import 'package:ez_shop_sync/src/pages/main/more/models/menu_item_model.dart';
import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final MenuItemModel model;

  const MenuItemWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: model.disabled ? 0.25 : 1,
      child: IgnorePointer(
        ignoring: model.disabled,
        child: InkWell(
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
        ),
      ),
    );
  }
}
