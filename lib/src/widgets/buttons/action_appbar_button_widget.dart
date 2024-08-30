import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:flutter/material.dart';

class ActionAppbarButtonWidget extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  const ActionAppbarButtonWidget({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ContainerCircleWidget(
      backgroundColor: Colors.transparent,
      color: ColorKeys.primary,
      onPressed: onPressed,
      child: Theme(
        data: ThemeData(
          iconTheme: IconThemeData(
            color: onPressed == null
                ? Colors.grey.withOpacity(0.4)
                : ColorKeys.primary,
          ),
        ),
        child: child,
      ),
    );
  }
}
