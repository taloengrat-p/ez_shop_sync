import 'package:flutter/material.dart';

import 'text_form_field_ui_widget.dart';

// ignore: must_be_immutable
class TextFormFieldMobileUiWidget extends TextFormFieldUiWidget {
  TextFormFieldMobileUiWidget({
    super.key,
    required String label,
    required bool isRequired,
    required String hintText,
    TextEditingController? controller,
    Function()? onBlur,
    Iterable<String>? autofillHints,
    Function(String? value)? onChanged,
    String? errorText,
    final String? textInitial,
    Function(String? value)? additionalValidator,
    super.onFieldSubmitted,
    super.focusNode,
    final String? textValue,
  }) : super(
          controller: controller,
          label: label,
          validator: (value) {
            final resultDefaultValidate =
                _defaultMobileNumberValidator(value, isRequired);
            if (resultDefaultValidate != null) {
              return resultDefaultValidate;
            }

            if (additionalValidator != null) {
              final resultAdditionalValidate = additionalValidator(value);
              if (resultAdditionalValidate != null) {
                return resultAdditionalValidate;
              }
            }

            return null;
          },
          autofillHints: autofillHints,
          hintText: hintText,
          onChanged: onChanged,
          onBlur: onBlur,
          errorText: errorText,
          isRequired: isRequired,
          textInitial: textInitial,
          textValue: textValue,
        );

  static String? _defaultMobileNumberValidator(String? value, bool isRequired) {
    if (value != null && value.isNotEmpty) {
      final emailRegex = RegExp(r'^\d{4,16}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Your Mobile no. is invalid.';
      }
      return null; // Email is valid
    }

    if (isRequired) {
      return 'This field is required.';
    } else {
      return null;
    }
  }
}
