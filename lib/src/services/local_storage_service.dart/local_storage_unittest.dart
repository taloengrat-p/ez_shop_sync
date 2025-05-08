import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';

// @Singleton(as: LocalStorageService, env: [Flavor.TESTS])
class LocalStorageUnittest extends LocalStorageService {
  @override
  Future<void> init() async {}

  @override
  Future<bool> doCheckIsFirstRunApp() {
    throw UnimplementedError();
  }

  @override
  Future<bool> doCheckIsIntroduceFlowDone() {
    throw UnimplementedError();
  }

  @override
  T? getPref<T>(String key) {
    throw UnimplementedError();
  }

  @override
  Future<bool> setPref(String key, Object? value) {
    throw UnimplementedError();
  }

  @override
  getSecure(String key) {
    throw UnimplementedError();
  }

  @override
  setSecure(String key, String? value) {
    throw UnimplementedError();
  }
}
