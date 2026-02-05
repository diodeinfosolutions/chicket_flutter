// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateDeliveryRequest _$CreateDeliveryRequestFromJson(
  Map<String, dynamic> json,
) => CreateDeliveryRequest(
  organizationId: json['organizationId'] as String,
  terminalGroupId: json['terminalGroupId'] as String?,
  order: DeliveryOrder.fromJson(json['order'] as Map<String, dynamic>),
  createOrderSettings: json['createOrderSettings'] == null
      ? null
      : CreateOrderSettings.fromJson(
          json['createOrderSettings'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CreateDeliveryRequestToJson(
  CreateDeliveryRequest instance,
) => <String, dynamic>{
  'organizationId': instance.organizationId,
  'terminalGroupId': instance.terminalGroupId,
  'order': instance.order,
  'createOrderSettings': instance.createOrderSettings,
};

CreateOrderSettings _$CreateOrderSettingsFromJson(Map<String, dynamic> json) =>
    CreateOrderSettings(
      transportToFrontTimeout: _parseIntNullable(
        json['transportToFrontTimeout'],
      ),
    );

Map<String, dynamic> _$CreateOrderSettingsToJson(
  CreateOrderSettings instance,
) => <String, dynamic>{
  'transportToFrontTimeout': instance.transportToFrontTimeout,
};

DeliveryOrder _$DeliveryOrderFromJson(
  Map<String, dynamic> json,
) => DeliveryOrder(
  id: json['id'] as String?,
  externalNumber: json['externalNumber'] as String?,
  completeBefore: json['completeBefore'] as String?,
  phone: json['phone'] as String?,
  orderTypeId: json['orderTypeId'] as String?,
  orderServiceType: json['orderServiceType'] as String?,
  deliveryPoint: json['deliveryPoint'] == null
      ? null
      : DeliveryPoint.fromJson(json['deliveryPoint'] as Map<String, dynamic>),
  comment: json['comment'] as String?,
  customer: json['customer'] == null
      ? null
      : Customer.fromJson(json['customer'] as Map<String, dynamic>),
  guests: json['guests'] == null
      ? null
      : Guests.fromJson(json['guests'] as Map<String, dynamic>),
  marketingSourceId: json['marketingSourceId'] as String?,
  operatorId: json['operatorId'] as String?,
  items: (json['items'] as List<dynamic>)
      .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  combos: (json['combos'] as List<dynamic>?)
      ?.map((e) => OrderCombo.fromJson(e as Map<String, dynamic>))
      .toList(),
  payments: (json['payments'] as List<dynamic>?)
      ?.map((e) => OrderPayment.fromJson(e as Map<String, dynamic>))
      .toList(),
  tips: (json['tips'] as List<dynamic>?)
      ?.map((e) => OrderTip.fromJson(e as Map<String, dynamic>))
      .toList(),
  sourceKey: json['sourceKey'] as String?,
  discountsInfo: json['discountsInfo'] == null
      ? null
      : DiscountsInfo.fromJson(json['discountsInfo'] as Map<String, dynamic>),
  iikoCard5Info: json['iikoCard5Info'] == null
      ? null
      : IikoCard5Info.fromJson(json['iikoCard5Info'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DeliveryOrderToJson(DeliveryOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'externalNumber': instance.externalNumber,
      'completeBefore': instance.completeBefore,
      'phone': instance.phone,
      'orderTypeId': instance.orderTypeId,
      'orderServiceType': instance.orderServiceType,
      'deliveryPoint': instance.deliveryPoint,
      'comment': instance.comment,
      'customer': instance.customer,
      'guests': instance.guests,
      'marketingSourceId': instance.marketingSourceId,
      'operatorId': instance.operatorId,
      'items': instance.items,
      'combos': instance.combos,
      'payments': instance.payments,
      'tips': instance.tips,
      'sourceKey': instance.sourceKey,
      'discountsInfo': instance.discountsInfo,
      'iikoCard5Info': instance.iikoCard5Info,
    };

DeliveryPoint _$DeliveryPointFromJson(Map<String, dynamic> json) =>
    DeliveryPoint(
      coordinates: json['coordinates'] == null
          ? null
          : Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      externalCartographyId: json['externalCartographyId'] as String?,
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$DeliveryPointToJson(DeliveryPoint instance) =>
    <String, dynamic>{
      'coordinates': instance.coordinates,
      'address': instance.address,
      'externalCartographyId': instance.externalCartographyId,
      'comment': instance.comment,
    };

Coordinates _$CoordinatesFromJson(Map<String, dynamic> json) => Coordinates(
  latitude: _parseNum(json['latitude']),
  longitude: _parseNum(json['longitude']),
);

Map<String, dynamic> _$CoordinatesToJson(Coordinates instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  street: json['street'] == null
      ? null
      : Street.fromJson(json['street'] as Map<String, dynamic>),
  index: json['index'] as String?,
  house: json['house'] as String?,
  building: json['building'] as String?,
  flat: json['flat'] as String?,
  entrance: json['entrance'] as String?,
  floor: json['floor'] as String?,
  doorphone: json['doorphone'] as String?,
  region: json['region'] as String?,
  line1: json['line1'] as String?,
  line2: json['line2'] as String?,
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'street': instance.street,
  'index': instance.index,
  'house': instance.house,
  'building': instance.building,
  'flat': instance.flat,
  'entrance': instance.entrance,
  'floor': instance.floor,
  'doorphone': instance.doorphone,
  'region': instance.region,
  'line1': instance.line1,
  'line2': instance.line2,
};

Street _$StreetFromJson(Map<String, dynamic> json) => Street(
  classifierId: json['classifierId'] as String?,
  id: json['id'] as String?,
  name: json['name'] as String?,
  city: json['city'] as String?,
);

Map<String, dynamic> _$StreetToJson(Street instance) => <String, dynamic>{
  'classifierId': instance.classifierId,
  'id': instance.id,
  'name': instance.name,
  'city': instance.city,
};

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
  id: json['id'] as String?,
  name: json['name'] as String?,
  surname: json['surname'] as String?,
  comment: json['comment'] as String?,
  birthdate: json['birthdate'] as String?,
  email: json['email'] as String?,
  shouldReceiveOrderStatusNotifications:
      json['shouldReceiveOrderStatusNotifications'] as bool?,
  shouldReceivePromoActionsInfo: json['shouldReceivePromoActionsInfo'] as bool?,
  type: json['type'] as String?,
  gender: json['gender'] as String?,
  inBlacklist: json['inBlacklist'] as bool?,
  blacklistReason: json['blacklistReason'] as String?,
);

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'surname': instance.surname,
  'comment': instance.comment,
  'birthdate': instance.birthdate,
  'email': instance.email,
  'shouldReceiveOrderStatusNotifications':
      instance.shouldReceiveOrderStatusNotifications,
  'shouldReceivePromoActionsInfo': instance.shouldReceivePromoActionsInfo,
  'type': instance.type,
  'gender': instance.gender,
  'inBlacklist': instance.inBlacklist,
  'blacklistReason': instance.blacklistReason,
};

Guests _$GuestsFromJson(Map<String, dynamic> json) => Guests(
  count: _parseIntNullable(json['count']),
  splitBetweenPersons: json['splitBetweenPersons'] as bool?,
);

Map<String, dynamic> _$GuestsToJson(Guests instance) => <String, dynamic>{
  'count': instance.count,
  'splitBetweenPersons': instance.splitBetweenPersons,
};

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
  productId: json['productId'] as String,
  type: json['type'] as String?,
  amount: _parseNum(json['amount']),
  productSizeId: json['productSizeId'] as String?,
  comboInformation: json['comboInformation'] == null
      ? null
      : ComboInformation.fromJson(
          json['comboInformation'] as Map<String, dynamic>,
        ),
  modifiers: (json['modifiers'] as List<dynamic>?)
      ?.map((e) => OrderItemModifier.fromJson(e as Map<String, dynamic>))
      .toList(),
  price: _parseNum(json['price']),
  positionId: json['positionId'] as String?,
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
  'productId': instance.productId,
  'type': instance.type,
  'amount': instance.amount,
  'productSizeId': instance.productSizeId,
  'comboInformation': instance.comboInformation,
  'modifiers': instance.modifiers,
  'price': instance.price,
  'positionId': instance.positionId,
  'comment': instance.comment,
};

ComboInformation _$ComboInformationFromJson(Map<String, dynamic> json) =>
    ComboInformation(
      comboId: json['comboId'] as String,
      comboSourceId: json['comboSourceId'] as String,
      comboGroupId: json['comboGroupId'] as String,
    );

Map<String, dynamic> _$ComboInformationToJson(ComboInformation instance) =>
    <String, dynamic>{
      'comboId': instance.comboId,
      'comboSourceId': instance.comboSourceId,
      'comboGroupId': instance.comboGroupId,
    };

OrderItemModifier _$OrderItemModifierFromJson(Map<String, dynamic> json) =>
    OrderItemModifier(
      productId: json['productId'] as String,
      amount: _parseNum(json['amount']),
      productGroupId: json['productGroupId'] as String?,
      price: _parseNum(json['price']),
      positionId: json['positionId'] as String?,
    );

Map<String, dynamic> _$OrderItemModifierToJson(OrderItemModifier instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'amount': instance.amount,
      'productGroupId': instance.productGroupId,
      'price': instance.price,
      'positionId': instance.positionId,
    };

OrderCombo _$OrderComboFromJson(Map<String, dynamic> json) => OrderCombo(
  id: json['id'] as String,
  name: json['name'] as String,
  amount: _parseIntNullable(json['amount']),
  price: _parseNum(json['price']),
  sourceId: json['sourceId'] as String,
  programId: json['programId'] as String?,
);

Map<String, dynamic> _$OrderComboToJson(OrderCombo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'price': instance.price,
      'sourceId': instance.sourceId,
      'programId': instance.programId,
    };

OrderPayment _$OrderPaymentFromJson(Map<String, dynamic> json) => OrderPayment(
  paymentTypeKind: json['paymentTypeKind'] as String,
  sum: _parseNum(json['sum']),
  paymentTypeId: json['paymentTypeId'] as String,
  isProcessedExternally: json['isProcessedExternally'] as bool?,
  isPreliminary: json['isPreliminary'] as bool?,
  isExternal: json['isExternal'] as bool?,
  isFiscalizedExternally: json['isFiscalizedExternally'] as bool?,
);

Map<String, dynamic> _$OrderPaymentToJson(OrderPayment instance) =>
    <String, dynamic>{
      'paymentTypeKind': instance.paymentTypeKind,
      'sum': ?instance.sum,
      'paymentTypeId': instance.paymentTypeId,
      'isProcessedExternally': ?instance.isProcessedExternally,
      'isPreliminary': ?instance.isPreliminary,
      'isExternal': ?instance.isExternal,
      'isFiscalizedExternally': ?instance.isFiscalizedExternally,
    };

OrderTip _$OrderTipFromJson(Map<String, dynamic> json) => OrderTip(
  paymentTypeKind: json['paymentTypeKind'] as String,
  sum: _parseNum(json['sum']),
  paymentTypeId: json['paymentTypeId'] as String,
  isProcessedExternally: json['isProcessedExternally'] as bool?,
  isPreliminary: json['isPreliminary'] as bool?,
  isExternal: json['isExternal'] as bool?,
  isFiscalizedExternally: json['isFiscalizedExternally'] as bool?,
  tipsTypeId: json['tipsTypeId'] as String?,
);

Map<String, dynamic> _$OrderTipToJson(OrderTip instance) => <String, dynamic>{
  'paymentTypeKind': instance.paymentTypeKind,
  'sum': instance.sum,
  'paymentTypeId': instance.paymentTypeId,
  'isProcessedExternally': instance.isProcessedExternally,
  'isPreliminary': instance.isPreliminary,
  'isExternal': instance.isExternal,
  'isFiscalizedExternally': instance.isFiscalizedExternally,
  'tipsTypeId': instance.tipsTypeId,
};

DiscountsInfo _$DiscountsInfoFromJson(Map<String, dynamic> json) =>
    DiscountsInfo(
      card: json['card'] == null
          ? null
          : DiscountCard.fromJson(json['card'] as Map<String, dynamic>),
      discounts: (json['discounts'] as List<dynamic>?)
          ?.map((e) => Discount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DiscountsInfoToJson(DiscountsInfo instance) =>
    <String, dynamic>{'card': instance.card, 'discounts': instance.discounts};

DiscountCard _$DiscountCardFromJson(Map<String, dynamic> json) => DiscountCard(
  track: json['track'] as String?,
  number: json['number'] as String?,
);

Map<String, dynamic> _$DiscountCardToJson(DiscountCard instance) =>
    <String, dynamic>{'track': instance.track, 'number': instance.number};

Discount _$DiscountFromJson(Map<String, dynamic> json) => Discount(
  discountTypeId: json['discountTypeId'] as String,
  sum: _parseNum(json['sum']),
  selectivePositions: (json['selectivePositions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$DiscountToJson(Discount instance) => <String, dynamic>{
  'discountTypeId': instance.discountTypeId,
  'sum': instance.sum,
  'selectivePositions': instance.selectivePositions,
};

IikoCard5Info _$IikoCard5InfoFromJson(Map<String, dynamic> json) =>
    IikoCard5Info(
      coupon: json['coupon'] as String?,
      applicableManualConditions:
          (json['applicableManualConditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$IikoCard5InfoToJson(IikoCard5Info instance) =>
    <String, dynamic>{
      'coupon': instance.coupon,
      'applicableManualConditions': instance.applicableManualConditions,
    };

CreateDeliveryResponse _$CreateDeliveryResponseFromJson(
  Map<String, dynamic> json,
) => CreateDeliveryResponse(
  correlationId: json['correlationId'] as String?,
  orderInfo: json['orderInfo'] == null
      ? null
      : OrderInfo.fromJson(json['orderInfo'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreateDeliveryResponseToJson(
  CreateDeliveryResponse instance,
) => <String, dynamic>{
  'correlationId': instance.correlationId,
  'orderInfo': instance.orderInfo,
};

OrderInfo _$OrderInfoFromJson(Map<String, dynamic> json) => OrderInfo(
  id: json['id'] as String,
  posId: json['posId'] as String?,
  externalNumber: json['externalNumber'] as String?,
  organizationId: json['organizationId'] as String?,
  timestamp: _parseIntNullable(json['timestamp']),
  creationStatus: json['creationStatus'] as String?,
  errorInfo: json['errorInfo'] == null
      ? null
      : ErrorInfo.fromJson(json['errorInfo'] as Map<String, dynamic>),
  order: json['order'] == null
      ? null
      : OrderDetails.fromJson(json['order'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OrderInfoToJson(OrderInfo instance) => <String, dynamic>{
  'id': instance.id,
  'posId': instance.posId,
  'externalNumber': instance.externalNumber,
  'organizationId': instance.organizationId,
  'timestamp': instance.timestamp,
  'creationStatus': instance.creationStatus,
  'errorInfo': instance.errorInfo,
  'order': instance.order,
};

ErrorInfo _$ErrorInfoFromJson(Map<String, dynamic> json) => ErrorInfo(
  code: json['code'] as String?,
  message: json['message'] as String?,
  description: json['description'] as String?,
  additionalData: json['additionalData'] as String?,
);

Map<String, dynamic> _$ErrorInfoToJson(ErrorInfo instance) => <String, dynamic>{
  'code': instance.code,
  'message': instance.message,
  'description': instance.description,
  'additionalData': instance.additionalData,
};

OrderDetails _$OrderDetailsFromJson(Map<String, dynamic> json) => OrderDetails(
  parentDeliveryId: json['parentDeliveryId'] as String?,
  customer: json['customer'] == null
      ? null
      : Customer.fromJson(json['customer'] as Map<String, dynamic>),
  phone: json['phone'] as String?,
  deliveryPoint: json['deliveryPoint'] == null
      ? null
      : DeliveryPoint.fromJson(json['deliveryPoint'] as Map<String, dynamic>),
  status: json['status'] as String?,
  cancelInfo: json['cancelInfo'] == null
      ? null
      : CancelInfo.fromJson(json['cancelInfo'] as Map<String, dynamic>),
  courierInfo: json['courierInfo'] == null
      ? null
      : CourierInfo.fromJson(json['courierInfo'] as Map<String, dynamic>),
  completeBefore: json['completeBefore'] as String?,
  whenCreated: json['whenCreated'] as String?,
  whenConfirmed: json['whenConfirmed'] as String?,
  whenPrinted: json['whenPrinted'] as String?,
  whenSended: json['whenSended'] as String?,
  whenDelivered: json['whenDelivered'] as String?,
  comment: json['comment'] as String?,
  problem: json['problem'] == null
      ? null
      : Problem.fromJson(json['problem'] as Map<String, dynamic>),
  operator: json['operator'] == null
      ? null
      : Operator.fromJson(json['operator'] as Map<String, dynamic>),
  marketingSource: json['marketingSource'] == null
      ? null
      : MarketingSource.fromJson(
          json['marketingSource'] as Map<String, dynamic>,
        ),
  deliveryDuration: _parseIntNullable(json['deliveryDuration']),
  indexInCookingQueue: _parseIntNullable(json['indexInCookingQueue']),
  cookingStartTime: json['cookingStartTime'] as String?,
  isDeleted: json['isDeleted'] as bool?,
  whenReceivedByApi: json['whenReceivedByApi'] as String?,
  whenReceivedFromFront: json['whenReceivedFromFront'] as String?,
  movedFromDeliveryId: json['movedFromDeliveryId'] as String?,
  movedFromTerminalGroupId: json['movedFromTerminalGroupId'] as String?,
  movedFromOrganizationId: json['movedFromOrganizationId'] as String?,
  sum: _parseNum(json['sum']),
  number: _parseIntNullable(json['number']),
  sourceKey: json['sourceKey'] as String?,
  whenBillPrinted: json['whenBillPrinted'] as String?,
  whenClosed: json['whenClosed'] as String?,
  conception: json['conception'] == null
      ? null
      : Conception.fromJson(json['conception'] as Map<String, dynamic>),
  guestsInfo: json['guestsInfo'] == null
      ? null
      : GuestsInfo.fromJson(json['guestsInfo'] as Map<String, dynamic>),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => OrderItemResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  combos: (json['combos'] as List<dynamic>?)
      ?.map((e) => OrderCombo.fromJson(e as Map<String, dynamic>))
      .toList(),
  payments: (json['payments'] as List<dynamic>?)
      ?.map((e) => OrderPaymentResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  tips: (json['tips'] as List<dynamic>?)
      ?.map((e) => OrderTip.fromJson(e as Map<String, dynamic>))
      .toList(),
  discounts: (json['discounts'] as List<dynamic>?)
      ?.map((e) => DiscountResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  orderType: json['orderType'] == null
      ? null
      : OrderTypeInfo.fromJson(json['orderType'] as Map<String, dynamic>),
  terminalGroupId: json['terminalGroupId'] as String?,
  processedPaymentsSum: _parseNum(json['processedPaymentsSum']),
);

Map<String, dynamic> _$OrderDetailsToJson(OrderDetails instance) =>
    <String, dynamic>{
      'parentDeliveryId': instance.parentDeliveryId,
      'customer': instance.customer,
      'phone': instance.phone,
      'deliveryPoint': instance.deliveryPoint,
      'status': instance.status,
      'cancelInfo': instance.cancelInfo,
      'courierInfo': instance.courierInfo,
      'completeBefore': instance.completeBefore,
      'whenCreated': instance.whenCreated,
      'whenConfirmed': instance.whenConfirmed,
      'whenPrinted': instance.whenPrinted,
      'whenSended': instance.whenSended,
      'whenDelivered': instance.whenDelivered,
      'comment': instance.comment,
      'problem': instance.problem,
      'operator': instance.operator,
      'marketingSource': instance.marketingSource,
      'deliveryDuration': instance.deliveryDuration,
      'indexInCookingQueue': instance.indexInCookingQueue,
      'cookingStartTime': instance.cookingStartTime,
      'isDeleted': instance.isDeleted,
      'whenReceivedByApi': instance.whenReceivedByApi,
      'whenReceivedFromFront': instance.whenReceivedFromFront,
      'movedFromDeliveryId': instance.movedFromDeliveryId,
      'movedFromTerminalGroupId': instance.movedFromTerminalGroupId,
      'movedFromOrganizationId': instance.movedFromOrganizationId,
      'sum': instance.sum,
      'number': instance.number,
      'sourceKey': instance.sourceKey,
      'whenBillPrinted': instance.whenBillPrinted,
      'whenClosed': instance.whenClosed,
      'conception': instance.conception,
      'guestsInfo': instance.guestsInfo,
      'items': instance.items,
      'combos': instance.combos,
      'payments': instance.payments,
      'tips': instance.tips,
      'discounts': instance.discounts,
      'orderType': instance.orderType,
      'terminalGroupId': instance.terminalGroupId,
      'processedPaymentsSum': instance.processedPaymentsSum,
    };

CancelInfo _$CancelInfoFromJson(Map<String, dynamic> json) => CancelInfo(
  whenCancelled: json['whenCancelled'] as String?,
  cause: json['cause'] == null
      ? null
      : CancelCause.fromJson(json['cause'] as Map<String, dynamic>),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$CancelInfoToJson(CancelInfo instance) =>
    <String, dynamic>{
      'whenCancelled': instance.whenCancelled,
      'cause': instance.cause,
      'comment': instance.comment,
    };

CancelCause _$CancelCauseFromJson(Map<String, dynamic> json) =>
    CancelCause(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$CancelCauseToJson(CancelCause instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

CourierInfo _$CourierInfoFromJson(Map<String, dynamic> json) => CourierInfo(
  courier: json['courier'] == null
      ? null
      : Courier.fromJson(json['courier'] as Map<String, dynamic>),
  isCourierSelectedManually: json['isCourierSelectedManually'] as bool?,
);

Map<String, dynamic> _$CourierInfoToJson(CourierInfo instance) =>
    <String, dynamic>{
      'courier': instance.courier,
      'isCourierSelectedManually': instance.isCourierSelectedManually,
    };

Courier _$CourierFromJson(Map<String, dynamic> json) => Courier(
  id: json['id'] as String?,
  name: json['name'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$CourierToJson(Courier instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
};

Problem _$ProblemFromJson(Map<String, dynamic> json) => Problem(
  hasProblem: json['hasProblem'] as bool?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$ProblemToJson(Problem instance) => <String, dynamic>{
  'hasProblem': instance.hasProblem,
  'description': instance.description,
};

Operator _$OperatorFromJson(Map<String, dynamic> json) => Operator(
  id: json['id'] as String?,
  name: json['name'] as String?,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$OperatorToJson(Operator instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
};

MarketingSource _$MarketingSourceFromJson(Map<String, dynamic> json) =>
    MarketingSource(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$MarketingSourceToJson(MarketingSource instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

Conception _$ConceptionFromJson(Map<String, dynamic> json) => Conception(
  id: json['id'] as String?,
  name: json['name'] as String?,
  code: json['code'] as String?,
);

Map<String, dynamic> _$ConceptionToJson(Conception instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
    };

GuestsInfo _$GuestsInfoFromJson(Map<String, dynamic> json) => GuestsInfo(
  count: _parseIntNullable(json['count']),
  splitBetweenPersons: json['splitBetweenPersons'] as bool?,
);

Map<String, dynamic> _$GuestsInfoToJson(GuestsInfo instance) =>
    <String, dynamic>{
      'count': instance.count,
      'splitBetweenPersons': instance.splitBetweenPersons,
    };

OrderItemResponse _$OrderItemResponseFromJson(Map<String, dynamic> json) =>
    OrderItemResponse(
      product: json['product'] == null
          ? null
          : ProductInfo.fromJson(json['product'] as Map<String, dynamic>),
      modifiers: (json['modifiers'] as List<dynamic>?)
          ?.map((e) => ModifierResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      price: _parseNum(json['price']),
      cost: _parseNum(json['cost']),
      pricePredefined: json['pricePredefined'] as bool?,
      positionId: json['positionId'] as String?,
      taxPercent: _parseNum(json['taxPercent']),
      type: json['type'] as String?,
      status: json['status'] as String?,
      deleted: json['deleted'] as bool?,
      amount: _parseNum(json['amount']),
      comment: json['comment'] as String?,
      whenPrinted: json['whenPrinted'] as String?,
      size: json['size'] == null
          ? null
          : SizeInfo.fromJson(json['size'] as Map<String, dynamic>),
      comboInformation: json['comboInformation'] == null
          ? null
          : ComboInformation.fromJson(
              json['comboInformation'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$OrderItemResponseToJson(OrderItemResponse instance) =>
    <String, dynamic>{
      'product': instance.product,
      'modifiers': instance.modifiers,
      'price': instance.price,
      'cost': instance.cost,
      'pricePredefined': instance.pricePredefined,
      'positionId': instance.positionId,
      'taxPercent': instance.taxPercent,
      'type': instance.type,
      'status': instance.status,
      'deleted': instance.deleted,
      'amount': instance.amount,
      'comment': instance.comment,
      'whenPrinted': instance.whenPrinted,
      'size': instance.size,
      'comboInformation': instance.comboInformation,
    };

ProductInfo _$ProductInfoFromJson(Map<String, dynamic> json) =>
    ProductInfo(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$ProductInfoToJson(ProductInfo instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

ModifierResponse _$ModifierResponseFromJson(Map<String, dynamic> json) =>
    ModifierResponse(
      product: json['product'] == null
          ? null
          : ProductInfo.fromJson(json['product'] as Map<String, dynamic>),
      amount: _parseNum(json['amount']),
      amountIndependentOfParentAmount: _parseNum(
        json['amountIndependentOfParentAmount'],
      ),
      productGroup: json['productGroup'] == null
          ? null
          : ProductGroupInfo.fromJson(
              json['productGroup'] as Map<String, dynamic>,
            ),
      price: _parseNum(json['price']),
      pricePredefined: json['pricePredefined'] as bool?,
      positionId: json['positionId'] as String?,
      defaultAmount: _parseIntNullable(json['defaultAmount']),
      hideIfDefaultAmount: json['hideIfDefaultAmount'] as bool?,
      deleted: json['deleted'] as bool?,
    );

Map<String, dynamic> _$ModifierResponseToJson(
  ModifierResponse instance,
) => <String, dynamic>{
  'product': instance.product,
  'amount': instance.amount,
  'amountIndependentOfParentAmount': instance.amountIndependentOfParentAmount,
  'productGroup': instance.productGroup,
  'price': instance.price,
  'pricePredefined': instance.pricePredefined,
  'positionId': instance.positionId,
  'defaultAmount': instance.defaultAmount,
  'hideIfDefaultAmount': instance.hideIfDefaultAmount,
  'deleted': instance.deleted,
};

ProductGroupInfo _$ProductGroupInfoFromJson(Map<String, dynamic> json) =>
    ProductGroupInfo(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$ProductGroupInfoToJson(ProductGroupInfo instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

SizeInfo _$SizeInfoFromJson(Map<String, dynamic> json) =>
    SizeInfo(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$SizeInfoToJson(SizeInfo instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

OrderPaymentResponse _$OrderPaymentResponseFromJson(
  Map<String, dynamic> json,
) => OrderPaymentResponse(
  paymentType: json['paymentType'] == null
      ? null
      : PaymentTypeInfo.fromJson(json['paymentType'] as Map<String, dynamic>),
  sum: _parseNum(json['sum']),
  isPreliminary: json['isPreliminary'] as bool?,
  isExternal: json['isExternal'] as bool?,
  isProcessedExternally: json['isProcessedExternally'] as bool?,
  isFiscalizedExternally: json['isFiscalizedExternally'] as bool?,
);

Map<String, dynamic> _$OrderPaymentResponseToJson(
  OrderPaymentResponse instance,
) => <String, dynamic>{
  'paymentType': instance.paymentType,
  'sum': instance.sum,
  'isPreliminary': instance.isPreliminary,
  'isExternal': instance.isExternal,
  'isProcessedExternally': instance.isProcessedExternally,
  'isFiscalizedExternally': instance.isFiscalizedExternally,
};

PaymentTypeInfo _$PaymentTypeInfoFromJson(Map<String, dynamic> json) =>
    PaymentTypeInfo(
      id: json['id'] as String?,
      name: json['name'] as String?,
      kind: json['kind'] as String?,
    );

Map<String, dynamic> _$PaymentTypeInfoToJson(PaymentTypeInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kind': instance.kind,
    };

DiscountResponse _$DiscountResponseFromJson(Map<String, dynamic> json) =>
    DiscountResponse(
      discountType: json['discountType'] == null
          ? null
          : DiscountTypeInfo.fromJson(
              json['discountType'] as Map<String, dynamic>,
            ),
      sum: _parseNum(json['sum']),
      selectivePositions: (json['selectivePositions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DiscountResponseToJson(DiscountResponse instance) =>
    <String, dynamic>{
      'discountType': instance.discountType,
      'sum': instance.sum,
      'selectivePositions': instance.selectivePositions,
    };

DiscountTypeInfo _$DiscountTypeInfoFromJson(Map<String, dynamic> json) =>
    DiscountTypeInfo(id: json['id'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$DiscountTypeInfoToJson(DiscountTypeInfo instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

OrderTypeInfo _$OrderTypeInfoFromJson(Map<String, dynamic> json) =>
    OrderTypeInfo(
      id: json['id'] as String?,
      name: json['name'] as String?,
      orderServiceType: json['orderServiceType'] as String?,
    );

Map<String, dynamic> _$OrderTypeInfoToJson(OrderTypeInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'orderServiceType': instance.orderServiceType,
    };

RetrieveDeliveryRequest _$RetrieveDeliveryRequestFromJson(
  Map<String, dynamic> json,
) => RetrieveDeliveryRequest(
  organizationId: json['organizationId'] as String,
  orderIds: (json['orderIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  sourceKeys: (json['sourceKeys'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$RetrieveDeliveryRequestToJson(
  RetrieveDeliveryRequest instance,
) => <String, dynamic>{
  'organizationId': instance.organizationId,
  'orderIds': instance.orderIds,
  'sourceKeys': instance.sourceKeys,
};

RetrieveDeliveryResponse _$RetrieveDeliveryResponseFromJson(
  Map<String, dynamic> json,
) => RetrieveDeliveryResponse(
  correlationId: json['correlationId'] as String?,
  orders: (json['orders'] as List<dynamic>?)
      ?.map((e) => OrderInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RetrieveDeliveryResponseToJson(
  RetrieveDeliveryResponse instance,
) => <String, dynamic>{
  'correlationId': instance.correlationId,
  'orders': instance.orders,
};
