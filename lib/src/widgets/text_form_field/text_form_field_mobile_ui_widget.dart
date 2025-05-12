
import 'text_form_field_ui_widget.dart';

// ignore: must_be_immutable
class TextFormFieldMobileUiWidget extends AppTextFormFieldUiWidget {
  TextFormFieldMobileUiWidget({
    super.key,
    required String super.label,
    required super.isRequired,
    required String super.hintText,
    super.controller,
    super.onBlur,
    super.autofillHints = null,
    super.onChanged,
    super.errorText,
    super.textInitial,
    Function(String? value)? additionalValidator,
    super.onFieldSubmitted,
    super.focusNode,
    super.textValue,
  }) : super(
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
