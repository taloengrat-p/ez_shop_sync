import 'package:equatable/equatable.dart';

abstract class MainState extends Equatable {
  const MainState() : super();

  @override
  List<Object?> get props => [];
}

class MainArgruments extends MainState {
  final int startWithIndexPage;
  final bool? isRefresh;
  const MainArgruments(this.startWithIndexPage, {this.isRefresh});

  @override
  String toString() => 'MainArgruments $startWithIndexPage';
  @override
  List<Object?> get props => [startWithIndexPage, isRefresh];
}

class MainInitial extends MainState {
  @override
  String toString() => 'MainInitial';
}

class MainLoading extends MainState {
  @override
  String toString() => 'MainLoading';
}

class MainGotoIntroduceFlow extends MainState {
  @override
  String toString() => 'MainGotoIntroduceFlow';
}

class MainSuccess extends MainState {
  @override
  String toString() => 'MainSuccess';
}

class MainFailure extends MainState {
  @override
  String toString() => 'MainFailure';
}

class MainDelete extends MainState {
  @override
  String toString() => 'MainDelete';
}

class MainRefresh extends MainState {
  final DateTime dateTime;

  const MainRefresh(this.dateTime);
  @override
  String toString() => 'MainRefresh';

  @override
  List<Object?> get props => [dateTime.toIso8601String()];
}
