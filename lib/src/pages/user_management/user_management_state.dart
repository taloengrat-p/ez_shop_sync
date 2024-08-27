import 'package:equatable/equatable.dart';

abstract class UserManagementState extends Equatable {
  const UserManagementState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class UserManagementInitial extends UserManagementState {
  @override
  String toString() => 'UserManagementInitial';
}

class UserManagementLoading extends UserManagementState {
  @override
  String toString() => 'UserManagementLoading';
}

class UserManagementSuccess extends UserManagementState {
  @override
  String toString() => 'UserManagementSuccess';
}

class UserManagementFailure extends UserManagementState {
  const UserManagementFailure();

  @override
  String toString() => 'UserManagementFailure';
}
