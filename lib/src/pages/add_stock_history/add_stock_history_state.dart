import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class AddStockHistoryState extends Equatable {
  const AddStockHistoryState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class AddStockHistoryRefresh extends AddStockHistoryState {
  final dynamic value;

  const AddStockHistoryRefresh(this.value);
  @override
  String toString() => 'AddStockHistoryRefresh';

  @override
  List<Object?> get props => [value];
}

class AddStockHistoryScreenModeChange extends AddStockHistoryState {
  final ScreenMode mode;

  const AddStockHistoryScreenModeChange(this.mode);

  @override
  String toString() => 'AddStockHistoryScreenModeChange';
}

class AddStockHistoryInitial extends AddStockHistoryState {
  @override
  String toString() => 'AddStockHistoryInitial';
}

class AddStockHistoryLoading extends AddStockHistoryState {
  @override
  String toString() => 'AddStockHistoryLoading';
}

class AddStockHistorySuccess extends AddStockHistoryState {
  @override
  String toString() => 'AddStockHistorySuccess';
}

class AddStockHistoryFailure extends AddStockHistoryState {
  const AddStockHistoryFailure();

  @override
  String toString() => 'AddStockHistoryFailure';
}
