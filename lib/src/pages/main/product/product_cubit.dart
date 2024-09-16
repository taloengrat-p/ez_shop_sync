import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/product_display_type.enum.dart';
import 'package:ez_shop_sync/src/models/product_sort_type.enum.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  BaseCubit baseCubit;
  ProductRepository productRepository;

  ScreenMode screenMode = ScreenMode.display;
  String? searchText;
  List<Product> get products => baseCubit.products
      .where(
        (product) => (searchText?.isEmpty ?? true)
            ? true
            : product.name.ignoreSpaceAndUpperCase().contains(
                  searchText!.ignoreSpaceAndUpperCase(),
                ),
      )
      .toList();

  ProductCubit({
    required this.productRepository,
    required this.baseCubit,
  }) : super(ProductInitial());

  get productCount => products.isEmpty ? '' : ' ( ${products.length} )';

  ProductDisplayType get displayType => baseCubit.productDisplayType;
  ProductSortType get sortType => baseCubit.productSortType;

  void changeSortType() {
    baseCubit.changeSortType();

    emit(ProductRefresh(DateTime.now()));
  }

  changeDisplayType() {
    baseCubit.changeDisplayType();
    emit(ProductRefresh(DateTime.now()));
  }

  void deleteProduct(String id) {
    baseCubit.doDeleteProduct(id);
    emit(ProductRefresh(DateTime.now()));
  }

  void init() async {
    await baseCubit.doGetProducts();
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
    baseCubit.addCart(offset: offset, product: product);
  }

  void addProductToStock(Product product) {
    emit(ProductLoading());
    baseCubit.addStock(product: product);
    emit(ProductAddStockSuccess());
  }
}
