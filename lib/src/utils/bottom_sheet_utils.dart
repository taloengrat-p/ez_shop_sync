import 'package:ez_shop_sync/res/dimensions.dart';
import 'package:ez_shop_sync/src/models/option_item.dart';
import 'package:ez_shop_sync/src/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:flutter/material.dart';

class BottomSheetUtils {
  static Future<T> show<T>(BuildContext context, {required Widget Function(BuildContext) builder}) async {
    return await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(DimensionsKeys.radius)),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
              ),
              child: builder(context),
            ),
          ),
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
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          ),
          child: AppBottomSheet(props: AppBottomSheetProps(title: title ?? '', body: body, bottom: bottom)),
        );
      },
    );
  }

  static dynamic showMenu(BuildContext context, List<OptionItem> list) async {
    return await show(
      context,
      builder: (p0) {
        return Wrap(
          children:
              list
                  .map(
                    (e) => ListTile(
                      leading: e.leading,
                      title: Text(e.title),
                      onTap: () {
                        Navigator.pop(context, e.value);
                      },
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}
