import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_state.dart';
import 'package:ez_shop_sync/src/routes/base_router.dart';
import 'package:ez_shop_sync/src/routes/routes.dart';

class OrderHistoryDetailRouter extends BaseRouter {
  OrderHistoryDetailRouter(super.context) : super(name: Routes.ROUTE_ORDERHISTORYDETAIL);

  Future navigateFromOrderComplete({required OrderHistoryDetailArgruments argruments}) async {
    return await replace(argruments: argruments);
  }
}
