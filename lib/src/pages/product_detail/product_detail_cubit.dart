import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_history.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product_history/product_history_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductRepository productRepository;
  ProductHistoryRepository productHistoryRepository;

  Product? product;
  List<ProductHistory>? productHistory;
  BaseCubit baseCubit;

  String get productDescription => product?.description ?? '';
  List<Tag> get tags => baseCubit.tags
      .where((e) => product?.tag?.contains(e.id) ?? false)
      .toList();
  Category? get category =>
      baseCubit.categories.where((e) => product?.category == e.id).firstOrNull;
  ProductDetailCubit({
    required this.productHistoryRepository,
    required this.productRepository,
    required this.baseCubit,
  }) : super(ProductDetailInitial());

  setArgrument(Product value) async {
    log('baseCubit.tags ${baseCubit.tags} : ${product?.tag}');

    product = value;

    if (product?.category?.isNotNull ?? false) {
      loadCategory();
    }

    if (product?.tag?.isNotEmpty ?? false) {
      loadTags();
    }

    await loadProducthistory();

    emit(ProductDetailRefresh(DateTime.now()));
  }

  List<String> get imageMerged => product?.imagesPath ?? [];

  Future<void> deleteProduct() async {
    if (product?.id == null) {
      return;
    }
    emit(ProductDetailLoading());

    await productRepository.delete(
      baseCubit.store!.id,
      product!.id,
      appMode: AppMode.server,
    );

    emit(ProductDetailDelete());
  }

  void loadCategory() {}

  void loadTags() {}

  void refresh({Product? product}) async {
    product = product ??
        (await productRepository.getById(
                storeId: product!.storeId, productId: this.product!.id))
            .response;
    emit(ProductDetailInitial());
  }

  void addCart(Product? cartProduct) {
    baseCubit.addCart(
      offset: Offset.zero,
      product: cartProduct,
    );
  }

  void addStock(Product? product, num amountCost) async {
    emit(ProductDetailLoading());
    product = await baseCubit.addStock(
      product: product,
      amountCost: amountCost,
    );
    emit(ProductDetailRefresh(DateTime.now()));
  }

  Future<void> loadProducthistory() async {
    if (product == null) {
      throw ('loadProducthistory product is Null');
    }

    final result = await productRepository.getProductHistory(
      productId: product!.id,
      storeId: product!.storeId,
      limit: 10,
    );

    result.when(
      success: (response) {
        productHistory = response;

        emit(ProductDetailLoadHistorySuccess());
      },
      failure: (error) {
        emit(ProductDetailLoadHistoryFailure());
      },
    );
  }
}
