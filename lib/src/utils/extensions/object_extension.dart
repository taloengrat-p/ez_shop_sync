import 'package:ez_shop_sync/src/constances/application_constance.dart';

extension ObjectExtensions on Object? {
  bool get isNull => this == null;
  bool get isNotNull => !isNull;

  String elseDisplay() {
    return this == null || this == '' ? ApplicationConstance.emptyData : toString();
  }
}
