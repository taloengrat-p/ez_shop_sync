import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/models/period_type.enum.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class TransactionsChartDetailsState extends Equatable {
  const TransactionsChartDetailsState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class TransactionsChartDetailsRefresh extends TransactionsChartDetailsState {
  final dynamic value;

  const TransactionsChartDetailsRefresh(this.value);
  @override
  String toString() => 'TransactionsChartDetailsRefresh';

  @override
  List<Object?> get props => [value];
}

class TransactionsChartDetailsScreenModeChange extends TransactionsChartDetailsState {
  final ScreenMode mode;

  const TransactionsChartDetailsScreenModeChange(this.mode);

  @override
  String toString() => 'TransactionsChartDetailsScreenModeChange';
}

class TransactionsChartDetailsArgrument extends TransactionsChartDetailsState {
  final PeriodType periodType;
  final Map<DateTime, List<ProductOrder>> days;
  final String periodTitle;

  const TransactionsChartDetailsArgrument({
    required this.periodType,
    required this.days,
    required this.periodTitle,
  });
  @override
  String toString() => 'TransactionsChartDetailsArgrument $periodTitle $periodType';

  @override
  List<Object?> get props => [
        periodTitle,
        periodType,
        days,
      ];
}

class TransactionsChartDetailsInitial extends TransactionsChartDetailsState {
  @override
  String toString() => 'TransactionsChartDetailsInitial';
}

class TransactionsChartDetailsLoading extends TransactionsChartDetailsState {
  @override
  String toString() => 'TransactionsChartDetailsLoading';
}

class TransactionsChartDetailsSuccess extends TransactionsChartDetailsState {
  @override
  String toString() => 'TransactionsChartDetailsSuccess';
}

class TransactionsChartDetailsFailure extends TransactionsChartDetailsState {
  const TransactionsChartDetailsFailure();

  @override
  String toString() => 'TransactionsChartDetailsFailure';
}
