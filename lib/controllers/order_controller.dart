import 'package:get/get.dart';
import 'package:chicket/routes.dart';
import 'package:chicket/api/models/menu_models.dart';
import 'package:chicket/api/models/payment_models.dart';
import 'package:chicket/api/models/order_type_models.dart' as api;

enum OrderType { dineIn, takeaway }

class OrderController extends GetxController {
  final Rx<OrderType?> selectedType = Rx<OrderType?>(null);

  final RxList<Map<String, dynamic>> cart = <Map<String, dynamic>>[].obs;

  final Rx<MenuProduct?> currentProduct = Rx<MenuProduct?>(null);
  final Rx<MenuItem?> currentMenuItem = Rx<MenuItem?>(null);
  final RxMap<String, Set<String>> selectedModifiers =
      <String, Set<String>>{}.obs;
  final RxMap<String, Map<String, dynamic>> modifierInfo =
      <String, Map<String, dynamic>>{}.obs;
  final RxInt addonQuantity = 1.obs;
  double _basePrice = 0.0;

  // Order flow data
  final RxString customerPhone = ''.obs;
  final Rx<PaymentType?> selectedPaymentType = Rx<PaymentType?>(null);
  final Rx<api.OrderType?> selectedApiOrderType = Rx<api.OrderType?>(null);

  void selectOrderType(OrderType type) {
    selectedType.value = type;
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.offNamed(Routes.menu);
    });
  }

  void resetSelection() {
    selectedType.value = null;
    cart.clear();
    customerPhone.value = '';
    selectedPaymentType.value = null;
    selectedApiOrderType.value = null;
    resetAddonSelection();
  }

  // Set customer phone number (from MOB screen)
  void setCustomerPhone(String phone) {
    customerPhone.value = phone;
  }

  // Set selected payment type (from Select Payment screen)
  void setPaymentType(PaymentType paymentType) {
    selectedPaymentType.value = paymentType;
  }

  // Set API order type based on local order type selection
  void setApiOrderType(api.OrderType orderType) {
    selectedApiOrderType.value = orderType;
  }

  // Get the orderServiceType for API based on local selection
  // Valid Syrve API values: DeliveryByClient, DeliveryByCourier, DeliveryPickUp
  // For dine-in (restaurant orders), orderServiceType should be null
  String? get orderServiceType {
    switch (selectedType.value) {
      case OrderType.dineIn:
        return null; // Restaurant/dine-in orders don't use orderServiceType
      case OrderType.takeaway:
        return 'DeliveryByClient'; // Self-pickup/takeaway
      default:
        return null;
    }
  }

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

  void initModifierSelectionForMenuItem(MenuItem item) {
    currentProduct.value = null;
    currentMenuItem.value = item;
    addonQuantity.value = 1;
    selectedModifiers.clear();
    modifierInfo.clear();
    _basePrice = (item.currentPrice ?? 0).toDouble();

    for (final modGroup in item.modifierGroups ?? []) {
      if (modGroup.id != null) {
        selectedModifiers[modGroup.id!] = <String>{};
      }
    }
  }

  void resetAddonSelection() {
    currentProduct.value = null;
    currentMenuItem.value = null;
    selectedModifiers.clear();
    modifierInfo.clear();
    addonQuantity.value = 1;
    _basePrice = 0.0;
  }

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
        // Only one selectable in this group, clear others in this group only
        for (final existingId in current.toList()) {
          modifierInfo.remove('$groupId:$existingId');
        }
        current.clear();
      } else if (current.length >= maxAmount) {
        // Do not allow more than maxAmount in this group
        return;
      }
      current.add(modifierId);
      modifierInfo['$groupId:$modifierId'] = {
        'id': modifierId,
        'name': name,
        'price': price,
      };
    }

    // Only update this group, not others
    selectedModifiers[groupId] = current;
    selectedModifiers.refresh();
    modifierInfo.refresh();
  }

  bool isModifierSelected(String groupId, String modifierId) {
    return selectedModifiers[groupId]?.contains(modifierId) ?? false;
  }

  void incrementAddonQuantity() {
    addonQuantity.value++;
  }

  void decrementAddonQuantity() {
    if (addonQuantity.value > 1) {
      addonQuantity.value--;
    }
  }

  double get addonTotalPrice {
    double total = _basePrice;

    for (final entry in modifierInfo.entries) {
      final info = entry.value;
      total += (info['price'] as double?) ?? 0.0;
    }

    return total * addonQuantity.value;
  }

  bool get canAddToCart {
    final product = currentProduct.value;
    final menuItem = currentMenuItem.value;

    if (product == null && menuItem == null) return false;

    // Collect all relevant modifier groups for menuItem (including all itemSizes)
    final List<MenuModifierGroup> allModifierGroups = [];
    if (menuItem != null) {
      if (menuItem.modifierGroups != null) {
        allModifierGroups.addAll(menuItem.modifierGroups!);
      }
      if (menuItem.itemSizes != null) {
        for (final size in menuItem.itemSizes!) {
          if (size.itemModifierGroups != null) {
            allModifierGroups.addAll(size.itemModifierGroups!);
          }
        }
      }
    }

    // If there are modifier groups, enforce minQuantity/required logic
    if (allModifierGroups.isNotEmpty) {
      for (final modGroup in allModifierGroups) {
        final groupId = modGroup.id ?? '';
        final selected = selectedModifiers[groupId] ?? <String>{};
        final minQuantity = modGroup.minQuantity ?? 0;
        final maxQuantity = modGroup.maxQuantity ?? 9999;
        final requiredMin = (modGroup.required ?? false)
            ? (minQuantity > 0 ? minQuantity : 1)
            : minQuantity;

        // If group is required or minQuantity > 0, must select at least minQuantity
        if (requiredMin > 0 && selected.length < requiredMin) {
          return false;
        }
        if (selected.length > maxQuantity) {
          return false;
        }
      }
    }

    // For product-level groupModifiers (legacy or other use)
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

    final productId = product?.id ?? menuItem?.id ?? '';
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

  void increaseQty(int index) {
    cart[index]['qty']++;
    cart.refresh();
  }

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

  void removeItem(int index) {
    cart.removeAt(index);
    cart.refresh();
    if (cart.isEmpty) {
      Get.offNamed(Routes.menu);
    }
  }

  void clearCart() {
    cart.clear();
  }

  int get cartItemCount {
    int count = 0;
    for (final item in cart) {
      count += item['qty'] as int;
    }
    return count;
  }

  int getProductQuantity(String productId) {
    int qty = 0;
    for (final item in cart) {
      if (item['productId'] == productId) {
        qty += item['qty'] as int;
      }
    }
    return qty;
  }

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
