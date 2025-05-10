// ignore_for_file: type_init_formals

import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/payment_type.enum.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';

part 'add_product.g.dart';

@HiveType(typeId: 15)
@JsonSerializable(explicitToJson: true)
class AddProduct extends BaseHiveObject {
  @HiveField(7)
  String userId;

  @HiveField(8)
  String storeId;

  @HiveField(9, defaultValue: [])
  List<OrderItem> addProductItems;

  @HiveField(10, defaultValue: 0)
  num amountCost;

  @HiveField(11, defaultValue: PaymentMethodType.cash)
  final PaymentMethodType? paymentType;

  AddProduct({
    super.id,
    BaseHiveData? super.info,
    required this.userId,
    required this.storeId,
    required this.addProductItems,
    required this.amountCost,
    required this.paymentType,
  });

  factory AddProduct.fromJson(Map<String, dynamic> json) => _$AddProductFromJson(json);

  num get numberOfItems => addProductItems.fold(0, (sum, item) => sum + (item.product?.quantity ?? 0));

  @override
  Map<String, dynamic> toJson() => _$AddProductToJson(this);

  AddProduct copyWith({
    String? id,
    String? userId,
    String? storeId,
    List<OrderItem>? addProductItems,
    num? amountCost,
    BaseHiveData? info,
    PaymentMethodType? paymentType,
  }) {
    return AddProduct(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      storeId: storeId ?? this.storeId,
      addProductItems: addProductItems ?? this.addProductItems,
      amountCost: amountCost ?? this.amountCost,
      info: info ?? this.info,
      paymentType: paymentType ?? this.paymentType,
    );
  }
}
