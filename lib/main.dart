import 'dart:async';
import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/services/inject_service/inject.dart';
import 'package:flutter/material.dart';
import 'app.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupConfiguration();
  runApp(const App());
}

void setupConfiguration() {
  configureDependencies(F.appFlavor!.name);
}
