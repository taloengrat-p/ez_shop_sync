import 'package:ez_shop_sync/res/colors.dart';
import 'package:ez_shop_sync/src/utils/extensions/color_extension.dart';
import 'package:ez_shop_sync/src/widgets/container/container_circle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppbarWidget {
  String? title;
  TextStyle? titleStyle;
  List<Widget>? actions;
  bool? centerTitle;
  Color? color;
  Color? iconThemeColor;
  SystemUiOverlayStyle? systemUiOverlayStyle;
  Widget? titleWidget;
  PreferredSizeWidget? bottom;
  final BuildContext context;
  bool showLeading;
  AppbarWidget(
    this.context, {
    this.title,
    this.actions,
    this.color,
    this.centerTitle,
    this.iconThemeColor,
    this.systemUiOverlayStyle,
    this.titleWidget,
    this.titleStyle,
    this.bottom,
    this.showLeading = true,
  });
  AppBar build() {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);

    return AppBar(
      leading:
          showLeading && (parentRoute?.impliesAppBarDismissal ?? false)
              ? ContainerCircleWidget(
                margin: const EdgeInsets.only(left: 8),
                backgroundColor: ColorKeys.primary.withOpacity(0.1),
                child: Icon(Icons.arrow_back_ios_new_rounded, color: ColorKeys.primary),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
              : null,
      automaticallyImplyLeading: showLeading && (parentRoute?.impliesAppBarDismissal ?? false),
      backgroundColor: color ?? Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: systemUiOverlayStyle ?? SystemUiOverlayStyle.dark,
      centerTitle: centerTitle,
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child:
            titleWidget ??
            Text(
              title ?? '',
              style:
                  titleStyle ??
                  TextStyle(color: (color ?? Colors.white).getContrast(), fontSize: 18, fontWeight: FontWeight.bold),
            ),
      ),
      actions: actions,

      elevation: 0,
      bottom: bottom,
    );
  }
}
