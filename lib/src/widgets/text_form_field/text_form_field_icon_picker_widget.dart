import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/utils/icon_picker_utils.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker_plus/flutter_iconpicker.dart';

class TextFormFieldIconPickerWidget extends StatefulWidget {
  final String label;
  final Function(IconData?)? onSelected;
  const TextFormFieldIconPickerWidget({
    super.key,
    required this.label,
    this.onSelected,
  });

  @override
  _TextFormFieldIconPickerWidgetState createState() => _TextFormFieldIconPickerWidgetState();
}

class _TextFormFieldIconPickerWidgetState extends State<TextFormFieldIconPickerWidget> {
  IconData? _iconData;

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
              IconData? icon = await FlutterIconPicker.showIconPicker(
                context,
                iconPackModes: [
                  IconPack.material,
                  IconPack.fontAwesomeIcons,
                ],
              );

              if (icon != null) {
                _iconData = IconPickerUtils.getIcon(serializeIcon(icon));
                widget.onSelected?.call(_iconData);
              }

              setState(() {});
            },
            child: Container(
              width: size.width * 0.4,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(DimensionsKeys.radius),
              ),
              child: _iconData == null ? Container() : Icon(_iconData),
            ),
          ),
        ],
      ),
    );
  }
}
