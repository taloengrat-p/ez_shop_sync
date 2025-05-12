// ignore_for_file: type_init_formals

import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/order_status_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/payment_status_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/payment_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:ez_shop_sync/src/utils/extensions/list_order_item_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_order.g.dart';

@HiveType(typeId: 12)
@JsonSerializable(explicitToJson: true)
class ProductOrder extends BaseHiveObject {
  @HiveField(7)
  final String status;
  OrderStatusType get geyStatusType => OrderStatusType.fromString(status);

  @HiveField(8)
  final String paymentType;
  PaymentMethodType get geyPaymentType => PaymentMethodType.fromString(paymentType);

  @HiveField(9)
  List<OrderItem> orderItems;

  @HiveField(10, defaultValue: 0)
  num? serviceCharge;

  @HiveField(11)
  num? changeAmount;

  @HiveField(12)
  num? receiveAmount;

  @HiveField(13)
  final String? paymentStatus;
  PaymentStatusType get getPaymentStatus => PaymentStatusType.fromString(paymentStatus);

  num get numberOfItems => orderItems.fold(0, (sum, item) => sum + (item.product?.quantity ?? 0));

  num get serviceChargeValue => (serviceCharge ?? 0) / 100;

  num get totalServiceCharge => (orderItems.totalPrice * serviceChargeValue);

  num get totalPriceIncludeServiceCharge => orderItems.totalPrice + totalServiceCharge;

  String get totalPriceDisplay => totalPriceIncludeServiceCharge.prefixCurrency();

  ProductOrder({
    super.id,
    BaseHiveData? super.info,
    required this.status,
    required this.orderItems,
    required this.paymentType,
    this.receiveAmount,
    this.changeAmount,
    this.serviceCharge,
    this.paymentStatus,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> json) => _$ProductOrderFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProductOrderToJson(this);
}
