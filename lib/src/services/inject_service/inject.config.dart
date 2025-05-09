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
import '../../data/repository/add_product/local/i_add_product_local_repository.dart'
    as _i902;
import '../../data/repository/add_product/local/impl/hivedb_add_product_local_repository.dart'
    as _i370;
import '../../data/repository/add_product/server/i_add_product_server_repository.dart'
    as _i141;
import '../../data/repository/add_product/server/impl/firestore_add_product_server_repository.dart'
    as _i735;
import '../../data/repository/add_product_history/add_product_history_repository.dart'
    as _i394;
import '../../data/repository/add_product_history/local/add_product_history_local_repository.dart'
    as _i764;
import '../../data/repository/add_product_history/server/add_product_history_server_repository.dart'
    as _i710;
import '../../data/repository/auth/auth_repository.dart' as _i214;
import '../../data/repository/auth/auth_server_repository.dart' as _i57;
import '../../data/repository/auth/local/auth_local_repository.dart' as _i551;
import '../../data/repository/auth/server/auth_server_repository.dart' as _i701;
import '../../data/repository/cart/cart_repository.dart' as _i999;
import '../../data/repository/cart/local/i_cart_local_repository.dart' as _i544;
import '../../data/repository/cart/local/impl/hivedb_cart_local_repository.dart'
    as _i723;
import '../../data/repository/cart/server/i_cart_server_repository.dart'
    as _i167;
import '../../data/repository/cart/server/impl/firestore_cart_server_repository.dart'
    as _i1000;
import '../../data/repository/category/category_repository.dart' as _i635;
import '../../data/repository/category/local/category_local_repository.dart'
    as _i992;
import '../../data/repository/category/server/category_server_repository.dart'
    as _i997;
import '../../data/repository/image/image_repository.dart' as _i678;
import '../../data/repository/image/server/i_image_server_repository.dart'
    as _i830;
import '../../data/repository/image/server/impl/firebase_storage_image_server_repository.dart'
    as _i656;
import '../../data/repository/notifications/local/notification_local_repository.dart'
    as _i676;
import '../../data/repository/notifications/notification_repository.dart'
    as _i155;
import '../../data/repository/notifications/server/dev_notification_server_repository.dart'
    as _i561;
import '../../data/repository/order/local/order_local_repository.dart' as _i49;
import '../../data/repository/order/order_repository.dart' as _i698;
import '../../data/repository/order/server/order_server_repository.dart'
    as _i843;
import '../../data/repository/product/local/i_product_local_repository.dart'
    as _i448;
import '../../data/repository/product/local/impl/hivedb_product_local_repository.dart'
    as _i131;
import '../../data/repository/product/product_repository.dart' as _i846;
import '../../data/repository/product/server/i_product_server_repository.dart'
    as _i592;
import '../../data/repository/product/server/impl/firestore_product_repository.dart'
    as _i78;
import '../../data/repository/product_history/local/product_history_local_repository.dart'
    as _i485;
import '../../data/repository/product_history/product_history_repository.dart'
    as _i2;
import '../../data/repository/product_history/server/product_history_server_repository.dart'
    as _i750;
import '../../data/repository/store/local/dev_store_local_repository.dart'
    as _i457;
import '../../data/repository/store/server/dev_store_server_repository.dart'
    as _i18;
import '../../data/repository/store/store_repository.dart' as _i882;
import '../../data/repository/tag/local/tag_local_repository.dart' as _i295;
import '../../data/repository/tag/server/tag_server_repository.dart' as _i338;
import '../../data/repository/tag/tag_repository.dart' as _i505;
import '../../data/repository/transactions/local/transaction_local_repository.dart'
    as _i348;
import '../../data/repository/transactions/server/transaction_server_repository.dart'
    as _i620;
import '../../data/repository/transactions/transaction_repository.dart'
    as _i370;
import '../../data/repository/user/user_repository.dart' as _i118;
import '../../pages/_app/app_cubit.dart' as _i283;
import '../../pages/add_product/add_product_cubit.dart' as _i294;
import '../../pages/add_product_history/add_product_history_cubit.dart'
    as _i427;
