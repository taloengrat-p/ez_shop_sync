// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

class OptionItem {
  final String title;
  final dynamic value;
  final Widget? leading;
  OptionItem({required this.title, required this.value, this.leading});
}
