// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    CreateOrderRequest(
      storeId: json['storeId'] as String,
      userId: json['userId'] as String,
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentType: $enumDecode(_$PaymentMethodTypeEnumMap, json['paymentType']),
      status: $enumDecode(_$OrderStatusTypeEnumMap, json['status']),
      changeAmount: json['changeAmount'] as num?,
      receiveAmount: json['receiveAmount'] as num?,
      info: json['info'] == null
          ? null
          : BaseHiveData.fromJson(json['info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateOrderRequestToJson(CreateOrderRequest instance) =>
    <String, dynamic>{
      'storeId': instance.storeId,
      'userId': instance.userId,
      'orderItems': instance.orderItems.map((e) => e.toJson()).toList(),
      'paymentType': _$PaymentMethodTypeEnumMap[instance.paymentType]!,
      'status': _$OrderStatusTypeEnumMap[instance.status]!,
      'receiveAmount': instance.receiveAmount,
      'changeAmount': instance.changeAmount,
      'info': instance.info?.toJson(),
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
