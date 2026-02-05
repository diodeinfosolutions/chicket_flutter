import 'package:json_annotation/json_annotation.dart';

part 'menu_models.g.dart';

num? _parseNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) {
    final parsed = num.tryParse(value);
    if (parsed != null) return parsed;
  }
  return null;
}

int? _parseIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    final parsed = int.tryParse(value);
    if (parsed != null) return parsed;
  }
  throw FormatException('Cannot parse $value as int');
}

@JsonSerializable()
class MenuRequest {
  @JsonKey(name: 'organizationId')
  final String organizationId;

  @JsonKey(name: 'startRevision')
  final int? startRevision;

  MenuRequest({required this.organizationId, this.startRevision});

  factory MenuRequest.fromJson(Map<String, dynamic> json) =>
      _$MenuRequestFromJson(json);
  Map<String, dynamic> toJson() => _$MenuRequestToJson(this);
}

@JsonSerializable()
class MenuByIdRequest {
  @JsonKey(name: 'externalMenuId')
  final int externalMenuId;

  @JsonKey(name: 'organizationIds')
  final List<String> organizationIds;

  @JsonKey(name: 'priceCategoryId')
  final String? priceCategoryId;

  MenuByIdRequest({
    required this.externalMenuId,
    required this.organizationIds,
    this.priceCategoryId,
  });

  factory MenuByIdRequest.fromJson(Map<String, dynamic> json) =>
      _$MenuByIdRequestFromJson(json);
  Map<String, dynamic> toJson() => _$MenuByIdRequestToJson(this);
}

@JsonSerializable()
class ExternalMenu {
  @JsonKey(name: 'id', fromJson: _parseInt)
  final int id;

  @JsonKey(name: 'name')
  final String name;

  ExternalMenu({required this.id, required this.name});

  factory ExternalMenu.fromJson(Map<String, dynamic> json) =>
      _$ExternalMenuFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalMenuToJson(this);
}

@JsonSerializable()
class PriceCategory {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  PriceCategory({required this.id, required this.name});

  factory PriceCategory.fromJson(Map<String, dynamic> json) =>
      _$PriceCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$PriceCategoryToJson(this);
}

@JsonSerializable()
class ExternalMenusResponse {
  @JsonKey(name: 'correlationId')
  final String? correlationId;

  @JsonKey(name: 'externalMenus')
  final List<ExternalMenu>? externalMenus;

  @JsonKey(name: 'priceCategories')
  final List<PriceCategory>? priceCategories;

  ExternalMenusResponse({
    this.correlationId,
    this.externalMenus,
    this.priceCategories,
  });

  factory ExternalMenusResponse.fromJson(Map<String, dynamic> json) =>
      _$ExternalMenusResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalMenusResponseToJson(this);
}

@JsonSerializable()
class MenuResponse {
  @JsonKey(name: 'correlationId')
  final String? correlationId;

  @JsonKey(name: 'id', fromJson: _parseIntNullable)
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'itemCategories')
  final List<MenuItemCategory>? itemCategories;

  @JsonKey(name: 'groups')
  final List<MenuGroup>? groups;

  @JsonKey(name: 'productCategories')
  final List<ProductCategory>? productCategories;

  @JsonKey(name: 'products')
  final List<MenuProduct>? products;

  @JsonKey(name: 'sizes')
  final List<ProductSize>? sizes;

  @JsonKey(name: 'revision', fromJson: _parseIntNullable)
  final int? revision;

  MenuResponse({
    this.correlationId,
    this.id,
    this.name,
    this.description,
    this.itemCategories,
    this.groups,
    this.productCategories,
    this.products,
    this.sizes,
    this.revision,
  });

  factory MenuResponse.fromJson(Map<String, dynamic> json) =>
      _$MenuResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MenuResponseToJson(this);

  /// Content hash for strict equality checking
  String get contentHash {
    final catCount = itemCategories?.length ?? 0;
    final itemCount = itemCategories?.fold<int>(0, (sum, cat) => sum + (cat.items?.length ?? 0)) ?? 0;
    final catIds = itemCategories?.map((c) => c.id).join(',') ?? '';
    return '${revision}_${catCount}_${itemCount}_${catIds.hashCode}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MenuResponse) return false;
    // Strict equality: same revision and same content hash
    return revision == other.revision && contentHash == other.contentHash;
  }

  @override
  int get hashCode => Object.hash(revision, contentHash);
}

