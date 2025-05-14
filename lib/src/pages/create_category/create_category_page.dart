import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/create_category/create_category_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_category/create_category_router.dart';
import 'package:ez_shop_sync/src/pages/create_category/create_category_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/category_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_preview_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_color_picker_widget.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategoryPage> {
  final _cubit = GetIt.I<CreateCategoryCubit>();
  final _formKey = GlobalKey<FormState>();
  final _backgroundColorKey = GlobalKey<TextFormFieldColorPickerWidgetState>();
  final _borderColorKey = GlobalKey<TextFormFieldColorPickerWidgetState>();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      final argruments = ModalRoute.of(context)?.settings.arguments;

      if (argruments is Category) {
        _cubit.setArgrument(argruments);
        _borderColorKey.currentState?.setColor(argruments.borderColor?.toColor() ?? Colors.white);
        _backgroundColorKey.currentState?.setColor(argruments.color?.toColor() ?? Colors.white);
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateCategoryCubit, CreateCategoryState>(
      bloc: _cubit,
      listener: (context, state) {
        log('state : $state', name: runtimeType.toString());
        if (state is CreateCategorySuccess) {
          CreateCategoryRouter(context).pop(state);
        } else if (state is CreateCategoryUpdateSuccess) {
          CreateCategoryRouter(context).pop();
        }
      },
      child: BlocBuilder<CreateCategoryCubit, CreateCategoryState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            isLoading: state is CreateCategoryLoading,
            appBar:
                AppbarWidget(context, centerTitle: false, title: LocaleKeys.createCategory.tr(), actions: []).build(),
            body: _buildPage(context, state),
            bottomNavigationBar: ButtonWidget(
              margin: const EdgeInsets.all(8),
              label: _cubit.screenMode == ScreenMode.create ? LocaleKeys.create.tr() : LocaleKeys.button_save.tr(),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  if (_cubit.screenMode == ScreenMode.create) {
                    _cubit.doCreateSubmit();
                  } else {
                    _cubit.doSaveSubmit();
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, CreateCategoryState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ContainerPreviewWidget(
                child: CategoryWidget(
                  // icon: _cubit.iconData,
                  model: Category(
                    id: 'id',
                    name: _cubit.name.isEmpty ? '         ' : _cubit.name,
                    color: _cubit.backgroundColor.toHex(),
                    borderColor: _cubit.borderColor.toHex(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // TextFormFieldIconPickerWidget(label: LocaleKeys.icon.tr(), onSelected: _cubit.setIcon),
              AppTextFormFieldUiWidget(
                label: LocaleKeys.name.tr(),
                onChanged: _cubit.setName,
                autofocus: true,
                isRequired: true,
                textValue: _cubit.name,
              ),
              const SizedBox(height: 8),
              TextFormFieldColorPickerWidget(
                key: _backgroundColorKey,
                label: LocaleKeys.backgroundColor.tr(),
                onSelected: _cubit.setColor,
                initialColor: _cubit.backgroundColor,
              ),
              TextFormFieldColorPickerWidget(
                key: _borderColorKey,
                label: LocaleKeys.borderColor.tr(),
                onSelected: _cubit.setBorderColor,
                initialColor: _cubit.borderColor,
              ),
              const SizedBox(height: 16),
              Container(height: DimensionsKeys.heightBts),
            ],
          ),
        ),
      ),
    );
  }
}
