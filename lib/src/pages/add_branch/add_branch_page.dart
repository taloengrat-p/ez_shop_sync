import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/add_branch/add_branch_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_branch/add_branch_router.dart';
import 'package:ez_shop_sync/src/pages/add_branch/add_branch_state.dart';
import 'package:ez_shop_sync/src/utils/dialog_utils.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AddBranchPage extends StatefulWidget {
  const AddBranchPage({super.key});

  @override
  _AddBranchState createState() => _AddBranchState();
}

class _AddBranchState extends State<AddBranchPage> {
  final _formKey = GlobalKey<FormState>();
  final _cubit = GetIt.I<AddBranchCubit>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddBranchCubit, AddBranchState>(
      bloc: _cubit,
      listener: (context, state) async {
        if (state is AddBranchSuccess) {
          await DialogUtils.showAlertDialog(
            context,
            type: AlertDialogType.success,
            title: LocaleKeys.addBranchPage_addBranchSuccess.tr(args: [state.branch.name]),
            barrierDismissible: false,
          );

          AddBranchRouter(context).pop();
        }
      },
      child: BlocBuilder<AddBranchCubit, AddBranchState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            isLoading: state is AddBranchLoading,
            appBar:
                AppbarWidget(
                  context,
                  centerTitle: false,
                  title: LocaleKeys.addBranchPage_title.tr(),
                  actions: [],
                ).build(),
            body: _buildPage(context, state),
            bottomNavigationBar: ButtonWidget(
              disabled: _cubit.name.isEmpty,
              margin: const EdgeInsets.all(16),
              label: LocaleKeys.confirm.tr(),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _cubit.submit();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, AddBranchState state) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppTextFormFieldUiWidget(
                label: LocaleKeys.addBranchPage_branchName.tr(),
                onChanged: _cubit.doSetName,
                isRequired: true,
                errorText: state is AddBranchFailure ? state.apiError?.error.toString() : null,
              ),
              Container(height: DimensionsKeys.heightBts),
            ],
          ),
        ),
      ),
    );
  }
}
