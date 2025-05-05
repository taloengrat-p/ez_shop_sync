import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/transaction_statement_detail/transaction_statement_detail_cubit.dart';
import 'package:ez_shop_sync/src/pages/transaction_statement_detail/transaction_statement_detail_state.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/transaction_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class TransactionStatementDetailPage extends StatefulWidget {
  const TransactionStatementDetailPage({super.key});

  @override
  _TransactionStatementDetailState createState() => _TransactionStatementDetailState();
}

class _TransactionStatementDetailState extends State<TransactionStatementDetailPage> {
  final _cubit = GetIt.I<TransactionStatementDetailCubit>();

  @override
  void initState() {
    super.initState();

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
    return BlocListener<TransactionStatementDetailCubit, TransactionStatementDetailState>(
      bloc: _cubit,
      listener: (context, state) {},
      child: BlocBuilder<TransactionStatementDetailCubit, TransactionStatementDetailState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            appBar:
                AppbarWidget(
                  context,
                  centerTitle: false,
                  title: LocaleKeys.transactionHistory.tr(),
                  actions: [],
                ).build(),
            body: _buildPage(context, state),
          );
        },
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
              return const Divider(color: Colors.grey);
            },
          ),
          Container(height: DimensionsKeys.heightBts / 2),
        ],
      ),
    );
  }
}
