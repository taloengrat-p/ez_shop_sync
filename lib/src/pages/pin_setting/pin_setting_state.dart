import 'package:equatable/equatable.dart';

abstract class PinSettingState extends Equatable {
  const PinSettingState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class PinSettingInitial extends PinSettingState {
  @override
  String toString() => 'PinSettingInitial';
}

class PinSettingLoading extends PinSettingState {
  @override
  String toString() => 'PinSettingLoading';
}

class PinSettingSuccess extends PinSettingState {
  @override
  String toString() => 'PinSettingSuccess';
}

class PinSettingFailure extends PinSettingState {
  const PinSettingFailure();

  @override
  String toString() => 'PinSettingFailure';
}
