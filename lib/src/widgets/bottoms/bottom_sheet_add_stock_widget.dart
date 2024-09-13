import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/image/image_widget.dart';
import 'package:ez_shop_sync/src/widgets/price_group_select_widget.dart';
import 'package:ez_shop_sync/src/widgets/product_info_list_item.dart';
import 'package:ez_shop_sync/src/widgets/text_form_field/text_form_field_ui_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomSheetAddStockWidget extends StatefulWidget {
  final Product product;
  final Function()? onSubmit;
  const BottomSheetAddStockWidget({
    super.key,
    required this.product,
    this.onSubmit,
  });

  @override
  _BottomSheetAddStockWidgetState createState() => _BottomSheetAddStockWidgetState();
}

class _BottomSheetAddStockWidgetState extends State<BottomSheetAddStockWidget> {
  late Product _productEditor;
  final _qtyTextController = TextEditingController(text: '1');
  String? priceCategorySelected;
  @override
  void initState() {
    _productEditor = widget.product;
    super.initState();
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
                    ImageWidget(
                      imageFullName: _productEditor.imageName,
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ProductInfoListItem(
                      name: _productEditor.name,
                      desc: _productEditor.description,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                PriceGroupSelectWidget(
                  items: widget.product.priceCategories?.keys.toList() ?? [],
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
                const SizedBox(
                  height: 8,
                ),
                TextFormFieldUiWidget(
                  controller: _qtyTextController,
                  label: LocaleKeys.quantity.tr(),
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    Future.delayed(
                      Duration.zero,
                      () {
                        setState(() {
                          _qtyTextController.text = value?.trim() == '0' ? '' : value?.trim() ?? '';
                        });
                      },
                    );
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
            onPressed: _qtyTextController.text.isEmpty ||
                    int.tryParse(_qtyTextController.text) == null ||
                    priceCategorySelected == null
                ? null
                : () {
                    Navigator.of(context).pop(int.parse(_qtyTextController.text));
                  },
          ),
        ],
      ),
    );
  }
}
