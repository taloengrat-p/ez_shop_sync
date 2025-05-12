import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/transaction.dart';
import 'package:ez_shop_sync/src/pages/add_product_history_detail/add_product_history_detail_router.dart';
import 'package:ez_shop_sync/src/pages/add_product_history_detail/add_product_history_detail_state.dart';
import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_router.dart';
import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:ez_shop_sync/src/widgets/circle_profile_widget.dart';
import 'package:ez_shop_sync/src/widgets/history_widget.dart';
import 'package:flutter/material.dart';

class TransactionHistoryWidget extends StatelessWidget {
  final Transaction transaction;
  const TransactionHistoryWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (transaction.getMethodType == TransactionMethodType.order) {
          OrderHistoryDetailRouter(
            context,
          ).navigate(argruments: OrderHistoryDetailArgruments(orderId: transaction.valueId));
        } else if (transaction.getMethodType == TransactionMethodType.addProduct) {
          AddProductHistoryDetailRouter(
            context,
          ).navigate(argruments: AddProductHistoryDetailArgruments(addProductId: transaction.valueId));
        }
      },
      child: HistoryWidget(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: transaction.getMethodType.label,
        desc: transaction.valueId,
        leading: CircleProfileWidget(title: transaction.info?.createBy?.substring(0, 2).toUpperCase(), radius: 24),
        dateTime: transaction.info?.createAtDateTime,
        trailing: Text(
          '${transaction.getTransactionType == TransactionType.income ? '+' : '-'}${transaction.totalPrice.prefixCurrency()}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: transaction.getTransactionType == TransactionType.income ? Colors.green : Colors.black,
          ),
        ),
      ),
    );
  }
}
