import 'package:flutter/widgets.dart';
import 'text_form_field_ui_widget.dart';

class TextFormFieldPasswordUiWidget extends TextFormFieldUiWidget {
  const TextFormFieldPasswordUiWidget(
      {super.key,
      required super.label,
      required super.isRequired,
      required String super.hintText,
      super.onChanged,
      super.customMessageRequired,
      super.validator,
      super.errorText,
      Iterable<String>? autofillHints,
      super.controller,
      super.onBlur,
      super.onFieldSubmitted,
      super.focusNode,
      super.onTap,
      super.keyboardType,
      super.textInputAction,
      super.labelSuffix})
      : super(
          obscureText: true,
          autoCompleteType: TextFormFieldUiType.password,
          autofillHints: const [AutofillHints.password],
          enableSuggestions: false,
          autoCorrect: false,
        );
}
