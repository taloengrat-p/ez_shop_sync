import 'package:currency_picker/currency_picker.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_cubit.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_state.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';

class StoreManagementPage extends StatefulWidget {
  const StoreManagementPage({
    Key? key,
  }) : super(key: key);

  @override
  _StoreManagementState createState() => _StoreManagementState();
}

class _StoreManagementState extends State<StoreManagementPage> {
  late StoreManagementCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = StoreManagementCubit();

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
      child: BlocListener<StoreManagementCubit, StoreManagementState>(
        listener: (context, state) {},
        child: BlocBuilder<StoreManagementCubit, StoreManagementState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(context, 
                centerTitle: false,
                title: "StoreManagement",
                actions: [],
              ).build(),
              body: SingleChildScrollView(
                child: _buildPage(context, state),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, StoreManagementState state) {
    return Column(
      children: [
        TextFormFieldUiWidget(
          label: 'Currency',
          child: ButtonWidget(
            label: 'pick',
            onPressed: () {
              showCurrencyPicker(
                context: context,
                showFlag: true,
                showCurrencyName: true,
                showCurrencyCode: true,
                onSelect: (Currency currency) {
                  print('Select currency: ${currency.symbol}');
                },
              );
            },
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        ),
      ],
    );
  }
}
