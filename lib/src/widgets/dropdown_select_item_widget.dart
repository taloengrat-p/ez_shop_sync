import 'package:flutter/material.dart';

class DropdownSelectItemWidget extends StatelessWidget {
  final GestureTapCallback? onTap;
  final bool selected;
  final Widget child;
  const DropdownSelectItemWidget({
    super.key,
    this.onTap,
    required this.child,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            child,
            const Spacer(),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
              )
          ],
        ),
      ),
    );
  }
}
