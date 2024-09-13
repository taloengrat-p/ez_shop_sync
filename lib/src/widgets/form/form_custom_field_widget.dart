import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormCustomFieldWidget extends StatefulWidget {
  final Map<String, dynamic> items;
  final Function(String key)? onRemoveField;
  final Function(String key, String? value)? onFieldValueChange;
  final Function(String? key, String? value)? onTempFieldChange;
  final Function(String key, String value)? onAddCustomField;
  final String? keyLabel;
  final String? valueLabel;
  final TextInputType? keyboardType;
  final String tag;
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
  });

  @override
  _FormCustomFieldWidgetState createState() => _FormCustomFieldWidgetState();
}

class _FormCustomFieldWidgetState extends State<FormCustomFieldWidget> {
  final _textCustomFieldNameInput = TextEditingController();
  final _textCustomFieldValueInput = TextEditingController();
  String tempCustomValue = '';
  String tempCustomKey = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...widget.items
              .map(
                (k, v) => MapEntry(
                  k,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormFieldUiWidget(
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
                ),
              )
              .values,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormFieldUiWidget(
                        controller: _textCustomFieldNameInput,
                        label: widget.keyLabel ?? LocaleKeys.customName.tr(),
                        onChanged: (val) {
                          tempCustomKey = val ?? '';
                          widget.onTempFieldChange?.call(tempCustomKey, tempCustomValue);
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: TextFormFieldUiWidget(
                        controller: _textCustomFieldValueInput,
                        keyboardType: widget.keyboardType,
                        label: widget.valueLabel ?? LocaleKeys.customValue.tr(),
                        onChanged: (value) {
                          tempCustomValue = value ?? '';
                          widget.onTempFieldChange?.call(tempCustomKey, tempCustomValue);
                        },
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              ContainerCircleWidget(
                child: const Icon(Icons.add),
                onPressed: () {
                  if (tempCustomValue.isEmpty || tempCustomKey.isEmpty) {
                    return;
                  }
                  widget.onAddCustomField?.call(tempCustomKey, tempCustomValue);

                  _textCustomFieldValueInput.clear();
                  _textCustomFieldNameInput.clear();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
