import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:chicket/api/repositories/syrve_repository.dart';
import 'package:chicket/api/models/models.dart';
import 'package:chicket/services/kiosk_config_service.dart';
import 'package:chicket/services/menu_cache_service.dart';

class SyrveController extends GetxController {
  final SyrveRepository _repository = SyrveRepository();
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
        items.addAll(category.items!.where((item) => item.isHidden != true));
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
      debugPrint('Applied kiosk config: ${config.organizationName}');
    }
  }

  Future<void> initialize({bool forceReload = false}) async {
    if (_isDataLoaded.value && !forceReload) {
      debugPrint('Data already loaded, skipping initialization');
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
        debugPrint('Failed to initialize Syrve API: ${result.error}');
        return;
      }

      orderTypes.value = _repository.cachedOrderTypes ?? [];
      paymentTypes.value = _repository.cachedPaymentTypes ?? [];

      debugPrint('Syrve API initialized successfully');
      debugPrint('Organization ID: $organizationId');
      debugPrint('Terminal Group ID: $terminalGroupId');
      debugPrint('Order Types: ${orderTypes.length}');
      debugPrint('Payment Types: ${paymentTypes.length}');

      await loadMenu();
      await loadStopLists();

      _isDataLoaded.value = true;
    } catch (e) {
      initError.value = 'Initialization error: $e';
      debugPrint('Syrve initialization error: $e');
    } finally {
      isInitializing.value = false;
    }
  }

  Future<void> loadMenu({bool forceRefresh = false}) async {
    if (organizationId == null) {
      menuError.value = 'Organization ID not available';
      return;
    }

    debugPrint('loadMenu called: forceRefresh=$forceRefresh');
    menuError.value = null;

    // First: Check if we already have menu data in memory - never show shimmer
    if (menu.value != null && menu.value!.itemCategories?.isNotEmpty == true) {
      debugPrint('Menu already in memory, refreshing in background only');
      _refreshMenuInBackground();
      return;
    }

    // Second: Check cache before showing any loading state
    if (!forceRefresh && _cacheService.hasCachedMenu) {
      final cachedMenu = _cacheService.getCachedMenu();
      if (cachedMenu != null && cachedMenu.itemCategories?.isNotEmpty == true) {
        menu.value = cachedMenu;
        debugPrint(
          'Menu loaded from cache immediately - no loading state needed',
        );

        _refreshMenuInBackground();
        return;
      }
    }

    // Only show shimmer when we have no data at all
    isLoadingMenu.value = true;

    try {
      debugPrint('Fetching menu from API...');
      final result = await _repository.getMenu(organizationId: organizationId!);

      if (result.isSuccess && result.data != null) {
        final newMenu = result.data!;
        debugPrint('API returned menu successfully');

        if (_cacheService.hasMenuChanged(newMenu)) {
          debugPrint('Menu data changed, updating cache');
          await _cacheService.cacheMenu(newMenu);
        }

        menu.value = newMenu;
        final categories = newMenu.itemCategories ?? [];
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
        debugPrint(
          'Menu loaded: $totalItems items in ${categories.length} categories ($itemsWithImages with images)',
        );
        debugPrint('About to set isLoadingMenu to false');
        if (menuProducts.isNotEmpty || menuGroups.isNotEmpty) {
          debugPrint(
            'Legacy format: ${menuProducts.length} products, ${menuGroups.length} groups',
          );
        }
      } else {
        final cachedMenu = _cacheService.getCachedMenu();
        if (cachedMenu != null) {
          menu.value = cachedMenu;
          debugPrint('API failed, using cached menu');
        } else {
          menuError.value = result.error;
          debugPrint('Failed to load menu: ${result.error}');
        }
      }
    } catch (e) {
      final cachedMenu = _cacheService.getCachedMenu();
      if (cachedMenu != null) {
        menu.value = cachedMenu;
        debugPrint('Error occurred, using cached menu: $e');
      } else {
        menuError.value = 'Error loading menu: $e';
        debugPrint('Menu loading error: $e');
      }
    } finally {
      isLoadingMenu.value = false;
    }
  }

  Future<void> _refreshMenuInBackground() async {
    if (!_cacheService.shouldRefresh) {
      debugPrint('Background refresh: Not needed yet');
      return;
    }
    if (organizationId == null) return;

    try {
      debugPrint('Background refresh: Fetching menu from API...');
      final result = await _repository.getMenu(organizationId: organizationId!);
      if (result.isSuccess && result.data != null) {
        final newMenu = result.data!;
        // Use strict equality check
        if (menu.value != newMenu) {
          debugPrint('Background refresh: Menu changed (hash: ${newMenu.contentHash}), updating');
          await _cacheService.cacheMenu(newMenu);
          menu.value = newMenu;
        } else {
          debugPrint('Background refresh: Menu unchanged, skipping update');
          // Still update cache timestamp to prevent repeated checks
          await _cacheService.cacheMenu(newMenu);
        }
      }
    } catch (e) {
      debugPrint('Background menu refresh error: $e');
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
        debugPrint(
          'Stop list loaded: ${outOfStockProductIds.length} items out of stock',
        );
      }
    } catch (e) {
      debugPrint('Error loading stop lists: $e');
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
            // DON'T set orderServiceType to "Common" - the API doesn't accept it
            // For dine-in/Common orders, orderServiceType should remain null
            finalOrderServiceType = null;
          }
        } else {
          final takeawayOrderType = getOrderTypeByServiceType(
            finalOrderServiceType,
          );
          finalOrderTypeId = takeawayOrderType?.id;
        }
      }
      
      // Ensure orderServiceType is only set to valid API values
      // Valid values: DeliveryByCourier, DeliveryByClient
      // "Common" is NOT valid for the deliveries API - use null instead
      if (finalOrderServiceType == 'Common') {
        finalOrderServiceType = null;
      }

      debugPrint(
        'Creating order: orderTypeId=$finalOrderTypeId, orderServiceType=$finalOrderServiceType',
      );

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
          debugPrint(
            'Order created successfully: ${result.data!.orderInfo?.id}',
          );
          return true;
        } else {
          final errorMessage =
              result.data!.orderInfo?.errorInfo?.message ??
              'Unknown error creating order';
          orderError.value = errorMessage;
          debugPrint('Order creation failed: $errorMessage');
          return false;
        }
      } else {
        orderError.value = result.error;
        debugPrint('Failed to create order: ${result.error}');
        return false;
      }
    } catch (e) {
      orderError.value = 'Error creating order: $e';
      debugPrint('Order creation error: $e');
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
      debugPrint('Error getting order status: $e');
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
