import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:flutter/material.dart';

class ActionButtonGroupWidget extends StatelessWidget {
  final String? cancelLabel;
  final String? confirmLabel;
  final Function()? onCancel;
  final Function()? onConfirm;
  final Color? confirmColor;
  final Color? cancelColor;
  final bool? enableConfirm;
  final bool? enableCancel;
  final Axis direction;
  final double? heightButton;
  final double gap;

  const ActionButtonGroupWidget({
    super.key,
    this.cancelLabel,
    this.confirmLabel,
    this.onCancel,
    this.onConfirm,
    this.cancelColor,
    this.confirmColor,
    this.enableCancel,
    this.enableConfirm,
    this.heightButton,
    this.direction = Axis.horizontal,
    this.gap = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: direction == Axis.horizontal
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: buildChildrenHorizon(),
            )
          : SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: buildChildrenVertical().toList(),
              ),
            ),
    );
  }

  List<Widget> buildChildrenHorizon() {
    return [
      if (cancelLabel != null)
        Expanded(
          flex: 1,
          child: ButtonWidget(
            label: cancelLabel ?? 'Cancel',
            type: ButtonUiType.secondary,
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black,
            ),
            onPressed: enableCancel ?? true ? onCancel : null,
          ),
        ),
      if (confirmLabel != null && cancelLabel != null)
        SizedBox(
          width: gap,
        ),
      if (confirmLabel != null)
        Expanded(
          flex: 1,
          child: ButtonWidget(
            isFittedLabel: false,
            backgroundColor: confirmColor,
            label: confirmLabel ?? 'Confirm',
            onPressed: enableConfirm ?? true ? onConfirm : null,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
    ];
  }

  List<Widget> buildChildrenVertical() {
    return [
      if (confirmLabel != null)
        Flexible(
          flex: 1,
          child: ButtonWidget(
            height: heightButton ?? 44,
            isFittedLabel: false,
            backgroundColor: confirmColor,
            label: confirmLabel ?? 'Confirm',
            onPressed: enableConfirm ?? true ? onConfirm : null,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      SizedBox(
        height: gap,
      ),
      if (cancelLabel != null)
        Flexible(
          flex: 1,
          child: ButtonWidget(
            height: heightButton ?? 44,
            width: double.infinity,
            type: ButtonUiType.secondary,
            label: cancelLabel ?? 'Cancel',
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.grey,
            ),
            onPressed: enableCancel ?? true ? onCancel : null,
          ),
        ),
    ];
  }
}
