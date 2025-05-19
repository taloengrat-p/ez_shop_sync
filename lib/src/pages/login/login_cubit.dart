import 'package:ez_shop_sync/src/data/dto/request/create_register_request.dart';
import 'package:ez_shop_sync/src/data/dto/request/login_request.dart';
import 'package:ez_shop_sync/src/data/repository/auth/auth_repository.dart';
import 'package:ez_shop_sync/src/models/app_mode.enum.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  final AppCubit appCubit;
  String username = '';
  String password = '';
  String confirmPassword = '';
  // String phoneNumber = '';
  ScreenMode screenMode = ScreenMode.login;
  bool isVisiblePassword = false;
  bool get isDisabled => username.isEmpty || password.isEmpty;
  LoginCubit({required this.authRepository, required this.appCubit}) : super(LoginInitial());

  void setUsername(String? value) {
    username = value ?? '';
    // emit(LoginRefresh(username));
  }

  void setPassword(String? value) {
    password = value ?? '';
    // emit(LoginRefresh(password));
  }

  void setConfirmPassword(String? value) {
    confirmPassword = value ?? '';
    // emit(LoginRefresh(confirmPassword));
  }

  void register() async {
    if (password != confirmPassword) {
      emit(LoginPasswordNotMatch());
      return;
    }

    final request = CreateRegisterRequest(
      email: username.trim(),
      password: password.trim(),
      // phoneNumber: phoneNumber,
    );

    emit(LoginLoading());
    final result = await authRepository.register(request, appMode: AppMode.server);

    result.when(
      success: (response) {},
      failure: (error, {errorType}) {
        emit(LoginFailure(error, errorType: errorType));
      },
    );
  }

  void login() async {
    final request = LoginRequest(appMode: AppMode.server, username: username.trim(), password: password.trim());
    emit(LoginLoading());
    final resultLogin = await authRepository.login(request);

    resultLogin.when(
      success: (response) {
        appCubit.setCurrentUser(response.user, origin: runtimeType.toString());
        emit(LoginSuccess());
      },
      failure: (error) {
        emit(LoginFailure(error, errorType: error.errorType));
      },
    );
  }

  void switchToScreenMode() {
    screenMode = screenMode == ScreenMode.register ? ScreenMode.login : ScreenMode.register;

    emit(LoginScreenModeChange(screenMode));
  }

  void toggleVisiblePassword() {
    isVisiblePassword = !isVisiblePassword;
    emit(LoginRefresh(isVisiblePassword));
  }

  // void setPhoneNumber(String? value) {
  //   phoneNumber = value ?? '';
  //   emit(LoginRefresh(phoneNumber));
  // }
}
