import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerUtils {
  static Future<Color?> showDialogPicker(BuildContext context) async {
    Color pickerColor = Color(0xff443a49);
    Color currentColor = Color(0xff443a49);

    return await showDialog<Color?>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(DimensionsKeys.radius))),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (value) {
                    pickerColor = value;
                  },
                ),
                ButtonWidget(
                  elevation: 2,
                  margin: const EdgeInsets.all(8),
                  label: 'Confirm',
                  type: ButtonUiType.secondary,
                  onPressed: () {
                    currentColor = pickerColor;
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
