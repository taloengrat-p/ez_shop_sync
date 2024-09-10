import 'package:ez_shop_sync/src/pages/product_settings/product_settings_cubit.dart';
import 'package:ez_shop_sync/src/pages/product_settings/product_settings_state.dart';   
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/res/dimensions.dart';

class ProductSettingsPage extends StatefulWidget {
  const ProductSettingsPage({
    super.key,
  });

  @override
  _ProductSettingsState createState() => _ProductSettingsState();
}

class _ProductSettingsState extends State<ProductSettingsPage> {
  late ProductSettingsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ProductSettingsCubit();

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
      child: BlocListener<ProductSettingsCubit, ProductSettingsState>(
        listener: (context, state) {},
        child: BlocBuilder<ProductSettingsCubit, ProductSettingsState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(context, 
                centerTitle: false,
                title: "ProductSettings",
                actions: [],
              ).build(),
              body: _buildPage(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, ProductSettingsState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: DimensionsKeys.heightBts,
          ),
        ],
      ),
    );
  }
}
