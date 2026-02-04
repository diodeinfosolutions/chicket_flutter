// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenRequest _$AccessTokenRequestFromJson(Map<String, dynamic> json) =>
    AccessTokenRequest(apiLogin: json['apiLogin'] as String);

Map<String, dynamic> _$AccessTokenRequestToJson(AccessTokenRequest instance) =>
    <String, dynamic>{'apiLogin': instance.apiLogin};

AccessTokenResponse _$AccessTokenResponseFromJson(Map<String, dynamic> json) =>
    AccessTokenResponse(
      correlationId: json['correlationId'] as String?,
      token: json['token'] as String,
    );

Map<String, dynamic> _$AccessTokenResponseToJson(
  AccessTokenResponse instance,
) => <String, dynamic>{
  'correlationId': instance.correlationId,
  'token': instance.token,
};
