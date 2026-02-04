import 'package:json_annotation/json_annotation.dart';

part 'payment_models.g.dart';

/// Parse any numeric value to int (handles int, double, string, null)
int? _parseIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

/// Request model for getting payment types
@JsonSerializable()
class PaymentTypesRequest {
  @JsonKey(name: 'organizationIds')
  final List<String> organizationIds;

  PaymentTypesRequest({required this.organizationIds});

  factory PaymentTypesRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentTypesRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentTypesRequestToJson(this);
}

/// Response model for payment types
@JsonSerializable()
class PaymentTypesResponse {
  @JsonKey(name: 'correlationId')
  final String? correlationId;

  @JsonKey(name: 'paymentTypes')
  final List<PaymentType> paymentTypes;

  PaymentTypesResponse({this.correlationId, required this.paymentTypes});

  factory PaymentTypesResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentTypesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentTypesResponseToJson(this);
}

/// Payment type model
@JsonSerializable()
class PaymentType {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'code')
  final String? code;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'comment')
  final String? comment;

  @JsonKey(name: 'combinable')
  final bool? combinable;

  @JsonKey(name: 'externalRevision', fromJson: _parseIntNullable)
  final int? externalRevision;

  @JsonKey(name: 'applicableMarketingCampaigns')
  final List<String>? applicableMarketingCampaigns;

  @JsonKey(name: 'isDeleted')
  final bool? isDeleted;

  @JsonKey(name: 'printCheque')
  final bool? printCheque;

  @JsonKey(name: 'paymentProcessingType')
  final String? paymentProcessingType;

  @JsonKey(name: 'paymentTypeKind')
  final String? paymentTypeKind;

  @JsonKey(name: 'terminalGroups')
  final List<TerminalGroupInfo>? terminalGroups;

  PaymentType({
    required this.id,
    this.code,
    required this.name,
    this.comment,
    this.combinable,
    this.externalRevision,
    this.applicableMarketingCampaigns,
    this.isDeleted,
    this.printCheque,
    this.paymentProcessingType,
    this.paymentTypeKind,
    this.terminalGroups,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) =>
      _$PaymentTypeFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentTypeToJson(this);
}

/// Terminal group info for payment types
@JsonSerializable()
class TerminalGroupInfo {
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

  TerminalGroupInfo({
    required this.id,
    this.organizationId,
    this.name,
    this.address,
    this.timeZone,
  });

  factory TerminalGroupInfo.fromJson(Map<String, dynamic> json) =>
      _$TerminalGroupInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TerminalGroupInfoToJson(this);
}
