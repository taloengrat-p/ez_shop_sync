import 'dart:async';
import 'dart:math';

import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/pages/_app/app_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/home/home_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/home/widget/product_home_widget.dart';
import 'package:ez_shop_sync/src/pages/main/product/models/product_item.interface.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cubit = GetIt.I<HomeCubit>();
  final bool _stretch = true;

  final controller = PageController(viewportFraction: 1, keepPage: true);
  int _currentPage = 0;
  late final Timer _timer;
  int get numPage => 6;
  List<Widget> pages = [];

  @override
  void initState() {
    pages = List<Widget>.generate(
      numPage,
      (index) => Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.grey.shade300),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: SizedBox(
          height: 280,
          width: 200,
          child: Center(child: Text("Page $index", style: TextStyle(color: Colors.indigo))),
        ),
      ),
    );

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < numPage - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      controller.animateToPage(_currentPage, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    controller.dispose();
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
                onStretchTrigger: () async {
                  // Triggers when stretching
                },
                // [stretchTriggerOffset] describes the amount of overscroll that must occur
                // to trigger [onStretchTrigger]
                //
                // Setting [stretchTriggerOffset] to a value of 300.0 will trigger
                // [onStretchTrigger] when the user has overscrolled by 300.0 pixels.
                stretchTriggerOffset: 300.0,
                expandedHeight: 290.0,
                flexibleSpace: FlexibleSpaceBar(
                  // title: Text(cubit.appCubit.store?.name ?? '--'),
                  // background: Image.asset('assets/images/logo_outlined.png', width: 100, height: 100),
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 240,
                        width: double.infinity,
                        child: PageView.builder(
                          controller: controller,
                          // itemCount: pages.length,
                          itemBuilder: (_, index) {
                            return pages[index % pages.length];
                          },
                          onPageChanged: (value) {
                            _currentPage = value;
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      SmoothPageIndicator(
                        controller: controller,
                        count: pages.length,
                        effect: const WormEffect(
                          dotHeight: 12,
                          dotWidth: 12,
                          activeDotColor: Colors.amber,
                          type: WormType.thinUnderground,
                        ),
                        onDotClicked: (index) {
                          controller.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.linear,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Section(title: 'Top Sales', products: cubit.appCubit.products),
                      Section(title: 'New Products', products: cubit.appCubit.products),
                      Section(title: 'Promotions', products: cubit.appCubit.products),
                    ],
                  );
                }, childCount: 1),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: DimensionsKeys.heightBts)),
            ],
          ),
        );
      },
    );
  }
}

class Section extends StatelessWidget implements IProductPage {
  final String title;
  final List<Product> products;

  const Section({super.key, required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final random = Random();
                final randomIndex = random.nextInt(products.length);
                final product = products[randomIndex];
                return HomeProductItemWidget(
                  key: ValueKey('product-home-${product.id}'),
                  product: product,
                  iProductItem: this,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  onAddCart(Product product) {
    // TODO: implement onAddCart
    throw UnimplementedError();
  }

  @override
  onAddStock(Product product) {
    // TODO: implement onAddStock
    throw UnimplementedError();
  }

  @override
  onClickGoToDetailPage(Product product) {
    // TODO: implement onClickGoToDetailPage
    throw UnimplementedError();
  }

  @override
  onDelete(Product productId) {
    // TODO: implement onDelete
    throw UnimplementedError();
  }

  @override
  onEdit(String productId) {
    // TODO: implement onEdit
    throw UnimplementedError();
  }
}
