import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';

abstract class BaseState extends Equatable {
  const BaseState() : super();

  @override
  List<Object?> get props => [];
}

class BaseInitial extends BaseState {
  @override
  String toString() => 'BaseInitial';
}

class BaseInitialSuccess extends BaseState {
  @override
  String toString() => 'BaseInitialSuccess';
}

class BaseLoading extends BaseState {
  @override
  String toString() => 'BaseLoading';
}

class BaseSuccess extends BaseState {
  @override
  String toString() => 'BaseSuccess';
}

class BaseFailure extends BaseState {
  @override
  String toString() => 'BaseFailure';
}

class BaseRefresh extends BaseState {
  final DateTime dateTime;

  const BaseRefresh(this.dateTime);
  @override
  String toString() => 'BaseRefresh';

  @override
  List<Object?> get props => [dateTime.toIso8601String()];
}

class BaseChangeAppMode extends BaseState {
  AppMode mode;

  BaseChangeAppMode(this.mode);

  @override
  String toString() => 'BaseChangeAppMode';

  @override
  List<Object?> get props => [mode];
}

class BaseInitialLocalStorageServiceSuccess extends BaseState {
  @override
  String toString() => 'BaseInitialLocalStorageServiceSuccess';
}
