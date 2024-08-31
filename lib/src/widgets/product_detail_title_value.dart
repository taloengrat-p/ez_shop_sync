import 'package:flutter/cupertino.dart';

class ProductDetailTitleValue extends StatelessWidget {
  final String title;
  final String? value;
  final List<Widget>? widgetValues;
  const ProductDetailTitleValue({
    super.key,
    required this.title,
    this.value,
    this.widgetValues,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: buildValueWidget(),
        ),
      ],
    );
  }

  Widget buildValueWidget() {
    return (widgetValues?.isNotEmpty ?? false)
        ? Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [...widgetValues?.map((e) => e) ?? []],
          )
        : Text(value ?? '--');
  }
}
