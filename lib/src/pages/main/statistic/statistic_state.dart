import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/period_type.enum.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class StatisticState extends Equatable {
  const StatisticState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class StatisticRefresh extends StatisticState {
  final dynamic value;

  const StatisticRefresh(this.value);
  @override
  String toString() => 'StatisticRefresh';

  @override
  List<Object?> get props => [value];
}

class StatisticScreenModeChange extends StatisticState {
  final ScreenMode mode;

  const StatisticScreenModeChange(this.mode);

  @override
  String toString() => 'StatisticScreenModeChange';
}

class StatisticInitial extends StatisticState {
  @override
  String toString() => 'StatisticInitial';
}

class StatisticLoading extends StatisticState {
  @override
  String toString() => 'StatisticLoading';
}

class StatisticSuccess extends StatisticState {
  @override
  String toString() => 'StatisticSuccess';
}

class StatisticSelectDatePeriod extends StatisticState {
  final List<DateTime?>? dateSelected;
  final PeriodType periodType;
  const StatisticSelectDatePeriod(this.periodType, this.dateSelected);
  @override
  String toString() => 'StatisticSelectDatePeriod type $periodType, $dateSelected ';

  @override
  List<Object?> get props => dateSelected ?? [];
}

class StatisticFailure extends StatisticState {
  const StatisticFailure();

  @override
  String toString() => 'StatisticFailure';
}
