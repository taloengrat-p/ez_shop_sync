import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_type.enum.dart';

class CreateTransactionRequest {
  final TransactionType transactionType;
  final TransactionMethodType method;
  final String valueId;
  final num totalPrice;
  final String storeId;
  final String userId;

  CreateTransactionRequest({
    required this.method,
    required this.totalPrice,
    required this.transactionType,
    required this.valueId,
    required this.storeId,
    required this.userId,
  });
}
