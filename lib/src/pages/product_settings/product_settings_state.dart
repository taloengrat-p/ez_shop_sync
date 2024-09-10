import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class ProductSettingsState extends Equatable {
  const ProductSettingsState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class ProductSettingsRefresh extends ProductSettingsState {
  final dynamic value;

  const ProductSettingsRefresh(this.value);
  @override
  String toString() => 'ProductSettingsRefresh';

  @override
  List<Object?> get props => [value];
}

class ProductSettingsScreenModeChange extends ProductSettingsState {
  final ScreenMode mode;

  const ProductSettingsScreenModeChange(this.mode);

  @override
  String toString() => 'ProductSettingsScreenModeChange';
}

class ProductSettingsInitial extends ProductSettingsState {
  @override
  String toString() => 'ProductSettingsInitial';
}

class ProductSettingsLoading extends ProductSettingsState {
  @override
  String toString() => 'ProductSettingsLoading';
}

class ProductSettingsSuccess extends ProductSettingsState {
  @override
  String toString() => 'ProductSettingsSuccess';
}

class ProductSettingsFailure extends ProductSettingsState {
  const ProductSettingsFailure();

  @override
  String toString() => 'ProductSettingsFailure';
}
