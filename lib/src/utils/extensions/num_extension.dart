import 'package:ez_shop_sync/src/constances/application_constance.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';

extension NumExtension on num {
  String prefixCurrency() {
    return '${ApplicationConstance.currencyTHB}$this';
  }

  String suffuxCurrency() {
    return '${ApplicationConstance.currencyTHB}$this';
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
