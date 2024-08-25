import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';

abstract class CreateProductState extends Equatable {
  const CreateProductState() : super();

  @override
  List<Object?> get props => [];
}

class CreateProductInitial extends CreateProductState {
  @override
  String toString() => 'CreateProductInitial';
}

class CreateProductLoading extends CreateProductState {
  @override
  String toString() => 'CreateProductLoading';
}

class CreateProductSuccess extends CreateProductState {
  final Product product;

  const CreateProductSuccess(this.product);

  @override
  String toString() => 'CreateProductSuccess $product';

  @override
  List<Object?> get props => [product.id];
}

class CreateProductFailure extends CreateProductState {
  @override
  String toString() => 'CreateProductFailure';
}
