import 'package:json_annotation/json_annotation.dart';

part 'organization_models.g.dart';

/// Parse any numeric value to num (handles int, double, string, null)
num? _parseNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) {
    final parsed = num.tryParse(value);
    if (parsed != null) return parsed;
  }
  return null;
}

/// Parse any numeric value to int (handles int, double, string, null)
int? _parseIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

/// Request model for getting organizations
@JsonSerializable()
class OrganizationsRequest {
  @JsonKey(name: 'organizationIds')
  final List<String>? organizationIds;

  @JsonKey(name: 'returnAdditionalInfo')
  final bool? returnAdditionalInfo;

  @JsonKey(name: 'includeDisabled')
  final bool? includeDisabled;

  OrganizationsRequest({
    this.organizationIds,
    this.returnAdditionalInfo,
    this.includeDisabled,
  });

  factory OrganizationsRequest.fromJson(Map<String, dynamic> json) =>
      _$OrganizationsRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizationsRequestToJson(this);
}

/// Response model for organizations
@JsonSerializable()
class OrganizationsResponse {
  @JsonKey(name: 'correlationId')
  final String? correlationId;

  @JsonKey(name: 'organizations')
  final List<Organization> organizations;

  OrganizationsResponse({this.correlationId, required this.organizations});

  factory OrganizationsResponse.fromJson(Map<String, dynamic> json) =>
      _$OrganizationsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizationsResponseToJson(this);
}

/// Organization model
@JsonSerializable()
class Organization {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'country')
  final String? country;

  @JsonKey(name: 'restaurantAddress')
  final String? restaurantAddress;

  @JsonKey(name: 'latitude', fromJson: _parseNum)
  final num? latitude;

  @JsonKey(name: 'longitude', fromJson: _parseNum)
  final num? longitude;

  @JsonKey(name: 'useUaeAddressingSystem')
  final bool? useUaeAddressingSystem;

  @JsonKey(name: 'version')
  final String? version;

  @JsonKey(name: 'currencyIsoName')
  final String? currencyIsoName;

  @JsonKey(name: 'currencyMinimumDenomination', fromJson: _parseNum)
  final num? currencyMinimumDenomination;

  @JsonKey(name: 'countryPhoneCode')
  final String? countryPhoneCode;

  @JsonKey(name: 'marketingSourceRequiredInDelivery')
  final bool? marketingSourceRequiredInDelivery;

  @JsonKey(name: 'defaultDeliveryCityId')
  final String? defaultDeliveryCityId;

  @JsonKey(name: 'deliveryCityIds')
  final List<String>? deliveryCityIds;

  @JsonKey(name: 'deliveryServiceType')
  final String? deliveryServiceType;

  @JsonKey(name: 'defaultCallCenterPaymentTypeId')
  final String? defaultCallCenterPaymentTypeId;

  @JsonKey(name: 'orderItemCommentEnabled')
  final bool? orderItemCommentEnabled;

  @JsonKey(name: 'inn')
  final String? inn;

  @JsonKey(name: 'addressFormatType')
  final String? addressFormatType;

  @JsonKey(name: 'isConfirmationEnabled')
  final bool? isConfirmationEnabled;

  @JsonKey(name: 'confirmAllowedIntervalInMinutes', fromJson: _parseIntNullable)
  final int? confirmAllowedIntervalInMinutes;

  Organization({
    required this.id,
    this.name,
    this.country,
    this.restaurantAddress,
    this.latitude,
    this.longitude,
    this.useUaeAddressingSystem,
    this.version,
    this.currencyIsoName,
    this.currencyMinimumDenomination,
    this.countryPhoneCode,
    this.marketingSourceRequiredInDelivery,
    this.defaultDeliveryCityId,
    this.deliveryCityIds,
    this.deliveryServiceType,
    this.defaultCallCenterPaymentTypeId,
    this.orderItemCommentEnabled,
    this.inn,
    this.addressFormatType,
    this.isConfirmationEnabled,
    this.confirmAllowedIntervalInMinutes,
  });

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizationToJson(this);
}
