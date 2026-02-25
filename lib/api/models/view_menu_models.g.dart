// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_menu_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ViewMenuResponse _$ViewMenuResponseFromJson(Map<String, dynamic> json) =>
    ViewMenuResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : ViewMenuData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ViewMenuResponseToJson(ViewMenuResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

ViewMenuData _$ViewMenuDataFromJson(Map<String, dynamic> json) => ViewMenuData(
  id: _parseInt(json['id']),
  name: json['name'] as String?,
  nameAr: json['name_ar'] as String?,
  description: json['description'] as String?,
  descriptionAr: json['description_ar'] as String?,
  revision: _parseInt(json['revision']),
  productCategories: (json['productCategories'] as List<dynamic>?)
      ?.map((e) => ViewProductCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
  itemCategories: (json['itemCategories'] as List<dynamic>?)
      ?.map((e) => ViewItemCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ViewMenuDataToJson(ViewMenuData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'description': instance.description,
      'description_ar': instance.descriptionAr,
      'revision': instance.revision,
      'productCategories': instance.productCategories,
      'itemCategories': instance.itemCategories,
    };

ViewProductCategory _$ViewProductCategoryFromJson(Map<String, dynamic> json) =>
    ViewProductCategory(
      id: _parseString(json['id']),
      name: json['name'] as String?,
      nameAr: json['name_ar'] as String?,
      isDeleted: json['isDeleted'] as bool?,
    );

Map<String, dynamic> _$ViewProductCategoryToJson(
  ViewProductCategory instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'name_ar': instance.nameAr,
  'isDeleted': instance.isDeleted,
};

ViewItemCategory _$ViewItemCategoryFromJson(Map<String, dynamic> json) =>
    ViewItemCategory(
      id: _parseString(json['id']),
      name: json['name'] as String?,
      nameAr: json['name_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      buttonImageUrl: json['buttonImageUrl'] as String?,
      headerImageUrl: json['headerImageUrl'] as String?,
      isHidden: json['isHidden'] as bool?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ViewMenuItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ViewItemCategoryToJson(ViewItemCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'description': instance.description,
      'description_ar': instance.descriptionAr,
      'buttonImageUrl': instance.buttonImageUrl,
      'headerImageUrl': instance.headerImageUrl,
      'isHidden': instance.isHidden,
      'items': instance.items,
    };

ViewMenuItem _$ViewMenuItemFromJson(Map<String, dynamic> json) => ViewMenuItem(
  itemId: _parseString(json['itemId']),
  sku: json['sku'] as String?,
  name: json['name'] as String?,
  nameAr: json['name_ar'] as String?,
  description: json['description'] as String?,
  descriptionAr: json['description_ar'] as String?,
  type: json['type'] as String?,
  isHidden: json['isHidden'] as bool?,
  itemSizes: (json['itemSizes'] as List<dynamic>?)
      ?.map((e) => ViewMenuItemSize.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ViewMenuItemToJson(ViewMenuItem instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'sku': instance.sku,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'description': instance.description,
      'description_ar': instance.descriptionAr,
      'type': instance.type,
      'isHidden': instance.isHidden,
      'itemSizes': instance.itemSizes,
    };

ViewMenuItemSize _$ViewMenuItemSizeFromJson(Map<String, dynamic> json) =>
    ViewMenuItemSize(
      sku: json['sku'] as String?,
      sizeName: json['sizeName'] as String?,
      sizeNameAr: json['sizeName_ar'] as String?,
      portionWeightGrams: _parseString(json['portionWeightGrams']),
      measureUnitType: json['measureUnitType'] as String?,
      buttonImageUrl: json['buttonImageUrl'] as String?,
      isDefault: json['isDefault'] as bool?,
      isHidden: json['isHidden'] as bool?,
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) => ViewItemPrice.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemModifierGroups: (json['itemModifierGroups'] as List<dynamic>?)
          ?.map(
            (e) => ViewItemModifierGroup.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$ViewMenuItemSizeToJson(ViewMenuItemSize instance) =>
    <String, dynamic>{
      'sku': instance.sku,
      'sizeName': instance.sizeName,
      'sizeName_ar': instance.sizeNameAr,
      'portionWeightGrams': instance.portionWeightGrams,
      'measureUnitType': instance.measureUnitType,
      'buttonImageUrl': instance.buttonImageUrl,
      'isDefault': instance.isDefault,
      'isHidden': instance.isHidden,
      'prices': instance.prices,
      'itemModifierGroups': instance.itemModifierGroups,
    };

ViewItemPrice _$ViewItemPriceFromJson(Map<String, dynamic> json) =>
    ViewItemPrice(
      organizationId: _parseString(json['organizationId']),
      price: _parseString(json['price']),
    );

Map<String, dynamic> _$ViewItemPriceToJson(ViewItemPrice instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'price': instance.price,
    };

ViewItemModifierGroup _$ViewItemModifierGroupFromJson(
  Map<String, dynamic> json,
) => ViewItemModifierGroup(
  itemGroupId: _parseString(json['itemGroupId']),
  name: json['name'] as String?,
  nameAr: json['name_ar'] as String?,
  description: json['description'] as String?,
  descriptionAr: json['description_ar'] as String?,
  restrictions: json['restrictions'] == null
      ? null
      : ViewModifierRestrictions.fromJson(
          json['restrictions'] as Map<String, dynamic>,
        ),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => ViewModifierItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ViewItemModifierGroupToJson(
  ViewItemModifierGroup instance,
) => <String, dynamic>{
  'itemGroupId': instance.itemGroupId,
  'name': instance.name,
  'name_ar': instance.nameAr,
  'description': instance.description,
  'description_ar': instance.descriptionAr,
  'restrictions': instance.restrictions,
  'items': instance.items,
};

ViewModifierRestrictions _$ViewModifierRestrictionsFromJson(
  Map<String, dynamic> json,
) => ViewModifierRestrictions(
  minQuantity: _parseInt(json['minQuantity']),
  maxQuantity: _parseInt(json['maxQuantity']),
);

Map<String, dynamic> _$ViewModifierRestrictionsToJson(
  ViewModifierRestrictions instance,
) => <String, dynamic>{
  'minQuantity': instance.minQuantity,
  'maxQuantity': instance.maxQuantity,
};

ViewModifierItem _$ViewModifierItemFromJson(Map<String, dynamic> json) =>
    ViewModifierItem(
      itemId: _parseString(json['itemId']),
      sku: json['sku'] as String?,
      name: json['name'] as String?,
      nameAr: json['name_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) => ViewItemPrice.fromJson(e as Map<String, dynamic>))
          .toList(),
      isHidden: json['isHidden'] as bool?,
    );

Map<String, dynamic> _$ViewModifierItemToJson(ViewModifierItem instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'sku': instance.sku,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'description': instance.description,
      'description_ar': instance.descriptionAr,
      'prices': instance.prices,
      'isHidden': instance.isHidden,
    };
