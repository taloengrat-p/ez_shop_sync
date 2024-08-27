import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/pages/pin_verify/pin_verify_state.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/utils/crypto_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinVerifyCubit extends Cubit<PinVerifyState> {
  LocalStorageService localStorageService;

  PinVerifyCubit({
    required this.localStorageService,
  }) : super(PinVerifyInitial());

  void doVerify(String value) async {
    final pin =
        await localStorageService.getSecure(ApplicationConstance.securePINKey);
    final pinSalt =
        await localStorageService.getSecure(ApplicationConstance.securePINsalt);

    if (pin == null || pinSalt == null) {
      throw ('PIN Data in secure storage invalid');
    }

    final bool isValid = CryptoUtils.verifyPassword(
        passwordInput: value, passwordHash: pin, salt: pinSalt);
    if (isValid) {
      emit(PinVerifySuccess());
    } else {
      emit(const PinVerifyClearByFailure());
    }
  }

  void refresh() {
    emit(PinVerifyRefresh(DateTime.now()));
  }

  void displayFailure() {
    emit(const PinVerifyFailure());
  }
}
