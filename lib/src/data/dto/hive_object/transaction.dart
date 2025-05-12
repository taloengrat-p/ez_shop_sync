// ignore_for_file: type_init_formals

import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_type.enum.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_object.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@HiveType(typeId: 14)
@JsonSerializable(explicitToJson: true)
class Transaction extends BaseHiveObject {
  @HiveField(7)
  final String transactionType;
  TransactionType get getTransactionType => TransactionType.fromString(transactionType);

  @HiveField(8)
  final String method;
  TransactionMethodType get getMethodType => TransactionMethodType.fromString(method);

  @HiveField(9)
  final String valueId;

  @HiveField(10)
  final num totalPrice;

  Transaction({
    super.id,
    BaseHiveData? super.info,
    required this.transactionType,
    required this.method,
    required this.valueId,
    required this.totalPrice,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
