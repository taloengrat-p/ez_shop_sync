import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_cubit.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_state.dart';
import 'package:ez_shop_sync/src/pages/product_detail/widgets/product_history_item_widget.dart';
import 'package:ez_shop_sync/src/widgets/empty_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailTabHistory extends StatefulWidget {
  const ProductDetailTabHistory({super.key});

  @override
  State<ProductDetailTabHistory> createState() => _ProductDetailTabHistoryState();
}

class _ProductDetailTabHistoryState extends State<ProductDetailTabHistory> {
  late ProductDetailCubit productDetailCubit;
  @override
  void initState() {
    super.initState();
    productDetailCubit = BlocProvider.of<ProductDetailCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailCubit, ProductDetailState>(
      listener: (context, state) {},
      builder: (context, state) {
        return (productDetailCubit.productHistory?.isEmpty ?? true)
            ? EmptyDataWidget(
                message: LocaleKeys.productHistory_productHistoryEmpty.tr(),
              )
            : ListView.separated(
                padding: const EdgeInsets.only(top: 8),
                itemCount: productDetailCubit.productHistory?.length ?? 0,
                itemBuilder: (context, index) {
                  final history = productDetailCubit.productHistory?[index];
                  return ProductHistoryItemWidget(history: history);
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.grey,
                  );
                },
              );
      },
    );
  }
}
