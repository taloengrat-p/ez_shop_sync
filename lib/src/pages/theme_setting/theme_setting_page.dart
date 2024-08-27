import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/pages/theme_setting/theme_setting_cubit.dart';
import 'package:ez_shop_sync/src/pages/theme_setting/theme_setting_state.dart';   
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';

class ThemeSettingPage extends StatefulWidget {
  const ThemeSettingPage({
    Key? key,
  }) : super(key: key);

  @override
  _ThemeSettingState createState() => _ThemeSettingState();
}

class _ThemeSettingState extends State<ThemeSettingPage> {
  late ThemeSettingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ThemeSettingCubit();

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
      child: BlocListener<ThemeSettingCubit, ThemeSettingState>(
        listener: (context, state) {},
        child: BlocBuilder<ThemeSettingCubit, ThemeSettingState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                centerTitle: false,
                title: "ThemeSetting",
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

  Widget _buildPage(BuildContext context, ThemeSettingState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    );
  }
}
