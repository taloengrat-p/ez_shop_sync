// ignore_for_file: constant_identifier_names

import 'package:ez_shop_sync/src/pages/add_product/add_product_page.dart';
import 'package:ez_shop_sync/src/pages/add_product_history_detail/add_product_history_detail_page.dart';
import 'package:ez_shop_sync/src/pages/add_product_history/add_product_history_page.dart';
import 'package:ez_shop_sync/src/pages/add_user/add_user_page.dart';
import 'package:ez_shop_sync/src/pages/cart/cart_page.dart';
import 'package:ez_shop_sync/src/pages/category_management/category_management_page.dart';
import 'package:ez_shop_sync/src/pages/create_category/create_category_page.dart';
import 'package:ez_shop_sync/src/pages/create_product/create_product_page.dart';
import 'package:ez_shop_sync/src/pages/create_product_detail/create_product_detail_page.dart';
import 'package:ez_shop_sync/src/pages/create_store/create_store_page.dart';
import 'package:ez_shop_sync/src/pages/create_tag/create_tag_page.dart';
import 'package:ez_shop_sync/src/pages/introduce/introduce_page.dart';
import 'package:ez_shop_sync/src/pages/login/login_page.dart';
import 'package:ez_shop_sync/src/pages/main/main_page.dart';
import 'package:ez_shop_sync/src/pages/notification/notification_page.dart';
import 'package:ez_shop_sync/src/pages/notification_detail/notification_detail_page.dart';
import 'package:ez_shop_sync/src/pages/order_complete/order_complete_page.dart';
import 'package:ez_shop_sync/src/pages/order_history/order_history_page.dart';
import 'package:ez_shop_sync/src/pages/order_history_detail/order_history_detail_page.dart';
import 'package:ez_shop_sync/src/pages/password_setting/password_setting_page.dart';
import 'package:ez_shop_sync/src/pages/pin_setup/pin_setup_page.dart';
import 'package:ez_shop_sync/src/pages/pin_verify/pin_verify_page.dart';
import 'package:ez_shop_sync/src/pages/product_detail/product_detail_page.dart';
import 'package:ez_shop_sync/src/pages/product_settings/product_settings_page.dart';
import 'package:ez_shop_sync/src/pages/profile_settings/profile_settings_page.dart';
import 'package:ez_shop_sync/src/pages/store_management/store_management_page.dart';
import 'package:ez_shop_sync/src/pages/tag_management/tag_management_page.dart';
import 'package:ez_shop_sync/src/pages/theme_setting/theme_setting_page.dart';
import 'package:ez_shop_sync/src/pages/transaction_statement_detail/transaction_statement_detail_page.dart';
import 'package:ez_shop_sync/src/pages/transactions_chart_details/transactions_chart_details_page.dart';
import 'package:ez_shop_sync/src/pages/user_management/user_management_page.dart';
import 'package:ez_shop_sync/src/pages/verify_phone_number/verify_phone_number_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String ROUTE_MAIN = '/MAIN';
  static const String ROUTE_CREATE_PRODUCT = '/ROUTE_CREATE_PRODUCT';
  static const String ROUTE_PRODUCT_DETAIL = '/ROUTE_PRODUCT_DETAIL';
  static const String ROUTE_INTRODUCE = '/ROUTE_INTRODUCE';
  static const String ROUTE_CREATESTORE = '/ROUTE_CREATESTORE';
  static const String ROUTE_STOREMANAGEMENT = '/ROUTE_STOREMANAGEMENT';
  static const String ROUTE_PROFILESETTINGS = '/ROUTE_PROFILESETTINGS';
  static const String ROUTE_USERMANAGEMENT = '/ROUTE_USERMANAGEMENT';
  static const String ROUTE_PASSWORDSETTING = '/ROUTE_PASSWORDSETTING';
  static const String ROUTE_THEMESETTING = '/ROUTE_THEMESETTING';
  static const String ROUTE_PINVERIFY = '/ROUTE_PINVERIFY';
  static const String ROUTE_PINSETUP = '/ROUTE_PINSETUP';
  static const String ROUTE_TAGMANAGEMENT = '/ROUTE_TAGMANAGEMENT';
  static const String ROUTE_CREATETAG = '/ROUTE_CREATETAG';
  static const String ROUTE_CATEGORYMANAGEMENT = '/ROUTE_CATEGORYMANAGEMENT';
  static const String ROUTE_CREATECATEGORY = '/ROUTE_CREATECATEGORY';
  static const String ROUTE_CART = '/ROUTE_CART';
  static const String ROUTE_PRODUCTSETTINGS = '/ROUTE_PRODUCTSETTINGS';
  static const String ROUTE_ORDERCOMPLETE = '/ROUTE_ORDERCOMPLETE';
  static const String ROUTE_ORDERHISTORY = '/ROUTE_ORDERHISTORY';
  static const String ROUTE_ORDERHISTORYDETAIL = '/ROUTE_ORDERHISTORYDETAIL';
  static const String ROUTE_TRANSACTIONSCHARTDETAILS = '/ROUTE_TRANSACTIONSCHARTDETAILS';
  static const String ROUTE_TRANSACTIONSTATEMENTDETAIL = '/ROUTE_TRANSACTIONSTATEMENTDETAIL';
  static const String ROUTE_ADDPRODUCTHISTORY = '/ROUTE_ADDPRODUCTHISTORY';
  static const String ROUTE_ADDPRODUCT = '/ROUTE_ADDPRODUCT';
  static const String ROUTE_ADDPRODUCTHISTORYDETAIL = '/ROUTE_ADDPRODUCTHISTORYDETAIL';
  static const String ROUTE_LOGIN = '/ROUTE_LOGIN';
  static const String ROUTE_VERIFYPHONENUMBER = '/ROUTE_VERIFYPHONENUMBER';
  static const String ROUTE_NOTIFICATION = '/ROUTE_NOTIFICATION';
  static const String ROUTE_ADDUSER = '/ROUTE_ADDUSER';
  static const String ROUTE_NOTIFICATIONDETAIL = '/ROUTE_NOTIFICATIONDETAIL';
  static const String ROUTE_CREATEPRODUCTDETAIL = '/ROUTE_CREATEPRODUCTDETAIL';

  static Map<String, Widget Function(BuildContext)> values = {
    ROUTE_MAIN: (context) => const MainPage(),
    ROUTE_CREATE_PRODUCT: (context) => const CreateProductPage(),
    ROUTE_PRODUCT_DETAIL: (context) => const ProductDetailPage(),
    ROUTE_INTRODUCE: (context) => const IntroduceFlowPage(),
    ROUTE_CREATESTORE: (context) => const CreateStorePage(),
    ROUTE_STOREMANAGEMENT: (context) => const StoreManagementPage(),
    ROUTE_PROFILESETTINGS: (context) => const ProfileSettingsPage(),
    ROUTE_USERMANAGEMENT: (context) => const UserManagementPage(),
    ROUTE_PASSWORDSETTING: (context) => const PasswordSettingPage(),
    ROUTE_THEMESETTING: (context) => const ThemeSettingPage(),
    ROUTE_PINVERIFY: (context) => const PinVerifyPage(),
    ROUTE_PINSETUP: (context) => const PinSetupPage(),
    ROUTE_TAGMANAGEMENT: (context) => const TagManagementPage(),
    ROUTE_CREATETAG: (context) => const CreateTagPage(),
    ROUTE_CATEGORYMANAGEMENT: (context) => const CategoryManagementPage(),
    ROUTE_CREATECATEGORY: (context) => const CreateCategoryPage(),
    ROUTE_CART: (context) => const CartPage(),
    ROUTE_PRODUCTSETTINGS: (context) => const ProductSettingsPage(),
    ROUTE_ORDERCOMPLETE: (context) => const OrderCompletePage(),
    ROUTE_ORDERHISTORY: (context) => const OrderHistoryPage(),
    ROUTE_ORDERHISTORYDETAIL: (context) => const OrderHistoryDetailPage(),
    ROUTE_TRANSACTIONSCHARTDETAILS: (context) => const TransactionsChartDetailsPage(),
    ROUTE_TRANSACTIONSTATEMENTDETAIL: (context) => const TransactionStatementDetailPage(),
    ROUTE_ADDPRODUCTHISTORY: (context) => const AddProductHistoryPage(),
    ROUTE_ADDPRODUCT: (context) => const AddProductPage(),
    ROUTE_ADDPRODUCTHISTORYDETAIL: (context) => const AddProductHistoryDetailPage(),
    ROUTE_LOGIN: (context) => const LoginPage(),
    ROUTE_VERIFYPHONENUMBER: (context) => const VerifyPhoneNumberPage(),
    ROUTE_NOTIFICATION: (context) => const NotificationPage(),
    ROUTE_ADDUSER: (context) => const AddUserPage(),
    ROUTE_NOTIFICATIONDETAIL: (context) => const NotificationDetailPage(),
    ROUTE_CREATEPRODUCTDETAIL: (context) => const CreateProductDetailPage(),
  };
}
