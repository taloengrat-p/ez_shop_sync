// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:ez_shop_sync/src/data/dto/hive_object/unit_type.dart';

abstract class UnitTypeManagementState extends Equatable {
  const UnitTypeManagementState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class UnitTypeManagementInitial extends UnitTypeManagementState {
  @override
  String toString() => 'UnitTypeManagementInitial';
}

class UnitTypeManagementInitialLoading extends UnitTypeManagementState {
  @override
  String toString() => 'UnitTypeManagementInitialLoading';
}

class UnitTypeManagementLoading extends UnitTypeManagementState {
  @override
  String toString() => 'UnitTypeManagementLoading';
}

class UnitTypeManagementRefreshSuccess extends UnitTypeManagementState {
  @override
  String toString() => 'UnitTypeManagementRefreshSuccess';
}

class UnitTypeManagementDeleteSuccess extends UnitTypeManagementState {
  final UnitType unitType;

  const UnitTypeManagementDeleteSuccess({required this.unitType});

  @override
  String toString() => 'UnitTypeManagementDeleteSuccess $UnitType';

  @override
  List<Object> get props => [UnitType];
}

class UnitTypeManagementDeleteFailure extends UnitTypeManagementState {
  const UnitTypeManagementDeleteFailure();

  @override
  String toString() => 'UnitTypeManagementDeleteFailure';
}

class UnitTypeManagementRefreshFailure extends UnitTypeManagementState {
  @override
  String toString() => 'UnitTypeManagementRefreshFailure';
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
