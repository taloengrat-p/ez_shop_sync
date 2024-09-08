import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/widgets/circle_profile_widget.dart';
import 'package:flutter/cupertino.dart';

class ProfileWidget extends StatelessWidget {
  final String name;

  const ProfileWidget({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleProfileWidget(
          title: name.substring(0, 2).toUpperCase(),
          radius: 18,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          name,
          style: TextStyle(
            color: ColorKeys.brightness.getContrast(),
          ),
        )
      ],
    );
  }
}
