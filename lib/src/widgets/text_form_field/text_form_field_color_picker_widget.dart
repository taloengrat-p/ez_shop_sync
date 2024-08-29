import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/utils/color_picker_utils.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';

class TextFormFieldColorPickerWidget extends StatefulWidget {
  final Function(Color)? onSelected;
  final String label;

  const TextFormFieldColorPickerWidget({
    super.key,
    this.onSelected,
    required this.label,
  });

  @override
  State<TextFormFieldColorPickerWidget> createState() =>
      _TextFormFieldColorPickerWidgetState();
}

class _TextFormFieldColorPickerWidgetState
    extends State<TextFormFieldColorPickerWidget> {
  Color? _color;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return TextFormFieldUiWidget(
      label: widget.label,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              final color = await ColorPickerUtils.showDialogPicker(context);

              if (color != null) {
                _color = color;
                widget.onSelected?.call(color);
              }

              setState(() {});
            },
            child: Container(
              width: size.width * 0.4,
              height: 50,
              decoration: BoxDecoration(
                color: _color,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(DimensionsKeys.radius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
