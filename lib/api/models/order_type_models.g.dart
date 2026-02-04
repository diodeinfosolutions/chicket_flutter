// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_type_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderTypesRequest _$OrderTypesRequestFromJson(Map<String, dynamic> json) =>
    OrderTypesRequest(
      organizationIds: (json['organizationIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$OrderTypesRequestToJson(OrderTypesRequest instance) =>
    <String, dynamic>{'organizationIds': instance.organizationIds};

OrderTypesResponse _$OrderTypesResponseFromJson(Map<String, dynamic> json) =>
    OrderTypesResponse(
      correlationId: json['correlationId'] as String?,
      orderTypes: (json['orderTypes'] as List<dynamic>)
          .map(
            (e) => OrganizationOrderTypes.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$OrderTypesResponseToJson(OrderTypesResponse instance) =>
    <String, dynamic>{
      'correlationId': instance.correlationId,
      'orderTypes': instance.orderTypes,
    };

OrganizationOrderTypes _$OrganizationOrderTypesFromJson(
  Map<String, dynamic> json,
) => OrganizationOrderTypes(
  organizationId: json['organizationId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderType.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrganizationOrderTypesToJson(
  OrganizationOrderTypes instance,
) => <String, dynamic>{
  'organizationId': instance.organizationId,
  'items': instance.items,
};

OrderType _$OrderTypeFromJson(Map<String, dynamic> json) => OrderType(
  id: json['id'] as String,
  name: json['name'] as String,
  orderServiceType: json['orderServiceType'] as String,
  isDeleted: json['isDeleted'] as bool?,
  externalRevision: _parseIntNullable(json['externalRevision']),
);

Map<String, dynamic> _$OrderTypeToJson(OrderType instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'orderServiceType': instance.orderServiceType,
  'isDeleted': instance.isDeleted,
  'externalRevision': instance.externalRevision,
};
