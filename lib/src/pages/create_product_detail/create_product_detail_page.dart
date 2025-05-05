import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_type.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/create_product_detail/create_product_detail_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_product_detail/create_product_detail_router.dart';
import 'package:ez_shop_sync/src/pages/create_product_detail/create_product_detail_state.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/form/form_create_price_cetagory_widget.dart';
import 'package:ez_shop_sync/src/widgets/image_form_field.dart/image_picker_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/row_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CreateProductDetailPage extends StatefulWidget {
  const CreateProductDetailPage({super.key});

  @override
  _CreateProductDetailState createState() => _CreateProductDetailState();
}

class _CreateProductDetailState extends State<CreateProductDetailPage> {
  final _cubit = GetIt.I<CreateProductDetailCubit>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      final argruments = ModalRoute.of(context)?.settings.arguments;

      if (argruments is ProductType) {
        _cubit.setArgruments(argruments);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateProductDetailCubit, CreateProductDetailState>(
      bloc: _cubit,
      listener: (context, state) {},
      child: BlocBuilder<CreateProductDetailCubit, CreateProductDetailState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            backgroundColor: Colors.white,
            appBar: AppbarWidget(context, centerTitle: false, title: "CreateProductDetail", actions: []).build(),
            body: Column(
              children: [
                if (_cubit.items.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Colors.black.withOpacity(0.2),
                    height: 80,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: RowGapWidget(
                        gap: 12,
                        children: [
                          ..._cubit.items.map((e) => Container(width: 40, height: double.infinity, color: Colors.red)),
                          DottedBorder(
                            child: GestureDetector(
                              onTap: () {
                                _cubit.addCategory();
                              },
                              child: const SizedBox(
                                width: 40,
                                height: double.infinity,
                                child: Center(child: Icon(Icons.add, color: Colors.red)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Expanded(child: _buildPage(context, state)),
              ],
            ),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.all(16),
              child: ButtonWidget(
                label: LocaleKeys.button_save.tr(),
                onPressed: () {
                  CreateProductDetailRouter(context).pop(
                    ProductType(
                      image: _cubit.productImage,
                      name: _cubit.productName ?? '',
                      price: _cubit.productPrice,
                      quantity: _cubit.productQuantity,
                      desc: _cubit.productDesc,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, CreateProductDetailState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            ImagePickerWidget(
              height: 150,
              width: 150,
              path: _cubit.productImage,
              onImagePicked: (file) {
                _cubit.setImage(file?.path);
              },
            ),
            const SizedBox(height: 16),
            FormCreatePriceCetagoryWidget(
              screenMode: ScreenMode.create,
              model: FormCreatePriceCetagoryWidgetArgrument(
                name: _cubit.productName ?? '',
                price: _cubit.productPrice,
                quantity: _cubit.productQuantity,
                desc: _cubit.productDesc,
              ),
              onChange: ({String? name, num? price, num? quantity, String? desc}) {
                if (name != null) {
                  _cubit.setName(name);
                }

                if (desc != null) {
                  _cubit.setDesc(desc);
                }

                if (price != null) {
                  _cubit.setPrice(price);
                }
                if (quantity != null) {
                  _cubit.setQuantity(quantity);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
