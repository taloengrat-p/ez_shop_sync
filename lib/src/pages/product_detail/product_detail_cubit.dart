import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductRepository productRepository;

  Product? product;
  BaseCubit baseCubit;

  String get productDescription => product?.description?.elseDisplay() ?? elseDisplay();
  List<Tag> get tags => baseCubit.tags.where((e) => product?.tag?.contains(e.id) ?? false).toList();
  Category? get category => baseCubit.categories.where((e) => product?.category == e.id).firstOrNull;
  ProductDetailCubit({
    required this.productRepository,
    required this.baseCubit,
  }) : super(ProductDetailInitial());

  setArgrument(Product value) {
    log('baseCubit.tags ${baseCubit.tags} : ${product?.tag}');

    product = value;

    if (product?.category?.isNotNull ?? false) {
      loadCategory();
    }

    if (product?.tag?.isNotEmpty ?? false) {
      loadTags();
    }

    emit(ProductDetailRefresh(DateTime.now()));
  }

  List<String> get imageMerged {
    List<String> images = [];

    if (product?.imageName?.isNotNull ?? false) {
      images.add(product!.imageName!);
    }

    if (product?.imageDetail?.isNotNull ?? false) {
      images.addAll(product!.imageDetail!);
    }

    return images;
  }

  void deleteProduct() {
    if (product?.id.isNull ?? true) {
      return;
    }
    emit(ProductDetailLoading());

    productRepository.delete(product!.id);

    emit(ProductDetailDelete());
  }

  void loadCategory() {}

  void loadTags() {}

  void refresh() {
    if (product != null) {
      product = productRepository.getById(product!.id);
      emit(ProductDetailInitial());
    } else {
      throw ('Product data not found.');
    }
  }

  void addCart(Product? cartProduct) {
    baseCubit.addCart(
      offset: Offset.zero,
      product: cartProduct,
    );
  }

  void addStock(Product? copyWith, num qty) async {
    emit(ProductDetailLoading());
    product = await baseCubit.addStock(product: copyWith, qty: qty);
    emit(ProductDetailRefresh(DateTime.now()));
  }
}
