import 'dart:developer';

import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_state.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    log('init', name: runtimeType.toString());
    baseCubit = BlocProvider.of<BaseCubit>(context);
    cubit = MoreCubit(baseCubit: baseCubit);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return cubit;
      },
      child: BlocBuilder<MoreCubit, MoreState>(
        builder: (context, state) {
          return BaseScaffolds(
            appBar: AppbarWidget(centerTitle: false, title: 'Menu').build(),
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
        Card(
          color: ColorKeys.primary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: ColorKeys.white,
                  child: Text(
                    cubit.shortName,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 60,
        ),
      ],
    );
  }
}
