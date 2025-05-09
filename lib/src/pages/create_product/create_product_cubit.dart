import 'dart:developer';
import 'dart:io';

import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_type.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_product_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/product_request/update_product_image_request.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_state.dart';
import 'package:ez_shop_sync/src/utils/folder_file_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Injectable()
class CreateProductCubit extends Cubit<CreateProductState> {
  final ProductRepository productRepository;
  final AppCubit appCubit;
  //
  ScreenMode _screenMode = ScreenMode.create;

  Product? _productOriginal;
  Product? _productEditor;

  String tempCustomName = '';
  String tempCustomValue = '';

  String tempPriceCategoryName = '';
  String tempPriceCategoryValue = '';

  // List<ProductType> productTypeList = [];

  Store? get currentStore => appCubit.store;
  User? get currentUser => appCubit.user;

  List<Tag> get tagsModelSelected =>
      _productEditor?.tag?.map((e) => tags.where((tag) => tag.id == e).first).toList() ?? [];

  List<Category> get categories => appCubit.categories;
  List<Tag> get tags => appCubit.tags;
  ScreenMode get screenMode => _screenMode;
  Product? get productEditor => _productEditor;
  Product? get productOriginal => _productOriginal;

  CreateProductCubit({required this.productRepository, required this.appCubit}) : super(CreateProductInitial()) {
    _productEditor = Product(
      id: '',
      name: '',
      storeId: currentStore?.id ?? '',
      status: ProductStatus.undefined,
      ownerId: currentStore?.ownerId ?? '',
      attributes: {},
      productTypeList: [],
    );
  }

  File? _productImage;
  File? get productImageFile => _productImage;

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

  setProductImages(List<String>? images) {
    _productEditor?.imagesUrl = images;
    emit(CreateProductUpdateImages(_productEditor?.imagesUrl));
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
    _productEditor?.tag = tags.map((e) => e.id.toString()).toList();
  }

  void refresh() {
    emit(CreateProductRefresh(DateTime.now()));
  }

  void setScreenMode(ScreenMode mode) {
    _screenMode = mode;

    emit(ProductScreenModeChange(_screenMode));
  }

  void setArgruments(ProductEditArgrument args) {
    _productOriginal = args.product?.copyWith();
    _productEditor = args.product?.copyWith();

    log('_productEditor $_productEditor');
    emit(CreateProductInitial());
    setScreenMode(ScreenMode.edit);
  }

  checkTempCustomFieldRemaining() {
    if (tempCustomName.isNotEmpty && tempCustomValue.isNotEmpty) {
      _productEditor?.attributes?[tempCustomName] = tempCustomValue;
    }
  }

  void setTempPriceCategoryName(String? value) {
    tempPriceCategoryName = value ?? '';
  }

  void setTempPriceCategoryValue(String? value) {
    tempPriceCategoryValue = value ?? '';
  }

  // void changedPriceCategory(String key, String? value) {
  //   final priceParced = num.tryParse(value ?? '');

  //   if (priceParced == null) {
  //     throw ('addPriceCategory priceParced is not Number');
  //   }

  //   _productEditor?.priceCategories?[key] = priceParced;
  // }

  // void removePriceCategory(String key) {
  //   _productEditor?.priceCategories?.remove(key);
  //   emit(CreateProductRemoveCustomField(key));
  // }

  // void addPriceCategory(String key, String value) {
  //   final priceParced = num.tryParse(value);

  //   if (priceParced == null) {
  //     throw ('addPriceCategory priceParced is not Number');
  //   }

  //   _productEditor?.priceCategories?[key] = priceParced;
  //   clearPriceCategoryField();
  //   emit(CreateProductAddCustomField(key, value));
  // }

  clearPriceCategoryField() {
    tempPriceCategoryName = '';
    tempCustomValue = '';
  }

  void checkTempPriceCategoryRemaining() {
    if (tempPriceCategoryName.isNotEmpty && tempPriceCategoryValue.isNotEmpty) {
      num? priceTemp = num.tryParse(tempPriceCategoryValue);

      if (priceTemp != null) {
        _productEditor?.productTypeList?.add(ProductType(image: '', name: tempPriceCategoryName, price: priceTemp));
      }
    }
  }

  void addProductType() {
    _productEditor?.productTypeList?.add(ProductType(image: null));
    emit(CreateProductRefresh(DateTime.now()));
  }

  void updateProductType(int index, ProductType productType) {
    _productEditor?.productTypeList?[index] = productType;
    emit(CreateProductUpdateProductType(productType: productType));
  }

  void setProductImage(File? file) {
    log('setProductImage');
    _productImage = file;

    emit(CreateProductRefresh(DateTime.now()));
  }

  void onDeleteProductType(int index) {
    _productEditor?.productTypeList?.removeAt(index);
    emit(CreateProductRefresh(DateTime.now()));
  }

  void submitCreate() async {
    emit(CreateProductLoading());
    List<String> imageDetailFileName = [];

    if (_productEditor?.imagesUrl?.isNotEmpty ?? false) {
      for (var element in _productEditor!.imagesUrl!) {
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

    final result = await productRepository.createProduct(
      BaseRepoRequest(
        storeId: currentStore!.id,
        userId: currentUser?.uid ?? '',
        data: CreateProductRequest(
          product:
              _productEditor!
                ..productTypeList = _productEditor!.productTypeList?.map((e) => e..id = const Uuid().v4()).toList(),
          image: productImageFile,
        ),
      ),
    );

    result.when(
      success: (response) {
        emit(CreateProductSuccess(response));
      },
    );
  }

  Future<void> saveEdit() async {
    if (_productEditor == null) {
      return;
    }

    checkTempCustomFieldRemaining();
    checkTempPriceCategoryRemaining();

    emit(CreateProductLoading());
    final result = await productRepository.updateProduct(
      BaseRepoRequest(
        storeId: appCubit.storeId ?? '',
        userId: appCubit.userId ?? '',
        data: UpdateProductImageRequest(
          imageRefUrl: productOriginal!.imageUrl!,
          updatedImage: productImageFile,
          product:
              _productEditor!
                ..productTypeList =
                    _productEditor!.productTypeList?.map((e) {
                      e.id ??= const Uuid().v4();
                      return e;
                    }).toList(),
        ),
      ),
    );

    result.when(
      success: (success) {
        emit(CreateProductUpdateSuccess(_productEditor));
      },
      failure: (error, {errorType}) {
        emit(CreateProductUpdateFailure());
      },
    );
  }
}
