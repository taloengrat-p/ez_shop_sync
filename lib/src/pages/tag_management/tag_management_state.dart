import 'package:equatable/equatable.dart';

abstract class TagManagementState extends Equatable {
  const TagManagementState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class TagManagementRefreshState extends TagManagementState {
  final DateTime dateTime;

  const TagManagementRefreshState(this.dateTime);

  @override
  String toString() => 'TagManagementRefreshState';

  @override
  List<Object> get props => [dateTime.toIso8601String()];
}

class TagManagementInitial extends TagManagementState {
  @override
  String toString() => 'TagManagementInitial';
}

class TagManagementLoading extends TagManagementState {
  @override
  String toString() => 'TagManagementLoading';
}

class TagManagementSuccess extends TagManagementState {
  @override
  String toString() => 'TagManagementSuccess';
}

class TagManagementFailure extends TagManagementState {
  const TagManagementFailure();

  @override
  String toString() => 'TagManagementFailure';
}

class TagManagementDeleteSuccess extends TagManagementState {
  @override
  String toString() => 'TagManagementDeleteSuccess';
}
