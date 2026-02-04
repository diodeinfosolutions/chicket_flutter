// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminal_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TerminalGroupsRequest _$TerminalGroupsRequestFromJson(
  Map<String, dynamic> json,
) => TerminalGroupsRequest(
  organizationIds: (json['organizationIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  includeDisabled: json['includeDisabled'] as bool?,
);

Map<String, dynamic> _$TerminalGroupsRequestToJson(
  TerminalGroupsRequest instance,
) => <String, dynamic>{
  'organizationIds': instance.organizationIds,
  'includeDisabled': instance.includeDisabled,
};

TerminalGroupsResponse _$TerminalGroupsResponseFromJson(
  Map<String, dynamic> json,
) => TerminalGroupsResponse(
  correlationId: json['correlationId'] as String?,
  terminalGroups: (json['terminalGroups'] as List<dynamic>)
      .map(
        (e) => OrganizationTerminalGroups.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$TerminalGroupsResponseToJson(
  TerminalGroupsResponse instance,
) => <String, dynamic>{
  'correlationId': instance.correlationId,
  'terminalGroups': instance.terminalGroups,
};

OrganizationTerminalGroups _$OrganizationTerminalGroupsFromJson(
  Map<String, dynamic> json,
) => OrganizationTerminalGroups(
  organizationId: json['organizationId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => TerminalGroup.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrganizationTerminalGroupsToJson(
  OrganizationTerminalGroups instance,
) => <String, dynamic>{
  'organizationId': instance.organizationId,
  'items': instance.items,
};

TerminalGroup _$TerminalGroupFromJson(Map<String, dynamic> json) =>
    TerminalGroup(
      id: json['id'] as String,
      organizationId: json['organizationId'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      timeZone: json['timeZone'] as String?,
      isAlive: json['isAlive'] as bool?,
    );

Map<String, dynamic> _$TerminalGroupToJson(TerminalGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organizationId': instance.organizationId,
      'name': instance.name,
      'address': instance.address,
      'timeZone': instance.timeZone,
      'isAlive': instance.isAlive,
    };
