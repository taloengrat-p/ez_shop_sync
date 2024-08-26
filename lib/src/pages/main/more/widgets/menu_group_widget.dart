import 'package:ez_shop_sync/src/pages/main/more/models/menu_item_model.dart';
import 'package:ez_shop_sync/src/pages/main/more/widgets/menu_item_widget.dart';
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(
            height: 16,
          ),
          ...items.map(
            (e) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MenuItemWidget(model: e),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
