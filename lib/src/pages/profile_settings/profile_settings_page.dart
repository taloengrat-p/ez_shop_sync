import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/_app/app_state.dart';
import 'package:ez_shop_sync/src/pages/profile_settings/profile_settings_cubit.dart';
import 'package:ez_shop_sync/src/pages/profile_settings/profile_settings_router.dart';
import 'package:ez_shop_sync/src/pages/profile_settings/profile_settings_state.dart';
import 'package:ez_shop_sync/src/utils/dialog_utils.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/column_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettingsPage> {
  final _cubit = GetIt.I<ProfileSettingsCubit>();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      _cubit.initial();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: _cubit), BlocProvider.value(value: _cubit.appCubit)],
      child: BlocConsumer<AppCubit, AppState>(
        bloc: GetIt.I<AppCubit>(),
        listener: (context, state) {
          if (state is AppUserChange) {
            _cubit.refresh();
          }
        },
        builder: (context, state) {
          return BlocListener<ProfileSettingsCubit, ProfileSettingsState>(
            listener: (context, state) async {
              log('profile state : $state');
              if (state is ProfileSettingsSendVerifyEmail) {
                await DialogUtils.showAlertDialog(
                  context,
                  title: 'Email verification sended',
                  desc: 'Please check your email ${state.email} and login again',
                  barrierDismissible: false,
                );

                ProfileSettingsRouter(context).pop();
              } else if (state is ProfileSettingsFailure) {
                DialogUtils.showAlertDialog(context, title: 'Something went wrong', desc: 'Please try again later.');
              }
            },
            child: BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
              builder: (context, state) {
                return BaseScaffolds(
                  isInitialLoading: state is ProfileSettingsInitial,
                  isLoading: state is ProfileSettingsLoading,
                  appBar:
                      AppbarWidget(
                        context,
                        centerTitle: false,
                        title: LocaleKeys.profileSettings.tr(),
                        actions: [
                          if (_cubit.screenMode != ScreenMode.display)
                            TextButton(
                              child: Text(LocaleKeys.cancel.tr()),
                              onPressed: () {
                                _cubit.doCancelEdit();
                              },
                            ),
                          if (_cubit.screenMode == ScreenMode.display) ...[
                            ContainerCircleWidget(onPressed: _cubit.doEdit, child: const Icon(Icons.edit)),
                          ],
                          const SizedBox(width: 8),
                        ],
                      ).build(),
                  body: _buildPage(context, state),
                  bottomNavigationBar:
                      _cubit.screenMode == ScreenMode.display
                          ? null
                          : ButtonWidget(
                            disabled: !_cubit.hasEditChange,
                            margin: const EdgeInsets.symmetric(
                              horizontal: DimensionsKeys.pagePaddingHzt,
                              vertical: DimensionsKeys.l,
                            ),
                            label: LocaleKeys.button_save.tr(),
                            onPressed: () {
                              _cubit.doSave();
                            },
                          ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, ProfileSettingsState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: DimensionsKeys.pagePaddingVt,
        horizontal: DimensionsKeys.pagePaddingHzt,
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          _cubit.initial();
        },
        child: ListView(
          children: [
            ColumnGapWidget(
              gap: 8,
              children: [
                AppTextFormFieldUiWidget(
                  key: const ValueKey('display-name'),
                  readOnly: _cubit.screenMode == ScreenMode.display,
                  label: LocaleKeys.displayName.tr(),
                  textValue:
                      _cubit.screenMode == ScreenMode.display ? _cubit.displayNameOriginal : _cubit.displayNameEditor,
                  onChanged: _cubit.doSetName,
                ),
                AppTextFormFieldUiWidget(
                  key: const ValueKey('email'),
                  readOnly: true,
                  label: LocaleKeys.email.tr(),
                  suffixIcon: IconButton(
                    onPressed:
                        _cubit.user?.emailVerified ?? true
                            ? null
                            : () async {
                              final result = await DialogUtils.showConfirm(
                                context,
                                title: 'Verification email',
                                desc: 'Confirm your email \'${_cubit.user?.email}\' address for verification',
                              );

                              if (result == ConfirmDialogResult.ok) {
                                _cubit.verifyEmail();
                              }
                            },
                    icon: Icon(
                      Icons.verified_rounded,
                      color: (_cubit.appCubit.user?.emailVerified ?? false) ? Colors.green : Colors.grey,
                    ),
                  ),
                  textValue:
                      _cubit.screenMode == ScreenMode.display ? _cubit.appCubit.user?.email : _cubit.emailEditor ?? '',
                  onChanged: _cubit.doSetEmail,
                ),
                // TextFormFieldUiWidget(
                //   key: const ValueKey('phone-number'),
                //   readOnly: _cubit.screenMode == ScreenMode.display,
                //   label: LocaleKeys.phoneNumber.tr(),
                //   textValue:
                //       _cubit.screenMode == ScreenMode.display ? baseCubit.user?.phoneNumber ?? '' : _cubit.phoneEditor,
                //   onChanged: _cubit.doSetPhoneNumber,
                //   suffixIcon: _cubit.user?.phoneNumber == null
                //       ? IconButton(
                //           onPressed: () {
                //             VerifyPhoneNumberRouter(context).navigate();
                //           },
                //           icon: const Icon(Icons.edit_rounded),
                //         )
                //       : baseCubit.user?.phoneNumber != null
                //           ? Icon(
                //               Icons.verified_rounded,
                //               color: (baseCubit.user?.phoneNumber != null) ? Colors.green : Colors.grey,
                //             )
                //           : null,
                // ),
                AppTextFormFieldUiWidget(
                  key: const ValueKey('date-created'),
                  readOnly: true,
                  label: LocaleKeys.dateTimeCreated.tr(),
                  textValue:
                      _cubit.appCubit.user?.metadata.creationTime?.toLocal().toDisplayDependLocale(context) ?? '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
