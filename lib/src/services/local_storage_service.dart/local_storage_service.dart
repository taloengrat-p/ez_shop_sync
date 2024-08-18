abstract class LocalStorageService {
  init();
  Future<bool> doCheckIsFirstRunApp();
  Future<bool> doCheckIsIntroduceFlowDone();
}
