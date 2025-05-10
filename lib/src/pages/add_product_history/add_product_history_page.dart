import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/add_product_history/add_product_history_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_product_history/add_product_history_state.dart';
import 'package:ez_shop_sync/src/pages/add_product_history/widgets/add_product_history_item_widget.dart';
import 'package:ez_shop_sync/src/pages/add_product_history_detail/add_product_history_detail_router.dart';
import 'package:ez_shop_sync/src/pages/add_product_history_detail/add_product_history_detail_state.dart';
import 'package:ez_shop_sync/src/widgets/app_pagination_loading_widget.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/empty_data_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AddProductHistoryPage extends StatefulWidget {
  const AddProductHistoryPage({super.key});

  @override
  _AddProductHistoryState createState() => _AddProductHistoryState();
}

class _AddProductHistoryState extends State<AddProductHistoryPage> {
  final _cubit = GetIt.I<AddProductHistoryCubit>();
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<AddProductHistoryCubit, AddProductHistoryState>(
      bloc: _cubit,
      listener: (context, state) {},
      child: BlocBuilder<AddProductHistoryCubit, AddProductHistoryState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            enableAppModeDisplay: true,
            isInitialLoading: state is AddProductHistoryInitialLoading,
            isLoading: state is AddProductHistoryLoading,
            appBar:
                AppbarWidget(
                  context,
                  centerTitle: false,
                  title: LocaleKeys.addProductHistory_title.tr(),
                  actions: [],
                ).build(),
            body:
                _cubit.orderItems.isEmpty
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
    );
  }

  Widget _buildPage(BuildContext context, AddProductHistoryState state) {
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
                final model = _cubit.orderItems.elementAt(index);

                return InkWell(
                  child: AddProductHistoryItemWidget(addProduct: model),
                  onTap: () {
                    AddProductHistoryDetailRouter(
                      context,
                    ).navigate(argruments: AddProductHistoryDetailArgruments(addProduct: model));
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 16);
              },
            ),
          ),
        ),
        if (state is AddProductHistoryLoadMore)
          Lottie.asset('assets/animations/load_more.json', width: double.infinity, height: 50),
      ],
    );
  }
}
