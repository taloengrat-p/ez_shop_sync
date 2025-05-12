import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/add_branch/add_branch_router.dart';
import 'package:ez_shop_sync/src/pages/branch_detail_management/branch_detail_management_router.dart';
import 'package:ez_shop_sync/src/pages/branch_detail_management/branch_detail_management_state.dart';
import 'package:ez_shop_sync/src/pages/branch_management/branch_management_cubit.dart';
import 'package:ez_shop_sync/src/pages/branch_management/branch_management_state.dart';
import 'package:ez_shop_sync/src/services/toast_notification_service.dart';
import 'package:ez_shop_sync/src/utils/dialog_utils.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';

class BranchManagementPage extends StatefulWidget {
  const BranchManagementPage({super.key});

  @override
  _BranchManagementState createState() => _BranchManagementState();
}

class _BranchManagementState extends State<BranchManagementPage> {
  final _cubit = GetIt.I<BranchManagementCubit>();

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
    return BlocListener<BranchManagementCubit, BranchManagementState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is BranchManagementDeleteSuccess) {
          ToastNotificationService.show(
            title: LocaleKeys.branchDetailManagementPage_deleteBranchSuccess.tr(args: [state.branch.name]),
          );
        }
      },
      child: BlocBuilder<BranchManagementCubit, BranchManagementState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            isInitialLoading: state is BranchManagementLoading,
            isLoading: state is BranchManagementLoading,
            appBar:
                AppbarWidget(context, centerTitle: false, title: LocaleKeys.branchManagement.tr(), actions: []).build(),
            body: _buildPage(context, state),
            isEmpty: _cubit.branches.isEmpty,
            emptyIcon: CupertinoIcons.arrow_branch,
            emptyMessage: LocaleKeys.branchDetailManagementPage_branchEmpty.tr(),
            bottomNavigationBar: ButtonWidget(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              label: LocaleKeys.button_create.tr(),
              leading: const Icon(Icons.add_circle_outline_rounded),
              onPressed: () async {
                await AddBranchRouter(context).navigate();
                _cubit.refresh();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext appContext, BranchManagementState state) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _cubit.branches.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final branch = _cubit.branches[index];
        return GestureDetector(
          onTap: () {
            BranchDetailManagementRouter(context).navigate(argruments: BranchDetailManagementArgrument(branch));
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
                      _cubit.deleteBranch(branch);
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
            child: ListTile(
              title: Text(branch.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text(branch.members.length.toString()), const SizedBox(width: 8), Icon(Icons.person)],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(color: Colors.grey);
      },
    );
  }
}
