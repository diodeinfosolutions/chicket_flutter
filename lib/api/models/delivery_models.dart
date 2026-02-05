import 'package:json_annotation/json_annotation.dart';

part 'delivery_models.g.dart';

// ============================================================================
// Helper functions for parsing numeric values
// ============================================================================

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

// ============================================================================
// Request Models
// ============================================================================

/// Request model for creating a delivery order
@JsonSerializable()
class CreateDeliveryRequest {
  @JsonKey(name: 'organizationId')
  final String organizationId;

  @JsonKey(name: 'terminalGroupId')
  final String? terminalGroupId;

  @JsonKey(name: 'order')
  final DeliveryOrder order;

  @JsonKey(name: 'createOrderSettings')
  final CreateOrderSettings? createOrderSettings;

  CreateDeliveryRequest({
    required this.organizationId,
    this.terminalGroupId,
    required this.order,
    this.createOrderSettings,
  });

  factory CreateDeliveryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateDeliveryRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateDeliveryRequestToJson(this);
}

/// Create order settings
@JsonSerializable()
class CreateOrderSettings {
  @JsonKey(name: 'transportToFrontTimeout', fromJson: _parseIntNullable)
  final int? transportToFrontTimeout;

  CreateOrderSettings({this.transportToFrontTimeout});

  factory CreateOrderSettings.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$CreateOrderSettingsToJson(this);
}

/// Delivery order model
@JsonSerializable()
class DeliveryOrder {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'externalNumber')
  final String? externalNumber;

  @JsonKey(name: 'completeBefore')
  final String? completeBefore;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'orderTypeId')
  final String? orderTypeId;

  @JsonKey(name: 'orderServiceType')
  final String? orderServiceType;

  @JsonKey(name: 'deliveryPoint')
  final DeliveryPoint? deliveryPoint;

  @JsonKey(name: 'comment')
  final String? comment;

  @JsonKey(name: 'customer')
  final Customer? customer;

  @JsonKey(name: 'guests')
  final Guests? guests;

  @JsonKey(name: 'marketingSourceId')
  final String? marketingSourceId;

  @JsonKey(name: 'operatorId')
  final String? operatorId;

  @JsonKey(name: 'items')
  final List<OrderItem> items;

  @JsonKey(name: 'combos')
  final List<OrderCombo>? combos;

  @JsonKey(name: 'payments')
  final List<OrderPayment>? payments;

  @JsonKey(name: 'tips')
  final List<OrderTip>? tips;

  @JsonKey(name: 'sourceKey')
  final String? sourceKey;

  @JsonKey(name: 'discountsInfo')
  final DiscountsInfo? discountsInfo;

  @JsonKey(name: 'iikoCard5Info')
  final IikoCard5Info? iikoCard5Info;

  DeliveryOrder({
    this.id,
    this.externalNumber,
    this.completeBefore,
    this.phone,
    this.orderTypeId,
    this.orderServiceType,
    this.deliveryPoint,
    this.comment,
    this.customer,
    this.guests,
    this.marketingSourceId,
    this.operatorId,
    required this.items,
    this.combos,
    this.payments,
    this.tips,
    this.sourceKey,
    this.discountsInfo,
    this.iikoCard5Info,
  });

  factory DeliveryOrder.fromJson(Map<String, dynamic> json) =>
      _$DeliveryOrderFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryOrderToJson(this);
}

/// Delivery point (address)
@JsonSerializable()
class DeliveryPoint {
  @JsonKey(name: 'coordinates')
  final Coordinates? coordinates;

  @JsonKey(name: 'address')
  final Address? address;

  @JsonKey(name: 'externalCartographyId')
  final String? externalCartographyId;

  @JsonKey(name: 'comment')
  final String? comment;

  DeliveryPoint({
    this.coordinates,
    this.address,
    this.externalCartographyId,
    this.comment,
  });

  factory DeliveryPoint.fromJson(Map<String, dynamic> json) =>
      _$DeliveryPointFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryPointToJson(this);
}

/// Coordinates
@JsonSerializable()
class Coordinates {
  @JsonKey(name: 'latitude', fromJson: _parseNum)
  final num? latitude;

  @JsonKey(name: 'longitude', fromJson: _parseNum)
  final num? longitude;

  Coordinates({this.latitude, this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);
  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}

/// Address
@JsonSerializable()
class Address {
  @JsonKey(name: 'street')
  final Street? street;

