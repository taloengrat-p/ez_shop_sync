import 'package:ez_shop_sync/src/data/dto/hive_object/category.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extensions.dart';
import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  final Category model;
  final IconData? icon;

  const CategoryWidget({
    super.key,
    required this.model,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Color? color = model.color?.toColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      height: 40,
      decoration: BoxDecoration(
        color: model.color?.toColor(),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: (model.borderColor?.toColor() ?? Colors.transparent)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: icon != null
                ? Icon(
                    icon,
                    color: color?.getContrast(),
                  )
                : Container(),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            model.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: (color ?? Colors.transparent).getContrast(),
            ),
          )
        ],
      ),
    );
  }
}
