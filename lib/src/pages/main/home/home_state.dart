import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  @override
  String toString() => 'HomeInitial';
}

class HomeLoading extends HomeState {
  @override
  String toString() => 'HomeLoading';
}

class HomeSuccess extends HomeState {
  @override
  String toString() => 'HomeSuccess';
}

class HomeFailure extends HomeState {
  const HomeFailure();

  @override
  String toString() => 'HomeFailure';
}

class HomeDeleteSuccess extends HomeState {
  @override
  String toString() => 'HomeDeleteSuccess';
}
