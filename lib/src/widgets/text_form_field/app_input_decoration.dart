import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';

class AppInputDecoration {
  bool readOnly;
  EdgeInsetsGeometry? contentPadding;
  Widget? suffixIcon;
  Widget? suffix;
  TextFormFieldUiType autoCompleteType;
  double borderRadius;
  String? hintText;
  String? errorText;

  AppInputDecoration({
    this.readOnly = false,
    this.contentPadding,
    this.suffixIcon,
    this.suffix,
    this.autoCompleteType = TextFormFieldUiType.normal,
    this.borderRadius = 8,
    this.hintText,
    this.errorText,
  });

  InputDecoration build() {
    final border = BorderRadius.circular(borderRadius);

    return InputDecoration(
      fillColor: readOnly ? Colors.grey.withOpacity(0.3) : Colors.white,
      filled: true,
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
      suffixIcon: suffixIcon,
      suffix: suffix,
      border: OutlineInputBorder(
        borderRadius: border,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: border,
        borderSide: const BorderSide(color: Colors.black, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: border,
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      labelStyle: const TextStyle(fontSize: 17),
      hintStyle: TextStyle(color: ColorKeys.text),
      hintText: hintText,
      errorStyle: const TextStyle(
        color: Colors.red,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      errorMaxLines: 4,
      errorText: errorText,
      errorBorder: OutlineInputBorder(
        gapPadding: 0,
        borderRadius: border,
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: border,
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
