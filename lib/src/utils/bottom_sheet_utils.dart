import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:flutter/material.dart';

class BottomSheetUtils {
  static Future<T> show<T>(
    BuildContext context, {
    required Widget Function(BuildContext) builder,
  }) async {
    return await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DimensionsKeys.radius),
          ),
          child: builder(context),
        );
      },
    );
  }

  static Future<dynamic> showDragable(
    BuildContext context, {
    String? title,
    required Widget body,
    Widget? bottom,
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
            bottom: bottom,
          ),
        );
      },
    );
  }
}
