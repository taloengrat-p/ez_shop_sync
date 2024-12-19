import 'package:ez_shop_sync/app.dart';
import 'package:ez_shop_sync/src/widgets/debug/debugger_dragable.dart';
import 'package:ez_shop_sync/src/widgets/overlay_loading_widget.dart';
import 'package:flutter/material.dart';

enum RouteAwareType {
  pop,
  popNext,
  push,
  pushNext;
}

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
  const BaseScaffolds({
    super.key,
    this.bottomNavigationBar,
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
  });

  @override
  _BaseScaffoldsState createState() => _BaseScaffoldsState();
}

class _BaseScaffoldsState extends State<BaseScaffolds> implements RouteAware {
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
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        gradient: widget.backgroundColor == null
            ? LinearGradient(
                colors: [
                  Colors.grey.shade800, // Start color
                  Colors.grey.shade900, // End color
                  Colors.black, // End color
                  Colors.black, // End color
                ],
                stops: const [0.1, 0.3, 0.5, 0.6],
                begin: Alignment.topLeft, // Gradient starting point
                end: Alignment.bottomRight, // Gradient ending point
              )
            : null,
        image: widget.imageDecoration,
      ),
      child: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: true,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              drawerScrimColor: Colors.white,
              appBar: widget.appBar,
              body: Stack(
                children: [
                  widget.body ?? Container(),
                  const DebuggerDragable(),
                ],
              ),
              bottomNavigationBar: widget.bottomNavigationBar,
              floatingActionButton: widget.floatingActionButton,
            ),
          ),
          if (widget.isLoading) const OverlayLoadingWidget(),
        ],
      ),
    );
  }
}
