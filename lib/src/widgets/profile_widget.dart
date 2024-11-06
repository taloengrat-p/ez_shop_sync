import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/widgets/circle_profile_widget.dart';
import 'package:flutter/cupertino.dart';

class ProfileWidget extends StatelessWidget {
  final String name;
  final String? desc;
  final TextStyle? descStyle;
  final TextStyle? nameStyle;
  const ProfileWidget({
    super.key,
    required this.name,
    this.desc,
    this.descStyle,
    this.nameStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleProfileWidget(
          title: name.substring(0, 1).toUpperCase(),
          radius: 18,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: nameStyle ??
                    TextStyle(
                      color: ColorKeys.brightness.getContrast(),
                    ),
              ),
              if (desc != null)
                Text(
                  desc ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: descStyle ??
                      TextStyle(
                        color: ColorKeys.brightness.getContrast(),
                      ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
