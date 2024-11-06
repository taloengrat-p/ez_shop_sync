import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class AddUserState extends Equatable {
  const AddUserState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class AddUserRefresh extends AddUserState {
  final dynamic value;

  const AddUserRefresh(this.value);
  @override
  String toString() => 'AddUserRefresh';

  @override
  List<Object?> get props => [value];
}

class AddUserScreenModeChange extends AddUserState {
  final ScreenMode mode;

  const AddUserScreenModeChange(this.mode);

  @override
  String toString() => 'AddUserScreenModeChange';
}

class AddUserInitial extends AddUserState {
  @override
  String toString() => 'AddUserInitial';
}

class AddUserLoading extends AddUserState {
  @override
  String toString() => 'AddUserLoading';
}

class AddUserSuccess extends AddUserState {
  @override
  String toString() => 'AddUserSuccess';
}

class AddUserFailure extends AddUserState {
  final AppErrorType? errorType;
  const AddUserFailure(this.errorType);

  @override
  String toString() => 'AddUserFailure $errorType';

  @override
  List<Object?> get props => [errorType];
}
