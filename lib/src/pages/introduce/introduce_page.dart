import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/introduce/introduce_cubit.dart';
import 'package:ez_shop_sync/src/pages/introduce/introduce_state.dart';
import 'package:ez_shop_sync/src/pages/introduce/widgets/step_widget.dart';
import 'package:ez_shop_sync/src/pages/main/main_router.dart';
import 'package:ez_shop_sync/src/pages/pin_setup/pin_setup_router.dart';
import 'package:ez_shop_sync/src/pages/pin_setup/pin_setup_state.dart';
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
  final _cubit = GetIt.I<IntroduceCubit>();
  final _introKey = GlobalKey<IntroductionScreenState>();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneNumber = FocusNode();

  final _storeNameFocusNode = FocusNode();
  final _storeDescFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  TextStyle get buttonTextStyle => TextStyle(color: ColorKeys.primary);
  TextStyle get labelInfomationTextStyle => const TextStyle(fontSize: 18);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IntroduceCubit, IntroduceState>(
      bloc: _cubit,
      listener: (context, state) async {
        if (state is IntroduceSuccess) {
          MainRouter(context).replace();
        }
      },
      child: BlocBuilder<IntroduceCubit, IntroduceState>(
        bloc: _cubit,
        builder: (context, state) {
          return BaseScaffolds(
            appBar: AppBar(systemOverlayStyle: SystemUiOverlayStyle.dark, backgroundColor: Colors.white),
            body:
                state is IntroduceSuccess
                    ? Container(height: double.infinity, width: double.infinity, color: Colors.white)
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
                              AppTextFormFieldUiWidget(
                                label: LocaleKeys.storeName.tr(),
                                focusNode: _storeNameFocusNode,
                                textInitial: _cubit.storeName,
                                onChanged: _cubit.setStoreName,
                                textInputAction: TextInputAction.next,
                                hintText: LocaleKeys.yourStoreName.tr(),
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(_storeDescFocusNode);
                                },
                              ),
                              AppTextFormFieldUiWidget(
                                label: LocaleKeys.optionalField.tr(args: [LocaleKeys.description.tr()]),
                                focusNode: _storeDescFocusNode,
                                textInitial: _cubit.storeName,
                                onChanged: _cubit.setStoreDesc,
                                textInputAction: TextInputAction.done,
                                hintText: LocaleKeys.yourStoreName.tr(),
                                onFieldSubmitted: (value) {
                                  if (_cubit.enableNext) {
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
                              AppTextFormFieldUiWidget(
                                label: LocaleKeys.introducePage_firstName.tr(),
                                focusNode: _firstNameFocusNode,
                                textInitial: _cubit.firstName,
                                hintText: LocaleKeys.introducePage_yourFirstName.tr(),
                                onChanged: _cubit.setFirstName,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(_lastNameFocusNode);
                                },
                              ),
                              AppTextFormFieldUiWidget(
                                label: LocaleKeys.introducePage_lastName.tr(),
                                focusNode: _lastNameFocusNode,
                                textInitial: _cubit.lastName,
                                onChanged: _cubit.setLastName,
                                hintText: LocaleKeys.introducePage_yourLastName.tr(),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(_emailFocusNode);
                                },
                              ),
                              AppTextFormFieldUiWidget(
                                focusNode: _emailFocusNode,
                                label: LocaleKeys.email.tr(),
                                textInitial: _cubit.email,
                                onChanged: _cubit.setEmail,
                                hintText: LocaleKeys.introducePage_yourEmail.tr(),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).requestFocus(_phoneNumber);
                                },
                              ),
                              AppTextFormFieldUiWidget(
                                focusNode: _phoneNumber,
                                label: LocaleKeys.phoneNumber.tr(),
                                textInitial: _cubit.phoneNumber,
                                onChanged: _cubit.setPhoneNumber,
                                hintText: LocaleKeys.introducePage_yourPhoneNumber.tr(),
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  if (_cubit.enableNext) {
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
                              Text('Store Name : ${_cubit.storeName}', style: labelInfomationTextStyle),
                              const SizedBox(height: DimensionsKeys.m),
                              Text('First Name : ${_cubit.firstName}', style: labelInfomationTextStyle),
                              const SizedBox(height: DimensionsKeys.m),
                              Text('Last Name : ${_cubit.lastName}', style: labelInfomationTextStyle),
                              const SizedBox(height: DimensionsKeys.m),
                              Text('Email : ${_cubit.email}', style: labelInfomationTextStyle),
                              const SizedBox(height: DimensionsKeys.m),
                              Text('Phone number : ${_cubit.phoneNumber}', style: labelInfomationTextStyle),
                            ],
                          ),
                        ),
                      ],
                      showBackButton: _cubit.currentStep != 0,
                      showDoneButton: true,
                      showSkipButton: false,
                      showNextButton: _cubit.currentStep != 2,
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
                            _cubit.doSubmit();
                          }
                        },
                      ),
                      next: ButtonWidget(
                        label: LocaleKeys.button_next.tr(),
                        onPressed:
                            _cubit.enableNext
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
                        _cubit.onStepChange(value);
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
    );
  }
}
