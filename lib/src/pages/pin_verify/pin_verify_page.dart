import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/pin_verify/pin_verify_cubit.dart';
import 'package:ez_shop_sync/src/pages/pin_verify/pin_verify_router.dart';
import 'package:ez_shop_sync/src/pages/pin_verify/pin_verify_state.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/widgets/app_pin_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:get_it/get_it.dart';

class PinVerifyPage extends StatefulWidget {
  const PinVerifyPage({
    Key? key,
  }) : super(key: key);

  @override
  _PinVerifyState createState() => _PinVerifyState();
}

class _PinVerifyState extends State<PinVerifyPage> {
  late PinVerifyCubit _cubit;
  TextEditingController pinController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _cubit = PinVerifyCubit(
      localStorageService: GetIt.I<LocalStorageService>(),
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
      child: BlocListener<PinVerifyCubit, PinVerifyState>(
        listener: (context, state) {
          if (state is PinVerifySuccess) {
            PinVerifyRouter(context).pop(state);
          } else if (state is PinVerifyClearByFailure) {
            pinController.clear();
            _cubit.displayFailure();
          }
        },
        child: BlocBuilder<PinVerifyCubit, PinVerifyState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                context,
                color: Colors.transparent,
                iconThemeColor: Colors.black,
                actions: [],
              ).build(),
              body: AppPinWidget(
                controller: pinController,
                title: LocaleKeys.verificationTitle.tr(),
                onCompleted: _cubit.doVerify,
                onChanged: (value) {
                  _cubit.refresh();
                },
                errorText: state is PinVerifyFailure ? LocaleKeys.verifyIsInvalid.tr() : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
