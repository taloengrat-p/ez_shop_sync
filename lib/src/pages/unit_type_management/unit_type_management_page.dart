import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/unit_type.dart';
import 'package:ez_shop_sync/src/pages/branch_management/branch_management_state.dart';
import 'package:ez_shop_sync/src/pages/unit_type_management/unit_type_management_cubit.dart';
import 'package:ez_shop_sync/src/pages/unit_type_management/unit_type_management_state.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:ez_shop_sync/src/utils/bottom_sheet_utils.dart';
import 'package:ez_shop_sync/src/utils/dialog_utils.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/bottoms/bottom_sheet_create_unit_type.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/unit_type_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';

class UnitTypeManagementPage extends StatefulWidget {
  const UnitTypeManagementPage({super.key});

  @override
  _UnitTypeManagementState createState() => _UnitTypeManagementState();
}

class _UnitTypeManagementState extends State<UnitTypeManagementPage> {
  final _cubit = GetIt.I<UnitTypeManagementCubit>();

  @override
  void initState() {
    super.initState();
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
    return BlocListener<UnitTypeManagementCubit, UnitTypeManagementState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is UnitTypeManagementDeleteSuccess) {
          ToastNotificationService.show(
            title: LocaleKeys.branchDetailManagementPage_deleteBranchSuccess.tr(
              args: [state.unitType.name.tr(context)],
            ),
          );
        }
      },
      child: BlocBuilder<UnitTypeManagementCubit, UnitTypeManagementState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            isInitialLoading: state is BranchManagementLoading,
            isLoading: state is BranchManagementLoading,
            appBar:
                AppbarWidget(
                  context,
                  centerTitle: false,
                  title: LocaleKeys.unitTypeManagement.tr(),
                  actions: [],
                ).build(),
            body: _buildPage(context, state),
            isEmpty: _cubit.unitTypes.isEmpty,
            emptyIcon: Icons.upcoming_outlined,
            emptyMessage: LocaleKeys.branchDetailManagementPage_branchEmpty.tr(),
            bottomNavigationBar: ButtonWidget(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              label: LocaleKeys.button_create.tr(),
              leading: const Icon(Icons.add_circle_outline_rounded),
              onPressed: () async {
                final result = await BottomSheetUtils.openUnitTypeBottomSheet(context);

                if (result is UnitType) {
                  _cubit.createUnitType(result);
                }
                // _cubit.refresh();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext appContext, UnitTypeManagementState state) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _cubit.unitTypes.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final unitType = _cubit.unitTypes.elementAtOrNull(index);
        return GestureDetector(
          onTap: () async {
            final result = await BottomSheetUtils.openUnitTypeBottomSheet(context, value: unitType);

            if (result is UnitType) {
              _cubit.editUnitType(result);
            }
          },
          child: Slidable(
            closeOnScroll: true,
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    final result = await DialogUtils.showConfirmDelete(appContext);

                    if (result == ConfirmDialogResult.ok) {
                      _cubit.deleteBranch(unitType);
                    }
                  },
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: CupertinoIcons.delete,
                ),
                const SizedBox(width: 0.5),
                SlidableAction(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  icon: CupertinoIcons.pencil,
                  onPressed: (context) {},
                ),
              ],
            ),
            child: UnitTypeWidget(key: ValueKey('transaction-item-${unitType?.id}'), unitType: unitType),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(color: Colors.grey);
      },
    );
  }
}
