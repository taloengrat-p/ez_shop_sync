import 'package:ez_shop_sync/src/models/app_mode.enum.dart';

class LoginRequest {
  final String username;
  final String password;
  final AppMode appMode;

  LoginRequest({
    required this.appMode,
    required this.username,
    required this.password,
  });
}
