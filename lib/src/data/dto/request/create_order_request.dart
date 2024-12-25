import 'package:ez_shop_sync/src/data/dto/hive_object/enums/order_status_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/payment_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_order_request.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateOrderRequest {
  final String storeId;
  final String userId;
  final List<OrderItem> orderItems;
  final PaymentMethodType paymentType;
  final OrderStatusType status;
  final num? receiveAmount;
  final num? changeAmount;
  dynamic createAt;

  CreateOrderRequest({
    required this.storeId,
    required this.userId,
    required this.orderItems,
    required this.paymentType,
    required this.status,
    this.changeAmount,
    this.receiveAmount,
  });

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}
