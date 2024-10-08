import 'package:ez_shop_sync/flavors.dart';
import 'package:ez_shop_sync/src/constances/shared_pref_keys.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Singleton(as: LocalStorageService, env: [Flavor.DEV, Flavor.PROD])
@Injectable(as: LocalStorageService, env: [Flavor.DEV, Flavor.PROD])
class LocalStorageDevService implements LocalStorageService {
  SharedPreferences? prefs;
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  T? getPref<T>(String key) {
    try {
      final result = prefs?.get(key) as T;
      return result;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> setPref(String key, Object? value) async {
    bool result = false;

    if (value == null) {
      result = await prefs?.setString(key, "") ?? false;
      return result;
    }
    if (value is int) {
      result = await prefs?.setInt(key, value) ?? false;
    } else if (value is String) {
      result = await prefs?.setString(key, value) ?? false;
    } else if (value is double) {
      result = await prefs?.setDouble(key, value) ?? false;
    } else if (value is bool) {
      result = await prefs?.setBool(key, value) ?? false;
    } else if (value is List<String>) {
      result = await prefs?.setStringList(key, value) ?? false;
    } else {
      result = await prefs?.setString(key, value.toString()) ?? false;
    }

    return result;
  }

  @override
  Future<bool> doCheckIsFirstRunApp() async {
    if (prefs.isNull) {
      await init();
    }

    final result = getPref<bool>(SharedPrefKeys.isFirstRunApp) ?? true;

    if (result) {
      await setPref(SharedPrefKeys.isFirstRunApp, false);
    }

    return result;
  }

  @override
  Future<bool> doCheckIsIntroduceFlowDone() async {
    if (prefs.isNull) {
      await init();
    }

    final result = getPref<bool>(SharedPrefKeys.isIntroduceFlowDone) ?? false;

    if (!result) {
      await setPref(SharedPrefKeys.isIntroduceFlowDone, false);
    }

    return result;
  }

  @override
  Future<String?> getSecure(String key) async {
    return await secureStorage.read(key: key);
  }

  @override
  Future<void> setSecure(String key, String? value) async {
    return await secureStorage.write(key: key, value: value);
  }
}
