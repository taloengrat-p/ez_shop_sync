import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/constances/shared_pref_keys.dart';
import 'package:ez_shop_sync/src/data/dto/request/create_register_request.dart';
import 'package:ez_shop_sync/src/data/repository/auth/auth_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/introduce/introduce_state.dart';
import 'package:ez_shop_sync/src/pages/pin_setup/pin_setup_state.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/utils/crypto_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroduceCubit extends Cubit<IntroduceState> {
  int currentStep = 0;
  String storeName = '';
  String firstName = '';
  String lastName = '';
  String email = '';

  BaseCubit baseCubit;
  AuthRepository authRepository;
  LocalStorageService localStorageService;
  bool get enableNext {
    if (currentStep == 0) {
      return storeName.isNotEmpty;
    } else if (currentStep == 1) {
      return storeName.isNotEmpty &&
          firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          email.isNotEmpty;
    } else if (currentStep == 2) {
      return true;
    }

    return true;
  }

  IntroduceCubit({
    required this.authRepository,
    required this.baseCubit,
    required this.localStorageService,
  }) : super(IntroduceInitial());

  void onStepChange(int value) {
    currentStep = value;
    emit(IntroduceRefresh(DateTime.now()));
  }

  void setStoreName(String? value) {
    storeName = value ?? '';
    emitRefresh();
  }

  void setFirstName(String? value) {
    firstName = value ?? '';
    emitRefresh();
  }

  void setLastName(String? value) {
    lastName = value ?? '';
    emitRefresh();
  }

  void setEmail(String? value) {
    email = value ?? '';
    emitRefresh();
  }

  void emitRefresh() {
    emit(IntroduceRefresh(DateTime.now()));
  }

  void doSubmit() async {
    final userRegister = await authRepository.register(
      CreateRegisterRequest(
        storeName: storeName.trim(),
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: email.trim(),
      ),
    );

    final updateIntroduceFlow = await localStorageService.setPref(
        SharedPrefKeys.isIntroduceFlowDone, true);
    await localStorageService.setPref(
        SharedPrefKeys.currentUsername, userRegister.username);
    if (updateIntroduceFlow) {
      baseCubit.doLogin(userForceLogin: userRegister);
      emit(IntroduceSuccess(userRegister.username));
    }
  }
}
