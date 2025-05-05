import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/order/order_repository.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_cubit.dart';
import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_shadow_group_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/column_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/order_item_widget.dart';
import 'package:ez_shop_sync/src/widgets/product_order_total_amount_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_title_bold_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class OrderHistoryDetailPage extends StatefulWidget {
  const OrderHistoryDetailPage({
    super.key,
  });

  @override
  _OrderHistoryDetailState createState() => _OrderHistoryDetailState();
}

class _OrderHistoryDetailState extends State<OrderHistoryDetailPage> {
  late OrderHistoryDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OrderHistoryDetailCubit(
      orderRepository: GetIt.I<OrderRepository>(),
      baseCubit: BlocProvider.of<AppCubit>(context),
    );

    WidgetsBinding.instance.addPostFrameCallback((time) {
      final argruments = ModalRoute.of(context)?.settings.arguments;

      if (argruments is OrderHistoryDetailArgruments) {
        _cubit.initialize(argruments);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<OrderHistoryDetailCubit, OrderHistoryDetailState>(
        listener: (context, state) {},
        child: BlocBuilder<OrderHistoryDetailCubit, OrderHistoryDetailState>(
          builder: (context, state) {
            return BaseScaffolds(
              isInitialLoading: state is OrderHistoryDetailInitialLoading,
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: LocaleKeys.orderDetail.tr(),
                actions: [],
              ).build(),
              body: _buildPage(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, OrderHistoryDetailState state) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        const SizedBox(
          height: 12,
        ),
        buildDetailWidget(),
        ListView.separated(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: _cubit.order?.orderItems.length ?? 0,
          itemBuilder: (context, index) {
            final cartItem = _cubit.order?.orderItems.elementAt(index);

            // log('_cubit.products.length ${_cubit.products.length}, $index, ${product.quantity}');

            return OrderItemWidget(
              order: cartItem,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 16,
            );
          },
        ),
      ],
    );
  }

  Widget buildDetailWidget() {
    return ContainerShadowGroupWidget(
      margin:
          const EdgeInsets.symmetric(horizontal: DimensionsKeys.pagePaddingHzt),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      children: [
        ColumnGapWidget(
          mainAxisSize: MainAxisSize.min,
          gap: 4,
          children: [
            TextTitleBoldValueWidget(
              title: LocaleKeys.orderId.tr(),
              value: _cubit.order?.id ?? '',
            ),
            TextTitleBoldValueWidget(
              title: LocaleKeys.orderDateTime.tr(),
              value: (_cubit.order?.info?.createAt as Timestamp?)
                      ?.toDate()
                      .toDisplayDependLocale(context) ??
                  '--',
            ),
            TextTitleBoldValueWidget(
              title: LocaleKeys.paymentMethod.tr(),
              value: _cubit.order?.geyPaymentType.display ?? '--',
            ),
            Divider(
              color: Colors.grey.shade200,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.orderNumberOfItem.tr(
                      args: [_cubit.order?.numberOfItems.toString() ?? '--']),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                ProductOrderTotalAmountWidget(
                  totalPrice: _cubit.order?.totalPriceIncludeServiceCharge,
                  changeAmount: _cubit.order?.changeAmount,
                  receiveAmount: _cubit.order?.receiveAmount,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
