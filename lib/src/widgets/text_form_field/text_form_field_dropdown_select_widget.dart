import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class AppTextFormFieldDropdownSelectWidget<T extends Object>
    extends StatefulWidget {
  final String label;
  final MultiSelectController<T> controller;
  final Function(T? value)? onSelected;
  final List<DropdownItem<T>> items;
  final Widget Function(DropdownItem<T>, int, void Function())? itemBuilder;
  final Widget? itemSeparator;
  final Widget Function(DropdownItem<T>)? selectedItemBuilder;
  final Function(List<T>)? onSelectionChange;
  final String? Function(List<DropdownItem<T>>?)? validator;
  final String? hintText;
  final bool singleSelect;
  final Widget? footerMenu;
  final List<T>? itemSelectd;

  const AppTextFormFieldDropdownSelectWidget({
    super.key,
    required this.label,
    this.onSelected,
    required this.items,
    this.itemBuilder,
    this.itemSeparator,
    this.selectedItemBuilder,
    this.onSelectionChange,
    this.validator,
    this.hintText,
    required this.singleSelect,
    this.footerMenu,
    this.itemSelectd,
    required this.controller,
  });

  @override
  _AppTextFormFieldDropdownSelectWidgetState createState() =>
      _AppTextFormFieldDropdownSelectWidgetState<T>();
}

class _AppTextFormFieldDropdownSelectWidgetState<T extends Object>
    extends State<AppTextFormFieldDropdownSelectWidget<T>> {
  @override
  void initState() {
    super.initState();
    // widget.initialized?.call(_multiSelectController);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {});
  }

  @override
  void didUpdateWidget(
      covariant AppTextFormFieldDropdownSelectWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(
      Duration.zero,
      () async {
        widget.controller.setItems(widget.items);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppTextFormFieldUiWidget(
      label: widget.label,
      child: MultiDropdown<T>(
        controller: widget.controller,
        closeOnBackButton: true,
        searchDecoration: SearchFieldDecoration(
          hintText: LocaleKeys.search.tr(),
          border: OutlineInputBorder(
            gapPadding: 0,
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        items: widget.items,
        singleSelect: widget.singleSelect,
        enabled: true,
        searchEnabled: true,
        itemBuilder: widget.itemBuilder,
        itemSeparator: widget.itemSeparator,
        selectedItemBuilder: widget.selectedItemBuilder,
        chipDecoration: const ChipDecoration(
          backgroundColor: Colors.yellow,
          wrap: true,
          runSpacing: 2,
          spacing: 10,
        ),
        fieldDecoration: FieldDecoration(
          hintText: widget.hintText,
          showClearIcon: false,
          border: OutlineInputBorder(
            gapPadding: 0,
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            gapPadding: 0,
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: ColorKeys.black, width: 1.5),
          ),
        ),
        dropdownDecoration: DropdownDecoration(
          marginTop: 2,
          maxHeight: 500,
          footer: widget.footerMenu,
          borderRadius: BorderRadius.circular(8),
        ),
        validator: widget.validator,
        onSelectionChange: widget.onSelectionChange,
      ),
    );
  }
}
