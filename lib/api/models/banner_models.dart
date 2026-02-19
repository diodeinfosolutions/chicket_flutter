import 'package:json_annotation/json_annotation.dart';

part 'banner_models.g.dart';

@JsonSerializable()
class BannerResponse {
  @JsonKey(name: 'status')
  final bool? status;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'data')
  final List<BannerData>? data;

  BannerResponse({this.status, this.message, this.data});

  factory BannerResponse.fromJson(Map<String, dynamic> json) =>
      _$BannerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BannerResponseToJson(this);
}

@JsonSerializable()
class BannerData {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'organization_id')
  final String? organizationId;

  @JsonKey(name: 'terminal_group_id')
  final String? terminalGroupId;

  @JsonKey(name: 'organization_name')
  final String? organizationName;

  @JsonKey(name: 'terminal_group_name')
  final String? terminalGroupName;

  @JsonKey(name: 'start_date')
  final String? startDate;

  @JsonKey(name: 'end_date')
  final String? endDate;

  @JsonKey(name: 'banner')
  final String? banner;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  BannerData({
    this.id,
    this.organizationId,
    this.terminalGroupId,
    this.organizationName,
    this.terminalGroupName,
    this.startDate,
    this.endDate,
    this.banner,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) =>
      _$BannerDataFromJson(json);

  Map<String, dynamic> toJson() => _$BannerDataToJson(this);
}
