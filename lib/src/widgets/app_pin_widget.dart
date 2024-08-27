import 'package:ez_shop_sync/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class AppPinWidget extends StatefulWidget {
  final String title;
  final String desc;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  const AppPinWidget({
    Key? key,
    required this.title,
    required this.desc,
    this.obscureText = true,
    this.validator,
    this.onCompleted,
    this.onSubmitted,
    this.controller,
    this.errorText,
    this.onChanged,
  }) : super(key: key);

  @override
  _AppPinWidgetState createState() => _AppPinWidgetState();
}

class _AppPinWidgetState extends State<AppPinWidget> {
  late PinTheme defaultPinTheme;
  late var focusedPinTheme;
  late var submittedPinTheme;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: ColorKeys.accent),
      borderRadius: BorderRadius.circular(8),
    );

    submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            widget.desc,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.grey),
          ),
          const SizedBox(
            height: 16,
          ),
          Pinput(
            controller: widget.controller,
            length: 6,
            obscureText: widget.obscureText,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            validator: widget.validator,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            showCursor: true,
            autofocus: true,
            errorText: widget.errorText,
            onCompleted: widget.onCompleted,
            onSubmitted: widget.onSubmitted,
            forceErrorState: widget.errorText != null,
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}
