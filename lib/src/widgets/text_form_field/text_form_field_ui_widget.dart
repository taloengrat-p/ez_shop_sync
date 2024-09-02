import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/app_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TextFormFieldUiType { password, normal, email }

class TextFormFieldUiWidget extends StatefulWidget {
  final Widget? labelSuffix;
  final String label;
  final String? hintText;
  final String? textInitial;
  final bool? obscureText;
  final String? Function(String? value)? validator;
  final Function(String? value)? onChanged;
  final bool isRequired;
  final Iterable<String>? autofillHints;
  final Widget? suffixIcon;
  final TextFormFieldUiType autoCompleteType;
  final TextEditingController? controller;
  final Function()? onBlur;
  final Function()? onTap;
  final String? customMessageRequired;
  final bool readOnly;
  final String? errorText;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String value)? onFieldSubmitted;
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;
  final String? textValue;
  final TextInputAction textInputAction;
  final bool autoCorrect;
  final bool enableSuggestions;
  final double? maxLines;
  final bool? autofocus;
  final Widget? child;
  const TextFormFieldUiWidget({
    super.key,
    required this.label,
    this.obscureText,
    this.errorText,
    this.validator,
    this.isRequired = false,
    this.textInitial,
    this.autofillHints = const [],
    this.suffixIcon,
    this.hintText,
    this.autoCompleteType = TextFormFieldUiType.normal,
    this.controller,
    this.customMessageRequired,
    this.onChanged,
    this.onBlur,
    this.onTap,
    this.readOnly = false,
    this.onFieldSubmitted,
    this.focusNode,
    this.textAlign,
    this.autofocus,
    this.inputFormatters,
    this.keyboardType,
    this.contentPadding,
    this.textValue,
    this.textInputAction = TextInputAction.done,
    this.autoCorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.labelSuffix,
    this.child,
  });

  @override
  State<TextFormFieldUiWidget> createState() => _TextFormFieldUiWidgetState();
}

class _TextFormFieldUiWidgetState extends State<TextFormFieldUiWidget> {
  late TextEditingController _controller;
  bool isBlured = false;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _controller = TextEditingController();
    } else if (widget.controller != null) {
      _controller = widget.controller!;
    }

    if (widget.textInitial != null) {
      _controller.text = widget.textInitial!;
      widget.onChanged?.call(_controller.text);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Widget buildLabel(String? label) {
    if (label != null && label.isNotEmpty) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              if (widget.labelSuffix.isNotNull) widget.labelSuffix!,
            ],
          ),
          const SizedBox(
            height: 6,
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  void didUpdateWidget(covariant TextFormFieldUiWidget oldWidget) {
    if (widget.textValue != null) {
      _controller.text = widget.textValue!;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(8);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel(widget.label),
          Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
            ),
            child: SizedBox(
              child: widget.child ??
                  TextFormField(
                    textInputAction: widget.textInputAction,
                    smartDashesType: SmartDashesType.disabled,
                    enableSuggestions: widget.enableSuggestions,
                    autocorrect: widget.autoCorrect,
                    inputFormatters: widget.inputFormatters ?? [],
                    keyboardType: widget.keyboardType ?? TextInputType.text,
                    textAlign: widget.textAlign ?? TextAlign.start,
                    autofocus: widget.autofocus ?? false,
                    autovalidateMode: isBlured ? AutovalidateMode.always : AutovalidateMode.disabled,
                    readOnly: widget.readOnly,
                    autofillHints: widget.autofillHints,
                    focusNode: widget.focusNode,
                    controller: _controller,
                    onFieldSubmitted: widget.onFieldSubmitted,
                    onTap: () {
                      widget.onTap?.call();
                    },
                    maxLines: widget.maxLines!.toInt(),
                    validator: (value) {
                      if ((value?.isEmpty ?? true) && widget.isRequired) {
                        return widget.customMessageRequired ??
                            LocaleKeys.requiredErrorMessage.tr(args: [widget.label.toLowerCase()]);
                      }

                      return widget.validator?.call(doValiedate(value));
                    },
                    obscureText: getObscureText(),
                    // decoration: InputDecoration(
                    //   fillColor: widget.readOnly
                    //       ? Colors.grey.withOpacity(0.3)
                    //       : Colors.white,
                    //   filled: true,
                    //   contentPadding: widget.contentPadding ??
                    //       const EdgeInsets.symmetric(
                    //           vertical: 13, horizontal: 8),
                    //   suffixIcon: widget.autoCompleteType ==
                    //           TextFormFieldUiType.password
                    //       ? getSuffixPasswordType()
                    //       : widget.suffixIcon,
                    //   border: OutlineInputBorder(
                    //     borderRadius: borderRadius,
                    //   ),
                    //   focusedBorder: OutlineInputBorder(
                    //     borderRadius: borderRadius,
                    //     borderSide:
                    //         const BorderSide(color: Colors.black, width: 1),
                    //   ),
                    //   enabledBorder: OutlineInputBorder(
                    //     borderRadius: borderRadius,
                    //     borderSide: BorderSide(
                    //       color: Colors.grey,
                    //       width: 1.0,
                    //     ),
                    //   ),
                    //   labelStyle: const TextStyle(fontSize: 17),
                    //   // hintStyle: TextStyle(color: ColorKeys.defaultWeak),
                    //   hintText: widget.hintText,
                    //   errorStyle: TextStyle(
                    //     // color: ColorKeys.error,
                    //     fontSize: 15,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    //   errorMaxLines: 4,
                    //   errorText: widget.errorText,
                    //   errorBorder: OutlineInputBorder(
                    //     gapPadding: 0,
                    //     borderRadius: borderRadius,
                    //     borderSide: BorderSide(color: Colors.red, width: 1.0),
                    //   ),
                    //   focusedErrorBorder: OutlineInputBorder(
                    //     borderRadius: borderRadius,
                    //     borderSide: BorderSide(color: Colors.red, width: 1.5),
                    //   ),
                    // ),
                    decoration: AppInputDecoration(
                      contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
                      readOnly: widget.readOnly,
                      suffixIcon: widget.autoCompleteType == TextFormFieldUiType.password
                          ? getSuffixPasswordType()
                          : widget.suffixIcon,
                    ).build(),
                    onChanged: (value) {
                      widget.onChanged?.call(value);
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }

  String? doValiedate(String? value) {
    return value;
  }

  Widget getSuffixPasswordType() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isVisible = !_isVisible;
        });
      },
      icon: Icon(_isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded),
    );
  }

  bool getObscureText() {
    if (widget.autoCompleteType == TextFormFieldUiType.password) {
      return !_isVisible;
    }

    return widget.obscureText ?? false;
  }
}
