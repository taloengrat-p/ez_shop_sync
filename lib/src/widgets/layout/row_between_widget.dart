import 'package:flutter/cupertino.dart';

class RowBetweenWidget extends StatelessWidget {
  final Widget title;
  final Widget? value;
  final CrossAxisAlignment crossAxisAlignment;
  const RowBetweenWidget({
    super.key,
    required this.title,
    this.value,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        title,
        const Spacer(),
        if (value != null) value!,
      ],
    );
  }
}
