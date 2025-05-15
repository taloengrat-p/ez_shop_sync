import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/order_history/order_history_cubit.dart';
import 'package:ez_shop_sync/src/pages/order_history/order_history_state.dart';
import 'package:ez_shop_sync/src/pages/order_history/widgets/order_history_item_widget.dart';
import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_router.dart';
import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_state.dart';
import 'package:ez_shop_sync/src/widgets/app_pagination_loading_widget.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/empty_data_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistoryPage> {
  final _cubit = GetIt.I<OrderHistoryCubit>();
  final _refreshListViewController = RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      _cubit.initialze();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<OrderHistoryCubit, OrderHistoryState>(
      bloc: _cubit,
      listener: (context, state) {
        log('state : $state', name: runtimeType.toString());
      },
      child: BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            isInitialLoading: state is OrderHistoryInitialLoading,
            isLoading: state is OrderHistoryLoading,
            appBar: AppbarWidget(context, centerTitle: false, title: LocaleKeys.orderHistory.tr(), actions: []).build(),
            body:
                _cubit.orderItems.isEmpty
                    ? Center(
                      child: EmptyDataWidget(
                        height: size.height * 0.45,
                        width: 200,
                        message: LocaleKeys.orderHistoryEmpty.tr(),
                        onRefresh: onRefresh,
                      ),
                    )
                    : _buildPage(context, state),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, OrderHistoryState state) {
    return Column(
      children: [
        Expanded(
          child: AppPaginationLoadingWidget(
            controller: _refreshListViewController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: onRefresh,
            onLoading: onLoadMore,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: _cubit.orderItems.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemBuilder: (context, index) {
                final model = _cubit.orderItems[index];

                return InkWell(
                  child: OrderHistoryItemWidget(key: ValueKey('order-item-${model.id}'), order: model),
                  onTap: () {
                    OrderHistoryDetailRouter(
                      context,
                    ).navigate(argruments: OrderHistoryDetailArgruments(productOrder: model));
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 16);
              },
            ),
          ),
        ),
        // if (state is OrderHistoryLoadMore)
        //   Lottie.asset(
        //     'assets/animations/load_more.json',
        //     width: double.infinity,
        //     height: 50,
        //   )
      ],
    );
  }

  Future<void> onRefresh() async {
    _refreshListViewController.requestRefresh();
    await _cubit.loadMoreItems(refresh: true);
    _refreshListViewController.refreshCompleted();
  }

  Future<void> onLoadMore() async {
    _refreshListViewController.requestLoading();
    await _cubit.loadMoreItems(refresh: false);
    _refreshListViewController.loadComplete();
  }
}
