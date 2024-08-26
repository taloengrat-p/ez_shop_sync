import 'package:flutter/material.dart';

class MenuItemModel {
  final String title;
  final dynamic value;
  final Widget? trailing;
  final bool disabled;
  final Function()? onPressed;

  MenuItemModel({
    required this.title,
    required this.value,
    this.onPressed,
    this.trailing,
    this.disabled = false,
  });
}
