import 'package:equatable/equatable.dart';

abstract class PinSetupState extends Equatable {
  const PinSetupState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class PinSetupInitial extends PinSetupState {
  @override
  String toString() => 'PinSetupInitial';
}

class PinSetupLoading extends PinSetupState {
  @override
  String toString() => 'PinSetupLoading';
}

class PinSetupSuccess extends PinSetupState {
  @override
  String toString() => 'PinSetupSuccess';
}

class PinSetupConfirmSuccess extends PinSetupState {
  @override
  String toString() => 'PinSetupConfirmSuccess';
}

class PinSetupFailure extends PinSetupState {
  const PinSetupFailure();

  @override
  String toString() => 'PinSetupFailure';
}

class PinSetupArgruments extends PinSetupState {
  final String title;
  final String desc;
  const PinSetupArgruments({
    required this.title,
    required this.desc,
  });

  @override
  String toString() => 'PinSetupArgruments : $title, $desc';
}

class PinSetupAllSuccess extends PinSetupState {
  final String pin;

  const PinSetupAllSuccess(this.pin);

  @override
  String toString() => 'PinSetupAllSuccess : $pin';
}
