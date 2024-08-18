import 'dart:developer';

import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/pages/main/introduce/introduce_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/introduce/introduce_state.dart';
import 'package:ez_shop_sync/src/pages/main/introduce/widgets/step_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_password_ui_widget.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroduceFlowPage extends StatefulWidget {
  const IntroduceFlowPage({Key? key}) : super(key: key);

  @override
  _IntroduceFlowPageState createState() => _IntroduceFlowPageState();
}

class _IntroduceFlowPageState extends State<IntroduceFlowPage> {
  late IntroduceCubit cubit;
  final _introKey = GlobalKey<IntroductionScreenState>();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = IntroduceCubit();
  }

  TextStyle get buttonTextStyle => TextStyle(color: ColorKeys.primary);
  TextStyle get labelInfomationTextStyle => const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocListener<IntroduceCubit, IntroduceState>(
        listener: (context, state) {},
        child: BlocBuilder<IntroduceCubit, IntroduceState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                backgroundColor: Colors.transparent,
              ),
              body: IntroductionScreen(
                key: _introKey,
                globalBackgroundColor: Colors.white,
                scrollPhysics: const NeverScrollableScrollPhysics(),
                pages: [
                  PageViewModel(
                    title: "",
                    bodyWidget: StepWidget(
                      number: 1,
                      title: 'Create Your Store Name',
                      children: [
                        TextFormFieldUiWidget(
                          label: 'Store Name',
                          autofocus: true,
                          textInitial: cubit.storeName,
                          onChanged: cubit.setStoreName,
                          textInputAction: TextInputAction.done,
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
                      title: 'Create Owner Infomation',
                      children: [
                        TextFormFieldUiWidget(
                          label: 'Firstname',
                          focusNode: _firstNameFocusNode,
                          textInitial: cubit.firstName,
                          onChanged: cubit.setFirstName,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_lastNameFocusNode);
                          },
                        ),
                        TextFormFieldUiWidget(
                          label: 'Lastname',
                          focusNode: _lastNameFocusNode,
                          textInitial: cubit.lastName,
                          onChanged: cubit.setLastName,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_emailFocusNode);
                          },
                        ),
                        TextFormFieldUiWidget(
                          focusNode: _emailFocusNode,
                          label: 'Email',
                          textInitial: cubit.email,
                          onChanged: cubit.setEmail,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_passwordFocusNode);
                          },
                        ),
                        TextFormFieldPasswordUiWidget(
                          focusNode: _passwordFocusNode,
                          label: 'Password',
                          onChanged: cubit.setPassword,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                          },
                          isRequired: true,
                          hintText: 'Enter your password',
                        ),
                        TextFormFieldPasswordUiWidget(
                          label: 'Confirm Password',
                          hintText: 'Confirm your password',
                          focusNode: _confirmPasswordFocusNode,
                          onChanged: cubit.setConfirmPassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value) {
                            if (cubit.enableNext) {
                              _introKey.currentState?.next();
                            }
                          },
                          isRequired: true,
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
                      ],
                    ),
                  ),
                ],
                showBackButton: cubit.currentStep != 0,
                showDoneButton: true,
                showSkipButton: false,
                showNextButton: cubit.currentStep != 2,
                back: ButtonWidget(
                  label: 'Back',
                  onPressed: () {
                    _introKey.currentState?.previous();
                  },
                ),
                done: ButtonWidget(
                  label: 'Done',
                  onPressed: () {
                    cubit.doSubmit();
                  },
                ),
                next: ButtonWidget(
                  label: 'Next',
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
