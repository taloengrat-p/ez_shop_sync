import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/base_argrument.dart';
import 'package:ez_shop_sync/src/models/product_display_type.enum.dart';
import 'package:ez_shop_sync/src/models/product_sort_type.enum.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_router.dart';
import 'package:ez_shop_sync/src/pages/main/product/models/product_item.interface.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_state.dart';
import 'package:ez_shop_sync/src/pages/main/product/widgets/product_grid_item_widget.dart';
import 'package:ez_shop_sync/src/pages/main/product/widgets/product_list_item_widget.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_router.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/body/body_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/action_appbar_button_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_scrollable_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
import 'package:ez_shop_sync/src/widgets/empty_data_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/app_input_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  ProductPageState createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> implements IProductPage {
  late ProductCubit cubit;
  final _searchTextController = TextEditingController();
  @override
  void initState() {
    log('[init]', name: runtimeType.toString());
    super.initState();
    cubit = ProductCubit(
      productRepository: GetIt.I<ProductRepository>(),
      baseCubit: GetIt.I.get<BaseCubit>(),
    );
  }

  @override
  void dispose() {
    log('[dispose]', name: runtimeType.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        cubit.init();
        return cubit;
      },
      child: BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
        return BaseScaffolds(
          appBar: AppbarWidget(
            context,
            centerTitle: false,
            title: '${LocaleKeys.inventory.tr()}${cubit.productCount}',
            titleWidget: cubit.screenMode == ScreenMode.search
                ? TextField(
                    controller: _searchTextController,
                    autofocus: true,
                    decoration: AppInputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _searchTextController.clear();
                          cubit.clearSearchText();
                        },
                      ),
                    ).build(),
                    onChanged: cubit.setSearchText,
                  )
                : null,
            actions: [
              if (cubit.screenMode == ScreenMode.search)
                TextButton(
                  onPressed: () {
                    _searchTextController.clear();
                    cubit.doSwitchToDisplay();
                  },
                  child: Text(LocaleKeys.cancel.tr()),
                ),
              if (cubit.screenMode == ScreenMode.display) ...[
                ActionAppbarButtonWidget(
                  onPressed: cubit.doSwitchToSearch,
                  child: const Icon(
                    CupertinoIcons.search,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                ActionAppbarButtonWidget(
                  child: const Icon(
                    CupertinoIcons.add,
                  ),
                  onPressed: () async {
                    final result = await CreateProductRouter(context).navigate();
                    if (result is BaseArgrument && result.refresh) {
                      cubit.init();
                    }
                  },
                ),
                const SizedBox(
                  width: 5,
                ),
                ContainerCircleWidget(
                  child: const Icon(
                    CupertinoIcons.bag_badge_plus,
                  ),
                  // onPressed: () async {},
                ),
                SizedBox(
                  width: 8,
                ),
              ]
            ],
          ).build(),
          body: buildBody(),
        );
      }),
    );
  }

  Widget buildBody() {
    return BodyWidget(
      actions: [
        IconButton(
          onPressed: () {
            cubit.changeSortType();
          },
          icon: Icon(
            cubit.sortType == ProductSortType.asc ? CupertinoIcons.sort_up : CupertinoIcons.sort_down,
          ),
        ),
        IconButton(
          onPressed: () {
            cubit.changeDisplayType();
          },
          icon: Icon(cubit.displayType == ProductDisplayType.grid ? Icons.list_rounded : Icons.grid_view),
        ),
      ],
      children: [
        buildContent(),
      ],
    );
  }

  Widget buildGridViewProduct() {
    return OrientationBuilder(builder: (context, orientation) {
      double itemHeight = 330;
      var size = MediaQuery.of(context).size;
      final crossAxisCount = orientation == Orientation.landscape ? 3 : 2;
      final double itemWidth = size.width / crossAxisCount;
      return GridView.count(
        crossAxisCount: crossAxisCount,
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        children: cubit.products
            .map(
              (e) => GestureDetector(
                onTap: () async {
                  final result = await ProductDetailRouter(context).navigate(argruments: e);

                  if (result is BaseArgrument && result.refresh) {
                    cubit.init();
                  }
                },
                child: ProductGridItemWidget(
                  key: ValueKey(e.id),
                  product: e,
                  iProductItem: this,
                ),
              ),
            )
            .toList(),
      );
    });
  }

  Widget buildListProduct() {
    return ListView.separated(
      itemCount: cubit.products.length,
      itemBuilder: (context, index) {
        final product = cubit.products.elementAt(index);

        return ProductListItemWidget(
          product: product,
          iProductItem: this,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: DimensionsKeys.gap,
        );
      },
    );
  }

  Widget buildContent() {
    var size = MediaQuery.of(context).size;

    if (cubit.products.isNotEmpty) {
      return Expanded(
        child: ContainerScrollableWidget(
          radius: DimensionsKeys.radius + 4,
          paddingAll: 10,
          child: cubit.displayType == ProductDisplayType.grid ? buildGridViewProduct() : buildListProduct(),
        ),
      );
    } else {
      return Expanded(
        child: Center(
          child: EmptyDataWidget(
            height: size.height * 0.45,
            width: 200,
            message: LocaleKeys.productsEmpty.tr(),
          ),
        ),
      );
    }
  }

  @override
  onAddStock(String productId) {
    cubit.addProductToStock(productId, 10);
  }

  @override
  onAddCart(String productId) {
    cubit.addCart();
  }

  @override
  onDelete(String productId) {
    ConfirmDialogUiWidget(
      context,
      title: LocaleKeys.confirmDeleteTitle.tr(),
      desc: LocaleKeys.confirmDeleteDesc.tr(),
      confirmLabel: LocaleKeys.delete.tr(),
      confirmColor: Colors.red,
    ).show().then(
      (val) {
        if (val == ConfirmDialogUiResult.ok) {
          cubit.deleteProduct(productId);
        }
      },
    );
  }

  @override
  onEdit(String productId) async {
    final result = await CreateProductRouter(context).navigate();
  }
}
