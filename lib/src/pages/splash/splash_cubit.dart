import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/splash/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class SplashCubit extends Cubit<SplashState> {
  final AppCubit appCubit;
  SplashCubit({required this.appCubit}) : super(SplashInitial());

  void initial() {
    if (appCubit.user == null) {
      emit(const SplashFailure());
    }
  }
}
