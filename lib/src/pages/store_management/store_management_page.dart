import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_cubit.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_router.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_state.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/column_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:toastification/toastification.dart';

class StoreManagementPage extends StatefulWidget {
  const StoreManagementPage({
    Key? key,
  }) : super(key: key);

  @override
  _StoreManagementState createState() => _StoreManagementState();
}

class _StoreManagementState extends State<StoreManagementPage> {
  late StoreManagementCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = StoreManagementCubit(
      storeRepository: GetIt.I<StoreRepository>(),
      baseCubit: GetIt.I<BaseCubit>(),
      userRepository: GetIt.I<UserRepository>(),
    );

    WidgetsBinding.instance.addPostFrameCallback((time) {
      _cubit.initial();
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
      child: BlocListener<StoreManagementCubit, StoreManagementState>(
        listener: (context, state) {
          if (state is StoreManagementDeleteSuccess) {
            StoreManagementRouter(context).pop(state);
          }
        },
        child: BlocBuilder<StoreManagementCubit, StoreManagementState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: LocaleKeys.storeManagement.tr(),
                actions: [
                  if (_cubit.screenMode == ScreenMode.edit)
                    TextButton(
                      child: Text(LocaleKeys.cancel.tr()),
                      onPressed: () {
                        _cubit.doCancelEdit();
                      },
                    ),
                  if (_cubit.screenMode == ScreenMode.display) ...[
                    ContainerCircleWidget(
                      onPressed: _cubit.doEdit,
                      child: const Icon(
                        Icons.edit,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ContainerCircleWidget(
                      color: Colors.red,
                      child: const Icon(
                        CupertinoIcons.delete,
                      ),
                      onPressed: () async {
                        final result = await ConfirmDialogUiWidget(
                          context,
                          title: 'ลบร้านค้า',
                          desc: 'ยืนยันการลบ',
                          confirmColor: Colors.red,
                        ).show();

                        if (result == ConfirmDialogUiResult.ok) {
                          _cubit.doDelete();
                        }
                      },
                    ),
                  ],
                ],
              ).build(),
              body: _buildPage(context, state),
              bottomNavigationBar: ButtonWidget(
                margin: const EdgeInsets.symmetric(
                  horizontal: DimensionsKeys.pagePaddingHzt,
                  vertical: DimensionsKeys.l,
                ),
                label: LocaleKeys.button_save.tr(),
                onPressed: () {
                  _cubit.doSave();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, StoreManagementState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: DimensionsKeys.pagePaddingVt,
        horizontal: DimensionsKeys.pagePaddingHzt,
      ),
      child: SingleChildScrollView(
        child: ColumnGapWidget(
          gap: 8,
          children: [
            TextFormFieldUiWidget(
              readOnly: _cubit.screenMode == ScreenMode.display,
              label: LocaleKeys.name.tr(),
              textValue: _cubit.nameEditor,
              onChanged: _cubit.doSetName,
            ),
            TextFormFieldUiWidget(
              readOnly: _cubit.screenMode == ScreenMode.display,
              label: LocaleKeys.description.tr(),
              textValue: _cubit.descEditor,
              onChanged: _cubit.doSetDesc,
            ),
            TextFormFieldUiWidget(
              readOnly: true,
              label: LocaleKeys.owner.tr(),
              textInitial: _cubit.ownerName,
              textValue: _cubit.ownerName,
            ),
            TextFormFieldUiWidget(
              readOnly: true,
              label: LocaleKeys.dateTimeCreated.tr(),
              textValue: _cubit.store?.createDate?.toDisplayDependLocale(context) ?? '',
            ),
            TextFormFieldUiWidget(
              readOnly: true,
              label: LocaleKeys.dateTimeUpdated.tr(),
              textValue: _cubit.store?.updateDate?.toDisplayDependLocale(context) ?? '',
            ),
          ],
        ),
      ),
    );
  }
}


// child: ButtonWidget(
//             label: 'pick',
//             onPressed: () {
//               showCurrencyPicker(
//                 context: context,
//                 showFlag: true,
//                 showCurrencyName: true,
//                 showCurrencyCode: true,
//                 onSelect: (Currency currency) {
//                   print('Select currency: ${currency.symbol}');
//                 },
//               );
//             },
//           ),