import 'package:ez_shop_sync/flavors.dart';
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

@Singleton(signalsReady: true)
class ProductCubit extends Cubit<ProductState> {
  final AppCubit appCubit;
  final ProductRepository productRepository;

  ScreenMode screenMode = ScreenMode.display;
  String? searchText;
  List<Product> get products =>
      appCubit.products
          .where(
            (product) =>
                (searchText?.isEmpty ?? true)
                    ? true
                    : product.name.ignoreSpaceAndUpperCase().contains(searchText!.ignoreSpaceAndUpperCase()),
          )
          .toList();

  ProductCubit({required this.productRepository, required this.appCubit}) : super(ProductCubitInitial());

  get productCount => products.isEmpty ? '' : ' ( ${products.length} )';

  ProductDisplayType get displayType => appCubit.productDisplayType;
  ProductSortType get sortType => appCubit.productSortType;

  void changeSortType() {
    appCubit.changeSortType();

    emit(ProductRefresh(DateTime.now()));
  }

  changeDisplayType() {
    appCubit.changeDisplayType();
    emit(ProductRefresh(DateTime.now()));
  }

  Future<void> deleteProduct(String storeId, String id) async {
    await appCubit.doDeleteProduct(storeId: storeId, productId: id);
    emit(ProductRefresh(DateTime.now()));
  }

  Future<void> init() async {
    emit(ProductInitial());
    await appCubit.loadProductByCurrentStore();
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
    await appCubit.addStock(product: product, amountCost: amountCost);
    emit(ProductAddStockSuccess());
  }
}
