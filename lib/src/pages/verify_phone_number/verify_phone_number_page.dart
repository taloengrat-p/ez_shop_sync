import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/verify_phone_number/verify_phone_number_cubit.dart';
import 'package:ez_shop_sync/src/pages/verify_phone_number/verify_phone_number_state.dart';
import 'package:ez_shop_sync/src/widgets/app_pin_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:get_it/get_it.dart';

class VerifyPhoneNumberPage extends StatefulWidget {
  const VerifyPhoneNumberPage({super.key});

  @override
  _VerifyPhoneNumberState createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumberPage> {
  final _cubit = GetIt.I<VerifyPhoneNumberCubit>();
  TextEditingController pinController = TextEditingController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      final argrument = ModalRoute.of(context)?.settings.arguments;

      if (argrument is VerifyPhoneNumberArgrument) {
        _cubit.initial(argrument);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyPhoneNumberCubit, VerifyPhoneNumberState>(
      bloc: _cubit,
      listener: (context, state) {},
      child: BlocBuilder<VerifyPhoneNumberCubit, VerifyPhoneNumberState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            appBar: AppbarWidget(context, color: Colors.transparent, iconThemeColor: Colors.black, actions: []).build(),
            body: AppPinWidget(
              token: _cubit.verificationId,
              controller: pinController,
              title: LocaleKeys.verifyPhoneNumber.tr(),
              onCompleted: _cubit.doVerify,
              onChanged: (value) {
                _cubit.refresh();
              },
              errorText: state is VerifyPhoneNumberFailure ? state.message : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, VerifyPhoneNumberState state) {
    return SingleChildScrollView(child: Column(children: [Container(height: DimensionsKeys.heightBts)]));
  }
}
