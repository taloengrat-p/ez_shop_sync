import 'dart:developer';

import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/pages/base/base_state.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_cubit.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

enum AppMode {
  local,
  server;
}

@Singleton(env: [Flavor.DEV, Flavor.PROD, Flavor.TESTS])
@Injectable(env: [Flavor.DEV, Flavor.PROD, Flavor.TESTS])
class BaseCubit extends Cubit<BaseState> {
  LocalStorageService localStorageService;
  AppMode _appMode = AppMode.local;
  ProductDisplayType productDisplayType = ProductDisplayType.grid;
  ProductDisplayType displayType = ProductDisplayType.grid;
  AppMode get appMode => _appMode;
  bool isFirstRun = false;
  bool isIntroduceFlowDone = false;

  BaseCubit({
    required this.localStorageService,
  }) : super(BaseInitial()) {
    onCheckFirstRun();
    onCheckIntroduceFlowDone();
  }

  changeMode(AppMode mode) {
    _appMode = mode;
    emit(BaseChangeAppMode(_appMode));
  }

  changeDisplayType() {
    displayType = displayType == ProductDisplayType.grid ? ProductDisplayType.list : ProductDisplayType.grid;
  }

  Future<void> onCheckFirstRun() async {
    isFirstRun = await localStorageService.doCheckIsFirstRunApp();
  }

  Future<void> onCheckIntroduceFlowDone() async {
    // isIntroduceFlowDone = await localStorageService.doCheckIsIntroduceFlowDone();
    log('isIntroduceFlowDone : $isIntroduceFlowDone');
  }
}
