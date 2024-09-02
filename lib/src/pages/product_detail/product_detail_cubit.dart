import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  Product? product;
  ProductRepository productRepository;
  BaseCubit baseCubit;
  List<Tag> get tags => baseCubit.tags.where((e) => product?.tag?.contains(e.id) ?? false).toList();
  ProductDetailCubit({
    required this.productRepository,
    required this.baseCubit,
  }) : super(ProductDetailInitial());

  List<String> get imageMerged {
    List<String> images = [];

    if (product?.image?.isNotNull ?? false) {
      images.add(product!.image!);
    }

    if (product?.imageDetail?.isNotNull ?? false) {
      images.addAll(product!.imageDetail!);
    }

    return images;
  }

  setArgrument(Product value) {
    product = value;
    emit(ProductDetailRefresh(DateTime.now()));
  }

  void deleteProduct() {
    if (product?.id.isNull ?? true) {
      return;
    }
    emit(ProductDetailLoading());

    productRepository.delete(product!.id!);

    emit(ProductDetailDelete());
  }
}
