import 'package:get/get.dart';
import 'package:chicket/routes.dart';
import 'package:chicket/api/models/menu_models.dart' show MenuProduct;
import 'package:chicket/api/models/view_menu_models.dart';
import 'package:chicket/api/models/payment_models.dart';
import 'package:chicket/api/models/order_type_models.dart' as api;

enum OrderType { dineIn, takeaway }

/// Manages the customer's order state, cart, and product selections.
/// Handles order type selection, cart management (add/remove/qty),
/// and product modifier (addon) logic.
class OrderController extends GetxController {
  /// The high-level order type selected by the user (Dine In or Takeaway).
  final Rx<OrderType?> selectedType = Rx<OrderType?>(null);

  /// The list of items currently in the customer's cart.
  /// Each item is a map containing [productId], [name], [price], [qty], and [modifiers].
  final RxList<Map<String, dynamic>> cart = <Map<String, dynamic>>[].obs;

  /// The product currently being customized in a popup.
  final Rx<MenuProduct?> currentProduct = Rx<MenuProduct?>(null);

  /// The menu item currently being customized in a popup (for view-based menus).
  final Rx<ViewMenuItem?> currentMenuItem = Rx<ViewMenuItem?>(null);

  /// Currently selected modifier IDs, grouped by their category or group ID.
  final RxMap<String, Set<String>> selectedModifiers =
      <String, Set<String>>{}.obs;

  /// Detailed information about the selected modifiers (id, name, price).
  final RxMap<String, Map<String, dynamic>> modifierInfo =
      <String, Map<String, dynamic>>{}.obs;

  /// Quantity for the item currently being customized.
  final RxInt addonQuantity = 1.obs;

  double _basePrice = 0.0;

  /// The customer's phone number, if provided for the order.
  final RxString customerPhone = ''.obs;

  /// The payment method selected by the user.
  final Rx<PaymentType?> selectedPaymentType = Rx<PaymentType?>(null);

  /// The specific order type categorization required by the backend API.
  final Rx<api.OrderType?> selectedApiOrderType = Rx<api.OrderType?>(null);

