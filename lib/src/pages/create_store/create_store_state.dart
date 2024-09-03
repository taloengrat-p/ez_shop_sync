import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';

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
  final Store store;

  const CreateStoreSuccess(
    this.store,
  );
  @override
  String toString() => 'CreateStoreSuccess ${store.id}';
}

class CreateStoreFailure extends CreateStoreState {
  const CreateStoreFailure();

  @override
  String toString() => 'CreateStoreFailure';
}
