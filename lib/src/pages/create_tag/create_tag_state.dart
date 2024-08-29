import 'package:equatable/equatable.dart';

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
  @override
  String toString() => 'CreateTagSuccess';
}

class CreateTagFailure extends CreateTagState {
  const CreateTagFailure();

  @override
  String toString() => 'CreateTagFailure';
}
