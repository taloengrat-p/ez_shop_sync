import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class VerifyPhoneNumberState extends Equatable {
  const VerifyPhoneNumberState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class VerifyPhoneNumberRefresh extends VerifyPhoneNumberState {
  final dynamic value;

  const VerifyPhoneNumberRefresh(this.value);
  @override
  String toString() => 'VerifyPhoneNumberRefresh';

  @override
  List<Object?> get props => [value];
}

class VerifyPhoneNumberScreenModeChange extends VerifyPhoneNumberState {
  final ScreenMode mode;

  const VerifyPhoneNumberScreenModeChange(this.mode);

  @override
  String toString() => 'VerifyPhoneNumberScreenModeChange';
}

class VerifyPhoneNumberArgrument extends VerifyPhoneNumberState {
  final String phoneNumber;

  const VerifyPhoneNumberArgrument(
    this.phoneNumber,
  );
  @override
  String toString() => 'VerifyPhoneNumberArgrument $phoneNumber';
}

class VerifyPhoneNumberInitial extends VerifyPhoneNumberState {
  @override
  String toString() => 'VerifyPhoneNumberInitial';
}

class VerifyPhoneNumberLoading extends VerifyPhoneNumberState {
  @override
  String toString() => 'VerifyPhoneNumberLoading';
}

class VerifyPhoneNumberSuccess extends VerifyPhoneNumberState {
  @override
  String toString() => 'VerifyPhoneNumberSuccess';
}

class VerifyPhoneNumberFailure extends VerifyPhoneNumberState {
  final String message;
  const VerifyPhoneNumberFailure(this.message);

  @override
  String toString() => 'VerifyPhoneNumberFailure $message';
}
