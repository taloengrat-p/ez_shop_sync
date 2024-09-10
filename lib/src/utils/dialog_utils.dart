import 'package:easy_localization/easy_localization.dart';
import 'package:ez_shop_sync/res/generated/locale.g.dart';
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
}
