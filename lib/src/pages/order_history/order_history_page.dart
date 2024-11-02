import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/pages/order_history/order_history_cubit.dart';
import 'package:ez_shop_sync/src/pages/order_history/order_history_state.dart';
import 'package:ez_shop_sync/src/pages/order_history/widgets/order_history_item_widget.dart';
import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_router.dart';
import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_state.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/empty_data_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({
    super.key,
  });

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistoryPage> {
  late OrderHistoryCubit _cubit;
  final _listViewController = ScrollController();

  @override
  void initState() {
    super.initState();
    _listViewController.addListener(() => _onScroll(_listViewController));
    _cubit = OrderHistoryCubit(
      orderRepository: GetIt.I<OrderRepository>(),
    );

    WidgetsBinding.instance.addPostFrameCallback((time) {
      _cubit.initialze();
    });
  }

  @override
  void dispose() {
    _listViewController.dispose();
    super.dispose();
  }

  void _onScroll(ScrollController controller) {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      _cubit.loadMoreItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<OrderHistoryCubit, OrderHistoryState>(
        listener: (context, state) {},
        child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
          builder: (context, state) {
            return BaseScaffolds(
              isLoading: state is OrderHistoryLoading,
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: LocaleKeys.orderHistory.tr(),
                actions: [],
              ).build(),
              body: _cubit.orderItems.isEmpty
                  ? Center(
                      child: EmptyDataWidget(
                        height: size.height * 0.45,
                        width: 200,
                        message: LocaleKeys.orderHistoryEmpty.tr(),
                      ),
                    )
                  : _buildPage(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, OrderHistoryState state) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            controller: _listViewController,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: _cubit.orderItems.length,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemBuilder: (context, index) {
              final model = _cubit.orderItems[index];

              return InkWell(
                child: OrderHistoryItemWidget(
                  order: model,
                ),
                onTap: () {
                  OrderHistoryDetailRouter(context).navigate(
                    argruments: OrderHistoryDetailArgruments(productOrder: model),
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 16,
              );
            },
          ),
        ),
        if (state is OrderHistoryLoadMore)
          Lottie.asset(
            'assets/animations/load_more.json',
            width: double.infinity,
            height: 50,
          )
      ],
    );
  }
}
