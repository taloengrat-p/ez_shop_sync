// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:ez_shop_sync/src/data/dto/hive_object/branch.dart';

abstract class BranchManagementState extends Equatable {
  const BranchManagementState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class BranchManagementInitial extends BranchManagementState {
  @override
  String toString() => 'BranchManagementInitial';
}

class BranchManagementInitialLoading extends BranchManagementState {
  @override
  String toString() => 'BranchManagementInitialLoading';
}

class BranchManagementLoading extends BranchManagementState {
  @override
  String toString() => 'BranchManagementLoading';
}

class BranchManagementRefreshSuccess extends BranchManagementState {
  @override
  String toString() => 'BranchManagementRefreshSuccess';
}

class BranchManagementDeleteSuccess extends BranchManagementState {
  final Branch branch;
  const BranchManagementDeleteSuccess({required this.branch});

  @override
  String toString() => 'BranchManagementDeleteSuccess $branch';

  @override
  List<Object> get props => [branch];
}

class BranchManagementDeleteFailure extends BranchManagementState {
  const BranchManagementDeleteFailure();

  @override
  String toString() => 'BranchManagementDeleteFailure';
}

class BranchManagementRefreshFailure extends BranchManagementState {
  @override
  String toString() => 'BranchManagementRefreshFailure';
}

class BranchManagementSuccess extends BranchManagementState {
  @override
  String toString() => 'BranchManagementSuccess';
}

class BranchManagementFailure extends BranchManagementState {
  const BranchManagementFailure();

  @override
  String toString() => 'BranchManagementFailure';
}
