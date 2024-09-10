import 'package:ez_shop_sync/app.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/widgets/body/body_widget.dart';
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
  final Function(RouteAwareType type)? onRouteAware;
  const BaseScaffolds({
    super.key,
    this.bottomNavigationBar,
    this.body,
    this.appBar,
    this.floatingActionButton,
    this.textSystemUiOverlayStyleColor,
    this.onRouteAware,
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
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        drawerScrimColor: Colors.white,
        appBar: widget.appBar,
        body: widget.body,
        bottomNavigationBar: widget.bottomNavigationBar,
        floatingActionButton: widget.floatingActionButton,
      ),
    );
  }
}
