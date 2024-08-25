import 'dart:async';

import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/data/repository/auth/_local/auth_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/services/inject_service/inject.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialHiveDB();

  await setupConfiguration();

  await GetIt.I<LocalStorageService>().init();

  GetIt.instance.registerSingleton<BaseCubit>(
    BaseCubit(
      localStorageService: GetIt.I<LocalStorageService>(),
      authLocalRepository: GetIt.I<AuthLocalRepository>(),
      storeRepository: GetIt.I<StoreRepository>(),
    ),
  );
  runApp(const App());
}

Future<void> setupConfiguration() async {
  configureDependencies(F.appFlavor!.name);
}

Future<void> initialHiveDB() async {
  final document = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(document.path);

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(StoreAdapter());
  Hive.registerAdapter(ProductStatusAdapter());
  Hive.registerAdapter(ProductAdapter());

  await Hive.openBox<Product>(HiveBoxConstance.product);
  await Hive.openBox<Store>(HiveBoxConstance.store);
  await Hive.openBox<User>(HiveBoxConstance.user);
}
