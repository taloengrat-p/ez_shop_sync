import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class StoreManagementState extends Equatable {
  const StoreManagementState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
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

class StoreManagementDeleteSuccess extends StoreManagementState {
  final Store? store;

  const StoreManagementDeleteSuccess(
    this.store,
  );
  @override
  String toString() => 'StoreManagementDeleteSuccess';

  @override
  List<Object?> get props => [store?.id];
}

class StoreManagementScreenModeChange extends StoreManagementState {
  final ScreenMode mode;
  const StoreManagementScreenModeChange(
    this.mode,
  );

  @override
  String toString() => 'StoreManagementScreenModeChange $mode';

  @override
  List<Object?> get props => [mode];
}

class StoreManagementUpdateSuccess extends StoreManagementState {
  @override
  String toString() => 'StoreManagementUpdateSuccess';
}
