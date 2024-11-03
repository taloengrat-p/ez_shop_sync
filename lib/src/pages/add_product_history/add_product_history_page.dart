import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/add_product_history/add_product_history_repository.dart';
import 'package:ez_shop_sync/src/pages/add_product_history/add_product_history_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_product_history/add_product_history_state.dart';
import 'package:ez_shop_sync/src/pages/add_product_history/widgets/add_product_history_item_widget.dart';
import 'package:ez_shop_sync/src/pages/add_product_history_detail/add_product_history_detail_router.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/empty_data_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

class AddProductHistoryPage extends StatefulWidget {
  const AddProductHistoryPage({
    super.key,
  });

  @override
  _AddProductHistoryState createState() => _AddProductHistoryState();
}

class _AddProductHistoryState extends State<AddProductHistoryPage> {
  late AddProductHistoryCubit _cubit;
  final _listViewController = ScrollController();

  @override
  void initState() {
    super.initState();
    _listViewController.addListener(() => _onScroll(_listViewController));
    _cubit = AddProductHistoryCubit(
      addProductHistoryRepository: GetIt.I<AddProductHistoryRepository>(),
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
      child: BlocListener<AddProductHistoryCubit, AddProductHistoryState>(
        listener: (context, state) {},
        child: BlocBuilder<AddProductHistoryCubit, AddProductHistoryState>(
          builder: (context, state) {
            return BaseScaffolds(
              isLoading: state is AddProductHistoryLoading,
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

  Widget _buildPage(BuildContext context, AddProductHistoryState state) {
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
                child: AddProductHistoryItemWidget(
                  addProduct: model,
                ),
                onTap: () {
                  AddProductHistoryDetailRouter(context).navigate();
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
        if (state is AddProductHistoryLoadMore)
          Lottie.asset(
            'assets/animations/load_more.json',
            width: double.infinity,
            height: 50,
          )
      ],
    );
  }
}
