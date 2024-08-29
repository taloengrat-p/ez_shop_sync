import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_router.dart';
import 'package:ez_shop_sync/src/pages/main/more/models/menu_item_model.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_state.dart';
import 'package:ez_shop_sync/src/pages/main/more/widgets/menu_group_widget.dart';
import 'package:ez_shop_sync/src/pages/password_setting/password_setting_router.dart';
import 'package:ez_shop_sync/src/pages/pin_setup/pin_setup_router.dart';
import 'package:ez_shop_sync/src/pages/pin_setup/pin_setup_state.dart';
import 'package:ez_shop_sync/src/pages/pin_verify/pin_verify_router.dart';
import 'package:ez_shop_sync/src/pages/pin_verify/pin_verify_state.dart';
import 'package:ez_shop_sync/src/pages/profile_settings/profile_settings_router.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_router.dart';
import 'package:ez_shop_sync/src/pages/tag_management/tag_management_router.dart';
import 'package:ez_shop_sync/src/pages/theme_setting/theme_setting_router.dart';
import 'package:ez_shop_sync/src/pages/user_management/user_management_router.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/utils/bottom_sheet_utils.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extendsions.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/bottom_sheet/bottom_menu_item.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/circle_profile_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  late MoreCubit cubit;
  late BaseCubit baseCubit;

  @override
  void initState() {
    super.initState();
    baseCubit = GetIt.I<BaseCubit>();
    cubit = MoreCubit(
      baseCubit: baseCubit,
      localStorageService: GetIt.I<LocalStorageService>(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit.setLocale(context.locale);
  }

  @override
  Widget build(BuildContext context) {
    log('${context.locale}', name: runtimeType.toString());
    return BlocProvider(
      create: (context) => cubit,
      child: BlocListener<MoreCubit, MoreState>(
        listener: (context, state) async {
          log('state $state', name: runtimeType.toString());
          if (state is MoreClickPinSetting) {
            if (state.type == PinType.create) {
              final result = await PinSetupRouter(context).navigate();

              cubit.refresh();
            } else if (state.type == PinType.setting) {
              final result = await PinVerifyRouter(context).navigate();

              if (result is PinVerifySuccess) {
                await Future.delayed(Duration.zero, () async {
                  PinSetupRouter(context).navigate(
                    argruments: PinSetupArgruments(
                      title: 'Create New PIN',
                      desc: 'Enter the code for new PIN',
                    ),
                  );
                });

                cubit.refresh();
              } else {
                cubit.refresh();
              }
            }
          }
        },
        child: BlocBuilder<MoreCubit, MoreState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                centerTitle: false,
                title: LocaleKeys.menu.tr(),
                actions: [
                  Text(
                    cubit.username,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  CircleProfileWidget(
                    title: cubit.userShortName,
                    radius: 18,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ).build(),
              body: SingleChildScrollView(
                child: buildBody(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStoreProfile(),
          const SizedBox(
            height: 16,
          ),
          _buildStoreSettings(),
          const SizedBox(
            height: 16,
          ),
          _buildUserSettings(),
          const SizedBox(
            height: 16,
          ),
          _buildAppSettings(),
          const SizedBox(
            height: 32,
          ),
          ButtonWidget(
            disabled: true,
            label: LocaleKeys.logout.tr(),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            backgroundColor: Colors.red,
            leading: const Icon(
              Icons.power_settings_new_rounded,
              color: Colors.white,
            ),
            onPressed: cubit.doLogout,
          ),
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(LocaleKeys.appVersion
                  .tr(args: [cubit.version, cubit.buildNumber])),
            ),
          ),
          const SizedBox(
            height: DimensionsKeys.heightBts * 1.75,
          ),
        ],
      ),
    );
  }

  Widget _buildStoreProfile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: ColorKeys.secondary,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleProfileWidget(
                title: cubit.storeShortName,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                cubit.storeName,
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  CreateStoreRouter(context).navigate();
                },
                icon: const Material(
                  elevation: 0.05,
                  color: Colors.transparent,
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.add_circle_rounded,
                    color: Colors.yellow,
                    size: 36,
                  ),
                ),
              ),
              if (cubit.stores.isNotEmpty)
                IconButton(
                  onPressed: onHandleChangeStore,
                  icon: const Material(
                    elevation: 0.05,
                    shape: CircleBorder(),
                    color: Colors.transparent,
                    child: Icon(
                      Icons.expand_circle_down_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void onHandleChangeStore() async {
    final result = await BottomSheetUtils.showMenu(context,
        title: 'Your Store',
        body: SingleChildScrollView(
          child: Column(
            children: [
              ...cubit.stores.map(
                (e) => BottomMenuItem(
                  label: e.name,
                  leading: CircleProfileWidget(
                    title: e.name.toSubStringFirstToIndex(2),
                  ),
                  value: e.id,
                  trailing: e.id == cubit.currentStore?.id
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ));
    if (result != null) {
      // TO DO
      cubit.changeStore(result);
    }
  }

  Widget _buildStoreSettings() {
    return MenuGroupWidget(
      title: LocaleKeys.storeSettings.tr(),
      items: [
        MenuItemModel(
          disabled: true,
          title: LocaleKeys.storeManagement.tr(),
          value: 1,
          onPressed: () {
            StoreManagementRouter(context).navigate();
          },
        ),
        MenuItemModel(
          title: LocaleKeys.userManagement.tr(),
          value: 2,
          disabled: true,
          onPressed: () {
            UserManagementRouter(context).navigate();
          },
        ),
        MenuItemModel(
          title: LocaleKeys.tagManagement.tr(),
          value: 3,
          disabled: false,
          onPressed: () {
            TagManagementRouter(context).navigate();
          },
        ),
      ],
    );
  }

  Widget _buildUserSettings() {
    return MenuGroupWidget(
      title: LocaleKeys.userSettings.tr(),
      items: [
        MenuItemModel(
          disabled: true,
          title: LocaleKeys.profileSettings.tr(),
          value: 1,
          onPressed: () {
            ProfileSettingsRouter(context).navigate();
          },
        ),
        MenuItemModel(
          title: LocaleKeys.passwordSetting.tr(),
          value: 1,
          disabled: true,
          onPressed: () {
            PasswordSettingRouter(context).navigate();
          },
        ),
        MenuItemModel(
          title: LocaleKeys.pinSetting.tr(),
          value: 1,
          onPressed: cubit.clickPinSetting,
        ),
      ],
    );
  }

  Widget _buildAppSettings() {
    return MenuGroupWidget(
      title: LocaleKeys.appSetting.tr(),
      items: [
        MenuItemModel(
          title: LocaleKeys.language.tr(),
          value: 1,
          trailing: Row(
            children: [
              Text(LocaleKeys.languageEn.tr()),
              const SizedBox(
                width: 4,
              ),
              Switch.adaptive(
                value: context.locale == const Locale('th'),
                activeColor: Colors.orange.shade300,
                inactiveTrackColor: Colors.orange.shade300,
                onChanged: (val) => cubit.changeLanguage(context, val),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(LocaleKeys.languageTh.tr()),
            ],
          ),
        ),
        MenuItemModel(
          disabled: true,
          title: LocaleKeys.theme.tr(),
          value: 1,
          onPressed: () {
            ThemeSettingRouter(context).navigate();
          },
        ),
      ],
    );
  }
}
