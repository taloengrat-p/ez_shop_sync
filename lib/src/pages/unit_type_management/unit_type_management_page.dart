import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/unit_type_management/unit_type_management_cubit.dart';
import 'package:ez_shop_sync/src/pages/unit_type_management/unit_type_management_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:get_it/get_it.dart';

class UnitTypeManagementPage extends StatefulWidget {
  const UnitTypeManagementPage({super.key});

  @override
  _UnitTypeManagementState createState() => _UnitTypeManagementState();
}

class _UnitTypeManagementState extends State<UnitTypeManagementPage> {
  final _cubit = GetIt.I<UnitTypeManagementCubit>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((time) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<UnitTypeManagementCubit, UnitTypeManagementState>(
        bloc: _cubit,
        listener: (context, state) {},
        child: BlocBuilder<UnitTypeManagementCubit, UnitTypeManagementState>(
          bloc: _cubit,
          builder: (context, state) {
            return BaseScaffolds(
              appBar:
                  AppbarWidget(
                    context,
                    centerTitle: false,
                    title: LocaleKeys.unitTypeManagement.tr(),
                    actions: [],
                  ).build(),
              body: _buildPage(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, UnitTypeManagementState state) {
    return SingleChildScrollView(child: Column(children: [Container(height: DimensionsKeys.heightBts)]));
  }
}
