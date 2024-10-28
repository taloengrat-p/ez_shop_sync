import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/models/period_type.enum.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/statistic/statistic_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

class StatisticCubit extends Cubit<StatisticState> {
  DateTime? _dateTimeSelected;
  CategoryRepository categoryRepository;
  OrderRepository orderRepository;

  BaseCubit baseCubit;
  PeriodType periodType = PeriodType.week;

  List<DateTime> get dateTime => [
        _dateTimeSelected?.getStartOfWeek() ?? DateTime.now().getStartOfWeek(),
        _dateTimeSelected?.getEndOfWeek() ?? DateTime.now().getEndOfWeek(),
      ];

  DateTime? get dateTimeSelected => _dateTimeSelected;

  num get totalSales => ordered.fold(0.0, (sum, item) => sum + item.totalPriceIncludeServiceCharge);
  List<ProductOrder> _ordered = [];
  List<ProductOrder> get ordered => _ordered;

  StatisticCubit({
    required this.categoryRepository,
    required this.orderRepository,
    required this.baseCubit,
  }) : super(StatisticInitial());

  initialize() async {
    _ordered = orderRepository.getAllBetween(
      baseCubit.store?.id ?? '',
      start: periodType == PeriodType.week
          ? DateTime(dateTime.first.year, dateTime.first.month, dateTime.first.day, 0, 0, 0, 0)
          : periodType == PeriodType.month
              ? DateTime(dateTimeSelected!.year, dateTimeSelected!.month)
              : DateTime(dateTimeSelected!.year),
      end: periodType == PeriodType.week
          ? DateTime(dateTime.first.year, dateTime.last.month, dateTime.last.day + 1, 0, 0, 0, 0)
          : periodType == PeriodType.month
              ? DateTime(dateTimeSelected!.year, dateTimeSelected!.month).getLastDayByMonth()
              : DateTime(dateTimeSelected!.year + 1),
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