@JsonSerializable()
class MenuItemCategory {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'buttonImageUrl')
  final String? buttonImageUrl;

  @JsonKey(name: 'headerImageUrl')
  final String? headerImageUrl;

  @JsonKey(name: 'order', fromJson: _parseIntNullable)
  final int? order;

  @JsonKey(name: 'isHidden')
  final bool? isHidden;

  @JsonKey(name: 'items')
  final List<MenuItem>? items;

  MenuItemCategory({
    this.id,
    this.name,
    this.description,
    this.buttonImageUrl,
    this.headerImageUrl,
    this.order,
    this.isHidden,
    this.items,
  });

  factory MenuItemCategory.fromJson(Map<String, dynamic> json) =>
      _$MenuItemCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemCategoryToJson(this);
}

@JsonSerializable()
class MenuItem {
  @JsonKey(name: 'sku')
  final String? sku;

  @JsonKey(name: 'itemId')
  final String? itemId;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'buttonImageUrl')
  final String? buttonImageUrl;

  @JsonKey(name: 'itemSizes')
  final List<MenuItemSize>? itemSizes;

  @JsonKey(name: 'modifierGroups')
  final List<MenuModifierGroup>? modifierGroups;

  @JsonKey(name: 'order', fromJson: _parseIntNullable)
  final int? order;

  @JsonKey(name: 'taxCategory')
  final MenuTaxCategory? taxCategory;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'isHidden')
  final bool? isHidden;

  MenuItem({
    this.sku,
    this.itemId,
    this.name,
    this.description,
    this.buttonImageUrl,
    this.itemSizes,
    this.modifierGroups,
    this.order,
    this.taxCategory,
    this.type,
    this.isHidden,
  });

  num? get currentPrice {
    if (itemSizes != null && itemSizes!.isNotEmpty) {
      final firstSize = itemSizes!.first;
      if (firstSize.prices != null && firstSize.prices!.isNotEmpty) {
        return firstSize.prices!.first.price;
      }
    }
    return null;
  }

  String? get imageUrl {
    if (buttonImageUrl != null && buttonImageUrl!.isNotEmpty) {
      return buttonImageUrl;
    }
    if (itemSizes != null && itemSizes!.isNotEmpty) {
      for (final size in itemSizes!) {
        if (size.buttonImageUrl != null && size.buttonImageUrl!.isNotEmpty) {
          return size.buttonImageUrl;
        }
      }
    }
    return null;
  }

  String get id => itemId ?? sku ?? '';

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemToJson(this);
}

@JsonSerializable()
class MenuItemSize {
  @JsonKey(name: 'sizeId')
  final String? sizeId;

  @JsonKey(name: 'sizeName')
  final String? sizeName;

  @JsonKey(name: 'sizeCode')
  final String? sizeCode;

  @JsonKey(name: 'isDefault')
  final bool? isDefault;

  @JsonKey(name: 'prices')
  final List<MenuItemPrice>? prices;

  @JsonKey(name: 'portionWeightGrams', fromJson: _parseNum)
  final num? portionWeightGrams;

  @JsonKey(name: 'buttonImageUrl')
  final String? buttonImageUrl;

  @JsonKey(name: 'nutritionPerHundredGrams')
  final NutritionInfo? nutritionPerHundredGrams;

  MenuItemSize({
    this.sizeId,
    this.sizeName,
    this.sizeCode,
    this.isDefault,
    this.prices,
    this.portionWeightGrams,
    this.buttonImageUrl,
    this.nutritionPerHundredGrams,
  });

