import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_history.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product_history/product_history_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductRepository productRepository;
  final ProductHistoryRepository productHistoryRepository;
  final AppCubit appCubit;

  Product? product;
  List<ProductHistory>? productHistory;
  String get productDescription => product?.description ?? '';
  List<Tag> get tags => appCubit.tags.where((e) => product?.tag?.contains(e.id) ?? false).toList();
  Category? get category => appCubit.categories.where((e) => product?.category == e.id).firstOrNull;
  ProductDetailCubit({required this.productHistoryRepository, required this.productRepository, required this.appCubit})
    : super(ProductDetailInitial());

  setArgrument(Product value, {String? heroTag}) async {
    log('baseCubit.tags ${appCubit.tags} : ${product?.tag}');

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

  List<String> get imageMerged =>
      product?.imageUrl != null ? [product!.imageUrl!, ...product?.imagesUrl ?? []] : product?.imagesUrl ?? [];

  Future<void> deleteProduct() async {
    if (product?.id == null) {
      return;
    }
    emit(ProductDetailLoading());

    final result = await productRepository.deleteProduct(
      BaseRepoRequest(storeId: appCubit.storeId ?? '', userId: appCubit.userId ?? '', data: product!),
    );

    result.when(
      success: (response) {
        emit(ProductDetailDeleteSuccess());
      },
      failure: (error) {
        emit(ProductDetailDeleteFailure());
      },
    );
  }

  void loadCategory() {}

  void loadTags() {}

  Future<void> refresh() async {
    log('get ${product!.id}');
    emit(ProductDetailLoading());
    final result = await productRepository.getById(
      BaseRepoRequest(storeId: appCubit.storeId ?? '', userId: appCubit.userId ?? '', data: product!.id),
    );
    result.when(
      success: (response) {
        product = response;
        emit(ProductDetailSuccess());
      },
      failure: (error) {
        emit(ProductDetailFailure());
      },
    );
  }

  void addCart(Product? cartProduct) {
    appCubit.addCart(offset: Offset.zero, product: cartProduct);
  }

  void addStock(Product? product, num amountCost) async {
    emit(ProductDetailLoading());
    product = await appCubit.addStock(product: product, amountCost: amountCost);
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
