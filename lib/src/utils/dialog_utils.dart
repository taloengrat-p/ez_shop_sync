import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
import 'package:ez_shop_sync/src/data/dto/hive_object/product.dart';
import 'package:ez_shop_sync/src/utils/bottom_sheet_utils.dart';
import 'package:ez_shop_sync/src/widgets/bottoms/bottom_sheet_add_cart_widget.dart';
import 'package:ez_shop_sync/src/widgets/bottoms/bottom_sheet_add_stock_widget.dart';
import 'package:ez_shop_sync/src/widgets/buttons/button_widget.dart';
import 'package:ez_shop_sync/src/widgets/dialogs/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static Future<ConfirmDialogResult?> showConfirmDelete(BuildContext context) async {
    return ConfirmDialogUiWidget(
      context,
      title: LocaleKeys.confirmDeleteTitle.tr(),
      desc: LocaleKeys.confirmDeleteDesc.tr(),
      confirmLabel: LocaleKeys.delete.tr(),
      confirmColor: Colors.red,
    ).show();
  }

  static Future<BottomSheetAddCartSuccess?> showAddCartDialog(BuildContext context, Product? product) async {
    if (product == null) {
      throw ('showAddCartDialog product is Null');
    }
    if (product.priceCategories?.isEmpty ?? true) {
      await showAlertDialog(
        context,
        title: LocaleKeys.error_unableAddCart.tr(),
        desc: LocaleKeys.error_productPriceNotYet.tr(),
        barrierDismissible: false,
      );

      return null;
    }
    return await BottomSheetUtils.show(
      context,
      builder: (context) {
        return BottomSheetAddCartWidget(product: product);
      },
    );
  }

  static showAddStockDialog(BuildContext context, Product? product) async {
    if (product == null) {
      throw ('showAddStockDialog product is Null');
    }

    return await BottomSheetUtils.show(
      context,
      builder: (context) {
        return BottomSheetAddStockWidget(product: product);
      },
    );
  }

  static Future<void> showAlertDialog(
    BuildContext context, {
    required String title,
    String? desc,
    bool barrierDismissible = true,
  }) async {
    return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DimensionsKeys.radius)),
          title: Text(title),
          content: Text(desc ?? ''),
          actions: [
            ButtonWidget(
              label: LocaleKeys.button_okay.tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
