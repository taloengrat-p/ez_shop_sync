import 'package:equatable/equatable.dart';

abstract class PasswordSettingState extends Equatable {
  const PasswordSettingState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class PasswordSettingInitial extends PasswordSettingState {
  @override
  String toString() => 'PasswordSettingInitial';
}

class PasswordSettingLoading extends PasswordSettingState {
  @override
  String toString() => 'PasswordSettingLoading';
}

class PasswordSettingSuccess extends PasswordSettingState {
  @override
  String toString() => 'PasswordSettingSuccess';
}

class PasswordSettingFailure extends PasswordSettingState {
  const PasswordSettingFailure();

  @override
  String toString() => 'PasswordSettingFailure';
}
