import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/main/transaction/transaction_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/transaction/transaction_state.dart';
import 'package:ez_shop_sync/src/pages/transaction_statement_detail/transaction_statement_detail_state.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/transaction_history_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<TransactionPage> {
  final _cubit = GetIt.I<TransactionCubit>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      _cubit.initialize();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onRefresh() async {
    await _cubit.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionCubit, TransactionState>(
      bloc: _cubit,
      listener: (context, state) {},
      child: BlocBuilder<TransactionCubit, TransactionState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            emptyIcon: CupertinoIcons.money_dollar_circle,
            isInitialLoading: state is TransactionInitialLoading,
            isEmpty: _cubit.transactions.isEmpty,
            onRefresh: _onRefresh,
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

  Widget _buildPage(BuildContext context, TransactionState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            padding: const EdgeInsets.only(top: 8),
            itemCount: _cubit.transactions.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final transaction = _cubit.transactions[index];
              return TransactionHistoryWidget(transaction: transaction);
            },
            separatorBuilder: (context, index) {
              return const Divider(color: Colors.grey);
            },
          ),
          Container(height: DimensionsKeys.heightBts * 1.5),
        ],
      ),
    );
  }
}
