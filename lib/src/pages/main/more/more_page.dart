import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/enums/role_type.enum.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/_app/app_state.dart';
import 'package:ez_shop_sync/src/pages/add_product_history/add_product_history_router.dart';
import 'package:ez_shop_sync/src/pages/branch_management/branch_management_router.dart';
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
import 'package:ez_shop_sync/src/pages/unit_type_management/unit_type_management_router.dart';
import 'package:ez_shop_sync/src/pages/user_management/user_management_router.dart';
import 'package:ez_shop_sync/src/utils/bottom_sheet_utils.dart';
import 'package:ez_shop_sync/src/utils/dialog_utils.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/bottoms/bottom_sheet_select_store_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/circle_profile_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
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
  final _cubit = GetIt.I<MoreCubit>();
  @override
  void initState() {
    log('[init]', name: runtimeType.toString());
    super.initState();
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
    return BlocListener<MoreCubit, MoreState>(
      bloc: _cubit,
      listener: (context, state) async {
        if (state is MoreClickPinSetting) {
          if (state.type == PinType.create) {
            await PinSetupRouter(context).navigate();

            _cubit.refresh();
          } else if (state.type == PinType.setting) {
            final result = await PinVerifyRouter(context).navigate();

            if (result is PinVerifySuccess) {
              await Future.delayed(Duration.zero, () async {
                PinSetupRouter(context).navigate(
                  argruments: const PinSetupArgruments(title: 'Create New PIN', desc: 'Enter the code for new PIN'),
                );
              });

              _cubit.refresh();
            } else {
              _cubit.refresh();
            }
          }
        } else if (state is MoreLogoutSuccess) {
          _cubit.appCubit.clearCurrentUserData();
          LoginRouter(context).pushNamedAndRemoveUntil();
        }
      },
      child: BlocBuilder<AppCubit, AppState>(
        bloc: GetIt.I<AppCubit>(),
        builder: (context, appState) {
          return BlocBuilder<MoreCubit, MoreState>(
            bloc: _cubit,
            builder: (context, state) {
              return BaseScaffolds(
                enableAppModeDisplay: false,
                backgroundColor: Colors.white,
                isLoading: state is AppLoading,
                appBar: AppbarWidget(context, centerTitle: false, title: LocaleKeys.menu.tr(), actions: []).build(),
                body: SingleChildScrollView(child: buildBody()),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DimensionsKeys.pagePaddingHzt),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStoreProfile(),
            const SizedBox(height: 16),
            _buildMenuSettings(),
            const SizedBox(height: 16),
            if ((_cubit.appCubit.userRoleTypeCurrentStore?.power ?? -1) >= RoleType.manager.power) ...[
              _buildStoreSettings(),
              const SizedBox(height: 16),
            ],
            _buildUserSettings(),
            const SizedBox(height: 16),
            _buildAppSettings(),
            const SizedBox(height: 32),
            ButtonWidget(
              label: LocaleKeys.logout.tr(),
              backgroundColor: Colors.red,
              leading: const Icon(Icons.logout_rounded),
              onPressed: doLogout,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(LocaleKeys.appVersion.tr(args: [_cubit.version, _cubit.buildNumber])),
              ),
            ),
            const SizedBox(height: DimensionsKeys.heightBts * 1.75),
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
                  if (_cubit.stores.isNotEmpty) CircleProfileWidget(title: _cubit.user?.displayName),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            _cubit.user?.displayName ?? _cubit.user?.email ?? '-',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              overflow: TextOverflow.ellipsis,
                              color: ColorKeys.primary.withOpacity(0.6).getContrast(),
                            ),
                          ),
                        ),
                        if (_cubit.storeName.isEmpty)
                          Text(
                            LocaleKeys.createFirstStore.tr(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              overflow: TextOverflow.ellipsis,
                              color: ColorKeys.primary.withOpacity(0.6).getContrast(),
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          '${LocaleKeys.branch.tr()} : ${_cubit.appCubit.branch?.name ?? '--'}',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            overflow: TextOverflow.ellipsis,
                            color: ColorKeys.primary.withOpacity(0.6).getContrast(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                ContainerCircleWidget(
                  color: ColorKeys.secondary.getContrast(),
                  child: const Icon(Icons.add_business_rounded),
                  onPressed: () {
                    CreateStoreRouter(context).navigate();
                  },
                ),
                const SizedBox(width: 8),
                if (_cubit.stores.isNotEmpty)
                  ContainerCircleWidget(
                    color: ColorKeys.secondary.getContrast(),
                    onPressed: onHandleChangeStore,
                    child: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onHandleChangeStore() async {
    final result = await BottomSheetUtils.showDragable(
      context,
      title: LocaleKeys.yourStores.tr(),
      body: BottomSheetSelectStoreWidget(
        stores: _cubit.stores,
        initStoreId: _cubit.currentStore?.id,
        initBranchId: _cubit.currentBranch?.id,
      ),
    );
    if (result != null && result is BottomSheetSelectStoreWidgetArgrument) {
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
          title: LocaleKeys.branchManagement.tr(),
          value: 1,
          onPressed: () {
            BranchManagementRouter(context).navigate();
          },
        ),
        MenuItemModel(
          title: LocaleKeys.userManagement.tr(),
          value: 2,
          onPressed: () async {
            UserManagementRouter(context).navigate();
          },
        ),
        if (false)
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
          // disabled: true,
          onPressed: () {
            CategoryManagementRouter(context).navigate();
          },
        ),
        MenuItemModel(
          title: LocaleKeys.unitTypeManagement.tr(),
          value: 3,
          // disabled: true,
          onPressed: () {
            UnitTypeManagementRouter(context).navigate();
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
        MenuItemModel(title: LocaleKeys.pinSetting.tr(), value: 1, onPressed: _cubit.clickPinSetting),
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
              const SizedBox(width: 4),
              Switch.adaptive(
                value: context.locale == const Locale('th'),
                activeColor: ColorKeys.primary,
                inactiveTrackColor: ColorKeys.primary,
                onChanged: (val) => _cubit.changeLanguage(context, val),
              ),
              const SizedBox(width: 4),
              Text(LocaleKeys.languageTh.tr()),
            ],
          ),
        ),
        MenuItemModel(
          title: LocaleKeys.notificationSetting_title.tr(),
          value: 1,
          onPressed: () async {
            final result = await ThemeSettingRouter(context).navigate();

            if (result is ThemeSettingSuccess) {
              _cubit.refresh();
            }
          },
        ),
        if (false)
          MenuItemModel(
            disabled: true,
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
          title: LocaleKeys.orderHistory.tr(),
          value: 1,
          onPressed: () {
            OrderHistoryRouter(context).navigate();
          },
        ),
        MenuItemModel(
          title: LocaleKeys.addStockHistory.tr(),
          value: 2,
          onPressed: () {
            AddProductHistoryRouter(context).navigate();
          },
        ),
      ],
    );
  }

  doLogout() async {
    final result = await DialogUtils.showConfirm(
      context,
      title: LocaleKeys.confirmLogout_title.tr(),
      desc: LocaleKeys.confirmLogout_desc.tr(),
    );
    if (result == ConfirmDialogResult.ok) {
      await _cubit.doLogout();
    }
  }
}
