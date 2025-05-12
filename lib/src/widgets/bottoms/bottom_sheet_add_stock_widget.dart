// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:ez_shop_sync/src/widgets/price_group_select_widget.dart';
import 'package:ez_shop_sync/src/widgets/product_info_list_item.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';

class BottomSheetAddStockSuccess {
  final num qty;
  final num amountCost;
  final String? priceCategorySelected;
  BottomSheetAddStockSuccess({required this.priceCategorySelected, required this.qty, required this.amountCost});

  @override
  String toString() =>
      'BottomSheetAddStockSuccess(qty: $qty, amountCost: $amountCost, priceCategorySelected: $priceCategorySelected)';
}

class BottomSheetAddStockWidget extends StatefulWidget {
  final Product product;
  final Function()? onSubmit;
  const BottomSheetAddStockWidget({super.key, required this.product, this.onSubmit});

  @override
  _BottomSheetAddStockWidgetState createState() => _BottomSheetAddStockWidgetState();
}

class _BottomSheetAddStockWidgetState extends State<BottomSheetAddStockWidget> {
  late Product _productEditor;
  final _qtyTextController = TextEditingController(text: '1');
  final _costAmountTextController = TextEditingController();
  String? priceCategorySelected;
  @override
  void initState() {
    _productEditor = widget.product;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (_productEditor.productTypeList?.length == 1) {
        priceCategorySelected = _productEditor.productTypeList?.first.id;

        setState(() {});
      }
    });
  }

  num? get qtyEditor => int.tryParse(_qtyTextController.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    ImageWidget(imageUrl: _productEditor.imagesUrl?.firstOrNull, width: 80, height: 80),
                    const SizedBox(width: 8),
                    ProductInfoListItem(name: _productEditor.name, desc: _productEditor.description),
                  ],
                ),
                const SizedBox(height: 8),
                PriceGroupSelectWidget(
                  items: widget.product.productTypeList?.toList() ?? [],
                  itemSelected: priceCategorySelected,
                  onChange: (value) {
                    setState(() {
                      if (priceCategorySelected == value) {
                        priceCategorySelected = null;
                      } else {
                        priceCategorySelected = value;
                      }
                    });
                  },
                ),
                const SizedBox(height: 8),
                AppTextFormFieldUiWidget(
                  controller: _qtyTextController,
                  label: LocaleKeys.quantity.tr(),
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    Future.delayed(Duration.zero, () {
                      setState(() {
                        _qtyTextController.text = value?.trim() == '0' ? '' : value?.trim() ?? '';
                      });
                    });
                  },
                ),
                AppTextFormFieldUiWidget(
                  controller: _costAmountTextController,
                  label: LocaleKeys.amountCost.tr(),
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    Future.delayed(Duration.zero, () {
                      setState(() {
                        _costAmountTextController.text = value?.trim() == '0' ? '' : value?.trim() ?? '';
                      });
                    });
                  },
                ),
              ],
            ),
          ),
          ButtonWidget(
            margin: const EdgeInsets.only(top: 16),
            label: LocaleKeys.addStock.tr(),
            leading: const Icon(CupertinoIcons.bag_badge_plus),
            backgroundColor: Colors.amber,
            onPressed:
                _qtyTextController.text.isEmpty ||
                        int.tryParse(_qtyTextController.text) == null ||
                        (priceCategorySelected == null || (priceCategorySelected?.isEmpty ?? false)) ||
                        _costAmountTextController.text.isEmpty ||
                        int.tryParse(_costAmountTextController.text) == null
                    ? null
                    : () {
                      final amountCost = num.tryParse(_costAmountTextController.text);

                      Navigator.of(context).pop(
                        BottomSheetAddStockSuccess(
                          priceCategorySelected: priceCategorySelected,
                          qty: int.parse(_qtyTextController.text),
                          amountCost: amountCost ?? 0,
                        ),
                      );
                    },
          ),
        ],
      ),
    );
  }
}
