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
}

extension StringNullableExtendsions on String? {
  String defaultDash() {
    return this ?? '--';
  }
}
