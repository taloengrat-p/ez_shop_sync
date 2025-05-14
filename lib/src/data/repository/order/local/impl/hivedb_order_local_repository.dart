import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/dto/request/base_repo_request.dart';
import 'package:ez_shop_sync/src/data/repository/base_hive_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/local/i_order_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IOrderLocalRepository, env: [Flavor.DEV, Flavor.STG, Flavor.PROD])
class HivedbOrderLocalRepository extends BaseHiveRepository<String, ProductOrder> implements IOrderLocalRepository {
  HivedbOrderLocalRepository() : super(boxName: HiveBoxConstance.order);

  @override
  List<ProductOrder> getAllRangeByDateTime(BaseRepoRequest<OrderGetByDateRangeRequest> request) {
    return super.getAllRange(request.data.start.millisecondsSinceEpoch, request.data.end.millisecondsSinceEpoch);
  }
}
