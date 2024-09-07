import 'package:equatable/equatable.dart';

abstract class CategoryManagementState extends Equatable {
  const CategoryManagementState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class CategoryManagementRefresh extends CategoryManagementState {
  final DateTime dateTime;

  const CategoryManagementRefresh(this.dateTime);
  @override
  String toString() => 'CategoryManagementRefresh';

  @override
  List<Object?> get props => [dateTime.toIso8601String()];
}

class CategoryManagementInitial extends CategoryManagementState {
  @override
  String toString() => 'CategoryManagementInitial';
}

class CategoryManagementLoading extends CategoryManagementState {
  @override
  String toString() => 'CategoryManagementLoading';
}

class CategoryManagementSuccess extends CategoryManagementState {
  @override
  String toString() => 'CategoryManagementSuccess';
}

class CategoryManagementFailure extends CategoryManagementState {
  const CategoryManagementFailure();

  @override
  String toString() => 'CategoryManagementFailure';
}
