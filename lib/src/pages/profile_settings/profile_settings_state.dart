import 'package:equatable/equatable.dart';

abstract class ProfileSettingsState extends Equatable {
  const ProfileSettingsState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class ProfileSettingsInitial extends ProfileSettingsState {
  @override
  String toString() => 'ProfileSettingsInitial';
}

class ProfileSettingsLoading extends ProfileSettingsState {
  @override
  String toString() => 'ProfileSettingsLoading';
}

class ProfileSettingsSuccess extends ProfileSettingsState {
  @override
  String toString() => 'ProfileSettingsSuccess';
}

class ProfileSettingsFailure extends ProfileSettingsState {
  const ProfileSettingsFailure();

  @override
  String toString() => 'ProfileSettingsFailure';
}
