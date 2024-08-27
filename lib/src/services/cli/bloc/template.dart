String pageTemplate = '''
import 'package:%{package}/res/colors.dart';
import 'package:%{package}/src/pages/%{nameSnake}/%{nameSnake}_cubit.dart';
import 'package:%{package}/src/pages/%{nameSnake}/%{nameSnake}_state.dart';   
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:%{package}/src/widgets/appbar_widget.dart';
import 'package:%{package}/src/widgets/scaffolds/base_scaffolds.dart';

class %{name}Page extends StatefulWidget {
  const %{name}Page({
    Key? key,
  }) : super(key: key);

  @override
  _%{name}State createState() => _%{name}State();
}

class _%{name}State extends State<%{name}Page> {
  late %{name}Cubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = %{name}Cubit();

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
      child: BlocListener<%{name}Cubit, %{name}State>(
        listener: (context, state) {},
        child: BlocBuilder<%{name}Cubit, %{name}State>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                centerTitle: false,
                title: "%{name}",
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

  Widget _buildPage(BuildContext context, %{name}State state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    );
  }
}
''';

String cubitTemplate = '''
import 'package:%{package}/src/pages/%{nameSnake}/%{nameSnake}_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class %{name}Cubit extends Cubit<%{name}State> {
  %{name}Cubit() : super(%{name}Initial()) {}
}
''';

String stateTemplate = '''
import 'package:equatable/equatable.dart';

abstract class %{name}State extends Equatable {
  const %{name}State([List props = const []]) : super();

  @override
  List<Object> get props => [];
}

class %{name}Initial extends %{name}State {
  @override
  String toString() => '%{name}Initial';
}

class %{name}Loading extends %{name}State {
  @override
  String toString() => '%{name}Loading';
}

class %{name}Success extends %{name}State {
  @override
  String toString() => '%{name}Success';
}

class %{name}Failure extends %{name}State {
  const %{name}Failure();

  @override
  String toString() => '%{name}Failure';
}
''';

String routerTemplate = '''
import 'package:%{package}/src/routes/base_router.dart';
import 'package:%{package}/src/routes/routes.dart';

class %{name}Router extends BaseRouter {
  %{name}Router(super.context) : super(name: Routes.ROUTE_%{nameUpper});
}

''';
