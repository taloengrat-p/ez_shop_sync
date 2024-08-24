abstract class LocalStorageService {
  init();
  Future<bool> doCheckIsFirstRunApp();
  Future<bool> doCheckIsIntroduceFlowDone();
  T? getPref<T>(String key);
  Future<bool> setPref(String key, Object? value);
}
