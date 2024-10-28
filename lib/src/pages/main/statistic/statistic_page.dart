import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/models/period_type.enum.dart';
import 'package:ez_shop_sync/src/pages/main/statistic/statistic_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/statistic/statistic_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/chart/bar_chart_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_shadow_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/column_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    _cubit = StatisticCubit();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      setState(() {});
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
              key: UniqueKey(),
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
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: SingleChildScrollView(
        child: ColumnGapWidget(
          gap: 12,
          children: [
            _buildPeriodDateTime(),
            _buildTitleStatisticInfo('${LocaleKeys.totalSales.tr()} : ', '1200'),
            _buildTitleStatisticInfo(
              '${LocaleKeys.netProfit.tr()} : ',
              '500',
            ),
            BarChartWidget(),
            Container(
              height: DimensionsKeys.heightBts,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleStatisticInfo(String title, String value) {
    return ContainerShadowWidget(
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            _cubit.dateTime.displayWeekFormat(context),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        MenuAnchor(
          builder: (BuildContext context, MenuController controller, Widget? widget) {
            return IconButton(
              onPressed: () {
                if (!controller.isOpen) {
                  controller.open();
                }
              },
              icon: Icon(
                key: UniqueKey(),
                CupertinoIcons.calendar_circle,
                size: 40,
              ),
            );
          },
          key: UniqueKey(),
          menuChildren: [
            MenuItemButton(
              child: Text(
                LocaleKeys.week.tr(),
              ),
              onPressed: () async {
                await pickPeriod(PeriodType.week);
              },
            ),
            MenuItemButton(
              child: Text(
                LocaleKeys.month.tr(),
              ),
              onPressed: () async {
                await pickPeriod(PeriodType.month);
              },
            ),
            MenuItemButton(
              child: Text(
                LocaleKeys.year.tr(),
              ),
              onPressed: () async {
                await pickPeriod(PeriodType.year);
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> pickPeriod(PeriodType type) async {
    final dateSelect = await showDatePicker(
      context: context.findRootAncestorStateOfType<NavigatorState>()!.context,
      useRootNavigator: false,
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
