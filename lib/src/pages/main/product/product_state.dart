// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/models/product_sort_type.enum.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class ProductState extends Equatable {
  const ProductState() : super();

  @override
  List<Object?> get props => [];
}

class ProductCubitInitial extends ProductState {
  @override
  String toString() => 'ProductCubitInitial';
}

class ProductInitial extends ProductState {
  @override
  String toString() => 'ProductInitial';
}

class ProductLoadItemSuccess extends ProductState {
  const ProductLoadItemSuccess();

  @override
  String toString() => 'ProductLoadItemSuccess';
}

class ProductLoadItemFailure extends ProductState {
  const ProductLoadItemFailure();

  @override
  String toString() => 'ProductLoadItemFailure';
}

class ProductChangeSortType extends ProductState {
  final ProductSortType sortType;
  const ProductChangeSortType({required this.sortType});

  @override
  String toString() => 'ProductChangeSortType $sortType';

  @override
  List<Object?> get props => [sortType];
}

class ProductChangeSortTypeSuccess extends ProductState {
  final ProductSortType sortType;
  const ProductChangeSortTypeSuccess({required this.sortType});

  @override
  String toString() => 'ProductChangeSortTypeSuccess $sortType';

  @override
  List<Object?> get props => [sortType];
}

class ProductInitialLoading extends ProductState {
  @override
  String toString() => 'ProductInitialLoading';
}

class ProductRefresh extends ProductState {
  final DateTime dateTime;

  const ProductRefresh(this.dateTime);

  @override
  String toString() => 'ProductRefresh';

  @override
  List<Object?> get props => [dateTime];
}

class ProductLoading extends ProductState {
  @override
  String toString() => 'ProductLoading';
}

class ProductDeleteSuccess extends ProductState {
  final String id;
  const ProductDeleteSuccess({required this.id});

  @override
  String toString() => 'ProductLoading $id';

  @override
  List<Object?> get props => [id];
}

class ProductDeleteFailure extends ProductState {
  @override
  String toString() => 'ProductDeleteFailure';
}

class ProductAddStockSuccess extends ProductState {
  @override
  String toString() => 'ProductAddStockSuccess';
}

class ProductAddStockFailure extends ProductState {
  final ApiError apiError;
  const ProductAddStockFailure({required this.apiError});
  @override
  String toString() => 'ProductAddStockFailure $apiError';
}

class ProductLoadmoreSuccess extends ProductState {
  @override
  String toString() => 'ProductLoadmoreSuccess';
}

class ProductSuccess extends ProductState {
  @override
  String toString() => 'ProductSuccess';
}

class ProductChangeScreenMode extends ProductState {
  final ScreenMode mode;

  const ProductChangeScreenMode(this.mode);
  @override
  String toString() => 'ProductChangeScreenMode $mode';

  @override
  List<Object?> get props => [mode];
}

class ProductFailure extends ProductState {
  @override
  String toString() => 'ProductFailure';
}

class ProductLoadItemEmpty extends ProductState {
  @override
  String toString() => 'ProductLoadItemEmpty';
}
