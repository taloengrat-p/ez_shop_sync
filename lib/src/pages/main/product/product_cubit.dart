import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/product_display_type.enum.dart';
import 'package:ez_shop_sync/src/models/product_sort_type.enum.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class ProductCubit extends Cubit<ProductState> {
  final AppCubit appCubit;
  final ProductRepository productRepository;

  ScreenMode screenMode = ScreenMode.display;
  String? searchText;

  List<Product> _products = [];
  List<Product> get products => _products;

  ProductCubit({required this.productRepository, required this.appCubit}) : super(ProductCubitInitial()) {
    updateCurrentProductFromAppCubit(appCubit.products);
    emit(const ProductLoadItemSuccess());
  }

  get productCount => products.isEmpty ? '' : ' ( ${appCubit.totalAllProduct} )';

  ProductDisplayType get displayType => appCubit.productDisplayType;
  ProductSortType get sortType => appCubit.productSortType;

  void changeSortType() async {
    appCubit.changeSortType();
    emit(ProductChangeSortType(sortType: sortType));
    await refresh();
    emit(ProductChangeSortTypeSuccess(sortType: sortType));
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
        _products.removeWhere((e) => e.id == product.id);
        appCubit.doDeleteProduct(storeId: storeId, product: product);
        emit(ProductDeleteSuccess(id: product.id));
      },
      failure: (error) {
        emit(ProductDeleteFailure());
      },
    );

    emit(ProductRefresh(DateTime.now()));
  }

  // Future<void> init({bool isRefresh = false}) async {
  //   if (appCubit.storeId == null) {
  //     return;
  //   }

  //   emit(ProductInitial());

  //   final start = appCubit.products.length;

  //   final result = await productRepository.getAllByStoreAndBranchId(
  //     appCubit.request(PaginationIndexRequest(start: start, limit: limitLength, lastDocument: lastDocument)),
  //   );

  //   result.when(
  //     success: (response) {
  //       appCubit.doAddProduct(response ?? []);

  //       emit(ProductLoadItemSuccess(start: start, limit: limitLength));
  //     },
  //     failure: (error, {errorType}) {
  //       emit(ProductLoadItemSuccess(start: start, limit: limitLength));
  //     },
  //   );
  // }

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

  // refreshProductFromAppState() {
  //   emit(ProductLoading());

  //   _products.clear();
  //   _products = appCubit.products;
  //   emit(ProductSuccess());
  // }

  Future<void> refresh() async {
    if (appCubit.storeId == null) {
      return;
    }

    emit(ProductLoading());
    final result = await appCubit.refreshProductByCurrentStoreAndBranch();

    return result.when(
      success: (response) {
        if (response.data.isEmpty) {
          emit(const ProductLoadItemSuccess());
        } else {
          _products.clear();
          updateCurrentProductFromAppCubit(response.data);
          emit(const ProductLoadItemSuccess());
        }
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

    final result = await appCubit.loadProductByCurrentStore();

    return result.when(
      success: (response) {
        updateCurrentProductFromAppCubit(response.data);
        emit(const ProductLoadItemSuccess());

        return response.data.isNotEmpty;
      },
      failure: (error, {errorType}) {
        emit(const ProductLoadItemFailure());
      },
    );
  }

  updateCurrentProductFromAppCubit(List<Product> data) {
    _products.addAll(data);
  }
}
