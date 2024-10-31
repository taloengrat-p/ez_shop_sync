import 'package:equatable/equatable.dart';
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
