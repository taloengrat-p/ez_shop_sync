import 'dart:developer';

import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/main_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainCubit extends Cubit<MainState> {
  int currentPage = 0;
  BaseCubit baseCubit;
  final UserRepository userRepository;
  MainCubit({
    required this.baseCubit,
    required this.userRepository,
  }) : super(MainInitial());

  String? get username => baseCubit.currentUsername;

  String get userShortName => baseCubit.user?.displayName?.toSubStringFirstToIndex(2) ?? '';

  void setCurrentPageView(int value) {
    currentPage = value;
  }

  void doCheckUserAlreadyUseApp() async {
    final result = await userRepository.onCheckUserAlreadyUseApp();

    log('doCheckUserAlreadyUseApp $result');
  }
}
