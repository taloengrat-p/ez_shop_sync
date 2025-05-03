import 'dart:developer';
import 'dart:ui';

import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/role_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/notification.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user_data.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_qty_to_stock_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_add_stock_request.dart';
import 'package:ez_shop_sync/src/data/repository/add_product/add_product_repository.dart';
import 'package:ez_shop_sync/src/data/repository/auth/_local/auth_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/cart/cart_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/cart/cart_repository.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_repository.dart';
import 'package:ez_shop_sync/src/data/repository/notifications/notification_repository.dart';
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
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
  AddProductRepository addProductRepository;
  NotificationRepository notificationRepository;
  //
  final durationAddCart = const Duration(milliseconds: 700);
  NavigationService navigationService;
  AppMode _appMode = AppMode.local;
  ProductDisplayType productDisplayType = ProductDisplayType.grid;
  ProductSortType productSortType = ProductSortType.asc;
  bool isFirstRun = false;
  bool? isIntroduceFlowDone;
  User? _user;
  UserData? _userData;
  Store? _store;
  List<Product> _products = [];
  List<Store> _stores = [];
  List<Tag> _tags = [];
  List<Category> _categories = [];
  List<AddProduct> _addProducts = [];
  List<Notification> _notification = [];
  Cart? _cart;
  AddProduct? _addProduct;

  // getter sections
  List<Notification> get notification => _notification;
  AppMode get appMode => _appMode;
  User? get user => _user;
  UserData? get userData => _userData;
  Store? get store => _store;
  Cart? get cart => _cart;
  AddProduct? get addProduct => _addProduct;
  List<Product> get products => _products;
  List<Store> get stores => _stores;
  List<Tag> get tags => _tags;
  List<Category> get categories => _categories;
  AppTheme? get appTheme => _appTheme;
  int get cartCount => cart?.cartItems.length ?? 0;
  int get notificationCount => 0;
  int get addProductCount => _addProduct?.addProductItems.length ?? 0;
  RoleType? get userRoleTypeCurrentStore =>
      store?.members.firstWhere((e) => e.uid == user?.uid).roleType;
  String? get userId => user?.uid;
  String get currentUsername {
    if (user?.displayName == null && user?.email == null) {
      throw ('currentUsername user?.displayName == null && user?.email == null is Null');
    }
    return user?.displayName ??
        user?.email?.substring(0, user?.email?.indexOf("@")) ??
        '--';
  }

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
    required this.addProductRepository,
    required this.notificationRepository,
  }) : super(BaseInitial()) {
    // startAuthListen();
    startProfileUpdateListen();
  }

  Future<void> loadAllDependencies() async {
    emit(BaseLoading());
    await loadUserData();
    await loadStores();
    await loadNotifications();
    emit(BaseSuccess());
  }

  Future<void> loadStores() async {
    final result = await storeRepository.getAll(appMode: AppMode.server);

    result.when(
      success: (response) {
        _stores = response;
        emit(BaseGetStoreSuccess(response));
        setCurrentStoreById(userData?.storeSelected);
      },
      failure: (error, {errorType}) {
        emit(BaseGetStoreFailure());
      },
    );
  }

  Future<void> loadUserData() async {
    final result = await userRepository.getUserData();

    result.when(
      success: (response) {
        _userData = response;
        emit(BaseGetUserDataSuccess());
      },
      failure: (error, {errorType}) {
        emit(BaseGetUserDataFailure());
      },
    );
  }

  // startAuthListen() {
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     log('authStateChanges() isClosed:: ${isClosed} $user', name: runtimeType.toString());
  //     setCurrentUser(user);
  //   });
  // }

  startProfileUpdateListen() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      log(
        'userChanges() isClosed:: ${isClosed} $user',
        name: runtimeType.toString(),
      );
      setCurrentUser(user);
    });
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

  setCurrentStoreById(String? id) {
    final store = _stores.where((e) => e.id == id).firstOrNull;
    setCurrentStore(store);
  }

  setCurrentStoreByLastCreate() {}

  setCurrentStore(Store? value) async {
    _store = value;

    // await authLocalRepository.update(user?.id, user!..storeLatest = store!.id);

    if (value == null) {
      throw ('setCurrentStore store == null');
    }

    await doGetAddProductByCurrentUserAndStore();
    setCurrentAddCartByCurrentStore(store?.id);
    setCurrentCartByCurrentStore();

    emit(BaseSelectStore(_store?.id));
    // loadAppTheme(_store?.storeTheme);
    // loadTagsByCurrentStore();
    // loadCategoryByCurrentStore();
  }

  Future<void> setCurrentUser(User? user) async {
    _user = user;
    loadAllDependencies();
    emit(BaseUserChange(user));
    // if (_user?.storeId?.isEmpty ?? true) {
    //   return;
    // }

    // await doGetStores(_user?.storeId ?? []);
  }

  setCurrentCartByCurrentStore() async {
    final cartLocal = GetIt.I<CartLocalRepository>().getAll();
    final cartFinded = cartRepository.getCartsByUserIdWithCurrentStore(
      storeId: store!.id,
      userId: user!.uid,
    );
    log('setCurrentCartByCurrentStore : ${cartLocal.length}');

    if (cartFinded != null) {
      setCurrentCart(cartFinded);
    } else {
      final cartCreated = await cartRepository.create(
        Cart(
          id: const Uuid().v1(),
          storeId: store!.id,
          userId: user?.uid ?? '--',
          cartItems: [],
        ),
      );

      // await userRepository.update(user!.id, user!..carts.add(cartCreated.id));
      setCurrentCart(cartCreated);
    }

    emit(BaseRefresh(DateTime.now()));
  }

  setCurrentAddCartByCurrentStore(String storeId) async {
    if (_addProducts.map((e) => e.storeId).toList().contains(storeId)) {
      final addProductFinded =
          _addProducts
              .where((addProduct) => addProduct.storeId == storeId)
              .firstOrNull;
      setCurrentAddProduct(addProductFinded);
    } else {
      final addProductCreated = await addProductRepository.create(
        CreateAddProductRequest(
          addProduct: AddProduct(
            id: const Uuid().v1(),
            storeId: storeId,
            userId: user?.uid ?? '',
            addProductItems: [],
            amountCost: 0,
          ),
          storeId: storeId,
          userId: user?.uid ?? '',
        ),
      );

      // await userRepository.update(user?.uid, user?..addProducts.add(addProductCreated.id));
      // setCurrentAddProduct(addProductCreated);
    }

    // log('current Cart $cart');
  }

  setCurrentCart(Cart? value) {
    log('setCurrentCart $value');
    _cart = value;
  }

  setCurrentAddProduct(AddProduct? value) {
    _addProduct = value;
  }

  changeMode(AppMode mode) {
    _appMode = mode;
    emit(BaseChangeAppMode(_appMode));
  }

  changeDisplayType() {
    productDisplayType =
        productDisplayType == ProductDisplayType.grid
            ? ProductDisplayType.list
            : ProductDisplayType.grid;
  }

  changeSortType() {
    productSortType =
        productSortType == ProductSortType.asc
            ? ProductSortType.desc
            : ProductSortType.asc;

    sortProduct(productSortType);
  }

  sortProduct(ProductSortType sortType) {
    try {
      if (sortType == ProductSortType.asc) {
        products.sort(
          (a, b) => a.info?.createAt!.millisecondsSinceEpoch.compareTo(
            b.info?.createAt!.millisecondsSinceEpoch,
          ),
        );
      } else {
        products.sort(
          (a, b) => b.info?.createAt!.millisecondsSinceEpoch.compareTo(
            a.info?.createAt!.millisecondsSinceEpoch,
          ),
        );
      }
    } catch (e) {
      log('sortProduct error $e');
    }
  }

  emitInitLocalStorageServiceSuccess() {
    emit(BaseInitialLocalStorageServiceSuccess());
  }

  Future<void> doGetProducts() async {
    emit(BaseLoading());
    final result = await productRepository.getAllByStoreId(
      store!.id,
      appMode: AppMode.server,
    );

    result.when(
      success: (response) {
        setCurrentProduct(response ?? []);
        // sortProduct(productSortType);
        emit(BaseSuccess());
      },
      failure: (error, {errorType}) {
        setCurrentProduct([]);
        emit(BaseFailure());
      },
    );
  }

  void setCurrentProduct(List<Product> value) {
    _products = value;
  }

  Future<void> doDeleteProduct({
    required String storeId,
    required String productId,
  }) async {
    emit(BaseLoading());
    await productRepository.delete(storeId, productId, appMode: AppMode.server);
    _products.removeWhere((elelment) => elelment.id == productId);
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
    // setCurrentUser(localUser: resultUpdated);
  }

  void addCart({Offset? offset, required Product? product}) async {
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

  Future<void> doGetAddProductByCurrentUserAndStore() async {
    // _addProducts = addProductRepository.getAddProductByUserIdWithCurrentStore(user!.addProducts);
  }

  Future<void> deleteItemFromCart(String cartItemId) async {
    emit(BaseLoading());
    final resultCartUpdated = await cartRepository.deleteItemByIdFromCart(
      cart?.id,
      cartItemId,
    );

    setCurrentCart(resultCartUpdated);

    emit(BaseRemoveCartItem());
  }

  Future<void> deleteItemFromAddProduct(String addProductItemId) async {
    emit(BaseLoading());
    final resultAddCartUpdated = await addProductRepository
        .deleteItemByIdFromCart(cart?.id, addProductItemId);

    setCurrentAddProduct(resultAddCartUpdated);

    emit(BaseRemoveCartItem());
  }

  Future<Product?> addStock({
    required Product? product,
    required num amountCost,
  }) async {
    if (product == null) {
      throw ('addStock product is Null');
    }

    if (addProduct == null) {
      throw ('addStock addProduct is Null');
    }

    emit(BaseLoading());

    final addProductUpdate = await addProductRepository.addProduct(
      addProduct!.id,
      product,
    );

    // final productUpdated = await productRepository.addProductQuantityToStock(
    //   AddProductQtyToStockrequest(
    //     productId: product.id,
    //     storeId: store!.id,
    //     userId: user!.uid,
    //     product: product,
    //     amountCost: amountCost,
    //   ),
    //   appMode: AppMode.server,
    // );

    // productUpdated.when(
    //   success: (response) {
    //     updateProductQuantity(response);
    //   },
    //   failure: (error) {},
    // );

    emit(BaseAddStockSuccess(DateTime.now()));

    return product;
  }

  void updateProductQuantity(Product? productUpdated) {
    final productFinded =
        _products.where((e) => e.id == productUpdated?.id).firstOrNull;

    if (productFinded == null) {
      throw ('updateProductQuantity() Product is Null');
    }

    productFinded.quantity = productUpdated?.quantity;
    emit(BaseRefresh(DateTime.now()));
  }

  Future<void> updateDisplayName(String? displayNameEditor) async {
    await _user?.updateDisplayName(displayNameEditor);
  }

  Future<void> loadNotifications() async {
    final result = await notificationRepository.getNotifications();

    result.when(
      success: (response) {
        setNotifications(response);
        emit(BaseGetNotificationsSuccess());
      },
      failure: (error, {errorType}) {
        emit(BaseGetNotificationsFailure());
      },
    );
  }

  void setNotifications(List<Notification> response) {
    _notification = response;
  }

  void clearCurrentUserData() {}
}
