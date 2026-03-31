import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:chicket/api/repositories/syrve_repository.dart';
import 'package:chicket/api/models/models.dart';
// import 'package:chicket/api/models/view_menu_models.dart';
import 'package:chicket/services/kiosk_config_service.dart';
import 'package:chicket/services/menu_cache_service.dart';

import 'package:chicket/api/repositories/api_repository.dart';
import 'banner_controller.dart';
import '../utils/log_local.dart';

/// Main controller for interacting with the Syrve (iiko) API.
/// Handles menu loading, stop lists, order types, payment methods,
/// and order creation/status tracking.
class SyrveController extends GetxController {
  final SyrveRepository _repository = SyrveRepository();
  final BannerController _bannerController = Get.find<BannerController>();
  late final KioskConfigService _configService;
  late final MenuCacheService _cacheService;

  /// Loading status for initial setup (order types, payment types).
  final RxBool isInitializing = false.obs;

  /// Loading status for the menu data.
  final RxBool isLoadingMenu = false.obs;

  /// Status of an active order creation request.
  final RxBool isCreatingOrder = false.obs;

  /// Error message from the initialization phase.
  final RxnString initError = RxnString();

  /// Error message from the menu loading phase.
  final RxnString menuError = RxnString();

  /// Error message from the order creation phase.
  final RxnString orderError = RxnString();

  /// The currently loaded menu data.
  final Rx<ViewMenuData?> menu = Rx<ViewMenuData?>(null);

  /// List of product IDs that are currently out of stock.
  final RxList<String> outOfStockProductIds = <String>[].obs;

  /// Available order types (Delivery, Pickup, etc.) from Syrve.
  final RxList<OrderType> orderTypes = <OrderType>[].obs;

  /// Available payment methods configured in Syrve.
  final RxList<PaymentType> paymentTypes = <PaymentType>[].obs;

  /// Result of the most recently created order.
  final Rx<CreateDeliveryResponse?> lastOrderResponse =
      Rx<CreateDeliveryResponse?>(null);

  final RxBool _isDataLoaded = false.obs;

  /// Returns [true] if the initial data (menu, types) has been loaded.
  bool get isDataLoaded => _isDataLoaded.value;

  Timer? _refreshTimer;

  /// Returns the current organization ID configured in the repository.
  String? get organizationId => _repository.organizationId;

  /// Returns the current terminal group ID configured in the repository.
  String? get terminalGroupId => _repository.terminalGroupId;

  /// Returns the flattened list of menu categories.
  List<ViewItemCategory> get menuCategories => menu.value?.itemCategories ?? [];

  /// Returns all menu items filtered to exclude hidden items.
  List<ViewMenuItem> get menuItems {
    final items = <ViewMenuItem>[];
    for (final category in menuCategories) {
      if (category.items != null) {
        items.addAll(category.items!.where((item) => item.isHidden != true));
      }
    }
    return items;
  }

  /// Returns categories used for product grouping (e.g., sizes, flavors).
  List<ViewProductCategory> get productCategories =>
      menu.value?.productCategories ?? [];

  @override
  void onInit() {
    super.onInit();
    _configService = Get.find<KioskConfigService>();
    _cacheService = Get.find<MenuCacheService>();
    _applyConfigIfAvailable();
  }

  /// Configures the repository with organization and terminal details from local storage.
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

  /// Powers on the controller by loading initial static data and starting background refreshes.
  ///
  /// [forceReload] bypasses the internal "is loaded" check.
  Future<void> initialize({
    bool forceReload = false,
    bool forceStore = false,
  }) async {
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
      }

      await Future.wait([
        loadMenu(forceRefresh: forceReload, forceStore: forceStore),
        loadStopLists(),
      ]);

      if (organizationId != null) {
        await _bannerController.fetchBanners(
          organizationId: organizationId ?? '',
          terminalGroupId: terminalGroupId ?? '',
        );
      }

