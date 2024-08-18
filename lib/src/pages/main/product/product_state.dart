import 'package:equatable/equatable.dart';

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

class ProductSuccess extends ProductState {
  @override
  String toString() => 'ProductSuccess';
}

class ProductFailure extends ProductState {
  @override
  String toString() => 'ProductFailure';
}
