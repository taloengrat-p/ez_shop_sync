import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class ProfileSettingsState extends Equatable {
  const ProfileSettingsState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class ProfileSettingsRefresh extends ProfileSettingsState {
  final dynamic value;

  const ProfileSettingsRefresh(this.value);
  @override
  String toString() => 'ProfileSettingsRefresh';

  @override
  List<Object> get props => [value];
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

class ProfileSettingsDeleteSuccess extends ProfileSettingsState {
  @override
  String toString() => 'ProfileSettingsDeleteSuccess';
}

class ProfileSettingsFailure extends ProfileSettingsState {
  const ProfileSettingsFailure();

  @override
  String toString() => 'ProfileSettingsFailure';
}

class ProfileSettingsUpdateSuccess extends ProfileSettingsState {
  const ProfileSettingsUpdateSuccess();

  @override
  String toString() => 'ProfileSettingsUpdateSuccess';
}

class ProfileSettingsModeChange extends ProfileSettingsState {
  final ScreenMode mode;

  const ProfileSettingsModeChange(this.mode);

  @override
  String toString() => 'ProfileSettingsModeChange $mode';

  @override
  List<Object> get props => [mode];
}
