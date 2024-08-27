import 'dart:io';
import 'dart:core';

import 'package:ez_shop_sync/src/services/cli/src/constance.dart';

void main() async {
  String languagePath = 'lib/res/translations/langs.csv';
  String colorPath = 'lib/res/colors.dart';
  String drawablePath = 'lib/res/drawables';
  String dimenPath = 'lib/res/dimens.dart';
  String pubspectPath = 'pubspec.yaml';

  stdout.writeln(Constance.organizeTitle);
  // GENERATE STRUCTURE
  generateStructure();

  // GENERATE
  generateLanguage(languagePath);
  generateColor(colorPath);
  generateDrawable(drawablePath);
  generateDimension(dimenPath);
  generateFont();

  // GENERATE SOURCE
  generateR();

  // WATCH FILE CHANGE
  File(languagePath).watch().listen(((event) {
    generateLanguage(event.path, rebuild: true);
  }));
  File(dimenPath).watch().listen(((event) {
    generateDimension(event.path, rebuild: true);
  }));
  File(colorPath).watch().listen(((event) {
    generateColor(event.path, rebuild: true);
  }));
  File(drawablePath).watch().listen(((event) {
    generateDrawable(event.path, rebuild: true);
  }));

  File(pubspectPath).watch().listen((event) {
    generateFont();
  });

  await stdin.pipe(stdout);
}

generateStructure() {
  print('(*) generateStructure');
  Directory drawable = Directory('lib/res/drawables');
  if (!drawable.existsSync()) {
    drawable.createSync(recursive: true);
  }

  Directory font = Directory('lib/res/fonts');
  if (!font.existsSync()) {
    font.createSync(recursive: true);
  }

  File langs = File('lib/res/translations/langs.csv');
  if (!langs.existsSync()) {
    langs.createSync(recursive: true);
  }

  File dimen = File('lib/res/dimens.dart');
  if (!dimen.existsSync()) {
    dimen.createSync(recursive: true);
    dimen.writeAsStringSync("""class AppDimens {

}
""");
  }

  File color = File('lib/res/colors.dart');
  if (!color.existsSync()) {
    color.createSync(recursive: true);
    color.writeAsStringSync("""import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {

}
""");
  }
}

generateR() {
  String path = 'lib/res/R.dart';
  File file = File(path);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
    file.writeAsStringSync("""// GENERATED CODE - DO NOT MODIFY
import 'package:aware_event/src/localization/localization.dart';

import 'dimens.dart';
import 'generated/colors.g.dart';
import 'generated/dimens.g.dart';
import 'generated/drawables.g.dart';
import 'generated/fonts.g.dart';
import 'generated/strings.g.dart';

class R {
  R._();

  static final drawable = Drawables();
  static final string = Strings();
  static final font = Fonts();
  static final color = Colors();
  static final dimen = AppDimens();

  static String tr({required String? en, required String? th}) {
    return Localization.isAppLanguageEn() ? en ?? "" : th ?? "";
  }
}
""");
  }
}

generateDimension(String path, {bool? rebuild = false}) {
  if (rebuild!) {
    Log.logCyan('(*) Re-Generate | Dimension (${getCurentDateTime()})');
  } else {
    Log.logInfo('(*) Generate | Dimension');
  }
  String colorPath = path;
  File file = File(colorPath);
  String template = """// GENERATED CODE - DO NOT MODIFY

// ignore_for_file: non_constant_identifier_names

class Dimensions {
{{lineList}}
}""";
  List<String> lineList = [];

  for (String line in file.readAsLinesSync()) {
    if (!line.contains("//") && line.contains("int")) {
      String key = line.trim().split(" ")[2];
      String value = line.trim().split(" ")[4];
      lineList.add("""  int get $key => $value""");
    }
  }
  template = template.replaceAll("{{lineList}}", lineList.join("\n"));
  saveDataToFile('lib/res/generated/dimens.g.dart', template);
}

generateFont() {
  String path = 'pubspec.yaml';
  File file = File(path);

  String template = """// GENERATED CODE - DO NOT MODIFY

// ignore_for_file: non_constant_identifier_names

class Fonts {
{{lineList}}
}""";
  List<String> lineList = [];

  for (String line in file.readAsLinesSync()) {
    if (!line.contains('#') && line.contains('- family: ')) {
      String name = line.split('- family: ')[1];
      String trueName = camelToSnake(name);
      lineList.add("""  String get $trueName => '$name';""");
    }
  }
  template = template.replaceAll("{{lineList}}", lineList.join("\n"));
  saveDataToFile('lib/res/generated/fonts.g.dart', template);
}