  @JsonKey(name: 'index')
  final String? index;

  @JsonKey(name: 'house')
  final String? house;

  @JsonKey(name: 'building')
  final String? building;

  @JsonKey(name: 'flat')
  final String? flat;

  @JsonKey(name: 'entrance')
  final String? entrance;

  @JsonKey(name: 'floor')
  final String? floor;

  @JsonKey(name: 'doorphone')
  final String? doorphone;

  @JsonKey(name: 'region')
  final String? region;

  @JsonKey(name: 'line1')
  final String? line1;

  @JsonKey(name: 'line2')
  final String? line2;

  Address({
    this.street,
    this.index,
    this.house,
    this.building,
    this.flat,
    this.entrance,
    this.floor,
    this.doorphone,
    this.region,
    this.line1,
    this.line2,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

/// Street
@JsonSerializable()
class Street {
  @JsonKey(name: 'classifierId')
  final String? classifierId;

  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'city')
  final String? city;

  Street({this.classifierId, this.id, this.name, this.city});

  factory Street.fromJson(Map<String, dynamic> json) => _$StreetFromJson(json);
  Map<String, dynamic> toJson() => _$StreetToJson(this);
}

/// Customer
@JsonSerializable()
class Customer {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'surname')
  final String? surname;

  @JsonKey(name: 'comment')
  final String? comment;

  @JsonKey(name: 'birthdate')
  final String? birthdate;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'shouldReceiveOrderStatusNotifications')
  final bool? shouldReceiveOrderStatusNotifications;

  @JsonKey(name: 'shouldReceivePromoActionsInfo')
  final bool? shouldReceivePromoActionsInfo;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'gender')
  final String? gender;

  @JsonKey(name: 'inBlacklist')
  final bool? inBlacklist;

  @JsonKey(name: 'blacklistReason')
  final String? blacklistReason;

