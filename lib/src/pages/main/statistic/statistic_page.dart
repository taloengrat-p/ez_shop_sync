import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/constances/date_format_constance.dart';
import 'package:ez_shop_sync/src/models/period_type.enum.dart';
import 'package:ez_shop_sync/src/pages/main/statistic/statistic_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/statistic/statistic_state.dart';
import 'package:ez_shop_sync/src/pages/transaction_statement_detail/transaction_statement_detail_router.dart';
import 'package:ez_shop_sync/src/pages/transaction_statement_detail/transaction_statement_detail_state.dart';
import 'package:ez_shop_sync/src/pages/transactions_chart_details/transactions_chart_details_router.dart';
import 'package:ez_shop_sync/src/pages/transactions_chart_details/transactions_chart_details_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/chart/bar_chart_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_shadow_widget.dart';
import 'package:ez_shop_sync/src/widgets/empty_data_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/column_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/transaction_history_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<StatisticPage> {
  final _cubit = GetIt.I<StatisticCubit>();

  String get periodTitle =>
      _cubit.periodType == PeriodType.week
          ? _cubit.dateTime.displayWeekFormat(context)
          : _cubit.dateTimeSelected.toDisplayDependLocale(
            context,
            format: _cubit.periodType == PeriodType.month ? DateFormatConstance.MMMM_YYYY : DateFormatConstance.YYYY,
          );
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      _cubit.initialize();
    });
  }

  @override
  void dispose() {
    log('[_StatisticState] dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StatisticCubit, StatisticState>(
      bloc: _cubit,
      listener: (context, state) {
        log('state ${_cubit.transaction.length}');
      },
      child: BlocBuilder<StatisticCubit, StatisticState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            isEmpty: _cubit.transaction.isEmpty,
            emptyIcon: CupertinoIcons.chart_bar_square,
            emptyMessage: LocaleKeys.statistic_emptyMessage.tr(),
            onRefresh: () async {
              await _cubit.initialize(refresh: true);
            },
            isInitialLoading: state is StatisticInitial,
            isLoading: state is StatisticLoading,
            enableAppModeDisplay: false,
            backgroundColor: Colors.white,
            appBar:
                AppbarWidget(
                  context,
                  centerTitle: false,
                  title: '${LocaleKeys.statistic_title.tr()} ( ${_cubit.periodType.label} )',
                  actions: [],
                ).build(),
            body: _buildPage(context, state),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, StatisticState state) {
    return Column(
      children: [
        _buildPeriodDateTime(),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: ColumnGapWidget(
              gap: 12,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTitleStatisticInfo(
                          LocaleKeys.totalSales.tr(),
                          _cubit.totalSales.toString().formatCurrency(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTitleStatisticInfo(
                          LocaleKeys.netProfit.tr(),
                          _cubit.netProfit.toString().formatCurrency(),
                          valueStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: _cubit.netProfit > 0 ? Colors.green : Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ContainerShadowWidget(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.transactionHistory.tr(),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                          ),
                          TextButton(
                            onPressed: () {
                              TransactionStatementDetailRouter(
                                context,
                              ).navigate(argruments: TransactionStatementDetailArgrument(_cubit.transaction));
                            },
                            child: Text(
                              LocaleKeys.seeAll.tr(),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_cubit.transaction.isEmpty)
                        EmptyDataWidget(message: LocaleKeys.transactionEmpty.tr(), width: double.infinity, height: 120),
                      if (_cubit.transaction.isNotEmpty)
                        ListView.separated(
                          padding: const EdgeInsets.only(top: 8),
                          itemCount: _cubit.transactionPerview.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final transaction = _cubit.transactionPerview[index];
                            return TransactionHistoryWidget(transaction: transaction);
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(color: Colors.grey);
                          },
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                ContainerShadowWidget(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  color: Colors.white,
                  child: BarChartWidget(
                    activeColor: Colors.green,
                    periodType: _cubit.periodType,
                    days: _cubit.dateTimeWithValue,
                    header: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _cubit.periodType.getLabel,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                            ),
                            TextButton(
                              onPressed: () {
                                TransactionsChartDetailsRouter(context).navigate(
                                  argruments: TransactionsChartDetailsArgrument(
                                    periodType: _cubit.periodType,
                                    days: _cubit.dateTimeWithValue,
                                    periodTitle: periodTitle,
                                  ),
                                );
                              },
                              child: Text(
                                LocaleKeys.seeDetail.tr(),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueAccent),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.totalIncome.tr(),
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                                  ),
                                  Text(
                                    _cubit.totalSales.toString().formatCurrency(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.averageIncome.tr(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                                  ),
                                  Text(
                                    _cubit.averageIncome.prefixCurrency(),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: double.infinity, height: DimensionsKeys.heightBts),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleStatisticInfo(String title, String value, {TextStyle? valueStyle}) {
    return ContainerShadowWidget(
      padding: const EdgeInsets.all(12),
      color: ColorKeys.primary.withOpacity(0.55),
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
          Text(value, style: valueStyle ?? Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildPeriodDateTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              periodTitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          PopupMenuButton(
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    child: Text(LocaleKeys.week.tr()),
                    onTap: () async {
                      await pickPeriod(PeriodType.week);
                    },
                  ),
                  PopupMenuItem(
                    child: Text(LocaleKeys.month.tr()),
                    onTap: () async {
                      await pickPeriod(PeriodType.month);
                    },
                  ),
                  PopupMenuItem(
                    child: Text(LocaleKeys.year.tr()),
                    onTap: () async {
                      await pickPeriod(PeriodType.year);
                    },
                  ),
                ],
            child: Icon(key: UniqueKey(), CupertinoIcons.calendar_circle, size: 40),
          ),
        ],
      ),
    );
  }

  Future<void> pickPeriod(PeriodType type) async {
    final dateSelect = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2017),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    log('dateSelect $dateSelect');

    if (dateSelect != null) {
      _cubit.setCurrentDateTime(type, dateSelect);
    }
  }
}
