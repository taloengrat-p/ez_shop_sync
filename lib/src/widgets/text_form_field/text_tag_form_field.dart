import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';

class TextTagFormField<T> extends StatefulWidget {
  // final TextfieldTagsController<T> textfieldTagsController;
  final List<T>? initialTags;
  final List<String>? textSeparators;
  // final Validator<T>? validator;
  final String label;

  const TextTagFormField({
    super.key,
    required this.label,
    // required this.textfieldTagsController,
    this.initialTags,
    this.textSeparators = const [' ', ','],
    // this.validator,
  });

  @override
  TextTagFormFieldState<T> createState() => TextTagFormFieldState<T>();
}

class TextTagFormFieldState<T> extends State<TextTagFormField<T>> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return TextFieldTags<T>(
    //     textfieldTagsController: widget.textfieldTagsController,
    //     initialTags: widget.initialTags,
    //     textSeparators: widget.textSeparators,
    //     validator: widget.validator,
    //     inputFieldBuilder: (context, inputFieldValues) {
    //       return TextFormFieldUiWidget(
    //         label: widget.label,
    //         controller: inputFieldValues.textEditingController,
    //         focusNode: inputFieldValues.focusNode,
    //       );
    //     });
  }
}
