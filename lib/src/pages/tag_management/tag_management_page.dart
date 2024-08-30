import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_tag/create_tag_router.dart';
import 'package:ez_shop_sync/src/pages/create_tag/create_tag_state.dart';
import 'package:ez_shop_sync/src/pages/tag_management/tag_management_cubit.dart';
import 'package:ez_shop_sync/src/pages/tag_management/tag_management_state.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_select_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
import 'package:ez_shop_sync/src/widgets/empty_data_widget.dart';
import 'package:ez_shop_sync/src/widgets/tag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:get_it/get_it.dart';

class TagManagementPage extends StatefulWidget {
  const TagManagementPage({
    Key? key,
  }) : super(key: key);

  @override
  _TagManagementState createState() => _TagManagementState();
}

class _TagManagementState extends State<TagManagementPage> {
  late TagManagementCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = TagManagementCubit(
      baseCubit: GetIt.I<BaseCubit>(),
      storeRepository: GetIt.I<StoreRepository>(),
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
      child: BlocListener<TagManagementCubit, TagManagementState>(
        listener: (context, state) {},
        child: BlocBuilder<TagManagementCubit, TagManagementState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(context, 
                centerTitle: false,
                title: "Tag Management",
                actions: [
                  if (_cubit.tags.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        _cubit.toggleDeleteMode();
                      },
                      icon: _cubit.screenMode == ScreenMode.delete
                          ? const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            )
                          : const Icon(CupertinoIcons.delete),
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

  Widget _buildPage(BuildContext context, TagManagementState state) {
    final size = MediaQuery.of(context).size;
    return _cubit.tags.isEmpty
        ? Center(
            child: EmptyDataWidget(
              height: size.height * 0.45,
              width: 200,
              message: LocaleKeys.tagEmpty.tr(),
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
                          child: TagWidget(model: e),
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

  Widget _buildButtom(BuildContext context, TagManagementState state) {
    return ButtonWidget(
      disabled: _cubit.screenMode == ScreenMode.delete && _cubit.selectedEmpty
          ? true
          : false,
      margin: const EdgeInsets.all(8),
      backgroundColor:
          _cubit.screenMode == ScreenMode.delete ? Colors.red : null,
      label: _cubit.screenMode == ScreenMode.delete ? 'DELETE' : 'ADD TAG',
      onPressed: () async {
        if (_cubit.screenMode == ScreenMode.display) {
          final result = await CreateTagRouter(context).navigate();

          if (result is CreateTagSuccess) {
            _cubit.refresh();
          }
        } else if (_cubit.screenMode == ScreenMode.delete) {
          ConfirmDialogUiWidget(
            context,
            title: 'Confirm Delete',
            confirmLabel: 'Confirm',
            cancelLabel: 'Cancel',
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
