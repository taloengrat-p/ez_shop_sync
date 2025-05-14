import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/widgets/circle_profile_widget.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String name;
  final String title;
  final String? desc;
  final TextStyle? descStyle;
  final TextStyle? nameStyle;
  const ProfileWidget({super.key, required this.name, this.desc, this.descStyle, this.nameStyle, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleProfileWidget(title: name.substring(0, 1).toUpperCase(), radius: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style:
                    nameStyle ??
                    Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorKeys.brightness.getContrast()),
              ),
              if (desc != null)
                Text(
                  desc ?? '',
                  overflow: TextOverflow.ellipsis,
                  style:
                      descStyle ??
                      Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorKeys.brightness.getContrast()),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
