import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/pages/test/test_cubit.dart';
import 'package:ez_shop_sync/src/pages/test/test_state.dart';   
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';

class TestPage extends StatefulWidget {
  const TestPage({
    Key? key,
  }) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<TestPage> {
  late TestCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = TestCubit();

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
      child: BlocListener<TestCubit, TestState>(
        listener: (context, state) {},
        child: BlocBuilder<TestCubit, TestState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                centerTitle: false,
                title: "Test",
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

  Widget _buildPage(BuildContext context, TestState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    );
  }
}
