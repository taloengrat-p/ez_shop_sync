import 'package:ez_shop_sync/src/pages/main/more/models/menu_item_model.dart';
import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final MenuItemModel model;

  const MenuItemWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: model.onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: Text(
                model.title,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            if (model.trailing != null) model.trailing!,
          ],
        ),
      ),
    );
  }
}