import '../../pages/add_product_history_detail/add_product_history_detail_cubit.dart'
    as _i734;
import '../../pages/add_user/add_user_cubit.dart' as _i853;
import '../../pages/cart/cart_cubit.dart' as _i874;
import '../../pages/category_management/category_management_cubit.dart'
    as _i647;
import '../../pages/create_category/create_category_cubit.dart' as _i1028;
import '../../pages/create_product/create_product_cubit.dart' as _i75;
import '../../pages/create_product_detail/create_product_detail_cubit.dart'
    as _i415;
import '../../pages/create_store/create_store_cubit.dart' as _i272;
import '../../pages/create_tag/create_tag_cubit.dart' as _i419;
import '../../pages/introduce/introduce_cubit.dart' as _i213;
import '../../pages/login/login_cubit.dart' as _i377;
import '../../pages/main/home/home_cubit.dart' as _i853;
import '../../pages/main/main_cubit.dart' as _i301;
import '../../pages/main/more/more_cubit.dart' as _i758;
import '../../pages/main/product/product_cubit.dart' as _i462;
import '../../pages/main/statistic/statistic_cubit.dart' as _i948;
import '../../pages/main/transaction/transaction_cubit.dart' as _i179;
import '../../pages/notification/notification_cubit.dart' as _i653;
import '../../pages/notification_detail/notification_detail_cubit.dart' as _i18;
import '../../pages/order_complete/order_complete_cubit.dart' as _i315;
import '../../pages/order_history/order_history_cubit.dart' as _i867;
import '../../pages/order_history_detail/order_history_detail_cubit.dart'
    as _i150;
import '../../pages/password_setting/password_setting_cubit.dart' as _i694;
import '../../pages/pin_setup/pin_setup_cubit.dart' as _i306;
import '../../pages/pin_verify/pin_verify_cubit.dart' as _i1048;
import '../../pages/product_detail/product_detail_cubit.dart' as _i305;
import '../../pages/product_settings/product_settings_cubit.dart' as _i717;
import '../../pages/profile_settings/profile_settings_cubit.dart' as _i560;
import '../../pages/store_management/store_management_cubit.dart' as _i468;
import '../../pages/tag_management/tag_management_cubit.dart' as _i277;
import '../../pages/theme_setting/theme_setting_cubit.dart' as _i524;
import '../../pages/transaction_statement_detail/transaction_statement_detail_cubit.dart'
    as _i721;
import '../../pages/transactions_chart_details/transactions_chart_details_cubit.dart'
    as _i924;
import '../../pages/user_management/user_management_cubit.dart' as _i304;
import '../../pages/verify_phone_number/verify_phone_number_cubit.dart'
    as _i156;
import '../../utils/image_picker_utils.dart' as _i286;
import '../firebase_service.dart' as _i228;
import '../hivedb_service/hivedb_dev_service.dart' as _i1036;
import '../hivedb_service/hivedb_service.dart' as _i535;
import '../hivedb_service/hivedb_unittest_service.dart' as _i233;
import '../local_storage_service.dart/local_storage_dev_service.dart' as _i736;
import '../local_storage_service.dart/local_storage_service.dart' as _i461;
import '../navigation_service.dart' as _i892;