  factory MenuItemSize.fromJson(Map<String, dynamic> json) =>
      _$MenuItemSizeFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemSizeToJson(this);
}

@JsonSerializable()
class MenuItemPrice {
  @JsonKey(name: 'organizationId')
  final String? organizationId;

  @JsonKey(name: 'price', fromJson: _parseNum)
  final num? price;

  MenuItemPrice({this.organizationId, this.price});

  factory MenuItemPrice.fromJson(Map<String, dynamic> json) =>
      _$MenuItemPriceFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemPriceToJson(this);
}

@JsonSerializable()
class NutritionInfo {
  @JsonKey(name: 'fats', fromJson: _parseNum)
  final num? fats;

  @JsonKey(name: 'proteins', fromJson: _parseNum)
  final num? proteins;

  @JsonKey(name: 'carbs', fromJson: _parseNum)
  final num? carbs;

  @JsonKey(name: 'energy', fromJson: _parseNum)
  final num? energy;

  NutritionInfo({this.fats, this.proteins, this.carbs, this.energy});

  factory NutritionInfo.fromJson(Map<String, dynamic> json) =>
      _$NutritionInfoFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionInfoToJson(this);
}

@JsonSerializable()
class MenuModifierGroup {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'minQuantity', fromJson: _parseIntNullable)
  final int? minQuantity;

  @JsonKey(name: 'maxQuantity', fromJson: _parseIntNullable)
  final int? maxQuantity;

  @JsonKey(name: 'required')
  final bool? required;

  @JsonKey(name: 'items')
  final List<MenuModifierItem>? items;

  @JsonKey(name: 'splittable')
  final bool? splittable;

  @JsonKey(name: 'childModifiersHaveMinMaxRestrictions')
  final bool? childModifiersHaveMinMaxRestrictions;

  MenuModifierGroup({
    this.id,
    this.name,
    this.description,
    this.minQuantity,
    this.maxQuantity,
    this.required,
    this.items,
    this.splittable,
    this.childModifiersHaveMinMaxRestrictions,
  });

  factory MenuModifierGroup.fromJson(Map<String, dynamic> json) =>
      _$MenuModifierGroupFromJson(json);
  Map<String, dynamic> toJson() => _$MenuModifierGroupToJson(this);
}

@JsonSerializable()
class MenuModifierItem {
  @JsonKey(name: 'sku')
  final String? sku;

  @JsonKey(name: 'itemId')
  final String? itemId;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'buttonImageUrl')
  final String? buttonImageUrl;

  @JsonKey(name: 'prices')
  final List<MenuItemPrice>? prices;

  @JsonKey(name: 'defaultAmount', fromJson: _parseIntNullable)
  final int? defaultAmount;

  @JsonKey(name: 'minAmount', fromJson: _parseIntNullable)
  final int? minAmount;

  @JsonKey(name: 'maxAmount', fromJson: _parseIntNullable)
  final int? maxAmount;

  @JsonKey(name: 'freeOfChargeAmount', fromJson: _parseIntNullable)
  final int? freeOfChargeAmount;

  @JsonKey(name: 'hideIfDefaultAmount')
  final bool? hideIfDefaultAmount;

  @JsonKey(name: 'portionWeightGrams', fromJson: _parseNum)
  final num? portionWeightGrams;

  MenuModifierItem({
    this.sku,
    this.itemId,
    this.name,
    this.description,
    this.buttonImageUrl,
    this.prices,
    this.defaultAmount,
    this.minAmount,
    this.maxAmount,
    this.freeOfChargeAmount,
    this.hideIfDefaultAmount,
    this.portionWeightGrams,
  });

  String get id => itemId ?? sku ?? '';

  num? get price {
    if (prices != null && prices!.isNotEmpty) {
      return prices!.first.price;
    }
    return null;
  }

  factory MenuModifierItem.fromJson(Map<String, dynamic> json) =>
      _$MenuModifierItemFromJson(json);
  Map<String, dynamic> toJson() => _$MenuModifierItemToJson(this);
}

