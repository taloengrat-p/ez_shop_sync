import 'dart:developer';

import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_state.dart';
import 'package:ez_shop_sync/src/utils/bottom_sheet_utils.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extendsions.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/bottom_sheet/model/bottom_sheet_menu_model.dart';
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
    return Column(
      children: [
        _buildProfile(),
        Container(
          height: 60,
        ),
      ],
    );
  }

  Widget _buildProfile() {
    return Card(
      color: ColorKeys.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleProfileWidget(
              title: cubit.shortName,
            ),
            Text(cubit.currentStore),
            const Spacer(),
            if (cubit.stores.isNotEmpty)
              IconButton(
                onPressed: () async {
                  final result = await BottomSheetUtils.showMenu(context, items: [
                    ...cubit.stores.map(
                      (e) => BottomSheetMenuModel(
                        label: e.name,
                        icon: CircleProfileWidget(
                          title: e.name.toSubStringFirstToIndex(2),
                        ),
                        value: e.id,
                      ),
                    ),
                  ]);
                  if (result != null) {
                    onHandleChangeStore(result);
                  }
                },
                icon: const Icon(
                  Icons.expand_circle_down_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onHandleChangeStore(dynamic result) {
    log('onHandleChangeStore : $result');
  }
}
