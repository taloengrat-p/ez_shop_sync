import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/main_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class MainCubit extends Cubit<MainState> {
  int currentPage = 0;
  final AppCubit appCubit;
  final UserRepository userRepository;
  MainCubit({required this.appCubit, required this.userRepository}) : super(MainInitial());

  String? get username => appCubit.currentUsername;

  String get userShortName => appCubit.user?.displayName?.toSubStringFirstToIndex(2) ?? '';

  void setCurrentPageView(int value) {
    currentPage = value;
  }

  void doCheckUserAlreadyUseApp() async {
    emit(MainLoading());
    final result = await userRepository.onCheckUserAlreadyUseApp();

    if (result == false) {
      await userRepository.initialUserData();
      emit(MainGotoIntroduceFlow());
    }

    emit(MainInitial());
  }
}