@JsonSerializable()
class MenuTaxCategory {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'percentage', fromJson: _parseNum)
  final num? percentage;

  MenuTaxCategory({this.id, this.name, this.percentage});

  factory MenuTaxCategory.fromJson(Map<String, dynamic> json) =>
      _$MenuTaxCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$MenuTaxCategoryToJson(this);
}

@JsonSerializable()
class MenuGroup {
  @JsonKey(name: 'imageLinks')
  final List<String>? imageLinks;

  @JsonKey(name: 'parentGroup')
  final String? parentGroup;

  @JsonKey(name: 'order', fromJson: _parseIntNullable)
  final int? order;

  @JsonKey(name: 'isIncludedInMenu')
  final bool? isIncludedInMenu;

  @JsonKey(name: 'isGroupModifier')
  final bool? isGroupModifier;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'code')
  final String? code;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'additionalInfo')
  final String? additionalInfo;

  @JsonKey(name: 'tags')
  final List<String>? tags;

  @JsonKey(name: 'isDeleted')
  final bool? isDeleted;

  @JsonKey(name: 'seoDescription')
  final String? seoDescription;

  @JsonKey(name: 'seoText')
  final String? seoText;

  @JsonKey(name: 'seoKeywords')
  final String? seoKeywords;

  @JsonKey(name: 'seoTitle')
  final String? seoTitle;

  MenuGroup({
    this.imageLinks,
    this.parentGroup,
    this.order,
    this.isIncludedInMenu,
    this.isGroupModifier,
    required this.id,
    this.code,
    required this.name,
    this.description,
    this.additionalInfo,
    this.tags,
    this.isDeleted,
    this.seoDescription,
    this.seoText,
    this.seoKeywords,
    this.seoTitle,
  });

  factory MenuGroup.fromJson(Map<String, dynamic> json) =>
      _$MenuGroupFromJson(json);
  Map<String, dynamic> toJson() => _$MenuGroupToJson(this);
}

@JsonSerializable()
class ProductCategory {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'isDeleted')
  final bool? isDeleted;

  ProductCategory({required this.id, required this.name, this.isDeleted});

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);
}

@JsonSerializable()
class MenuProduct {
  @JsonKey(name: 'fatAmount', fromJson: _parseNum)
  final num? fatAmount;

  @JsonKey(name: 'proteinsAmount', fromJson: _parseNum)
  final num? proteinsAmount;

  @JsonKey(name: 'carbohydratesAmount', fromJson: _parseNum)
  final num? carbohydratesAmount;

  @JsonKey(name: 'energyAmount', fromJson: _parseNum)
  final num? energyAmount;

  @JsonKey(name: 'fatFullAmount', fromJson: _parseNum)
  final num? fatFullAmount;

  @JsonKey(name: 'proteinsFullAmount', fromJson: _parseNum)
  final num? proteinsFullAmount;

  @JsonKey(name: 'carbohydratesFullAmount', fromJson: _parseNum)
  final num? carbohydratesFullAmount;

  @JsonKey(name: 'energyFullAmount', fromJson: _parseNum)
  final num? energyFullAmount;

  @JsonKey(name: 'weight', fromJson: _parseNum)
  final num? weight;

  @JsonKey(name: 'groupId')
  final String? groupId;