  Customer({
    this.id,
    this.name,
    this.surname,
    this.comment,
    this.birthdate,
    this.email,
    this.shouldReceiveOrderStatusNotifications,
    this.shouldReceivePromoActionsInfo,
    this.type,
    this.gender,
    this.inBlacklist,
    this.blacklistReason,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

/// Guests
@JsonSerializable()
class Guests {
  @JsonKey(name: 'count', fromJson: _parseIntNullable)
  final int? count;

  @JsonKey(name: 'splitBetweenPersons')
  final bool? splitBetweenPersons;

  Guests({this.count, this.splitBetweenPersons});

  factory Guests.fromJson(Map<String, dynamic> json) => _$GuestsFromJson(json);
  Map<String, dynamic> toJson() => _$GuestsToJson(this);
}

/// Order item (product in cart)
@JsonSerializable()
class OrderItem {
  @JsonKey(name: 'productId')
  final String productId;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'amount', fromJson: _parseNum)
  final num? amount;

  @JsonKey(name: 'productSizeId')
  final String? productSizeId;

  @JsonKey(name: 'comboInformation')
  final ComboInformation? comboInformation;

  @JsonKey(name: 'modifiers')
  final List<OrderItemModifier>? modifiers;

  @JsonKey(name: 'price', fromJson: _parseNum)
  final num? price;

  @JsonKey(name: 'positionId')
  final String? positionId;

  @JsonKey(name: 'comment')
  final String? comment;

  OrderItem({
    required this.productId,
    this.type,
    this.amount,
    this.productSizeId,
    this.comboInformation,
    this.modifiers,
    this.price,
    this.positionId,
    this.comment,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

/// Combo information
@JsonSerializable()
class ComboInformation {
  @JsonKey(name: 'comboId')
  final String comboId;

  @JsonKey(name: 'comboSourceId')
  final String comboSourceId;

  @JsonKey(name: 'comboGroupId')
  final String comboGroupId;

  ComboInformation({
    required this.comboId,
    required this.comboSourceId,
    required this.comboGroupId,
  });

  factory ComboInformation.fromJson(Map<String, dynamic> json) =>
      _$ComboInformationFromJson(json);
  Map<String, dynamic> toJson() => _$ComboInformationToJson(this);
}

/// Order item modifier
@JsonSerializable()
class OrderItemModifier {
  @JsonKey(name: 'productId')
  final String productId;

  @JsonKey(name: 'amount', fromJson: _parseNum)
  final num? amount;

  @JsonKey(name: 'productGroupId')
  final String? productGroupId;

  @JsonKey(name: 'price', fromJson: _parseNum)
  final num? price;

  @JsonKey(name: 'positionId')
  final String? positionId;

  OrderItemModifier({
    required this.productId,
    this.amount,
    this.productGroupId,
    this.price,
    this.positionId,
  });

  factory OrderItemModifier.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModifierFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemModifierToJson(this);
}

/// Order combo
@JsonSerializable()
class OrderCombo {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'amount', fromJson: _parseIntNullable)
  final int? amount;

  @JsonKey(name: 'price', fromJson: _parseNum)
  final num? price;

  @JsonKey(name: 'sourceId')
  final String sourceId;

  @JsonKey(name: 'programId')
  final String? programId;

  OrderCombo({
    required this.id,
    required this.name,
    this.amount,
    this.price,
    required this.sourceId,
    this.programId,
  });

  factory OrderCombo.fromJson(Map<String, dynamic> json) =>
      _$OrderComboFromJson(json);
  Map<String, dynamic> toJson() => _$OrderComboToJson(this);
}

/// Order payment
@JsonSerializable(includeIfNull: false)
class OrderPayment {
  @JsonKey(name: 'paymentTypeKind')
  final String paymentTypeKind;

  @JsonKey(name: 'sum', fromJson: _parseNum)
  final num? sum;

  @JsonKey(name: 'paymentTypeId')
  final String paymentTypeId;

  @JsonKey(name: 'isProcessedExternally')
  final bool? isProcessedExternally;

  @JsonKey(name: 'isPreliminary')
  final bool? isPreliminary;

  @JsonKey(name: 'isExternal')
  final bool? isExternal;

  @JsonKey(name: 'isFiscalizedExternally')
  final bool? isFiscalizedExternally;

  OrderPayment({
    required this.paymentTypeKind,
    this.sum,
    required this.paymentTypeId,
    this.isProcessedExternally,
    this.isPreliminary,
    this.isExternal,
    this.isFiscalizedExternally,
  });

  factory OrderPayment.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentFromJson(json);
  Map<String, dynamic> toJson() => _$OrderPaymentToJson(this);
}

/// Order tip
@JsonSerializable()
class OrderTip {
  @JsonKey(name: 'paymentTypeKind')
  final String paymentTypeKind;

  @JsonKey(name: 'sum', fromJson: _parseNum)
  final num? sum;

  @JsonKey(name: 'paymentTypeId')
  final String paymentTypeId;

  @JsonKey(name: 'isProcessedExternally')
  final bool? isProcessedExternally;

  @JsonKey(name: 'isPreliminary')
  final bool? isPreliminary;

  @JsonKey(name: 'isExternal')
  final bool? isExternal;

  @JsonKey(name: 'isFiscalizedExternally')
  final bool? isFiscalizedExternally;

  @JsonKey(name: 'tipsTypeId')
  final String? tipsTypeId;

  OrderTip({
    required this.paymentTypeKind,
    this.sum,
    required this.paymentTypeId,
    this.isProcessedExternally,
    this.isPreliminary,
    this.isExternal,
    this.isFiscalizedExternally,
    this.tipsTypeId,
  });

  factory OrderTip.fromJson(Map<String, dynamic> json) =>
      _$OrderTipFromJson(json);
  Map<String, dynamic> toJson() => _$OrderTipToJson(this);
}

/// Discounts info
@JsonSerializable()
class DiscountsInfo {
  @JsonKey(name: 'card')
  final DiscountCard? card;

  @JsonKey(name: 'discounts')
  final List<Discount>? discounts;

  DiscountsInfo({this.card, this.discounts});

  factory DiscountsInfo.fromJson(Map<String, dynamic> json) =>
      _$DiscountsInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DiscountsInfoToJson(this);
}

/// Discount card
@JsonSerializable()
class DiscountCard {
  @JsonKey(name: 'track')
  final String? track;

  @JsonKey(name: 'number')
  final String? number;

  DiscountCard({this.track, this.number});

  factory DiscountCard.fromJson(Map<String, dynamic> json) =>
      _$DiscountCardFromJson(json);
  Map<String, dynamic> toJson() => _$DiscountCardToJson(this);
}

/// Discount
@JsonSerializable()
class Discount {
  @JsonKey(name: 'discountTypeId')
  final String discountTypeId;

  @JsonKey(name: 'sum', fromJson: _parseNum)
  final num? sum;

  @JsonKey(name: 'selectivePositions')
  final List<String>? selectivePositions;

  Discount({required this.discountTypeId, this.sum, this.selectivePositions});

  factory Discount.fromJson(Map<String, dynamic> json) =>
      _$DiscountFromJson(json);
  Map<String, dynamic> toJson() => _$DiscountToJson(this);
}

/// iiko Card 5 info
@JsonSerializable()
class IikoCard5Info {
  @JsonKey(name: 'coupon')
  final String? coupon;

  @JsonKey(name: 'applicableManualConditions')
  final List<String>? applicableManualConditions;

  IikoCard5Info({this.coupon, this.applicableManualConditions});

  factory IikoCard5Info.fromJson(Map<String, dynamic> json) =>
      _$IikoCard5InfoFromJson(json);
  Map<String, dynamic> toJson() => _$IikoCard5InfoToJson(this);
}

// ============================================================================
// Response Models
// ============================================================================

/// Response model for create delivery
@JsonSerializable()
class CreateDeliveryResponse {
  @JsonKey(name: 'correlationId')
  final String? correlationId;

  @JsonKey(name: 'orderInfo')
  final OrderInfo? orderInfo;

  CreateDeliveryResponse({this.correlationId, this.orderInfo});

  factory CreateDeliveryResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateDeliveryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateDeliveryResponseToJson(this);
}

/// Order info from response
@JsonSerializable()
class OrderInfo {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'posId')
  final String? posId;

  @JsonKey(name: 'externalNumber')
  final String? externalNumber;

  @JsonKey(name: 'organizationId')
  final String? organizationId;

  @JsonKey(name: 'timestamp', fromJson: _parseIntNullable)
  final int? timestamp;

  @JsonKey(name: 'creationStatus')
  final String? creationStatus;

  @JsonKey(name: 'errorInfo')
  final ErrorInfo? errorInfo;

  @JsonKey(name: 'order')
  final OrderDetails? order;

  OrderInfo({
    required this.id,
    this.posId,
    this.externalNumber,
    this.organizationId,
    this.timestamp,
    this.creationStatus,
    this.errorInfo,
    this.order,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) =>
      _$OrderInfoFromJson(json);
  Map<String, dynamic> toJson() => _$OrderInfoToJson(this);
}

/// Error info
@JsonSerializable()
class ErrorInfo {
  @JsonKey(name: 'code')
  final String? code;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'additionalData')
  final String? additionalData;

  ErrorInfo({this.code, this.message, this.description, this.additionalData});

  factory ErrorInfo.fromJson(Map<String, dynamic> json) =>
      _$ErrorInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorInfoToJson(this);
}

/// Order details from response
@JsonSerializable()
class OrderDetails {
  @JsonKey(name: 'parentDeliveryId')
  final String? parentDeliveryId;

  @JsonKey(name: 'customer')
  final Customer? customer;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'deliveryPoint')
  final DeliveryPoint? deliveryPoint;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'cancelInfo')
  final CancelInfo? cancelInfo;

  @JsonKey(name: 'courierInfo')
  final CourierInfo? courierInfo;

  @JsonKey(name: 'completeBefore')
  final String? completeBefore;

  @JsonKey(name: 'whenCreated')
  final String? whenCreated;

  @JsonKey(name: 'whenConfirmed')
  final String? whenConfirmed;

  @JsonKey(name: 'whenPrinted')
  final String? whenPrinted;

  @JsonKey(name: 'whenSended')
  final String? whenSended;

  @JsonKey(name: 'whenDelivered')
  final String? whenDelivered;

  @JsonKey(name: 'comment')
  final String? comment;

  @JsonKey(name: 'problem')
  final Problem? problem;

  @JsonKey(name: 'operator')
  final Operator? operator;

  @JsonKey(name: 'marketingSource')
  final MarketingSource? marketingSource;

  @JsonKey(name: 'deliveryDuration', fromJson: _parseIntNullable)
  final int? deliveryDuration;

  @JsonKey(name: 'indexInCookingQueue', fromJson: _parseIntNullable)
  final int? indexInCookingQueue;

  @JsonKey(name: 'cookingStartTime')
  final String? cookingStartTime;

  @JsonKey(name: 'isDeleted')
  final bool? isDeleted;

  @JsonKey(name: 'whenReceivedByApi')
  final String? whenReceivedByApi;

  @JsonKey(name: 'whenReceivedFromFront')
  final String? whenReceivedFromFront;

  @JsonKey(name: 'movedFromDeliveryId')
  final String? movedFromDeliveryId;

  @JsonKey(name: 'movedFromTerminalGroupId')
  final String? movedFromTerminalGroupId;

  @JsonKey(name: 'movedFromOrganizationId')
  final String? movedFromOrganizationId;

  @JsonKey(name: 'sum', fromJson: _parseNum)
  final num? sum;

  @JsonKey(name: 'number', fromJson: _parseIntNullable)
  final int? number;

  @JsonKey(name: 'sourceKey')
  final String? sourceKey;

  @JsonKey(name: 'whenBillPrinted')
  final String? whenBillPrinted;

  @JsonKey(name: 'whenClosed')
  final String? whenClosed;

  @JsonKey(name: 'conception')
  final Conception? conception;

  @JsonKey(name: 'guestsInfo')
  final GuestsInfo? guestsInfo;

  @JsonKey(name: 'items')
  final List<OrderItemResponse>? items;

  @JsonKey(name: 'combos')
  final List<OrderCombo>? combos;

  @JsonKey(name: 'payments')
  final List<OrderPaymentResponse>? payments;

  @JsonKey(name: 'tips')
  final List<OrderTip>? tips;

  @JsonKey(name: 'discounts')
  final List<DiscountResponse>? discounts;

  @JsonKey(name: 'orderType')
  final OrderTypeInfo? orderType;

  @JsonKey(name: 'terminalGroupId')
  final String? terminalGroupId;

  @JsonKey(name: 'processedPaymentsSum', fromJson: _parseNum)
  final num? processedPaymentsSum;

  OrderDetails({
    this.parentDeliveryId,
    this.customer,
    this.phone,
    this.deliveryPoint,
    this.status,
    this.cancelInfo,
    this.courierInfo,
    this.completeBefore,
    this.whenCreated,
    this.whenConfirmed,
    this.whenPrinted,
    this.whenSended,
    this.whenDelivered,
    this.comment,
    this.problem,
    this.operator,
    this.marketingSource,
    this.deliveryDuration,
    this.indexInCookingQueue,
    this.cookingStartTime,
    this.isDeleted,
    this.whenReceivedByApi,
    this.whenReceivedFromFront,
    this.movedFromDeliveryId,
    this.movedFromTerminalGroupId,
    this.movedFromOrganizationId,
    this.sum,
    this.number,
    this.sourceKey,
    this.whenBillPrinted,
    this.whenClosed,
    this.conception,
    this.guestsInfo,
    this.items,
    this.combos,
    this.payments,
    this.tips,
    this.discounts,
    this.orderType,
    this.terminalGroupId,
    this.processedPaymentsSum,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDetailsToJson(this);
}

/// Cancel info
@JsonSerializable()
class CancelInfo {
  @JsonKey(name: 'whenCancelled')
  final String? whenCancelled;

  @JsonKey(name: 'cause')
  final CancelCause? cause;

  @JsonKey(name: 'comment')
  final String? comment;

  CancelInfo({this.whenCancelled, this.cause, this.comment});

  factory CancelInfo.fromJson(Map<String, dynamic> json) =>
      _$CancelInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CancelInfoToJson(this);
}

/// Cancel cause
@JsonSerializable()
class CancelCause {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  CancelCause({this.id, this.name});

  factory CancelCause.fromJson(Map<String, dynamic> json) =>
      _$CancelCauseFromJson(json);
  Map<String, dynamic> toJson() => _$CancelCauseToJson(this);
}

/// Courier info
@JsonSerializable()
class CourierInfo {
  @JsonKey(name: 'courier')
  final Courier? courier;

  @JsonKey(name: 'isCourierSelectedManually')
  final bool? isCourierSelectedManually;

  CourierInfo({this.courier, this.isCourierSelectedManually});

  factory CourierInfo.fromJson(Map<String, dynamic> json) =>
      _$CourierInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CourierInfoToJson(this);
}

/// Courier
@JsonSerializable()
class Courier {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'phone')
  final String? phone;

  Courier({this.id, this.name, this.phone});

  factory Courier.fromJson(Map<String, dynamic> json) =>
      _$CourierFromJson(json);
  Map<String, dynamic> toJson() => _$CourierToJson(this);
}

/// Problem
@JsonSerializable()
class Problem {
  @JsonKey(name: 'hasProblem')
  final bool? hasProblem;

  @JsonKey(name: 'description')
  final String? description;

  Problem({this.hasProblem, this.description});

  factory Problem.fromJson(Map<String, dynamic> json) =>
      _$ProblemFromJson(json);
  Map<String, dynamic> toJson() => _$ProblemToJson(this);
}

/// Operator
@JsonSerializable()
class Operator {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'phone')
  final String? phone;

  Operator({this.id, this.name, this.phone});

  factory Operator.fromJson(Map<String, dynamic> json) =>
      _$OperatorFromJson(json);
  Map<String, dynamic> toJson() => _$OperatorToJson(this);
}

/// Marketing source
@JsonSerializable()
class MarketingSource {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  MarketingSource({this.id, this.name});

