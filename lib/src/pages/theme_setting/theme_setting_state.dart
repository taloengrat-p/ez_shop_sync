import 'package:equatable/equatable.dart';

abstract class ThemeSettingState extends Equatable {
  const ThemeSettingState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class ThemeSettingInitial extends ThemeSettingState {
  @override
  String toString() => 'ThemeSettingInitial';
}

class ThemeSettingLoading extends ThemeSettingState {
  @override
  String toString() => 'ThemeSettingLoading';
}

class ThemeSettingSuccess extends ThemeSettingState {
  @override
  String toString() => 'ThemeSettingSuccess';
}

class ThemeSettingFailure extends ThemeSettingState {
  const ThemeSettingFailure();

  @override
  String toString() => 'ThemeSettingFailure';
}

class ThemeSettingRefresh extends ThemeSettingState {
  final dynamic value;
  const ThemeSettingRefresh(this.value);

  @override
  String toString() => 'ThemeSettingRefresh $value';

  @override
  List<Object> get props => [value];
}
