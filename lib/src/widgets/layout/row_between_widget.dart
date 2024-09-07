import 'package:flutter/cupertino.dart';

class RowBetweenWidget extends StatelessWidget {
  final Widget title;
  final Widget? value;

  const RowBetweenWidget({
    super.key,
    required this.title,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        title,
        const Spacer(),
        if (value != null) value!,
      ],
    );
  }
}
