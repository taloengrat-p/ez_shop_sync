import 'package:equatable/equatable.dart';

abstract class TransactionState extends Equatable {
  const TransactionState([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {
  @override
  String toString() => 'TransactionInitial';
}

class TransactionLoading extends TransactionState {
  @override
  String toString() => 'TransactionLoading';
}

class TransactionSuccess extends TransactionState {
  @override
  String toString() => 'TransactionSuccess';
}

class TransactionFailure extends TransactionState {
  const TransactionFailure();

  @override
  String toString() => 'TransactionFailure';
}

class TransactionDeleteSuccess extends TransactionState {
  @override
  String toString() => 'TransactionDeleteSuccess';
}
