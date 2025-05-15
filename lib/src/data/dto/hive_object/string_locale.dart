// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'string_locale.g.dart';

@HiveType(typeId: 21)
@JsonSerializable(explicitToJson: true)
class StringLocale {
  @HiveField(1)
  final String en;

  @HiveField(2)
  final String th;
  StringLocale({required this.en, required this.th});

  factory StringLocale.fromJson(Map<String, dynamic> json) => _$StringLocaleFromJson(json);

  Map<String, dynamic> toJson() => _$StringLocaleToJson(this);

  String tr(BuildContext context) {
    final lang = context.locale;
    final text = lang == const Locale('th') ? th : en;
    return text;
  }
}
