import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/base_argrument.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_router.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_state.dart';
import 'package:ez_shop_sync/src/pages/main/main_page.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/image_form_field.dart/image_form_field.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  CreateProductPageState createState() => CreateProductPageState();
}

class CreateProductPageState extends State<CreateProductPage> {
  late CreateProductCubit cubit;
  final _textCustomFieldNameInput = TextEditingController();
  final _textCustomFieldValueInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit = CreateProductCubit(
      productRepository: GetIt.I<ProductRepository>(),
      baseCubit: GetIt.I<BaseCubit>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return cubit;
      },
      child: BlocListener<CreateProductCubit, CreateProductState>(
        listener: (context, state) {
          if (state is CreateProductSuccess) {
            CreateProductRouter(context).pop(BaseArgrument(refresh: true));
          }
        },
        child: BlocBuilder<CreateProductCubit, CreateProductState>(builder: (context, state) {
          return BaseScaffolds(
            appBar: AppbarWidget(context, title: LocaleKeys.createProduct.tr(), actions: []).build(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      ImageFormField(
                        imageDetailLimit: 5,
                        onProductDetailImageSelect: cubit.setProductDetailImageSelect,
                        onProductImageSelect: cubit.setProductImageSelect,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormFieldUiWidget(
                        label: LocaleKeys.name.tr(),
                        onChanged: cubit.setName,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormFieldUiWidget(
                        label: LocaleKeys.description.tr(),
                        onChanged: cubit.setDescription,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormFieldUiWidget(
                        label: LocaleKeys.price.tr(),
                        onChanged: cubit.setPrice,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormFieldUiWidget(
                        label: LocaleKeys.quantity.tr(),
                        keyboardType: TextInputType.number,
                        onChanged: cubit.setQuantity,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormFieldUiWidget(
                        label: LocaleKeys.category.tr(),
                        onChanged: cubit.setCategory,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Divider(
                        color: ColorKeys.primary.withOpacity(0.6),
                      ),
                      ...buildCustomField()
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: ButtonWidget(
              margin: const EdgeInsets.all(16),
              label: 'CREATE',
              onPressed: () {
                cubit.submit();
              },
            ),
          );
        }),
      ),
    );
  }

  List<Widget> buildCustomField() {
    return [
      ...cubit.customField
          .map(
            (k, v) => MapEntry(
              k,
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormFieldUiWidget(
                      key: ValueKey(k),
                      label: k,
                      textInitial: v,
                      onChanged: (value) {
                        cubit.changedCustomField(k, v);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ContainerCircleWidget(
                    color: Colors.red,
                    child: const Icon(CupertinoIcons.delete),
                    onPressed: () {
                      cubit.removeCustomField(k);
                    },
                  )
                ],
              ),
            ),
          )
          .values,
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: TextFormFieldUiWidget(
                    controller: _textCustomFieldNameInput,
                    label: LocaleKeys.customName.tr(),
                    onChanged: cubit.setTempCustomName,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextFormFieldUiWidget(
                    controller: _textCustomFieldValueInput,
                    label: LocaleKeys.customValue.tr(),
                    onChanged: (value) {
                      cubit.tempCustomValue = value ?? '';
                    },
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          ContainerCircleWidget(
            child: const Icon(Icons.add),
            onPressed: () {
              if (cubit.tempCustomValue.isEmpty || cubit.tempCustomName.isEmpty) {
                return;
              }
              cubit.addCustomField(cubit.tempCustomName, cubit.tempCustomValue);
              _textCustomFieldValueInput.clear();
              _textCustomFieldNameInput.clear();
            },
          )
        ],
      )
    ];
  }
}
