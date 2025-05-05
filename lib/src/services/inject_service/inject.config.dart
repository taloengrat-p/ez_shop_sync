// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/repository/add_product/add_product_repository.dart' as _i13;
import '../../data/repository/add_product/local/add_product_local_repository.dart' as _i260;
import '../../data/repository/add_product/server/add_product_server_repository.dart' as _i529;
import '../../data/repository/add_product_history/add_product_history_repository.dart' as _i394;
import '../../data/repository/add_product_history/local/add_product_history_local_repository.dart' as _i764;
import '../../data/repository/add_product_history/server/add_product_history_server_repository.dart' as _i710;
import '../../data/repository/auth/auth_repository.dart' as _i214;
import '../../data/repository/auth/auth_server_repository.dart' as _i57;
import '../../data/repository/auth/local/auth_local_repository.dart' as _i551;
import '../../data/repository/auth/server/auth_server_repository.dart' as _i701;
import '../../data/repository/cart/cart_repository.dart' as _i999;
import '../../data/repository/cart/local/cart_local_repository.dart' as _i1034;
import '../../data/repository/cart/server/cart_server_repository.dart' as _i719;
import '../../data/repository/category/category_repository.dart' as _i635;
import '../../data/repository/category/local/category_local_repository.dart' as _i992;
import '../../data/repository/category/server/category_server_repository.dart' as _i997;
import '../../data/repository/image/local/image_local_repository.dart' as _i848;
import '../../data/repository/image/server/image_server_repository.dart' as _i580;
import '../../data/repository/notifications/local/notification_local_repository.dart' as _i676;
import '../../data/repository/notifications/notification_repository.dart' as _i155;
import '../../data/repository/notifications/server/dev_notification_server_repository.dart' as _i561;
import '../../data/repository/order/local/order_local_repository.dart' as _i49;
import '../../data/repository/order/order_repository.dart' as _i698;
import '../../data/repository/order/server/order_server_repository.dart' as _i843;
import '../../data/repository/product/local/product_local_repository.dart' as _i395;
import '../../data/repository/product/product_repository.dart' as _i846;
import '../../data/repository/product/server/product_server_repository.dart' as _i992;
import '../../data/repository/product_history/local/product_history_local_repository.dart' as _i485;
import '../../data/repository/product_history/product_history_repository.dart' as _i2;
import '../../data/repository/product_history/server/product_history_server_repository.dart' as _i750;
import '../../data/repository/store/local/dev_store_local_repository.dart' as _i457;
import '../../data/repository/store/server/dev_store_server_repository.dart' as _i18;
import '../../data/repository/store/store_repository.dart' as _i882;
import '../../data/repository/tag/local/tag_local_repository.dart' as _i295;
import '../../data/repository/tag/server/tag_server_repository.dart' as _i338;
import '../../data/repository/tag/tag_repository.dart' as _i505;
import '../../data/repository/transactions/local/transaction_local_repository.dart' as _i348;
import '../../data/repository/transactions/server/transaction_server_repository.dart' as _i620;
import '../../data/repository/transactions/transaction_repository.dart' as _i370;
import '../../data/repository/user/user_repository.dart' as _i118;
import '../../pages/_app/app_cubit.dart' as _i283;
import '../../pages/cart/cart_cubit.dart' as _i874;
import '../../pages/main/product/product_cubit.dart' as _i462;
import '../../pages/notification/notification_cubit.dart' as _i653;
import '../../utils/image_picker_utils.dart' as _i286;
import '../firebase_service.dart' as _i228;
import '../hivedb_service/hivedb_dev_service.dart' as _i1036;
import '../hivedb_service/hivedb_service.dart' as _i535;
import '../hivedb_service/hivedb_unittest_service.dart' as _i233;
import '../local_storage_service.dart/local_storage_dev_service.dart' as _i736;
import '../local_storage_service.dart/local_storage_service.dart' as _i461;
import '../local_storage_service.dart/local_storage_unittest.dart' as _i79;
import '../navigation_service.dart' as _i892;

