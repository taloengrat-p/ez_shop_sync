import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';

enum TransactionMethodType {
  addProduct,
  order,
  undefined;

  String get label => switch (this) {
        TransactionMethodType.addProduct => LocaleKeys.tansactionTitleTypes_addStock.tr(),
        TransactionMethodType.order => LocaleKeys.tansactionTitleTypes_order.tr(),
        TransactionMethodType.undefined => 'undefined',
      };

  static TransactionMethodType fromString(String? value) {
    switch (value) {
      case 'addProduct':
        return TransactionMethodType.addProduct;
      case 'order':
        return TransactionMethodType.order;
      default:
        return TransactionMethodType.undefined;
    }
  }
}
