import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';

abstract class CreateStoreState extends Equatable {
  const CreateStoreState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class CreateStoreArgrument extends CreateStoreState {
  final bool isInitialFirstStore;
  const CreateStoreArgrument(this.isInitialFirstStore);
  @override
  String toString() => 'CreateStoreArgrument isInitialFirstStore: $isInitialFirstStore';
  @override
  List<Object> get props => [isInitialFirstStore];
}

class CreateStoreInitial extends CreateStoreState {
  @override
  String toString() => 'CreateStoreInitial';
}

class CreateStoreRefresh extends CreateStoreState {
  final value;
  const CreateStoreRefresh(this.value);
  @override
  String toString() => 'CreateStoreRefresh';

  @override
  List<Object> get props => [value];
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
