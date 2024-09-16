import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class ProductState extends Equatable {
  const ProductState() : super();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  @override
  String toString() => 'ProductInitial';
}

class ProductRefresh extends ProductState {
  final DateTime dateTime;

  ProductRefresh(this.dateTime);

  @override
  String toString() => 'ProductRefresh';

  @override
  List<Object?> get props => [dateTime];
}

class ProductLoading extends ProductState {
  @override
  String toString() => 'ProductLoading';
}

class ProductAddStockSuccess extends ProductState {
  @override
  String toString() => 'ProductAddStockSuccess';
}

class ProductSuccess extends ProductState {
  @override
  String toString() => 'ProductSuccess';
}

class ProductChangeScreenMode extends ProductState {
  final ScreenMode mode;

  const ProductChangeScreenMode(
    this.mode,
  );
  @override
  String toString() => 'ProductChangeScreenMode $mode';

  @override
  List<Object?> get props => [mode];
}

class ProductFailure extends ProductState {
  @override
  String toString() => 'ProductFailure';
}