  factory MarketingSource.fromJson(Map<String, dynamic> json) =>
      _$MarketingSourceFromJson(json);
  Map<String, dynamic> toJson() => _$MarketingSourceToJson(this);
}

/// Conception
@JsonSerializable()
class Conception {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'code')
  final String? code;

  Conception({this.id, this.name, this.code});

  factory Conception.fromJson(Map<String, dynamic> json) =>
      _$ConceptionFromJson(json);
  Map<String, dynamic> toJson() => _$ConceptionToJson(this);
}

/// Guests info
@JsonSerializable()
class GuestsInfo {
  @JsonKey(name: 'count', fromJson: _parseIntNullable)
  final int? count;

  @JsonKey(name: 'splitBetweenPersons')
  final bool? splitBetweenPersons;

  GuestsInfo({this.count, this.splitBetweenPersons});

  factory GuestsInfo.fromJson(Map<String, dynamic> json) =>
      _$GuestsInfoFromJson(json);
  Map<String, dynamic> toJson() => _$GuestsInfoToJson(this);
}

/// Order item response
@JsonSerializable()
class OrderItemResponse {
  @JsonKey(name: 'product')
  final ProductInfo? product;

  @JsonKey(name: 'modifiers')
  final List<ModifierResponse>? modifiers;

  @JsonKey(name: 'price', fromJson: _parseNum)
  final num? price;