generateDrawable(String path, {bool? rebuild = false}) {
  if (rebuild!) {
    Log.logCyan('(*) Re-Generate | Drawable (${getCurentDateTime()})');
  } else {
    Log.logInfo('(*) Generate | Drawable');
  }
  String drawableDirectory = path;
  Directory directory = Directory(drawableDirectory);
  if (!directory.existsSync()) {
    directory.createSync();
  }
  List<String> fileList = directory.listSync().map((f) => f.path).toList();
  String template = """// GENERATED CODE - DO NOT MODIFY

// ignore_for_file: non_constant_identifier_names

class Drawables {
{{lineList}}
}""";
  List<String> lineList = [];

  for (String filePath in fileList) {
    List<String> pathSplit = filePath.split('/');

    String fileName = pathSplit[pathSplit.length - 1];

    String ext = fileName.split('.')[fileName.split('.').length - 1];
    if (!fileName.startsWith(".", 0)) {
      String result = fileName
          .replaceAll("drawables", "")
          .replaceAll("\\", "")
          .replaceAll(ext, "")
          .toLowerCase()
          .replaceAll(RegExp('[^A-Za-z0-9-_]'), '')
          .replaceAll("-", "_")
          .replaceAll("\\", "/");
      lineList.add("""  String get $result => "lib/res/$fileName";""");
    }
  }
  template = template
      .replaceAll("{{lineList}}", lineList.join("\n"))
      .replaceAll("\\", "/");

  saveDataToFile('lib/res/generated/drawables.g.dart', template);
}

generateColor(String path, {bool? rebuild = false}) {
  if (rebuild!) {
    Log.logCyan('(*) Re-Generate | Color (${getCurentDateTime()})');
  } else {
    Log.logInfo('(*) Generate | Color');
  }
  String colorPath = path;
  File file = File(colorPath);
  String template = """// GENERATED CODE - DO NOT MODIFY

// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:flutter/material.dart' as mtr;
class Colors {
{{lineList}}
}""";
  List<String> lineList = [];

  for (String line in file.readAsLinesSync()) {
    line = line.trimLeft();
    if (!line.startsWith("//") && line.contains("static")) {
      String key = line.trim().split(" ")[2];
      String value = line.trim().split(" ")[4];
      if (line.contains('0x')) {
        value = "const $value";
      }
      lineList.add("""  Color get $key => $value""");
    }
  }
  template = template.replaceAll("{{lineList}}", lineList.join("\n"));
  saveDataToFile('lib/res/generated/colors.g.dart', template);
}

generateLanguage(String path, {bool? rebuild = false}) {
  if (rebuild!) {
    Log.logCyan('(*) Re-Generate | Language (${getCurentDateTime()})');
  } else {
    Log.logInfo('(*) Generate | Language');
  }

  String langPath = path;
  File file = File(langPath);
  int lineCount = 0;
  String template = """// GENERATED CODE - DO NOT MODIFY

// ignore_for_file: non_constant_identifier_names

class Strings {
{{lineList}}
}""";
  List<String> lineList = [];
  List<String> keyList = [];
  List<String> duplicateList = [];

  for (String line in file.readAsLinesSync()) {
    if (lineCount > 0) {
      String key = line.split(',')[0].replaceAll(".", "");
      if (key.isNotEmpty) {
        lineList.add("""  String get $key => '$key';""");

        if (keyList.contains(key)) {
          duplicateList.add(key);
        } else {
          keyList.add(key);
        }
      }
    }
    lineCount++;
  }

  template = template.replaceAll("{{lineList}}", lineList.join("\n"));
  saveDataToFile('lib/res/generated/strings.g.dart', template);

  if (duplicateList.isNotEmpty) {
    Log.logWarnning('''   (#) Result | Language (warning)
       [key duplicate] : ${duplicateList.toString()}''');
  } else {
    Log.logSusccess('   (#) Result | Language (success)');
  }
}

saveDataToFile(String path, String template) {
  File fileGenerated = File(path);
  if (fileGenerated.existsSync()) {
    fileGenerated.deleteSync();
  }
  fileGenerated.createSync(recursive: true);
  fileGenerated.writeAsStringSync(template);
}

String getCurentDateTime() {
  return DateTime.now().toString();
}

String camelToSnake(String str) {
  String result = "";
  List<String> strSplit = str.split('');
  int i = 0;
  for (String e in strSplit) {
    if (e.toLowerCase() != str[i]) {
      if (i != 0) {
        result += '_';
      }
      result += e.toLowerCase();
    } else {
      result += e;
    }

    i++;
  }

  return result;
}

class Log {
  static logInfo(String message) {
    print(message.toBlackColor());
  }

  static logSusccess(String message) {
    print(message.toGreenColor());
  }

  static logError(String message) {
    print(message.toRedColor());
  }

  static logWarnning(String message) {
    print(message.toYellowColor());
  }

  static logCyan(String message) {
    print(message.toCyan());
  }
}

extension ColorWrapper on String {
  static const String reset = '\x1B[0m'; // Reset:   \x1B[0m
  static const String black = '\x1B[30m'; // Black:   \x1B[30m
  static const String white = '\x1B[37m'; // White:   \x1B[37m
  static const String red = '\x1B[31m'; // Red:     \x1B[31m
  static const String green = '\x1B[32m'; // Green:   \x1B[32m
  static const String yellow = '\x1B[33m'; // Yellow:  \x1B[33m
  static const String blue = '\x1B[34m'; // Blue:    \x1B[34m
  static const String cyan = '\x1B[36m'; // Cyan:    \x1B[36m
  static const String endfix = '\x1B[0m';
  String toGreenColor() {
    return '$green${this}$endfix';
  }

  String toRedColor() {
    return '$red${this}$endfix';
  }

  String toYellowColor() {
    return '$yellow${this}$endfix';
  }

  String toBlackColor() {
    return '$black${this}$endfix';
  }

  String toWhiteColor() {
    return '$white${this}$endfix';
  }

  String toCyan() {
    return '$cyan${this}$endfix';
  }
}