  /// Selects the order type and navigates to the menu.
  void selectOrderType(OrderType type, {api.OrderType? apiType}) {
    selectedType.value = type;
    selectedApiOrderType.value = apiType;
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.offNamed(Routes.menu);
    });
  }

  /// Resets the entire order state to default values.
  void resetSelection() {
    selectedType.value = null;
    cart.clear();
    customerPhone.value = '';
    selectedPaymentType.value = null;
    selectedApiOrderType.value = null;
    resetAddonSelection();
  }

  /// Sets the customer's phone number.
  void setCustomerPhone(String phone) {
    customerPhone.value = phone;
  }

  /// Sets the selected payment method.
  void setPaymentType(PaymentType paymentType) {
    selectedPaymentType.value = paymentType;
  }

  /// Sets the API-specific order type.
  void setApiOrderType(api.OrderType orderType) {
    selectedApiOrderType.value = orderType;
  }

  /// Returns the service type identifier used by the backend based on selection.
  String? get orderServiceType {
    if (selectedApiOrderType.value != null) {
      return selectedApiOrderType.value!.orderServiceType;
    }
    switch (selectedType.value) {
      case OrderType.dineIn:
        return 'Common';
      case OrderType.takeaway:
        return 'DeliveryByClient';
      default:
        return null;
    }
  }

  /// Initializes the modifier selection state for a [MenuProduct].
  void initModifierSelection(MenuProduct product) {
    currentProduct.value = product;
    currentMenuItem.value = null;
    addonQuantity.value = 1;
    selectedModifiers.clear();
    modifierInfo.clear();
    _basePrice = (product.currentPrice ?? 0).toDouble();

    for (final groupMod in product.groupModifiers ?? []) {
      selectedModifiers[groupMod.id] = <String>{};
    }
  }

  /// Initializes the modifier selection state for a [ViewMenuItem].
  void initModifierSelectionForMenuItem(ViewMenuItem item) {
    currentProduct.value = null;
    currentMenuItem.value = item;
    addonQuantity.value = 1;
    selectedModifiers.clear();
    modifierInfo.clear();

    final defaultSize =
        item.itemSizes?.firstWhereOrNull((s) => s.isDefault == true) ??
        item.itemSizes?.firstOrNull;
    final priceString = defaultSize?.prices?.firstOrNull?.price ?? '0';
    _basePrice = double.tryParse(priceString) ?? 0.0;

    final List<ViewItemModifierGroup> allModifierGroups = [
      ...?item.itemSizes?.expand((size) => size.itemModifierGroups ?? []),
    ];

    for (final modGroup in allModifierGroups) {
      final groupId =
          (modGroup.itemGroupId != null && modGroup.itemGroupId!.isNotEmpty)
          ? modGroup.itemGroupId!
          : '${modGroup.name}_${modGroup.hashCode}';
      selectedModifiers[groupId] = <String>{};
    }
  }

  /// Resets only the current product customization state.
  void resetAddonSelection() {
    currentProduct.value = null;
    currentMenuItem.value = null;
    selectedModifiers.clear();
    modifierInfo.clear();
    addonQuantity.value = 1;
    _basePrice = 0.0;
  }

  /// Toggles a modifier selection, respecting maximum quantity limits for its group.
  void toggleModifier(
    String groupId,
    String modifierId,
    String name,
    double price,
    int maxAmount,
  ) {
    final current = selectedModifiers[groupId] ?? <String>{};

    if (current.contains(modifierId)) {
      current.remove(modifierId);
      modifierInfo.remove('$groupId:$modifierId');
    } else {
      if (maxAmount == 1) {
        for (final existingId in current.toList()) {
          modifierInfo.remove('$groupId:$existingId');
        }
        current.clear();
      } else if (current.length >= maxAmount) {
        return;
      }
      current.add(modifierId);
      modifierInfo['$groupId:$modifierId'] = {
        'id': modifierId,
        'name': name,
        'price': price,
      };
    }

    selectedModifiers[groupId] = current;
    selectedModifiers.refresh();
    modifierInfo.refresh();
  }

  /// Checks if a specific modifier is currently selected in a group.
  bool isModifierSelected(String groupId, String modifierId) {
    return selectedModifiers[groupId]?.contains(modifierId) ?? false;
  }

  /// Increments the quantity of the product being customized.
  void incrementAddonQuantity() {
    addonQuantity.value++;
  }

  /// Decrements the quantity of the product being customized.
  void decrementAddonQuantity() {
    if (addonQuantity.value > 1) {
      addonQuantity.value--;
    }
  }

  /// Returns the total price of the product currently being customized, inclusive of modifiers.
  double get addonTotalPrice {
    double total = _basePrice;

    for (final entry in modifierInfo.entries) {
      final info = entry.value;
      total += (info['price'] as double?) ?? 0.0;
    }

    return total * addonQuantity.value;
  }

  /// Validates if the current selection meets all mandatory modifier requirements.
  bool get canAddToCart {
    final product = currentProduct.value;
    final menuItem = currentMenuItem.value;

    if (product == null && menuItem == null) return false;

    final List<ViewItemModifierGroup> allModifierGroups = [];
    if (menuItem != null) {
      if (menuItem.itemSizes != null) {
        for (final size in menuItem.itemSizes!) {
          if (size.itemModifierGroups != null) {
            allModifierGroups.addAll(size.itemModifierGroups!);
          }
        }
      }
    }

    if (allModifierGroups.isNotEmpty) {
      for (final modGroup in allModifierGroups) {
        final groupId =
            (modGroup.itemGroupId != null && modGroup.itemGroupId!.isNotEmpty)
            ? modGroup.itemGroupId!
            : '${modGroup.name}_${modGroup.hashCode}';
        final selected = selectedModifiers[groupId] ?? <String>{};
        final minQuantity = modGroup.restrictions?.minQuantity ?? 0;
        final maxQuantity = modGroup.restrictions?.maxQuantity ?? 9999;
        final requiredMin = minQuantity > 0 ? minQuantity : 0;

        if (requiredMin > 0 && selected.length < requiredMin) {
          return false;
        }
        if (selected.length > maxQuantity) {
          return false;
        }
      }
    }

    if (product != null) {
      for (final groupMod in product.groupModifiers ?? []) {
        final selected = selectedModifiers[groupMod.id] ?? <String>{};
        final minAmount = groupMod.minAmount ?? 0;
        final maxAmount = groupMod.maxAmount ?? 9999;
        final requiredMin = (groupMod.required ?? false)
            ? (minAmount > 0 ? minAmount : 1)
            : minAmount;
        if (selected.length < requiredMin) {
          return false;
        }
        if (selected.length > maxAmount) {
          return false;
        }
      }
    }

    return true;
  }

  /// Finalizes the customization and adds the product to the cart.
  void addCurrentProductToCart() {
    final product = currentProduct.value;
    final menuItem = currentMenuItem.value;

    if (product == null && menuItem == null) return;
    if (!canAddToCart) return;

    final Map<String, List<Map<String, dynamic>>> modifiersMap = {};

    for (final entry in selectedModifiers.entries) {
      final groupId = entry.key;
      final selectedIds = entry.value;

      if (selectedIds.isNotEmpty) {
        final mods = <Map<String, dynamic>>[];
        for (final modId in selectedIds) {
          final info = modifierInfo['$groupId:$modId'];
          if (info != null) {
            mods.add(Map<String, dynamic>.from(info));
          }
        }
        if (mods.isNotEmpty) {
          modifiersMap[groupId] = mods;
        }
      }
    }

    final productId = product?.id ?? menuItem?.itemId ?? menuItem?.sku ?? '';
    final productName = product?.name ?? menuItem?.name ?? '';

    addToCart(
      productId: productId,
      name: productName,
      price: _basePrice,
      modifiers: modifiersMap,
      qty: addonQuantity.value,
    );

    resetAddonSelection();
    Get.back();
  }

  /// Adds an item to the cart, merging quantities if an identical item exists.
  void addToCart({
    required String productId,
    required String name,
    required double price,
    Map<String, List<Map<String, dynamic>>>? modifiers,
    int qty = 1,
  }) {
    final mods = modifiers ?? <String, List<Map<String, dynamic>>>{};
    final index = cart.indexWhere(
      (e) =>
          e['productId'] == productId && _sameModifiers(e['modifiers'], mods),
    );

    if (index != -1) {
      cart[index]['qty'] += qty;
      cart.refresh();
    } else {
      cart.add({
        'productId': productId,
        'name': name,
        'price': price,
        'qty': qty,
        'modifiers': mods,
      });
    }
  }

  /// Increases the quantity of a specific cart item by index.
  void increaseQty(int index) {
    cart[index]['qty']++;
    cart.refresh();
  }

  /// Decreases the quantity of a specific cart item, removing it if qty reaches 0.
  void decreaseQty(int index) {
    if (cart[index]['qty'] > 1) {
      cart[index]['qty']--;
    } else {
      cart.removeAt(index);
    }
    cart.refresh();
    if (cart.isEmpty) {
      Get.offNamed(Routes.menu);
    }
  }

  /// Removes an item from the cart by index.
  void removeItem(int index) {
    cart.removeAt(index);
    cart.refresh();
    if (cart.isEmpty) {
      Get.offNamed(Routes.menu);
    }
  }

  /// Clears all items from the cart.
  void clearCart() {
    cart.clear();
  }

  /// Returns the total number of items in the cart.
  int get cartItemCount {
    int count = 0;
    for (final item in cart) {
      count += item['qty'] as int;
    }
    return count;
  }

  /// Returns the total quantity of a specific product ID in the cart.
  int getProductQuantity(String productId) {
    int qty = 0;
    for (final item in cart) {
      if (item['productId'] == productId) {
        qty += item['qty'] as int;
      }
    }
    return qty;
  }

  /// Returns the total value of the cart, including all item modifiers.
  double get cartTotal {
    double total = 0;
    for (final item in cart) {
      final base = (item['price'] as double) * (item['qty'] as int);
      double modifiersTotal = 0;

      final modifiers =
          item['modifiers'] as Map<String, List<Map<String, dynamic>>>?;
      if (modifiers != null) {
        for (final group in modifiers.values) {
          for (final mod in group) {
            modifiersTotal += (mod['price'] as double?) ?? 0.0;
          }
        }
      }

      total += base + (modifiersTotal * (item['qty'] as int));
    }
    return total;
  }

  /// Deep comparison to check if two modifier maps are identical.
  bool _sameModifiers(dynamic aRaw, Map<String, List<Map<String, dynamic>>> b) {
    final a = <String, List<Map<String, dynamic>>>{};
    if (aRaw is Map) {
      for (final entry in aRaw.entries) {
        if (entry.value is List) {
          a[entry.key.toString()] = (entry.value as List)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        }
      }
    }

    if (a.length != b.length) return false;

    for (final key in a.keys) {
      if (!b.containsKey(key)) return false;
      final aIds = a[key]!.map((e) => e['id']).toSet();
      final bIds = b[key]!.map((e) => e['id']).toSet();
      if (!aIds.containsAll(bIds) || !bIds.containsAll(aIds)) {
        return false;
      }
    }

    for (final key in b.keys) {
      if (!a.containsKey(key)) return false;
    }

    return true;
  }
}
