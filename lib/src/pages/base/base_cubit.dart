import 'dart:developer';
import 'package:ez_shop_sync/res/colors.dart';
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
import 'package:ez_shop_sync/src/services/navigation_service.dart';
import 'package:ez_shop_sync/src/theme/app_theme.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extendsions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaseCubit extends Cubit<BaseState> {
  AppTheme? _appTheme;
  LocalStorageService localStorageService;
  AuthLocalRepository authLocalRepository;
  StoreRepository storeRepository;
  ProductRepository productRepository;
  NavigationService navigationService;
  AppMode _appMode = AppMode.local;
  ProductDisplayType productDisplayType = ProductDisplayType.grid;
  ProductSortType productSortType = ProductSortType.asc;
  bool isFirstRun = false;
  bool? isIntroduceFlowDone;
  User? _user;
  Store? _store;
  List<Product> _products = [];
  List<Store> _stores = [];
  AppMode get appMode => _appMode;
  User? get user => _user;
  Store? get store => _store;
  List<Product> get products => _products;
  List<Store> get stores => _stores;
  AppTheme? get appTheme => _appTheme;

  BaseCubit({
    required this.localStorageService,
    required this.authLocalRepository,
    required this.storeRepository,
    required this.productRepository,
    required this.navigationService,
  }) : super(BaseInitial()) {
    onCheckFirstRun();
    onCheckIntroduceFlowDone();
    doGetUserAppLocalSession();
  }

  loadAppTheme(AppTheme? value) {
    _appTheme = value;
    ColorKeys.primary =
        _appTheme?.primaryColor.toColor() ?? ColorKeys.defaultPrimary;
    ColorKeys.secondary =
        _appTheme?.secondaryColor.toColor() ?? ColorKeys.defaultSecondary;
    ColorKeys.accent =
        _appTheme?.accentColor.toColor() ?? ColorKeys.defaultAccent;
    ColorKeys.brightness =
        _appTheme?.backgroundColor.toColor() ?? ColorKeys.defaultBrightness;
    emit(BaseLoadAppThemeSuccess(appTheme));
  }

  setCurrentStoreById(String id) {
    final store = _stores.where((e) => e.id == id).firstOrNull;
    setCurrentStore(store);
  }

  setCurrentStore(Store? value) {
    _store = value;
    loadAppTheme(_store?.storeTheme);
  }

  setCurrentUser(User? value) {
    _user = value;

    log('_user?.storeId : ${_user?.storeId}');
    if (_user?.storeId?.isEmpty ?? true) {
      return;
    }

    doGetStores(_user?.storeId ?? []);
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
      setCurrentUser(userForceLogin);
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
      // Store? storeFinded = storeRepository.getById(userFinded!.storeId!.first);
      // setCurrentStore(storeFinded);

      await initialStoreData();
      emit(BaseRefresh(DateTime.now()));
    }
  }

  emitInitLocalStorageServiceSuccess() {
    emit(BaseInitialLocalStorageServiceSuccess());
  }

  Future<void> doGetStores(List<String> ids) async {
    emit(BaseLoading());
    final allStore = storeRepository.getAllByIds(ids);

    log('get all Stores : $allStore');
    _stores = allStore;

    if (stores.isNotEmpty) {
      setCurrentStore(_stores.first);
    } else {
      setCurrentStore(null);
    }
    emit(BaseSuccess());
  }

  Future<void> doGetProducts() async {
    emit(BaseLoading());
    final allProduct = productRepository.getAll();

    log('get all Product : $allProduct');
    setCurrentProduct(allProduct);
    sortProduct(productSortType);
    emit(BaseSuccess());
  }

  void setCurrentProduct(List<Product> value) {
    _products = value;
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
    await doGetProducts();
  }

  void refresh() {
    emit(BaseRefresh(DateTime.now()));
  }
}
