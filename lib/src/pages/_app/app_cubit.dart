import 'dart:developer';
import 'dart:ui';

import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/payment_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/role_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/notification.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user_data.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/add_product_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/delete_item_form_cart_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/cart_request/add_cart_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/cart_request/delete_item_from_cart_request.dart';
import 'package:ez_shop_sync/src/data/repository/add_product/add_product_repository.dart';
import 'package:ez_shop_sync/src/data/repository/auth/auth_repository.dart';
import 'package:ez_shop_sync/src/data/repository/auth/local/auth_local_repository.dart';
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
import 'package:ez_shop_sync/src/pages/_app/app_state.dart';
import 'package:ez_shop_sync/src/services/firebase_service.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/services/navigation_service.dart';
import 'package:ez_shop_sync/src/theme/app_theme.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Singleton()
class AppCubit extends Cubit<AppState> {
  // repositories
  final LocalStorageService localStorageService;
  final AuthLocalRepository authLocalRepository;
  final StoreRepository storeRepository;
  final ProductRepository productRepository;
  final TagRepository tagRepository;
  final CategoryRepository categoryRepository;
  final CartRepository cartRepository;
  final UserRepository userRepository;
  final AddProductRepository addProductRepository;
  final NotificationRepository notificationRepository;
  final AuthRepository authRepository;
  //

  AppTheme? _appTheme;

  Size deviceSize = const Size(0, 0);

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
  final List<AddProduct> _addProducts = [];
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
  RoleType? get userRoleTypeCurrentStore => store?.members.firstWhere((e) => e.uid == user?.uid).roleType;
  String? get userId => user?.uid;
  String? get storeId => store?.id;
  String get currentUsername {
    if (user?.displayName == null && user?.email == null) {
      return 'Unknown';
      //  throw ('currentUsername user?.displayName == null && user?.email == null is Null');
    }
    return user?.displayName ?? user?.email?.substring(0, user?.email?.indexOf("@")) ?? '--';
  }

  AppCubit({
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
    required this.authRepository,
  }) : super(AppInitial()) {
    init();
  }

  void init() {
    log('init()', name: runtimeType.toString());
    startProfileUpdateListen();
  }

  Future<void> loadAllDependencies() async {
    emit(AppLoading());
    await loadUserData();
    await loadStores();
    await loadNotifications();
    emit(AppSuccess());
  }

  BaseRepoRequest<T> request<T>(T value) {
    return BaseRepoRequest<T>(storeId: storeId, userId: userId, data: value);
  }

  Future<void> loadStores() async {
    throwIf(userData == null, 'loadStores() userData == null');

    final result = await storeRepository.getAll();

    result.when(
      success: (response) {
        _stores = response;
        emit(AppGetStoreSuccess(response));
        setCurrentStoreById(userData?.storeSelected);
      },
      failure: (error, {errorType}) {
        emit(AppGetStoreFailure());
      },
    );
  }

  Future<void> loadUserData() async {
    final result = await userRepository.getUserData();

    result.when(
      success: (response) {
        _userData = response;
        emit(AppGetUserDataSuccess());
      },
      failure: (error, {errorType}) {
        emit(AppGetUserDataFailure());
      },
    );
  }

  startProfileUpdateListen() {
    FirebaseAuth.instance.userChanges().listen((User? user) {
      log('userChanges() isClosed:: $isClosed $user', name: runtimeType.toString());
      setCurrentUser(user);
      GetIt.I<FirebaseService>().updateUserFcmToken(userId!);
    });
  }

  loadAppTheme(AppTheme? value) {
    _appTheme = value;
    ColorKeys.primary = _appTheme?.primaryColor.toColor() ?? ColorKeys.defaultPrimary;
    ColorKeys.secondary = _appTheme?.secondaryColor.toColor() ?? ColorKeys.defaultSecondary;
    ColorKeys.accent = _appTheme?.accentColor.toColor() ?? ColorKeys.defaultAccent;
    ColorKeys.brightness = _appTheme?.backgroundColor.toColor() ?? ColorKeys.defaultBrightness;
    emit(AppLoadAppThemeSuccess(appTheme));
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

    await loadProductByCurrentStore();
    // await loadAllDependencies();
    // await doGetAddProductByCurrentUserAndStore();
    setCurrentAddProductByCurrentStore();
    setCurrentCartByCurrentStore();

    emit(AppSelectStore(_store?.id));
    // loadAppTheme(_store?.storeTheme);
    // loadTagsByCurrentStore();
    // loadCategoryByCurrentStore();
  }

