import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/transaction.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class TransactionStatementDetailState extends Equatable {
  const TransactionStatementDetailState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class TransactionStatementDetailRefresh extends TransactionStatementDetailState {
  final dynamic value;

  const TransactionStatementDetailRefresh(this.value);
  @override
  String toString() => 'TransactionStatementDetailRefresh';

  @override
  List<Object?> get props => [value];
}

class TransactionStatementDetailScreenModeChange extends TransactionStatementDetailState {
  final ScreenMode mode;

  const TransactionStatementDetailScreenModeChange(this.mode);

  @override
  String toString() => 'TransactionStatementDetailScreenModeChange';
}

class TransactionStatementDetailInitial extends TransactionStatementDetailState {
  @override
  String toString() => 'TransactionStatementDetailInitial';
}

class TransactionStatementDetailArgrument extends TransactionStatementDetailState {
  final List<Transaction> transactions;
  const TransactionStatementDetailArgrument(this.transactions);
  @override
  String toString() => 'TransactionStatementDetailArgrument $transactions';

  @override
  List<Object?> get props => [transactions];
}

class TransactionStatementDetailLoading extends TransactionStatementDetailState {
  @override
  String toString() => 'TransactionStatementDetailLoading';
}

class TransactionStatementDetailSuccess extends TransactionStatementDetailState {
  @override
  String toString() => 'TransactionStatementDetailSuccess';
}

class TransactionStatementDetailFailure extends TransactionStatementDetailState {
  const TransactionStatementDetailFailure();

  @override
  String toString() => 'TransactionStatementDetailFailure';
}
