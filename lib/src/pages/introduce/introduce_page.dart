import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/auth/auth_repository.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/introduce/introduce_cubit.dart';
import 'package:ez_shop_sync/src/pages/introduce/introduce_state.dart';
import 'package:ez_shop_sync/src/pages/introduce/widgets/step_widget.dart';
import 'package:ez_shop_sync/src/pages/main/main_router.dart';
import 'package:ez_shop_sync/src/pages/pin_setup/pin_setup_router.dart';
import 'package:ez_shop_sync/src/pages/pin_setup/pin_setup_state.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroduceFlowPage extends StatefulWidget {
  const IntroduceFlowPage({super.key});

  @override
  _IntroduceFlowPageState createState() => _IntroduceFlowPageState();
}

class _IntroduceFlowPageState extends State<IntroduceFlowPage> {
  late IntroduceCubit cubit;
  late BaseCubit baseCubit;
  final _introKey = GlobalKey<IntroductionScreenState>();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneNumber = FocusNode();

  final _storeNameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    baseCubit = BlocProvider.of<BaseCubit>(context);
    cubit = IntroduceCubit(
      authRepository: GetIt.I<AuthRepository>(),
      baseCubit: baseCubit,
      localStorageService: GetIt.I<LocalStorageService>(),
    );
  }

  TextStyle get buttonTextStyle => TextStyle(color: ColorKeys.primary);
  TextStyle get labelInfomationTextStyle => const TextStyle(fontSize: 18);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocListener<IntroduceCubit, IntroduceState>(
        listener: (context, state) async {
          if (state is IntroduceSuccess) {
            MainRouter(context).replace();
          }
        },
        child: BlocBuilder<IntroduceCubit, IntroduceState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                backgroundColor: Colors.white,
              ),
              body: state is IntroduceSuccess
                  ? Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.white,
                    )
                  : IntroductionScreen(
                      key: _introKey,
                      globalBackgroundColor: Colors.white,
                      scrollPhysics: const NeverScrollableScrollPhysics(),
                      pages: [
                        PageViewModel(
                          title: "",
                          bodyWidget: StepWidget(
                            number: 1,
                            title: LocaleKeys.createYourStoreName.tr(),
                            children: [
                              TextFormFieldUiWidget(
                                label: LocaleKeys.storeName.tr(),
                                focusNode: _storeNameFocusNode,
                                textInitial: cubit.storeName,
                                onChanged: cubit.setStoreName,
                                textInputAction: TextInputAction.done,
                                hintText: LocaleKeys.yourStoreName.tr(),
                                onFieldSubmitted: (value) {
                                  if (cubit.enableNext) {
                                    _introKey.currentState?.next();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        PageViewModel(
                          title: "",
                          bodyWidget: StepWidget(
                            number: 2,
                            title: LocaleKeys.introducePage_createOwnerInfomation.tr(),
                            children: [
                              TextFormFieldUiWidget(
                                label: LocaleKeys.introducePage_firstName.tr(),
                                focusNode: _firstNameFocusNode,
                                textInitial: cubit.firstName,
                                hintText: LocaleKeys.introducePage_yourFirstName.tr(),
                                onChanged: cubit.setFirstName,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(_lastNameFocusNode);
                                },
                              ),
                              TextFormFieldUiWidget(
                                label: LocaleKeys.introducePage_lastName.tr(),
                                focusNode: _lastNameFocusNode,
                                textInitial: cubit.lastName,
                                onChanged: cubit.setLastName,
                                hintText: LocaleKeys.introducePage_yourLastName.tr(),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(_emailFocusNode);
                                },
                              ),
                              TextFormFieldUiWidget(
                                focusNode: _emailFocusNode,
                                label: LocaleKeys.email.tr(),
                                textInitial: cubit.email,
                                onChanged: cubit.setEmail,
                                hintText: LocaleKeys.introducePage_yourEmail.tr(),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(_phoneNumber);
                                },
                              ),
                              TextFormFieldUiWidget(
                                focusNode: _phoneNumber,
                                label: LocaleKeys.phoneNumber.tr(),
                                textInitial: cubit.phoneNumber,
                                onChanged: cubit.setPhoneNumber,
                                hintText: LocaleKeys.introducePage_yourPhoneNumber.tr(),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  if (cubit.enableNext) {
                                    _introKey.currentState?.next();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        PageViewModel(
                          title: "",
                          bodyWidget: StepWidget(
                            number: 3,
                            title: 'Check your infomation',
                            children: [
                              Text(
                                'Store Name : ${cubit.storeName}',
                                style: labelInfomationTextStyle,
                              ),
                              const SizedBox(
                                height: DimensionsKeys.m,
                              ),
                              Text(
                                'First Name : ${cubit.firstName}',
                                style: labelInfomationTextStyle,
                              ),
                              const SizedBox(
                                height: DimensionsKeys.m,
                              ),
                              Text(
                                'Last Name : ${cubit.lastName}',
                                style: labelInfomationTextStyle,
                              ),
                              const SizedBox(
                                height: DimensionsKeys.m,
                              ),
                              Text(
                                'Email : ${cubit.email}',
                                style: labelInfomationTextStyle,
                              ),
                              const SizedBox(
                                height: DimensionsKeys.m,
                              ),
                              Text(
                                'Phone number : ${cubit.phoneNumber}',
                                style: labelInfomationTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                      showBackButton: cubit.currentStep != 0,
                      showDoneButton: true,
                      showSkipButton: false,
                      showNextButton: cubit.currentStep != 2,
                      back: ButtonWidget(
                        label: LocaleKeys.button_back.tr(),
                        onPressed: () {
                          _introKey.currentState?.previous();
                        },
                      ),
                      done: ButtonWidget(
                        label: LocaleKeys.button_done.tr(),
                        onPressed: () async {
                          final result = await PinSetupRouter(context).navigate();

                          if (result is PinSetupAllSuccess) {
                            cubit.doSubmit();
                          }
                        },
                      ),
                      next: ButtonWidget(
                        label: LocaleKeys.button_next.tr(),
                        onPressed: cubit.enableNext
                            ? () {
                                _introKey.currentState?.next();
                              }
                            : null,
                      ),
                      // overrideBack: ButtonWidget(
                      //   label: 'Back',
                      //   onPressed: () {},
                      // ),
                      // overrideDone: ButtonWidget(
                      //   label: 'Done',
                      //   onPressed: () {},
                      // ),
                      // overrideNext: ButtonWidget(
                      //   label: 'Next',
                      //   onPressed: () {},
                      // ),
                      onChange: (value) {
                        cubit.onStepChange(value);
                      },
                      onDone: () {
                        log('onDone Click');
                      },
                      dotsDecorator: DotsDecorator(
                        size: const Size.square(10.0),
                        activeSize: const Size(20.0, 10.0),
                        activeColor: Theme.of(context).colorScheme.secondary,
                        color: Colors.black26,
                        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
