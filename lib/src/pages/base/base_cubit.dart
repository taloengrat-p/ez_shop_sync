import 'dart:developer';

import 'package:ez_shop_sync/src/constances/shared_pref_keys.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/data/repository/auth/_local/auth_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/models/product_display_type.enum.dart';
import 'package:ez_shop_sync/src/models/product_sort_type.enum.dart';
import 'package:ez_shop_sync/src/pages/base/base_state.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseCubit extends Cubit<BaseState> {
  LocalStorageService localStorageService;
  AuthLocalRepository authLocalRepository;
  StoreRepository storeRepository;
  ProductRepository productRepository;

  AppMode _appMode = AppMode.local;
  ProductDisplayType productDisplayType = ProductDisplayType.grid;
  ProductSortType productSortType = ProductSortType.asc;
  bool isFirstRun = false;
  bool? isIntroduceFlowDone;
  User? _user;
  Store? _store;
  List<Product> _products = [];

  AppMode get appMode => _appMode;
  User? get user => _user;
  Store? get store => _store;
  List<Product> get products => _products;

  BaseCubit({
    required this.localStorageService,
    required this.authLocalRepository,
    required this.storeRepository,
    required this.productRepository,
  }) : super(BaseInitial()) {
    onCheckFirstRun();
    onCheckIntroduceFlowDone();
    doGetUserAppLocalSession();
  }

  setCurrentStore(Store? value) {
    _store = value;
  }

  setCurrentUser(User? value) {
    _user = value;
  }

  changeMode(AppMode mode) {
    _appMode = mode;
    emit(BaseChangeAppMode(_appMode));
  }

  changeDisplayType() {
    productDisplayType = productDisplayType == ProductDisplayType.grid
        ? ProductDisplayType.list
        : ProductDisplayType.grid;
  }

  changeSortType() {
    productSortType = productSortType == ProductSortType.asc
        ? ProductSortType.desc
        : ProductSortType.asc;

    sortProduct(productSortType);
  }

  sortProduct(ProductSortType sortType) {
    if (sortType == ProductSortType.asc) {
      products.sort((a, b) => a.createDate!.millisecondsSinceEpoch
          .compareTo(b.createDate!.millisecondsSinceEpoch));
    } else {
      products.sort((a, b) => b.createDate!.millisecondsSinceEpoch
          .compareTo(a.createDate!.millisecondsSinceEpoch));
    }
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

    if (currentLocalUsername.isNull) {
      return;
    }

    if (currentLocalUsername?.isNotEmpty ?? false) {
      User? userFinded =
          authLocalRepository.getByUsername(currentLocalUsername!);
      setCurrentUser(userFinded);
      Store? storeFinded = storeRepository.getById(userFinded!.storeId!.first);
      setCurrentStore(storeFinded);

      await initialStoreData();
      emit(BaseRefresh(DateTime.now()));
    }
  }

  emitInitLocalStorageServiceSuccess() {
    emit(BaseInitialLocalStorageServiceSuccess());
  }

  Future<void> doGetProduct() async {
    emit(BaseLoading());
    final allProduct = productRepository.getAll();

    log('get all Product : $allProduct');
    _products = allProduct;
    sortProduct(productSortType);
    emit(BaseSuccess());
  }

  void doDeleteProduct(String? id) {
    if (id.isNotNull) {
      emit(BaseLoading());
      productRepository.delete(id!);
      _products.removeWhere((elelment) => elelment.id == id);
      emit(BaseRefresh(DateTime.now()));
    }
  }

  Future<void> initialStoreData() async {
    await doGetProduct();
  }
}
