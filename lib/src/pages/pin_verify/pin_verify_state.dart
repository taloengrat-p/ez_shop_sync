import 'package:equatable/equatable.dart';

abstract class PinVerifyState extends Equatable {
  const PinVerifyState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class PinVerifyInitial extends PinVerifyState {
  @override
  String toString() => 'PinVerifyInitial';
}

class PinVerifyLoading extends PinVerifyState {
  @override
  String toString() => 'PinVerifyLoading';
}

class PinVerifySuccess extends PinVerifyState {
  @override
  String toString() => 'PinVerifySuccess';
}

class PinVerifyFailure extends PinVerifyState {
  const PinVerifyFailure();

  @override
  String toString() => 'PinVerifyFailure';
}

class PinVerifyClearByFailure extends PinVerifyState {
  const PinVerifyClearByFailure();

  @override
  String toString() => 'PinVerifyClearByFailure';
}

class PinVerifyRefresh extends PinVerifyState {
  final DateTime dateTime;
  const PinVerifyRefresh(
    this.dateTime,
  );

  @override
  String toString() => 'PinVerifyRefresh $dateTime';

  @override
  List<Object> get props => [dateTime];
}
