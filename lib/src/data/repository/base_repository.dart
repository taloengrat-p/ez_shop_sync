import 'package:ez_shop_sync/src/models/app_mode.enum.dart';

abstract class BaseRepository {
  AppMode _appMode = AppMode.local;
  AppMode get appMode => _appMode;

  setRepoMode(AppMode value) {
    _appMode = value;
  }
}
