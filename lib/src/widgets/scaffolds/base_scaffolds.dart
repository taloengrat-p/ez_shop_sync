import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/app.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/_app/app_state.dart';
import 'package:ez_shop_sync/src/widgets/debug/debugger_dragable.dart';
import 'package:ez_shop_sync/src/widgets/empty_data_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/row_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/overlay_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';

enum RouteAwareType { pop, popNext, push, pushNext }

class BaseScaffolds extends StatefulWidget {
  final Widget? bottomNavigationBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? appBar;
  final Colors? textSystemUiOverlayStyleColor;
  final bool isLoading;
  final Function(RouteAwareType type)? onRouteAware;
  final bool isInitialLoading;
  final Color? backgroundColor;
  final List<Colors>? backgroundColors;
  final DecorationImage? imageDecoration;
  final bool? enableAppModeDisplay;
  final bool canPop;
  final bool isEmpty;
  final IconData? emptyIcon;
  final Function()? onRefresh;
  final Function()? onLoading;
  final bool? isAppBarOverlay;
  final String? emptyMessage;

  const BaseScaffolds({
    this.emptyIcon,
    this.isEmpty = false,
    super.key,
    this.bottomNavigationBar,
    this.canPop = true,
    this.enableAppModeDisplay = true,
    this.body,
    this.appBar,
    this.floatingActionButton,
    this.textSystemUiOverlayStyleColor,
    this.onRouteAware,
    this.isLoading = false,
    this.isInitialLoading = false,
    this.backgroundColor,
    this.backgroundColors,
    this.imageDecoration,
    this.onLoading,
    this.onRefresh,
    this.isAppBarOverlay = false,
    this.emptyMessage,
  });

  @override
  _BaseScaffoldsState createState() => _BaseScaffoldsState();
}

class _BaseScaffoldsState extends State<BaseScaffolds> implements RouteAware {
  final appCubit = GetIt.I.get<AppCubit>();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeAware.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeAware.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    widget.onRouteAware?.call(RouteAwareType.pop);
  }

  @override
  void didPopNext() {
    widget.onRouteAware?.call(RouteAwareType.popNext);
  }

  @override
  void didPush() {
    widget.onRouteAware?.call(RouteAwareType.push);
  }

  @override
  void didPushNext() {
    widget.onRouteAware?.call(RouteAwareType.pushNext);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.canPop,
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          // gradient: widget.backgroundColor == null
          //     ? LinearGradient(
          //         colors: [
          //           Colors.grey.shade800, // Start color
          //           Colors.grey.shade900, // End color
          //           Colors.black, // End color
          //           Colors.black, // End color
          //         ],
          //         stops: const [0.1, 0.3, 0.5, 0.6],
          //         begin: Alignment.topLeft, // Gradient starting point
          //         end: Alignment.bottomRight, // Gradient ending point
          //       )
          //     : null,
          image: widget.imageDecoration,
        ),
        child: Stack(
          children: [
            SafeArea(
              top: false,
              bottom: true,
              child: Scaffold(
                extendBodyBehindAppBar: widget.isAppBarOverlay ?? false,
                backgroundColor: Colors.transparent,
                drawerScrimColor: Colors.white,
                appBar: widget.appBar,
                body: Stack(
                  children: [
                    Column(
                      children: [
                        BlocBuilder<AppCubit, AppState>(
                          bloc: appCubit,
                          builder: (context, state) {
                            if ((widget.enableAppModeDisplay ?? false) && appCubit.appMode == AppMode.local) {
                              return Container(
                                padding: const EdgeInsets.all(8),
                                width: double.infinity,
                                color: Colors.red.shade900,
                                child: Column(
                                  children: [
                                    RowGapWidget(
                                      gap: 8,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.wifi_off_outlined, color: Colors.white, size: 16),
                                        Text(appCubit.appMode.toString()),
                                        Text(
                                          LocaleKeys.offline_title.tr(),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      LocaleKeys.offline_desc.tr(),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                        Expanded(
                          child:
                              widget.isInitialLoading
                                  ? Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    color: Colors.white,
                                    child: Center(
                                      child: Stack(
                                        children: [
                                          Center(child: Lottie.asset('assets/loading.json')),
                                          Center(child: Image.asset('assets/images/logo.png', height: 100)),
                                        ],
                                      ),
                                    ),
                                  )
                                  : widget.isEmpty
                                  ? EmptyDataWidget(
                                    onRefresh: widget.onRefresh,
                                    onLoading: widget.onLoading,
                                    message: widget.emptyMessage ?? LocaleKeys.dataEmptyMessage.tr(),
                                    icon: widget.emptyIcon,
                                  )
                                  : widget.body ?? Container(),
                        ),
                      ],
                    ),
                    const DebuggerDragable(),
                  ],
                ),
                bottomNavigationBar: widget.isInitialLoading ? null : widget.bottomNavigationBar,
                floatingActionButton: widget.isInitialLoading ? null : widget.floatingActionButton,
              ),
            ),
            if (widget.isLoading) const OverlayLoadingWidget(),
          ],
        ),
      ),
    );
  }
}
