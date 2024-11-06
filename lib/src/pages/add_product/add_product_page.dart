import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/transaction_method_type.enum.dart';
import 'package:ez_shop_sync/src/data/repository/add_product/add_product_repository.dart';
import 'package:ez_shop_sync/src/data/repository/add_product_history/add_product_history_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/pages/add_product/add_product_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_product/add_product_state.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
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
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({
    super.key,
  });

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProductPage> {
  late AddProductCubit _cubit;
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
    _cubit = AddProductCubit(
      productRepository: GetIt.I<ProductRepository>(),
      addProductHistoryRepository: GetIt.I<AddProductHistoryRepository>(),
      baseCubit: GetIt.I<BaseCubit>(),
      addProductRepository: GetIt.I<AddProductRepository>(),
    );

    WidgetsBinding.instance.addPostFrameCallback((time) {
      _cubit.initial();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<AddProductCubit, AddProductState>(
        listener: (context, state) {
          if (state is AddProductRemoveItemSuccess) {
            // checkCanScroll();
          } else if (state is AddProductSuccess) {
            OrderCompleteRouter(context).replace(
                argruments: OrderCompleteArgrument(
              title: LocaleKeys.addProductCompleteTitle.tr(),
              addProductItems: state.addProduct,
              transactionMethodType: TransactionMethodType.addProduct,
              from: Routes.ROUTE_ADDPRODUCT,
            ));
          }
        },
        child: BlocBuilder<AddProductCubit, AddProductState>(
          builder: (context, state) {
            return BaseScaffolds(
              isLoading: state is AddProductLoading,
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: LocaleKeys.addStock.tr(),
                actions: [],
              ).build(),
              body: _cubit.products.isEmpty
                  ? Center(
                      child:
                          EmptyDataWidget(height: size.height * 0.45, width: 200, message: LocaleKeys.cartEmpty.tr()))
                  : _buildPage(context, state),
              bottomNavigationBar: _cubit.products.isEmpty
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(LocaleKeys.totalAmount.tr()),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: TextFormFieldUiWidget(
                                  textAlign: TextAlign.right,
                                  autofocus: true,
                                  textValue: _cubit.totalPrice?.toString() ?? '0',
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  onChanged: (value) {
                                    _cubit.setTotalPrice(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ButtonWidget(
                            disabled: _cubit.disabledSubmit,
                            label: LocaleKeys.proceedToAddProduct.tr(),
                            leading: const Icon(Icons.add_circle_outline_rounded),
                            onPressed: () {
                              _cubit.submit();
                            },
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

  Widget _buildPage(BuildContext context, AddProductState state) {
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
            Divider(
              color: Colors.grey.shade200,
            ),
            RowBetweenWidget(
              title: Text(
                LocaleKeys.totalAmount.tr(),
              ),
              value: Text(
                _cubit.totalPriceDisplay,
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
