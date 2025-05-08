import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/drawables.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/models/base_argrument.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/_app/app_state.dart';
import 'package:ez_shop_sync/src/pages/cart/cart_router.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_router.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_state.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_cubit.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_router.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_state.dart';
import 'package:ez_shop_sync/src/pages/product_detail/widgets/product_detail_tab_data.dart';
import 'package:ez_shop_sync/src/pages/product_detail/widgets/product_detail_tab_history.dart';
import 'package:ez_shop_sync/src/pages/product_settings/product_settings_router.dart';
import 'package:ez_shop_sync/src/utils/dialog_utils.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:ez_shop_sync/src/utils/icon_picker_utils.dart';
import 'package:ez_shop_sync/src/widgets/app_pagination_loading_widget.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/bottoms/bottom_sheet_add_cart_widget.dart';
import 'package:ez_shop_sync/src/widgets/bottoms/bottom_sheet_add_stock_widget.dart';
import 'package:ez_shop_sync/src/widgets/category_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
import 'package:ez_shop_sync/src/widgets/icon/button_icon_label_widget.dart';
import 'package:ez_shop_sync/src/widgets/icon/drawable_icon_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_carousel_preview_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/column_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/product_detail_title_value.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/tag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _cubit = GetIt.I<ProductDetailCubit>();
  final _refreshController = RefreshController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final argruments = ModalRoute.of(context)?.settings.arguments;

      if (argruments is Product) {
        _cubit.setArgrument(argruments);
      }
    });
  }

  List<Widget> _buildTitle() {
    return [
      ImageCarouselPreviewWidget(imagesUrl: _cubit.imageMerged, height: MediaQuery.of(context).size.height * 0.45),
      const SizedBox(height: DimensionsKeys.m),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _cubit.product?.name.elseDisplay() ?? elseDisplay(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  _cubit.product?.priceStringDisplay ?? elseDisplay(),
                  style: TextStyle(fontSize: 18, color: ColorKeys.accent),
                ),
              ],
            ),
            Text(
              '${_cubit.product?.allQuantity.elseDisplay()} ${LocaleKeys.units_piece.tr()}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildContent() {
    final data =
        _cubit.product?.attributes
            ?.map((k, v) => MapEntry(k, ProductDetailTitleValue(title: k, value: v)))
            .values
            .toList() ??
        [];

    return ColumnGapWidget(
      gap: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetailTitleValue(title: LocaleKeys.description.tr(), value: _cubit.productDescription.toString()),
        ProductDetailTitleValue(
          title: LocaleKeys.category.tr(),
          widgetValues:
              _cubit.category == null
                  ? []
                  : [CategoryWidget(model: _cubit.category!, icon: IconPickerUtils.getIcon(_cubit.category!.iconData))],
        ),
        ProductDetailTitleValue(
          title: LocaleKeys.tags.tr(),
          widgetValues: _cubit.tags.map((e) => TagWidget(model: e)).toList(),
        ),
        ...data,
      ],
    );
  }

  Widget buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        AppPaginationLoadingWidget(
          controller: _refreshController,
          onRefresh: _refresh,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._buildTitle(),
                const SizedBox(height: 16),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: _buildContent()),
                const SizedBox(height: 16),
                SizedBox(height: 450, width: double.infinity, child: _buildTabContent()),
              ],
            ),
          ),
        ),
        BlocBuilder(
          bloc: _cubit.appCubit,
          builder: (context, baseState) {
            final size = MediaQuery.of(context).size;

            return AnimatedPositioned(
              duration: _cubit.appCubit.durationAddCart,
              top: baseState is AppAddCartSuccess ? 0 : size.height,
              right: baseState is AppAddCartSuccess ? 20 : (size.width - 100),
              child: baseState is AppAddCartSuccess ? const Icon(CupertinoIcons.bag, color: Colors.black) : Container(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TabBar(
            indicatorColor: ColorKeys.primary,
            tabs: const [
              Tab(icon: SizedBox.expand(child: Icon(CupertinoIcons.time))),
              Tab(icon: SizedBox.expand(child: Icon(CupertinoIcons.chart_bar_square))),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                ProductDetailTabHistory(emptyIcon: CupertinoIcons.time),
                ProductDetailTabData(emptyIcon: CupertinoIcons.chart_bar_square),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    log('refresh');
    _refreshController.requestRefresh();
    await _cubit.refresh();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductDetailCubit, ProductDetailState>(
      bloc: _cubit,
      listener: (context, state) {
        log('state : $state', name: runtimeType.toString());
        if (state is ProductDetailDeleteSuccess) {
          ProductDetailRouter(context).pop(BaseArgrument(refresh: true));
        }
      },
      child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            onRefresh: _refresh,
            // isLoading: state is ProductDetailLoading,
            backgroundColor: Colors.white,
            isAppBarOverlay: true,
            appBar:
                AppbarWidget(
                  context,
                  actions: [
                    ContainerCircleWidget(
                      backgroundColor: Colors.black.withOpacity(0.4),
                      color: Colors.white,
                      onPressed:
                          _cubit.product == null
                              ? null
                              : () async {
                                final result = await CreateProductRouter(context).navigate(
                                  argruments: ProductEditArgrument(
                                    product: _cubit.product,
                                    screenMode: ScreenMode.edit,
                                  ),
                                );

                                // if (result is CreateProductUpdateSuccess) {
                                //   _cubit.refresh(product: result.product);
                                // }
                              },
                      child: const Icon(CupertinoIcons.pencil),
                    ),
                    const SizedBox(width: 8),
                    ContainerCircleWidget(
                      backgroundColor: Colors.black.withOpacity(0.25),
                      color: Colors.red,
                      child: const Icon(CupertinoIcons.delete),
                      onPressed: () {
                        ConfirmDialogUiWidget(
                          context,
                          title: LocaleKeys.confirmDeleteTitle.tr(),
                          desc: LocaleKeys.confirmDeleteDesc.tr(),
                          confirmLabel: LocaleKeys.delete.tr(),
                          confirmColor: Colors.red,
                        ).show().then((val) {
                          if (val == ConfirmDialogResult.ok) {
                            _cubit.deleteProduct();
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    ContainerCircleWidget(
                      backgroundColor: Colors.black.withOpacity(0.4),
                      color: Colors.white,
                      child:
                          _cubit.appCubit.cartCount != 0
                              ? Badge.count(count: _cubit.appCubit.cartCount, child: const Icon(CupertinoIcons.cart))
                              : const Icon(CupertinoIcons.cart),
                      onPressed: () {
                        CartRouter(context).navigate();
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ).build(),
            body: buildBody(),
            bottomNavigationBar: SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ButtonIconLabelWidget(
                            icon: const DrawableIconWidget(Drawables.settings),
                            label: LocaleKeys.settings.tr(),
                            onPressed: () {
                              ProductSettingsRouter(context).navigate();
                            },
                          ),
                        ),
                        Expanded(
                          child: ButtonIconLabelWidget(
                            icon: const Icon(CupertinoIcons.cart_badge_plus, color: Colors.white),
                            color: Colors.orange,
                            label: LocaleKeys.addCart.tr(),
                            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                            onPressed: () async {
                              final result = await DialogUtils.showAddCartDialog(context, _cubit.product);

                              if (result is BottomSheetAddCartSuccess) {
                                _cubit.addCart(
                                  _cubit.product?.copyWith(
                                    quantity: result.qty,
                                    priceSelected: result.priceCategorySelected,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ButtonIconLabelWidget(
                      icon: const Icon(CupertinoIcons.bag_badge_plus, color: Colors.white),
                      color: Colors.amber,
                      label: LocaleKeys.addStock.tr(),
                      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                      onPressed: () async {
                        final result = await DialogUtils.showAddStockDialog(context, _cubit.product);

                        if (result is BottomSheetAddStockSuccess) {
                          _cubit.addStock(
                            _cubit.product?.copyWith(priceSelected: result.priceCategorySelected, quantity: result.qty),
                            result.amountCost,
                          );
                        }
                      },
                    ),
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