const String _dev = 'dev';
const String _tests = 'tests';
const String _prod = 'prod';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt $init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i721.TransactionStatementDetailCubit>(
        () => _i721.TransactionStatementDetailCubit());
    gh.factory<_i734.AddProductHistoryDetailCubit>(
        () => _i734.AddProductHistoryDetailCubit());
    gh.factory<_i694.PasswordSettingCubit>(() => _i694.PasswordSettingCubit());
    gh.factory<_i717.ProductSettingsCubit>(() => _i717.ProductSettingsCubit());
    gh.factory<_i156.VerifyPhoneNumberCubit>(
        () => _i156.VerifyPhoneNumberCubit());
    gh.factory<_i415.CreateProductDetailCubit>(
        () => _i415.CreateProductDetailCubit());
    gh.singleton<_i286.ImagePickerUtils>(() => _i286.ImagePickerUtils());
    gh.singleton<_i49.OrderLocalRepository>(() => _i49.OrderLocalRepository());
    gh.singleton<_i750.ProductHistoryServerRepository>(
        () => _i750.ProductHistoryServerRepository());
    gh.singleton<_i485.ProductHistoryLocalRepository>(
        () => _i485.ProductHistoryLocalRepository());
    gh.singleton<_i997.CategoryServerRepository>(
        () => _i997.CategoryServerRepository());
    gh.singleton<_i992.CategoryLocalRepository>(
        () => _i992.CategoryLocalRepository());
    gh.singleton<_i57.AuthServerRepository>(() => _i57.AuthServerRepository());
    gh.singleton<_i701.AuthServerRepository>(
        () => _i701.AuthServerRepository());
    gh.singleton<_i551.AuthLocalRepository>(() => _i551.AuthLocalRepository());
    gh.singleton<_i620.TransactionServerRepository>(
        () => _i620.TransactionServerRepository());
    gh.singleton<_i348.TransactionLocalRepository>(
        () => _i348.TransactionLocalRepository());
    gh.singleton<_i338.TagServerRepository>(() => _i338.TagServerRepository());
    gh.singleton<_i295.TagLocalRepository>(() => _i295.TagLocalRepository());
    gh.singleton<_i892.NavigationService>(() => _i892.NavigationService());
    gh.singleton<_i228.FirebaseService>(() => _i228.FirebaseService());
    gh.singleton<_i635.CategoryRepository>(() => _i635.CategoryRepository(
          categoryLocalRepository: gh<_i992.CategoryLocalRepository>(),
          categoryServerRepository: gh<_i997.CategoryServerRepository>(),
          navigationService: gh<_i892.NavigationService>(),
        ));
    gh.singleton<_i155.NotificationRepository>(
        () => _i155.NotificationRepository(
              firebaseService: gh<_i228.FirebaseService>(),
              navigationService: gh<_i892.NavigationService>(),
            ));
    gh.singleton<_i461.LocalStorageService>(
        () => _i736.LocalStorageDevService());
    gh.factory<_i448.IProductLocalRepository>(
      () => _i131.HivedbProductLocalRepository(),
      registerFor: {
        _dev,
        _tests,
        _prod,
      },
    );
    gh.singleton<_i141.IAddProductServerRepository>(
      () => _i735.FirestoreAddProductServerRepository(),
      registerFor: {
        _dev,
        _prod,
        _tests,
      },
    );
    gh.factory<_i457.StoreLocalRepository>(
      () => _i457.StoreLocalRepository(),
      registerFor: {_dev},
    );
    gh.singleton<_i710.AddProductHistoryServerRepository>(
      () => _i710.AddProductHistoryServerRepository(),
      registerFor: {_dev},
    );
    gh.singleton<_i764.AddProductHistoryLocalRepository>(
      () => _i764.AddProductHistoryLocalRepository(),
      registerFor: {_dev},
    );
    gh.singleton<_i561.DevNotificationServerRepository>(
      () => _i561.DevNotificationServerRepository(),
      registerFor: {_dev},
    );
    gh.singleton<_i676.NotificationLocalRepository>(
      () => _i676.NotificationLocalRepository(),
      registerFor: {_dev},
    );
    gh.singleton<_i535.HiveDBService>(
      () => _i233.HiveDBUnittestService(),
      registerFor: {_tests},
    );
    gh.singleton<_i505.TagRepository>(() => _i505.TagRepository(
          tagLocalRepository: gh<_i295.TagLocalRepository>(),
          tagServerRepository: gh<_i338.TagServerRepository>(),
          navigationService: gh<_i892.NavigationService>(),
        ));
    gh.singleton<_i902.IAddProductLocalRepository>(
      () => _i370.HiveAddProductLocalRepository(),
      registerFor: {
        _dev,
        _prod,
        _tests,
      },
    );
    gh.singleton<_i118.UserRepository>(() => _i118.UserRepository(
          firebaseService: gh<_i228.FirebaseService>(),
          notificationRepository: gh<_i155.NotificationRepository>(),
        ));
    gh.singleton<_i544.ICartLocalRepository>(
      () => _i723.HivedbCartLocalRepository(),
      registerFor: {
        _dev,
        _tests,
        _prod,
      },
    );
    gh.factory<_i1048.PinVerifyCubit>(() => _i1048.PinVerifyCubit(
        localStorageService: gh<_i461.LocalStorageService>()));
    gh.factory<_i306.PinSetupCubit>(() => _i306.PinSetupCubit(
        localStorageService: gh<_i461.LocalStorageService>()));
    gh.singleton<_i167.ICartServerRepository>(
      () => _i1000.FirestoreCartServerRepository(),
      registerFor: {
        _dev,
        _tests,
        _prod,
      },
    );
    gh.singleton<_i535.HiveDBService>(
      () => _i1036.HiveDBDevService(),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.singleton<_i999.CartRepository>(() => _i999.CartRepository(
          cartLocalRepository: gh<_i544.ICartLocalRepository>(),
          cartServerRepository: gh<_i167.ICartServerRepository>(),
          navigationService: gh<_i892.NavigationService>(),
        ));
    gh.singleton<_i13.AddProductRepository>(() => _i13.AddProductRepository(
          addProductLocalRepository: gh<_i902.IAddProductLocalRepository>(),
          addProductServerRepository: gh<_i141.IAddProductServerRepository>(),
          navigationService: gh<_i892.NavigationService>(),
        ));
    gh.factory<_i18.StoreServerRepository>(
      () => _i18.StoreServerRepository(
        userRepository: gh<_i118.UserRepository>(),
        firebaseService: gh<_i228.FirebaseService>(),
        notificationRepository: gh<_i155.NotificationRepository>(),
      ),
      registerFor: {_dev},
    );
    gh.factory<_i830.IImageServerRepository>(
      () => _i656.FirebaseStorageImageServerRepository(
          firebaseService: gh<_i228.FirebaseService>()),
      registerFor: {
        _dev,
        _tests,
        _prod,
      },
    );
    gh.singleton<_i2.ProductHistoryRepository>(
        () => _i2.ProductHistoryRepository(
              productHistoryLocalRepository:
                  gh<_i485.ProductHistoryLocalRepository>(),
              productHistoryServerRepository:
                  gh<_i750.ProductHistoryServerRepository>(),
              navigationService: gh<_i892.NavigationService>(),
            ));
    gh.singleton<_i678.ImageRepository>(() => _i678.ImageRepository(
        imageServerRepository: gh<_i830.IImageServerRepository>()));
    gh.singleton<_i370.TransactionRepository>(() => _i370.TransactionRepository(
          transactionLocalRepository: gh<_i348.TransactionLocalRepository>(),
          transactionServerRepository: gh<_i620.TransactionServerRepository>(),
          navigationService: gh<_i892.NavigationService>(),
        ));
    gh.singleton<_i394.AddProductHistoryRepository>(
        () => _i394.AddProductHistoryRepository(
              addProductHistoryLocalRepository:
                  gh<_i764.AddProductHistoryLocalRepository>(),
              addProductHistoryServerRepository:
                  gh<_i710.AddProductHistoryServerRepository>(),
              navigationService: gh<_i892.NavigationService>(),
            ));
    gh.factory<_i18.NotificationDetailCubit>(() => _i18.NotificationDetailCubit(
        storeServerRepository: gh<_i18.StoreServerRepository>()));
    gh.factory<_i592.IProductServerRepository>(
      () => _i78.FirestoreProductServerRepository(
        firebaseService: gh<_i228.FirebaseService>(),
        imageRepository: gh<_i678.ImageRepository>(),
      ),
      registerFor: {
        _dev,
        _tests,
        _prod,
      },
    );
    gh.singleton<_i846.ProductRepository>(() => _i846.ProductRepository(
          productLocalRepository: gh<_i448.IProductLocalRepository>(),
          productServerRepository: gh<_i592.IProductServerRepository>(),
          productHistoryRepository: gh<_i2.ProductHistoryRepository>(),
          transactionRepository: gh<_i370.TransactionRepository>(),
          navigationService: gh<_i892.NavigationService>(),
          imageRepository: gh<_i678.ImageRepository>(),
        ));
    gh.factory<_i427.AddProductHistoryCubit>(() => _i427.AddProductHistoryCubit(
        addProductHistoryRepository: gh<_i394.AddProductHistoryRepository>()));
    gh.singleton<_i882.StoreRepository>(() => _i882.StoreRepository(
          storeLocalRepository: gh<_i457.StoreLocalRepository>(),
          storeServerRepository: gh<_i18.StoreServerRepository>(),
          navigationService: gh<_i892.NavigationService>(),
        ));
    gh.singleton<_i843.OrderServerRepository>(() => _i843.OrderServerRepository(
          firebaseService: gh<_i228.FirebaseService>(),
          productRepository: gh<_i846.ProductRepository>(),
        ));
    gh.singleton<_i698.OrderRepository>(() => _i698.OrderRepository(
          orderLocalRepository: gh<_i49.OrderLocalRepository>(),
          orderServerRepository: gh<_i843.OrderServerRepository>(),
          cartRepository: gh<_i999.CartRepository>(),
          transactionRepository: gh<_i370.TransactionRepository>(),
          navigationService: gh<_i892.NavigationService>(),
        ));
    gh.singleton<_i283.AppCubit>(() => _i283.AppCubit(
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
        ));
    gh.factory<_i867.OrderHistoryCubit>(() => _i867.OrderHistoryCubit(
          orderRepository: gh<_i698.OrderRepository>(),
          appCubit: gh<_i283.AppCubit>(),
        ));
    gh.factory<_i150.OrderHistoryDetailCubit>(
        () => _i150.OrderHistoryDetailCubit(
              orderRepository: gh<_i698.OrderRepository>(),
              appCubit: gh<_i283.AppCubit>(),
            ));
    gh.factory<_i924.TransactionsChartDetailsCubit>(() =>
        _i924.TransactionsChartDetailsCubit(appCubit: gh<_i283.AppCubit>()));
    gh.factory<_i653.NotificationCubit>(
        () => _i653.NotificationCubit(appCubit: gh<_i283.AppCubit>()));
    gh.factory<_i315.OrderCompleteCubit>(
        () => _i315.OrderCompleteCubit(appCubit: gh<_i283.AppCubit>()));
    gh.factory<_i179.TransactionCubit>(
        () => _i179.TransactionCubit(appCubit: gh<_i283.AppCubit>()));
    gh.factory<_i853.HomeCubit>(
        () => _i853.HomeCubit(appCubit: gh<_i283.AppCubit>()));
    gh.singleton<_i214.AuthRepository>(() => _i214.AuthRepository(
          authLocalRepository: gh<_i551.AuthLocalRepository>(),
          storeRepository: gh<_i882.StoreRepository>(),
          authServerRepository: gh<_i701.AuthServerRepository>(),
        ));
    gh.lazySingleton<_i301.MainCubit>(() => _i301.MainCubit(
          appCubit: gh<_i283.AppCubit>(),
          userRepository: gh<_i118.UserRepository>(),
        ));
    gh.factory<_i560.ProfileSettingsCubit>(() => _i560.ProfileSettingsCubit(
          appCubit: gh<_i283.AppCubit>(),
          userRepository: gh<_i118.UserRepository>(),
        ));
    gh.factory<_i277.TagManagementCubit>(() => _i277.TagManagementCubit(
          appCubit: gh<_i283.AppCubit>(),
          storeRepository: gh<_i882.StoreRepository>(),
        ));
    gh.factory<_i524.ThemeSettingCubit>(() => _i524.ThemeSettingCubit(
          appCubit: gh<_i283.AppCubit>(),
          storeRepository: gh<_i882.StoreRepository>(),
        ));
    gh.factory<_i853.AddUserCubit>(() => _i853.AddUserCubit(
          storeRepository: gh<_i18.StoreServerRepository>(),
          appCubit: gh<_i283.AppCubit>(),
        ));
    gh.factory<_i419.CreateTagCubit>(() => _i419.CreateTagCubit(
          storeRepository: gh<_i882.StoreRepository>(),
          appCubit: gh<_i283.AppCubit>(),
          tagRepository: gh<_i505.TagRepository>(),
        ));
    gh.factory<_i758.MoreCubit>(() => _i758.MoreCubit(
          appCubit: gh<_i283.AppCubit>(),
          localStorageService: gh<_i461.LocalStorageService>(),
          authRepository: gh<_i214.AuthRepository>(),
          userRepository: gh<_i118.UserRepository>(),
        ));
    gh.factory<_i874.CartCubit>(() => _i874.CartCubit(
          cartRepository: gh<_i999.CartRepository>(),
          appCubit: gh<_i283.AppCubit>(),
          orderRepository: gh<_i698.OrderRepository>(),
          productRepository: gh<_i846.ProductRepository>(),
        ));
    gh.factory<_i272.CreateStoreCubit>(() => _i272.CreateStoreCubit(
          storeRepository: gh<_i882.StoreRepository>(),
          appCubit: gh<_i283.AppCubit>(),
          userRepository: gh<_i118.UserRepository>(),
        ));
    gh.factory<_i468.StoreManagementCubit>(() => _i468.StoreManagementCubit(
          storeRepository: gh<_i882.StoreRepository>(),
          appCubit: gh<_i283.AppCubit>(),
          userRepository: gh<_i118.UserRepository>(),
        ));
    gh.factory<_i294.AddProductCubit>(() => _i294.AddProductCubit(
          productRepository: gh<_i846.ProductRepository>(),
          addProductHistoryRepository: gh<_i394.AddProductHistoryRepository>(),
          appCubit: gh<_i283.AppCubit>(),
          addProductRepository: gh<_i13.AddProductRepository>(),
        ));
    gh.factory<_i948.StatisticCubit>(() => _i948.StatisticCubit(
          categoryRepository: gh<_i635.CategoryRepository>(),
          orderRepository: gh<_i698.OrderRepository>(),
          appCubit: gh<_i283.AppCubit>(),
          transactionRepository: gh<_i370.TransactionRepository>(),
        ));
    gh.factory<_i75.CreateProductCubit>(() => _i75.CreateProductCubit(
          productRepository: gh<_i846.ProductRepository>(),
          appCubit: gh<_i283.AppCubit>(),
        ));
    gh.factory<_i462.ProductCubit>(() => _i462.ProductCubit(
          productRepository: gh<_i846.ProductRepository>(),
          appCubit: gh<_i283.AppCubit>(),
        ));
    gh.factory<_i304.UserManagementCubit>(() => _i304.UserManagementCubit(
          storeRepository: gh<_i882.StoreRepository>(),
          appCubit: gh<_i283.AppCubit>(),
        ));
    gh.factory<_i377.LoginCubit>(() => _i377.LoginCubit(
          authRepository: gh<_i214.AuthRepository>(),
          appCubit: gh<_i283.AppCubit>(),
        ));
    gh.factory<_i1028.CreateCategoryCubit>(() => _i1028.CreateCategoryCubit(
          appCubit: gh<_i283.AppCubit>(),
          categoryRepository: gh<_i635.CategoryRepository>(),
          storeRepository: gh<_i882.StoreRepository>(),
        ));
    gh.factory<_i647.CategoryManagementCubit>(
        () => _i647.CategoryManagementCubit(
              appCubit: gh<_i283.AppCubit>(),
              storeRepository: gh<_i882.StoreRepository>(),
              categoryRepository: gh<_i635.CategoryRepository>(),
            ));
    gh.factory<_i305.ProductDetailCubit>(() => _i305.ProductDetailCubit(
          productHistoryRepository: gh<_i2.ProductHistoryRepository>(),
          productRepository: gh<_i846.ProductRepository>(),
          appCubit: gh<_i283.AppCubit>(),
        ));
    gh.factory<_i213.IntroduceCubit>(() => _i213.IntroduceCubit(
          authRepository: gh<_i214.AuthRepository>(),
          appCubit: gh<_i283.AppCubit>(),
          localStorageService: gh<_i461.LocalStorageService>(),
        ));
    return this;
  }
}
