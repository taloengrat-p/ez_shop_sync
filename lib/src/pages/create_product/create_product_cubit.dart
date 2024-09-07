import 'dart:io';

import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:ez_shop_sync/src/utils/folder_file_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  ProductRepository productRepository;
  BaseCubit baseCubit;
  //
  ScreenMode _screenMode = ScreenMode.delete;
  String name = '';
  String description = '';
  String? category;
  String brand = '';
  ProductStatus status = ProductStatus.active;
  String? productImage;
  List<String>? productDetalImages;
  num? price;
  num? quantity;
  Map<String, dynamic> customField = {};

  String tempCustomName = '';
  String tempCustomValue = '';
  List<String> tagsSelected = [];

  List<Tag> get tagsModelSelected => tagsSelected
      .map(
        (e) => tags.where((tag) => tag.id == e).first,
      )
      .toList();

  List<Category> get categories => baseCubit.categories;
  List<Tag> get tags => baseCubit.tags;
  ScreenMode get screenMode => _screenMode;

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

  setCategory(List<Category>? list) {
    if (list?.isEmpty ?? true) {
      category = null;
    } else {
      category = list?.first.id;
    }
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

  void submit() async {
    emit(CreateProductLoading());

    final productId = const Uuid().v1();

    createProduct(id: productId, productImageUrl: productImage);
  }

  Future<void> createProduct({required String id, String? productImageUrl}) async {
    emit(CreateProductLoading());
    String? imageFullName;
    List<String> imageDetailFileName = [];
    if (productImageUrl.isNotNull) {
      final fileBytes = await FolderFileUtils.getFileBytes(File(productImageUrl!));
      final imageName = const Uuid().v1().substring(0, 10);
      final imageSaveModel = (await FolderFileUtils.saveImageInApp(fileBytes, imageName));
      imageFullName = imageSaveModel.fileName;
    }

    if (productDetalImages?.isNotEmpty ?? false) {
      for (var element in productDetalImages!) {
        final fileBytes = await FolderFileUtils.getFileBytes(File(element));
        final imageName = const Uuid().v1().substring(0, 10);
        final imageSaveModel = (await FolderFileUtils.saveImageInApp(fileBytes, imageName));
        imageDetailFileName.add(imageSaveModel.fileName);
      }
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
        imageDetail: imageDetailFileName,
        imageName: imageFullName,
        quantity: quantity,
        ownerId: baseCubit.user!.id,
        attributes: customField,
        category: category,
        tag: tagsSelected,
      ),
    );

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

  setTags(List<Tag> tags) {
    tagsSelected = tags
        .map(
          (e) => e.id,
        )
        .toList();
  }

  void refresh() {
    emit(CreateProductRefresh(DateTime.now()));
  }

  void setScreenMode(ScreenMode mode) {
    _screenMode = mode;

    emit(ProductScreenModeChange(_screenMode));
  }

  void setArgruments(ProductEditArgrument args) {
    final productArgs = args.product;
    name = productArgs.name;
    description = productArgs.description ?? '';
    price = productArgs.price;
    quantity = productArgs.quantity;
    category = productArgs.category ?? '';
    tagsSelected = productArgs.tag ?? [];
    customField = productArgs.attributes ?? {};
    emit(CreateProductUpdateCategorySelect(category ?? ''));
    emit(CreateProductUpdateTagsSelect(tagsSelected));
    setScreenMode(ScreenMode.edit);
  }
}
