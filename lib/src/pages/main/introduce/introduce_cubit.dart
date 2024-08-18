import 'package:ez_shop_sync/src/pages/main/introduce/introduce_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IntroduceCubit extends Cubit<IntroduceState> {
  int currentStep = 0;
  String storeName = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  bool get enableNext {
    if (currentStep == 0) {
      return storeName.isNotEmpty;
    } else if (currentStep == 1) {
      return storeName.isNotEmpty &&
          firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty;
    } else if (currentStep == 2) {
      return true;
    }

    return true;
  }

  IntroduceCubit() : super(IntroduceInitial());

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

  void setPassword(String? value) {
    password = value ?? '';
    emitRefresh();
  }

  void setConfirmPassword(String? value) {
    confirmPassword = value ?? '';
    emitRefresh();
  }

  void emitRefresh() {
    emit(IntroduceRefresh(DateTime.now()));
  }

  void doSubmit() {}
}