      _isDataLoaded.value = true;
      refreshMenuInBackground(forceBypassCacheWait: true);
      _startPeriodicRefreshTimer();
    } catch (e) {
      initError.value = 'Initialization error: $e';
      if (kDebugMode) debugPrint('Syrve initialization error: $e');
      logLocal('Syrve initialize error: $e');
    } finally {
      isInitializing.value = false;
    }
  }

  /// Filters out "Delivery Fee" items from the menu categories.
  ViewMenuData _filterDeliveryFee(ViewMenuData menu) {
    final filteredCategories = menu.itemCategories?.where((category) {
      if (category.name?.toLowerCase() == 'delivery fee') return false;

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

  /// Loads the menu from cache or API.
  ///
  /// Uses a "Cache-First" approach: displays cached data immediately if available,
  /// then triggers a background refresh from the API.
  Future<void> loadMenu({
    bool forceRefresh = false,
    bool forceStore = false,
  }) async {
    if (organizationId == null) {
      menuError.value = 'Organization ID not available';
      return;
    }

    if (kDebugMode) {
      debugPrint(
        'loadMenu called: forceRefresh=$forceRefresh forceStore=$forceStore',
      );
    }
    menuError.value = null;

    if (!forceStore &&
        !forceRefresh &&
        menu.value != null &&
        menu.value!.itemCategories?.isNotEmpty == true) {
      refreshMenuInBackground();
      return;
    }

    if (!forceStore && !forceRefresh && _cacheService.hasCachedMenu) {
      final cachedMenu = _cacheService.getCachedMenu();
      if (cachedMenu != null && cachedMenu.itemCategories?.isNotEmpty == true) {
        final filteredMenu = _filterDeliveryFee(cachedMenu);
        if (filteredMenu.itemCategories?.isNotEmpty == true) {
          menu.value = filteredMenu;
          refreshMenuInBackground();
          return;
        }
      }
    }

    isLoadingMenu.value = true;

    try {
      if (forceStore) {
        await Get.find<ApiRepository>().storeOrUpdateMenu(
          externalMenuId: _configService.currentConfig.externalMenuId,
          organizationId: _configService.currentConfig.organizationId,
        );
      }

      final result = await Get.find<ApiRepository>().viewMenu(
        menuId: _configService.currentConfig.externalMenuId,
      );

      if (result.status == true && result.data != null) {
        final newMenu = result.data!;
        final filteredMenu = _filterDeliveryFee(newMenu);

        if (_cacheService.hasMenuChanged(filteredMenu)) {
          await _cacheService.cacheMenu(filteredMenu);
        }

        menu.value = filteredMenu;

        // Refresh banners when menu is successfully loaded from API
        unawaited(_bannerController.fetchBanners(
          organizationId: organizationId!,
          terminalGroupId: terminalGroupId!,
        ));
      } else {
        final cachedMenu = _cacheService.getCachedMenu();
        if (cachedMenu != null) {
          menu.value = _filterDeliveryFee(cachedMenu);
        } else {
          menuError.value = result.message;
        }
      }
    } catch (e) {
      final cachedMenu = _cacheService.getCachedMenu();
      if (cachedMenu != null) {
        menu.value = _filterDeliveryFee(cachedMenu);
      } else {
        menuError.value = 'Error loading menu: $e';
        logLocal('loadMenu error: $e');
      }
    } finally {
      isLoadingMenu.value = false;
    }
  }

  /// Sets up an automated timer to refresh the menu every 15 minutes.
  void _startPeriodicRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 15), (_) {
      refreshMenuInBackground(forceBypassCacheWait: true);
    });
  }

  /// Performs a silent background refresh of the menu data.
  ///
  /// Checks if the menu revision has changed before updating the UI and cache.
  Future<void> refreshMenuInBackground({
    bool forceBypassCacheWait = false,
  }) async {
    if (!forceBypassCacheWait && !_cacheService.shouldRefresh) return;
    if (organizationId == null) return;

    try {
      await Get.find<ApiRepository>().storeOrUpdateMenu(
        externalMenuId: _configService.currentConfig.externalMenuId,
        organizationId: _configService.currentConfig.organizationId,
      );

      final result = await Get.find<ApiRepository>().viewMenu(
        menuId: _configService.currentConfig.externalMenuId,
      );
      if (result.status == true && result.data != null) {
        final newMenu = result.data!;
        final filteredMenu = _filterDeliveryFee(newMenu);

        if (menu.value != filteredMenu) {
          await _cacheService.cacheMenu(filteredMenu);
          menu.value = filteredMenu;
        } else {
          await _cacheService.cacheMenu(filteredMenu);
        }

        // Refresh banners when menu is refreshed in background
        unawaited(_bannerController.fetchBanners(
          organizationId: organizationId!,
          terminalGroupId: terminalGroupId!,
        ));
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Background menu refresh error: $e');
      logLocal('refreshMenuInBackground error: $e');
    }
  }

  /// Clears the local menu cache and resets initialization state.
  Future<void> clearMenuCache() async {
    await _cacheService.clearCache();
    _isDataLoaded.value = false;
  }

  /// Fetches the list of products that are currently unavailable in the POS.
  Future<void> loadStopLists() async {
    if (organizationId == null) return;

    try {
      final result = await _repository.getStopListProductIds(
        organizationIds: [organizationId!],
      );

      if (result.isSuccess && result.data != null) {
        outOfStockProductIds.value = result.data!;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error loading stop lists: $e');
      logLocal('loadStopLists error: $e');
    }
  }

  /// Checks if a product is in the stop list.
  bool isProductOutOfStock(String productId) {
    return outOfStockProductIds.contains(productId);
  }

  /// Finds a menu item by its unique ID or SKU.
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

  /// Resolves a Syrve [OrderType] by its service type string (e.g., 'Common', 'DeliveryByClient').
  OrderType? getOrderTypeByServiceType(String serviceType) {
    try {
      return orderTypes.firstWhere((t) => t.orderServiceType == serviceType);
    } catch (_) {
      return null;
    }
  }

  /// Resolves a Syrve [OrderType] by its name (e.g., 'KIOSK DINE IN').
  OrderType? getOrderTypeByName(String name) {
    try {
      return orderTypes.firstWhere(
        (t) => t.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Resolves a Syrve [PaymentType] by its category/kind.
  PaymentType? getPaymentTypeByKind(String kind) {
    try {
      return paymentTypes.firstWhere((t) => t.paymentTypeKind == kind);
    } catch (_) {
      return null;
    }
  }

  /// Resolves a Syrve [PaymentType] by its name (e.g., 'KIOSK ONLINE').
  PaymentType? getPaymentTypeByName(String name) {
    try {
      return paymentTypes.firstWhere(
        (t) => t.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Creates a final delivery order in the Syrve system.
  ///
  /// Resolves order type mapping and handles order creation status.
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

      // 1. Resolve orderTypeId from orderServiceType if missing
      if (finalOrderTypeId == null && finalOrderServiceType != null) {
        final orderType = getOrderTypeByServiceType(finalOrderServiceType);
        finalOrderTypeId = orderType?.id;
      }

      // 2. Fallback to 'Common' or first available if still null
      if (finalOrderTypeId == null && orderTypes.isNotEmpty) {
        final commonOrderType =
            orderTypes.firstWhereOrNull(
              (t) => t.orderServiceType == 'Common',
            ) ??
            orderTypes.first;

        finalOrderTypeId = commonOrderType.id;
        // If we fell back to Common, ensure service type matches for consistency
        finalOrderServiceType ??= commonOrderType.orderServiceType;
      }

      // 3. Normalize: Syrve API often expects null for 'Common' service type
      // And documentation says only one of orderTypeId or orderServiceType should be defined.
      if (finalOrderTypeId != null) {
        finalOrderServiceType = null;
      } else if (finalOrderServiceType == 'Common') {
        finalOrderServiceType = null;
      } else if (finalOrderServiceType == 'DeliveryPickUp') {
        finalOrderServiceType = 'DeliveryByClient';
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
          return true;
        } else {
          final errorMessage =
              result.data!.orderInfo?.errorInfo?.message ??
              'Unknown error creating order';
          orderError.value = errorMessage;
          return false;
        }
      } else {
        orderError.value = result.error;
        return false;
      }
    } catch (e) {
      orderError.value = 'Error creating order: $e';
      logLocal('createOrder error: $e');
      return false;
    } finally {
      isCreatingOrder.value = false;
    }
  }

  /// Retrieves the current status of an order from Syrve by Its ID.
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
      logLocal('getOrderStatus error: $e');
    }
    return null;
  }

  /// Clears repository cache and re-initializes all data.
  Future<void> refreshAll() async {
    _repository.clearCache();
    await initialize();
  }

  /// Clears the results of the last successful order.
  void clearLastOrder() {
    lastOrderResponse.value = null;
    orderError.value = null;
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }
}
