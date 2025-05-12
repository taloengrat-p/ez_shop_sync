// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/order_status_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/payment_status_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/payment_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_order_request.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateOrderRequest {
  final PaymentMethodType paymentType;
  final PaymentStatusType paymentStatusType;
  final OrderStatusType status;
  final num? receiveAmount;
  final num? changeAmount;
  final List<OrderItem> orderItems;
  BaseHiveData? info;
  final Cart cart;
  final num? serviceCharge;

  CreateOrderRequest({
    required this.paymentType,
    required this.status,
    this.receiveAmount,
    this.changeAmount,
    required this.orderItems,
    this.info,
    this.serviceCharge,
    required this.cart,
    required this.paymentStatusType,
  });

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) => _$CreateOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}
