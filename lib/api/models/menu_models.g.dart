// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuRequest _$MenuRequestFromJson(Map<String, dynamic> json) => MenuRequest(
  organizationId: json['organizationId'] as String,
  startRevision: (json['startRevision'] as num?)?.toInt(),
);

Map<String, dynamic> _$MenuRequestToJson(MenuRequest instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'startRevision': instance.startRevision,
    };

MenuByIdRequest _$MenuByIdRequestFromJson(Map<String, dynamic> json) =>
    MenuByIdRequest(
      externalMenuId: (json['externalMenuId'] as num).toInt(),
      organizationIds: (json['organizationIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      priceCategoryId: json['priceCategoryId'] as String?,
    );

Map<String, dynamic> _$MenuByIdRequestToJson(MenuByIdRequest instance) =>
    <String, dynamic>{
      'externalMenuId': instance.externalMenuId,
      'organizationIds': instance.organizationIds,
      'priceCategoryId': instance.priceCategoryId,
    };

ExternalMenu _$ExternalMenuFromJson(Map<String, dynamic> json) =>
    ExternalMenu(id: _parseInt(json['id']), name: json['name'] as String);

Map<String, dynamic> _$ExternalMenuToJson(ExternalMenu instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

PriceCategory _$PriceCategoryFromJson(Map<String, dynamic> json) =>
    PriceCategory(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$PriceCategoryToJson(PriceCategory instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

ExternalMenusResponse _$ExternalMenusResponseFromJson(
  Map<String, dynamic> json,
) => ExternalMenusResponse(
  correlationId: json['correlationId'] as String?,
  externalMenus: (json['externalMenus'] as List<dynamic>?)
      ?.map((e) => ExternalMenu.fromJson(e as Map<String, dynamic>))
      .toList(),
  priceCategories: (json['priceCategories'] as List<dynamic>?)
      ?.map((e) => PriceCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ExternalMenusResponseToJson(
  ExternalMenusResponse instance,
) => <String, dynamic>{
  'correlationId': instance.correlationId,
  'externalMenus': instance.externalMenus,
  'priceCategories': instance.priceCategories,
};

MenuResponse _$MenuResponseFromJson(Map<String, dynamic> json) => MenuResponse(
  correlationId: json['correlationId'] as String?,
  id: _parseIntNullable(json['id']),
  name: json['name'] as String?,
  description: json['description'] as String?,
  itemCategories: (json['itemCategories'] as List<dynamic>?)
      ?.map((e) => MenuItemCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
  groups: (json['groups'] as List<dynamic>?)
      ?.map((e) => MenuGroup.fromJson(e as Map<String, dynamic>))
      .toList(),
  productCategories: (json['productCategories'] as List<dynamic>?)
      ?.map((e) => ProductCategory.fromJson(e as Map<String, dynamic>))
      .toList(),
  products: (json['products'] as List<dynamic>?)
      ?.map((e) => MenuProduct.fromJson(e as Map<String, dynamic>))
      .toList(),
  sizes: (json['sizes'] as List<dynamic>?)
      ?.map((e) => ProductSize.fromJson(e as Map<String, dynamic>))
      .toList(),
  revision: _parseIntNullable(json['revision']),
);

Map<String, dynamic> _$MenuResponseToJson(MenuResponse instance) =>
    <String, dynamic>{
      'correlationId': instance.correlationId,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'itemCategories': instance.itemCategories,
      'groups': instance.groups,
      'productCategories': instance.productCategories,
      'products': instance.products,
      'sizes': instance.sizes,
      'revision': instance.revision,
    };

MenuItemCategory _$MenuItemCategoryFromJson(Map<String, dynamic> json) =>
    MenuItemCategory(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      buttonImageUrl: json['buttonImageUrl'] as String?,
      headerImageUrl: json['headerImageUrl'] as String?,
      order: _parseIntNullable(json['order']),
      isHidden: json['isHidden'] as bool?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuItemCategoryToJson(MenuItemCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'buttonImageUrl': instance.buttonImageUrl,
      'headerImageUrl': instance.headerImageUrl,
      'order': instance.order,
      'isHidden': instance.isHidden,
      'items': instance.items,
    };

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => MenuItem(
  sku: json['sku'] as String?,
  itemId: json['itemId'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  buttonImageUrl: json['buttonImageUrl'] as String?,
  itemSizes: (json['itemSizes'] as List<dynamic>?)
      ?.map((e) => MenuItemSize.fromJson(e as Map<String, dynamic>))
      .toList(),
  modifierGroups: (json['modifierGroups'] as List<dynamic>?)
      ?.map((e) => MenuModifierGroup.fromJson(e as Map<String, dynamic>))
      .toList(),
  order: _parseIntNullable(json['order']),
  taxCategory: json['taxCategory'] == null
      ? null
      : MenuTaxCategory.fromJson(json['taxCategory'] as Map<String, dynamic>),
  type: json['type'] as String?,
  isHidden: json['isHidden'] as bool?,
);

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) => <String, dynamic>{
  'sku': instance.sku,
  'itemId': instance.itemId,
  'name': instance.name,
  'description': instance.description,
  'buttonImageUrl': instance.buttonImageUrl,
  'itemSizes': instance.itemSizes,
  'modifierGroups': instance.modifierGroups,
  'order': instance.order,
  'taxCategory': instance.taxCategory,
  'type': instance.type,
  'isHidden': instance.isHidden,
};

MenuItemSize _$MenuItemSizeFromJson(Map<String, dynamic> json) => MenuItemSize(
  sizeId: json['sizeId'] as String?,
  sizeName: json['sizeName'] as String?,
  sizeCode: json['sizeCode'] as String?,
  isDefault: json['isDefault'] as bool?,
  prices: (json['prices'] as List<dynamic>?)
      ?.map((e) => MenuItemPrice.fromJson(e as Map<String, dynamic>))
      .toList(),
  portionWeightGrams: _parseNum(json['portionWeightGrams']),
  buttonImageUrl: json['buttonImageUrl'] as String?,
  nutritionPerHundredGrams: json['nutritionPerHundredGrams'] == null
      ? null
      : NutritionInfo.fromJson(
          json['nutritionPerHundredGrams'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$MenuItemSizeToJson(MenuItemSize instance) =>
    <String, dynamic>{
      'sizeId': instance.sizeId,
      'sizeName': instance.sizeName,
      'sizeCode': instance.sizeCode,
      'isDefault': instance.isDefault,
      'prices': instance.prices,
      'portionWeightGrams': instance.portionWeightGrams,
      'buttonImageUrl': instance.buttonImageUrl,
      'nutritionPerHundredGrams': instance.nutritionPerHundredGrams,
    };

MenuItemPrice _$MenuItemPriceFromJson(Map<String, dynamic> json) =>
    MenuItemPrice(
      organizationId: json['organizationId'] as String?,
      price: _parseNum(json['price']),
    );

Map<String, dynamic> _$MenuItemPriceToJson(MenuItemPrice instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'price': instance.price,
    };

NutritionInfo _$NutritionInfoFromJson(Map<String, dynamic> json) =>
    NutritionInfo(
      fats: _parseNum(json['fats']),
      proteins: _parseNum(json['proteins']),
      carbs: _parseNum(json['carbs']),
      energy: _parseNum(json['energy']),
    );

Map<String, dynamic> _$NutritionInfoToJson(NutritionInfo instance) =>
    <String, dynamic>{
      'fats': instance.fats,
      'proteins': instance.proteins,
      'carbs': instance.carbs,
      'energy': instance.energy,
    };

MenuModifierGroup _$MenuModifierGroupFromJson(Map<String, dynamic> json) =>
    MenuModifierGroup(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      minQuantity: _parseIntNullable(json['minQuantity']),
      maxQuantity: _parseIntNullable(json['maxQuantity']),
      required: json['required'] as bool?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => MenuModifierItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      splittable: json['splittable'] as bool?,
      childModifiersHaveMinMaxRestrictions:
          json['childModifiersHaveMinMaxRestrictions'] as bool?,
    );

Map<String, dynamic> _$MenuModifierGroupToJson(MenuModifierGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'minQuantity': instance.minQuantity,
      'maxQuantity': instance.maxQuantity,
      'required': instance.required,
      'items': instance.items,
      'splittable': instance.splittable,
      'childModifiersHaveMinMaxRestrictions':
          instance.childModifiersHaveMinMaxRestrictions,
    };

MenuModifierItem _$MenuModifierItemFromJson(Map<String, dynamic> json) =>
    MenuModifierItem(
      sku: json['sku'] as String?,
      itemId: json['itemId'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      buttonImageUrl: json['buttonImageUrl'] as String?,
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) => MenuItemPrice.fromJson(e as Map<String, dynamic>))
          .toList(),
      defaultAmount: _parseIntNullable(json['defaultAmount']),
      minAmount: _parseIntNullable(json['minAmount']),
      maxAmount: _parseIntNullable(json['maxAmount']),
      freeOfChargeAmount: _parseIntNullable(json['freeOfChargeAmount']),
      hideIfDefaultAmount: json['hideIfDefaultAmount'] as bool?,
      portionWeightGrams: _parseNum(json['portionWeightGrams']),
    );

Map<String, dynamic> _$MenuModifierItemToJson(MenuModifierItem instance) =>
    <String, dynamic>{
      'sku': instance.sku,
      'itemId': instance.itemId,
      'name': instance.name,
      'description': instance.description,
      'buttonImageUrl': instance.buttonImageUrl,
      'prices': instance.prices,
      'defaultAmount': instance.defaultAmount,
      'minAmount': instance.minAmount,
      'maxAmount': instance.maxAmount,
      'freeOfChargeAmount': instance.freeOfChargeAmount,
      'hideIfDefaultAmount': instance.hideIfDefaultAmount,
      'portionWeightGrams': instance.portionWeightGrams,
    };

MenuTaxCategory _$MenuTaxCategoryFromJson(Map<String, dynamic> json) =>
    MenuTaxCategory(
      id: json['id'] as String?,
      name: json['name'] as String?,
      percentage: _parseNum(json['percentage']),
    );

Map<String, dynamic> _$MenuTaxCategoryToJson(MenuTaxCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'percentage': instance.percentage,
    };

MenuGroup _$MenuGroupFromJson(Map<String, dynamic> json) => MenuGroup(
  imageLinks: (json['imageLinks'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  parentGroup: json['parentGroup'] as String?,
  order: _parseIntNullable(json['order']),
  isIncludedInMenu: json['isIncludedInMenu'] as bool?,
  isGroupModifier: json['isGroupModifier'] as bool?,
  id: json['id'] as String,
  code: json['code'] as String?,
  name: json['name'] as String,
  description: json['description'] as String?,
  additionalInfo: json['additionalInfo'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  isDeleted: json['isDeleted'] as bool?,
  seoDescription: json['seoDescription'] as String?,
  seoText: json['seoText'] as String?,
  seoKeywords: json['seoKeywords'] as String?,
  seoTitle: json['seoTitle'] as String?,
);

Map<String, dynamic> _$MenuGroupToJson(MenuGroup instance) => <String, dynamic>{
  'imageLinks': instance.imageLinks,
  'parentGroup': instance.parentGroup,
  'order': instance.order,
  'isIncludedInMenu': instance.isIncludedInMenu,
  'isGroupModifier': instance.isGroupModifier,
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'description': instance.description,
  'additionalInfo': instance.additionalInfo,
  'tags': instance.tags,
  'isDeleted': instance.isDeleted,
  'seoDescription': instance.seoDescription,
  'seoText': instance.seoText,
  'seoKeywords': instance.seoKeywords,
  'seoTitle': instance.seoTitle,
};

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) =>
    ProductCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      isDeleted: json['isDeleted'] as bool?,
    );

Map<String, dynamic> _$ProductCategoryToJson(ProductCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isDeleted': instance.isDeleted,
    };

MenuProduct _$MenuProductFromJson(Map<String, dynamic> json) => MenuProduct(
  fatAmount: _parseNum(json['fatAmount']),
  proteinsAmount: _parseNum(json['proteinsAmount']),
  carbohydratesAmount: _parseNum(json['carbohydratesAmount']),
  energyAmount: _parseNum(json['energyAmount']),
  fatFullAmount: _parseNum(json['fatFullAmount']),
  proteinsFullAmount: _parseNum(json['proteinsFullAmount']),
  carbohydratesFullAmount: _parseNum(json['carbohydratesFullAmount']),
  energyFullAmount: _parseNum(json['energyFullAmount']),
  weight: _parseNum(json['weight']),
  groupId: json['groupId'] as String?,
  productCategoryId: json['productCategoryId'] as String?,
  type: json['type'] as String?,
  orderItemType: json['orderItemType'] as String?,
  modifierSchemaId: json['modifierSchemaId'] as String?,
  modifierSchemaName: json['modifierSchemaName'] as String?,
  splittable: json['splittable'] as bool?,
  measureUnit: json['measureUnit'] as String?,
  sizePrices: (json['sizePrices'] as List<dynamic>?)
      ?.map((e) => SizePrice.fromJson(e as Map<String, dynamic>))
      .toList(),
  modifiers: (json['modifiers'] as List<dynamic>?)
      ?.map((e) => Modifier.fromJson(e as Map<String, dynamic>))
      .toList(),
  groupModifiers: (json['groupModifiers'] as List<dynamic>?)
      ?.map((e) => GroupModifier.fromJson(e as Map<String, dynamic>))
      .toList(),
  imageLinks: (json['imageLinks'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  doNotPrintInCheque: json['doNotPrintInCheque'] as bool?,
  parentGroup: json['parentGroup'] as String?,
  order: _parseIntNullable(json['order']),
  fullNameEnglish: json['fullNameEnglish'] as String?,
  useBalanceForSell: json['useBalanceForSell'] as bool?,
  canSetOpenPrice: json['canSetOpenPrice'] as bool?,
  id: json['id'] as String,
  code: json['code'] as String?,
  name: json['name'] as String,
  description: json['description'] as String?,
  additionalInfo: json['additionalInfo'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  isDeleted: json['isDeleted'] as bool?,
  seoDescription: json['seoDescription'] as String?,
  seoText: json['seoText'] as String?,
  seoKeywords: json['seoKeywords'] as String?,
  seoTitle: json['seoTitle'] as String?,
);

Map<String, dynamic> _$MenuProductToJson(MenuProduct instance) =>
    <String, dynamic>{
      'fatAmount': instance.fatAmount,
      'proteinsAmount': instance.proteinsAmount,
      'carbohydratesAmount': instance.carbohydratesAmount,
      'energyAmount': instance.energyAmount,
      'fatFullAmount': instance.fatFullAmount,
      'proteinsFullAmount': instance.proteinsFullAmount,
      'carbohydratesFullAmount': instance.carbohydratesFullAmount,
      'energyFullAmount': instance.energyFullAmount,
      'weight': instance.weight,
      'groupId': instance.groupId,
      'productCategoryId': instance.productCategoryId,
      'type': instance.type,
      'orderItemType': instance.orderItemType,
      'modifierSchemaId': instance.modifierSchemaId,
      'modifierSchemaName': instance.modifierSchemaName,
      'splittable': instance.splittable,
      'measureUnit': instance.measureUnit,
      'sizePrices': instance.sizePrices,
      'modifiers': instance.modifiers,
      'groupModifiers': instance.groupModifiers,
      'imageLinks': instance.imageLinks,
      'doNotPrintInCheque': instance.doNotPrintInCheque,
      'parentGroup': instance.parentGroup,
      'order': instance.order,
      'fullNameEnglish': instance.fullNameEnglish,
      'useBalanceForSell': instance.useBalanceForSell,
      'canSetOpenPrice': instance.canSetOpenPrice,
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'additionalInfo': instance.additionalInfo,
      'tags': instance.tags,
      'isDeleted': instance.isDeleted,
      'seoDescription': instance.seoDescription,
      'seoText': instance.seoText,
      'seoKeywords': instance.seoKeywords,
      'seoTitle': instance.seoTitle,
    };

SizePrice _$SizePriceFromJson(Map<String, dynamic> json) => SizePrice(
  sizeId: json['sizeId'] as String?,
  price: json['price'] == null
      ? null
      : Price.fromJson(json['price'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SizePriceToJson(SizePrice instance) => <String, dynamic>{
  'sizeId': instance.sizeId,
  'price': instance.price,
};

Price _$PriceFromJson(Map<String, dynamic> json) => Price(
  currentPrice: _parseNum(json['currentPrice']),
  isIncludedInMenu: json['isIncludedInMenu'] as bool?,
  nextPrice: _parseNum(json['nextPrice']),
  nextIncludedInMenu: json['nextIncludedInMenu'] as bool?,
  nextDatePrice: json['nextDatePrice'] as String?,
);

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
  'currentPrice': instance.currentPrice,
  'isIncludedInMenu': instance.isIncludedInMenu,
  'nextPrice': instance.nextPrice,
  'nextIncludedInMenu': instance.nextIncludedInMenu,
  'nextDatePrice': instance.nextDatePrice,
};

Modifier _$ModifierFromJson(Map<String, dynamic> json) => Modifier(
  id: json['id'] as String,
  defaultAmount: _parseIntNullable(json['defaultAmount']),
  minAmount: _parseIntNullable(json['minAmount']),
  maxAmount: _parseIntNullable(json['maxAmount']),
  required: json['required'] as bool?,
  hideIfDefaultAmount: json['hideIfDefaultAmount'] as bool?,
  splittable: json['splittable'] as bool?,
  freeOfChargeAmount: _parseIntNullable(json['freeOfChargeAmount']),
);

Map<String, dynamic> _$ModifierToJson(Modifier instance) => <String, dynamic>{
  'id': instance.id,
  'defaultAmount': instance.defaultAmount,
  'minAmount': instance.minAmount,
  'maxAmount': instance.maxAmount,
  'required': instance.required,
  'hideIfDefaultAmount': instance.hideIfDefaultAmount,
  'splittable': instance.splittable,
  'freeOfChargeAmount': instance.freeOfChargeAmount,
};

GroupModifier _$GroupModifierFromJson(Map<String, dynamic> json) =>
    GroupModifier(
      id: json['id'] as String,
      minAmount: _parseIntNullable(json['minAmount']),
      maxAmount: _parseIntNullable(json['maxAmount']),
      required: json['required'] as bool?,
      childModifiersHaveMinMaxRestrictions:
          json['childModifiersHaveMinMaxRestrictions'] as bool?,
      childModifiers: (json['childModifiers'] as List<dynamic>?)
          ?.map((e) => ChildModifier.fromJson(e as Map<String, dynamic>))
          .toList(),
      hideIfDefaultAmount: json['hideIfDefaultAmount'] as bool?,
      defaultAmount: _parseIntNullable(json['defaultAmount']),
      splittable: json['splittable'] as bool?,
      freeOfChargeAmount: _parseIntNullable(json['freeOfChargeAmount']),
    );

Map<String, dynamic> _$GroupModifierToJson(GroupModifier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'minAmount': instance.minAmount,
      'maxAmount': instance.maxAmount,
      'required': instance.required,
      'childModifiersHaveMinMaxRestrictions':
          instance.childModifiersHaveMinMaxRestrictions,
      'childModifiers': instance.childModifiers,
      'hideIfDefaultAmount': instance.hideIfDefaultAmount,
      'defaultAmount': instance.defaultAmount,
      'splittable': instance.splittable,
      'freeOfChargeAmount': instance.freeOfChargeAmount,
    };

ChildModifier _$ChildModifierFromJson(Map<String, dynamic> json) =>
    ChildModifier(
      id: json['id'] as String,
      defaultAmount: _parseIntNullable(json['defaultAmount']),
      minAmount: _parseIntNullable(json['minAmount']),
      maxAmount: _parseIntNullable(json['maxAmount']),
      required: json['required'] as bool?,
      hideIfDefaultAmount: json['hideIfDefaultAmount'] as bool?,
      splittable: json['splittable'] as bool?,
      freeOfChargeAmount: _parseIntNullable(json['freeOfChargeAmount']),
    );

Map<String, dynamic> _$ChildModifierToJson(ChildModifier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'defaultAmount': instance.defaultAmount,
      'minAmount': instance.minAmount,
      'maxAmount': instance.maxAmount,
      'required': instance.required,
      'hideIfDefaultAmount': instance.hideIfDefaultAmount,
      'splittable': instance.splittable,
      'freeOfChargeAmount': instance.freeOfChargeAmount,
    };

ProductSize _$ProductSizeFromJson(Map<String, dynamic> json) => ProductSize(
  id: json['id'] as String,
  name: json['name'] as String,
  priority: _parseIntNullable(json['priority']),
  isDefault: json['isDefault'] as bool?,
);

Map<String, dynamic> _$ProductSizeToJson(ProductSize instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'priority': instance.priority,
      'isDefault': instance.isDefault,
    };
