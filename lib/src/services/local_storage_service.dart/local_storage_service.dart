abstract class LocalStorageService {
  init();
  Future<bool> doCheckIsFirstRunApp();
  Future<bool> doCheckIsIntroduceFlowDone();
  T? getPref<T>(String key);
  Future<bool> setPref(String key, Object? value);

  Future<void> setSecure(String key, String? value);
  Future<String?> getSecure(String key);
}
