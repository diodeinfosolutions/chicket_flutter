import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

/// Request model for getting access token
@JsonSerializable()
class AccessTokenRequest {
  @JsonKey(name: 'apiLogin')
  final String apiLogin;

  AccessTokenRequest({required this.apiLogin});

  factory AccessTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AccessTokenRequestToJson(this);
}

/// Response model for access token
@JsonSerializable()
class AccessTokenResponse {
  @JsonKey(name: 'correlationId')
  final String? correlationId;

  @JsonKey(name: 'token')
  final String token;

  AccessTokenResponse({this.correlationId, required this.token});

  factory AccessTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AccessTokenResponseToJson(this);
}
