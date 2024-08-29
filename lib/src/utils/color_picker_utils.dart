import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/widgets/buttons/action_button_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerUtils {
  static Future<Color?> showDialogPicker(BuildContext context,
      {Color? initialColor}) async {
    Color pickerColor = initialColor ?? Colors.white;
    Color currentColor = pickerColor;

    return await showDialog<Color?>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(DimensionsKeys.radius))),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (value) {
                    currentColor = value;
                  },
                ),
                ActionButtonGroupWidget(
                  margin: EdgeInsets.all(8),
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onConfirm: () {
                    Navigator.of(context).pop(currentColor);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
