import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/cart/cart_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/cart/cart_cubit.dart';
import 'package:ez_shop_sync/src/pages/cart/cart_state.dart';
import 'package:ez_shop_sync/src/pages/cart/widgets/cart_item_widget.dart';
import 'package:ez_shop_sync/src/utils/dialog_utils.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
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

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
  });

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartPage> {
  late CartCubit _cubit;
  final _listViewController = ScrollController();
  final _scrollViewController = ScrollController();

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
    _cubit = CartCubit(
      baseCubit: GetIt.I<BaseCubit>(),
      cartRepository: GetIt.I<CartRepository>(),
    );

    WidgetsBinding.instance.addPostFrameCallback((time) {
      _cubit.initial();
      Future.delayed(const Duration(milliseconds: 100), () {
        checkCanScroll();
      });
    });
  }

  checkCanScroll() {
    final maxScrollExtent = _listViewController.position.maxScrollExtent;
    final minScrollExtent = _listViewController.position.minScrollExtent;

    final canScroll = maxScrollExtent > minScrollExtent;

    // log('canScroll $canScroll, maxScrollExtent $maxScrollExtent, minScrollExtent $minScrollExtent');
    if (canScroll != _canScroll) {
      setState(() {
        _canScroll = canScroll;
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
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartRemoveItemSuccess) {
            checkCanScroll();
          }
        },
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: LocaleKeys.cart.tr(),
                actions: [],
              ).build(),
              body: _buildPage(context, state),
              bottomNavigationBar: buildPriceLayout(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(LocaleKeys.totalAmount.tr()),
                        Text(
                          _cubit.totalPriceIncludeServiceCharge.toString(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ButtonWidget(
                      label: LocaleKeys.proceedToCheckout.tr(),
                      leading: const Icon(Icons.payment_rounded),
                    )
                  ],
                ),
              ),
            );
          },
        ),
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
        )
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

            // log('_cubit.products.length ${_cubit.products.length}, $index, ${product.quantity}');

            return CartItemWidget(
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
            return const SizedBox(
              height: 16,
            );
          },
        ),
        buildPaymentMethod(),
        const SizedBox(
          height: 16,
        ),
        buildPaymentInfo(),
      ],
    );
  }

  Widget buildPriceLayout({required Widget child}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
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
            RowBetweenWidget(
              title: Text(
                LocaleKeys.paymentMethodOptions_qrCode.tr(),
              ),
              value: CupertinoRadio(
                activeColor: Colors.green,
                value: 'qr-code',
                groupValue: _cubit.paymentMethod,
                onChanged: (val) {
                  _cubit.changePaymentMethod(val);
                },
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
            ),
            RowBetweenWidget(
              title: Text(
                LocaleKeys.paymentMethodOptions_cash.tr(),
              ),
              value: CupertinoRadio(
                value: 'cash',
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
            RowBetweenWidget(
              title: Text(LocaleKeys.items.tr()),
              value: Text(
                _cubit.totalItems.prefixCurrency(),
              ),
            ),
            RowBetweenWidget(
              title: Text(LocaleKeys.subTotal.tr()),
              value: Text(_cubit.subTotalPrice.toString().prefixCurrency()),
            ),
            RowBetweenWidget(
              title: Text(LocaleKeys.serviceCharge.tr(args: [_cubit.serviceCharge.toString()])),
              value: Text(
                _cubit.totalServiceCharge.toString().prefixCurrency(),
              ),
            ),
            Divider(
              color: Colors.grey.shade200,
            ),
            RowBetweenWidget(
              title: Text(LocaleKeys.totalAmount.tr(args: [_cubit.serviceCharge.toString()])),
              value: Text(
                _cubit.totalPriceIncludeServiceCharge.toString().prefixCurrency(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
