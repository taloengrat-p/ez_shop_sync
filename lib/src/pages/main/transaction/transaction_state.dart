// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class TransactionInitialLoading extends TransactionState {
  @override
  String toString() => 'TransactionInitialLoading';
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

class TransactionLoadmore extends TransactionState {
  @override
  String toString() => 'TransactionLoadmore';
}

class OrderHistoryLoadMoreSuccess extends TransactionState {
  final int start;
  final int end;
  const OrderHistoryLoadMoreSuccess({required this.start, required this.end});
  @override
  String toString() => 'OrderHistoryLoadMoreSuccess';

  @override
  List<Object> get props => [start, end];
}

class OrderHistoryLoadMoreFailure extends TransactionState {
  @override
  String toString() => 'OrderHistoryLoadMoreFailure';
}
