import 'package:equatable/equatable.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';

abstract class SplashState extends Equatable {
  const SplashState([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class SplashRefresh extends SplashState {
  final dynamic value;

  const SplashRefresh(this.value);
  @override
  String toString() => 'SplashRefresh';

  @override
  List<Object?> get props => [value];
}

class SplashScreenModeChange extends SplashState {
  final ScreenMode mode;

  const SplashScreenModeChange(this.mode);

  @override
  String toString() => 'SplashScreenModeChange';
}

class SplashInitial extends SplashState {
  @override
  String toString() => 'SplashInitial';
}

class SplashLoading extends SplashState {
  @override
  String toString() => 'SplashLoading';
}

class SplashSuccess extends SplashState {
  @override
  String toString() => 'SplashSuccess';
}

class SplashFailure extends SplashState {
  const SplashFailure();

  @override
  String toString() => 'SplashFailure';
}
