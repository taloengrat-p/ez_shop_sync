import 'dart:developer';

import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/_app/app_state.dart';
import 'package:ez_shop_sync/src/pages/login/login_router.dart';
import 'package:ez_shop_sync/src/pages/main/main_router.dart';
import 'package:ez_shop_sync/src/pages/splash/splash_cubit.dart';
import 'package:ez_shop_sync/src/pages/splash/splash_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  final _cubit = GetIt.I<SplashCubit>();

  @override
  void initState() {
    log('initState()', name: runtimeType.toString());
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      log('addPostFrameCallback()', name: runtimeType.toString());
      _cubit.initial();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppCubit, AppState>(
          bloc: _cubit.appCubit,
          listener: (context, state) {
            log('state app cubit : $state', name: runtimeType.toString());
            if (state is AppGetAllDataStarterSuccess) {
              MainRouter(context).replace();
            } else if (state is AppGetAllDataStarterFailure) {
              LoginRouter(context).replace();
            }
          },
        ),
        BlocListener<SplashCubit, SplashState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is SplashFailure) {
              LoginRouter(context).replace();
            }
          },
        ),
      ],
      child: BlocBuilder<AppCubit, AppState>(
        bloc: _cubit.appCubit,
        builder: (context, state) {
          return Center(child: _buildPage(context, state));
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, AppState state) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.all(32),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Image.asset('assets/images/logo_outlined.png'),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...[
                if (_cubit.appCubit.user != null) const SizedBox(height: 24),
                AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  height: _cubit.appCubit.user != null ? null : 0,
                  child: Visibility(
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    maintainSemantics: true,
                    maintainInteractivity: true,
                    visible: _cubit.appCubit.user != null,
                    child: const CupertinoActivityIndicator(radius: 12, color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
