import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/add_product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/base_hive_data.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart' as et;
import 'package:ez_shop_sync/src/data/dto/hive_object/member.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/order_item.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_config.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_history.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_order.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_type.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/string_locale.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/transaction.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/unit_type.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user_data.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/services/inject_service/inject.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'firebase_options.dart';

// final CacheManager cacheManager = DefaultCacheManager();

FutureOr<void> main() async {
  // CachedNetworkImage.logLevel = CacheManagerLogLevel.verbose;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await EasyLocalization.ensureInitialized();

  await initialHiveDB();

  await setupConfiguration();

  await GetIt.I<LocalStorageService>().init();

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [ApplicationConstance.localeEN, ApplicationConstance.localeTH],
      fallbackLocale: ApplicationConstance.localeEN,
      child: MultiBlocProvider(providers: [BlocProvider.value(value: GetIt.I<AppCubit>())], child: const App()),
    ),
  );
}

Future<void> setupConfiguration() async {
  log('env ${F.appFlavor.name}');

  await dotenv.load(fileName: kReleaseMode ? "assets/envs/.env" : "assets/envs/.env.${F.appFlavor.name}");

  final appEnv = dotenv.get("ENV");

  log('appEnv $appEnv');

  configureDependencies(F.appFlavor.name);
  log('configureDependencies');
}

Future<void> initialHiveDB() async {
  final document = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(document.path);

  Hive.registerAdapter(UserDataAdapter());
  Hive.registerAdapter(MemberAdapter());
  Hive.registerAdapter(StoreAdapter());
  Hive.registerAdapter(ProductStatusAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(ProductConfigAdapter());
  Hive.registerAdapter(TagAdapter());
  Hive.registerAdapter(AppThemeAdapter());
  Hive.registerAdapter(et.CategoryAdapter());
  Hive.registerAdapter(ProductOrderAdapter());
  Hive.registerAdapter(CartAdapter());
  Hive.registerAdapter(OrderItemAdapter());
  Hive.registerAdapter(ProductHistoryAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(AddProductAdapter());
  Hive.registerAdapter(ProductTypeAdapter());
  Hive.registerAdapter(UnitTypeAdapter());
  Hive.registerAdapter(StringLocaleAdapter());
  Hive.registerAdapter(BaseHiveDataAdapter());
  // Hive.registerAdapter(adapter)

  await Hive.openBox<Product>(HiveBoxConstance.product);
  await Hive.openBox<ProductHistory>(HiveBoxConstance.productHistory);
  await Hive.openBox<Store>(HiveBoxConstance.store);
  await Hive.openBox<UserData>(HiveBoxConstance.user);
  await Hive.openBox<Tag>(HiveBoxConstance.tag);
  await Hive.openBox<et.Category>(HiveBoxConstance.category);
  await Hive.openBox<Cart>(HiveBoxConstance.cart);
  await Hive.openBox<ProductOrder>(HiveBoxConstance.order);
  await Hive.openBox<Transaction>(HiveBoxConstance.transaction);
  await Hive.openBox<AddProduct>(HiveBoxConstance.addProduct);
  await Hive.openBox<AddProduct>(HiveBoxConstance.addProductHistory);
}
