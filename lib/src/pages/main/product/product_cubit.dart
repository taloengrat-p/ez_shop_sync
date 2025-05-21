import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/request/pagination_index_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/product_request/get_product_request.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/product_display_type.enum.dart';
import 'package:ez_shop_sync/src/models/product_sort_type.enum.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/product/models/product_category_group.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class ProductCubit extends Cubit<ProductState> {
  final AppCubit appCubit;
  final ProductRepository productRepository;
  final int limitLength = 10;
  ScreenMode screenMode = ScreenMode.display;
  String? searchText;
  String? categorySelect;
  Map<String?, ProductCategoryGroup> _products = {};
  // AppSortType sortType = AppSortType.desc;
  bool isDesc = true;
  List<Product> get products => _products[categorySelect]?.products ?? [];
  QueryDocumentSnapshot? get lastDocumentByCategorySelected => _products[categorySelect]?.lastDocument;

  get productCount =>
      products.isEmpty
          ? ''
          : ' ( ${_products[categorySelect]?.totalItems != 0 ? _products[categorySelect]?.totalItems : (appCubit.totalAllProduct != 0 ? appCubit.totalAllProduct : 0)} )';

  ProductDisplayType get displayType => appCubit.productDisplayType;

  List<Category> get categories => [Category(id: null, name: LocaleKeys.all.tr()), ...appCubit.categories];

  List<String> get productIds => products.map((e) => e.id.toString()).toList();
  ProductCubit({required this.productRepository, required this.appCubit}) : super(ProductCubitInitial()) {
    emit(ProductInitialLoading());
    _initial(appCubit.products);
    emit(ProductInitial());
  }

  _initial(List<Product> data) {
    Map<String?, ProductCategoryGroup> itemMap = {
      for (var item in categories) item.id: ProductCategoryGroup(products: [], totalItems: 0),
    };

    _products = itemMap;
    doAddAllProductLoaded(data);
    log('updateCurrentProductFromAppCubit ${appCubit.totalAllProduct}) ');
    emit(const ProductUpdateCartFromAppState());
  }

  void changeSortType() async {
    isDesc = !isDesc;
    emit(ProductChangeSortType(sortType: isDesc ? AppSortType.desc : AppSortType.asc));
    await refresh(loading: false);
    emit(ProductChangeSortTypeSuccess(sortType: isDesc ? AppSortType.desc : AppSortType.asc));
  }

  changeDisplayType() {
    appCubit.changeDisplayType();
    emit(ProductRefresh(DateTime.now()));
  }

  Future<void> deleteProduct(String storeId, Product product) async {
    emit(ProductLoading());
    final result = await productRepository.deleteProduct(appCubit.request(product));

    result.when(
      success: (response) {
        products.removeWhere((e) => e.id == product.id);
        // appCubit.doDeleteProduct(storeId: storeId, product: product);
        emit(ProductDeleteSuccess(id: product.id));
      },
      failure: (error) {
        emit(ProductDeleteFailure());
      },
    );

    emit(ProductRefresh(DateTime.now()));
  }

  void setSearchText(String? value) {
    searchText = value;

    emit(ProductRefresh(DateTime.now()));
  }

  doSwitchToSearch() {
    screenMode = ScreenMode.search;
    emit(ProductChangeScreenMode(screenMode));
  }

  void clearSearchText() {
    searchText = '';
    emit(ProductRefresh(DateTime.now()));
  }

  doSwitchToDisplay() {
    clearSearchText();
    screenMode = ScreenMode.display;
    emit(ProductChangeScreenMode(screenMode));
  }

  void addCart(Product product, {Offset? offset}) {
    appCubit.addCart(offset: offset, product: product);
  }

  void addProductToStock(Product product, num amountCost) async {
    emit(ProductLoading());
    final resultAddProduct = await appCubit.addStock(product: product, amountCost: amountCost);

    resultAddProduct.when(
      success: (response) {
        emit(ProductAddStockSuccess());
      },
      failure: (error) {
        emit(ProductAddStockFailure(apiError: error));
      },
    );
  }

  Future<void> refresh({bool? loading = true}) async {
    if (appCubit.storeId == null) {
      return;
    }

    if (loading == true) {
      emit(ProductLoading());
    }
    final result = await productRepository.getAllByStoreAndBranchId(
      appCubit.request(
        PaginationIndexRequest(
          start: 0,
          limit: limitLength,
          descending: isDesc,
          payload: GetProductRequest(categoryId: categorySelect),
        ),
      ),
    );

    return result.when(
      success: (response) {
        products.clear();
        _products[categorySelect]?.lastDocument = response.lastDocument;
        _products[categorySelect]?.totalItems = response.totalItem;
        doAddAllProductLoaded(response.data);
        emit(const ProductLoadItemSuccess());
      },
      failure: (error, {errorType}) {
        emit(const ProductLoadItemFailure());
      },
    );
  }

  Future<bool> loadMore() async {
    if (appCubit.storeId == null) {
      return false;
    }

    log('loadMore ${categories.where((e) => e.id == categorySelect).firstOrNull?.name}', name: runtimeType.toString());
    final result = await productRepository.getAllByStoreAndBranchId(
      appCubit.request(
        PaginationIndexRequest(
          start: products.length,
          limit: limitLength,
          lastDocument: lastDocumentByCategorySelected,
          descending: isDesc,
          payload: GetProductRequest(categoryId: categorySelect),
        ),
      ),
    );

    return result.when(
      success: (response) {
        _products[categorySelect]?.lastDocument = response.lastDocument;
        _products[categorySelect]?.totalItems = response.totalItem;
        doAddAllProductLoaded(response.data);
        emit(const ProductLoadItemSuccess());

        return response.data.isNotEmpty;
      },
      failure: (error, {errorType}) {
        emit(const ProductLoadItemFailure());
        return false;
      },
    );
  }

  void changeCategoryProductView(String? cateId) async {
    if (cateId == categorySelect || state is ProductInitialLoading) {
      return;
    }

    emit(ProductInitialLoading());

    categorySelect = cateId;

    if (products.isNotEmpty) {
      emit(ProductSuccess());
      return;
    }

    final result = await productRepository.getAllByStoreAndBranchId(
      appCubit.request(
        PaginationIndexRequest(
          start: products.length,
          limit: limitLength,
          descending: isDesc,
          lastDocument: lastDocumentByCategorySelected,
          payload: GetProductRequest(categoryId: cateId),
        ),
      ),
    );

    result.when(
      success: (response) {
        _products[categorySelect]?.lastDocument = response.lastDocument;
        _products[categorySelect]?.totalItems = response.totalItem;
        doAddAllProductLoaded(response.data);
        // _products[categorySelect]?.products = response.data;
        emit(ProductSuccess());
      },
      failure: (error) {
        emit(ProductFailure());
      },
    );
  }

  void doAddAllProductLoaded(List<Product> data) {
    final productToAdd = data.where((newData) => !productIds.contains(newData.id)).toList();

    products.addAll(productToAdd);
    emit(const ProductUpdateCartFromAppState());
  }
}
