import 'package:equatable/equatable.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState() : super();

  @override
  List<Object?> get props => [];
}

class ProductDetailInitial extends ProductDetailState {
  @override
  String toString() => 'ProductDetailInitial';
}

class ProductDetailLoading extends ProductDetailState {
  @override
  String toString() => 'ProductDetailLoading';
}

class ProductDetailSuccess extends ProductDetailState {
  @override
  String toString() => 'ProductDetailSuccess';
}

class ProductDetailFailure extends ProductDetailState {
  @override
  String toString() => 'ProductDetailFailure';
}

class ProductDetailLoadHistorySuccess extends ProductDetailState {
  @override
  String toString() => 'ProductDetailLoadHistorySuccess';
}

class ProductDetailDelete extends ProductDetailState {
  @override
  String toString() => 'ProductDetailDelete';
}

class ProductDetailRefresh extends ProductDetailState {
  final DateTime dateTime;

  const ProductDetailRefresh(this.dateTime);
  @override
  String toString() => 'ProductDetailRefresh';

  @override
  List<Object?> get props => [dateTime.toIso8601String()];
}
