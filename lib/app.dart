import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/base/base_state.dart';
import 'package:ez_shop_sync/src/pages/introduce/introduce_page.dart';
import 'package:ez_shop_sync/src/pages/main/main_page.dart';
import 'package:ez_shop_sync/src/routes/routes.dart';
import 'package:ez_shop_sync/src/services/navigation_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import 'flavors.dart';

RouteObserver<PageRoute> routeAware = RouteObserver<PageRoute>();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  late BaseCubit baseCubit;
  @override
  void initState() {
    super.initState();
    baseCubit = BlocProvider.of<BaseCubit>(context);

    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      // if (result.contains(ConnectivityResult.none)) {
      //   baseCubit.changeMode(AppMode.local);
      // } else {
      //   baseCubit.changeMode(AppMode.server);
      // }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: F.title,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          textTheme: GoogleFonts.promptTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: MaterialColor(
              Colors.black.value,
              <int, Color>{
                50: Colors.black.withOpacity(0.05),
                100: Colors.black.withOpacity(0.1),
                200: Colors.black.withOpacity(0.2),
                300: Colors.black.withOpacity(0.3),
                400: Colors.black.withOpacity(0.4),
                500: Colors.black.withOpacity(0.5),
                600: Colors.black.withOpacity(0.6),
                700: Colors.black.withOpacity(0.7),
                800: Colors.black.withOpacity(0.8),
                900: Colors.black.withOpacity(0.9),
              },
            ),
          ).copyWith(),
          primarySwatch: Colors.blue,
        ),
        navigatorKey: GetIt.I<NavigationService>().navigatorKey,
        navigatorObservers: [routeAware],
        routes: Routes.values,
        home: _flavorBanner(
          child: BlocListener<BaseCubit, BaseState>(
            bloc: baseCubit,
            listener: (context, state) {
              log('[CUBIT][BASE] state : $state');
            },
            child: BlocBuilder<BaseCubit, BaseState>(
              bloc: baseCubit,
              builder: (context, state) {
                return Stack(
                  children: [
                    baseCubit.isIntroduceFlowDone.isNull
                        ? Container(
                            color: Colors.white,
                          )
                        : baseCubit.isIntroduceFlowDone!
                            ? const MainPage()
                            : const IntroduceFlowPage(),
                    if (state is BaseLoading)
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.6),
                        child: const Center(
                          child: CupertinoActivityIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          show: kDebugMode,
        ),
      ),
    );
  }

  Widget _flavorBanner({
    required Widget child,
    bool show = true,
  }) =>
      show
          ? Banner(
              location: BannerLocation.topStart,
              message: F.name,
              color: Colors.green.withOpacity(0.6),
              textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0, letterSpacing: 1.0),
              child: child,
            )
          : Container(
              child: child,
            );
}
