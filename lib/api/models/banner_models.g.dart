// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerResponse _$BannerResponseFromJson(Map<String, dynamic> json) =>
    BannerResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BannerData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BannerResponseToJson(BannerResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

BannerData _$BannerDataFromJson(Map<String, dynamic> json) => BannerData(
  id: (json['id'] as num?)?.toInt(),
  organizationId: json['organization_id'] as String?,
  terminalGroupId: json['terminal_group_id'] as String?,
  organizationName: json['organization_name'] as String?,
  terminalGroupName: json['terminal_group_name'] as String?,
  startDate: json['start_date'] as String?,
  endDate: json['end_date'] as String?,
  banner: json['banner'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$BannerDataToJson(BannerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization_id': instance.organizationId,
      'terminal_group_id': instance.terminalGroupId,
      'organization_name': instance.organizationName,
      'terminal_group_name': instance.terminalGroupName,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'banner': instance.banner,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
