import 'package:cached_network_image/cached_network_image.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/home/home_cubit.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cubit = GetIt.I<HomeCubit>();
  final bool _stretch = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: GetIt.I<AppCubit>(),
      builder: (context, state) {
        return BaseScaffolds(
          backgroundColor: Colors.white,
          // appBar: AppbarWidget(context, title: cubit.appCubit.store?.name).build(),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: ColorKeys.primary.withOpacity(0.8),
                stretch: _stretch,
                onStretchTrigger: () async {
                  // Triggers when stretching
                },
                // [stretchTriggerOffset] describes the amount of overscroll that must occur
                // to trigger [onStretchTrigger]
                //
                // Setting [stretchTriggerOffset] to a value of 300.0 will trigger
                // [onStretchTrigger] when the user has overscrolled by 300.0 pixels.
                stretchTriggerOffset: 300.0,
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(cubit.appCubit.store?.name ?? '--'),
                  background: const FlutterLogo(),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  return Container(
                    color: index.isOdd ? Colors.white : Colors.black12,
                    height: 100.0,
                    child: Center(child: Text('$index', textScaler: const TextScaler.linear(5.0))),
                  );
                }, childCount: 20),
              ),
            ],
          ),
        );
      },
    );
  }
}
