import 'dart:developer';

import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/base_argrument.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_cubit.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_router.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_state.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_carousel_preview_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late ProductDetailCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cubit = ProductDetailCubit(productRepository: GetIt.I<ProductRepository>());

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      final argruments = ModalRoute.of(context)?.settings.arguments;

      if (argruments is Product) {
        cubit.setArgrument(argruments);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocListener<ProductDetailCubit, ProductDetailState>(
        listener: (context, state) {
          if (state is ProductDetailDelete) {
            ProductDetailRouter(context).pop(BaseArgrument(refresh: true));
          }
        },
        child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                actions: [
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.pencil,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      cubit.deleteProduct();
                    },
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageCarouselPreviewWidget(imagesUrl: cubit.imageMerged),
                    const SizedBox(
                      height: DimensionsKeys.m,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        cubit.product?.name ?? '',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "\$${cubit.product?.price.toString() ?? ''}",
                        style: TextStyle(
                          fontSize: 18,
                          color: ColorKeys.accent,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        label: 'Add Stock',
                        radius: 0,
                        textStyle: const TextStyle(color: Colors.grey),
                        backgroundColor: ColorKeys.white,
                        icon: Icon(
                          CupertinoIcons.cube_box,
                          color: ColorKeys.primary,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: ButtonWidget(
                        label: 'Transaction',
                        radius: 0,
                        backgroundColor: ColorKeys.primary,
                        icon: Icon(
                          CupertinoIcons.money_dollar_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
