import 'package:ez_shop_sync/src/utils/extensions/object_extension.dart';
import 'package:ez_shop_sync/src/widgets/bottom_sheet/model/bottom_sheet_menu_model.dart';
import 'package:flutter/material.dart';

class BottomSheetUtils {
  static Future<dynamic> showMenu(
    BuildContext context, {
    String? title,
    required List<BottomSheetMenuModel> items,
  }) async {
    return await showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (title.isNotNull)
                  Text(
                    title!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                const SizedBox(
                  height: 16,
                ),
                ...items.map(
                  (e) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(e.value);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 50,
                      child: Row(
                        children: [
                          e.icon,
                          const SizedBox(
                            width: 16,
                          ),
                          Text(e.label)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
