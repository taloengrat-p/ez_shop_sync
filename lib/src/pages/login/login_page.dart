import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/auth/auth_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/login/login_cubit.dart';
import 'package:ez_shop_sync/src/pages/login/login_state.dart';
import 'package:ez_shop_sync/src/pages/main/main_router.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/column_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  late LoginCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = LoginCubit(
      authRepository: GetIt.I<AuthRepository>(),
      baseCubit: GetIt.I<BaseCubit>(),
    );

    WidgetsBinding.instance.addPostFrameCallback((time) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            MainRouter(context).replace();
          }
        },
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return BaseScaffolds(
              imageDecoration: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/cover.jpg'),
              ),
              backgroundColor: Colors.transparent,
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                color: Colors.transparent,
                title: _cubit.screenMode == ScreenMode.login
                    ? LocaleKeys.loginPage_login.tr()
                    : LocaleKeys.loginPage_register.tr(),
                titleStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _cubit.switchToScreenMode();
                    },
                    child: Text(
                      _cubit.screenMode == ScreenMode.register
                          ? LocaleKeys.loginPage_login.tr()
                          : LocaleKeys.loginPage_register.tr(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                          ),
                    ),
                  )
                ],
              ).build(),
              body: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/shopping-bag-white.png',
                      height: 100,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: _buildPage(context, state),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, LoginState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 16,
          ),
          Form(
            child: ColumnGapWidget(
              gap: 8,
              children: [
                TextFormFieldUiWidget(
                  label: LocaleKeys.loginPage_username.tr(),
                  labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                  hintText: LocaleKeys.loginPage_yourEmail.tr(),
                  errorText: state is LoginFailure ? state.errorType?.label : null,
                  onChanged: (value) {
                    _cubit.setUsername(value);
                  },
                ),
                TextFormFieldUiWidget(
                  label: LocaleKeys.loginPage_password.tr(),
                  labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                  obscureText: !_cubit.isVisiblePassword,
                  errorText: state is LoginFailure ? state.errorType?.label : null,
                  onChanged: (value) {
                    _cubit.setPassword(value);
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      _cubit.toggleVisiblePassword();
                    },
                    icon: Icon(_cubit.isVisiblePassword ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                  ),
                ),
                if (_cubit.screenMode == ScreenMode.register)
                  TextFormFieldUiWidget(
                    label: LocaleKeys.loginPage_confirmPassword.tr(),
                    labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                    obscureText: !_cubit.isVisiblePassword,
                    errorText: state is LoginPasswordNotMatch ? LocaleKeys.loginPage_confirmPasswordInvalid.tr() : null,
                    onChanged: (value) {
                      _cubit.setConfirmPassword(value);
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        _cubit.toggleVisiblePassword();
                      },
                      icon: Icon(_cubit.isVisiblePassword ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                    ),
                  ),
                // AnimatedOpacity(
                //   opacity: _cubit.screenMode == ScreenMode.register ? 1.0 : 0.0,
                //   duration: const Duration(milliseconds: 800),
                //   child: Visibility(
                //     visible: _cubit.screenMode == ScreenMode.register,
                //     child: TextFormFieldUiWidget(
                //       label: LocaleKeys.phoneNumber.tr(),
                //       // errorText: state is LoginFailure ? state.errorType?.label : null,
                //       onChanged: (value) {
                //         _cubit.setPhoneNumber(value);
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          ButtonWidget(
            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
            disabled: state is LoginLoading,
            label: _cubit.screenMode == ScreenMode.login
                ? LocaleKeys.loginPage_login.tr()
                : LocaleKeys.loginPage_register.tr(),
            isLoading: state is LoginLoading,
            onPressed: () {
              if (state is LoginLoading) {
                return;
              }

              if (_cubit.screenMode == ScreenMode.register) {
                _cubit.register();
              } else if (_cubit.screenMode == ScreenMode.login) {
                _cubit.login();
              }
            },
          ),
        ],
      ),
    );
  }
}
