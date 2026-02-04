// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentTypesRequest _$PaymentTypesRequestFromJson(Map<String, dynamic> json) =>
    PaymentTypesRequest(
      organizationIds: (json['organizationIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PaymentTypesRequestToJson(
  PaymentTypesRequest instance,
) => <String, dynamic>{'organizationIds': instance.organizationIds};

PaymentTypesResponse _$PaymentTypesResponseFromJson(
  Map<String, dynamic> json,
) => PaymentTypesResponse(
  correlationId: json['correlationId'] as String?,
  paymentTypes: (json['paymentTypes'] as List<dynamic>)
      .map((e) => PaymentType.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PaymentTypesResponseToJson(
  PaymentTypesResponse instance,
) => <String, dynamic>{
  'correlationId': instance.correlationId,
  'paymentTypes': instance.paymentTypes,
};

PaymentType _$PaymentTypeFromJson(Map<String, dynamic> json) => PaymentType(
  id: json['id'] as String,
  code: json['code'] as String?,
  name: json['name'] as String,
  comment: json['comment'] as String?,
  combinable: json['combinable'] as bool?,
  externalRevision: _parseIntNullable(json['externalRevision']),
  applicableMarketingCampaigns:
      (json['applicableMarketingCampaigns'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  isDeleted: json['isDeleted'] as bool?,
  printCheque: json['printCheque'] as bool?,
  paymentProcessingType: json['paymentProcessingType'] as String?,
  paymentTypeKind: json['paymentTypeKind'] as String?,
  terminalGroups: (json['terminalGroups'] as List<dynamic>?)
      ?.map((e) => TerminalGroupInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PaymentTypeToJson(PaymentType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'comment': instance.comment,
      'combinable': instance.combinable,
      'externalRevision': instance.externalRevision,
      'applicableMarketingCampaigns': instance.applicableMarketingCampaigns,
      'isDeleted': instance.isDeleted,
      'printCheque': instance.printCheque,
      'paymentProcessingType': instance.paymentProcessingType,
      'paymentTypeKind': instance.paymentTypeKind,
      'terminalGroups': instance.terminalGroups,
    };

TerminalGroupInfo _$TerminalGroupInfoFromJson(Map<String, dynamic> json) =>
    TerminalGroupInfo(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      timeZone: json['timeZone'] as String?,
    );

Map<String, dynamic> _$TerminalGroupInfoToJson(TerminalGroupInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'name': instance.name,
      'address': instance.address,
      'timeZone': instance.timeZone,
    };