  @JsonKey(name: 'productCategoryId')
  final String? productCategoryId;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'orderItemType')
  final String? orderItemType;

  @JsonKey(name: 'modifierSchemaId')
  final String? modifierSchemaId;

  @JsonKey(name: 'modifierSchemaName')
  final String? modifierSchemaName;

  @JsonKey(name: 'splittable')
  final bool? splittable;

  @JsonKey(name: 'measureUnit')
  final String? measureUnit;

  @JsonKey(name: 'sizePrices')
  final List<SizePrice>? sizePrices;

  @JsonKey(name: 'modifiers')
  final List<Modifier>? modifiers;

  @JsonKey(name: 'groupModifiers')
  final List<GroupModifier>? groupModifiers;

  @JsonKey(name: 'imageLinks')
  final List<String>? imageLinks;

  @JsonKey(name: 'doNotPrintInCheque')
  final bool? doNotPrintInCheque;

  @JsonKey(name: 'parentGroup')
  final String? parentGroup;

  @JsonKey(name: 'order', fromJson: _parseIntNullable)
  final int? order;

  @JsonKey(name: 'fullNameEnglish')
  final String? fullNameEnglish;

  @JsonKey(name: 'useBalanceForSell')
  final bool? useBalanceForSell;

  @JsonKey(name: 'canSetOpenPrice')
  final bool? canSetOpenPrice;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'code')
  final String? code;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'additionalInfo')
  final String? additionalInfo;

  @JsonKey(name: 'tags')
  final List<String>? tags;

  @JsonKey(name: 'isDeleted')
  final bool? isDeleted;

  @JsonKey(name: 'seoDescription')
  final String? seoDescription;

  @JsonKey(name: 'seoText')
  final String? seoText;

  @JsonKey(name: 'seoKeywords')
  final String? seoKeywords;

  @JsonKey(name: 'seoTitle')
  final String? seoTitle;

  MenuProduct({
    this.fatAmount,
    this.proteinsAmount,
    this.carbohydratesAmount,
    this.energyAmount,
    this.fatFullAmount,
    this.proteinsFullAmount,
    this.carbohydratesFullAmount,
    this.energyFullAmount,
    this.weight,
    this.groupId,
    this.productCategoryId,
    this.type,
    this.orderItemType,
    this.modifierSchemaId,
    this.modifierSchemaName,
    this.splittable,
    this.measureUnit,
    this.sizePrices,
    this.modifiers,
    this.groupModifiers,
    this.imageLinks,
    this.doNotPrintInCheque,
    this.parentGroup,
    this.order,
    this.fullNameEnglish,
    this.useBalanceForSell,
    this.canSetOpenPrice,
    required this.id,
    this.code,
    required this.name,
    this.description,
    this.additionalInfo,
    this.tags,
    this.isDeleted,
    this.seoDescription,
    this.seoText,
    this.seoKeywords,
    this.seoTitle,
  });

  num? get currentPrice {
    if (sizePrices != null && sizePrices!.isNotEmpty) {
      return sizePrices!.first.price?.currentPrice;
    }
    return null;
  }

  String? get imageUrl {
    if (imageLinks != null && imageLinks!.isNotEmpty) {
      return imageLinks!.first;
    }
    return null;
  }

  factory MenuProduct.fromJson(Map<String, dynamic> json) =>
      _$MenuProductFromJson(json);
  Map<String, dynamic> toJson() => _$MenuProductToJson(this);
}

@JsonSerializable()
class SizePrice {
  @JsonKey(name: 'sizeId')
  final String? sizeId;

  @JsonKey(name: 'price')
  final Price? price;

  SizePrice({this.sizeId, this.price});

  factory SizePrice.fromJson(Map<String, dynamic> json) =>
      _$SizePriceFromJson(json);
  Map<String, dynamic> toJson() => _$SizePriceToJson(this);
}

@JsonSerializable()
class Price {
  @JsonKey(name: 'currentPrice', fromJson: _parseNum)
  final num? currentPrice;

  @JsonKey(name: 'isIncludedInMenu')
  final bool? isIncludedInMenu;

  @JsonKey(name: 'nextPrice', fromJson: _parseNum)
  final num? nextPrice;

  @JsonKey(name: 'nextIncludedInMenu')
  final bool? nextIncludedInMenu;

  @JsonKey(name: 'nextDatePrice')
  final String? nextDatePrice;

  Price({
    this.currentPrice,
    this.isIncludedInMenu,
    this.nextPrice,
    this.nextIncludedInMenu,
    this.nextDatePrice,
  });

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
  Map<String, dynamic> toJson() => _$PriceToJson(this);
}