const String _dev = 'dev';
const String _tests = 'tests';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt $init({String? environment, _i526.EnvironmentFilter? environmentFilter}) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i286.ImagePickerUtils>(() => _i286.ImagePickerUtils());
    gh.singleton<_i49.OrderLocalRepository>(() => _i49.OrderLocalRepository());
    gh.singleton<_i750.ProductHistoryServerRepository>(() => _i750.ProductHistoryServerRepository());
    gh.singleton<_i485.ProductHistoryLocalRepository>(() => _i485.ProductHistoryLocalRepository());
    gh.singleton<_i529.AddProductServerRepository>(() => _i529.AddProductServerRepository());
    gh.singleton<_i260.AddProductLocalRepository>(() => _i260.AddProductLocalRepository());
    gh.singleton<_i997.CategoryServerRepository>(() => _i997.CategoryServerRepository());
    gh.singleton<_i992.CategoryLocalRepository>(() => _i992.CategoryLocalRepository());
    gh.singleton<_i57.AuthServerRepository>(() => _i57.AuthServerRepository());
    gh.singleton<_i701.AuthServerRepository>(() => _i701.AuthServerRepository());
    gh.singleton<_i551.AuthLocalRepository>(() => _i551.AuthLocalRepository());
    gh.singleton<_i710.AddProductHistoryServerRepository>(() => _i710.AddProductHistoryServerRepository());
    gh.singleton<_i764.AddProductHistoryLocalRepository>(() => _i764.AddProductHistoryLocalRepository());
    gh.singleton<_i395.ProductLocalRepository>(() => _i395.ProductLocalRepository());
    gh.singleton<_i620.TransactionServerRepository>(() => _i620.TransactionServerRepository());
    gh.singleton<_i348.TransactionLocalRepository>(() => _i348.TransactionLocalRepository());
    gh.singleton<_i719.CartServerRepository>(() => _i719.CartServerRepository());
    gh.singleton<_i1034.CartLocalRepository>(() => _i1034.CartLocalRepository());
    gh.singleton<_i338.TagServerRepository>(() => _i338.TagServerRepository());
    gh.singleton<_i295.TagLocalRepository>(() => _i295.TagLocalRepository());
    gh.singleton<_i892.NavigationService>(() => _i892.NavigationService());
    gh.singleton<_i228.FirebaseService>(() => _i228.FirebaseService());
    gh.singleton<_i394.AddProductHistoryRepository>(
      () => _i394.AddProductHistoryRepository(
        addProductHistoryLocalRepository: gh<_i764.AddProductHistoryLocalRepository>(),
        addProductHistoryServerRepository: gh<_i710.AddProductHistoryServerRepository>(),
      ),
    );
    gh.singleton<_i635.CategoryRepository>(
      () => _i635.CategoryRepository(
        categoryLocalRepository: gh<_i992.CategoryLocalRepository>(),
        categoryServerRepository: gh<_i997.CategoryServerRepository>(),
      ),
    );
    gh.factory<_i457.StoreLocalRepository>(() => _i457.StoreLocalRepository(), registerFor: {_dev});
    gh.singleton<_i580.ImageServerRepository>(() => _i580.ImageServerRepository(), registerFor: {_dev});
    gh.singleton<_i848.ImageLocalRepository>(() => _i848.ImageLocalRepository(), registerFor: {_dev});
    gh.singleton<_i561.DevNotificationServerRepository>(
      () => _i561.DevNotificationServerRepository(),
      registerFor: {_dev},
    );
    gh.singleton<_i676.NotificationLocalRepository>(() => _i676.NotificationLocalRepository(), registerFor: {_dev});
    gh.singleton<_i535.HiveDBService>(() => _i233.HiveDBUnittestService(), registerFor: {_tests});
    gh.singleton<_i461.LocalStorageService>(() => _i79.LocalStorageUnittest(), registerFor: {_tests});
    gh.singleton<_i535.HiveDBService>(() => _i1036.HiveDBDevService(), registerFor: {_dev, _prod});
    gh.singleton<_i461.LocalStorageService>(() => _i736.LocalStorageDevService(), registerFor: {_dev, _prod});
    gh.singleton<_i370.TransactionRepository>(
      () => _i370.TransactionRepository(
        transactionLocalRepository: gh<_i348.TransactionLocalRepository>(),
        transactionServerRepository: gh<_i620.TransactionServerRepository>(),
      ),
    );
    gh.singleton<_i992.ProductServerRepository>(
      () => _i992.ProductServerRepository(firebaseService: gh<_i228.FirebaseService>()),
    );
    gh.singleton<_i155.NotificationRepository>(
      () => _i155.NotificationRepository(firebaseService: gh<_i228.FirebaseService>()),
    );
    gh.singleton<_i13.AddProductRepository>(
      () => _i13.AddProductRepository(
        addProductLocalRepository: gh<_i260.AddProductLocalRepository>(),
        addProductServerRepository: gh<_i529.AddProductServerRepository>(),
      ),
    );
    gh.singleton<_i505.TagRepository>(
      () => _i505.TagRepository(
        tagLocalRepository: gh<_i295.TagLocalRepository>(),
        tagServerRepository: gh<_i338.TagServerRepository>(),
      ),
    );
    gh.singleton<_i2.ProductHistoryRepository>(
      () => _i2.ProductHistoryRepository(
        productHistoryLocalRepository: gh<_i485.ProductHistoryLocalRepository>(),
        productHistoryServerRepository: gh<_i750.ProductHistoryServerRepository>(),
      ),
    );
    gh.singleton<_i846.ProductRepository>(
      () => _i846.ProductRepository(
        productLocalRepository: gh<_i395.ProductLocalRepository>(),
        productServerRepository: gh<_i992.ProductServerRepository>(),
        productHistoryRepository: gh<_i2.ProductHistoryRepository>(),
        transactionRepository: gh<_i370.TransactionRepository>(),
      ),
    );
    gh.singleton<_i999.CartRepository>(
      () => _i999.CartRepository(
        cartLocalRepository: gh<_i1034.CartLocalRepository>(),
        cartServerRepository: gh<_i719.CartServerRepository>(),
      ),
    );
    gh.singleton<_i118.UserRepository>(
      () => _i118.UserRepository(
        firebaseService: gh<_i228.FirebaseService>(),
        notificationRepository: gh<_i155.NotificationRepository>(),
      ),
    );
    gh.singleton<_i843.OrderServerRepository>(
      () => _i843.OrderServerRepository(
        firebaseService: gh<_i228.FirebaseService>(),
        productRepository: gh<_i846.ProductRepository>(),
      ),
    );
    gh.factory<_i18.StoreServerRepository>(
      () => _i18.StoreServerRepository(
        userRepository: gh<_i118.UserRepository>(),
        firebaseService: gh<_i228.FirebaseService>(),
        notificationRepository: gh<_i155.NotificationRepository>(),
      ),
      registerFor: {_dev},
    );
    gh.singleton<_i698.OrderRepository>(
      () => _i698.OrderRepository(
        orderLocalRepository: gh<_i49.OrderLocalRepository>(),
        orderServerRepository: gh<_i843.OrderServerRepository>(),
        cartRepository: gh<_i999.CartRepository>(),
        transactionRepository: gh<_i370.TransactionRepository>(),
      ),
    );
    gh.singleton<_i882.StoreRepository>(
      () => _i882.StoreRepository(
        storeLocalRepository: gh<_i457.StoreLocalRepository>(),
        storeServerRepository: gh<_i18.StoreServerRepository>(),
      ),
    );
    gh.singleton<_i283.AppCubit>(
      () => _i283.AppCubit(
        localStorageService: gh<_i461.LocalStorageService>(),
        authLocalRepository: gh<_i551.AuthLocalRepository>(),
        storeRepository: gh<_i882.StoreRepository>(),
        productRepository: gh<_i846.ProductRepository>(),
        navigationService: gh<_i892.NavigationService>(),
        tagRepository: gh<_i505.TagRepository>(),
        categoryRepository: gh<_i635.CategoryRepository>(),
        cartRepository: gh<_i999.CartRepository>(),
        userRepository: gh<_i118.UserRepository>(),
        addProductRepository: gh<_i13.AddProductRepository>(),
        notificationRepository: gh<_i155.NotificationRepository>(),
      ),
      registerFor: {_dev},
    );
    gh.factory<_i653.NotificationCubit>(() => _i653.NotificationCubit(appCubit: gh<_i283.AppCubit>()));
    gh.singleton<_i214.AuthRepository>(
      () => _i214.AuthRepository(
        authLocalRepository: gh<_i551.AuthLocalRepository>(),
        storeRepository: gh<_i882.StoreRepository>(),
        authServerRepository: gh<_i701.AuthServerRepository>(),
      ),
    );
    gh.factory<_i874.CartCubit>(
      () => _i874.CartCubit(
        cartRepository: gh<_i999.CartRepository>(),
        appCubit: gh<_i283.AppCubit>(),
        orderRepository: gh<_i698.OrderRepository>(),
        productRepository: gh<_i846.ProductRepository>(),
      ),
    );
    gh.factory<_i462.ProductCubit>(
      () => _i462.ProductCubit(productRepository: gh<_i846.ProductRepository>(), appCubit: gh<_i283.AppCubit>()),
    );
    return this;
  }
}
