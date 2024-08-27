import 'dart:developer';

import 'package:ez_shop_sync/src/pages/pin_setup/pin_setup_cubit.dart';
import 'package:ez_shop_sync/src/pages/pin_setup/pin_setup_router.dart';
import 'package:ez_shop_sync/src/pages/pin_setup/pin_setup_state.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/widgets/app_pin_widget.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class PinSetupPage extends StatefulWidget {
  const PinSetupPage({
    Key? key,
  }) : super(key: key);

  @override
  _PinSetupState createState() => _PinSetupState();
}

class _PinSetupState extends State<PinSetupPage> {
  late PinSetupCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PinSetupCubit(
      localStorageService: GetIt.I<LocalStorageService>(),
    );

    WidgetsBinding.instance.addPostFrameCallback((time) {
      final argrument = ModalRoute.of(context)?.settings.arguments;
      if (argrument is PinSetupArgruments) {
        _cubit.setArgrument(argrument);
      }
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
      child: BlocListener<PinSetupCubit, PinSetupState>(
        listener: (context, state) {
          if (state is PinSetupAllSuccess) {
            PinSetupRouter(context).pop(state);
          }
        },
        child: BlocBuilder<PinSetupCubit, PinSetupState>(
          builder: (context, state) {
            return BaseScaffolds(
                appBar: AppbarWidget(
                  color: Colors.transparent,
                  iconThemeColor: Colors.black,
                ).build(),
                body: state is! PinSetupSuccess
                    ? AppPinWidget(
                        key: const ValueKey('create'),
                        title: _cubit.argrument?.title ?? 'Create PIN',
                        desc: _cubit.argrument?.desc ??
                            'Enter the code for setup PIN',
                        onCompleted: _cubit.setPin,
                      )
                    : AppPinWidget(
                        key: const ValueKey('confirm'),
                        title: 'Confirm PIN',
                        desc: 'Enter the confirm code PIN',
                        onCompleted: (value) {
                          log('onCompleted');
                          _cubit.setConfirmPin(value);
                        },
                        validator: (val) {
                          if (val != _cubit.pin &&
                              _cubit.pin.length == _cubit.confirm.length) {
                            return 'PIN Not match';
                          }

                          return null;
                        },
                      ));
          },
        ),
      ),
    );
  }
}
