import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/base/base_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/history/history_page.dart';
import 'package:ez_shop_sync/src/pages/main/home/home_page.dart';
import 'package:ez_shop_sync/src/pages/main/main_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/main_state.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_page.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_page.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/pages/main/transaction/transaction_page.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/widgets/appbar_widget.dart';
import 'package:ez_shop_sync/src/widgets/circle_profile_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/profile_widget.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late CircularBottomNavigationController _navigationController;
  late PageController _pageController;
  late MainCubit cubit;
  late BaseCubit baseCubit;

  @override
  void initState() {
    super.initState();
    baseCubit = BlocProvider.of<BaseCubit>(context);
    cubit = MainCubit(baseCubit: baseCubit);
    _navigationController = CircularBottomNavigationController(cubit.currentPage);
    _pageController = PageController(initialPage: cubit.currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocListener<MainCubit, MainState>(
        listener: (context, state) {},
        child: BlocBuilder<MainCubit, MainState>(
          builder: (context, state) {
            return BaseScaffolds(
              appBar: AppbarWidget(
                context,
                titleWidget: Row(
                  children: [
                    ProfileWidget(
                      name: cubit.username,
                    ),
                  ],
                ),
                actions: [
                  ContainerCircleWidget(
                    child: Icon(CupertinoIcons.cart),
                    onPressed: () {},
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
                      cubit.setCurrentPageView(value);
                    },
                    children: [
                      HomePage(),
                      ProductPage(),
                      TransactionPage(),
                      HistoryPage(),
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
                            color: ColorKeys.text,
                          ),
                        ),
                        TabItem(
                          CupertinoIcons.bag,
                          LocaleKeys.products.tr(),
                          ColorKeys.white,
                          circleStrokeColor: ColorKeys.primary,
                          labelStyle: TextStyle(
                            color: ColorKeys.text,
                          ),
                        ),
                        TabItem(
                          CupertinoIcons.money_dollar_circle,
                          LocaleKeys.transactions.tr(),
                          ColorKeys.white,
                          circleStrokeColor: ColorKeys.primary,
                          labelStyle: TextStyle(
                            color: ColorKeys.text,
                          ),
                        ),
                        TabItem(
                          CupertinoIcons.chart_bar_square,
                          LocaleKeys.statistic.tr(),
                          ColorKeys.white,
                          circleStrokeColor: ColorKeys.primary,
                          labelStyle: TextStyle(
                            color: ColorKeys.text,
                          ),
                        ),
                        TabItem(
                          Icons.menu_rounded,
                          LocaleKeys.menu.tr(),
                          ColorKeys.white,
                          circleStrokeColor: ColorKeys.primary,
                          labelStyle: TextStyle(
                            color: ColorKeys.text,
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

                        if ((selectedPos - cubit.currentPage).abs() > 1) {
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
