// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_list_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StopListRequest _$StopListRequestFromJson(Map<String, dynamic> json) =>
    StopListRequest(
      organizationIds: (json['organizationIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$StopListRequestToJson(StopListRequest instance) =>
    <String, dynamic>{'organizationIds': instance.organizationIds};

StopListResponse _$StopListResponseFromJson(Map<String, dynamic> json) =>
    StopListResponse(
      correlationId: json['correlationId'] as String?,
      terminalGroupStopLists: (json['terminalGroupStopLists'] as List<dynamic>)
          .map((e) => TerminalGroupStopList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StopListResponseToJson(StopListResponse instance) =>
    <String, dynamic>{
      'correlationId': instance.correlationId,
      'terminalGroupStopLists': instance.terminalGroupStopLists,
    };

TerminalGroupStopList _$TerminalGroupStopListFromJson(
  Map<String, dynamic> json,
) => TerminalGroupStopList(
  organizationId: json['organizationId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => StopListItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TerminalGroupStopListToJson(
  TerminalGroupStopList instance,
) => <String, dynamic>{
  'organizationId': instance.organizationId,
  'items': instance.items,
};

StopListItem _$StopListItemFromJson(Map<String, dynamic> json) => StopListItem(
  terminalGroupId: json['terminalGroupId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => StopListProduct.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StopListItemToJson(StopListItem instance) =>
    <String, dynamic>{
      'terminalGroupId': instance.terminalGroupId,
      'items': instance.items,
    };

StopListProduct _$StopListProductFromJson(Map<String, dynamic> json) =>
    StopListProduct(
      productId: json['productId'] as String,
      balance: _parseNum(json['balance']),
    );

Map<String, dynamic> _$StopListProductToJson(StopListProduct instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'balance': instance.balance,
    };
