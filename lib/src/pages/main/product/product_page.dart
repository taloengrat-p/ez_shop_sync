import 'dart:developer';

import 'package:ez_shop_sync/res/image_constance.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/base_argrument.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_router.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_state.dart';
import 'package:ez_shop_sync/src/pages/main/product/widgets/product_grid_item_widget.dart';
import 'package:ez_shop_sync/src/pages/main/product/widgets/product_list_item_widget.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_router.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/empty_data_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late ProductCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log('init', name: runtimeType.toString());
    cubit = ProductCubit(
      productRepository: GetIt.I<ProductRepository>(),
      baseCubit: GetIt.I.get<BaseCubit>(),
    );
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
            title: 'Products${cubit.productCount}',
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () async {
                  final result = await CreateProductRouter(context).navigate();
                  if (result is BaseArgrument && result.refresh) {
                    cubit.init();
                  }
                },
                icon: Icon(
                  CupertinoIcons.add,
                ),
              ),
            ],
          ).build(),
          body: buildBody(),
        );
      }),
    );
  }

  Widget buildBody() {
    var size = MediaQuery.of(context).size;

    return Column(
      children: [
        buildDisplayViewToggle(),
        buildContent(),
        Container(
          height: 60,
        ),
      ],
    );
  }

  Widget buildGridViewProduct() {
    return OrientationBuilder(builder: (context, orientation) {
      double itemHeight = 280;
      var size = MediaQuery.of(context).size;
      final crossAxisCount = orientation == Orientation.landscape ? 3 : 2;
      final double itemWidth = size.width / crossAxisCount;
      return GridView.count(
        padding: const EdgeInsets.all(8),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: (itemWidth / itemHeight),
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
                  product: e,
                ),
              ),
            )
            .toList(),
      );
    });
  }

  Widget buildListProduct() {
    return ListView.builder(
      itemCount: cubit.products.length,
      itemBuilder: (context, index) {
        final product = cubit.products.elementAt(index);

        return ProductListItemWidget(
          product: product,
          onDeleteProduct: () {
            cubit.deleteProduct(product.id);
          },
        );
      },
    );
  }

  Widget buildContent() {
    var size = MediaQuery.of(context).size;

    if (cubit.products.isNotEmpty) {
      return Expanded(
          child: cubit.displayType == ProductDisplayType.grid ? buildGridViewProduct() : buildListProduct());
    } else {
      return Expanded(
        child: Center(
          child: EmptyDataWidget(
            height: size.height * 0.45,
            width: 200,
            message: 'Your product is empty please create new product.',
          ),
        ),
      );
    }
  }

  Widget buildDisplayViewToggle() {
    return Visibility(
      visible: cubit.products.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                cubit.changeDisplayType();
              },
              icon: Icon(cubit.displayType == ProductDisplayType.grid ? Icons.list_rounded : Icons.grid_view),
            ),
          ],
        ),
      ),
    );
  }
}
