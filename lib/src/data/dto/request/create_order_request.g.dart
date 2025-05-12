// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    CreateOrderRequest(
      paymentType: $enumDecode(_$PaymentMethodTypeEnumMap, json['paymentType']),
      status: $enumDecode(_$OrderStatusTypeEnumMap, json['status']),
      receiveAmount: json['receiveAmount'] as num?,
      changeAmount: json['changeAmount'] as num?,
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      info: json['info'] == null
          ? null
          : BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
      serviceCharge: json['serviceCharge'] as num?,
      cart: Cart.fromJson(json['cart'] as Map<String, dynamic>),
      paymentStatusType:
          $enumDecode(_$PaymentStatusTypeEnumMap, json['paymentStatusType']),
    );

Map<String, dynamic> _$CreateOrderRequestToJson(CreateOrderRequest instance) =>
    <String, dynamic>{
      'paymentType': _$PaymentMethodTypeEnumMap[instance.paymentType]!,
      'paymentStatusType':
          _$PaymentStatusTypeEnumMap[instance.paymentStatusType]!,
      'status': _$OrderStatusTypeEnumMap[instance.status]!,
      'receiveAmount': instance.receiveAmount,
      'changeAmount': instance.changeAmount,
      'orderItems': instance.orderItems.map((e) => e.toJson()).toList(),
      'info': instance.info?.toJson(),
      'cart': instance.cart.toJson(),
      'serviceCharge': instance.serviceCharge,
    };

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.cash: 'cash',
  PaymentMethodType.qrcode: 'qrcode',
  PaymentMethodType.undefined: 'undefined',
};

const _$OrderStatusTypeEnumMap = {
  OrderStatusType.pending: 'pending',
  OrderStatusType.confirmed: 'confirmed',
  OrderStatusType.cancel: 'cancel',
  OrderStatusType.processing: 'processing',
  OrderStatusType.ready_to_ship: 'ready_to_ship',
  OrderStatusType.shipped: 'shipped',
  OrderStatusType.in_transit: 'in_transit',
  OrderStatusType.out_for_delivery: 'out_for_delivery',
  OrderStatusType.delivered: 'delivered',
  OrderStatusType.complete: 'complete',
  OrderStatusType.undefined: 'undefined',
};

const _$PaymentStatusTypeEnumMap = {
  PaymentStatusType.pending: 'pending',
  PaymentStatusType.paid: 'paid',
  PaymentStatusType.failed: 'failed',
  PaymentStatusType.cancelled: 'cancelled',
  PaymentStatusType.expired: 'expired',
  PaymentStatusType.undefined: 'undefined',
};
