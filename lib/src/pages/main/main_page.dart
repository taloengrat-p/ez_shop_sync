import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/repository/user/user_repository.dart';
import 'package:ez_shop_sync/src/pages/add_product/add_product_router.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/cart/cart_router.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_router.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_state.dart';
import 'package:ez_shop_sync/src/pages/introduce/introduce_page.dart';
import 'package:ez_shop_sync/src/pages/introduce/introduce_router.dart';
import 'package:ez_shop_sync/src/pages/main/home/home_page.dart';
import 'package:ez_shop_sync/src/pages/main/main_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/main_state.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_page.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_page.dart';
import 'package:ez_shop_sync/src/pages/main/statistic/statistic_page.dart';
import 'package:ez_shop_sync/src/pages/notification/notification_router.dart';
import 'package:ez_shop_sync/src/pages/notification/notification_state.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/profile_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late CircularBottomNavigationController _navigationController;
  late PageController _pageController;
  late MainCubit _cubit;
  late BaseCubit baseCubit;

  @override
  void initState() {
    super.initState();
    baseCubit = BlocProvider.of<BaseCubit>(context);
    _cubit = MainCubit(
      baseCubit: baseCubit,
      userRepository: GetIt.I<UserRepository>(),
    );
    _navigationController = CircularBottomNavigationController(_cubit.currentPage);

    _pageController = PageController(initialPage: _cubit.currentPage);

    WidgetsBinding.instance.addPostFrameCallback((time) {
      final argruments = ModalRoute.of(context)?.settings.arguments;
      if (argruments is MainArgruments) {
        _pageController.jumpToPage(argruments.startWithIndexPage);
      }
      _cubit.doCheckUserAlreadyUseApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocListener<MainCubit, MainState>(
        listener: (context, state) {
          if (state is MainGotoIntroduceFlow) {
            CreateStoreRouter(context).pushNamedAndRemoveUntil(
              argruments: const CreateStoreArgrument(true),
            );
          }
        },
        child: BlocBuilder<MainCubit, MainState>(
          builder: (context, state) {
            return BaseScaffolds(
              isLoading: state is MainLoading,
              backgroundColor: Colors.white,
              appBar: AppbarWidget(
                context,
                color: Colors.transparent,
                titleWidget: Row(
                  children: [
                    Expanded(
                      child: ProfileWidget(
                        name: _cubit.username ?? '',
                      ),
                    ),
                  ],
                ),
                actions: [
                  ContainerCircleWidget(
                    child: _cubit.baseCubit.addProductCount != 0
                        ? Badge.count(
                            count: _cubit.baseCubit.addProductCount,
                            child: const Icon(CupertinoIcons.bag_badge_plus),
                          )
                        : const Icon(
                            CupertinoIcons.bag_badge_plus,
                          ),
                    onPressed: () {
                      AddProductRouter(context).navigate();
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ContainerCircleWidget(
                    child: _cubit.baseCubit.cartCount != 0
                        ? Badge.count(
                            count: _cubit.baseCubit.cartCount,
                            child: const Icon(CupertinoIcons.cart),
                          )
                        : const Icon(CupertinoIcons.cart),
                    onPressed: () {
                      CartRouter(context).navigate();
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  BlocBuilder(
                    bloc: GetIt.I<BaseCubit>(),
                    builder: (context, state) {
                      return ContainerCircleWidget(
                        child: _cubit.baseCubit.notification.isNotEmpty
                            ? Badge.count(
                                count: _cubit.baseCubit.notification.length,
                                child: const Icon(CupertinoIcons.bell),
                              )
                            : const Icon(CupertinoIcons.bell),
                        onPressed: () {
                          NotificationRouter(context).navigate(
                            argruments: NotificationArgrument(_cubit.baseCubit.notification),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ).build(),
              body: Stack(
                fit: StackFit.expand,
                children: [
                  PageView(
                    // physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (value) {
                      _navigationController.value = value;
                      _cubit.setCurrentPageView(value);
                    },
                    children: [
                      HomePage(),
                      ProductPage(),
                      StatisticPage(),
                      MorePage(),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CircularBottomNavigation(
                      [
                        TabItem(
                          CupertinoIcons.home,
                          LocaleKeys.home.tr(),
                          ColorKeys.white,
                          circleStrokeColor: ColorKeys.primary,
                          labelStyle: TextStyle(
                            color: ColorKeys.primary,
                          ),
                        ),
                        TabItem(
                          CupertinoIcons.bag,
                          LocaleKeys.products.tr(),
                          ColorKeys.white,
                          circleStrokeColor: ColorKeys.primary,
                          labelStyle: TextStyle(
                            color: ColorKeys.primary,
                          ),
                        ),
                        // TabItem(
                        //   CupertinoIcons.money_dollar_circle,
                        //   LocaleKeys.transactions.tr(),
                        //   ColorKeys.white,
                        //   circleStrokeColor: ColorKeys.primary,
                        //   labelStyle: TextStyle(
                        //     color: ColorKeys.text,
                        //   ),
                        // ),
                        TabItem(
                          CupertinoIcons.chart_bar_square,
                          LocaleKeys.statistic.tr(),
                          ColorKeys.white,
                          circleStrokeColor: ColorKeys.primary,
                          labelStyle: TextStyle(
                            color: ColorKeys.primary,
                          ),
                        ),
                        TabItem(
                          Icons.menu_rounded,
                          LocaleKeys.menu.tr(),
                          ColorKeys.white,
                          circleStrokeColor: ColorKeys.primary,
                          labelStyle: TextStyle(
                            color: ColorKeys.primary,
                          ),
                        ),
                      ],
                      circleStrokeWidth: 1.5,
                      iconsSize: 24,
                      normalIconColor: ColorKeys.primary,
                      selectedIconColor: ColorKeys.primary,
                      controller: _navigationController,
                      selectedCallback: (int? selectedPos) {
                        if (selectedPos == null) {
                          return;
                        }

                        if ((selectedPos - _cubit.currentPage).abs() > 1) {
                          _pageController.jumpToPage(selectedPos);
                        } else {
                          _pageController.animateToPage(selectedPos,
                              duration: const Duration(milliseconds: 300), curve: Curves.linear);
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
