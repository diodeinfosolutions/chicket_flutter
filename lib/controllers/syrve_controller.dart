import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:chicket/api/repositories/syrve_repository.dart';
import 'package:chicket/api/models/models.dart';
import 'package:chicket/services/kiosk_config_service.dart';
import 'package:chicket/services/menu_cache_service.dart';

import 'banner_controller.dart';

class SyrveController extends GetxController {
  final SyrveRepository _repository = SyrveRepository();
  final BannerController _bannerController = Get.find<BannerController>();
  late final KioskConfigService _configService;
  late final MenuCacheService _cacheService;

  final RxBool isInitializing = false.obs;
  final RxBool isLoadingMenu = false.obs;
  final RxBool isCreatingOrder = false.obs;

  final RxnString initError = RxnString();
  final RxnString menuError = RxnString();
  final RxnString orderError = RxnString();

  final Rx<MenuResponse?> menu = Rx<MenuResponse?>(null);
  final RxList<String> outOfStockProductIds = <String>[].obs;
  final RxList<OrderType> orderTypes = <OrderType>[].obs;
  final RxList<PaymentType> paymentTypes = <PaymentType>[].obs;
  final Rx<CreateDeliveryResponse?> lastOrderResponse =
      Rx<CreateDeliveryResponse?>(null);

  final RxBool _isDataLoaded = false.obs;
  bool get isDataLoaded => _isDataLoaded.value;

  String? get organizationId => _repository.organizationId;
  String? get terminalGroupId => _repository.terminalGroupId;

  List<MenuItemCategory> get menuCategories => menu.value?.itemCategories ?? [];

  List<MenuItem> get menuItems {
    final items = <MenuItem>[];
    for (final category in menuCategories) {
      if (category.items != null) {
        items.addAll(
          category.items!
              .where((item) => item.isHidden != true)
              .map((item) => getEnrichedMenuItem(item)),
        );
      }
    }
    return items;
  }

  List<MenuGroup> get menuGroups => menu.value?.groups ?? [];
  List<MenuProduct> get menuProducts => menu.value?.products ?? [];
  List<ProductCategory> get productCategories =>
      menu.value?.productCategories ?? [];

  @override
  void onInit() {
    super.onInit();
    _configService = Get.find<KioskConfigService>();
    _cacheService = Get.find<MenuCacheService>();
    _applyConfigIfAvailable();
  }

  void _applyConfigIfAvailable() {
    if (_configService.isConfigured) {
      final config = _configService.currentConfig;
      _repository.setOrganizationId(config.organizationId);
      _repository.setTerminalGroupId(config.terminalGroupId);
      _repository.setExternalMenuId(config.externalMenuId);
      if (kDebugMode) {
        debugPrint('Applied kiosk config: ${config.organizationName}');
      }
    }
  }

  Future<void> initialize({bool forceReload = false}) async {
    if (_isDataLoaded.value && !forceReload) {
      if (kDebugMode) {
        debugPrint('Data already loaded, skipping initialization');
      }
      return;
    }

    if (isInitializing.value) return;

    isInitializing.value = true;
    initError.value = null;

    try {
      _applyConfigIfAvailable();

      final result = await _repository.initializeStaticData();

      if (!result.isSuccess) {
        initError.value = result.error;
        if (kDebugMode) {
          debugPrint('Failed to initialize Syrve API: ${result.error}');
        }
        return;
      }

      orderTypes.value = _repository.cachedOrderTypes ?? [];
      paymentTypes.value = _repository.cachedPaymentTypes ?? [];

      if (kDebugMode) {
        debugPrint('Syrve API initialized successfully');
        debugPrint('Organization ID: $organizationId');
        debugPrint('Terminal Group ID: $terminalGroupId');
        debugPrint('Order Types: ${orderTypes.length}');
        debugPrint('Payment Types: ${paymentTypes.length}');
      }

      await Future.wait([loadMenu(), loadStopLists()]);

      if (organizationId != null) {
        await _bannerController.fetchBanners(
          organizationId: organizationId ?? '',
          terminalGroupId: terminalGroupId ?? '',
        );
      }

      _isDataLoaded.value = true;
    } catch (e) {
      initError.value = 'Initialization error: $e';
      if (kDebugMode) debugPrint('Syrve initialization error: $e');
    } finally {
      isInitializing.value = false;
    }
  }

