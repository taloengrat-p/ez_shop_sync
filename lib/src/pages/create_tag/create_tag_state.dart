import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';

abstract class CreateTagState extends Equatable {
  const CreateTagState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class CreateTagRefresh extends CreateTagState {
  final dynamic value;

  const CreateTagRefresh(this.value);
  @override
  String toString() => 'CreateTagRefresh';

  @override
  List<Object> get props => [value];
}

class CreateTagInitial extends CreateTagState {
  @override
  String toString() => 'CreateTagInitial';
}

class CreateTagLoading extends CreateTagState {
  @override
  String toString() => 'CreateTagLoading';
}

class CreateTagSuccess extends CreateTagState {
  final Tag tag;

  const CreateTagSuccess(this.tag);
  @override
  String toString() => 'CreateTagSuccess';

  @override
  List<Object> get props => [tag.id];
}

class CreateTagFailure extends CreateTagState {
  const CreateTagFailure();

  @override
  String toString() => 'CreateTagFailure';
}
