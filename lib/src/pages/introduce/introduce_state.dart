import 'package:equatable/equatable.dart';

abstract class IntroduceState extends Equatable {
  const IntroduceState() : super();

  @override
  List<Object?> get props => [];
}

class IntroduceInitial extends IntroduceState {
  @override
  String toString() => 'IntroduceInitial';
}

class IntroduceRefresh extends IntroduceState {
  final DateTime dateTime;

  IntroduceRefresh(this.dateTime);

  @override
  String toString() => 'IntroduceRefresh';

  @override
  List<Object?> get props => [dateTime];
}

class IntroduceLoading extends IntroduceState {
  @override
  String toString() => 'IntroduceLoading';
}

class IntroduceSuccess extends IntroduceState {
  @override
  String toString() => 'IntroduceSuccess';
}

class IntroduceFailure extends IntroduceState {
  @override
  String toString() => 'IntroduceFailure';
}
