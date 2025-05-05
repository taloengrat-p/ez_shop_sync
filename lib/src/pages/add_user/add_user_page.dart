import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/role_type.enum.dart';
import 'package:ez_shop_sync/src/pages/add_user/add_user_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_user/add_user_router.dart';
import 'package:ez_shop_sync/src/pages/add_user/add_user_state.dart';
import 'package:ez_shop_sync/src/utils/dialog_utils.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/dropdown_select_item_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_dropdown_select_widget.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUserPage> {
  final _cubit = GetIt.I<AddUserCubit>();
  final _roleController = MultiSelectController<RoleType>();

  @override
  void initState() {
    super.initState();

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
    return BlocListener<AddUserCubit, AddUserState>(
      bloc: _cubit,
      listener: (context, state) async {
        if (state is AddUserSuccess) {
          await DialogUtils.showAlertDialog(context, title: 'Invite Success', barrierDismissible: false);

          AddUserRouter(context).pop();
        }
      },
      child: BlocBuilder<AddUserCubit, AddUserState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            isLoading: state is AddUserLoading,
            appBar:
                AppbarWidget(
                  context,
                  centerTitle: false,
                  title: LocaleKeys.addUserPage_title.tr(),
                  actions: [],
                ).build(),
            body: _buildPage(context, state),
            bottomNavigationBar: ButtonWidget(
              disabled: _cubit.email.isEmpty,
              margin: const EdgeInsets.all(16),
              label: LocaleKeys.confirm.tr(),
              onPressed: () {
                _cubit.submit();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, AddUserState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormFieldUiWidget(
              label: LocaleKeys.email.tr(),
              onChanged: _cubit.doSetEmail,
              errorText: state is AddUserFailure ? state.errorType?.label : null,
            ),
            TextFormFieldDropdownSelectWidget<RoleType>(
              controller: _roleController,
              singleSelect: true,
              itemSeparator: const Divider(),
              itemSelectd: _cubit.roleSelected,
              items:
                  RoleType.values.map((e) {
                    return DropdownItem<RoleType>(label: e.name, value: e, selected: false);
                  }).toList(),
              itemBuilder: (item, index, onTap) {
                return DropdownSelectItemWidget(selected: item.selected, onTap: onTap, child: Text(item.label));
              },
              selectedItemBuilder: (item) {
                return Container(margin: const EdgeInsets.only(top: 3), child: Text(item.label));
              },
              onSelectionChange: _cubit.setRoleSelect,
              label: LocaleKeys.optionalField.tr(args: [LocaleKeys.tags.tr()]),
            ),
            Container(height: DimensionsKeys.heightBts),
          ],
        ),
      ),
    );
  }
}
