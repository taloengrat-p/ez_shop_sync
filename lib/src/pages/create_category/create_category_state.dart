import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';

abstract class CreateCategoryState extends Equatable {
  const CreateCategoryState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class CreateCategoryRefresh extends CreateCategoryState {
  final DateTime dateTime;

  const CreateCategoryRefresh(this.dateTime);
  @override
  String toString() => 'CreateCategoryRefresh';

  @override
  List<Object?> get props => [dateTime.toIso8601String()];
}

class CreateCategoryInitial extends CreateCategoryState {
  @override
  String toString() => 'CreateCategoryInitial';
}

class CreateCategoryLoading extends CreateCategoryState {
  @override
  String toString() => 'CreateCategoryLoading';
}

class CreateCategorySuccess extends CreateCategoryState {
  final Category category;
  const CreateCategorySuccess(
    this.category,
  );

  @override
  String toString() => 'CreateCategorySuccess ${category.id}';
}

class CreateCategoryFailure extends CreateCategoryState {
  const CreateCategoryFailure();

  @override
  String toString() => 'CreateCategoryFailure';
}
