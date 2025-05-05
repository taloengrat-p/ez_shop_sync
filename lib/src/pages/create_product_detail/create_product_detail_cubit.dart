import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/product_type.dart';
import 'package:ez_shop_sync/src/pages/create_product_detail/create_product_detail_state.dart';
import 'package:ez_shop_sync/src/pages/create_product_detail/models/product_category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class CreateProductDetailCubit extends Cubit<CreateProductDetailState> {
  CreateProductDetailCubit() : super(CreateProductDetailInitial());

  final List<ProductCategory> _items = [];
  List<ProductCategory> get items => _items;
  ProductType? product;

  String? productName;
  String? productDesc;
  num? productPrice;
  num? productQuantity;
  String? productImage;

  void addCategory() {
    _items.add(ProductCategory());
    emit(CreateProductDetailRefresh(DateTime.now()));
  }

  void setArgruments(ProductType argruments) {
    product = argruments;

    log('setArgruments $argruments');
    productName = product?.name;
    productPrice = product?.price;
    productQuantity = product?.quantity;
    productImage = product?.image;
    productDesc = product?.desc;
    emit(CreateProductDetailInitial());
  }

  void setName(String? name) {
    productName = name;
  }

  void setPrice(num? price) {
    productPrice = price;
  }

  void setQuantity(num? quantity) {
    productQuantity = quantity;
  }

  void setImage(String? value) {
    productImage = value;
    emit(CreateProductDetailUpdateImage(productImage));
  }

  void setDesc(String desc) {
    productDesc = desc;
  }
}
