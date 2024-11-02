import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';

enum TransactionMethodType {
  addStock,
  order,
  undefined;

  String get label => switch (this) {
        TransactionMethodType.addStock => LocaleKeys.tansactionTitleTypes_addStock.tr(),
        TransactionMethodType.order => LocaleKeys.tansactionTitleTypes_order.tr(),
        TransactionMethodType.undefined => 'undefined',
      };

  static TransactionMethodType fromString(String? value) {
    switch (value) {
      case 'addStock':
        return TransactionMethodType.addStock;
      case 'order':
        return TransactionMethodType.order;
      default:
        return TransactionMethodType.undefined;
    }
  }
}
