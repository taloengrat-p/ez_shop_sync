import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/add_stock_history/add_stock_history_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_stock_history/add_stock_history_state.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddStockHistoryPage extends StatefulWidget {
  const AddStockHistoryPage({
    super.key,
  });

  @override
  _AddStockHistoryState createState() => _AddStockHistoryState();
}

class _AddStockHistoryState extends State<AddStockHistoryPage> {
  late AddStockHistoryCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = AddStockHistoryCubit();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      setState(() {});
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
      child: BlocListener<AddStockHistoryCubit, AddStockHistoryState>(
        listener: (context, state) {},
        child: BlocBuilder<AddStockHistoryCubit, AddStockHistoryState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: LocaleKeys.addStockHistory.tr(),
                actions: [],
              ).build(),
              body: _buildPage(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, AddStockHistoryState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: DimensionsKeys.heightBts,
          ),
        ],
      ),
    );
  }
}
