import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/pages/pin_setup/pin_setup_state.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/utils/crypto_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinSetupCubit extends Cubit<PinSetupState> {
  String pin = '';
  String confirm = '';
  LocalStorageService localStorageService;
  PinSetupArgruments? argrument;
  PinSetupCubit({
    required this.localStorageService,
  }) : super(PinSetupInitial());

  void setPin(String value) {
    pin = value;
    emit(PinSetupSuccess());
  }

  void setConfirmPin(String value) {
    confirm = value;

    if (confirm == pin) {
      initPIN(value);
    }
  }

  void initPIN(String pin) async {
    ResultEncryp pinEncrypt = CryptoUtils.encrypPassword(pin);
    await localStorageService.setSecure(
        ApplicationConstance.securePINKey, pinEncrypt.value);
    await localStorageService.setSecure(
        ApplicationConstance.securePINsalt, pinEncrypt.salt);

    emit(PinSetupAllSuccess('${pinEncrypt.value}:${pinEncrypt.salt}'));
  }

  void setArgrument(PinSetupArgruments argrument) {
    this.argrument = argrument;
  }
}
