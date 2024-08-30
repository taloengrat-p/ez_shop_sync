import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/pages/profile_settings/profile_settings_cubit.dart';
import 'package:ez_shop_sync/src/pages/profile_settings/profile_settings_state.dart';   
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettingsPage> {
  late ProfileSettingsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ProfileSettingsCubit();

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
      child: BlocListener<ProfileSettingsCubit, ProfileSettingsState>(
        listener: (context, state) {},
        child: BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(context, 
                centerTitle: false,
                title: "ProfileSettings",
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

  Widget _buildPage(BuildContext context, ProfileSettingsState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    );
  }
}
