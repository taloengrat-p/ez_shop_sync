import 'dart:developer';

import 'package:ez_shop_sync/src/data/dto/hive_object/tag.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/utils/extensions/string_extendsions.dart';
import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  final Tag model;

  const TagWidget({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final Color? color = model.color?.toColor();

    log('asdf ${model.color}');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
      child: Text(
        model.name,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: (color ?? Colors.transparent).getContrast(),
        ),
      ),
    );
  }
}
