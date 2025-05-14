import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/models/base_argrument.dart';
import 'package:ez_shop_sync/src/models/product_display_type.enum.dart';
import 'package:ez_shop_sync/src/models/product_sort_type.enum.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/_app/app_state.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_router.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_state.dart';
import 'package:ez_shop_sync/src/pages/main/product/models/product_item.interface.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_state.dart';
import 'package:ez_shop_sync/src/pages/main/product/widgets/product_grid_item_widget.dart';
import 'package:ez_shop_sync/src/pages/main/product/widgets/product_list_item_widget.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_page.dart';
import 'package:ez_shop_sync/src/utils/dialog_utils.dart';
import 'package:ez_shop_sync/src/widgets/app_pagination_loading_widget.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/body/body_widget.dart';
import 'package:ez_shop_sync/src/widgets/bottoms/bottom_sheet_add_cart_widget.dart';
import 'package:ez_shop_sync/src/widgets/bottoms/bottom_sheet_add_stock_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/action_appbar_button_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_scrollable_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/app_input_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  ProductPageState createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> implements IProductPage {
  final _cubit = GetIt.I<ProductCubit>();

  final _searchTextController = TextEditingController();
  final _refreshListViewController = RefreshController();
  final _refreshGridViewController = RefreshController();
  final _refreshEmptyViewController = RefreshController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    log('[dispose]', name: runtimeType.toString());
    super.dispose();
  }

  Widget buildBody(ProductState state) {
    return BodyWidget(
      actions: [
        IconButton(
          onPressed:
              state is ProductChangeSortType
                  ? null
                  : () {
                    _cubit.changeSortType();
                  },
          icon:
              state is ProductChangeSortType
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.grey))
                  : Icon(_cubit.sortType == ProductSortType.asc ? CupertinoIcons.sort_up : CupertinoIcons.sort_down),
        ),
        IconButton(
          onPressed: () {
            _cubit.changeDisplayType();
          },
          icon: Icon(_cubit.displayType == ProductDisplayType.grid ? Icons.list_rounded : Icons.grid_view),
        ),
      ],
      children: [buildContent()],
    );
  }

  Widget buildGridViewProduct() {
    return OrientationBuilder(
      builder: (context, orientation) {
        double itemHeight = 365;
        var size = MediaQuery.of(context).size;
        final crossAxisCount = orientation == Orientation.landscape ? 3 : 2;
        final double itemWidth = size.width / crossAxisCount;
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AppPaginationLoadingWidget(
            controller: _refreshGridViewController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: GridView.count(
              cacheExtent: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(8),
              crossAxisCount: crossAxisCount,
              childAspectRatio: (itemWidth / itemHeight),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children:
                  _cubit.products
                      .map(
                        (e) => GestureDetector(
                          onTap: () => onClickGoToDetailPage(e),
                          child: ProductGridItemWidget(key: ValueKey(e.id), product: e, iProductItem: this),
                        ),
                      )
                      .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget buildListProduct() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AppPaginationLoadingWidget(
        controller: _refreshListViewController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.separated(
          cacheExtent: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(8),
          itemCount: _cubit.products.length,
          itemBuilder: (context, index) {
            final product = _cubit.products.elementAt(index);

            return GestureDetector(
              onTap: () => onClickGoToDetailPage(product),
              child: ProductListItemWidget(product: product, iProductItem: this),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 8);
          },
        ),
      ),
    );
  }

  Widget buildContent() {
    return BlocBuilder<AppCubit, AppState>(
      bloc: _cubit.appCubit,
      builder: (context, baseState) {
        return Expanded(
          child: _cubit.displayType == ProductDisplayType.grid ? buildGridViewProduct() : buildListProduct(),
        );
      },
    );
  }

  @override
  onAddStock(Product product) async {
    final result = await DialogUtils.showAddStockDialog(context, product);

    if (result is BottomSheetAddStockSuccess) {
      log('onAddStock $result');
      _cubit.addProductToStock(
        product.copyWith(priceSelected: result.priceCategorySelected, quantity: result.qty),
        result.amountCost,
      );
    }
  }

  @override
  onAddCart(Product product) async {
    final result = await DialogUtils.showAddCartDialog(context, product);

    if (result is BottomSheetAddCartSuccess) {
      _cubit.addCart(product.copyWith(quantity: result.qty, priceSelected: result.priceCategorySelected));
    }
  }

  @override
  onDelete(Product product) async {
    final result = await DialogUtils.showConfirmDelete(context);

    if (result == ConfirmDialogResult.ok) {
      await _cubit.deleteProduct(_cubit.appCubit.store!.id, product);
    }
  }

  @override
  onEdit(String productId) async {
    final result = await CreateProductRouter(context).navigate(
      argruments: ProductEditArgrument(
        product: _cubit.products.firstWhere((e) => e.id == productId),
        screenMode: ScreenMode.edit,
      ),
    );
  }

  @override
  onClickGoToDetailPage(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ProductDetailPage(
              product: product,
              heroTag: product.id, // unique tag
            ),
      ),
    );

    // if (result is BaseArgrument && result.refresh) {
    //   _cubit.init();
    // }
  }

  void _onRefresh() async {
    if (_cubit.products.isEmpty) {
      _refreshEmptyViewController.requestLoading();
    } else if (_cubit.displayType == ProductDisplayType.grid) {
      _refreshGridViewController.requestRefresh();
    } else {
      _refreshListViewController.requestRefresh();
    }
    await _cubit.refresh();

    if (_cubit.products.isEmpty) {
      _refreshEmptyViewController.refreshCompleted();
    } else if (_cubit.displayType == ProductDisplayType.grid) {
      _refreshGridViewController.refreshCompleted();
    } else {
      _refreshListViewController.refreshCompleted();
    }
  }

  void _onLoading() async {
    // monitor network fetch
    if (_cubit.displayType == ProductDisplayType.grid) {
      _refreshGridViewController.requestLoading();
    } else {
      _refreshListViewController.requestLoading();
    }

    final result = await _cubit.loadMore();

    if (result) {
      if (_cubit.displayType == ProductDisplayType.grid) {
        _refreshGridViewController.loadComplete();
      } else {
        _refreshListViewController.loadComplete();
      }
    } else {
      if (_cubit.displayType == ProductDisplayType.grid) {
        _refreshGridViewController.loadNoData();
      } else {
        _refreshListViewController.loadNoData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      bloc: GetIt.I<AppCubit>(),
      builder: (context, appState) {
        return BlocBuilder<ProductCubit, ProductState>(
          bloc: _cubit,
          builder: (context, state) {
            log('state : $state', name: runtimeType.toString());
            return BaseScaffolds(
              emptyIcon: CupertinoIcons.bag,
              isInitialLoading: state is ProductInitial,
              // isLoading: state is ProductLoading,
              onRefresh: () async {
                await _cubit.refresh();
              },
              isEmpty: _cubit.products.isEmpty,
              enableAppModeDisplay: false,
              backgroundColor: Colors.white,
              appBar:
                  AppbarWidget(
                    context,
                    centerTitle: false,
                    title: '${LocaleKeys.inventory.tr()}${_cubit.productCount}',
                    titleWidget:
                        _cubit.screenMode == ScreenMode.search
                            ? TextField(
                              controller: _searchTextController,
                              autofocus: true,
                              decoration:
                                  AppInputDecoration(
                                    context,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear, color: Colors.black),
                                      onPressed: () {
                                        _searchTextController.clear();
                                        _cubit.clearSearchText();
                                      },
                                    ),
                                  ).build(),
                              onChanged: _cubit.setSearchText,
                            )
                            : null,
                    actions: [
                      if (_cubit.screenMode == ScreenMode.search)
                        TextButton(
                          onPressed: () {
                            _searchTextController.clear();
                            _cubit.doSwitchToDisplay();
                          },
                          child: Text(LocaleKeys.cancel.tr()),
                        ),
                      if (_cubit.screenMode == ScreenMode.display) ...[
                        ActionAppbarButtonWidget(
                          onPressed: _cubit.doSwitchToSearch,
                          child: const Icon(CupertinoIcons.search),
                        ),
                        const SizedBox(width: 5),
                        ActionAppbarButtonWidget(
                          child: const Icon(CupertinoIcons.add),
                          onPressed: () async {
                            if (_cubit.appCubit.store == null) {
                              return await DialogUtils.showAlertDialog(
                                context,
                                title: LocaleKeys.dialogUnableCreateProduct_title.tr(),
                                desc: LocaleKeys.dialogUnableCreateProduct_desc.tr(),
                              );
                            }
                            final result = await CreateProductRouter(context).navigate();
                            if (result is BaseArgrument && result.refresh) {
                              _cubit.refresh();
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ).build(),
              body: buildBody(state),
            );
          },
        );
      },
    );
  }
}
