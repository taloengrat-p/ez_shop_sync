import 'package:equatable/equatable.dart';

abstract class MoreState extends Equatable {
  const MoreState() : super();

  @override
  List<Object?> get props => [];
}

class MoreInitial extends MoreState {
  @override
  String toString() => 'MoreInitial';
}

class MoreRefresh extends MoreState {
  final DateTime dateTime;

  MoreRefresh(this.dateTime);

  @override
  String toString() => 'MoreRefresh';

  @override
  List<Object?> get props => [dateTime];
}

class MoreLoading extends MoreState {
  @override
  String toString() => 'MoreLoading';
}

class MoreSuccess extends MoreState {
  @override
  String toString() => 'MoreSuccess';
}

class MoreFailure extends MoreState {
  @override
  String toString() => 'MoreFailure';
}

class MoreClickPinSetting extends MoreState {
  final PinType type;

  const MoreClickPinSetting(this.type);
  @override
  String toString() => 'MoreClickPinSetting $type';

  @override
  List<Object?> get props => [type];
}

class MoreSetupPinSuccess extends MoreState {
  @override
  String toString() => 'MoreSetupPinSuccess';
}

enum PinType {
  setting,
  create;
}
