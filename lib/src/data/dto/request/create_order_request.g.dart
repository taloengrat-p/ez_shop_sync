// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    CreateOrderRequest(
      paymentType: $enumDecode(_$PaymentMethodTypeEnumMap, json['paymentType']),
      status: $enumDecode(_$OrderStatusTypeEnumMap, json['status']),
      changeAmount: json['changeAmount'] as num?,
      receiveAmount: json['receiveAmount'] as num?,
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateOrderRequestToJson(CreateOrderRequest instance) =>
    <String, dynamic>{
      'paymentType': _$PaymentMethodTypeEnumMap[instance.paymentType]!,
      'status': _$OrderStatusTypeEnumMap[instance.status]!,
      'receiveAmount': instance.receiveAmount,
      'changeAmount': instance.changeAmount,
      'orderItems': instance.orderItems.map((e) => e.toJson()).toList(),
    };

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.cash: 'cash',
  PaymentMethodType.qrcode: 'qrcode',
  PaymentMethodType.undefined: 'undefined',
};

const _$OrderStatusTypeEnumMap = {
  OrderStatusType.complete: 'complete',
  OrderStatusType.waitPayment: 'waitPayment',
  OrderStatusType.undefiend: 'undefiend',
};
