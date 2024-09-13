import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/drawables.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/base_argrument.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/base/base_state.dart';
import 'package:ez_shop_sync/src/pages/cart/cart_router.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_router.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_state.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_cubit.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_router.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_state.dart';
import 'package:ez_shop_sync/src/pages/product_settings/product_settings_router.dart';
import 'package:ez_shop_sync/src/utils/dialog_utils.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:ez_shop_sync/src/utils/icon_picker_utils.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/bottoms/bottom_sheet_add_cart_widget.dart';
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

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({
    super.key,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late ProductDetailCubit cubit;
  late BaseCubit baseCubit;
  @override
  void initState() {
    super.initState();

    baseCubit = GetIt.I<BaseCubit>();
    cubit = ProductDetailCubit(
      productRepository: GetIt.I<ProductRepository>(),
      baseCubit: baseCubit,
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
                    onPressed: cubit.product == null
                        ? null
                        : () async {
                            final result = await CreateProductRouter(context)
                                .navigate(argruments: ProductEditArgrument(cubit.product!));

                            if (result is BaseArgrument && result.refresh) {
                              cubit.refresh();
                            }
                          },
                    child: const Icon(
                      CupertinoIcons.pencil,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
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
                          if (val == ConfirmDialogResult.ok) {
                            cubit.deleteProduct();
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ContainerCircleWidget(
                    child: cubit.baseCubit.cartCount != 0
                        ? Badge.count(
                            count: cubit.baseCubit.cartCount,
                            child: const Icon(CupertinoIcons.cart),
                          )
                        : const Icon(CupertinoIcons.cart),
                    onPressed: () {
                      CartRouter(context).navigate();
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ).build(),
              body: buildBody(),
              bottomNavigationBar: Container(
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
                              icon: const Icon(CupertinoIcons.cart_badge_plus),
                              color: Colors.orange,
                              label: LocaleKeys.addCart.tr(),
                              onPressed: () async {
                                final result = await DialogUtils.showAddCartDialog(context, cubit.product);

                                if (result is BottomSheetAddCartSuccess) {
                                  cubit.addCart(
                                    cubit.product?.copyWith(
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
                        icon: const Icon(
                          CupertinoIcons.bag_badge_plus,
                        ),
                        color: Colors.amber,
                        label: LocaleKeys.addStock.tr(),
                        onPressed: () async {
                          final result = await DialogUtils.showAddStockDialog(context, cubit.product);

                          if (result is num) {
                            cubit.addStock(cubit.product?.copyWith(), result);
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
                  cubit.product?.name.elseDisplay() ?? elseDisplay(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  cubit.product?.priceStringDisplay ?? elseDisplay(),
                  style: TextStyle(
                    fontSize: 18,
                    color: ColorKeys.accent,
                  ),
                )
              ],
            ),
            Text(
              '${cubit.product?.quantity.elseDisplay()} ${LocaleKeys.units_piece.tr()}',
              style: const TextStyle(fontSize: 18),
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
          value: cubit.productDescription,
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

  Widget buildBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
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
        BlocBuilder(
          bloc: baseCubit,
          builder: (context, baseState) {
            final size = MediaQuery.of(context).size;

            return AnimatedPositioned(
              duration: baseCubit.durationAddCart,
              top: baseState is BaseAddCartSuccess ? 0 : size.height,
              right: baseState is BaseAddCartSuccess ? 20 : (size.width - 100),
              child: baseState is BaseAddCartSuccess
                  ? const Icon(
                      CupertinoIcons.bag,
                      color: Colors.black,
                    )
                  : Container(),
            );
          },
        ),
      ],
    );
  }
}
