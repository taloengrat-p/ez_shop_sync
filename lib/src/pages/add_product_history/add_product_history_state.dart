import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class AddProductHistoryState extends Equatable {
  const AddProductHistoryState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class AddProductHistoryRefresh extends AddProductHistoryState {
  final dynamic value;

  const AddProductHistoryRefresh(this.value);
  @override
  String toString() => 'AddProductHistoryRefresh';

  @override
  List<Object?> get props => [value];
}

class AddProductHistoryInitialLoading extends AddProductHistoryState {
  const AddProductHistoryInitialLoading();

  @override
  String toString() => 'AddProductHistoryInitialLoading';
}

class AddProductHistoryScreenModeChange extends AddProductHistoryState {
  final ScreenMode mode;

  const AddProductHistoryScreenModeChange(this.mode);

  @override
  String toString() => 'AddProductHistoryScreenModeChange';
}

class AddProductHistoryInitial extends AddProductHistoryState {
  @override
  String toString() => 'AddProductHistoryInitial';
}

class AddProductHistoryLoading extends AddProductHistoryState {
  @override
  String toString() => 'AddProductHistoryLoading';
}

class AddProductHistorySuccess extends AddProductHistoryState {
  @override
  String toString() => 'AddProductHistorySuccess';
}

class AddProductHistoryFailure extends AddProductHistoryState {
  const AddProductHistoryFailure();

  @override
  String toString() => 'AddProductHistoryFailure';
}

class AddProductHistoryLoadMore extends AddProductHistoryState {
  const AddProductHistoryLoadMore();

  @override
  String toString() => 'AddProductHistoryLoadMore';
}

class AddProductHistoryLoadMoreSuccess extends AddProductHistoryState {
  final int start;
  final int end;

  const AddProductHistoryLoadMoreSuccess(this.start, this.end);

  @override
  String toString() => 'AddProductHistoryLoadMoreSuccess $start to $end';

  @override
  List<Object?> get props => [start, end];
}
