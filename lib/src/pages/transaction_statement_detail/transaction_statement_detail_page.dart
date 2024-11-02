import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_type.enum.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/pages/transaction_statement_detail/transaction_statement_detail_cubit.dart';
import 'package:ez_shop_sync/src/pages/transaction_statement_detail/transaction_statement_detail_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:ez_shop_sync/src/widgets/circle_profile_widget.dart';
import 'package:ez_shop_sync/src/widgets/history_widget.dart';
import 'package:ez_shop_sync/src/widgets/transaction_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/res/dimensions.dart';

class TransactionStatementDetailPage extends StatefulWidget {
  const TransactionStatementDetailPage({
    super.key,
  });

  @override
  _TransactionStatementDetailState createState() => _TransactionStatementDetailState();
}

class _TransactionStatementDetailState extends State<TransactionStatementDetailPage> {
  late TransactionStatementDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = TransactionStatementDetailCubit();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      final argruments = ModalRoute.of(context)?.settings.arguments;

      if (argruments is TransactionStatementDetailArgrument) {
        _cubit.initialize(argruments);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<TransactionStatementDetailCubit, TransactionStatementDetailState>(
        listener: (context, state) {},
        child: BlocBuilder<TransactionStatementDetailCubit, TransactionStatementDetailState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: LocaleKeys.transactionHistory.tr(),
                actions: [],
              ).build(),
              body: _buildPage(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, TransactionStatementDetailState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            padding: const EdgeInsets.only(top: 8),
            itemCount: _cubit.argruments?.transactions.length ?? 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final transaction = _cubit.argruments!.transactions[index];
              return TransactionHistoryWidget(transaction: transaction);
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.grey,
              );
            },
          ),
          Container(
            height: DimensionsKeys.heightBts / 2,
          ),
        ],
      ),
    );
  }
}
