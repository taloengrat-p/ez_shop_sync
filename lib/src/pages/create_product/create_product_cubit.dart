import 'dart:io';

import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
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
  ScreenMode _screenMode = ScreenMode.create;

  Product? _productOriginal;
  Product? _productEditor;
  // String name = '';
  // String description = '';
  // String? category;
  // String brand = '';
  // ProductStatus status = ProductStatus.active;
  // String? productImage;
  // List<String>? productDetalImages;
  // num? price;
  // num? quantity;
  // Map<String, dynamic> customField = {};

  String tempCustomName = '';
  String tempCustomValue = '';
  // List<String> tagsSelected = [];
  // Product? productArgs;
  Store? get currentStore => baseCubit.store;
  List<Tag> get tagsModelSelected =>
      _productEditor?.tag
          ?.map(
            (e) => tags.where((tag) => tag.id == e).first,
          )
          .toList() ??
      [];

  List<Category> get categories => baseCubit.categories;
  List<Tag> get tags => baseCubit.tags;
  ScreenMode get screenMode => _screenMode;
  Product? get productEditor => _productEditor;
  Product? get productOriginal => _productOriginal;

  CreateProductCubit({
    required this.productRepository,
    required this.baseCubit,
  }) : super(CreateProductInitial()) {
    _productEditor = Product(
        id: '', name: '', storeId: currentStore!.id, status: ProductStatus.undefined, ownerId: currentStore!.ownerId);
  }

  setName(String? value) {
    _productEditor?.name = value ?? '';
  }

  setDescription(String? value) {
    _productEditor?.description = value ?? '';
  }

  setPrice(String? value) {
    try {
      _productEditor?.price = num.parse(value!);
    } catch (e) {}
  }

  setCategory(List<Category>? list) {
    if (list?.isEmpty ?? true) {
      _productEditor?.category = null;
    } else {
      _productEditor?.category = list?.first.id;
    }
  }

  setBrand(String? value) {
    _productEditor?.brand = value ?? '';
  }

  setStatus(String? value) {
    _productEditor?.status = ProductStatus.fromString(value);
  }

  setProductDetailImageSelect(List<File>? values) {
    _productEditor?.imageDetail = values?.map((e) => e.path).toList();
  }

  setProductImageSelect(File? value) {
    _productEditor?.image = value?.path;
  }

  void submit() async {
    emit(CreateProductLoading());

    final productId = const Uuid().v1();

    createProduct(id: productId);
  }

  setQuantity(String? value) {
    if (value == null) {
      _productEditor?.quantity = null;
      return;
    }
    _productEditor?.quantity = num.tryParse(value);
  }

  void addCustomField(String tempCustomName, String tempCustomValue) {
    _productEditor?.attributes?[tempCustomName] = tempCustomValue;
    clearTempCustomField();
    emit(CreateProductAddCustomField(tempCustomName, tempCustomValue));
  }

  void changedCustomField(String k, v) {
    _productEditor?.attributes?[k] = v;
  }

  void removeCustomField(String k) {
    _productEditor?.attributes?.remove(k);
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
    _productEditor?.tag = tags
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
    _productEditor = args.product;

    setScreenMode(ScreenMode.edit);
  }

  Future<void> createProduct({required String id}) async {
    emit(CreateProductLoading());
    String? imageFullName;
    List<String> imageDetailFileName = [];
    if (_productEditor?.image.isNotNull ?? false) {
      final fileBytes = await FolderFileUtils.getFileBytes(File(_productEditor!.image!));
      final imageName = const Uuid().v1().substring(0, 10);
      final imageSaveModel = (await FolderFileUtils.saveImageInApp(fileBytes, imageName));
      imageFullName = imageSaveModel.fileName;
    }

    if (_productEditor?.imageDetail?.isNotEmpty ?? false) {
      for (var element in _productEditor!.imageDetail!) {
        final fileBytes = await FolderFileUtils.getFileBytes(File(element));
        final imageName = const Uuid().v1().substring(0, 10);
        final imageSaveModel = (await FolderFileUtils.saveImageInApp(fileBytes, imageName));
        imageDetailFileName.add(imageSaveModel.fileName);
      }
    }

    if (tempCustomName.isNotEmpty && tempCustomValue.isNotEmpty) {
      _productEditor?.attributes?[tempCustomName] = tempCustomValue;
    }

    if (_productEditor == null) {
      return;
    }

    final result = await productRepository.create(
      _productEditor!
        ..id = id
        ..imageName = imageFullName
        ..imageDetail = imageDetailFileName,
    );

    Future.delayed(Duration.zero, () {
      emit(CreateProductSuccess(result));
    });
  }

  Future<void> saveEdit() async {
    if (_productEditor == null) {
      return;
    }

    emit(CreateProductLoading());
    await productRepository.update(_productEditor!.id, _productEditor!);
    emit(CreateProductUpdateSuccess());
  }
}
