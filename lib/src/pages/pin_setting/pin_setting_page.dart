import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/pages/pin_setting/pin_setting_cubit.dart';
import 'package:ez_shop_sync/src/pages/pin_setting/pin_setting_state.dart';   
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';

class PinSettingPage extends StatefulWidget {
  const PinSettingPage({
    Key? key,
  }) : super(key: key);

  @override
  _PinSettingState createState() => _PinSettingState();
}

class _PinSettingState extends State<PinSettingPage> {
  late PinSettingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PinSettingCubit();

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
      child: BlocListener<PinSettingCubit, PinSettingState>(
        listener: (context, state) {},
        child: BlocBuilder<PinSettingCubit, PinSettingState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                centerTitle: false,
                title: "PinSetting",
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

  Widget _buildPage(BuildContext context, PinSettingState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    );
  }
}
