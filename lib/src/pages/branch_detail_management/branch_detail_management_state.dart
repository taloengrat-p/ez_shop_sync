// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:ez_shop_sync/src/data/dto/hive_object/branch.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class BranchDetailManagementState extends Equatable {
  const BranchDetailManagementState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class BranchDetailManagementRefresh extends BranchDetailManagementState {
  final dynamic value;

  const BranchDetailManagementRefresh(this.value);
  @override
  String toString() => 'BranchDetailManagementRefresh';

  @override
  List<Object?> get props => [value];
}

class BranchDetailManagementScreenModeChange extends BranchDetailManagementState {
  final ScreenMode mode;

  const BranchDetailManagementScreenModeChange(this.mode);

  @override
  String toString() => 'BranchDetailManagementScreenModeChange';
}

class BranchDetailManagementInitial extends BranchDetailManagementState {
  @override
  String toString() => 'BranchDetailManagementInitial';
}

class BranchDetailManagementLoading extends BranchDetailManagementState {
  @override
  String toString() => 'BranchDetailManagementLoading';
}

class BranchDetailManagementSuccess extends BranchDetailManagementState {
  @override
  String toString() => 'BranchDetailManagementSuccess';
}

class BranchDetailManagementToggleCheck extends BranchDetailManagementState {
  final int index;
  final bool? value;

  const BranchDetailManagementToggleCheck({required this.index, required this.value});

  @override
  List<Object?> get props => [index, value];

  @override
  String toString() => 'BranchDetailManagementToggleCheck(index: $index, value: $value)';
}

class BranchDetailManagementFailure extends BranchDetailManagementState {
  const BranchDetailManagementFailure();

  @override
  String toString() => 'BranchDetailManagementFailure';
}

class BranchDetailManagementArgrument extends BranchDetailManagementState {
  final Branch branch;
  const BranchDetailManagementArgrument(this.branch);

  @override
  String toString() => 'BranchDetailManagementArgrument $branch';

  @override
  List<Object?> get props => [branch];
}
