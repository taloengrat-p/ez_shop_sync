import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/add_user/add_user_router.dart';
import 'package:ez_shop_sync/src/pages/user_management/user_management_cubit.dart';
import 'package:ez_shop_sync/src/pages/user_management/user_management_state.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/profile_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagementPage> {
  final _cubit = GetIt.I<UserManagementCubit>();

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
    return BlocListener<UserManagementCubit, UserManagementState>(
      bloc: _cubit,
      listener: (context, state) {},
      child: BlocBuilder<UserManagementCubit, UserManagementState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            appBar:
                AppbarWidget(context, centerTitle: false, title: LocaleKeys.userManagement.tr(), actions: []).build(),
            body: SingleChildScrollView(child: _buildPage(context, state)),
            bottomNavigationBar: ButtonWidget(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              label: 'Add',
              leading: const Icon(Icons.add_circle_outline_rounded),
              onPressed: () {
                AddUserRouter(context).navigate();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, UserManagementState state) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _cubit.members.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final member = _cubit.members[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Flexible(
                child: ProfileWidget(
                  name: member.email,
                  title: member.email,
                  desc: member.role,
                  nameStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black87),
                  descStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(color: Colors.grey);
      },
    );
  }
}
