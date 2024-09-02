import 'package:flutter/material.dart';
import 'package:flutter_iconpicker_plus/Serialization/iconDataSerialization.dart';

class IconPickerUtils {
  static IconData? getIcon(Map<String, dynamic>? icondata) {
    if (icondata == null) {
      return null;
    }

    final icon = deserializeIcon(icondata);

    if (icon == null) {
      return null;
    }

    return IconData(
      icon.codePoint,
      fontFamily: icon.fontFamily,
    );
  }
}