  Future<void> setCurrentUser(User? user) async {
    _user = user;
    loadAllDependencies();
    emit(AppUserChange(user));
    // if (_user?.storeId?.isEmpty ?? true) {
    //   return;
    // }

    // await doGetStores(_user?.storeId ?? []);
  }

  setCurrentCartByCurrentStore() async {
    final resultCart = await cartRepository.getAll();

    log('setCurrentCartByCurrentStore() : $storeId, $userId : result ${resultCart.response?.map((e) => e.id)}');

    resultCart.when(
      success: (response) async {
        final cartFinded = await cartRepository.getCartsByUserIdWithCurrentStore(
          storeId: storeId ?? '',
          userId: userId ?? '',
        );

        log('getCartsByUserIdWithCurrentStore() : $storeId, $userId : result ${cartFinded.response}');
        cartFinded.when(
          success: (response) {
            setCurrentCart(response);
          },
          failure: (error) async {
            if (userId == null) {
              return;
            }

            final cartCreated = await cartRepository.create(
              BaseRepoRequest(
                storeId: store?.id,
                userId: userId!,
                data: Cart(id: const Uuid().v1(), storeId: store!.id, userId: user?.uid ?? '--', cartItems: []),
              ),
            );

            cartCreated.when(
              success: (response) {
                setCurrentCart(null);
              },
            );
          },
        );

        emit(AppRefresh(DateTime.now()));
      },
      failure: (error) async {
        if (userId == null) {
          return;
        }

        final cartCreated = await cartRepository.create(
          BaseRepoRequest(
            storeId: store?.id,
            userId: userId!,
            data: Cart(id: const Uuid().v1(), storeId: storeId ?? '', userId: userId ?? '', cartItems: []),
          ),
        );

        cartCreated.when(
          success: (response) {
            setCurrentCart(null);
          },
          failure: (error) {
            log('message');
          },
        );
        emit(AppRefresh(DateTime.now()));
      },
    );
  }

  setCurrentAddProductByCurrentStore() async {
    final resultAddProduct = await addProductRepository.getAll();

    if (resultAddProduct.response?.map((e) => e.storeId).toList().contains(storeId) ?? false) {
      final addProductFinded =
          resultAddProduct.response
              ?.where((addProduct) => addProduct.storeId == storeId && addProduct.userId == userId)
              .firstOrNull;
      setCurrentAddProduct(addProductFinded);
    } else {
      final addProductCreated = await addProductRepository.create(
        BaseRepoRequest<AddProduct>(
          data: AddProduct(
            id: const Uuid().v1(),
            storeId: storeId ?? '',
            userId: user?.uid ?? '',
            addProductItems: [],
            amountCost: 0,
            paymentType: PaymentMethodType.cash,
          ),
          storeId: storeId,
          userId: user?.uid ?? '',
        ),
      );

      addProductCreated.when(
        success: (response) async {
          setCurrentAddProduct(response);
        },
      );
    }

    // log('current Cart $cart');
  }

  setCurrentCart(Cart? value) {
    log('setCurrentCart $value');
    _cart = value;
    emit(AppCartUpdate());
  }

  setCurrentAddProduct(AddProduct? value) {
    log('setCurrentAddProduct : $value');
    _addProduct = value;
  }

  changeMode(AppMode mode) {
    _appMode = mode;
    emit(AppChangeAppMode(_appMode));
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
    try {
      if (sortType == ProductSortType.asc) {
        products.sort(
          (a, b) => a.info!.createAtDateTime.millisecondsSinceEpoch.compareTo(
            b.info!.createAtDateTime.millisecondsSinceEpoch,
          ),
        );
      } else {
        products.sort(
          (a, b) => b.info!.createAtDateTime.millisecondsSinceEpoch.compareTo(
            a.info!.createAtDateTime.millisecondsSinceEpoch,
          ),
        );
      }
    } catch (e) {
      log('sortProduct error $e');
    }
  }

  emitInitLocalStorageServiceSuccess() {
    emit(AppInitialLocalStorageServiceSuccess());
  }

  Future<void> loadProductByCurrentStore() async {
    if (storeId == null) {
      return;
    }

    emit(AppLoading());
    final result = await productRepository.getAllByStoreId(storeId!);

    result.when(
      success: (response) {
        setCurrentProduct(response ?? []);

        // sortProduct(productSortType);
        emit(AppSuccess());
      },
      failure: (error, {errorType}) {
        setCurrentProduct([]);
        emit(AppFailure());
      },
    );
  }

  void setCurrentProduct(List<Product> value) {
    _products = value;
  }

