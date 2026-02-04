import 'package:json_annotation/json_annotation.dart';

part 'terminal_models.g.dart';

/// Request model for getting terminal groups
@JsonSerializable()
class TerminalGroupsRequest {
  @JsonKey(name: 'organizationIds')
  final List<String> organizationIds;

  @JsonKey(name: 'includeDisabled')
  final bool? includeDisabled;

  TerminalGroupsRequest({required this.organizationIds, this.includeDisabled});

  factory TerminalGroupsRequest.fromJson(Map<String, dynamic> json) =>
      _$TerminalGroupsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TerminalGroupsRequestToJson(this);
}

/// Response model for terminal groups
@JsonSerializable()
class TerminalGroupsResponse {
  @JsonKey(name: 'correlationId')
  final String? correlationId;

  @JsonKey(name: 'terminalGroups')
  final List<OrganizationTerminalGroups> terminalGroups;

  TerminalGroupsResponse({this.correlationId, required this.terminalGroups});

  factory TerminalGroupsResponse.fromJson(Map<String, dynamic> json) =>
      _$TerminalGroupsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TerminalGroupsResponseToJson(this);
}

/// Organization terminal groups
@JsonSerializable()
class OrganizationTerminalGroups {
  @JsonKey(name: 'organizationId')
  final String organizationId;

  @JsonKey(name: 'items')
  final List<TerminalGroup> items;

  OrganizationTerminalGroups({
    required this.organizationId,
    required this.items,
  });

  factory OrganizationTerminalGroups.fromJson(Map<String, dynamic> json) =>
      _$OrganizationTerminalGroupsFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizationTerminalGroupsToJson(this);
}

/// Terminal group model
@JsonSerializable()
class TerminalGroup {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'organizationId')
  final String? organizationId;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'address')
  final String? address;

  @JsonKey(name: 'timeZone')
  final String? timeZone;

  @JsonKey(name: 'isAlive')
  final bool? isAlive;

  TerminalGroup({
    required this.id,
    this.organizationId,
    this.name,
    this.address,
    this.timeZone,
    this.isAlive,
  });

  factory TerminalGroup.fromJson(Map<String, dynamic> json) =>
      _$TerminalGroupFromJson(json);
  Map<String, dynamic> toJson() => _$TerminalGroupToJson(this);
}
