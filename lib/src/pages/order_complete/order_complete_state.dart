import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class OrderCompleteState extends Equatable {
  const OrderCompleteState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class OrderCompleteRefresh extends OrderCompleteState {
  final dynamic value;

  const OrderCompleteRefresh(this.value);
  @override
  String toString() => 'OrderCompleteRefresh';

  @override
  List<Object?> get props => [value];
}

class OrderCompleteScreenModeChange extends OrderCompleteState {
  final ScreenMode mode;

  const OrderCompleteScreenModeChange(this.mode);

  @override
  String toString() => 'OrderCompleteScreenModeChange';
}

class OrderCompleteInitial extends OrderCompleteState {
  @override
  String toString() => 'OrderCompleteInitial';
}

class OrderCompleteLoading extends OrderCompleteState {
  @override
  String toString() => 'OrderCompleteLoading';
}

class OrderCompleteSuccess extends OrderCompleteState {
  @override
  String toString() => 'OrderCompleteSuccess';
}

class OrderCompleteFailure extends OrderCompleteState {
  const OrderCompleteFailure();

  @override
  String toString() => 'OrderCompleteFailure';
}
