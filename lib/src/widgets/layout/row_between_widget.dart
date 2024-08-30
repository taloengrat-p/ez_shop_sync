import 'package:flutter/cupertino.dart';

class RowBetweenWidget extends StatelessWidget {
  final Widget title;
  final Widget? value;

  const RowBetweenWidget({
    Key? key,
    required this.title,
    this.value,
  }) : super(key: key);

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
