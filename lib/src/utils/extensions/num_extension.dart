import 'dart:math';

import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';

extension NumExtension on num {
  String prefixCurrency() {
    return '${ApplicationConstance.currencyTHB}$this';
  }

  String suffuxCurrency() {
    return '${ApplicationConstance.currencyTHB}$this';
  }

  num ceilToDecimalPlaces(int decimalPlaces) {
    double factor = pow(10, decimalPlaces).toDouble();
    return (this * factor).ceil() / factor;
  }
}

extension NumNullableExtension on num? {
  String elsePrefixCurrency() {
    return '${ApplicationConstance.currencyTHB}${this ?? ''.elseDisplay()}';
  }

  String elseSuffuxCurrency() {
    return '${ApplicationConstance.currencyTHB}${this ?? ''.elseDisplay()}';
  }
}
