import 'package:ez_shop_sync/src/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:flutter/material.dart';

class BottomSheetUtils {
  static Future<dynamic> showMenu(
    BuildContext context, {
    String? title,
    required Widget body,
  }) async {
    return await showModalBottomSheet<dynamic>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AppBottomSheet(
          props: AppBottomSheetProps(
            title: title ?? '',
            body: body,
          ),
        );
      },
    );
  }
}
