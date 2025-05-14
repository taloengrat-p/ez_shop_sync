import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/models/enums/cart_error_type.enum.dart';
import 'package:ez_shop_sync/src/pages/add_product/add_product_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_product/add_product_state.dart';
import 'package:ez_shop_sync/src/pages/add_product/widget/add_product_item_widget.dart';
import 'package:ez_shop_sync/src/pages/main/main_router.dart';
import 'package:ez_shop_sync/src/pages/main/main_state.dart';
import 'package:ez_shop_sync/src/pages/order_complete/order_complete_router.dart';
import 'package:ez_shop_sync/src/pages/order_complete/order_complete_state.dart';
import 'package:ez_shop_sync/src/routes/routes.dart';
import 'package:ez_shop_sync/src/utils/dialog_utils.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_shadow_group_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/column_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/row_between_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProductPage> {
  final _cubit = GetIt.I<AddProductCubit>();
  final _listViewController = ScrollController();
  final _scrollViewController = ScrollController();
  bool _isBottomScroll = false;
  final bool _canScroll = false;

  void _onScroll() {
    final pixel = _listViewController.position.pixels;
    final maxScroll = _listViewController.position.maxScrollExtent;

    bool isBottom = pixel >= maxScroll;

    if (isBottom != _isBottomScroll) {
      setState(() {
        _isBottomScroll = isBottom;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      _cubit.initial();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildPage(BuildContext context, AddProductState state) {
    return Stack(
      children: [
        buildProductItems(),
        AnimatedOpacity(
          opacity: _isBottomScroll || _canScroll == false || _cubit.addProductOrderItems.length <= 2 ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.5),
                      Colors.white.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProductItems() {
    return ListView(
      controller: _listViewController,
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        ListView.separated(
          controller: _scrollViewController,
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: _cubit.addProductOrderItems.length,
          itemBuilder: (context, index) {
            bool hasInsufficientError = false;
            bool hasInvalid = false;

            final orderItem = _cubit.addProductOrderItems.elementAtOrNull(index);
            try {
              final productStockItem = _cubit.productInStock.firstWhere((e) => e.id == orderItem?.product?.id);

              hasInsufficientError =
                  (productStockItem.productTypeList
                          ?.firstWhere((e) => e.id == orderItem?.product?.priceSelected)
                          .quantity ??
                      0) <
                  (orderItem?.product?.quantity ?? 0);
            } catch (e) {
              hasInvalid = true;
            }

            return AddProductItemWidget(
              errorMessageType:
                  hasInvalid
                      ? CartErrorType.invalid
                      : hasInsufficientError
                      ? CartErrorType.insufficient
                      : null,
              orderItem: orderItem,
              onIncreaseQty: () {
                _cubit.increaseProductQtyByIndex(index);
              },
              onDecreaseQty: () {
                _cubit.decreaseProductQtyByIndex(index);
              },
              onDelete: () async {
                final result = await DialogUtils.showConfirmDelete(context);

                if (result == ConfirmDialogResult.ok) {
                  _cubit.deleteItemFromCart(orderItem?.id);
                }
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 16);
          },
        ),
        buildAddProductInfo(),
      ],
    );
  }

  Widget buildPriceLayout({required Widget child}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: child,
    );
  }

  Widget buildAddProductInfo() {
    return ContainerShadowGroupWidget(
      margin: const EdgeInsets.symmetric(horizontal: DimensionsKeys.pagePaddingHzt),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      color: Colors.white,
      title: LocaleKeys.addProductInfo.tr(),
      children: [
        ColumnGapWidget(
          mainAxisSize: MainAxisSize.min,
          gap: 4,
          children: [
            RowBetweenWidget(title: Text(LocaleKeys.items.tr()), value: Text(_cubit.totalItems)),
            Divider(color: Colors.grey.shade200),
            RowBetweenWidget(
              title: Text(LocaleKeys.totalAmount.tr()),
              value: Text(
                _cubit.totalPriceDisplay,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddProductCubit, AddProductState>(
      bloc: _cubit,
      listener: (context, state) {
        log('state : $state', name: runtimeType.toString());
        if (state is AddProductRemoveItemSuccess) {
          // checkCanScroll();
        } else if (state is AddProductSuccess) {
          OrderCompleteRouter(context).replace(
            argruments: OrderCompleteArgrument(
              title: LocaleKeys.addProductCompleteTitle.tr(),
              addProductItems: state.addProduct,
              transactionMethodType: TransactionMethodType.addProduct,
              from: Routes.ROUTE_ADDPRODUCT,
            ),
          );
        } else if (state is AddProductProductInsufficient) {
          DialogUtils.showAlertDialog(
            context,
            title: LocaleKeys.error_unableCheckout.tr(),
            desc: LocaleKeys.error_pleaseCheckShoppingCart.tr(),
          );
        }
      },
      child: BlocBuilder<AddProductCubit, AddProductState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            isEmpty: _cubit.addProductOrderItems.isEmpty,
            emptyIcon: CupertinoIcons.bag_badge_plus,
            emptyMessage: LocaleKeys.addProductEmpty.tr(),
            enableAppModeDisplay: true,
            isInitialLoading: state is AddProductInitial,
            isLoading: state is AddProductLoading,
            appBar: AppbarWidget(context, centerTitle: false, title: LocaleKeys.addStock.tr(), actions: []).build(),
            body: _buildPage(context, state),
            bottomNavigationBar:
                _cubit.addProductOrderItems.isEmpty
                    ? ButtonWidget(
                      margin: const EdgeInsets.all(16),
                      label: LocaleKeys.gotoProductsPage.tr(),
                      onPressed: () {
                        MainRouter(context).pushNamedAndRemoveUntil(argruments: const MainArgruments(1));
                      },
                    )
                    : buildPriceLayout(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(LocaleKeys.totalAmount.tr()),
                          //     const SizedBox(width: 16),
                          //     Expanded(
                          //       child: AppTextFormFieldUiWidget(
                          //         textAlign: TextAlign.right,
                          //         autofocus: true,
                          //         textValue: _cubit.totalPrice?.toString() ?? '0',
                          //         keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          //         onChanged: (value) {
                          //           _cubit.setTotalPrice(value);
                          //         },
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // const SizedBox(height: 16),
                          ButtonWidget(
                            disabled: _cubit.disabledSubmit,
                            label: LocaleKeys.proceedToAddProduct.tr(),
                            leading: const Icon(Icons.add_circle_outline_rounded),
                            onPressed: () {
                              _cubit.submit();
                            },
                          ),
                        ],
                      ),
                    ),
          );
        },
      ),
    );
  }
}
