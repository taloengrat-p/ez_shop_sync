import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_cubit.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_state.dart';   
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';

class CreateStorePage extends StatefulWidget {
  const CreateStorePage({
    Key? key,
  }) : super(key: key);

  @override
  _CreateStoreState createState() => _CreateStoreState();
}

class _CreateStoreState extends State<CreateStorePage> {
  late CreateStoreCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CreateStoreCubit();

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
      child: BlocListener<CreateStoreCubit, CreateStoreState>(
        listener: (context, state) {},
        child: BlocBuilder<CreateStoreCubit, CreateStoreState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                centerTitle: false,
                title: "CreateStore",
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

  Widget _buildPage(BuildContext context, CreateStoreState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    );
  }
}
