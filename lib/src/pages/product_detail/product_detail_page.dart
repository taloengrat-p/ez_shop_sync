import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/base_argrument.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_cubit.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_router.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_state.dart';
import 'package:ez_shop_sync/src/utils/icon_picker_utils.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/category_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_carousel_preview_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/column_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/product_detail_title_value.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/tag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:glassmorphism/glassmorphism.dart';

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
    super.initState();

    cubit = ProductDetailCubit(
      productRepository: GetIt.I<ProductRepository>(),
      baseCubit: GetIt.I<BaseCubit>(),
    );

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
              appBar: AppbarWidget(
                context,
                actions: [
                  ContainerCircleWidget(
                    child: const Icon(
                      CupertinoIcons.pencil,
                    ),
                    // onPressed: () {},
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  ContainerCircleWidget(
                    color: Colors.red,
                    child: const Icon(
                      CupertinoIcons.delete,
                    ),
                    onPressed: () {
                      ConfirmDialogUiWidget(
                        context,
                        title: LocaleKeys.confirmDeleteTitle.tr(),
                        desc: LocaleKeys.confirmDeleteDesc.tr(),
                        confirmLabel: LocaleKeys.delete.tr(),
                        confirmColor: Colors.red,
                      ).show().then(
                        (val) {
                          if (val == ConfirmDialogUiResult.ok) {
                            cubit.deleteProduct();
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ).build(),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._buildTitle(),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _buildContent(),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(20)),
                child: GlassmorphicContainer(
                  width: double.infinity,
                  height: 80,
                  borderRadius: 20,
                  blur: 20,
                  alignment: Alignment.bottomCenter,
                  border: 2,
                  linearGradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                    Color(0xFFffffff).withOpacity(0.1),
                    Color(0xFFFFFFFF).withOpacity(0.05),
                  ], stops: [
                    0.1,
                    1,
                  ]),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFffffff).withOpacity(0.5),
                      Color((0xFFFFFFFF)).withOpacity(0.5),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildTitle() {
    return [
      ImageCarouselPreviewWidget(imagesUrl: cubit.imageMerged),
      const SizedBox(
        height: DimensionsKeys.m,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cubit.product?.name ?? '',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  "\$${cubit.product?.price?.toString() ?? '--'}",
                  style: TextStyle(
                    fontSize: 18,
                    color: ColorKeys.accent,
                  ),
                )
              ],
            ),
            Text(
              '${cubit.product?.quantity ?? '--'} ${LocaleKeys.units_piece.tr()}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      )
    ];
  }

  Widget _buildContent() {
    final data = cubit.product?.attributes
            ?.map(
              (k, v) => MapEntry(
                k,
                ProductDetailTitleValue(
                  title: k,
                  value: v,
                ),
              ),
            )
            .values
            .toList() ??
        [];

    return ColumnGapWidget(
      gap: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetailTitleValue(
          title: LocaleKeys.description.tr(),
          value: cubit.product?.description,
        ),
        ProductDetailTitleValue(
          title: LocaleKeys.category.tr(),
          widgetValues: cubit.category == null
              ? []
              : [
                  CategoryWidget(
                    model: cubit.category!,
                    icon: IconPickerUtils.getIcon(cubit.category!.iconData),
                  )
                ],
        ),
        ProductDetailTitleValue(
          title: LocaleKeys.tags.tr(),
          widgetValues: cubit.tags
              .map((e) => TagWidget(
                    model: e,
                  ))
              .toList(),
        ),
        ...data,
      ],
    );
  }
}