  MenuResponse _filterDeliveryFee(MenuResponse menu) {
    final filteredCategories = menu.itemCategories?.where((category) {
      if (category.name?.toLowerCase() == 'delivery fee') return false;

      category.items?.removeWhere(
        (item) => item.name?.toLowerCase() == 'delivery fee',
      );
      return true;
    }).toList();

    return MenuResponse(
      correlationId: menu.correlationId,
      id: menu.id,
      name: menu.name,
      description: menu.description,
      itemCategories: filteredCategories,
      groups: menu.groups,
      productCategories: menu.productCategories,
      products: menu.products,
      sizes: menu.sizes,
      revision: menu.revision,
    );
  }

  Future<void> loadMenu({bool forceRefresh = false}) async {
    if (organizationId == null) {
      menuError.value = 'Organization ID not available';
      return;
    }

    if (kDebugMode) debugPrint('loadMenu called: forceRefresh=$forceRefresh');
    menuError.value = null;

    if (menu.value != null && menu.value!.itemCategories?.isNotEmpty == true) {
      if (kDebugMode) {
        debugPrint('Menu already in memory, refreshing in background only');
      }
      _refreshMenuInBackground();
      return;
    }

    if (!forceRefresh && _cacheService.hasCachedMenu) {
      final cachedMenu = _cacheService.getCachedMenu();
      if (cachedMenu != null && cachedMenu.itemCategories?.isNotEmpty == true) {
        final filteredMenu = _filterDeliveryFee(cachedMenu);
        if (filteredMenu.itemCategories?.isNotEmpty == true) {
          menu.value = filteredMenu;
          if (kDebugMode) {
            debugPrint(
              'Menu loaded from cache immediately - no loading state needed',
            );
          }

          _refreshMenuInBackground();
          return;
        }
      }
    }

    isLoadingMenu.value = true;

    try {
      if (kDebugMode) debugPrint('Fetching menu from API...');
      final result = await _repository.getMenu(organizationId: organizationId!);

      if (result.isSuccess && result.data != null) {
        final newMenu = result.data!;
        if (kDebugMode) debugPrint('API returned menu successfully');

        final filteredMenu = _filterDeliveryFee(newMenu);

        if (_cacheService.hasMenuChanged(filteredMenu)) {
          if (kDebugMode) debugPrint('Menu data changed, updating cache');
          await _cacheService.cacheMenu(filteredMenu);
        }

        menu.value = filteredMenu;
        final categories = filteredMenu.itemCategories ?? [];
        int totalItems = 0;
        int itemsWithImages = 0;
        for (final cat in categories) {
          for (final item in cat.items ?? []) {
            totalItems++;
            if (item.imageUrl != null) {
              itemsWithImages++;
            }
          }
        }
        if (kDebugMode) {
          debugPrint(
            'Menu loaded: $totalItems items in ${categories.length} categories ($itemsWithImages with images)',
          );
        }
        if (kDebugMode) debugPrint('About to set isLoadingMenu to false');
        if (menuProducts.isNotEmpty || menuGroups.isNotEmpty) {
          if (kDebugMode) {
            debugPrint(
              'Legacy format: ${menuProducts.length} products, ${menuGroups.length} groups',
            );
          }
        }
      } else {
        final cachedMenu = _cacheService.getCachedMenu();
        if (cachedMenu != null) {
          menu.value = _filterDeliveryFee(cachedMenu);
          if (kDebugMode) debugPrint('API failed, using cached menu');
        } else {
          menuError.value = result.error;
          if (kDebugMode) debugPrint('Failed to load menu: ${result.error}');
        }
      }
    } catch (e) {
      final cachedMenu = _cacheService.getCachedMenu();
      if (cachedMenu != null) {
        menu.value = _filterDeliveryFee(cachedMenu);
        if (kDebugMode) debugPrint('Error occurred, using cached menu: $e');
      } else {
        menuError.value = 'Error loading menu: $e';
        if (kDebugMode) debugPrint('Menu loading error: $e');
      }
    } finally {
      isLoadingMenu.value = false;
    }
  }

