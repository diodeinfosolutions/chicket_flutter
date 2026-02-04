import 'package:json_annotation/json_annotation.dart';

part 'stop_list_models.g.dart';

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

/// Request model for getting stop lists (out of stock items)
@JsonSerializable()
class StopListRequest {
  @JsonKey(name: 'organizationIds')
  final List<String> organizationIds;

  StopListRequest({required this.organizationIds});

  factory StopListRequest.fromJson(Map<String, dynamic> json) =>
      _$StopListRequestFromJson(json);
  Map<String, dynamic> toJson() => _$StopListRequestToJson(this);
}

/// Response model for stop lists
@JsonSerializable()
class StopListResponse {
  @JsonKey(name: 'correlationId')
  final String? correlationId;

  @JsonKey(name: 'terminalGroupStopLists')
  final List<TerminalGroupStopList> terminalGroupStopLists;

  StopListResponse({this.correlationId, required this.terminalGroupStopLists});

  factory StopListResponse.fromJson(Map<String, dynamic> json) =>
      _$StopListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StopListResponseToJson(this);
}

/// Terminal group stop list
@JsonSerializable()
class TerminalGroupStopList {
  @JsonKey(name: 'organizationId')
  final String organizationId;

  @JsonKey(name: 'items')
  final List<StopListItem> items;

  TerminalGroupStopList({required this.organizationId, required this.items});

  factory TerminalGroupStopList.fromJson(Map<String, dynamic> json) =>
      _$TerminalGroupStopListFromJson(json);
  Map<String, dynamic> toJson() => _$TerminalGroupStopListToJson(this);
}

/// Stop list item
@JsonSerializable()
class StopListItem {
  @JsonKey(name: 'terminalGroupId')
  final String terminalGroupId;

  @JsonKey(name: 'items')
  final List<StopListProduct> items;

  StopListItem({required this.terminalGroupId, required this.items});

  factory StopListItem.fromJson(Map<String, dynamic> json) =>
      _$StopListItemFromJson(json);
  Map<String, dynamic> toJson() => _$StopListItemToJson(this);
}

/// Stop list product (out of stock product)
@JsonSerializable()
class StopListProduct {
  @JsonKey(name: 'productId')
  final String productId;

  @JsonKey(name: 'balance', fromJson: _parseNum)
  final num? balance;

  StopListProduct({required this.productId, this.balance});

  factory StopListProduct.fromJson(Map<String, dynamic> json) =>
      _$StopListProductFromJson(json);
  Map<String, dynamic> toJson() => _$StopListProductToJson(this);
}
