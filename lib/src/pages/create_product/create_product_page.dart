import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/models/base_argrument.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_category/create_category_router.dart';
import 'package:ez_shop_sync/src/pages/create_category/create_category_state.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_router.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_state.dart';
import 'package:ez_shop_sync/src/pages/create_tag/create_tag_router.dart';
import 'package:ez_shop_sync/src/pages/create_tag/create_tag_state.dart';
import 'package:ez_shop_sync/src/utils/icon_picker_utils.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/category_widget.dart';
import 'package:ez_shop_sync/src/widgets/dropdown_select_item_widget.dart';
import 'package:ez_shop_sync/src/widgets/form/form_custom_field_widget.dart';
import 'package:ez_shop_sync/src/widgets/image_form_field.dart/image_form_field.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/tag_widget.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_dropdown_select_widget.dart';
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
  late CreateProductCubit cubit;

  final ScrollController _scrollController = ScrollController();

  final _tagController = MultiSelectController<Tag>();
  final _categoryController = MultiSelectController<Category>();
  @override
  void initState() {
    super.initState();
    cubit = CreateProductCubit(
      productRepository: GetIt.I<ProductRepository>(),
      baseCubit: GetIt.I<BaseCubit>(),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (timstamp) {
        final args = ModalRoute.of(context)?.settings.arguments;

        if (args is ProductEditArgrument) {
          cubit.setArgruments(args);
        }
      },
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
          log('create product state : $state, ${cubit.productEditor?.attributes}');
          if (state is CreateProductSuccess || state is CreateProductUpdateSuccess) {
            CreateProductRouter(context).pop(BaseArgrument(refresh: true));
          }
        },
        child: BlocBuilder<CreateProductCubit, CreateProductState>(builder: (context, state) {
          return BaseScaffolds(
            appBar: AppbarWidget(context, title: LocaleKeys.createProduct.tr(), actions: []).build(),
            body: SingleChildScrollView(
              controller: _scrollController,
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
                        textValue: cubit.productEditor?.name,
                        label: LocaleKeys.name.tr(),
                        onChanged: cubit.setName,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormFieldUiWidget(
                        textValue: cubit.productEditor?.description,
                        label: LocaleKeys.description.tr(),
                        onChanged: cubit.setDescription,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormFieldUiWidget(
                        textValue: cubit.productEditor?.quantity?.toString() ?? '',
                        label: LocaleKeys.quantity.tr(),
                        keyboardType: TextInputType.number,
                        onChanged: cubit.setQuantity,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormFieldDropdownSelectWidget<Category>(
                        controller: _categoryController,
                        singleSelect: true,
                        label: LocaleKeys.category.tr(),
                        items: cubit.categories
                            .map(
                              (e) => DropdownItem<Category>(
                                label: e.name,
                                value: e,
                                selected: cubit.productEditor?.category == e.id,
                              ),
                            )
                            .toList(),
                        itemBuilder: (item, index, onTap) {
                          return DropdownSelectItemWidget(
                            selected: item.selected,
                            onTap: onTap,
                            child: CategoryWidget(
                              model: item.value,
                              icon: IconPickerUtils.getIcon(item.value.iconData),
                            ),
                          );
                        },
                        selectedItemBuilder: (item) {
                          return CategoryWidget(
                            model: item.value,
                            icon: IconPickerUtils.getIcon(item.value.iconData),
                          );
                        },
                        onSelectionChange: cubit.setCategory,
                        footerMenu: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            final result = await CreateCategoryRouter(context).navigate();

                            if (result is CreateCategorySuccess) {
                              _categoryController.closeDropdown();
                              cubit.refresh();
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormFieldDropdownSelectWidget<Tag>(
                        controller: _tagController,
                        singleSelect: false,
                        itemSeparator: const Divider(),
                        itemSelectd: cubit.tagsModelSelected,
                        items: cubit.tags.map(
                          (e) {
                            final isSelect = cubit.productEditor?.tag?.contains(e.id) ?? false;

                            return DropdownItem<Tag>(
                              label: e.name,
                              value: e,
                              selected: isSelect,
                            );
                          },
                        ).toList(),
                        itemBuilder: (item, index, onTap) {
                          return DropdownSelectItemWidget(
                            selected: item.selected,
                            onTap: onTap,
                            child: TagWidget(model: item.value),
                          );
                        },
                        selectedItemBuilder: (item) {
                          return Container(
                            margin: const EdgeInsets.only(top: 3),
                            child: TagWidget(model: item.value),
                          );
                        },
                        onSelectionChange: cubit.setTags,
                        label: LocaleKeys.tags.tr(),
                        footerMenu: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            final result = await CreateTagRouter(context).navigate();

                            if (result is CreateTagSuccess) {
                              _tagController.closeDropdown();
                              cubit.refresh();
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Divider(
                        color: ColorKeys.primary.withOpacity(0.6),
                      ),
                      TextFormFieldUiWidget(
                        label: LocaleKeys.priceCategory.tr(),
                        child: FormCustomFieldWidget(
                          key: const ValueKey('form-create-price-category'),
                          tag: 'form-create-price-category',
                          keyLabel: LocaleKeys.priceCategoryName.tr(),
                          valueLabel: LocaleKeys.price.tr(),
                          keyboardType: const TextInputType.numberWithOptions(),
                          items: cubit.productEditor?.priceCategories ?? {},
                          onAddCustomField: (key, value) {
                            cubit.addPriceCategory(key, value);
                          },
                          onRemoveField: (key) {
                            cubit.removePriceCategory(key);
                          },
                          onFieldValueChange: (key, value) {
                            cubit.changedPriceCategory(key, value);
                          },
                          onTempFieldChange: (key, value) {
                            cubit.setTempPriceCategoryName(key);
                            cubit.setTempPriceCategoryValue(key);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Divider(
                        color: ColorKeys.primary.withOpacity(0.6),
                      ),
                      TextFormFieldUiWidget(
                        label: LocaleKeys.custom.tr(),
                        child: FormCustomFieldWidget(
                          key: const ValueKey('form-create-custom-field'),
                          tag: 'form-create-custom-field',
                          items: cubit.productEditor?.attributes ?? {},
                          onAddCustomField: (key, value) {
                            cubit.addCustomField(key, value);
                            Future.delayed(const Duration(milliseconds: 200), () {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                            });
                          },
                          onRemoveField: (key) {
                            cubit.removeCustomField(key);
                          },
                          onFieldValueChange: (key, value) {
                            cubit.changedCustomField(key, value);
                          },
                          onTempFieldChange: (key, value) {
                            cubit.setTempCustomName(key);
                            cubit.setTempCustomValue(key);
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
              label: cubit.screenMode == ScreenMode.create ? LocaleKeys.create.tr() : LocaleKeys.button_save.tr(),
              onPressed: () {
                if (cubit.screenMode == ScreenMode.create) {
                  cubit.submit();
                } else {
                  cubit.saveEdit();
                }
              },
            ),
          );
        }),
      ),
    );
  }
}
