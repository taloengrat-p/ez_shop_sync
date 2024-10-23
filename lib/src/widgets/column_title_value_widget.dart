import 'package:flutter/material.dart';

class ColumnTitleValueWidget extends StatelessWidget {
  final String? title;
  final Widget? value;
  final TextStyle? textStyle;
  const ColumnTitleValueWidget({
    super.key,
    this.title,
    this.value,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (title != null)
          Text(
            title!,
            style: textStyle,
          ),
        const SizedBox(
          height: 4,
        ),
        value ?? Container(),
      ],
    );
  }
}
