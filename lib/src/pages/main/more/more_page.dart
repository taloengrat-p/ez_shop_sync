import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/role_type.enum.dart';
import 'package:ez_shop_sync/src/data/repository/auth/auth_repository.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/pages/add_product_history/add_product_history_router.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/base/base_state.dart';
import 'package:ez_shop_sync/src/pages/category_management/category_management_router.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_router.dart';
import 'package:ez_shop_sync/src/pages/login/login_router.dart';
import 'package:ez_shop_sync/src/pages/main/more/models/menu_item_model.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_state.dart';
import 'package:ez_shop_sync/src/pages/main/more/widgets/menu_group_widget.dart';
import 'package:ez_shop_sync/src/pages/order_history/order_history_router.dart';
import 'package:ez_shop_sync/src/pages/password_setting/password_setting_router.dart';
import 'package:ez_shop_sync/src/pages/pin_setup/pin_setup_router.dart';
import 'package:ez_shop_sync/src/pages/pin_setup/pin_setup_state.dart';
import 'package:ez_shop_sync/src/pages/pin_verify/pin_verify_router.dart';
import 'package:ez_shop_sync/src/pages/pin_verify/pin_verify_state.dart';
import 'package:ez_shop_sync/src/pages/profile_settings/profile_settings_router.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_router.dart';
import 'package:ez_shop_sync/src/pages/tag_management/tag_management_router.dart';
import 'package:ez_shop_sync/src/pages/theme_setting/theme_setting_router.dart';
import 'package:ez_shop_sync/src/pages/theme_setting/theme_setting_state.dart';
import 'package:ez_shop_sync/src/pages/user_management/user_management_router.dart';
import 'package:ez_shop_sync/src/services/local_storage_service.dart/local_storage_service.dart';
import 'package:ez_shop_sync/src/utils/bottom_sheet_utils.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/bottom_sheet/bottom_menu_item.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/circle_profile_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  late MoreCubit _cubit;
  late BaseCubit baseCubit;

  @override
  void initState() {
    log('[init]', name: runtimeType.toString());
    super.initState();

    _cubit = MoreCubit(
      baseCubit: GetIt.I<BaseCubit>(),
      localStorageService: GetIt.I<LocalStorageService>(),
      authRepository: GetIt.I<AuthRepository>(),
      userRepository: GetIt.I<UserRepository>(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit.setLocale(context.locale);
  }

  @override
  Widget build(BuildContext context) {
    log('${context.locale}', name: runtimeType.toString());
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<MoreCubit, MoreState>(
        listener: (context, state) async {
          if (state is MoreClickPinSetting) {
            if (state.type == PinType.create) {
              final result = await PinSetupRouter(context).navigate();

              _cubit.refresh();
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

                _cubit.refresh();
              } else {
                _cubit.refresh();
              }
            }
          } else if (state is MoreLogoutSuccess) {
            baseCubit.clearCurrentUserData();
            LoginRouter(context).replace();
          }
        },
        child: BlocBuilder<MoreCubit, MoreState>(
          builder: (context, state) {
            return BaseScaffolds(
              backgroundColor: Colors.white,
              isLoading: state is BaseLoading,
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: LocaleKeys.menu.tr(),
                actions: [],
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DimensionsKeys.pagePaddingHzt,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStoreProfile(),
            const SizedBox(
              height: 16,
            ),
            _buildMenuSettings(),
            const SizedBox(
              height: 16,
            ),
            if ((_cubit.baseCubit.userRoleTypeCurrentStore?.power ?? -1) >= RoleType.manager.power) ...[
              _buildStoreSettings(),
              const SizedBox(
                height: 16,
              )
            ],
            _buildUserSettings(),
            const SizedBox(
              height: 16,
            ),
            _buildAppSettings(),
            const SizedBox(
              height: 32,
            ),
            ButtonWidget(
              label: LocaleKeys.logout.tr(),
              backgroundColor: Colors.red,
              leading: const Icon(
                Icons.logout_rounded,
              ),
              onPressed: _cubit.doLogout,
            ),
            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(LocaleKeys.appVersion.tr(args: [_cubit.version, _cubit.buildNumber])),
              ),
            ),
            const SizedBox(
              height: DimensionsKeys.heightBts * 1.75,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreProfile() {
    return Card(
      color: ColorKeys.primary.withOpacity(0.6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  if (_cubit.stores.isNotEmpty)
                    CircleProfileWidget(
                      title: _cubit.storeShortName,
                    ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      _cubit.storeName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            overflow: TextOverflow.ellipsis,
                            color: ColorKeys.primary.withOpacity(0.6).getContrast(),
                          ),
                    ),
                  ),
                  if (_cubit.storeName.isEmpty)
                    Text(
                      'Create first store',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            overflow: TextOverflow.ellipsis,
                            color: ColorKeys.primary.withOpacity(0.6).getContrast(),
                          ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Row(
              children: [
                ContainerCircleWidget(
                  color: ColorKeys.secondary.getContrast(),
                  child: const Icon(
                    Icons.add_business_rounded,
                  ),
                  onPressed: () {
                    CreateStoreRouter(context).navigate();
                  },
                ),
                const SizedBox(
                  width: 8,
                ),
                if (_cubit.stores.isNotEmpty)
                  ContainerCircleWidget(
                    color: ColorKeys.secondary.getContrast(),
                    child: const Icon(
                      Icons.swap_horiz_rounded,
                      color: Colors.white,
                    ),
                    onPressed: onHandleChangeStore,
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onHandleChangeStore() async {
    final result = await BottomSheetUtils.showDragable(context,
        title: 'Your Store',
        body: SingleChildScrollView(
          child: Column(
            children: [
              ..._cubit.stores.map(
                (e) => BottomMenuItem(
                  label: e.name,
                  leading: CircleProfileWidget(
                    title: e.name.toSubStringFirstToIndex(2),
                  ),
                  value: e.id,
                  trailing: e.id == _cubit.currentStore?.id
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
      _cubit.selectStore(result);
    }
  }

  Widget _buildStoreSettings() {
    return MenuGroupWidget(
      title: LocaleKeys.storeSettings.tr(),
      items: [
        MenuItemModel(
          disabled: _cubit.stores.isEmpty,
          title: LocaleKeys.storeManagement.tr(),
          value: 1,
          onPressed: () {
            StoreManagementRouter(context).navigate();
          },
        ),
        MenuItemModel(
          title: LocaleKeys.userManagement.tr(),
          value: 2,
          onPressed: () {
            UserManagementRouter(context).navigate();
          },
        ),
        MenuItemModel(
          title: LocaleKeys.tagManagement.tr(),
          value: 3,
          disabled: true,
          onPressed: () {
            TagManagementRouter(context).navigate();
          },
        ),
        MenuItemModel(
          title: LocaleKeys.categoryManagement.tr(),
          value: 3,
          disabled: true,
          onPressed: () {
            CategoryManagementRouter(context).navigate();
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
          onPressed: _cubit.clickPinSetting,
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
                activeColor: ColorKeys.primary,
                inactiveTrackColor: ColorKeys.primary,
                onChanged: (val) => _cubit.changeLanguage(context, val),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(LocaleKeys.languageTh.tr()),
            ],
          ),
        ),
        MenuItemModel(
          title: LocaleKeys.theme.tr(),
          value: 1,
          onPressed: () async {
            final result = await ThemeSettingRouter(context).navigate();

            if (result is ThemeSettingSuccess) {
              _cubit.refresh();
            }
          },
        ),
      ],
    );
  }

  Widget _buildMenuSettings() {
    return MenuGroupWidget(
      title: LocaleKeys.myMenu.tr(),
      items: [
        MenuItemModel(
          disabled: true,
          title: LocaleKeys.orderHistory.tr(),
          value: 1,
          onPressed: () {
            OrderHistoryRouter(context).navigate();
          },
        ),
        MenuItemModel(
          disabled: true,
          title: LocaleKeys.addStockHistory.tr(),
          value: 2,
          onPressed: () {
            AddProductHistoryRouter(context).navigate();
          },
        ),
      ],
    );
  }
}
