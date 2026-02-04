import 'package:json_annotation/json_annotation.dart';

part 'order_type_models.g.dart';

/// Parse any numeric value to int (handles int, double, string, null)
int? _parseIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

/// Request model for getting order types
@JsonSerializable()
class OrderTypesRequest {
  @JsonKey(name: 'organizationIds')
  final List<String> organizationIds;

  OrderTypesRequest({required this.organizationIds});

  factory OrderTypesRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderTypesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OrderTypesRequestToJson(this);
}

/// Response model for order types
@JsonSerializable()
class OrderTypesResponse {
  @JsonKey(name: 'correlationId')
  final String? correlationId;

  @JsonKey(name: 'orderTypes')
  final List<OrganizationOrderTypes> orderTypes;

  OrderTypesResponse({this.correlationId, required this.orderTypes});

  factory OrderTypesResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderTypesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OrderTypesResponseToJson(this);
}

/// Organization order types
@JsonSerializable()
class OrganizationOrderTypes {
  @JsonKey(name: 'organizationId')
  final String organizationId;

  @JsonKey(name: 'items')
  final List<OrderType> items;

  OrganizationOrderTypes({required this.organizationId, required this.items});

  factory OrganizationOrderTypes.fromJson(Map<String, dynamic> json) =>
      _$OrganizationOrderTypesFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizationOrderTypesToJson(this);
}

/// Order type model
@JsonSerializable()
class OrderType {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'orderServiceType')
  final String orderServiceType;

  @JsonKey(name: 'isDeleted')
  final bool? isDeleted;

  @JsonKey(name: 'externalRevision', fromJson: _parseIntNullable)
  final int? externalRevision;

  OrderType({
    required this.id,
    required this.name,
    required this.orderServiceType,
    this.isDeleted,
    this.externalRevision,
  });

  factory OrderType.fromJson(Map<String, dynamic> json) =>
      _$OrderTypeFromJson(json);
  Map<String, dynamic> toJson() => _$OrderTypeToJson(this);
}
