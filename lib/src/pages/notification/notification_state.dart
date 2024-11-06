import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/notification.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class NotificationState extends Equatable {
  const NotificationState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class NotificationRefresh extends NotificationState {
  final dynamic value;

  const NotificationRefresh(this.value);
  @override
  String toString() => 'NotificationRefresh';

  @override
  List<Object?> get props => [value];
}

class NotificationScreenModeChange extends NotificationState {
  final ScreenMode mode;

  const NotificationScreenModeChange(this.mode);

  @override
  String toString() => 'NotificationScreenModeChange';
}

class NotificationInitial extends NotificationState {
  @override
  String toString() => 'NotificationInitial';
}

class NotificationArgrument extends NotificationState {
  final List<Notification> notifications;
  const NotificationArgrument(this.notifications);
  @override
  String toString() => 'NotificationArgrument $notifications';
  @override
  List<Object?> get props => [notifications];
}

class NotificationLoading extends NotificationState {
  @override
  String toString() => 'NotificationLoading';
}

class NotificationSuccess extends NotificationState {
  @override
  String toString() => 'NotificationSuccess';
}

class NotificationFailure extends NotificationState {
  const NotificationFailure();

  @override
  String toString() => 'NotificationFailure';
}
