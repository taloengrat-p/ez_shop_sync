import 'package:ez_shop_sync/src/models/period_type.enum.dart';
import 'package:ez_shop_sync/src/pages/main/statistic/statistic_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticCubit extends Cubit<StatisticState> {
  DateTime? _dateTimeSelected;

  PeriodType periodType = PeriodType.week;

  List<DateTime> get dateTime => [
        _dateTimeSelected?.getStartOfWeek() ?? DateTime.now().getStartOfWeek(),
        _dateTimeSelected?.getEndOfWeek() ?? DateTime.now().getEndOfWeek(),
      ];

  StatisticCubit() : super(StatisticInitial());

  initialize() async {}

  setCurrentDateTime(PeriodType type, DateTime value) {
    periodType = type;
    _dateTimeSelected = value;
    emit(StatisticSelectDatePeriod(periodType, dateTime));
  }
}