  doDeleteProduct({required String storeId, required Product product}) async {
    emit(AppLoading());

    _products.removeWhere((elelment) => elelment.id == product.id);
    emit(AppRefresh(DateTime.now()));
  }

  void refresh() {
    emit(AppRefresh(DateTime.now()));
  }

  void loadTagsByCurrentStore() async {
    emit(AppLoading());
    final result = await tagRepository.getAllByIds(store?.tags ?? []);
    result.when(
      success: (response) {
        _tags = response;
        emit(AppLoadTagsByStoreSuccess(store?.tags ?? []));
      },
      failure: (error) {
        emit(AppFailure());
      },
    );
  }

  void loadCategoryByCurrentStore() async {
    emit(AppLoading());
    final result = await categoryRepository.getAllByIds(store?.categories ?? []);

    result.when(
      success: (response) {
        _categories = response;
        emit(AppLoadCategoriesByStoreSuccess(store?.categories ?? []));
      },
      failure: (error) {
        emit(AppFailure());
      },
    );
  }

  void updateCurrentUser(User resultUpdated) {
    // setCurrentUser(localUser: resultUpdated);
  }

  void addCart({Offset? offset, required Product? product}) async {
    log('addCart() $cart');
    if (cart != null && product != null) {
      emit(AppLoading());
      final cartUpdate = await cartRepository.addCart(
        BaseRepoRequest(storeId: storeId, userId: userId, data: AddCartRequest(id: _cart!.id, product: product)),
      );

      log('cartUpdate $cartUpdate');
      emit(AppAddCartSuccess());
      Future.delayed(durationAddCart).then((value) {
        emit(AppAddCartAnimationSuccess());
      });
    }
  }

  Future<void> doGetAddProductByCurrentUserAndStore() async {
    // _addProducts = addProductRepository.getAddProductByUserIdWithCurrentStore(user!.addProducts);
  }

  Future<ApiResult> deleteItemFromCart(String cartItemId) async {
    emit(AppLoading());
    log('deleteItemFromCart : ${cartItemId}, ${cart?.id}');
    final resultCartUpdated = await cartRepository.deleteItemByIdFromCart(
      request(DeleteItemFromCartRequest(cartItemId: cartItemId, id: cart?.id)),
    );

    setCurrentCart(resultCartUpdated.response);

    emit(AppRemoveCartItem());

    return resultCartUpdated;
  }

  Future<ApiResult> deleteItemFromAddProduct(String addProductItemId) async {
    emit(AppLoading());
    final resultAddCartUpdated = await addProductRepository.deleteItemByIdFromAddProduct(
      BaseRepoRequest(
        storeId: storeId,
        userId: userId,
        data: DeleteItemFormCartRequest(id: addProduct?.id, addProductItemId: addProductItemId),
      ),
    );

    resultAddCartUpdated.when(
      success: (response) {
        setCurrentAddProduct(response);

        emit(AppRemoveCartItem());
      },
      failure: (error) {
        emit(AppFailure());
      },
    );

    return resultAddCartUpdated;
  }

  Future<Product?> addStock({required Product? product, required num amountCost}) async {
    if (product == null) {
      throw ('addStock product is Null');
    }

    if (addProduct == null) {
      return null;
    }

    emit(AppLoading());

    final addProductUpdate = await addProductRepository.addProductStock(
      BaseRepoRequest(
        storeId: storeId,
        userId: userId,
        data: AddProductStockRequest(id: addProduct!.id, orderItem: OrderItem(product: product, cost: amountCost)),
      ),
    );

    addProductUpdate.when(
      success: (response) {
        emit(AppAddStockSuccess(DateTime.now()));
      },
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

    return product;
  }

  void updateProductQuantity(Product? productUpdated) {
    final productFinded = _products.where((e) => e.id == productUpdated?.id).firstOrNull;

    if (productFinded == null) {
      throw ('updateProductQuantity() Product is Null');
    }

    productFinded.quantity = productUpdated?.quantity;
    emit(AppRefresh(DateTime.now()));
  }

  Future<void> updateDisplayName(String? displayNameEditor) async {
    await _user?.updateDisplayName(displayNameEditor);
  }

  Future<void> loadNotifications() async {
    final result = await notificationRepository.getNotifications();

    result.when(
      success: (response) {
        setNotifications(response);
        emit(AppGetNotificationsSuccess());
      },
      failure: (error, {errorType}) {
        emit(AppGetNotificationsFailure());
      },
    );
  }

  void setNotifications(List<Notification> response) {
    _notification = response;
  }

  void clearCurrentUserData() {}

  Future<void> logout() async {
    await authRepository.logout();
    await setCurrentUser(null);
  }
}
