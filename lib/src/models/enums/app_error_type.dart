import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';

enum AppErrorType {
  userNotFound,
  wrongPassword,
  invalidCredential,
  registerInvalidEmail,
  emailAlreadyInUse,
  somethingWentWrong,
  undefined,
  storeAlreadyThisUser,
  alreadyExist;

  String get label => switch (this) {
    AppErrorType.userNotFound => LocaleKeys.errorMessage_loginUserNotFound.tr(),
    AppErrorType.wrongPassword => LocaleKeys.errorMessage_loginWrongPassword.tr(),
    AppErrorType.invalidCredential => LocaleKeys.errorMessage_loginWrongUsernameOrPassword.tr(),
    AppErrorType.registerInvalidEmail => LocaleKeys.errorMessage_emailInvalid.tr(),
    AppErrorType.emailAlreadyInUse => LocaleKeys.errorMessage_emailAlreadyUse.tr(),
    AppErrorType.storeAlreadyThisUser => 'This user has already join store',
    AppErrorType.somethingWentWrong => 'Something went wrong',
    AppErrorType.alreadyExist => LocaleKeys.errorMessage_alreadyExist.tr(),
    AppErrorType.undefined => 'Unknown',
  };
}
