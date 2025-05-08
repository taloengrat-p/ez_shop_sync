import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_type.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/models/base_argrument.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_router.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_state.dart';
import 'package:ez_shop_sync/src/pages/create_product/widgets/product_type_widget.dart';
import 'package:ez_shop_sync/src/pages/create_product_detail/create_product_detail_router.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/form/form_create_custom_field.dart';
import 'package:ez_shop_sync/src/widgets/form/form_custom_field_widget.dart';
import 'package:ez_shop_sync/src/widgets/image_form_field.dart/image_picker_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/column_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  CreateProductPageState createState() => CreateProductPageState();
}

class CreateProductPageState extends State<CreateProductPage> {
  final _cubit = GetIt.I<CreateProductCubit>();

  final ScrollController _scrollController = ScrollController();

  final _tagController = MultiSelectController<Tag>();
  final _categoryController = MultiSelectController<Category>();
  final _textProductTypeNameInput = TextEditingController();
  final _textProductTypePriceInput = TextEditingController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timstamp) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is ProductEditArgrument) {
        _cubit.setArgruments(args);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateProductCubit, CreateProductState>(
      bloc: _cubit,
      listener: (context, state) {
        log('create product state : $state, ${_cubit.productEditor?.attributes}');
        if (state is CreateProductSuccess || state is CreateProductUpdateSuccess) {
          CreateProductRouter(context).pop(BaseArgrument(refresh: true));
        }
      },
      child: BlocBuilder<CreateProductCubit, CreateProductState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            isLoading: state is CreateProductLoading,
            backgroundColor: Colors.white,
            appBar: AppbarWidget(context, title: LocaleKeys.createProduct.tr(), actions: []).build(),
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      ImagePickerWidget(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: 150,
                        path: _cubit.productImageFile?.path,
                        imageUrl: _cubit.productEditor?.imageUrl,
                        onImagePicked: (file) {
                          _cubit.setProductImage(file);
                        },
                      ),
                      const SizedBox(height: 32),
                      TextFormFieldUiWidget(
                        textValue: _cubit.productEditor?.name,
                        label: LocaleKeys.name.tr(),
                        onChanged: _cubit.setName,
                      ),
                      const SizedBox(height: 8),
                      TextFormFieldUiWidget(
                        textValue: _cubit.productEditor?.description,
                        label: LocaleKeys.optionalField.tr(args: [LocaleKeys.description.tr()]),
                        onChanged: _cubit.setDescription,
                      ),
                      const SizedBox(height: 8),
                      // TextFormFieldUiWidget(
                      //   textValue: cubit.productEditor?.quantity?.toString() ?? '',
                      //   label: LocaleKeys.optionalField.tr(args: [LocaleKeys.quantity.tr()]),
                      //   keyboardType: TextInputType.number,
                      //   onChanged: cubit.setQuantity,
                      // ),
                      // const SizedBox(
                      //   height: 8,
                      // ),
                      Divider(color: ColorKeys.primary.withOpacity(0.6)),
                      TextFormFieldUiWidget(
                        label: LocaleKeys.productType.tr(),
                        errorText: state is CreateProductProductTypeFailure ? state.message : null,
                        child: ColumnGapWidget(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          gap: 12,
                          children: [
                            ..._cubit.productEditor?.productTypeList
                                    ?.asMap()
                                    .map(
                                      (index, e) => MapEntry(
                                        index,
                                        InkWell(
                                          onTap: () async {
                                            final productType = await CreateProductDetailRouter(
                                              context,
                                            ).navigate(argruments: e);

                                            if (productType is ProductType) {
                                              _cubit.updateProductType(index, productType);
                                            }
                                          },
                                          child: IntrinsicHeight(
                                            child: ProductTypeWidget(
                                              model: e,
                                              onDelete: () {
                                                _cubit.onDeleteProductType(index);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .values ??
                                [],
                            if (_cubit.productEditor?.productTypeList?.length != 5)
                              Align(
                                alignment: Alignment.center,
                                child: ContainerCircleWidget(
                                  onPressed: () {
                                    _cubit.addProductType();
                                  },
                                  child: const Icon(Icons.add, color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // Divider(
                      //   color: ColorKeys.primary.withOpacity(0.6),
                      // ),
                      // TextFormFieldDropdownSelectWidget<Category>(
                      //   controller: _categoryController,
                      //   singleSelect: true,
                      //   label: LocaleKeys.optionalField.tr(args: [LocaleKeys.category.tr()]),
                      //   items: cubit.categories
                      //       .map(
                      //         (e) => DropdownItem<Category>(
                      //           label: e.name,
                      //           value: e,
                      //           selected: cubit.productEditor?.category == e.id,
                      //         ),
                      //       )
                      //       .toList(),
                      //   itemBuilder: (item, index, onTap) {
                      //     return DropdownSelectItemWidget(
                      //       selected: item.selected,
                      //       onTap: onTap,
                      //       child: CategoryWidget(
                      //         model: item.value,
                      //         icon: IconPickerUtils.getIcon(item.value.iconData),
                      //       ),
                      //     );
                      //   },
                      //   selectedItemBuilder: (item) {
                      //     return CategoryWidget(
                      //       model: item.value,
                      //       icon: IconPickerUtils.getIcon(item.value.iconData),
                      //     );
                      //   },
                      //   onSelectionChange: cubit.setCategory,
                      //   footerMenu: IconButton(
                      //     icon: const Icon(Icons.add),
                      //     onPressed: () async {
                      //       final result = await CreateCategoryRouter(context).navigate();

                      //       if (result is CreateCategorySuccess) {
                      //         _categoryController.closeDropdown();
                      //         cubit.refresh();
                      //       }
                      //     },
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 8,
                      // ),
                      // TextFormFieldDropdownSelectWidget<Tag>(
                      //   controller: _tagController,
                      //   singleSelect: false,
                      //   itemSeparator: const Divider(),
                      //   itemSelectd: cubit.tagsModelSelected,
                      //   items: cubit.tags.map(
                      //     (e) {
                      //       final isSelect = cubit.productEditor?.tag?.contains(e.id) ?? false;

                      //       return DropdownItem<Tag>(
                      //         label: e.name,
                      //         value: e,
                      //         selected: isSelect,
                      //       );
                      //     },
                      //   ).toList(),
                      //   itemBuilder: (item, index, onTap) {
                      //     return DropdownSelectItemWidget(
                      //       selected: item.selected,
                      //       onTap: onTap,
                      //       child: TagWidget(model: item.value),
                      //     );
                      //   },
                      //   selectedItemBuilder: (item) {
                      //     return Container(
                      //       margin: const EdgeInsets.only(top: 3),
                      //       child: TagWidget(model: item.value),
                      //     );
                      //   },
                      //   onSelectionChange: cubit.setTags,
                      //   label: LocaleKeys.optionalField.tr(args: [LocaleKeys.tags.tr()]),
                      //   footerMenu: IconButton(
                      //     icon: const Icon(Icons.add),
                      //     onPressed: () async {
                      //       final result = await CreateTagRouter(context).navigate();

                      //       if (result is CreateTagSuccess) {
                      //         _tagController.closeDropdown();
                      //         cubit.refresh();
                      //       }
                      //     },
                      //   ),
                      // ),
                      Divider(color: ColorKeys.primary.withOpacity(0.6)),
                      TextFormFieldUiWidget(
                        label: LocaleKeys.custom.tr(),
                        child: FormCustomFieldWidget<FormCreateCustomFieldArgrument>(
                          key: const ValueKey('form-create-custom-field'),
                          tag: 'form-create-custom-field',
                          // widgetEditor: FormCreateCustomField(
                          //   screenMode: ScreenMode.edit,
                          // ),
                          widgetDisplayBuilder: (context, item) {
                            return FormCreateCustomField(screenMode: ScreenMode.display, model: item);
                          },
                          items: _cubit.productEditor?.attributes ?? {},
                          onAddCustomField: (key, value) {
                            _cubit.addCustomField(key, value);
                            Future.delayed(const Duration(milliseconds: 200), () {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                            });
                          },
                          onRemoveField: (key) {
                            _cubit.removeCustomField(key);
                          },
                          onFieldValueChange: (key, value) {
                            _cubit.changedCustomField(key, value);
                          },
                          onTempFieldChange: (key, value) {
                            _cubit.setTempCustomName(key);
                            _cubit.setTempCustomValue(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: ButtonWidget(
              margin: const EdgeInsets.all(16),
              label:
                  _cubit.screenMode == ScreenMode.create ? LocaleKeys.button_submit.tr() : LocaleKeys.button_save.tr(),
              onPressed: () {
                if (_cubit.screenMode == ScreenMode.create) {
                  _cubit.submitCreate();
                } else {
                  _cubit.saveEdit();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
