import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

@singleton
class NavigationService {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
