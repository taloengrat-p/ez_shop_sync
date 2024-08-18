import 'package:equatable/equatable.dart';

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
  @override
  String toString() => 'CreateProductSuccess';
}

class CreateProductFailure extends CreateProductState {
  @override
  String toString() => 'CreateProductFailure';
}
