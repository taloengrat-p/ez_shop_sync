import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppbarWidget {
  String? title;
  List<Widget>? actions;
  bool? centerTitle;
  Color? color;
  Color? iconThemeColor;
  SystemUiOverlayStyle? systemUiOverlayStyle;
  Widget? titleWidget;
  final BuildContext context;
  AppbarWidget(
    this.context, {
    this.title,
    this.actions,
    this.color,
    this.centerTitle,
    this.iconThemeColor,
    this.systemUiOverlayStyle,
    this.titleWidget,
  });
  AppBar build() {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);

    return AppBar(
      leading: (parentRoute?.impliesAppBarDismissal ?? false)
          ? ContainerCircleWidget(
              margin: const EdgeInsets.only(left: 8),
              backgroundColor: ColorKeys.primary.withOpacity(0.3),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ColorKeys.primary,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      backgroundColor: color ?? Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: systemUiOverlayStyle ?? SystemUiOverlayStyle.dark,
      centerTitle: centerTitle,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: (color ?? Colors.white).getContrast(),
                fontSize: 18,
              ),
            )
          : titleWidget,
      actions: actions,
      elevation: 0,
    );
  }
}
