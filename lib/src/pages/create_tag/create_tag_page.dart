import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/data/repository/tag/tag_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_tag/create_tag_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_tag/create_tag_router.dart';
import 'package:ez_shop_sync/src/pages/create_tag/create_tag_state.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_preview_widget.dart';
import 'package:ez_shop_sync/src/widgets/tag_widget.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_color_picker_widget.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:get_it/get_it.dart';

class CreateTagPage extends StatefulWidget {
  const CreateTagPage({
    super.key,
  });

  @override
  _CreateTagState createState() => _CreateTagState();
}

class _CreateTagState extends State<CreateTagPage> {
  late CreateTagCubit _cubit;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cubit = CreateTagCubit(
      storeRepository: GetIt.I<StoreRepository>(),
      baseCubit: GetIt.I<BaseCubit>(),
      tagRepository: GetIt.I<TagRepository>(),
    );

    WidgetsBinding.instance.addPostFrameCallback((time) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<CreateTagCubit, CreateTagState>(
        listener: (context, state) {
          if (state is CreateTagSuccess) {
            CreateTagRouter(context).pop(state);
          }
        },
        child: BlocBuilder<CreateTagCubit, CreateTagState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: LocaleKeys.createTag.tr(),
                actions: [],
              ).build(),
              body: _buildPage(context, state),
              bottomNavigationBar: ButtonWidget(
                margin: const EdgeInsets.all(8),
                label: LocaleKeys.create.tr(),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _cubit.doSubmit();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, CreateTagState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ContainerPreviewWidget(
                child: TagWidget(
                  model: Tag(
                    id: 'id',
                    name: _cubit.name.isEmpty ? '         ' : _cubit.name,
                    color: _cubit.backgroundColor.toHex(),
                    borderColor: _cubit.borderColor.toHex(),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormFieldUiWidget(
                label: LocaleKeys.name.tr(),
                onChanged: _cubit.setName,
                autofocus: true,
                isRequired: true,
              ),
              const SizedBox(
                height: 8,
              ),
              TextFormFieldColorPickerWidget(
                label: LocaleKeys.backgroundColor.tr(),
                onSelected: _cubit.setColor,
              ),
              TextFormFieldColorPickerWidget(
                label: LocaleKeys.borderColor.tr(),
                onSelected: _cubit.setBorderColor,
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: DimensionsKeys.heightBts,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
