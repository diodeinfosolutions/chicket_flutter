// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizationsRequest _$OrganizationsRequestFromJson(
  Map<String, dynamic> json,
) => OrganizationsRequest(
  organizationIds: (json['organizationIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  returnAdditionalInfo: json['returnAdditionalInfo'] as bool?,
  includeDisabled: json['includeDisabled'] as bool?,
);

Map<String, dynamic> _$OrganizationsRequestToJson(
  OrganizationsRequest instance,
) => <String, dynamic>{
  'organizationIds': instance.organizationIds,
  'returnAdditionalInfo': instance.returnAdditionalInfo,
  'includeDisabled': instance.includeDisabled,
};

OrganizationsResponse _$OrganizationsResponseFromJson(
  Map<String, dynamic> json,
) => OrganizationsResponse(
  correlationId: json['correlationId'] as String?,
  organizations: (json['organizations'] as List<dynamic>)
      .map((e) => Organization.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrganizationsResponseToJson(
  OrganizationsResponse instance,
) => <String, dynamic>{
  'correlationId': instance.correlationId,
  'organizations': instance.organizations,
};

Organization _$OrganizationFromJson(Map<String, dynamic> json) => Organization(
  id: json['id'] as String,
  name: json['name'] as String?,
  country: json['country'] as String?,
  restaurantAddress: json['restaurantAddress'] as String?,
  latitude: _parseNum(json['latitude']),
  longitude: _parseNum(json['longitude']),
  useUaeAddressingSystem: json['useUaeAddressingSystem'] as bool?,
  version: json['version'] as String?,
  currencyIsoName: json['currencyIsoName'] as String?,
  currencyMinimumDenomination: _parseNum(json['currencyMinimumDenomination']),
  countryPhoneCode: json['countryPhoneCode'] as String?,
  marketingSourceRequiredInDelivery:
      json['marketingSourceRequiredInDelivery'] as bool?,
  defaultDeliveryCityId: json['defaultDeliveryCityId'] as String?,
  deliveryCityIds: (json['deliveryCityIds'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  deliveryServiceType: json['deliveryServiceType'] as String?,
  defaultCallCenterPaymentTypeId:
      json['defaultCallCenterPaymentTypeId'] as String?,
  orderItemCommentEnabled: json['orderItemCommentEnabled'] as bool?,
  inn: json['inn'] as String?,
  addressFormatType: json['addressFormatType'] as String?,
  isConfirmationEnabled: json['isConfirmationEnabled'] as bool?,
  confirmAllowedIntervalInMinutes: _parseIntNullable(
    json['confirmAllowedIntervalInMinutes'],
  ),
);

Map<String, dynamic> _$OrganizationToJson(
  Organization instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'country': instance.country,
  'restaurantAddress': instance.restaurantAddress,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'useUaeAddressingSystem': instance.useUaeAddressingSystem,
  'version': instance.version,
  'currencyIsoName': instance.currencyIsoName,
  'currencyMinimumDenomination': instance.currencyMinimumDenomination,
  'countryPhoneCode': instance.countryPhoneCode,
  'marketingSourceRequiredInDelivery':
      instance.marketingSourceRequiredInDelivery,
  'defaultDeliveryCityId': instance.defaultDeliveryCityId,
  'deliveryCityIds': instance.deliveryCityIds,
  'deliveryServiceType': instance.deliveryServiceType,
  'defaultCallCenterPaymentTypeId': instance.defaultCallCenterPaymentTypeId,
  'orderItemCommentEnabled': instance.orderItemCommentEnabled,
  'inn': instance.inn,
  'addressFormatType': instance.addressFormatType,
  'isConfirmationEnabled': instance.isConfirmationEnabled,
  'confirmAllowedIntervalInMinutes': instance.confirmAllowedIntervalInMinutes,
};
