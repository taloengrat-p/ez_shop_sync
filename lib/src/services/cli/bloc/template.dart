String pageTemplate = '''
import 'package:%{package}/src/pages/%{nameSnake}/%{nameSnake}_cubit.dart';
import 'package:%{package}/src/pages/%{nameSnake}/%{nameSnake}_state.dart';   
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:%{package}/src/widgets/appbar_widget.dart';
import 'package:%{package}/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:%{package}/res/dimensions.dart';

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
              appBar: AppbarWidget(context, 
                centerTitle: false,
                title: "%{name}",
                actions: [],
              ).build(),
              body: _buildPage(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, %{name}State state) {
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
import 'package:%{package}/src/models/screen_mode.dart';

abstract class %{name}State extends Equatable {
  const %{name}State([List props = const []]) : super();

  @override
  List<Object?> get props => [];
}

class %{name}Refresh extends %{name}State {
  final dynamic value;

  const %{name}Refresh(this.value);
  @override
  String toString() => '%{name}Refresh';

  @override
  List<Object?> get props => [value];
}

class %{name}ScreenModeChange extends %{name}State {
  final ScreenMode mode;

  const ScreenModeChange(this.mode);

  @override
  String toString() => '%{name}ScreenModeChange';
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
