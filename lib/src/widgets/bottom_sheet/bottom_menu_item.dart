import 'package:flutter/material.dart';

class BottomMenuItem extends StatelessWidget {
  final Widget? leading;
  final dynamic value;
  final String label;
  final Widget? trailing;

  const BottomMenuItem({
    super.key,
    required this.leading,
    required this.label,
    this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        height: 50,
        child: Row(
          children: [
            if (leading != null) leading!,
            const SizedBox(
              width: 16,
            ),
            Expanded(child: Text(label)),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
