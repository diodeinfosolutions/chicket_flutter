import 'package:json_annotation/json_annotation.dart';

part 'view_menu_models.g.dart';

String? _parseString(dynamic value) {
  if (value == null) return null;
  return value.toString();
}

int? _parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

@JsonSerializable()
class ViewMenuResponse {
  final bool? status;
  final String? message;
  final ViewMenuData? data;

  ViewMenuResponse({this.status, this.message, this.data});

  factory ViewMenuResponse.fromJson(Map<String, dynamic> json) =>
      _$ViewMenuResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ViewMenuResponseToJson(this);
}

@JsonSerializable()
class ViewMenuData {
  @JsonKey(fromJson: _parseInt)
  final int? id;
  final String? name;
  @JsonKey(name: 'name_ar')
  final String? nameAr;
  final String? description;
  @JsonKey(name: 'description_ar')
  final String? descriptionAr;
  @JsonKey(fromJson: _parseInt)
  final int? revision;
  final List<ViewProductCategory>? productCategories;
  final List<ViewItemCategory>? itemCategories;

  ViewMenuData({
    this.id,
    this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.revision,
    this.productCategories,
    this.itemCategories,
  });

  factory ViewMenuData.fromJson(Map<String, dynamic> json) =>
      _$ViewMenuDataFromJson(json);
  Map<String, dynamic> toJson() => _$ViewMenuDataToJson(this);
}

@JsonSerializable()
class ViewProductCategory {
  @JsonKey(fromJson: _parseString)
  final String? id;
  final String? name;
  @JsonKey(name: 'name_ar')
  final String? nameAr;
  final bool? isDeleted;

  ViewProductCategory({this.id, this.name, this.nameAr, this.isDeleted});

  factory ViewProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ViewProductCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ViewProductCategoryToJson(this);
}

@JsonSerializable()
class ViewItemCategory {
  @JsonKey(fromJson: _parseString)
  final String? id;
  final String? name;
  @JsonKey(name: 'name_ar')
  final String? nameAr;
  final String? description;
  @JsonKey(name: 'description_ar')
  final String? descriptionAr;
  final String? buttonImageUrl;
  final String? headerImageUrl;
  final bool? isHidden;
  final List<ViewMenuItem>? items;

  ViewItemCategory({
    this.id,
    this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.buttonImageUrl,
    this.headerImageUrl,
    this.isHidden,
    this.items,
  });

  factory ViewItemCategory.fromJson(Map<String, dynamic> json) =>
      _$ViewItemCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ViewItemCategoryToJson(this);
}

@JsonSerializable()
class ViewMenuItem {
  @JsonKey(fromJson: _parseString)
  final String? itemId;
  final String? sku;
  final String? name;
  @JsonKey(name: 'name_ar')
  final String? nameAr;
  final String? description;
  @JsonKey(name: 'description_ar')
  final String? descriptionAr;
  final String? type;
  final bool? isHidden;
  final List<ViewMenuItemSize>? itemSizes;

  ViewMenuItem({
    this.itemId,
    this.sku,
    this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.type,
    this.isHidden,
    this.itemSizes,
  });

  factory ViewMenuItem.fromJson(Map<String, dynamic> json) =>
      _$ViewMenuItemFromJson(json);
  Map<String, dynamic> toJson() => _$ViewMenuItemToJson(this);
}

@JsonSerializable()
class ViewMenuItemSize {
  final String? sku;
  final String? sizeName;
  @JsonKey(name: 'sizeName_ar')
  final String? sizeNameAr;
  @JsonKey(fromJson: _parseString)
  final String? portionWeightGrams;
  final String? measureUnitType;
  final String? buttonImageUrl;
  final bool? isDefault;
  final bool? isHidden;
  final List<ViewItemPrice>? prices;
  final List<ViewItemModifierGroup>? itemModifierGroups;

  ViewMenuItemSize({
    this.sku,
    this.sizeName,
    this.sizeNameAr,
    this.portionWeightGrams,
    this.measureUnitType,
    this.buttonImageUrl,
    this.isDefault,
    this.isHidden,
    this.prices,
    this.itemModifierGroups,
  });

  factory ViewMenuItemSize.fromJson(Map<String, dynamic> json) =>
      _$ViewMenuItemSizeFromJson(json);
  Map<String, dynamic> toJson() => _$ViewMenuItemSizeToJson(this);
}

@JsonSerializable()
class ViewItemPrice {
  @JsonKey(fromJson: _parseString)
  final String? organizationId;
  @JsonKey(fromJson: _parseString)
  final String? price;

  ViewItemPrice({this.organizationId, this.price});

  factory ViewItemPrice.fromJson(Map<String, dynamic> json) =>
      _$ViewItemPriceFromJson(json);
  Map<String, dynamic> toJson() => _$ViewItemPriceToJson(this);
}

@JsonSerializable()
class ViewItemModifierGroup {
  @JsonKey(fromJson: _parseString)
  final String? itemGroupId;
  final String? name;
  @JsonKey(name: 'name_ar')
  final String? nameAr;
  final String? description;
  @JsonKey(name: 'description_ar')
  final String? descriptionAr;
  final ViewModifierRestrictions? restrictions;
  final List<ViewModifierItem>? items;

  ViewItemModifierGroup({
    this.itemGroupId,
    this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.restrictions,
    this.items,
  });

  factory ViewItemModifierGroup.fromJson(Map<String, dynamic> json) =>
      _$ViewItemModifierGroupFromJson(json);
  Map<String, dynamic> toJson() => _$ViewItemModifierGroupToJson(this);
}

@JsonSerializable()
class ViewModifierRestrictions {
  @JsonKey(fromJson: _parseInt)
  final int? minQuantity;
  @JsonKey(fromJson: _parseInt)
  final int? maxQuantity;

  ViewModifierRestrictions({this.minQuantity, this.maxQuantity});

  factory ViewModifierRestrictions.fromJson(Map<String, dynamic> json) =>
      _$ViewModifierRestrictionsFromJson(json);
  Map<String, dynamic> toJson() => _$ViewModifierRestrictionsToJson(this);
}

@JsonSerializable()
class ViewModifierItem {
  @JsonKey(fromJson: _parseString)
  final String? itemId;
  final String? sku;
  final String? name;
  @JsonKey(name: 'name_ar')
  final String? nameAr;
  final String? description;
  @JsonKey(name: 'description_ar')
  final String? descriptionAr;
  final List<ViewItemPrice>? prices;
  final bool? isHidden;

  ViewModifierItem({
    this.itemId,
    this.sku,
    this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.prices,
    this.isHidden,
  });

  factory ViewModifierItem.fromJson(Map<String, dynamic> json) =>
      _$ViewModifierItemFromJson(json);
  Map<String, dynamic> toJson() => _$ViewModifierItemToJson(this);
}
