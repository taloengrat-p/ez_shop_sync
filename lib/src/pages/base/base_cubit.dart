import 'dart:developer';

import 'package:ez_shop_sync/src/constances/shared_pref_keys.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/data/repository/auth/_local/auth_local_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_state.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_cubit.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppMode {
  local,
  server;
}

class BaseCubit extends Cubit<BaseState> {
  LocalStorageService localStorageService;
  AuthLocalRepository authLocalRepository;

  AppMode _appMode = AppMode.local;
  ProductDisplayType productDisplayType = ProductDisplayType.grid;
  ProductDisplayType displayType = ProductDisplayType.grid;
  AppMode get appMode => _appMode;
  bool isFirstRun = false;
  bool? isIntroduceFlowDone;
  User? _user;

  User? get user => _user;

  BaseCubit({
    required this.localStorageService,
    required this.authLocalRepository,
  }) : super(BaseInitial()) {
    onCheckFirstRun();
    onCheckIntroduceFlowDone();
    doGetUserAppLocalSession();
  }

  changeMode(AppMode mode) {
    _appMode = mode;
    emit(BaseChangeAppMode(_appMode));
  }

  changeDisplayType() {
    displayType = displayType == ProductDisplayType.grid
        ? ProductDisplayType.list
        : ProductDisplayType.grid;
  }

  Future<void> onCheckFirstRun() async {
    isFirstRun = await localStorageService.doCheckIsFirstRunApp();
  }

  Future<void> onCheckIntroduceFlowDone() async {
    isIntroduceFlowDone =
        await localStorageService.doCheckIsIntroduceFlowDone();
    log('isIntroduceFlowDone : $isIntroduceFlowDone');

    emit(BaseRefresh(DateTime.now()));
    emit(BaseInitialSuccess());
  }

  doLogin({String? username, String? password, User? userForceLogin}) async {
    if (userForceLogin.isNotNull) {
      _user = userForceLogin;

      return;
    }
  }

  doLogout() {}

  Future<void> doGetUserAppLocalSession() async {
    String? currentLocalUsername =
        localStorageService.getPref<String>(SharedPrefKeys.currentUsername);
    log('currentUsername result ${currentLocalUsername} ');

    if (currentLocalUsername?.isNotEmpty ?? false) {
      _user = authLocalRepository.getByUsername(currentLocalUsername!);
      emit(BaseRefresh(DateTime.now()));
    }
  }

  emitInitLocalStorageServiceSuccess() {
    emit(BaseInitialLocalStorageServiceSuccess());
  }
}
