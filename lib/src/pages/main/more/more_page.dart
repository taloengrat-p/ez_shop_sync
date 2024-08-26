import 'dart:developer';

import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/more/models/menu_item_model.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_state.dart';
import 'package:ez_shop_sync/src/pages/main/more/widgets/menu_group_widget.dart';
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
    cubit = MoreCubit(baseCubit: baseCubit);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<MoreCubit, MoreState>(
        builder: (context, state) {
          return BaseScaffolds(
            appBar: AppbarWidget(
              centerTitle: false,
              title: 'Menu',
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
          _buildStoreManagement(),
          const SizedBox(
            height: 16,
          ),
          _buildUserManagement(),
          const SizedBox(
            height: 16,
          ),
          _buildAppSettings(),
          const SizedBox(
            height: 32,
          ),
          ButtonWidget(
            label: 'Log out',
            margin: const EdgeInsets.symmetric(horizontal: 16),
            backgroundColor: Colors.red,
            onPressed: cubit.doLogout,
          ),
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Version ${cubit.appVersion}'),
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
                onPressed: onHandleChangeStore,
                icon: const Icon(
                  Icons.add_circle_rounded,
                  color: Colors.yellow,
                  size: 36,
                ),
              ),
              if (cubit.stores.isNotEmpty)
                IconButton(
                  onPressed: onHandleChangeStore,
                  icon: const Icon(
                    Icons.expand_circle_down_rounded,
                    color: Colors.white,
                    size: 36,
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
    }
  }

  Widget _buildAppSettings() {
    return MenuGroupWidget(
      title: 'App Settings',
      items: [
        MenuItemModel(
          title: 'Language',
          value: 1,
          trailing: Row(
            children: [
              const Text('English'),
              const SizedBox(
                width: 4,
              ),
              Switch.adaptive(
                value: cubit.isTh,
                activeColor: Colors.orange.shade300,
                inactiveTrackColor: Colors.orange.shade300,
                onChanged: cubit.changeLanguage,
              ),
              const SizedBox(
                width: 4,
              ),
              const Text('ไทย'),
            ],
          ),
        ),
        MenuItemModel(
          title: 'Theme',
          value: 1,
          onPressed: () {
            log('message');
          },
        ),
      ],
    );
  }

  Widget _buildStoreManagement() {
    return MenuGroupWidget(
      title: 'Store Settings',
      items: [
        MenuItemModel(
          title: 'Store Management',
          value: 1,
          onPressed: () {
            log('message');
          },
        ),
        MenuItemModel(
          title: 'User Management',
          value: 1,
          disabled: true,
          onPressed: () {
            log('message');
          },
        ),
      ],
    );
  }

  Widget _buildUserManagement() {
    return MenuGroupWidget(
      title: 'User Settings',
      items: [
        MenuItemModel(
          title: 'Profile Settings',
          value: 1,
          onPressed: () {
            log('message');
          },
        ),
        MenuItemModel(
          title: 'Password Setting',
          value: 1,
          disabled: true,
          onPressed: () {
            log('message');
          },
        ),
        MenuItemModel(
          title: 'Pin Setting',
          value: 1,
          disabled: true,
          onPressed: () {
            log('message');
          },
        ),
      ],
    );
  }
}
