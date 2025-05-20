import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class NotificationSettingsState extends Equatable {
  const NotificationSettingsState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class NotificationSettingsRefresh extends NotificationSettingsState {
  final dynamic value;

  const NotificationSettingsRefresh(this.value);
  @override
  String toString() => 'NotificationSettingsRefresh';

  @override
  List<Object?> get props => [value];
}

class NotificationSettingsScreenModeChange extends NotificationSettingsState {
  final ScreenMode mode;

  const NotificationSettingsScreenModeChange(this.mode);

  @override
  String toString() => 'NotificationSettingsScreenModeChange';
}

class NotificationSettingsInitial extends NotificationSettingsState {
  @override
  String toString() => 'NotificationSettingsInitial';
}

class NotificationSettingsLoading extends NotificationSettingsState {
  @override
  String toString() => 'NotificationSettingsLoading';
}

class NotificationSettingsSuccess extends NotificationSettingsState {
  @override
  String toString() => 'NotificationSettingsSuccess';
}

class NotificationSettingsFailure extends NotificationSettingsState {
  const NotificationSettingsFailure();

  @override
  String toString() => 'NotificationSettingsFailure';
}
