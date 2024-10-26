import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class OrderHistoryRefresh extends OrderHistoryState {
  final dynamic value;

  const OrderHistoryRefresh(this.value);
  @override
  String toString() => 'OrderHistoryRefresh';

  @override
  List<Object?> get props => [value];
}

class OrderHistoryScreenModeChange extends OrderHistoryState {
  final ScreenMode mode;

  const OrderHistoryScreenModeChange(this.mode);

  @override
  String toString() => 'OrderHistoryScreenModeChange';
}

class OrderHistoryInitial extends OrderHistoryState {
  @override
  String toString() => 'OrderHistoryInitial';
}

class OrderHistoryLoading extends OrderHistoryState {
  @override
  String toString() => 'OrderHistoryLoading';
}

class OrderHistoryLoadMore extends OrderHistoryState {
  @override
  String toString() => 'OrderHistoryLoadMore';
}

class OrderHistorySuccess extends OrderHistoryState {
  @override
  String toString() => 'OrderHistorySuccess';
}

class OrderHistoryFailure extends OrderHistoryState {
  const OrderHistoryFailure();

  @override
  String toString() => 'OrderHistoryFailure';
}

class OrderHistoryLoadMoreSuccess extends OrderHistoryState {
  final int start;
  final int end;

  const OrderHistoryLoadMoreSuccess(this.start, this.end);

  @override
  String toString() => 'OrderHistoryLoadMoreSuccess $start to $end';

  @override
  List<Object?> get props => [start, end];
}
