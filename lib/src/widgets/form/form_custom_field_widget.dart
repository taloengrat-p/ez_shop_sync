import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/widgets/buttons/action_appbar_button_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormCustomFieldWidget<T> extends StatefulWidget {
  final Map<String, dynamic> items;
  final Function(String key)? onRemoveField;
  final Function(String key, String? value)? onFieldValueChange;
  final Function(String? key, String? value)? onTempFieldChange;
  final Function(String key, String value)? onAddCustomField;
  // final Widget widgetEditor;
  final String? keyLabel;
  final String? valueLabel;
  final TextInputType? keyboardType;
  final String tag;
  final Widget Function(dynamic context, T item) widgetDisplayBuilder;
  const FormCustomFieldWidget({
    super.key,
    required this.items,
    this.onRemoveField,
    this.onFieldValueChange,
    this.onTempFieldChange,
    this.onAddCustomField,
    this.keyLabel,
    this.valueLabel,
    this.keyboardType,
    required this.tag,
    // required this.widgetEditor,
    required this.widgetDisplayBuilder,
  });

  @override
  _FormCustomFieldWidgetState createState() => _FormCustomFieldWidgetState<T>();
}

class _FormCustomFieldWidgetState<T> extends State<FormCustomFieldWidget> {
  final _textProductTypeNameInput = TextEditingController();
  final _textProductTypePriceInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...widget.items
            .map(
              (k, v) => MapEntry(
                k,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: AppTextFormFieldUiWidget(
                            key: ValueKey('${widget.tag} $k'),
                            label: k,
                            textInitial: v?.toString(),
                            onChanged: (value) {
                              widget.onFieldValueChange?.call(k, value);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        ContainerCircleWidget(
                          color: Colors.red,
                          child: const Icon(CupertinoIcons.delete),
                          onPressed: () {
                            widget.onRemoveField?.call(k);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
            .values,
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppTextFormFieldUiWidget(
                          controller: _textProductTypeNameInput,
                          label: LocaleKeys.customName.tr(),
                          onChanged: (val) {
                            widget.onTempFieldChange?.call(
                                _textProductTypeNameInput.text,
                                _textProductTypePriceInput.text);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: AppTextFormFieldUiWidget(
                          controller: _textProductTypePriceInput,
                          label: LocaleKeys.customValue.tr(),
                          onChanged: (value) {
                            widget.onTempFieldChange?.call(
                                _textProductTypeNameInput.text,
                                _textProductTypePriceInput.text);
                            widget.onTempFieldChange?.call(
                                _textProductTypeNameInput.text,
                                _textProductTypePriceInput.text);
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
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ActionAppbarButtonWidget(
                child: const Icon(Icons.add),
                onPressed: () {
                  widget.onAddCustomField?.call(_textProductTypeNameInput.text,
                      _textProductTypePriceInput.text);
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
