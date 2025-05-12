// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/branch.dart';
import 'package:ez_shop_sync/src/models/enums/app_error_type.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class AddBranchState extends Equatable {
  const AddBranchState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class AddBranchRefresh extends AddBranchState {
  final dynamic value;

  const AddBranchRefresh(this.value);
  @override
  String toString() => 'AddBranchRefresh';

  @override
  List<Object?> get props => [value];
}

class AddBranchScreenModeChange extends AddBranchState {
  final ScreenMode mode;

  const AddBranchScreenModeChange(this.mode);

  @override
  String toString() => 'AddBranchScreenModeChange';
}

class AddBranchInitial extends AddBranchState {
  @override
  String toString() => 'AddBranchInitial';
}

class AddBranchLoading extends AddBranchState {
  @override
  String toString() => 'AddBranchLoading';
}

class AddBranchSuccess extends AddBranchState {
  final Branch branch;
  const AddBranchSuccess({required this.branch});
  @override
  String toString() => 'AddBranchSuccess $branch';

  @override
  List<Object?> get props => [branch];
}

class AddBranchFailure extends AddBranchState {
  final ApiError? apiError;
  const AddBranchFailure(this.apiError);

  @override
  String toString() => 'AddBranchFailure $apiError';

  @override
  List<Object?> get props => [apiError];
}
