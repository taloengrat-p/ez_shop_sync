import 'dart:developer';
import 'dart:io';

import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_request.dart';
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

  String tempCustomName = '';
  String tempCustomValue = '';

  String tempPriceCategoryName = '';
  String tempPriceCategoryValue = '';

  Store? get currentStore => baseCubit.store;
  User? get currentUser => baseCubit.user;

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
      id: '',
      name: '',
      storeId: currentStore!.id,
      status: ProductStatus.undefined,
      ownerId: currentStore!.ownerId,
      attributes: {},
      priceCategories: {},
    );
  }

  setName(String? value) {
    _productEditor?.name = value ?? '';
  }

  setDescription(String? value) {
    _productEditor?.description = value ?? '';
  }

  setCategory(List<Category>? list) {
    if (list?.isEmpty ?? true) {
      _productEditor?.category = null;
    } else {
      _productEditor?.category = list?.first.id;
    }
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

  void addCustomField(String key, String value) {
    _productEditor?.attributes?[key] = value;
    clearTempCustomField();
    emit(CreateProductAddCustomField(key, value));
  }

  void changedCustomField(String? k, String? v) {
    log('changedCustomField: $k:$v');
    if (k == null) {
      throw ('changedCustomField key is Null');
    }
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

    checkTempCustomFieldRemaining();
    checkTempPriceCategoryRemaining();

    if (_productEditor == null) {
      throw ('createProduct Product editor is Null');
    }

    final result = await productRepository.create(
      CreateProductRequest(
        id: id,
        storeId: currentStore!.id,
        userId: currentUser!.id,
        product: _productEditor!
          ..id = id
          ..imageName = imageFullName
          ..imageDetail = imageDetailFileName,
      ),
    );

    Future.delayed(Duration.zero, () {
      emit(CreateProductSuccess(result));
    });
  }

  checkTempCustomFieldRemaining() {
    if (tempCustomName.isNotEmpty && tempCustomValue.isNotEmpty) {
      _productEditor?.attributes?[tempCustomName] = tempCustomValue;
    }
  }

  Future<void> saveEdit() async {
    if (_productEditor == null) {
      return;
    }

    checkTempCustomFieldRemaining();
    checkTempPriceCategoryRemaining();

    emit(CreateProductLoading());
    await productRepository.update(_productEditor!.id, _productEditor!);
    emit(CreateProductUpdateSuccess());
  }

  void setTempPriceCategoryName(String? value) {
    tempPriceCategoryName = value ?? '';
  }

  void setTempPriceCategoryValue(String? value) {
    tempPriceCategoryValue = value ?? '';
  }

  void changedPriceCategory(String key, String? value) {
    final priceParced = num.tryParse(value ?? '');

    if (priceParced == null) {
      throw ('addPriceCategory priceParced is not Number');
    }

    _productEditor?.priceCategories?[key] = priceParced;
  }

  void removePriceCategory(String key) {
    _productEditor?.priceCategories?.remove(key);
    emit(CreateProductRemoveCustomField(key));
  }

  void addPriceCategory(String key, String value) {
    final priceParced = num.tryParse(value);

    if (priceParced == null) {
      throw ('addPriceCategory priceParced is not Number');
    }

    _productEditor?.priceCategories?[key] = priceParced;
    clearPriceCategoryField();
    emit(CreateProductAddCustomField(key, value));
  }

  clearPriceCategoryField() {
    tempPriceCategoryName = '';
    tempCustomValue = '';
  }

  void checkTempPriceCategoryRemaining() {
    if (tempPriceCategoryName.isNotEmpty && tempPriceCategoryValue.isNotEmpty) {
      num? priceTemp = num.tryParse(tempPriceCategoryValue);

      if (priceTemp != null) {
        _productEditor?.priceCategories?[tempPriceCategoryName] = priceTemp;
      }
    }
  }
}
