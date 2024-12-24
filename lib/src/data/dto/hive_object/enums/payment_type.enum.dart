import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';

enum PaymentMethodType {
  cash,
  qrcode,
  undefined;

  factory PaymentMethodType.fromString(String? value) {
    switch (value) {
      case 'cash':
        return cash;
      case 'qrcode':
        return qrcode;
      default:
        return undefined;
    }
  }

  String get display {
    switch (this) {
      case cash:
        return LocaleKeys.paymentMethodOptions_cash.tr();
      case qrcode:
        return LocaleKeys.paymentMethodOptions_qrCode.tr();
      default:
        return 'undefined';
    }
  }
}
