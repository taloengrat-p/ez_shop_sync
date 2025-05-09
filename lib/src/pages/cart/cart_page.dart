import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/payment_type.enum.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/models/enums/cart_error_type.enum.dart';
import 'package:ez_shop_sync/src/pages/cart/cart_cubit.dart';
import 'package:ez_shop_sync/src/pages/cart/cart_state.dart';
import 'package:ez_shop_sync/src/pages/cart/widgets/cart_item_widget.dart';
import 'package:ez_shop_sync/src/pages/main/main_router.dart';
import 'package:ez_shop_sync/src/pages/main/main_state.dart';
import 'package:ez_shop_sync/src/pages/order_complete/order_complete_router.dart';
import 'package:ez_shop_sync/src/pages/order_complete/order_complete_state.dart';
import 'package:ez_shop_sync/src/routes/routes.dart';
import 'package:ez_shop_sync/src/utils/dialog_utils.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_shadow_group_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
import 'package:ez_shop_sync/src/widgets/empty_data_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/column_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/row_between_widget.dart';
import 'package:ez_shop_sync/src/widgets/opacity_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartPage> {
  final _cubit = GetIt.I.get<CartCubit>();
  final _listViewController = ScrollController();
  final _scrollViewController = ScrollController();
  final _receiveAmountController = TextEditingController();
  final _receiveAmountForm = GlobalKey<FormState>();
  bool _isBottomScroll = false;
  bool _canScroll = false;

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

    _listViewController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((time) {
      _cubit.initial();
      Future.delayed(const Duration(milliseconds: 100), () {
        checkCanScroll();
      });
    });
  }

  checkCanScroll() {
    if (_cubit.products.isEmpty || _listViewController.positions.isEmpty) {
      return;
    }
    final maxScrollExtent = _listViewController.position.maxScrollExtent;
    final minScrollExtent = _listViewController.position.minScrollExtent;

    final canScroll = maxScrollExtent >= minScrollExtent;

    // log('canScroll $canScroll, maxScrollExtent $maxScrollExtent, minScrollExtent $minScrollExtent');
    if (canScroll != _canScroll) {
      Future.delayed(Duration.zero, () {
        setState(() {
          _canScroll = canScroll;
        });
      });
    }
  }

  @override
  void dispose() {
    _listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<CartCubit, CartState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is CartRemoveItemSuccess) {
          checkCanScroll();
        } else if (state is CartSuccess) {
          OrderCompleteRouter(context).replace(
            argruments: OrderCompleteArgrument(
              title: LocaleKeys.orderCompleteTitle.tr(),
              orderItem: state.ordered,
              transactionMethodType: TransactionMethodType.order,
              from: Routes.ROUTE_CART,
            ),
          );
        } else if (state is CartProductInsufficient) {
          DialogUtils.showAlertDialog(
            context,
            title: LocaleKeys.error_unableCheckout.tr(),
            desc: LocaleKeys.error_productPriceNotEnough.tr(),
          );
        }
      },
      child: BlocBuilder<CartCubit, CartState>(
        bloc: _cubit,
        builder: (context, state) {
          log('state : $state', name: runtimeType.toString());
          return BaseScaffolds(
            isInitialLoading: state is CartInitial,
            enableAppModeDisplay: true,
            isLoading: state is CartLoading,
            appBar: AppbarWidget(context, centerTitle: false, title: LocaleKeys.cart.tr(), actions: []).build(),
            body:
                _cubit.products.isEmpty
                    ? Center(
                      child: EmptyDataWidget(
                        height: size.height * 0.45,
                        width: 200,
                        message: LocaleKeys.cartEmpty.tr(),
                      ),
                    )
                    : _buildPage(context, state),
            bottomNavigationBar:
                _cubit.products.isEmpty
                    ? ButtonWidget(
                      margin: const EdgeInsets.all(16),
                      label: LocaleKeys.gotoProductsPage.tr(),
                      onPressed: () {
                        MainRouter(context).pushNamedAndRemoveUntil(argruments: const MainArgruments(1));
                      },
                    )
                    : Material(
                      child: buildPriceLayout(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(LocaleKeys.totalAmount.tr()),
                                Text(
                                  _cubit.totalPriceIncludeServiceCharge.toString(),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ButtonWidget(
                              label: LocaleKeys.proceedToCheckout.tr(),
                              leading: const Icon(Icons.payment_rounded),
                              onPressed:
                                  _cubit.hasAnyError
                                      ? null
                                      : () {
                                        if (_receiveAmountForm.currentState?.validate() ?? true) {
                                          _cubit.submit();
                                        } else {
                                          _receiveAmountController.clear();
                                        }
                                      },
                            ),
                          ],
                        ),
                      ),
                    ),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, CartState state) {
    return Stack(
      children: [
        buildProductItems(),
        AnimatedOpacity(
          opacity: _isBottomScroll || _canScroll == false || _cubit.products.length <= 2 ? 0 : 1,
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
          itemCount: _cubit.products.length,
          itemBuilder: (context, index) {
            final cartItem = _cubit.products.elementAt(index);

            final productStockItem = _cubit.productInStock.firstWhere((e) => e.id == cartItem.product?.id);

            final hasError =
                (productStockItem.productTypeList
                        ?.firstWhere((e) => e.id == cartItem.product?.priceSelected)
                        .quantity ??
                    0) <
                (cartItem.product?.quantity ?? 0);
            return CartItemWidget(
              hasError: hasError,
              errorMessageType: hasError ? CartErrorType.insufficient : null,
              cartItem: cartItem,
              onIncreaseQty: () {
                _cubit.increaseProductQtyByIndex(index);
              },
              onDecreaseQty: () {
                _cubit.decreaseProductQtyByIndex(index);
              },
              onDelete: () async {
                final result = await DialogUtils.showConfirmDelete(context);

                if (result == ConfirmDialogResult.ok) {
                  _cubit.deleteItemFromCart(cartItem.id);
                }
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 16);
          },
        ),
        buildPaymentMethod(),
        const SizedBox(height: 16),
        buildPaymentInfo(),
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

  Widget buildPaymentMethod() {
    return ContainerShadowGroupWidget(
      title: LocaleKeys.paymentMethod.tr(),
      margin: const EdgeInsets.symmetric(horizontal: DimensionsKeys.pagePaddingHzt),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      color: Colors.white,
      children: [
        ColumnGapWidget(
          mainAxisSize: MainAxisSize.min,
          gap: 4,
          children: [
            OpacityWidget(
              disabled: true,
              child: RowBetweenWidget(
                title: Text(LocaleKeys.paymentMethodOptions_qrCode.tr()),
                value: CupertinoRadio(
                  activeColor: Colors.green,
                  value: PaymentMethodType.qrcode,
                  groupValue: _cubit.paymentMethod,
                  onChanged: (val) {
                    log('change $val');
                    _cubit.changePaymentMethod(val);
                  },
                ),
              ),
            ),
            Divider(color: Colors.grey.shade200),
            RowBetweenWidget(
              title: Text(LocaleKeys.paymentMethodOptions_cash.tr()),
              value: CupertinoRadio(
                value: PaymentMethodType.cash,
                activeColor: Colors.green,
                groupValue: _cubit.paymentMethod,
                onChanged: (val) {
                  _cubit.changePaymentMethod(val);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildPaymentInfo() {
    return ContainerShadowGroupWidget(
      margin: const EdgeInsets.symmetric(horizontal: DimensionsKeys.pagePaddingHzt),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      color: Colors.white,
      title: LocaleKeys.paymentInfo.tr(),
      children: [
        ColumnGapWidget(
          mainAxisSize: MainAxisSize.min,
          gap: 4,
          children: [
            RowBetweenWidget(title: Text(LocaleKeys.items.tr()), value: Text(_cubit.totalItems)),
            RowBetweenWidget(
              title: Text(LocaleKeys.subTotal.tr()),
              value: Text(_cubit.subTotalPrice.toString().prefixCurrency()),
            ),
            RowBetweenWidget(
              title: Text(LocaleKeys.serviceCharge.tr(args: [_cubit.serviceCharge.toString()])),
              value: Text(_cubit.totalServiceCharge.toString().prefixCurrency()),
            ),
            Divider(color: Colors.grey.shade200),
            RowBetweenWidget(
              title: Text(LocaleKeys.totalAmount.tr(args: [_cubit.serviceCharge.toString()])),
              value: Text(
                _cubit.totalPriceIncludeServiceCharge.toString().prefixCurrency(),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
            if (_cubit.paymentMethod == PaymentMethodType.cash) ...[
              const SizedBox(height: 8),
              RowBetweenWidget(
                crossAxisAlignment: CrossAxisAlignment.start,
                title: Text(LocaleKeys.receiveAmount.tr()),
                value: Expanded(
                  child: Form(
                    key: _receiveAmountForm,
                    child: TextFormFieldUiWidget(
                      autofocus: true,
                      textAlign: TextAlign.end,
                      autoCorrect: true,
                      // keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: _receiveAmountController,
                      onChanged: (value) {
                        _cubit.setReceiveAmount(value);
                      },
                      isRequired: true,
                      validator: (value) {
                        if (_cubit.totalPrice > (_cubit.receiveAmount ?? 0)) {
                          return LocaleKeys.error_receiveAmountInvalid.tr();
                        }

                        if ((_cubit.paymentMethod == PaymentMethodType.cash && _cubit.receiveAmount == null) ||
                            (_cubit.paymentMethod == PaymentMethodType.cash && _cubit.receiveAmount == 0)) {
                          return LocaleKeys.error_receiveAmountInvalid.tr();
                        }

                        return null;
                      },
                    ),
                  ),
                ),
              ),
              RowBetweenWidget(
                title: Text(LocaleKeys.changeAmount.tr()),
                value: Text(
                  _cubit.receiveAmount == null ? '--' : _cubit.changeAmountDisplay.toString().prefixCurrency(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
