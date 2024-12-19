import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginState extends Equatable {
  const LoginState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class LoginRefresh extends LoginState {
  final dynamic value;

  const LoginRefresh(this.value);
  @override
  String toString() => 'LoginRefresh';

  @override
  List<Object?> get props => [value];
}

class LoginScreenModeChange extends LoginState {
  final ScreenMode mode;

  const LoginScreenModeChange(this.mode);

  @override
  String toString() => 'LoginScreenModeChange $mode';
  @override
  List<Object?> get props => [mode];
}

class LoginPasswordNotMatch extends LoginState {
  @override
  String toString() => 'LoginPasswordNotMatch';
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';
}

class RegisterConfirmPhoneNumber extends LoginState {
  final UserCredential userCredential;
  final String phoneNumber;
  const RegisterConfirmPhoneNumber(this.phoneNumber, this.userCredential);

  @override
  String toString() => 'RegisterConfirmPhoneNumber $phoneNumber';

  @override
  List<Object?> get props => [phoneNumber];
}

class RegisterSuccess extends LoginState {
  @override
  String toString() => 'RegisterSuccess';
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
}

class LoginSuccess extends LoginState {
  @override
  String toString() => 'LoginSuccess';
}

class LoginFailure extends LoginState {
  final Object? error;
  final AppErrorType? errorType;
  const LoginFailure(this.error, {this.errorType});

  @override
  String toString() => 'LoginFailure $error $errorType';

  @override
  List<Object?> get props => [
        error,
        errorType,
      ];
}
