import 'package:equatable/equatable.dart';

abstract class CreateStoreState extends Equatable {
  const CreateStoreState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class CreateStoreInitial extends CreateStoreState {
  @override
  String toString() => 'CreateStoreInitial';
}

class CreateStoreLoading extends CreateStoreState {
  @override
  String toString() => 'CreateStoreLoading';
}

class CreateStoreSuccess extends CreateStoreState {
  @override
  String toString() => 'CreateStoreSuccess';
}

class CreateStoreFailure extends CreateStoreState {
  const CreateStoreFailure();

  @override
  String toString() => 'CreateStoreFailure';
}