  Future<void> _refreshMenuInBackground() async {
    if (!_cacheService.shouldRefresh) {
      if (kDebugMode) debugPrint('Background refresh: Not needed yet');
      return;
    }
    if (organizationId == null) return;

    try {
      if (kDebugMode) {
        debugPrint('Background refresh: Fetching menu from API...');
      }
      final result = await _repository.getMenu(organizationId: organizationId!);
      if (result.isSuccess && result.data != null) {
        final newMenu = result.data!;
        final filteredMenu = _filterDeliveryFee(newMenu);

        if (menu.value != filteredMenu) {
          if (kDebugMode) {
            debugPrint(
              'Background refresh: Menu changed (hash: ${filteredMenu.contentHash}), updating',
            );
          }
          await _cacheService.cacheMenu(filteredMenu);
          menu.value = filteredMenu;
        } else {
          if (kDebugMode) {
            debugPrint('Background refresh: Menu unchanged, skipping update');
          }

          await _cacheService.cacheMenu(filteredMenu);
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Background menu refresh error: $e');
    }
  }

  Future<void> clearMenuCache() async {
    await _cacheService.clearCache();
    _isDataLoaded.value = false;
  }

  Future<void> loadStopLists() async {
    if (organizationId == null) return;

    try {
      final result = await _repository.getStopListProductIds(
        organizationIds: [organizationId!],
      );

      if (result.isSuccess && result.data != null) {
        outOfStockProductIds.value = result.data!;
        if (kDebugMode) {
          debugPrint(
            'Stop list loaded: ${outOfStockProductIds.length} items out of stock',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading stop lists: $e');
    }
  }

  bool isProductOutOfStock(String productId) {
    return outOfStockProductIds.contains(productId);
  }

  List<MenuProduct> getProductsByGroup(String groupId) {
    return menuProducts.where((p) => p.groupId == groupId).toList();
  }

  MenuProduct? getProductById(String productId) {
    try {
      return menuProducts.firstWhere((p) => p.id == productId);
    } catch (_) {
      return null;
    }
  }

  MenuItem? getMenuItemById(String itemId) {
    for (final category in menuCategories) {
      for (final item in category.items ?? []) {
        if (item.id == itemId) {
          return item;
        }
      }
    }
    return null;
  }

  MenuGroup? getGroupById(String groupId) {
    try {
      return menuGroups.firstWhere((g) => g.id == groupId);
    } catch (_) {
      return null;
    }
  }

  OrderType? getOrderTypeByServiceType(String serviceType) {
    try {
      return orderTypes.firstWhere((t) => t.orderServiceType == serviceType);
    } catch (_) {
      return null;
    }
  }

  PaymentType? getPaymentTypeByKind(String kind) {
    try {
      return paymentTypes.firstWhere((t) => t.paymentTypeKind == kind);
    } catch (_) {
      return null;
    }
  }

  Future<bool> createOrder({
    required List<OrderItem> items,
    String? orderTypeId,
    String? orderServiceType,
    String? phone,
    Customer? customer,
    List<OrderPayment>? payments,
    String? comment,
    Guests? guests,
  }) async {
    if (organizationId == null) {
      orderError.value = 'Organization ID not available';
      return false;
    }

    isCreatingOrder.value = true;
    orderError.value = null;

    try {
      String? finalOrderTypeId = orderTypeId;
      String? finalOrderServiceType = orderServiceType;

      if (finalOrderTypeId == null && finalOrderServiceType != null) {
        final orderType = getOrderTypeByServiceType(finalOrderServiceType);
        finalOrderTypeId = orderType?.id;
      }

      if (finalOrderTypeId == null && orderTypes.isNotEmpty) {
        if (finalOrderServiceType == null) {
          final commonOrderType = orderTypes.cast<OrderType?>().firstWhere(
            (t) => t?.orderServiceType == 'Common',
            orElse: () => orderTypes.first,
          );
          if (commonOrderType != null) {
            finalOrderTypeId = commonOrderType.id;

            finalOrderServiceType = null;
          }
        } else {
          final takeawayOrderType = getOrderTypeByServiceType(
            finalOrderServiceType,
          );
          finalOrderTypeId = takeawayOrderType?.id;
        }
      }

      if (finalOrderServiceType == 'Common') {
        finalOrderServiceType = null;
      }

      if (kDebugMode) {
        debugPrint(
          'Creating order: orderTypeId=$finalOrderTypeId, orderServiceType=$finalOrderServiceType',
        );
      }

      final order = DeliveryOrder(
        orderTypeId: finalOrderTypeId,
        orderServiceType: finalOrderServiceType,
        phone: phone,
        customer: customer,
        guests: guests ?? Guests(count: 1),
        items: items,
        payments: payments,
        comment: comment,
      );

      final result = await _repository.createDeliveryOrder(
        organizationId: organizationId!,
        terminalGroupId: terminalGroupId,
        order: order,
      );

      if (result.isSuccess && result.data != null) {
        lastOrderResponse.value = result.data;

        final creationStatus = result.data!.orderInfo?.creationStatus;
        if (creationStatus == 'Success' || creationStatus == 'InProgress') {
          if (kDebugMode) {
            debugPrint(
              'Order created successfully: ${result.data!.orderInfo?.id}',
            );
          }
          return true;
        } else {
          final errorMessage =
              result.data!.orderInfo?.errorInfo?.message ??
              'Unknown error creating order';
          orderError.value = errorMessage;
          if (kDebugMode) debugPrint('Order creation failed: $errorMessage');
          return false;
        }
      } else {
        orderError.value = result.error;
        if (kDebugMode) debugPrint('Failed to create order: ${result.error}');
        return false;
      }
    } catch (e) {
      orderError.value = 'Error creating order: $e';
      if (kDebugMode) debugPrint('Order creation error: $e');
      return false;
    } finally {
      isCreatingOrder.value = false;
    }
  }

  Future<OrderInfo?> getOrderStatus(String orderId) async {
    if (organizationId == null) return null;

    try {
      final result = await _repository.retrieveDeliveryById(
        organizationId: organizationId!,
        orderIds: [orderId],
      );

      if (result.isSuccess && result.data != null && result.data!.isNotEmpty) {
        return result.data!.first;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error getting order status: $e');
    }
    return null;
  }

  Future<void> refreshAll() async {
    _repository.clearCache();
    await initialize();
  }

  void clearLastOrder() {
    lastOrderResponse.value = null;
    orderError.value = null;
  }

  MenuItem getEnrichedMenuItem(MenuItem item) {
    if (item.modifierGroups?.isNotEmpty == true) {
      return item;
    }

    final product = getProductById(item.id);
    if (product == null || product.groupModifiers?.isEmpty == true) {
      return item;
    }

    final newModifierGroups = <MenuModifierGroup>[];

    for (final groupMod in product.groupModifiers!) {
      final childItems = <MenuModifierItem>[];

      if (groupMod.childModifiers != null) {
        for (final child in groupMod.childModifiers!) {
          final childProduct = getProductById(child.id);

          String? name;
          List<MenuItemPrice>? prices;
          String? description;
          String? buttonImageUrl;

          if (childProduct != null) {
            name = childProduct.name;
            description = childProduct.description;

            if (childProduct.sizePrices?.isNotEmpty == true) {
              final price = childProduct.sizePrices!.first.price?.currentPrice;
              if (price != null) {
                prices = [MenuItemPrice(price: price)];
              }
            }
          } else {
            final childMenuItem = getMenuItemById(child.id);
            if (childMenuItem != null) {
              name = childMenuItem.name;
              description = childMenuItem.description;
              buttonImageUrl = childMenuItem.buttonImageUrl;

              final price = childMenuItem.currentPrice;
              if (price != null) {
                prices = [MenuItemPrice(price: price)];
              }
            }
          }

          if (name != null) {
            childItems.add(
              MenuModifierItem(
                itemId: child.id,
                name: name,
                description: description,
                buttonImageUrl: buttonImageUrl,
                prices: prices,
                defaultAmount: child.defaultAmount,
                minAmount: child.minAmount,
                maxAmount: child.maxAmount,
                freeOfChargeAmount: child.freeOfChargeAmount,
                hideIfDefaultAmount: child.hideIfDefaultAmount,
              ),
            );
          }
        }
      }

      if (childItems.isNotEmpty) {
        final group = getGroupById(groupMod.id);

        newModifierGroups.add(
          MenuModifierGroup(
            id: groupMod.id,
            name: group?.name ?? 'Modifiers',
            minQuantity: groupMod.minAmount,
            maxQuantity: groupMod.maxAmount,
            required: groupMod.required,
            items: childItems,
            splittable: groupMod.splittable,
            childModifiersHaveMinMaxRestrictions:
                groupMod.childModifiersHaveMinMaxRestrictions,
          ),
        );
      }
    }

    if (newModifierGroups.isEmpty) {
      return item;
    }

    return MenuItem(
      sku: item.sku,
      itemId: item.itemId,
      name: item.name,
      description: item.description,
      buttonImageUrl: item.buttonImageUrl,
      itemSizes: item.itemSizes,
      modifierGroups: newModifierGroups,
      order: item.order,
      taxCategory: item.taxCategory,
      type: item.type,
      isHidden: item.isHidden,
    );
  }
}
