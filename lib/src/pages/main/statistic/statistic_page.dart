import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/constances/date_format_constance.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/models/period_type.enum.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/statistic/statistic_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/statistic/statistic_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/chart/bar_chart_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_shadow_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/column_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({
    super.key,
  });

  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<StatisticPage> {
  late StatisticCubit _cubit;
  @override
  void initState() {
    log('[_StatisticState] init');
    _cubit = StatisticCubit(
      baseCubit: GetIt.I<BaseCubit>(),
      orderRepository: GetIt.I<OrderRepository>(),
      categoryRepository: GetIt.I<CategoryRepository>(),
    );
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
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<StatisticCubit, StatisticState>(
        listener: (context, state) {
          log('state $state');
        },
        child: BlocBuilder<StatisticCubit, StatisticState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: '${LocaleKeys.statistic.tr()} ( ${_cubit.periodType.label} )',
                actions: [],
              ).build(),
              body: _buildPage(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, StatisticState state) {
    return SingleChildScrollView(
      child: ColumnGapWidget(
        gap: 12,
        children: [
          _buildPeriodDateTime(),
          _buildTitleStatisticInfo('${LocaleKeys.totalSales.tr()} : ', _cubit.totalSales.toString().formatCurrency()),
          _buildTitleStatisticInfo(
            '${LocaleKeys.netProfit.tr()} : ',
            '--'.prefixCurrency(),
          ),
          ContainerShadowWidget(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: Colors.white,
            child: BarChartWidget(
              header: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'This Week Imcoming',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See detail',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total incoming',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                            ),
                            Text(
                              '238.00'.prefixCurrency(),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Average imcoming',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                            ),
                            Text(
                              '238.00'.prefixCurrency(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
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
                    if (_cubit.baseCubit.categories.isEmpty)
                      SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(LocaleKeys.categoryEmpty.tr()),
                        ),
                      ),
                    if (_cubit.baseCubit.categories.isNotEmpty)
                      ..._cubit.baseCubit.categories.map(
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
        ],
      ),
    );
  }

  Widget _buildTitleStatisticInfo(String title, String value) {
    return ContainerShadowWidget(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(12),
      color: ColorKeys.primary.withOpacity(0.6),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
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
              _cubit.periodType == PeriodType.week
                  ? _cubit.dateTime.displayWeekFormat(context)
                  : _cubit.dateTimeSelected?.toDisplayDependLocale(context,
                          format: _cubit.periodType == PeriodType.month
                              ? DateFormatConstance.MMMM_YYYY
                              : DateFormatConstance.YYYY) ??
                      '--',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(
                  LocaleKeys.week.tr(),
                ),
                onTap: () async {
                  await pickPeriod(PeriodType.week);
                },
              ),
              PopupMenuItem(
                child: Text(
                  LocaleKeys.month.tr(),
                ),
                onTap: () async {
                  await pickPeriod(PeriodType.month);
                },
              ),
              PopupMenuItem(
                child: Text(
                  LocaleKeys.year.tr(),
                ),
                onTap: () async {
                  await pickPeriod(PeriodType.year);
                },
              ),
            ],
            child: Icon(
              key: UniqueKey(),
              CupertinoIcons.calendar_circle,
              size: 40,
            ),
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
