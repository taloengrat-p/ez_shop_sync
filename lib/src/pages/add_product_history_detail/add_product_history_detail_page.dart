import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/pages/add_product_history_detail/add_product_history_detail_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_product_history_detail/add_product_history_detail_state.dart';
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

class AddProductHistoryDetailPage extends StatefulWidget {
  const AddProductHistoryDetailPage({super.key});

  @override
  _AddProductHistoryDetailState createState() => _AddProductHistoryDetailState();
}

class _AddProductHistoryDetailState extends State<AddProductHistoryDetailPage> {
  final _cubit = GetIt.I<AddProductHistoryDetailCubit>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      final argruments = ModalRoute.of(context)?.settings.arguments;

      if (argruments is AddProductHistoryDetailArgruments) {
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
    return BlocListener<AddProductHistoryDetailCubit, AddProductHistoryDetailState>(
      bloc: _cubit,
      listener: (context, state) {},
      child: BlocBuilder<AddProductHistoryDetailCubit, AddProductHistoryDetailState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            isInitialLoading: state is AddProductHistoryDetailInitialLoading,
            appBar:
                AppbarWidget(
                  context,
                  centerTitle: false,
                  title: LocaleKeys.addProductHistoryDetail_title.tr(),
                  actions: [],
                ).build(),
            body: _buildPage(context, state),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, AddProductHistoryDetailState state) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        const SizedBox(height: 12),
        buildDetailWidget(),
        ListView.separated(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: _cubit.order?.addProductItems.length ?? 0,
          itemBuilder: (context, index) {
            final cartItem = _cubit.order?.addProductItems.elementAt(index);

            return OrderItemWidget(
              key: ValueKey('cart-item-${cartItem?.id}'),
              order: cartItem,
              type: TransactionMethodType.addProduct,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 16);
          },
        ),
      ],
    );
  }

  Widget buildDetailWidget() {
    return ContainerShadowGroupWidget(
      margin: const EdgeInsets.symmetric(horizontal: DimensionsKeys.pagePaddingHzt),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      children: [
        ColumnGapWidget(
          mainAxisSize: MainAxisSize.min,
          gap: 4,
          children: [
            TextTitleBoldValueWidget(title: LocaleKeys.orderId.tr(), value: _cubit.order?.id ?? ''),
            TextTitleBoldValueWidget(
              title: LocaleKeys.orderDateTime.tr(),
              value: (_cubit.order?.info?.createAt as Timestamp?)?.toDate().toDisplayDependLocale(context) ?? '--',
            ),
            TextTitleBoldValueWidget(
              title: LocaleKeys.paymentMethod.tr(),
              value: _cubit.order?.getPaymentType.display ?? '--',
            ),
            Divider(color: Colors.grey.shade200),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.orderNumberOfItem.tr(args: [_cubit.order?.numberOfItems.toString() ?? '--']),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                ProductOrderTotalAmountWidget(
                  totalPrice: _cubit.order?.amountCost,
                  // changeAmount: _cubit.order?.changeAmount,
                  // receiveAmount: _cubit.order?.receiveAmount,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
