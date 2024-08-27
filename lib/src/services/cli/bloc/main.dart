import 'dart:io';

import 'package:args/args.dart';
import 'package:ez_shop_sync/src/services/cli/bloc/template.dart';
import 'package:ez_shop_sync/src/services/cli/src/constance.dart';
import 'package:ez_shop_sync/src/services/cli/utils/convert.dart';
// import 'package:ats_cli_package/bloc/template.dart';
import 'package:yaml/yaml.dart';

const generateName = 'name';

class BuildBloc {
  BuildBloc();

  void build(ArgResults argResults) {
    // Read the content of the YAML file
    final File yamlFile = File('pubspec.yaml');
    if (!yamlFile.existsSync()) {
      print('Error: YAML file not found.');
      return;
    }

    final String yamlContent = yamlFile.readAsStringSync();

    // Parse the YAML content into a YamlMap
    final YamlMap yamlMap = loadYaml(yamlContent);

    // Cast the YamlMap to Map<String, dynamic>
    final Map<String, dynamic> typedMap = yamlMap.cast<String, dynamic>();

    // Check if the YAML content was parsed successfully

    // if (argResults[softwarePackage] == null || argResults[displayImage] == null || argResults[fullSizeImage] == null) {
    //   throw ('please enter option $softwarePackage, $displayImage, $fullSizeImage');
    // }

    String package = '${typedMap['name']}';
    String nameSnakeCase = argResults[generateName];
    String nameCamelCase = Convertor.snakeToCamel(nameSnakeCase);
    genPageTemplate(
        nameSnake: nameSnakeCase, nameCamel: nameCamelCase, package: package);
    genCubitTemplate(
        nameSnake: nameSnakeCase, nameCamel: nameCamelCase, package: package);
    genStateTemplate(
        nameSnake: nameSnakeCase, nameCamel: nameCamelCase, package: package);
    genRouterTemplate(
        nameSnake: nameSnakeCase, nameCamel: nameCamelCase, package: package);
  }

  void genPageTemplate(
      {required String nameSnake,
      required String nameCamel,
      required String package}) {
    String page = pageTemplate;

    String content = page
        .replaceAll('%{package}', package)
        .replaceAll('%{name}', nameCamel)
        .replaceAll("%{nameSnake}", nameSnake);

    saveDataToFile("lib/src/pages/$nameSnake/${nameSnake}_page.dart", content);

    stdout.writeln(Constance.organizeTitle);
    stdout.writeln(
        '''   \x1B[0m\x1B[32m||Generate '$nameSnake' Success :)\x1B[0m\x1B ''');
  }

  void genCubitTemplate(
      {required String nameSnake,
      required String nameCamel,
      required String package}) {
    String cubit = cubitTemplate;

    String content = cubit
        .replaceAll('%{package}', package)
        .replaceAll('%{name}', nameCamel)
        .replaceAll("%{nameSnake}", nameSnake);

    saveDataToFile("lib/src/pages/$nameSnake/${nameSnake}_cubit.dart", content);
  }

  void genStateTemplate(
      {required String nameSnake,
      required String nameCamel,
      required String package}) {
    String state = stateTemplate;

    String content = state
        .replaceAll('%{package}', package)
        .replaceAll('%{name}', nameCamel);

    saveDataToFile("lib/src/pages/$nameSnake/${nameSnake}_state.dart", content);
  }

  void genRouterTemplate(
      {required String nameSnake,
      required String nameCamel,
      required String package}) {
    String router = routerTemplate;
    String nameUpper = nameCamel.toUpperCase();
    String content = router
        .replaceAll('%{package}', package)
        .replaceAll('%{name}', nameCamel)
        .replaceAll('%{nameUpper}', nameUpper);

    saveDataToFile(
        "lib/src/pages/$nameSnake/${nameSnake}_router.dart", content);
  }

  void saveDataToFile(String path, String template) {
    File fileGenerated = File(path);
    if (fileGenerated.existsSync()) {
      fileGenerated.deleteSync();
    }
    fileGenerated.createSync(recursive: true);
    fileGenerated.writeAsStringSync(template);
  }

  void genRouteTemplate(
      {required String nameSnake,
      required String nameCamel,
      required String package}) {
    final File routesFile = File('lib/src/routes/routes.dart');
    if (!routesFile.existsSync()) {
      print('Error: routes.dart file not found.');
      return;
    }

    final String yamlContent = routesFile.readAsStringSync();

    final content = yamlContent
        .replaceFirst('// cli generate route name', '''// cli generate route name\n  static const String ROUTE_${nameCamel.toUpperCase()} = '/${nameCamel.toUpperCase()}';\n  // cli generate route name''').replaceFirst('// cli generate page map', '''// cli generate page map\n    ROUTE_${nameCamel.toUpperCase()}: (context) => const ${nameCamel}Page(),\n  // cli generate page map''').replaceFirst(
            '// cli generate import page',
            '// cli generate import page\nimport "${'package:mini_fx_booth/src/pages/$nameSnake/${nameSnake}_page.dart'}";\n// cli generate import page');
    saveDataToFile("lib/src/routes/routes.dart", content);
  }
}
