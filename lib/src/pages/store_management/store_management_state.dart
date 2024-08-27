import 'package:equatable/equatable.dart';

abstract class StoreManagementState extends Equatable {
  const StoreManagementState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class StoreManagementInitial extends StoreManagementState {
  @override
  String toString() => 'StoreManagementInitial';
}

class StoreManagementLoading extends StoreManagementState {
  @override
  String toString() => 'StoreManagementLoading';
}

class StoreManagementSuccess extends StoreManagementState {
  @override
  String toString() => 'StoreManagementSuccess';
}

class StoreManagementFailure extends StoreManagementState {
  const StoreManagementFailure();

  @override
  String toString() => 'StoreManagementFailure';
}