  @JsonKey(name: 'cost', fromJson: _parseNum)
  final num? cost;

  @JsonKey(name: 'pricePredefined')
  final bool? pricePredefined;

  @JsonKey(name: 'positionId')
  final String? positionId;

  @JsonKey(name: 'taxPercent', fromJson: _parseNum)
  final num? taxPercent;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'deleted')
  final bool? deleted;

  @JsonKey(name: 'amount', fromJson: _parseNum)
  final num? amount;

  @JsonKey(name: 'comment')
  final String? comment;

  @JsonKey(name: 'whenPrinted')
  final String? whenPrinted;

  @JsonKey(name: 'size')
  final SizeInfo? size;

  @JsonKey(name: 'comboInformation')
  final ComboInformation? comboInformation;

  OrderItemResponse({
    this.product,
    this.modifiers,
    this.price,
    this.cost,
    this.pricePredefined,
    this.positionId,
    this.taxPercent,
    this.type,
    this.status,
    this.deleted,
    this.amount,
    this.comment,
    this.whenPrinted,
    this.size,
    this.comboInformation,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemResponseToJson(this);
}

/// Product info
@JsonSerializable()
class ProductInfo {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  ProductInfo({this.id, this.name});

  factory ProductInfo.fromJson(Map<String, dynamic> json) =>
      _$ProductInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ProductInfoToJson(this);
}

/// Modifier response
@JsonSerializable()
class ModifierResponse {
  @JsonKey(name: 'product')
  final ProductInfo? product;

  @JsonKey(name: 'amount', fromJson: _parseNum)
  final num? amount;

  @JsonKey(name: 'amountIndependentOfParentAmount', fromJson: _parseNum)
  final num? amountIndependentOfParentAmount;

  @JsonKey(name: 'productGroup')
  final ProductGroupInfo? productGroup;

  @JsonKey(name: 'price', fromJson: _parseNum)
  final num? price;

  @JsonKey(name: 'pricePredefined')
  final bool? pricePredefined;

  @JsonKey(name: 'positionId')
  final String? positionId;

  @JsonKey(name: 'defaultAmount', fromJson: _parseIntNullable)
  final int? defaultAmount;

  @JsonKey(name: 'hideIfDefaultAmount')
  final bool? hideIfDefaultAmount;

  @JsonKey(name: 'deleted')
  final bool? deleted;

  ModifierResponse({
    this.product,
    this.amount,
    this.amountIndependentOfParentAmount,
    this.productGroup,
    this.price,
    this.pricePredefined,
    this.positionId,
    this.defaultAmount,
    this.hideIfDefaultAmount,
    this.deleted,
  });

  factory ModifierResponse.fromJson(Map<String, dynamic> json) =>
      _$ModifierResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ModifierResponseToJson(this);
}

/// Product group info
@JsonSerializable()
class ProductGroupInfo {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  ProductGroupInfo({this.id, this.name});

  factory ProductGroupInfo.fromJson(Map<String, dynamic> json) =>
      _$ProductGroupInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ProductGroupInfoToJson(this);
}

/// Size info
@JsonSerializable()
class SizeInfo {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  SizeInfo({this.id, this.name});

  factory SizeInfo.fromJson(Map<String, dynamic> json) =>
      _$SizeInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SizeInfoToJson(this);
}

/// Order payment response
@JsonSerializable()
class OrderPaymentResponse {
  @JsonKey(name: 'paymentType')
  final PaymentTypeInfo? paymentType;

  @JsonKey(name: 'sum', fromJson: _parseNum)
  final num? sum;

  @JsonKey(name: 'isPreliminary')
  final bool? isPreliminary;

  @JsonKey(name: 'isExternal')
  final bool? isExternal;

  @JsonKey(name: 'isProcessedExternally')
  final bool? isProcessedExternally;

  @JsonKey(name: 'isFiscalizedExternally')
  final bool? isFiscalizedExternally;

  OrderPaymentResponse({
    this.paymentType,
    this.sum,
    this.isPreliminary,
    this.isExternal,
    this.isProcessedExternally,
    this.isFiscalizedExternally,
  });

  factory OrderPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OrderPaymentResponseToJson(this);
}

/// Payment type info
@JsonSerializable()
class PaymentTypeInfo {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'kind')
  final String? kind;

  PaymentTypeInfo({this.id, this.name, this.kind});

  factory PaymentTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$PaymentTypeInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentTypeInfoToJson(this);
}

