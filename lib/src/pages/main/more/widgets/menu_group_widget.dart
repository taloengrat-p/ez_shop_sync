import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/pages/main/more/models/menu_item_model.dart';
import 'package:ez_shop_sync/src/pages/main/more/widgets/menu_item_widget.dart';
import 'package:ez_shop_sync/src/widgets/container/container_scrollable_widget.dart';
import 'package:flutter/material.dart';

class MenuGroupWidget extends StatelessWidget {
  final String title;
  final List<MenuItemModel> items;
  const MenuGroupWidget({
    super.key,
    required this.items,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        ContainerScrollableWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...items
                  .asMap()
                  .map(
                    (i, v) => MapEntry(
                      i,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MenuItemWidget(model: v),
                          if (i != items.length - 1)
                            Divider(
                              color: ColorKeys.primary.withOpacity(0.3),
                            ),
                        ],
                      ),
                    ),
                  )
                  .values
            ],
          ),
        ),
      ],
    );
  }
}