@JsonSerializable()
class Modifier {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'defaultAmount', fromJson: _parseIntNullable)
  final int? defaultAmount;

  @JsonKey(name: 'minAmount', fromJson: _parseIntNullable)
  final int? minAmount;

  @JsonKey(name: 'maxAmount', fromJson: _parseIntNullable)
  final int? maxAmount;

  @JsonKey(name: 'required')
  final bool? required;

  @JsonKey(name: 'hideIfDefaultAmount')
  final bool? hideIfDefaultAmount;

  @JsonKey(name: 'splittable')
  final bool? splittable;

  @JsonKey(name: 'freeOfChargeAmount', fromJson: _parseIntNullable)
  final int? freeOfChargeAmount;

  Modifier({
    required this.id,
    this.defaultAmount,
    this.minAmount,
    this.maxAmount,
    this.required,
    this.hideIfDefaultAmount,
    this.splittable,
    this.freeOfChargeAmount,
  });

  factory Modifier.fromJson(Map<String, dynamic> json) =>
      _$ModifierFromJson(json);
  Map<String, dynamic> toJson() => _$ModifierToJson(this);
}

@JsonSerializable()
class GroupModifier {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'minAmount', fromJson: _parseIntNullable)
  final int? minAmount;

  @JsonKey(name: 'maxAmount', fromJson: _parseIntNullable)
  final int? maxAmount;

  @JsonKey(name: 'required')
  final bool? required;

  @JsonKey(name: 'childModifiersHaveMinMaxRestrictions')
  final bool? childModifiersHaveMinMaxRestrictions;

  @JsonKey(name: 'childModifiers')
  final List<ChildModifier>? childModifiers;

  @JsonKey(name: 'hideIfDefaultAmount')
  final bool? hideIfDefaultAmount;

  @JsonKey(name: 'defaultAmount', fromJson: _parseIntNullable)
  final int? defaultAmount;

  @JsonKey(name: 'splittable')
  final bool? splittable;

  @JsonKey(name: 'freeOfChargeAmount', fromJson: _parseIntNullable)
  final int? freeOfChargeAmount;

  GroupModifier({
    required this.id,
    this.minAmount,
    this.maxAmount,
    this.required,
    this.childModifiersHaveMinMaxRestrictions,
    this.childModifiers,
    this.hideIfDefaultAmount,
    this.defaultAmount,
    this.splittable,
    this.freeOfChargeAmount,
  });

  factory GroupModifier.fromJson(Map<String, dynamic> json) =>
      _$GroupModifierFromJson(json);
  Map<String, dynamic> toJson() => _$GroupModifierToJson(this);
}

@JsonSerializable()
class ChildModifier {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'defaultAmount', fromJson: _parseIntNullable)
  final int? defaultAmount;

  @JsonKey(name: 'minAmount', fromJson: _parseIntNullable)
  final int? minAmount;

  @JsonKey(name: 'maxAmount', fromJson: _parseIntNullable)
  final int? maxAmount;

  @JsonKey(name: 'required')
  final bool? required;

  @JsonKey(name: 'hideIfDefaultAmount')
  final bool? hideIfDefaultAmount;

  @JsonKey(name: 'splittable')
  final bool? splittable;

  @JsonKey(name: 'freeOfChargeAmount', fromJson: _parseIntNullable)
  final int? freeOfChargeAmount;

  ChildModifier({
    required this.id,
    this.defaultAmount,
    this.minAmount,
    this.maxAmount,
    this.required,
    this.hideIfDefaultAmount,
    this.splittable,
    this.freeOfChargeAmount,
  });

  factory ChildModifier.fromJson(Map<String, dynamic> json) =>
      _$ChildModifierFromJson(json);
  Map<String, dynamic> toJson() => _$ChildModifierToJson(this);
}

@JsonSerializable()
class ProductSize {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'priority', fromJson: _parseIntNullable)
  final int? priority;

  @JsonKey(name: 'isDefault')
  final bool? isDefault;

  ProductSize({
    required this.id,
    required this.name,
    this.priority,
    this.isDefault,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json) =>
      _$ProductSizeFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSizeToJson(this);
}
