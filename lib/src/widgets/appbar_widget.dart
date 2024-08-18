import 'package:ez_shop_sync/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppbarWidget {
  String? title;
  List<Widget>? actions;
  bool? centerTitle;
  Color? color;
  Color? iconThemeColor;
  SystemUiOverlayStyle? systemUiOverlayStyle;
  AppbarWidget({
    this.title,
    this.actions,
    this.color,
    this.centerTitle,
    this.iconThemeColor,
    this.systemUiOverlayStyle,
  });
  AppBar build() {
    return AppBar(
      iconTheme: IconThemeData(color: iconThemeColor ?? Colors.white),
      backgroundColor: color ?? ColorKeys.midnightBlue,
      systemOverlayStyle: systemUiOverlayStyle,
      centerTitle: centerTitle,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            )
          : null,
      actions: actions,
    );
  }
}
