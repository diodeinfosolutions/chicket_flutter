import 'package:chicket/gen/assets.gen.dart';
import 'package:flutter/foundation.dart';

enum FoodType { veg, nonVeg }

enum AddonType { single, multiple }

class Category {
  final String id;
  final String name;
  final SvgGenImage? icon;

  const Category({required this.id, required this.name, this.icon});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => Object.hash(id, name);
}

final categories = <Category>[
  Category(id: 'combo', name: 'Combo Meal', icon: Assets.banner.comboMeal),
  Category(id: 'broasted', name: 'Broasted', icon: Assets.banner.broasted),
  Category(id: 'nuggets', name: 'Nuggets & Fillet', icon: Assets.banner.nugget),
  Category(id: 'sandwiches', name: 'Sandwiches', icon: Assets.banner.sandwich),
  Category(id: 'falafel', name: 'Falafel', icon: Assets.banner.falafel),
  Category(id: 'burgers', name: 'Burgers', icon: Assets.banner.burger),
];

final allCategories = <Category>[
  const Category(id: 'all', name: 'All'),
  ...categories,
];

class Addon {
  final String id;
  final String name;
  final double price;
  final bool isVeg;

  const Addon({
    required this.id,
    required this.name,
    required this.price,
    required this.isVeg,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Addon &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          price == other.price &&
          isVeg == other.isVeg;

  @override
  int get hashCode => Object.hash(id, name, price, isVeg);
}

class AddonGroup {
  final String id;
  final String title;
  final AddonType type;
  final bool required;
  final List<Addon> addons;

  const AddonGroup({
    required this.id,
    required this.title,
    required this.type,
    required this.required,
    required this.addons,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddonGroup &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          type == other.type &&
          required == other.required &&
          listEquals(addons, other.addons);

  @override
  int get hashCode =>
      Object.hash(id, title, type, required, Object.hashAll(addons));
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final FoodType foodType;
  final String categoryId;
  final String image;
  final List<AddonGroup> addonGroups;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.foodType,
    required this.categoryId,
    required this.image,
    this.addonGroups = const [],
  });

  Category? get category =>
      categories.where((c) => c.id == categoryId).firstOrNull;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          price == other.price &&
          foodType == other.foodType &&
          categoryId == other.categoryId &&
          image == other.image &&
          listEquals(addonGroups, other.addonGroups);

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    price,
    foodType,
    categoryId,
    image,
    Object.hashAll(addonGroups),
  );
}

final saucesAddonGroup = AddonGroup(
  id: 'ag1',
  title: 'Choose Sauces',
  type: AddonType.multiple,
  required: false,
  addons: const [
    Addon(id: 'a1', name: 'Garlic Sauce', price: 0.300, isVeg: true),
    Addon(id: 'a2', name: 'Ketchup', price: 0.200, isVeg: true),
    Addon(id: 'a3', name: 'Hummus', price: 0.400, isVeg: true),
  ],
);

final drinkAddonGroup = AddonGroup(
  id: 'ag2',
  title: 'Choose Drink',
  type: AddonType.single,
  required: true,
  addons: const [
    Addon(id: 'a4', name: 'Pepsi', price: 0.000, isVeg: true),
    Addon(id: 'a5', name: 'Coca-Cola', price: 0.000, isVeg: true),
    Addon(id: 'a6', name: 'Juice', price: 0.300, isVeg: true),
  ],
);

final products = <Product>[
  Product(
    id: 'p1',
    name: 'Family Combo',
    description: 'Broasted chicken + fries + drinks for 4',
    price: 6.999,
    foodType: FoodType.nonVeg,
    categoryId: 'combo',
    image: Assets.banner.food1.path,
    addonGroups: [saucesAddonGroup, drinkAddonGroup],
  ),
  Product(
    id: 'p2',
    name: 'Chicken Meal Box',
    description: '2 pcs chicken + fries + drink + coleslaw',
    price: 2.499,
    foodType: FoodType.nonVeg,
    categoryId: 'combo',
    image: Assets.banner.food1.path,
    addonGroups: [drinkAddonGroup],
  ),
  Product(
    id: 'p3',
    name: 'Burger Combo',
    description: 'Zinger burger + fries + drink',
    price: 2.299,
    foodType: FoodType.nonVeg,
    categoryId: 'combo',
    image: Assets.banner.food1.path,
    addonGroups: [drinkAddonGroup],
  ),

  Product(
    id: 'p4',
    name: '4 Pcs Broasted',
    description: '4 pcs broasted chicken + fries + garlic + ketchup',
    price: 1.500,
    foodType: FoodType.nonVeg,
    categoryId: 'broasted',
    image: Assets.banner.food1.path,
    addonGroups: [saucesAddonGroup],
  ),
  Product(
    id: 'p5',
    name: 'Broasted 8 Pcs',
    description: '8 pcs broasted chicken + fries + coleslaw + hummus',
    price: 4.000,
    foodType: FoodType.nonVeg,
    categoryId: 'broasted',
    image: Assets.banner.food1.path,
    addonGroups: [saucesAddonGroup, drinkAddonGroup],
  ),
  Product(
    id: 'p6',
    name: '16 Pcs Broasted',
    description: '16 pcs broasted chicken + fries + coleslaw + hummus',
    price: 8.970,
    foodType: FoodType.nonVeg,
    categoryId: 'broasted',
    image: Assets.banner.food1.path,
    addonGroups: [saucesAddonGroup, drinkAddonGroup],
  ),
  Product(
    id: 'p7',
    name: 'Grilled Chicken',
    description: 'Half grilled chicken with spices',
    price: 2.499,
    foodType: FoodType.nonVeg,
    categoryId: 'broasted',
    image: Assets.banner.food1.path,
  ),

  Product(
    id: 'p8',
    name: 'Chicken Nuggets',
    description: '6 pcs chicken nuggets with dip',
    price: 0.899,
    foodType: FoodType.nonVeg,
    categoryId: 'nuggets',
    image: Assets.banner.food1.path,
    addonGroups: [saucesAddonGroup],
  ),
  Product(
    id: 'p9',
    name: 'Chicken Popcorn',
    description: 'Crunchy chicken popcorn bites',
    price: 0.999,
    foodType: FoodType.nonVeg,
    categoryId: 'nuggets',
    image: Assets.banner.food1.path,
    addonGroups: [saucesAddonGroup],
  ),
  Product(
    id: 'p10',
    name: 'Chicken Strips',
    description: '4 pcs crispy chicken strips',
    price: 1.299,
    foodType: FoodType.nonVeg,
    categoryId: 'nuggets',
    image: Assets.banner.food1.path,
    addonGroups: [saucesAddonGroup],
  ),
  Product(
    id: 'p11',
    name: 'Veg Nuggets',
    description: '6 pcs veg nuggets',
    price: 0.799,
    foodType: FoodType.veg,
    categoryId: 'nuggets',
    image: Assets.banner.food2.path,
  ),

  Product(
    id: 'p12',
    name: 'Twister Sandwich',
    description: 'Chicken twister wrap with fries',
    price: 0.799,
    foodType: FoodType.nonVeg,
    categoryId: 'sandwiches',
    image: Assets.banner.food1.path,
    addonGroups: [saucesAddonGroup],
  ),
  Product(
    id: 'p13',
    name: 'Chicken Club Sandwich',
    description: 'Triple layer chicken sandwich',
    price: 1.699,
    foodType: FoodType.nonVeg,
    categoryId: 'sandwiches',
    image: Assets.banner.food1.path,
  ),
  Product(
    id: 'p14',
    name: 'Veg Grilled Sandwich',
    description: 'Grilled veg sandwich with cheese',
    price: 0.799,
    foodType: FoodType.veg,
    categoryId: 'sandwiches',
    image: Assets.banner.food2.path,
  ),
  Product(
    id: 'p15',
    name: 'Chicken Shawarma',
    description: 'Classic chicken shawarma roll',
    price: 0.999,
    foodType: FoodType.nonVeg,
    categoryId: 'sandwiches',
    image: Assets.banner.food1.path,
    addonGroups: [saucesAddonGroup],
  ),

  Product(
    id: 'p16',
    name: 'Falafel Wrap',
    description: 'Falafel wrap with tahini sauce',
    price: 0.699,
    foodType: FoodType.veg,
    categoryId: 'falafel',
    image: Assets.banner.food2.path,
    addonGroups: [saucesAddonGroup],
  ),
  Product(
    id: 'p17',
    name: 'Falafel Plate',
    description: 'Falafel with hummus and salad',
    price: 1.199,
    foodType: FoodType.veg,
    categoryId: 'falafel',
    image: Assets.banner.food2.path,
  ),
  Product(
    id: 'p18',
    name: 'Falafel Sandwich',
    description: 'Falafel in pita bread with veggies',
    price: 0.599,
    foodType: FoodType.veg,
    categoryId: 'falafel',
    image: Assets.banner.food2.path,
    addonGroups: [saucesAddonGroup],
  ),

  Product(
    id: 'p19',
    name: 'Royal Burger Meal',
    description: 'Burger + fries + drink',
    price: 2.999,
    foodType: FoodType.nonVeg,
    categoryId: 'burgers',
    image: Assets.banner.food1.path,
    addonGroups: [drinkAddonGroup],
  ),
  Product(
    id: 'p20',
    name: 'Zinger Burger',
    description: 'Crispy zinger chicken burger',
    price: 1.299,
    foodType: FoodType.nonVeg,
    categoryId: 'burgers',
    image: Assets.banner.food1.path,
  ),
  Product(
    id: 'p21',
    name: 'Cheese Zinger',
    description: 'Zinger burger with cheese slice',
    price: 1.499,
    foodType: FoodType.nonVeg,
    categoryId: 'burgers',
    image: Assets.banner.food1.path,
    addonGroups: [saucesAddonGroup],
  ),
  Product(
    id: 'p22',
    name: 'Veg Burger',
    description: 'Veg patty burger with lettuce',
    price: 0.899,
    foodType: FoodType.veg,
    categoryId: 'burgers',
    image: Assets.banner.food2.path,
  ),
  Product(
    id: 'p23',
    name: 'Double Chicken Burger',
    description: 'Double chicken patty burger',
    price: 1.999,
    foodType: FoodType.nonVeg,
    categoryId: 'burgers',
    image: Assets.banner.food1.path,
    addonGroups: [saucesAddonGroup],
  ),
];
