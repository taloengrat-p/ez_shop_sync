import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:flutter/material.dart';

extension StringExtendsions on String {
  String toSubStringFirstToIndex(int index) {
    return substring(0, index).toUpperCase();
  }

  Color toColor() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String ignoreSpaceAndUpperCase() {
    return toLowerCase().replaceAll(" ", "");
  }

  String prefixCurrency() {
    return '${ApplicationConstance.currencyTHB}$this';
  }

  String suffuxCurrency() {
    return '${ApplicationConstance.currencyTHB}$this';
  }
}

extension StringNullableExtendsions on String? {
  String elsePrefixCurrency() {
    return '${ApplicationConstance.currencyTHB}${this ?? ''.elseDisplay()}';
  }

  String elseSuffuxCurrency() {
    return '${ApplicationConstance.currencyTHB}${this ?? ''.elseDisplay()}';
  }
}
