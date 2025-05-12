import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class UnitTypeManagementState extends Equatable {
  const UnitTypeManagementState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class UnitTypeManagementRefresh extends UnitTypeManagementState {
  final dynamic value;

  const UnitTypeManagementRefresh(this.value);
  @override
  String toString() => 'UnitTypeManagementRefresh';

  @override
  List<Object?> get props => [value];
}

class UnitTypeManagementScreenModeChange extends UnitTypeManagementState {
  final ScreenMode mode;

  const UnitTypeManagementScreenModeChange(this.mode);

  @override
  String toString() => 'UnitTypeManagementScreenModeChange';
}

class UnitTypeManagementInitial extends UnitTypeManagementState {
  @override
  String toString() => 'UnitTypeManagementInitial';
}

class UnitTypeManagementLoading extends UnitTypeManagementState {
  @override
  String toString() => 'UnitTypeManagementLoading';
}

class UnitTypeManagementSuccess extends UnitTypeManagementState {
  @override
  String toString() => 'UnitTypeManagementSuccess';
}

class UnitTypeManagementFailure extends UnitTypeManagementState {
  const UnitTypeManagementFailure();

  @override
  String toString() => 'UnitTypeManagementFailure';
}
