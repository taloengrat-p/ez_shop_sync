import 'dart:developer';
import 'dart:ui';

import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/constances/shared_pref_keys.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/data/repository/auth/_local/auth_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/cart/cart_repository.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/data/repository/tag/tag_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/models/product_display_type.enum.dart';
import 'package:ez_shop_sync/src/models/product_sort_type.enum.dart';
import 'package:ez_shop_sync/src/pages/base/base_state.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/services/navigation_service.dart';
import 'package:ez_shop_sync/src/theme/app_theme.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class BaseCubit extends Cubit<BaseState> {
  AppTheme? _appTheme;

  Size deviceSize = const Size(0, 0);
  // repositories
  LocalStorageService localStorageService;
  AuthLocalRepository authLocalRepository;
  StoreRepository storeRepository;
  ProductRepository productRepository;
  TagRepository tagRepository;
  CategoryRepository categoryRepository;
  CartRepository cartRepository;
  UserRepository userRepository;
  //
  final durationAddCart = const Duration(milliseconds: 700);
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
  List<Tag> _tags = [];
  List<Category> _categories = [];
  List<Cart> _carts = [];
  Cart? _cart;

  // getter sections
  AppMode get appMode => _appMode;
  User? get user => _user;
  Store? get store => _store;
  Cart? get cart => _cart;
  List<Cart> get carts => _carts;
  List<Product> get products => _products;
  List<Store> get stores => _stores;
  List<Tag> get tags => _tags;
  List<Category> get categories => _categories;
  AppTheme? get appTheme => _appTheme;
  int get cartCount => cart?.cartItems.length ?? 0;

  BaseCubit({
    required this.localStorageService,
    required this.authLocalRepository,
    required this.storeRepository,
    required this.productRepository,
    required this.navigationService,
    required this.tagRepository,
    required this.categoryRepository,
    required this.cartRepository,
    required this.userRepository,
  }) : super(BaseInitial()) {
    onCheckFirstRun();
    onCheckIntroduceFlowDone();
    doGetUserAppLocalSession();
  }

  loadAppTheme(AppTheme? value) {
    _appTheme = value;
    ColorKeys.primary = _appTheme?.primaryColor.toColor() ?? ColorKeys.defaultPrimary;
    ColorKeys.secondary = _appTheme?.secondaryColor.toColor() ?? ColorKeys.defaultSecondary;
    ColorKeys.accent = _appTheme?.accentColor.toColor() ?? ColorKeys.defaultAccent;
    ColorKeys.brightness = _appTheme?.backgroundColor.toColor() ?? ColorKeys.defaultBrightness;
    emit(BaseLoadAppThemeSuccess(appTheme));
  }

  setCurrentStoreById(String id) {
    final store = _stores.where((e) => e.id == id).firstOrNull;
    setCurrentStore(store);
  }

  setCurrentStoreByLastCreate() {}

  setCurrentStore(Store? value) async {
    _store = value;

    await authLocalRepository.update(user!.id, user!..storeLatest = store!.id);

    await doGetCartByCurrentUserAndStore();
    setCurrentCartByCurrentStore(store!.id);
    loadAppTheme(_store?.storeTheme);
    loadTagsByCurrentStore();
    loadCategoryByCurrentStore();
  }

  Future<void> setCurrentUser(User? value) async {
    _user = value;

    if (_user?.storeId?.isEmpty ?? true) {
      return;
    }

    await doGetStores(_user?.storeId ?? []);
  }

  setCurrentCartByCurrentStore(String storeId) async {
    // log('setCurrentCartByCurrentStore : ${_carts.map((e) => e.id)}');
    if (_carts.map((e) => e.storeId).toList().contains(storeId)) {
      final cartFinded = _carts.where((cart) => cart.storeId == storeId).firstOrNull;
      setCurrentCart(cartFinded);
    } else {
      final cartCreated = await cartRepository.create(
        Cart(
          id: const Uuid().v1(),
          storeId: storeId,
          userId: user!.id,
          cartItems: [],
        ),
      );

      await userRepository.update(user!.id, user!..carts.add(cartCreated.id));
      setCurrentCart(cartCreated);
    }

    // log('current Cart $cart');
  }

  setCurrentCart(Cart? value) {
    _cart = value;
  }

  changeMode(AppMode mode) {
    _appMode = mode;
    emit(BaseChangeAppMode(_appMode));
  }

  changeDisplayType() {
    productDisplayType =
        productDisplayType == ProductDisplayType.grid ? ProductDisplayType.list : ProductDisplayType.grid;
  }

  changeSortType() {
    productSortType = productSortType == ProductSortType.asc ? ProductSortType.desc : ProductSortType.asc;

    sortProduct(productSortType);
  }

  sortProduct(ProductSortType sortType) {
    if (sortType == ProductSortType.asc) {
      products.sort((a, b) => a.createDate!.millisecondsSinceEpoch.compareTo(b.createDate!.millisecondsSinceEpoch));
    } else {
      products.sort((a, b) => b.createDate!.millisecondsSinceEpoch.compareTo(a.createDate!.millisecondsSinceEpoch));
    }
  }

  Future<void> onCheckFirstRun() async {
    isFirstRun = await localStorageService.doCheckIsFirstRunApp();
  }

  Future<void> onCheckIntroduceFlowDone() async {
    isIntroduceFlowDone = await localStorageService.doCheckIsIntroduceFlowDone();
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
    String? currentLocalUsername = localStorageService.getPref<String>(SharedPrefKeys.currentUsername);

    if (currentLocalUsername.isNull) {
      return;
    }

    if (currentLocalUsername?.isNotEmpty ?? false) {
      User? userFinded = authLocalRepository.getByUsername(currentLocalUsername!);
      setCurrentUser(userFinded);

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

    _stores = allStore;

    if (stores.isNotEmpty) {
      final storeInit = user?.storeLatest != null
          ? stores.where((e) => e.id == user?.storeLatest).firstOrNull ?? _stores.first
          : _stores.first;

      setCurrentStore(storeInit);
    } else {
      setCurrentStore(null);
    }
    emit(BaseSuccess());
  }

  Future<void> doGetProducts() async {
    emit(BaseLoading());
    final allProduct = productRepository.getAllByStoreId(store!.id);

    setCurrentProduct(allProduct);
    sortProduct(productSortType);
    emit(BaseSuccess());
  }

  void setCurrentProduct(List<Product> value) {
    _products = value;
  }

  void doDeleteProduct(String? id) {
    emit(BaseLoading());
    productRepository.delete(id!);
    _products.removeWhere((elelment) => elelment.id == id);
    emit(BaseRefresh(DateTime.now()));
  }

  Future<void> initialStoreData() async {
    await doGetProducts();
  }

  void refresh() {
    emit(BaseRefresh(DateTime.now()));
  }

  void loadTagsByCurrentStore() {
    emit(BaseLoading());
    _tags = tagRepository.getAllByIds(store?.tags ?? []);

    emit(BaseLoadTagsByStoreSuccess(store?.tags ?? []));
  }

  void loadCategoryByCurrentStore() {
    emit(BaseLoading());
    _categories = categoryRepository.getAllByIds(store?.categories ?? []);

    emit(BaseLoadCategoriesByStoreSuccess(store?.categories ?? []));
  }

  void updateCurrentUser(User resultUpdated) {
    setCurrentUser(resultUpdated);
  }

  void addCart({
    Offset? offset,
    required Product? product,
  }) async {
    if (_cart != null && product != null) {
      emit(BaseLoading());
      final cartUpdate = await cartRepository.addCart(_cart!.id, product);

      log('cartUpdate $cartUpdate');
      emit(BaseAddCartSuccess());
      Future.delayed(durationAddCart).then((value) {
        emit(BaseAddCartAnimationSuccess());
      });
    }
  }

  Future<void> doGetCartByCurrentUserAndStore() async {
    _carts = cartRepository.getCartsByUserIdWithCurrentStore(user!.carts);
  }

  Future<void> deleteItemFromCart(String cartItemId) async {
    emit(BaseLoading());
    final resultCartUpdated = await cartRepository.deleteItemByIdFromCart(cart?.id, cartItemId);

    setCurrentCart(resultCartUpdated);

    emit(BaseRemoveCartItem());
  }

  Future<Product?> addStock({required Product? product, required num qty}) async {
    if (product == null) {
      throw ('addStock product is Null');
    }
    final newQuantity = (product.quantity ?? 0) + qty;
    log('newQuantity $newQuantity');
    emit(BaseLoading());
    final productUpdated = await productRepository.update(product.id, product..quantity = newQuantity);
    await doGetProducts();
    emit(BaseAddStockSuccess(DateTime.now()));

    return productUpdated;
  }
}
