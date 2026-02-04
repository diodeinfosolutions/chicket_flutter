import 'package:get/get.dart';
import 'package:chicket/routes.dart';
import 'package:chicket/models/menu_model.dart';

enum OrderType { dineIn, takeaway }

class OrderController extends GetxController {
  final Rx<OrderType?> selectedType = Rx<OrderType?>(null);

  final RxList<Map<String, dynamic>> cart = <Map<String, dynamic>>[].obs;

  final Rx<Product?> currentProduct = Rx<Product?>(null);
  final RxMap<String, Set<String>> selectedAddons = <String, Set<String>>{}.obs;
  final RxInt addonQuantity = 1.obs;

  void selectOrderType(OrderType type) {
    if (selectedType.value == type) {
      selectedType.value = null;
    } else {
      selectedType.value = type;
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.toNamed(Routes.menu);
      });
    }
  }

  void resetSelection() {
    selectedType.value = null;
    cart.clear();
    resetAddonSelection();
  }

  void initAddonSelection(Product product) {
    currentProduct.value = product;
    addonQuantity.value = 1;
    selectedAddons.clear();
    for (final group in product.addonGroups) {
      selectedAddons[group.id] = <String>{};
    }
  }

  void resetAddonSelection() {
    currentProduct.value = null;
    selectedAddons.clear();
    addonQuantity.value = 1;
  }

  void toggleAddon(AddonGroup group, Addon addon) {
    if (group.type == AddonType.single) {
      if (selectedAddons[group.id]?.contains(addon.id) ?? false) {
        selectedAddons[group.id] = <String>{};
      } else {
        selectedAddons[group.id] = {addon.id};
      }
    } else {
      final current = selectedAddons[group.id] ?? <String>{};
      if (current.contains(addon.id)) {
        current.remove(addon.id);
      } else {
        current.add(addon.id);
      }
      selectedAddons[group.id] = current;
    }
    selectedAddons.refresh();
  }

  bool isAddonSelected(String groupId, String addonId) {
    return selectedAddons[groupId]?.contains(addonId) ?? false;
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
    final product = currentProduct.value;
    if (product == null) return 0;

    double total = product.price;
    for (final group in product.addonGroups) {
      for (final addon in group.addons) {
        if (isAddonSelected(group.id, addon.id)) {
          total += addon.price;
        }
      }
    }
    return total * addonQuantity.value;
  }

  bool get canAddToCart {
    final product = currentProduct.value;
    if (product == null) return false;

    for (final group in product.addonGroups) {
      if (group.required) {
        final selected = selectedAddons[group.id];
        if (selected == null || selected.isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  void addCurrentProductToCart() {
    final product = currentProduct.value;
    if (product == null) return;
    if (!canAddToCart) return;

    final Map<String, List<Map<String, dynamic>>> addonsMap = {};
    for (final group in product.addonGroups) {
      final selectedInGroup = <Map<String, dynamic>>[];
      for (final addon in group.addons) {
        if (isAddonSelected(group.id, addon.id)) {
          selectedInGroup.add({
            'id': addon.id,
            'name': addon.name,
            'price': addon.price,
          });
        }
      }
      if (selectedInGroup.isNotEmpty) {
        addonsMap[group.id] = selectedInGroup;
      }
    }

    addToCart(
      productId: product.id,
      name: product.name,
      price: product.price,
      addons: addonsMap,
      qty: addonQuantity.value,
    );

    resetAddonSelection();
    Get.back();
  }

  void addToCart({
    required String productId,
    required String name,
    required double price,
    Map<String, List<Map<String, dynamic>>> addons = const {},
    int qty = 1,
  }) {
    final index = cart.indexWhere(
      (e) => e['productId'] == productId && _sameAddons(e['addons'], addons),
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
        'addons': addons,
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
  }

  void removeItem(int index) {
    cart.removeAt(index);
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
      final base = item['price'] * item['qty'];
      double addonsTotal = 0;

      final addons = item['addons'] as Map<String, List<Map<String, dynamic>>>;
      for (final group in addons.values) {
        for (final addon in group) {
          addonsTotal += addon['price'];
        }
      }

      total += base + (addonsTotal * item['qty']);
    }
    return total;
  }

  bool _sameAddons(dynamic aRaw, Map<String, List<Map<String, dynamic>>> b) {
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
