import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/models/screen_mode.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/widgets.dart';

class FormCreateCustomFieldArgrument {
  final String name;
  final num price;
  const FormCreateCustomFieldArgrument({
    this.name = '',
    this.price = 0,
  });
}

class FormCreateCustomField extends StatefulWidget {
  final void Function({
    String name,
    num price,
  })? onChange;
  final ScreenMode screenMode;
  final FormCreateCustomFieldArgrument? model;

  const FormCreateCustomField({
    super.key,
    this.onChange,
    required this.screenMode,
    this.model,
  });

  @override
  State<FormCreateCustomField> createState() => _FormCreateCustomFieldState();
}

class _FormCreateCustomFieldState extends State<FormCreateCustomField> {
  final _textProductTypeNameInput = TextEditingController();
  final _textProductTypePriceInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormFieldUiWidget(
                      readOnly: widget.screenMode == ScreenMode.display,
                      textValue: widget.screenMode == ScreenMode.display ? widget.model?.name.toString() ?? '' : null,
                      controller: _textProductTypeNameInput,
                      label: LocaleKeys.customName.tr(),
                      onChanged: (val) {
                        widget.onChange?.call(name: _textProductTypeNameInput.text);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormFieldUiWidget(
                      readOnly: widget.screenMode == ScreenMode.display,
                      textValue: widget.screenMode == ScreenMode.display ? widget.model?.price.toString() ?? '' : null,
                      controller: _textProductTypePriceInput,
                      label: LocaleKeys.customValue.tr(),
                      onChanged: (value) {
                        widget.onChange?.call(price: num.tryParse(_textProductTypePriceInput.text) ?? 0);
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }
}
