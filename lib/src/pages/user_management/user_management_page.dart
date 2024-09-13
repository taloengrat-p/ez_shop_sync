import 'package:ez_shop_sync/src/pages/user_management/user_management_cubit.dart';
import 'package:ez_shop_sync/src/pages/user_management/user_management_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({
    super.key,
  });

  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagementPage> {
  late UserManagementCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = UserManagementCubit();

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
      child: BlocListener<UserManagementCubit, UserManagementState>(
        listener: (context, state) {},
        child: BlocBuilder<UserManagementCubit, UserManagementState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: "UserManagement",
                actions: [],
              ).build(),
              body: SingleChildScrollView(
                child: _buildPage(context, state),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, UserManagementState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    );
  }
}
