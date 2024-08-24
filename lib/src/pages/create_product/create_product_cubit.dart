import 'dart:developer';
import 'dart:io';

import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_state.dart';
import 'package:ez_shop_sync/src/utils/crypto_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  ProductRepository productRepository;

  String name = '';
  String description = '';
  String category = '';
  String brand = '';
  ProductStatus status = ProductStatus.active;
  String? productImage;
  List<String>? productDetalImages;
  num price = 0;
  // List<String> tags = [];
  CreateProductCubit({
    required this.productRepository,
  }) : super(CreateProductInitial());

  void submit() async {
    emit(CreateProductLoading());

    final result = await productRepository.create(
      Product(
        name: name,
        description: description,
        price: price,
        category: category,
        brand: brand,
        status: status,
        image: productImage,
        imageDetail: productDetalImages,
      ),
    );
    emit(CreateProductSuccess());
  }

  setName(String? value) {
    name = value ?? '';
  }

  setDescription(String? value) {
    description = value ?? '';
  }

  setPrice(String? value) {
    try {
      price = num.parse(value!);
    } catch (e) {}
  }

  setCategory(String? value) {
    category = value ?? '';
  }

  setBrand(String? value) {
    brand = value ?? '';
  }

  setStatus(String? value) {
    status = ProductStatus.fromString(value);
  }

  setProductDetailImageSelect(List<File>? values) {
    productDetalImages = values?.map((e) => e.path).toList();
  }

  setProductImageSelect(File? value) {
    productImage = value?.path;
  }
}
