import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/models/period_type.enum.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/statistic/statistic_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

class StatisticCubit extends Cubit<StatisticState> {
  DateTime _dateTimeSelected = DateTime.now();
  CategoryRepository categoryRepository;
  OrderRepository orderRepository;

  BaseCubit baseCubit;
  PeriodType periodType = PeriodType.week;

  List<DateTime> get dateTime => periodType == PeriodType.week
      ? _dateTimeSelected.getCurrentWeek()
      : periodType == PeriodType.month
          ? dateTimeSelected.getDaysInMonth()
          : dateTimeSelected.getAllMonthsInYear();

  DateTime get dateTimeSelected => _dateTimeSelected;

  num get totalSales => ordered.fold(0.0, (sum, item) => sum + item.totalPriceIncludeServiceCharge);

  List<ProductOrder> _ordered = [];
  List<ProductOrder> get ordered => _ordered;

  StatisticCubit({
    required this.categoryRepository,
    required this.orderRepository,
    required this.baseCubit,
  }) : super(StatisticInitial());

  String get averageIncome => (totalSales / dateTime.whereDayActived().length).ceilToDecimalPlaces(2).toString();

  Map<DateTime, List<ProductOrder>> get dateTimeWithValue =>
      periodType == PeriodType.month ? groupDatesBy4Weeks(ordered) : groupItemsByDate(ordered);

  Map<DateTime, List<ProductOrder>> groupItemsByDate(List<ProductOrder> items) {
    Map<DateTime, List<ProductOrder>> groupedItems = dateTime.asMap().map((index, value) {
      return MapEntry(
          periodType == PeriodType.week
              ? DateTime(value.year, value.month, value.day)
              : periodType == PeriodType.month
                  ? DateTime(value.year, value.month, value.day)
                  : DateTime(value.year, value.month),
          []);
    });
    for (var item in items) {
      // Normalize the date to ignore time (only keep the year, month, day)

      DateTime date = periodType == PeriodType.week
          ? DateTime(item.createDate!.year, item.createDate!.month, item.createDate!.day)
          : periodType == PeriodType.month
              ? DateTime(item.createDate!.year, item.createDate!.month, item.createDate!.day)
              : DateTime(item.createDate!.year, item.createDate!.month);

      if (groupedItems.containsKey(date)) {
        groupedItems[date]!.add(item);
      } else {
        groupedItems[date] = [item];
      }
    }

    return groupedItems;
  }

  Map<DateTime, List<ProductOrder>> groupDatesBy4Weeks(List<ProductOrder> items) {
    Map<DateTime, List<ProductOrder>> groupedItems = dateTime.asMap().map((index, value) {
      return MapEntry(DateTime(value.year, value.month, value.getWeekOfMonth()), []);
    });

    for (var item in items) {
      if (groupedItems
          .containsKey(DateTime(item.createDate!.year, item.createDate!.month, item.createDate!.getWeekOfMonth()))) {
        groupedItems[DateTime(item.createDate!.year, item.createDate!.month, item.createDate!.getWeekOfMonth())]!
            .add(item);
      } else {
        groupedItems[DateTime(item.createDate!.year, item.createDate!.month, item.createDate!.getWeekOfMonth())] = [
          item
        ];
      }
    }

    return groupedItems;
  }

  initialize() async {
    _ordered = orderRepository.getAllBetween(
      baseCubit.store?.id ?? '',
      start: periodType == PeriodType.week
          ? DateTime(dateTime.first.year, dateTime.first.month, dateTime.first.day, 0, 0, 0, 0)
          : periodType == PeriodType.month
              ? DateTime(dateTimeSelected.year, dateTimeSelected.month)
              : DateTime(dateTimeSelected.year),
      end: periodType == PeriodType.week
          ? DateTime(dateTime.first.year, dateTime.last.month, dateTime.last.day + 1, 0, 0, 0, 0)
          : periodType == PeriodType.month
              ? DateTime(dateTimeSelected.year, dateTimeSelected.month).getLastDayByMonth()
              : DateTime(dateTimeSelected.year + 1),
    );
    emit(StatisticInitial());
  }

  setCurrentDateTime(PeriodType type, DateTime value) {
    periodType = type;
    _dateTimeSelected = value;
    emit(StatisticSelectDatePeriod(periodType, dateTime));
    initialize();
  }
}
