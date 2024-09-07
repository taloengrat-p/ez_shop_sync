import 'package:ez_shop_sync/src/pages/password_setting/password_setting_cubit.dart';
import 'package:ez_shop_sync/src/pages/password_setting/password_setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';

class PasswordSettingPage extends StatefulWidget {
  const PasswordSettingPage({
    super.key,
  });

  @override
  _PasswordSettingState createState() => _PasswordSettingState();
}

class _PasswordSettingState extends State<PasswordSettingPage> {
  late PasswordSettingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PasswordSettingCubit();

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
      child: BlocListener<PasswordSettingCubit, PasswordSettingState>(
        listener: (context, state) {},
        child: BlocBuilder<PasswordSettingCubit, PasswordSettingState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: "PasswordSetting",
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

  Widget _buildPage(BuildContext context, PasswordSettingState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    );
  }
}
