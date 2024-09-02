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

class CreateProductAddCustomField extends CreateProductState {
  final String name;
  final String value;

  const CreateProductAddCustomField(this.name, this.value);

  @override
  String toString() => 'CreateProductAddCustomField(name: $name, value: $value)';

  @override
  List<Object?> get props => [name, value];
}

class CreateProductRemoveCustomField extends CreateProductState {
  final String name;

  const CreateProductRemoveCustomField(this.name);

  @override
  String toString() => 'CreateProductAddCustomField(name: $name)';

  @override
  List<Object?> get props => [name];
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

class CreateProductRefresh extends CreateProductState {
  final dynamic value;

  const CreateProductRefresh(this.value);
  @override
  String toString() => 'CreateProductRefresh $value';

  @override
  List<Object?> get props => [value];
}
