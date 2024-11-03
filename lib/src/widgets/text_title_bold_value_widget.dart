import 'package:flutter/material.dart';

class TextTitleBoldValueWidget extends StatelessWidget {
  final String title;
  final String value;
  const TextTitleBoldValueWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title : ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
          ),
        ),
      ],
    );
  }
}