/// Discount response
@JsonSerializable()
class DiscountResponse {
  @JsonKey(name: 'discountType')
  final DiscountTypeInfo? discountType;

  @JsonKey(name: 'sum', fromJson: _parseNum)
  final num? sum;

  @JsonKey(name: 'selectivePositions')
  final List<String>? selectivePositions;

  DiscountResponse({this.discountType, this.sum, this.selectivePositions});

  factory DiscountResponse.fromJson(Map<String, dynamic> json) =>
      _$DiscountResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DiscountResponseToJson(this);
}

/// Discount type info
@JsonSerializable()
class DiscountTypeInfo {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  DiscountTypeInfo({this.id, this.name});

  factory DiscountTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$DiscountTypeInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DiscountTypeInfoToJson(this);
}

/// Order type info
@JsonSerializable()
class OrderTypeInfo {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'orderServiceType')
  final String? orderServiceType;

  OrderTypeInfo({this.id, this.name, this.orderServiceType});

  factory OrderTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$OrderTypeInfoFromJson(json);
  Map<String, dynamic> toJson() => _$OrderTypeInfoToJson(this);
}

/// Request to retrieve delivery by ID
@JsonSerializable()
class RetrieveDeliveryRequest {
  @JsonKey(name: 'organizationId')
  final String organizationId;

  @JsonKey(name: 'orderIds')
  final List<String> orderIds;

  @JsonKey(name: 'sourceKeys')
  final List<String>? sourceKeys;

  RetrieveDeliveryRequest({
    required this.organizationId,
    required this.orderIds,
    this.sourceKeys,
  });

  factory RetrieveDeliveryRequest.fromJson(Map<String, dynamic> json) =>
      _$RetrieveDeliveryRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RetrieveDeliveryRequestToJson(this);
}

/// Response for retrieve delivery
@JsonSerializable()
class RetrieveDeliveryResponse {
  @JsonKey(name: 'correlationId')
  final String? correlationId;

  @JsonKey(name: 'orders')
  final List<OrderInfo>? orders;

  RetrieveDeliveryResponse({this.correlationId, this.orders});

  factory RetrieveDeliveryResponse.fromJson(Map<String, dynamic> json) =>
      _$RetrieveDeliveryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RetrieveDeliveryResponseToJson(this);
}
