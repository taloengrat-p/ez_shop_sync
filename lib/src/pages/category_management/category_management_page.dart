import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/category_management/category_management_cubit.dart';
import 'package:ez_shop_sync/src/pages/category_management/category_management_state.dart';
import 'package:ez_shop_sync/src/pages/create_category/create_category_router.dart';
import 'package:ez_shop_sync/src/pages/create_category/create_category_state.dart';
import 'package:ez_shop_sync/src/utils/icon_picker_utils.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/category_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_select_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
import 'package:ez_shop_sync/src/widgets/empty_data_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({
    Key? key,
  }) : super(key: key);

  @override
  _CategoryManagementState createState() => _CategoryManagementState();
}

class _CategoryManagementState extends State<CategoryManagementPage> {
  late CategoryManagementCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CategoryManagementCubit(
      storeRepository: GetIt.I<StoreRepository>(),
      baseCubit: GetIt.I<BaseCubit>(),
      categoryRepository: GetIt.I<CategoryRepository>(),
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
      child: BlocListener<CategoryManagementCubit, CategoryManagementState>(
        listener: (context, state) {},
        child: BlocBuilder<CategoryManagementCubit, CategoryManagementState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: LocaleKeys.categoryManagement.tr(),
                actions: [
                  if (_cubit.tags.isNotEmpty)
                    SizedBox(
                      child: _cubit.screenMode == ScreenMode.delete
                          ? TextButton(
                              onPressed: () {
                                _cubit.toggleDeleteMode();
                              },
                              child: Text(
                                LocaleKeys.cancel.tr(),
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          : ContainerCircleWidget(
                              color: Colors.red,
                              onPressed: () {
                                _cubit.toggleDeleteMode();
                              },
                              child: const Icon(CupertinoIcons.delete),
                            ),
                    )
                ],
              ).build(),
              body: _buildPage(context, state),
              bottomNavigationBar: _buildButtom(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, CategoryManagementState state) {
    final size = MediaQuery.of(context).size;
    return _cubit.tags.isEmpty
        ? Center(
            child: EmptyDataWidget(
              height: size.height * 0.45,
              width: 200,
              message: LocaleKeys.categoryEmpty.tr(),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  children: _cubit.tags
                      .map(
                        (e) => ContainerSelectWidget(
                          isSelect: _cubit.selected[e.id] ?? false,
                          margin: const EdgeInsets.only(top: 12, left: 12),
                          onChange: () {
                            _cubit.setSelect(e.id);
                          },
                          child: CategoryWidget(
                            icon: IconPickerUtils.getIcon(e.iconData),
                            model: e,
                          ),
                        ),
                      )
                      .toList(),
                ),
                Container(
                  height: DimensionsKeys.heightBts,
                ),
              ],
            ),
          );
  }

  Widget _buildButtom(BuildContext context, CategoryManagementState state) {
    return ButtonWidget(
      disabled: _cubit.screenMode == ScreenMode.delete && _cubit.selectedEmpty ? true : false,
      margin: const EdgeInsets.all(8),
      backgroundColor: _cubit.screenMode == ScreenMode.delete ? Colors.red : null,
      label: _cubit.screenMode == ScreenMode.delete
          ? LocaleKeys.delete.tr()
          : LocaleKeys.createCategory.tr().toUpperCase(),
      onPressed: () async {
        if (_cubit.screenMode == ScreenMode.display) {
          final result = await CreateCategoryRouter(context).navigate();

          if (result is CreateCategorySuccess) {
            _cubit.refresh();
          }
        } else if (_cubit.screenMode == ScreenMode.delete) {
          ConfirmDialogUiWidget(
            context,
            title: LocaleKeys.confirmDeleteTitle.tr(),
            desc: LocaleKeys.confirmDeleteDesc.tr(),
            confirmLabel: LocaleKeys.confirm.tr(),
            cancelLabel: LocaleKeys.cancel.tr(),
          ).show().then((value) {
            if (value == ConfirmDialogUiResult.ok) {
              _cubit.deleteSelected();
            }
          });
        }
      },
    );
  }
}
