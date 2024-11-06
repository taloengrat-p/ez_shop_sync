import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_server_repository.dart';
import 'package:ez_shop_sync/src/pages/add_user/add_user_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_user/add_user_router.dart';
import 'package:ez_shop_sync/src/pages/add_user/add_user_state.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/utils/dialog_utils.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({
    super.key,
  });

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUserPage> {
  late AddUserCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = AddUserCubit(
      storeRepository: GetIt.I<StoreServerRepository>(),
      baseCubit: GetIt.I<BaseCubit>(),
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
      child: BlocListener<AddUserCubit, AddUserState>(
        listener: (context, state) async {
          if (state is AddUserSuccess) {
            await DialogUtils.showAlertDialog(
              context,
              title: 'Invite Success',
              barrierDismissible: false,
            );

            AddUserRouter(context).pop();
          }
        },
        child: BlocBuilder<AddUserCubit, AddUserState>(
          builder: (context, state) {
            return BaseScaffolds(
              isLoading: state is AddUserLoading,
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: "AddUser",
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
              label: 'Email',
              onChanged: _cubit.doSetEmail,
              errorText: state is AddUserFailure ? state.errorType?.label : null,
            ),
            Container(
              height: DimensionsKeys.heightBts,
            ),
          ],
        ),
      ),
    );
  }
}
