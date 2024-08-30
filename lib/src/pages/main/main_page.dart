import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/pages/main/history/history_page.dart';
import 'package:ez_shop_sync/src/pages/main/home/home_page.dart';
import 'package:ez_shop_sync/src/pages/main/main_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/main_state.dart';
import 'package:ez_shop_sync/src/pages/main/more/more_page.dart';
import 'package:ez_shop_sync/src/pages/main/product/product_page.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/pages/main/transaction/transaction_page.dart';
import 'package:ez_shop_sync/src/widgets/scaffolds/base_scaffolds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late CircularBottomNavigationController _navigationController;
  late PageController _pageController;
  late MainCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = MainCubit();
    _navigationController =
        CircularBottomNavigationController(cubit.currentPage);
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
              body: Stack(
                fit: StackFit.expand,
                children: [
                  PageView(
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
                          CupertinoIcons.cube_box,
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
                          Icons.history_rounded,
                          LocaleKeys.histories.tr(),
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
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear);
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
