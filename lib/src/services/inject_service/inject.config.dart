// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/repository/auth/_local/auth_local_repository.dart' as _i900;
import '../../data/repository/auth/auth_repository.dart' as _i214;
import '../../data/repository/product/_local/product_local_dev_repository.dart'
    as _i1065;
import '../../data/repository/product/_local/product_local_repository.dart'
    as _i265;
import '../../data/repository/product/_local/product_local_unittest_repository.dart'
    as _i346;
import '../../data/repository/product/_server/product_server_dev_repository.dart'
    as _i258;
import '../../data/repository/product/_server/product_server_repository.dart'
    as _i960;
import '../../data/repository/product/_server/product_server_unittest_repository.dart'
    as _i468;
import '../../data/repository/product/product_repository.dart' as _i846;
import '../../data/repository/store/_local/store_local_repository.dart'
    as _i300;
import '../../data/repository/store/_server/store_server_repository.dart'
    as _i325;
import '../../data/repository/store/store_repository.dart' as _i882;
import '../../data/repository/tag/tag_local_repository.dart' as _i558;
import '../../data/repository/tag/tag_repository.dart' as _i505;
import '../../data/repository/tag/tag_server_repository.dart' as _i1035;
import '../../data/repository/user/user_repository.dart' as _i118;
import '../../utils/image_picker_utils.dart' as _i286;
import '../hivedb_service/hivedb_dev_service.dart' as _i1036;
import '../hivedb_service/hivedb_service.dart' as _i535;
import '../hivedb_service/hivedb_unittest_service.dart' as _i233;
import '../local_storage_service.dart/local_storage_dev_service.dart' as _i736;
import '../local_storage_service.dart/local_storage_service.dart' as _i461;
import '../local_storage_service.dart/local_storage_unittest.dart' as _i79;
import '../navigation_service.dart' as _i892;

const String _dev = 'dev';
const String _prod = 'prod';
const String _tests = 'tests';

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
    gh.factory<_i325.StoreServerRepository>(
        () => _i325.StoreServerRepository());
    gh.factory<_i300.StoreLocalRepository>(() => _i300.StoreLocalRepository());
    gh.singleton<_i286.ImagePickerUtils>(() => _i286.ImagePickerUtils());
    gh.singleton<_i900.AuthLocalRepository>(() => _i900.AuthLocalRepository());
    gh.singleton<_i118.UserRepository>(() => _i118.UserRepository());
    gh.singleton<_i892.NavigationService>(() => _i892.NavigationService());
    gh.singleton<_i1035.TagServerRepository>(
        () => _i1035.TagServerRepository());
    gh.singleton<_i558.TagLocalRepository>(() => _i558.TagLocalRepository());
    gh.singleton<_i265.ProductLocalRepository>(
      () => _i1065.ProductLocalDevRepository(),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.singleton<_i960.ProductServerRepository>(
      () => _i468.ProductServerUnittestRepository(),
      registerFor: {_tests},
    );
    gh.singleton<_i535.HiveDBService>(
      () => _i233.HiveDBUnittestService(),
      registerFor: {_tests},
    );
    gh.singleton<_i505.TagRepository>(() => _i505.TagRepository(
          tagLocalRepository: gh<_i558.TagLocalRepository>(),
          tagServerRepository: gh<_i1035.TagServerRepository>(),
        ));
    gh.singleton<_i461.LocalStorageService>(
      () => _i79.LocalStorageUnittest(),
      registerFor: {_tests},
    );
    gh.singleton<_i960.ProductServerRepository>(
      () => _i258.ProductServerDevRepository(),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i265.ProductLocalRepository>(
      () => _i346.ProductLocalUnittestRepository(),
      registerFor: {_tests},
    );
    gh.singleton<_i535.HiveDBService>(
      () => _i1036.HiveDBDevService(),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.singleton<_i461.LocalStorageService>(
      () => _i736.LocalStorageDevService(),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.singleton<_i882.StoreRepository>(() => _i882.StoreRepository(
          storeLocalRepository: gh<_i300.StoreLocalRepository>(),
          storeServerRepository: gh<_i325.StoreServerRepository>(),
        ));
    gh.singleton<_i846.ProductRepository>(() => _i846.ProductRepository(
          productLocalRepository: gh<_i265.ProductLocalRepository>(),
          productServerRepository: gh<_i960.ProductServerRepository>(),
        ));
    gh.singleton<_i214.AuthRepository>(() => _i214.AuthRepository(
          authLocalRepository: gh<_i900.AuthLocalRepository>(),
          storeRepository: gh<_i882.StoreRepository>(),
        ));
    return this;
  }
}
