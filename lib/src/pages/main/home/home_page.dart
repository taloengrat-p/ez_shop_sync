import 'dart:developer';

import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/home/home_cubit.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit cubit;

  @override
  void initState() {
    log('[init]', name: runtimeType.toString());
    super.initState();
    cubit = HomeCubit(
      baseCubit: GetIt.I<BaseCubit>(),
    );
  }

  @override
  void dispose() {
    log('[dispose]', name: runtimeType.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffolds(
      appBar: AppbarWidget(
        context,
        title: cubit.baseCubit.store?.name,
      ).build(),
    );
  }
}
