import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/base/base_state.dart';
import 'package:ez_shop_sync/src/pages/profile_settings/profile_settings_cubit.dart';
import 'package:ez_shop_sync/src/pages/profile_settings/profile_settings_router.dart';
import 'package:ez_shop_sync/src/pages/profile_settings/profile_settings_state.dart';
import 'package:ez_shop_sync/src/utils/dialog_utils.dart';
import 'package:ez_shop_sync/src/utils/extensions/date_time_extension.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/layout/column_gap_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({
    super.key,
  });

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettingsPage> {
  late ProfileSettingsCubit _cubit;
  late BaseCubit baseCubit;
  @override
  void initState() {
    super.initState();
    baseCubit = GetIt.I<BaseCubit>();
    _cubit = ProfileSettingsCubit(
      userRepository: GetIt.I<UserRepository>(),
      baseCubit: baseCubit,
    );

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
      providers: [
        BlocProvider<ProfileSettingsCubit>(
          create: (context) => _cubit,
        ),
        BlocProvider<BaseCubit>(
          create: (context) => baseCubit,
        ),
      ],
      child: BlocConsumer<BaseCubit, BaseState>(
          listener: (context, state) {},
          builder: (context, state) {
            return BlocListener<ProfileSettingsCubit, ProfileSettingsState>(
              listener: (context, state) async {
                if (state is ProfileSettingsSendVerifyEmail) {
                  await DialogUtils.showAlertDialog(context,
                      title: 'Email verification sended',
                      desc: 'Please check your email ${state.email} and login again',
                      barrierDismissible: false);
                  _cubit.forceLogout();
                } else if (state is ProfileSettingsFailure) {
                  DialogUtils.showAlertDialog(
                    context,
                    title: 'Something went wrong',
                    desc: 'Please try again later.',
                  );
                }
              },
              child: BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
                builder: (context, state) {
                  return BaseScaffolds(
                    isLoading: state is ProfileSettingsLoading,
                    appBar: AppbarWidget(
                      context,
                      centerTitle: false,
                      title: LocaleKeys.profileSettings.tr(),
                      actions: [
                        if (_cubit.screenMode == ScreenMode.edit)
                          TextButton(
                            child: Text(LocaleKeys.cancel.tr()),
                            onPressed: () {
                              _cubit.doCancelEdit();
                            },
                          ),
                        if (_cubit.screenMode == ScreenMode.display) ...[
                          ContainerCircleWidget(
                            onPressed: _cubit.doEdit,
                            child: const Icon(
                              Icons.edit,
                            ),
                          ),
                        ],
                      ],
                    ).build(),
                    body: _buildPage(context, state),
                    bottomNavigationBar: _cubit.screenMode == ScreenMode.display
                        ? null
                        : ButtonWidget(
                            margin: const EdgeInsets.symmetric(
                              horizontal: DimensionsKeys.pagePaddingHzt,
                              vertical: DimensionsKeys.l,
                            ),
                            label: LocaleKeys.button_save.tr(),
                            onPressed: _cubit.hasEditChange
                                ? () {
                                    _cubit.doSave();
                                  }
                                : null,
                          ),
                  );
                },
              ),
            );
          }),
    );
  }

  Widget _buildPage(BuildContext context, ProfileSettingsState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: DimensionsKeys.pagePaddingVt,
        horizontal: DimensionsKeys.pagePaddingHzt,
      ),
      child: SingleChildScrollView(
        child: ColumnGapWidget(
          gap: 8,
          children: [
            TextFormFieldUiWidget(
              key: const ValueKey('fullname'),
              readOnly: true,
              label: LocaleKeys.name.tr(),
              textValue: _cubit.profileName,
              onChanged: _cubit.doSetName,
            ),
            TextFormFieldUiWidget(
              key: const ValueKey('email'),
              readOnly: _cubit.screenMode == ScreenMode.display,
              label: LocaleKeys.email.tr(),
              suffixIcon: IconButton(
                onPressed: () async {
                  _cubit.verifyEmail();
                },
                icon: Icon(
                  Icons.verified_rounded,
                  color: (baseCubit.serverUser?.emailVerified ?? false) ? Colors.green : Colors.grey,
                ),
              ),
              textValue:
                  _cubit.screenMode == ScreenMode.display ? baseCubit.serverUser?.email : _cubit.emailEditor ?? '',
              onChanged: _cubit.doSetEmail,
            ),
            TextFormFieldUiWidget(
              key: const ValueKey('phone-number'),
              readOnly: _cubit.screenMode == ScreenMode.display,
              label: LocaleKeys.phoneNumber.tr(),
              textValue:
                  _cubit.screenMode == ScreenMode.display ? baseCubit.serverUser?.phoneNumber : _cubit.phoneEditor,
              onChanged: _cubit.doSetPhoneNumber,
              suffixIcon: Icon(
                Icons.verified_rounded,
                color: (baseCubit.serverUser?.phoneNumber != null) ? Colors.green : Colors.grey,
              ),
            ),
            TextFormFieldUiWidget(
              key: const ValueKey('date-created'),
              readOnly: true,
              label: LocaleKeys.dateTimeCreated.tr(),
              textValue: _cubit.baseCubit.serverUser?.metadata.creationTime.toDisplayDependLocale(context) ?? '',
            ),
            TextFormFieldUiWidget(
              key: const ValueKey('date-updated'),
              readOnly: true,
              label: LocaleKeys.dateTimeUpdated.tr(),
              textValue: _cubit.user?.updateDate?.toDisplayDependLocale(context) ?? '',
            ),
          ],
        ),
      ),
    );
  }
}
