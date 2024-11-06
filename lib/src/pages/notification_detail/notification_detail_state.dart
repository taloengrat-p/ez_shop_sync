import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/notification.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class NotificationDetailState extends Equatable {
  const NotificationDetailState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class NotificationDetailRefresh extends NotificationDetailState {
  final dynamic value;

  const NotificationDetailRefresh(this.value);
  @override
  String toString() => 'NotificationDetailRefresh';

  @override
  List<Object?> get props => [value];
}

class NotificationDetailScreenModeChange extends NotificationDetailState {
  final ScreenMode mode;

  const NotificationDetailScreenModeChange(this.mode);

  @override
  String toString() => 'NotificationDetailScreenModeChange';
}

class NotificationDetailArgrument extends NotificationDetailState {
  final Notification notification;

  const NotificationDetailArgrument(this.notification);
  @override
  String toString() => 'NotificationDetailArgrument $notification';
  @override
  List<Object?> get props => [notification];
}

class NotificationDetailInitial extends NotificationDetailState {
  @override
  String toString() => 'NotificationDetailInitial';
}

class NotificationDetailLoading extends NotificationDetailState {
  @override
  String toString() => 'NotificationDetailLoading';
}

class NotificationDetailSuccess extends NotificationDetailState {
  @override
  String toString() => 'NotificationDetailSuccess';
}

class NotificationDetailFailure extends NotificationDetailState {
  final AppErrorType? appErrorType;
  const NotificationDetailFailure(
    this.appErrorType,
  );

  @override
  String toString() => 'NotificationDetailFailure';

  @override
  List<Object?> get props => [appErrorType];
}
