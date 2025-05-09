// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/add_product_decrease_qty_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/add_product_increase_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/add_product_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/add_product_request/delete_item_form_cart_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/add_product/local/i_add_product_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/add_product/server/i_add_product_server_repository.dart';
import 'package:ez_shop_sync/src/data/repository/i_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:injectable/injectable.dart';

@Singleton()
@Injectable()
class AddProductRepository extends IRepository<AddProduct> {
  final IAddProductLocalRepository addProductLocalRepository;
  final IAddProductServerRepository addProductServerRepository;

  AddProductRepository({
    required this.addProductLocalRepository,
    required this.addProductServerRepository,
    required super.navigationService,
  }) : super(AppMode.local);

  @override
  Future<ApiResult<AddProduct>> create(BaseRepoRequest<AddProduct> request) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.createIfNotExist(request);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> delete(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.delete(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAllByIds(List<String> ids) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.deleteAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult<List<AddProduct>>> getAddProductByUserIdWithCurrentStore(List<String> carts) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.getAddProductByUserIdWithCurrentStore(carts);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<AddProduct>> update(BaseRepoRequest<AddProduct> request) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.update(request);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult<AddProduct>> deleteItemByIdFromCart(BaseRepoRequest<DeleteItemFormCartRequest> request) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.deleteItemByIdFromCart(request);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult<AddProduct>> addProduct(BaseRepoRequest<AddProductRequest> request) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.addProduct(request);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult> increaseQty(BaseRepoRequest<AddProductIncreaseRequest> request) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.increaseQty(request);
    } else {
      throw UnimplementedError();
    }
  }

  Future<ApiResult> decreaseQty(BaseRepoRequest<AddProductDecreaseQtyRequest> request) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.decreaseQty(request);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<AddProduct>>> getAll() async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.getAll();
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<List<AddProduct>>> getAllByIds(List<String> ids) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.getAllByIds(ids);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult<AddProduct>> getById(BaseRepoRequest<String> request) async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.getById(request.data);
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<ApiResult> deleteAll() async {
    if (appMode == AppMode.local) {
      return await addProductLocalRepository.deleteAll();
    } else {
      throw UnimplementedError();
    }
  }
}
