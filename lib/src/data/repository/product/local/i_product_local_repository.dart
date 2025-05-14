import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/api_result.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';

class IProductLocalRepository extends BaseHiveRepository<String, Product> {
  IProductLocalRepository() : super(boxName: HiveBoxConstance.product);

  Future<ApiResult<List<Product>?>> getAllByStoreAndBranchId(String id) async {
    final allResult = await getAll();

    allResult.when(
      success: (response) {
        return Future.value(ApiResult(response: response.where((e) => e.storeId == id).toList()));
      },
      failure: (error) {
        return Future.value(ApiResult(error: error));
      },
    );
    return Future.value(ApiResult(error: 'getAllByStoreId failure'));
  }
}
