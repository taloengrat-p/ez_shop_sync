import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/constances/hive_box_constance.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/cart_item.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/member.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product_history.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/store.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/user.dart';
import 'package:ez_shop_sync/src/data/repository/auth/_local/auth_local_repository.dart';
import 'package:ez_shop_sync/src/data/repository/cart/cart_repository.dart';
import 'package:ez_shop_sync/src/data/repository/category/category_repository.dart';
import 'package:ez_shop_sync/src/data/repository/product/product_repository.dart';
import 'package:ez_shop_sync/src/data/repository/store/store_repository.dart';
import 'package:ez_shop_sync/src/data/repository/tag/tag_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/services/inject_service/inject.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/services/navigation_service.dart';
import 'package:ez_shop_sync/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'app.dart';

FutureOr<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await initialHiveDB();

  await setupConfiguration();

  await GetIt.I<LocalStorageService>().init();

  GetIt.instance.registerSingleton<BaseCubit>(
    BaseCubit(
      localStorageService: GetIt.I<LocalStorageService>(),
      authLocalRepository: GetIt.I<AuthLocalRepository>(),
      storeRepository: GetIt.I<StoreRepository>(),
      productRepository: GetIt.I<ProductRepository>(),
      navigationService: GetIt.I<NavigationService>(),
      tagRepository: GetIt.I<TagRepository>(),
      categoryRepository: GetIt.I<CategoryRepository>(),
      cartRepository: GetIt.I<CartRepository>(),
      userRepository: GetIt.I<UserRepository>(),
    ),
  );
  runApp(
    EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [ApplicationConstance.localeEN, ApplicationConstance.localeTH],
      fallbackLocale: ApplicationConstance.localeEN,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GetIt.I<BaseCubit>(),
          ),
        ],
        child: const App(),
      ),
    ),
  );
}

Future<void> setupConfiguration() async {
  configureDependencies(F.appFlavor!.name);
}

Future<void> initialHiveDB() async {
  final document = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(document.path);

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(MemberAdapter());
  Hive.registerAdapter(StoreAdapter());
  Hive.registerAdapter(ProductStatusAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(TagAdapter());
  Hive.registerAdapter(AppThemeAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(CartAdapter());
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(ProductHistoryAdapter());

  await Hive.openBox<Product>(HiveBoxConstance.product);
  await Hive.openBox<ProductHistory>(HiveBoxConstance.productHistory);
  await Hive.openBox<Store>(HiveBoxConstance.store);
  await Hive.openBox<User>(HiveBoxConstance.user);
  await Hive.openBox<Tag>(HiveBoxConstance.tag);
  await Hive.openBox<Category>(HiveBoxConstance.category);
  await Hive.openBox<Cart>(HiveBoxConstance.cart);
}
