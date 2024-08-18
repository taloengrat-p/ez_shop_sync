import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:ez_shop_sync/src/pages/main/history/history_page.dart';
import 'package:ez_shop_sync/src/pages/main/home/home_page.dart';
import 'package:ez_shop_sync/src/pages/main/main_cubit.dart';
import 'package:ez_shop_sync/src/pages/main/main_state.dart';
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
              body: Stack(
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
                      Container(),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CircularBottomNavigation(
                      [
                        TabItem(CupertinoIcons.home, "Home", ColorKeys.skyBlue),
                        TabItem(CupertinoIcons.cube_box, "Products", ColorKeys.skyBlue),
                        TabItem(CupertinoIcons.money_dollar_circle, "Transaction", ColorKeys.skyBlue),
                        TabItem(Icons.history_rounded, "History", ColorKeys.skyBlue),
                        TabItem(Icons.menu_rounded, "Menu", ColorKeys.skyBlue),
                      ],
                      iconsSize: 24,
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
