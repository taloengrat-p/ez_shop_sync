import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/transactions_chart_details/transactions_chart_details_cubit.dart';
import 'package:ez_shop_sync/src/pages/transactions_chart_details/transactions_chart_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:get_it/get_it.dart';

class TransactionsChartDetailsPage extends StatefulWidget {
  const TransactionsChartDetailsPage({
    super.key,
  });

  @override
  _TransactionsChartDetailsState createState() => _TransactionsChartDetailsState();
}

class _TransactionsChartDetailsState extends State<TransactionsChartDetailsPage> {
  late TransactionsChartDetailsCubit _cubit;
  late BaseCubit baseCubit;
  @override
  void initState() {
    super.initState();
    baseCubit = GetIt.I<BaseCubit>();
    _cubit = TransactionsChartDetailsCubit();

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
      child: BlocListener<TransactionsChartDetailsCubit, TransactionsChartDetailsState>(
        listener: (context, state) {},
        child: BlocBuilder<TransactionsChartDetailsCubit, TransactionsChartDetailsState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: "TransactionsChartDetails",
                actions: [],
              ).build(),
              body: _buildPage(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, TransactionsChartDetailsState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.category.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                    ),
                    if (baseCubit.categories.isEmpty)
                      SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(LocaleKeys.categoryEmpty.tr()),
                        ),
                      ),
                    if (baseCubit.categories.isNotEmpty)
                      ...baseCubit.categories.map(
                        (e) => Text(e.name),
                      )
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                width: double.infinity,
                height: DimensionsKeys.heightBts * 2,
              ),
            ],
          ),
          Container(
            height: DimensionsKeys.heightBts,
          ),
        ],
      ),
    );
  }
}
