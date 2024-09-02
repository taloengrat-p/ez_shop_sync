import 'dart:developer';
import 'dart:io';

import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
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
  num? quantity;
  Map<String, dynamic> customField = {};

  String tempCustomName = '';
  String tempCustomValue = '';

  List<Tag> get tags => baseCubit.tags;
  List<Tag> tagsSelected = [];
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

  Future<void> createProduct({required String id, String? productImageUrl}) async {
    String? imageFullName;
    if (productImageUrl.isNotNull) {
      final fileBytes = await FolderFileUtils.getFileBytes(File(productImageUrl!));
      final imageName = const Uuid().v1().substring(0, 10);
      final imageSaveModel = (await FolderFileUtils.saveImageInApp(fileBytes, imageName));
      imageFullName = imageSaveModel.fileName;
    }

    if (tempCustomName.isNotEmpty && tempCustomValue.isNotEmpty) {
      customField[tempCustomName] = tempCustomValue;
    }

    final result = await productRepository.create(
      Product(
        id: id,
        storeId: baseCubit.store!.id,
        name: name,
        description: description,
        price: price,
        brand: brand,
        status: status,
        image: productImageUrl,
        imageDetail: productDetalImages,
        imageName: imageFullName,
        quantity: quantity,
        ownerId: baseCubit.user!.id,
        attributes: customField,
        tag: tagsSelected.map((e) => e.id).toList(),
      ),
    );

    log('create product success $result');
    Future.delayed(Duration.zero, () {
      emit(CreateProductSuccess(result));
    });
  }

  setQuantity(String? value) {
    if (value == null) {
      quantity = null;
      return;
    }
    quantity = num.tryParse(value);
  }

  void addCustomField(String tempCustomName, String tempCustomValue) {
    customField[tempCustomName] = tempCustomValue;
    log('[add] $customField');
    clearTempCustomField();
    emit(CreateProductAddCustomField(tempCustomName, tempCustomValue));
  }

  void changedCustomField(String k, v) {
    customField[k] = v;
  }

  void removeCustomField(String k) {
    customField.remove(k);
    emit(CreateProductRemoveCustomField(k));
  }

  setTempCustomName(String? value) {
    tempCustomName = value ?? '';
  }

  setTempCustomValue(String? value) {
    tempCustomValue = value ?? '';
  }

  clearTempCustomField() {
    tempCustomName = '';
    tempCustomValue = '';
  }

  void setTag(Tag? tag) {
    if (tag == null) {
      return;
    }
    tagsSelected.add(tag);
  }
}
