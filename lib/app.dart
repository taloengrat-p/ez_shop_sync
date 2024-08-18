import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/introduce/introduce_page.dart';
import 'package:ez_shop_sync/src/pages/main/main_page.dart';
import 'package:ez_shop_sync/src/routes/routes.dart';
import 'package:ez_shop_sync/src/services/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'flavors.dart';

RouteObserver<PageRoute> routeAware = RouteObserver<PageRoute>();

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: F.title,
      theme: ThemeData(
        textTheme: GoogleFonts.promptTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      navigatorKey: GetIt.I<NavigationService>().navigatorKey,
      navigatorObservers: [routeAware],
      routes: Routes.values,
      home: _flavorBanner(
        child: BlocProvider(
          create: (context) => GetIt.I<BaseCubit>(),
          child: GetIt.I<BaseCubit>().isIntroduceFlowDone ? MainPage() : IntroduceFlowPage(),
        ),
        show: kDebugMode,
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
              textDirection: TextDirection.ltr,
              child: child,
            )
          : Container(
              child: child,
            );
}
