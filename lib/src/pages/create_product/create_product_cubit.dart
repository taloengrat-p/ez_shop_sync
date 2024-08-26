import 'dart:developer';
import 'dart:io';

import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:ez_shop_sync/src/utils/folder_file_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  ProductRepository productRepository;
  BaseCubit baseCubit;
  String name = '';
  String description = '';
  String category = '';
  String brand = '';
  ProductStatus status = ProductStatus.active;
  String? productImage;
  List<String>? productDetalImages;
  num? price;
  // List<String> tags = [];
  CreateProductCubit({
    required this.productRepository,
    required this.baseCubit,
  }) : super(CreateProductInitial());

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
    log('setProductImageSelect $productImage');
  }

  void submit() async {
    emit(CreateProductLoading());

    final productId = const Uuid().v1();

    createProduct(id: productId, productImageUrl: productImage);
  }

  Future<void> createProduct(
      {required String id, String? productImageUrl}) async {
    String? imageFullName;
    if (productImageUrl.isNotNull) {
      final fileBytes =
          await FolderFileUtils.getFileBytes(File(productImageUrl!));
      final imageName = const Uuid().v1().substring(0, 10);
      final imageSaveModel =
          (await FolderFileUtils.saveImageInApp(fileBytes, imageName));
      imageFullName = imageSaveModel.fileName;
    }
    final result = await productRepository.create(
      Product(
        id: id,
        storeId: baseCubit.store!.id,
        name: name,
        description: description,
        price: price,
        category: category,
        brand: brand,
        status: status,
        image: productImageUrl,
        imageDetail: productDetalImages,
        imageName: imageFullName,
      ),
    );

    Future.delayed(Duration.zero, () {
      emit(CreateProductSuccess(result));
    });
  }
}
