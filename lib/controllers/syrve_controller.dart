import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:chicket/api/repositories/syrve_repository.dart';
import 'package:chicket/api/models/models.dart';
// import 'package:chicket/api/models/view_menu_models.dart';
import 'package:chicket/services/kiosk_config_service.dart';
import 'package:chicket/services/menu_cache_service.dart';

import 'package:chicket/api/repositories/api_repository.dart';
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

  final Rx<ViewMenuData?> menu = Rx<ViewMenuData?>(null);
  final RxList<String> outOfStockProductIds = <String>[].obs;
  final RxList<OrderType> orderTypes = <OrderType>[].obs;
  final RxList<PaymentType> paymentTypes = <PaymentType>[].obs;
  final Rx<CreateDeliveryResponse?> lastOrderResponse =
      Rx<CreateDeliveryResponse?>(null);

  final RxBool _isDataLoaded = false.obs;
  bool get isDataLoaded => _isDataLoaded.value;

  String? get organizationId => _repository.organizationId;
  String? get terminalGroupId => _repository.terminalGroupId;

  List<ViewItemCategory> get menuCategories => menu.value?.itemCategories ?? [];

  List<ViewMenuItem> get menuItems {
    final items = <ViewMenuItem>[];
    for (final category in menuCategories) {
      if (category.items != null) {
        items.addAll(category.items!.where((item) => item.isHidden != true));
      }
    }
    return items;
  }

  List<ViewProductCategory> get productCategories =>
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

  ViewMenuData _filterDeliveryFee(ViewMenuData menu) {
    final filteredCategories = menu.itemCategories?.where((category) {
      if (category.name?.toLowerCase() == 'delivery fee') return false;

      // Keep items that are NOT delivery fee
      final validItems = category.items
          ?.where((item) => item.name?.toLowerCase() != 'delivery fee')
          .toList();

      return validItems != null && validItems.isNotEmpty;
    }).toList();

    return ViewMenuData(
      id: menu.id,
      name: menu.name,
      nameAr: menu.nameAr,
      description: menu.description,
      descriptionAr: menu.descriptionAr,
      revision: menu.revision,
      productCategories: menu.productCategories,
      itemCategories: filteredCategories,
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
      final result = await Get.find<ApiRepository>().viewMenu(
        menuId: _configService.currentConfig.externalMenuId,
      );

      if (result.status == true && result.data != null) {
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
      } else {
        final cachedMenu = _cacheService.getCachedMenu();
        if (cachedMenu != null) {
          menu.value = _filterDeliveryFee(cachedMenu);
          if (kDebugMode) debugPrint('API failed, using cached menu');
        } else {
          menuError.value = result.message;
          if (kDebugMode) debugPrint('Failed to load menu: ${result.message}');
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

      // Call the store-or-update-menu api concurrently with viewMenu
      final results = await Future.wait([
        Get.find<ApiRepository>().storeOrUpdateMenu(),
        Get.find<ApiRepository>().viewMenu(
          menuId: _configService.currentConfig.externalMenuId,
        ),
      ]);

      final result = results[1] as ViewMenuResponse;
      if (result.status == true && result.data != null) {
        final newMenu = result.data!;
        final filteredMenu = _filterDeliveryFee(newMenu);

        if (menu.value != filteredMenu) {
          if (kDebugMode) {
            debugPrint(
              'Background refresh: Menu changed (revision: ${filteredMenu.revision}), updating',
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

  ViewMenuItem? getMenuItemById(String itemId) {
    for (final category in menuCategories) {
      for (final item in category.items ?? []) {
        if (item.itemId == itemId || item.sku == itemId) {
          return item;
        }
      }
    }
    return null;
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
}
