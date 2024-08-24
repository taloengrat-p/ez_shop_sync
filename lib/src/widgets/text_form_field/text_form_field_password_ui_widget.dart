import 'package:flutter/widgets.dart';
import 'text_form_field_ui_widget.dart';

class TextFormFieldPasswordUiWidget extends TextFormFieldUiWidget {
  const TextFormFieldPasswordUiWidget(
      {super.key,
      required String label,
      required bool isRequired,
      required String hintText,
      Function(String? value)? onChanged,
      String? customMessageRequired,
      String? Function(String? value)? validator,
      String? errorText,
      Iterable<String>? autofillHints,
      TextEditingController? controller,
      Function()? onBlur,
      super.onFieldSubmitted,
      super.focusNode,
      super.onTap,
      super.keyboardType,
      super.textInputAction,
      super.labelSuffix})
      : super(
          controller: controller,
          label: label,
          isRequired: isRequired,
          obscureText: true,
          hintText: hintText,
          autoCompleteType: TextFormFieldUiType.password,
          autofillHints: const [AutofillHints.password],
          customMessageRequired: customMessageRequired,
          onChanged: onChanged,
          validator: validator,
          errorText: errorText,
          onBlur: onBlur,
          enableSuggestions: false,
          autoCorrect: false,
        );
}
