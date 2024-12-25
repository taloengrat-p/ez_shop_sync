import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/transaction.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/data/repository/transactions/transaction_repository.dart';
import 'package:ez_shop_sync/src/models/period_type.enum.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/statistic/statistic_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/num_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticCubit extends Cubit<StatisticState> {
  DateTime _dateTimeSelected = DateTime.now();
  CategoryRepository categoryRepository;
  OrderRepository orderRepository;
  TransactionRepository transactionRepository;
  BaseCubit baseCubit;
  PeriodType periodType = PeriodType.week;

  List<DateTime> get dateTime => periodType == PeriodType.week
      ? _dateTimeSelected.getCurrentWeek()
      : periodType == PeriodType.month
          ? dateTimeSelected.getDaysInMonth()
          : dateTimeSelected.getAllMonthsInYear();

  DateTime get dateTimeSelected => _dateTimeSelected;

  num get totalSales => transaction.where((e) => e.getTransactionType == TransactionType.income).fold(
      0.0,
      (sum, item) =>
          sum + item.totalPrice); // ordered.fold(0.0, (sum, item) => sum + item.totalPriceIncludeServiceCharge);
  num get netProfit => transaction.fold(
        0.0,
        (sum, item) =>
            item.getTransactionType == TransactionType.income ? sum + item.totalPrice : sum - item.totalPrice,
      );

  List<ProductOrder> _ordered = [];
  List<ProductOrder> get ordered => _ordered;
  List<Transaction> _transaction = [];
  List<Transaction> get transaction => _transaction;
  List<Transaction> get transactionPerview => transaction.take(3).toList();

  StatisticCubit({
    required this.categoryRepository,
    required this.orderRepository,
    required this.baseCubit,
    required this.transactionRepository,
  }) : super(StatisticInitial());

  String get averageIncome => (totalSales /
          (periodType == PeriodType.week
              ? dateTime.whereDayActived().length
              : periodType == PeriodType.month
                  ? DateTime.now().getWeekMonth()
                  : DateTime.now().getMonthYear()))
      .ceilToDecimalPlaces(2)
      .toString();

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
          ? DateTime(item.info?.createAt!.year, item.info?.createAt!.month, item.info?.createAt!.day)
          : periodType == PeriodType.month
              ? DateTime(item.info?.createAt!.year, item.info?.createAt!.month, item.info?.createAt!.day)
              : DateTime(item.info?.createAt!.year, item.info?.createAt!.month);

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
      return MapEntry(DateTime(value.year, value.month, value.getWeekMonth()), []);
    });

    for (var item in items) {
      if (groupedItems.containsKey(
          DateTime(item.info?.createAt!.year, item.info?.createAt!.month, item.info?.createAt!.getWeekMonth()))) {
        groupedItems[DateTime(
                item.info?.createAt!.year, item.info?.createAt!.month, item.info?.createAt!.getWeekMonth())]!
            .add(item);
      } else {
        groupedItems[DateTime(
            item.info?.createAt!.year, item.info?.createAt!.month, item.info?.createAt!.getWeekMonth())] = [item];
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

    _transaction = await transactionRepository.getAllByStoreId(
      BaseRepoRequest(storeId: baseCubit.store!.id, userId: baseCubit.user?.uid ?? ''),
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
