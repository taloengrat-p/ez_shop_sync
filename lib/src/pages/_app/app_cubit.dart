import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/branch.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/payment_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/role_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/notification.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/unit_type.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user_data.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/add_product_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/delete_item_form_cart_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/cart_request/add_cart_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/cart_request/delete_item_from_cart_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/dto/response/pagination_response.dart';
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
import 'package:ez_shop_sync/src/pages/splash/splash_cubit.dart';
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
  final int limitProductLength = 10;
  QueryDocumentSnapshot? lastDocument;
  Size deviceSize = const Size(0, 0);

  final durationAddCart = const Duration(milliseconds: 700);
  NavigationService navigationService;
  AppMode _appMode = AppMode.local;
  ProductDisplayType productDisplayType = ProductDisplayType.grid;
  ProductSortType productSortType = ProductSortType.desc;
  bool isFirstRun = false;
  bool? isIntroduceFlowDone;
  User? _user;
  UserData? _userData;
  Store? _store;
  Branch? _branch;
  final List<Product> _products = [];
  List<Store> _stores = [];
  List<Branch> _branches = [];
  List<Tag> _tags = [];
  List<Category> _categories = [];
  List<Notification> _notification = [];
  Cart? _cart;
  AddProduct? _addProduct;
  int _totalAllProduct = 0;

  bool descending = true;
  // getter sections

  int get totalAllProduct => _totalAllProduct;

  List<Notification> get notification => _notification;
  AppMode get appMode => _appMode;
  User? get user => _user;
  UserData? get userData => _userData;
  Store? get store => _store;
  Branch? get branch => _branch;
  Cart? get cart => _cart;
  AddProduct? get addProduct => _addProduct;
  List<Product> get products => _products;
  List<String> get productIds => products.map((e) => e.id.toString()).toList();
  List<Store> get stores => _stores;
  List<Branch> get branches => _branches;
  List<Tag> get tags => _tags;
  List<Category> get categories => _categories;
  AppTheme? get appTheme => _appTheme;
  int get cartCount => cart?.cartItems.length ?? 0;
  int get notificationCount => 0;
  int get addProductCount => _addProduct?.addProductItems.length ?? 0;
  RoleType? get userRoleTypeCurrentStore => store?.members.firstWhere((e) => e.uid == user?.uid).roleType;
  String? get userId => user?.uid;
  String? get storeId => store?.id;
  String? get branchId => branch?.id;
  String get currentUsername {
    if (user?.displayName == null && user?.email == null) {
      return 'Unknown';
      //  throw ('currentUsername user?.displayName == null && user?.email == null is Null');
    }
    return user?.displayName ?? user?.email?.substring(0, user?.email?.indexOf("@")) ?? '--';
  }

  String get userRoleOnStoreSelect =>
      store?.members.where((e) => e.email == user?.email).firstOrNull?.roleType.label ?? '--';

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
    // init();
  }

  String get currentStoreName => store?.name ?? '--';
  String get currentBranchName => branch?.name ?? '--';

  List<UnitType> _unitTypes = [];
  List<UnitType> get unitTypes => _unitTypes;

  // void init() {
  // log('init()', name: runtimeType.toString());
  // startProfileUpdateListen();
  // }

  Future<void> loadAllDependencies() async {
    log('state app cubloadAllDependencies successit : ${GetIt.instance.isRegistered<SplashCubit>()}');
    emit(AppGetAllDataStarterLoading());
    await loadUserData();
    await loadStores();
    await loadNotifications();

    log('updateCurrentProductFromAppCubit loadAllDependencies success');
    emit(AppGetAllDataStarterSuccess());
  }

  BaseRepoRequest<T> request<T>(T value) {
    return BaseRepoRequest<T>(storeId: storeId ?? '', branchId: branchId ?? '', userId: userId ?? '', data: value);
  }

  Future<void> loadStores() async {
    throwIf(userData == null, 'loadStores() userData == null');

    final result = await storeRepository.getAll();

    return await result.when(
      success: (storesResponse) async {
        _stores = storesResponse;
        final resultAllBranch = await storeRepository.getAllBranchesByStoreIds(
          request(stores.map((e) => e.id.toString()).toList()),
        );

        resultAllBranch.when(
          success: (brancesResponse) {
            _stores =
                stores
                    .map(
                      (item) =>
                          item
                            ..branches =
                                brancesResponse.where((branchItem) => item.id == branchItem.info?.storeId).toList(),
                    )
                    .toList();
          },
        );

        await setCurrentStoreAndBranchById(
          userData?.storeSelected,
          branchId: userData?.branchSelected,
          origin: runtimeType.toString(),
        );

        emit(AppGetStoreSuccess(storesResponse));
      },
      failure: (error, {errorType}) {
        _store?.branches?.clear();
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

  // startProfileUpdateListen() {

  // }

  loadAppTheme(AppTheme? value) {
    _appTheme = value;
    ColorKeys.primary = _appTheme?.primaryColor.toColor() ?? ColorKeys.defaultPrimary;
    ColorKeys.secondary = _appTheme?.secondaryColor.toColor() ?? ColorKeys.defaultSecondary;
    ColorKeys.accent = _appTheme?.accentColor.toColor() ?? ColorKeys.defaultAccent;
    ColorKeys.brightness = _appTheme?.backgroundColor.toColor() ?? ColorKeys.defaultBrightness;
    emit(AppLoadAppThemeSuccess(appTheme));
  }

  Future<void> setCurrentStoreAndBranchById(String? id, {String? branchId, String? origin}) async {
    log('setCurrentStoreById($origin) store : ($id), branch : ($branchId)');
    emit(AppGetStoreLoading());
    final store = _stores.where((e) => e.id == id).firstOrNull;
    final branchFinded = _branches.where((e) => e.id == branchId).firstOrNull;
    _branch = branchFinded;
    await setCurrentStore(store);
  }

  setCurrentStoreByLastCreate() {}

  Future<void> setCurrentStore(Store? value) async {
    if (_store == value) {
      return;
    }

    _store = value;

    // await authLocalRepository.update(user?.id, user!..storeLatest = store!.id);

    if (value == null) {
      throw ('setCurrentStore store == null');
    }

    emit(AppChangeStoreLoading());

    await refreshProductByCurrentStoreAndBranch();
    await doGetBranchByCurrentStore();
    await doGetUniTypeByCurrentStore();
    // await loadAllDependencies();
    // await doGetAddProductByCurrentUserAndStore();
    await setCurrentAddProductByCurrentStore();
    await setCurrentCartByCurrentStore();
    await loadCategoryByCurrentStore();

    emit(AppSelectStore(_store?.id));
    // loadAppTheme(_store?.storeTheme);
    // loadTagsByCurrentStore();
  }

  Future<void> setCurrentUser(User? user, {String? origin}) async {
    log('setCurrentUser($origin) $user');
    _user = user;
    if (_user != null) {
      await loadAllDependencies();
      emit(AppUserChange(user));
    } else {
      emit(AppUserChange(user));
    }
  }

  Future<ApiResult<List<Cart>>> setCurrentCartByCurrentStore() async {
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
              request(Cart(id: const Uuid().v1(), storeId: store!.id, userId: user?.uid ?? '--', cartItems: [])),
            );

            cartCreated.when(
              success: (response) {
                setCurrentCart(response);
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
          request(Cart(id: const Uuid().v1(), storeId: storeId ?? '', userId: userId ?? '', cartItems: [])),
        );

        cartCreated.when(
          success: (response) {
            setCurrentCart(response);
          },
          failure: (error) {
            log('message');
          },
        );
        emit(AppRefresh(DateTime.now()));
      },
    );

    return resultCart;
  }

  Future<void> setCurrentAddProductByCurrentStore() async {
    final resultAddProduct = await addProductRepository.getAll();

    final allAddProduct = resultAddProduct.response?.map((e) => e.storeId).toList();

    final alreadyExistAddProduct = allAddProduct?.contains(storeId) ?? false;

    log('setCurrentAddProductByCurrentStore alreadyExistAddProduct : $alreadyExistAddProduct');
    if (alreadyExistAddProduct) {
      final addProductFinded =
          resultAddProduct.response
              ?.where((addProduct) => addProduct.storeId == storeId && addProduct.userId == userId)
              .firstOrNull;
      setCurrentAddProduct(addProductFinded, origin: 'alreadyExistAddProduct');
    } else {
      final addProductCreated = await addProductRepository.create(
        request(
          AddProduct(
            id: const Uuid().v1(),
            storeId: storeId ?? '',
            userId: user?.uid ?? '',
            addProductItems: [],
            amountCost: 0,
            paymentType: PaymentMethodType.cash.name,
          ),
        ),
      );

      addProductCreated.when(
        success: (response) async {
          setCurrentAddProduct(response, origin: 'create new');
        },
        failure: (error) async {
          final addProductCreated = await addProductRepository.create(
            request(
              AddProduct(
                id: const Uuid().v1(),
                storeId: storeId ?? '',
                userId: user?.uid ?? '',
                addProductItems: [],
                amountCost: 0,
                paymentType: PaymentMethodType.cash.name,
              ),
            ),
          );

          addProductCreated.when(
            success: (response) {
              setCurrentAddProduct(response, origin: 'is null and failure');
            },
          );
        },
      );
    }

    // log('current Cart $cart');
  }

  setCurrentCart(Cart? value) {
    log('setCurrentCart::: ${value?.id}');
    _cart = value;
    emit(AppCartUpdate());
  }

  setCurrentAddProduct(AddProduct? value, {String? origin}) {
    log('setCurrentAddProduct($origin) : $value');
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
    descending = !descending;
    productSortType = descending ? ProductSortType.desc : ProductSortType.asc;

    // sortProduct(productSortType);
  }

  // sortProduct(ProductSortType sortType) {
  //   try {
  //     if (sortType == ProductSortType.asc) {
  //       products.sort(
  //         (a, b) => a.info!.createAtDateTime.millisecondsSinceEpoch.compareTo(
  //           b.info!.createAtDateTime.millisecondsSinceEpoch,
  //         ),
  //       );
  //     } else {
  //       products.sort(
  //         (a, b) => b.info!.createAtDateTime.millisecondsSinceEpoch.compareTo(
  //           a.info!.createAtDateTime.millisecondsSinceEpoch,
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     log('sortProduct error $e');
  //   }
  // }

  emitInitLocalStorageServiceSuccess() {
    emit(AppInitialLocalStorageServiceSuccess());
  }

  Future<ApiResult<PaginationResponse<List<Product>>>> loadProductByCurrentStore() async {
    if (storeId == null) {
      return ApiResult(error: storeId == null);
    }

    emit(AppLoading());

    final result = await productRepository.getAllByStoreAndBranchId(
      request(
        PaginationIndexRequest(
          start: products.length,
          limit: limitProductLength,
          lastDocument: lastDocument,
          descending: descending,
        ),
      ),
    );

    result.when(
      success: (response) {
        lastDocument = response.lastDocument;
        doAddProduct(response.data, totalItem: response.totalItem);
        emit(AppGetAllProductByCurrentStoreSuccess(products: response.data));
      },
      failure: (error, {errorType}) {
        emit(AppGetAllProductByCurrentStoreFailure());
      },
    );
    return result;
  }

  doDeleteProduct({required String storeId, required Product product}) async {
    emit(AppLoading());
    _totalAllProduct--;
    _products.removeWhere((elelment) => elelment.id == product.id);
    emit(AppDeleteProductSuccess());
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

  Future<void> loadCategoryByCurrentStore() async {
    emit(AppLoading());
    final result = await categoryRepository.getCategoryByStoreId(request(null));

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

  Future<void> addCart({Offset? offset, required Product? product}) async {
    log('addCart() $cart');
    if (cart != null && product != null) {
      emit(AppLoading());
      final cartUpdate = await cartRepository.addCart(
        request(
          AddCartRequest(
            id: _cart!.id,
            product:
                product
                  ..info?.createAt = null
                  ..info?.updateAt = null,
          ),
        ),
      );

      return cartUpdate.when(
        success: (response) {
          log('cartUpdate $cartUpdate');
          emit(AppAddCartSuccess());
          Future.delayed(durationAddCart).then((value) {
            emit(AppAddCartAnimationSuccess());
          });
        },
        failure: (error) {
          emit(AppAddCartFailure());
        },
      );
    }
  }

  Future<ApiResult> deleteItemFromCart(String cartItemId) async {
    emit(AppLoading());
    log('deleteItemFromCart : $cartItemId, ${cart?.id}');
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
      request(DeleteItemFormCartRequest(id: addProduct?.id, addProductItemId: addProductItemId)),
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

  Future<ApiResult<AddProduct>> addStock({required Product? product, required num amountCost}) async {
    if (product == null) {
      throw ('addStock product is Null');
    }

    if (addProduct == null) {
      throw ('addProduct == null');
    }

    emit(AppLoading());

    final addProductUpdate = await addProductRepository.addProductStock(
      request(
        AddProductStockRequest(
          id: addProduct!.id,
          orderItem: OrderItem(
            product:
                product
                  ..info?.createAt = null
                  ..info?.updateAt = null,
            cost: amountCost,
          ),
        ),
      ),
    );

    addProductUpdate.when(
      success: (response) {
        emit(AppAddStockSuccess(DateTime.now()));
      },
      failure: (error) {
        emit(AppAddStockFailure(error));
      },
    );
    return addProductUpdate;
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
    await setCurrentUser(null, origin: runtimeType.toString());
  }

  Future<ApiResult<List<Branch>>> doGetBranchByCurrentStore() async {
    emit(AppLoading());
    final result = await storeRepository.getStoreBranches(request(null));

    result.when(
      success: (response) {
        _branches = response;
        emit(AppBranchSuccess(branches: response));
      },
      failure: (error) {
        emit(AppFailure());
      },
    );

    return result;
  }

  Future<ApiResult<List<UnitType>>> doGetUniTypeByCurrentStore() async {
    emit(AppLoading());
    final result = await storeRepository.getUnitTypes(request(null));

    result.when(
      success: (response) {
        _unitTypes = response;
        emit(AppGetUnitTypesSuccess(unitTypes: response));
      },
      failure: (error) {
        emit(AppFailure());
      },
    );

    return result;
  }

  Future<ApiResult> deleteBranch(BaseRepoRequest<String> request) async {
    emit(AppLoading());
    final result = await storeRepository.deleteBranch(request);

    result.when(
      success: (response) {
        _branches.removeWhere((e) => e.id == request.data);
        emit(AppSuccess());
      },
      failure: (error) {
        emit(AppFailure());
      },
    );

    return result;
  }

  void doAddProduct(List<Product> list, {required int totalItem}) {
    log('updateCurrentProductFromAppCubit doAddProduct() ${list.length}');
    final productFilted = list.where((product) => !productIds.contains(product.id)).toList();
    _totalAllProduct = totalItem;
    _products.addAll(productFilted);
    emit(AppRefresh(DateTime.now()));
  }

  Future<ApiResult<PaginationResponse<List<Product>>>> refreshProductByCurrentStoreAndBranch() async {
    clearCurrentProducts();
    final result = await loadProductByCurrentStore();
    emit(AppRefreshProductByCurrentStoreAndBranch());

    return result;
  }

  void clearCurrentProducts() {
    lastDocument = null;
    _products.clear();
  }

  void addUnitTypes(UnitType unitType) {
    if (unitTypes.any((e) => e.id == unitType.id)) {
      return;
    }

    _unitTypes.add(unitType);
  }

  void updateUnitType(UnitType result) {
    int index = _unitTypes.indexWhere((unitType) => unitType.id == result.id);
    if (index != -1) {
      _unitTypes[index] = result;
    }
  }
}
