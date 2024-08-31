import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/product_display_type.enum.dart';
import 'package:ez_shop_sync/src/models/product_sort_type.enum.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  BaseCubit baseCubit;
  ProductRepository productRepository;

  List<Product> get products => baseCubit.products;
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

  void addProductToStock(String id, num value) {
    baseCubit.addProductToStock(id, value);
  }
}
