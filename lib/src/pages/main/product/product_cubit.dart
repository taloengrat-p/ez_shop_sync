import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ProductDisplayType {
  grid,
  list;
}

class ProductCubit extends Cubit<ProductState> {
  BaseCubit baseCubit;
  ProductRepository productRepository;
  List<Product> _products = [];

  List<Product> get products => _products;
  ProductCubit({
    required this.productRepository,
    required this.baseCubit,
  }) : super(ProductInitial());

  get productCount => products.isEmpty ? '' : ' ( ${products.length} )';

  get displayType => baseCubit.displayType;

  changeDisplayType() {
    baseCubit.displayType =
        baseCubit.displayType == ProductDisplayType.grid ? ProductDisplayType.list : ProductDisplayType.grid;
    emit(ProductRefresh(DateTime.now()));
  }

  init() async {
    emit(ProductLoading());
    final allProduct = productRepository.getAll();

    log('get all Product : $allProduct');
    _products = allProduct;

    emit(ProductSuccess());
  }

  void deleteProduct(String? id) {
    if (id.isNotNull) {
      productRepository.delete(id!);
      _products.removeWhere((elelment) => elelment.id == id);
    }
    emit(ProductRefresh(DateTime.now()));
  }
}
