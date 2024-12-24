import 'package:ez_shop_sync/src/pages/add_product_history_detail/add_product_history_detail_cubit.dart';
import 'package:ez_shop_sync/src/pages/add_product_history_detail/add_product_history_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:ez_shop_sync/res/dimensions.dart';

class AddProductHistoryDetailPage extends StatefulWidget {
  const AddProductHistoryDetailPage({
    super.key,
  });

  @override
  _AddProductHistoryDetailState createState() =>
      _AddProductHistoryDetailState();
}

class _AddProductHistoryDetailState extends State<AddProductHistoryDetailPage> {
  late AddProductHistoryDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = AddProductHistoryDetailCubit();

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
      child: BlocListener<AddProductHistoryDetailCubit,
          AddProductHistoryDetailState>(
        listener: (context, state) {},
        child: BlocBuilder<AddProductHistoryDetailCubit,
            AddProductHistoryDetailState>(
          builder: (context, state) {
            return BaseScaffolds(
              enableAppModeDisplay: true,
              appBar: AppbarWidget(
                context,
                centerTitle: false,
                title: "AddProductHistoryDetail",
                actions: [],
              ).build(),
              body: _buildPage(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, AddProductHistoryDetailState state) {
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
