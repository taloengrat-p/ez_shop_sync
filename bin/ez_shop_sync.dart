import 'package:args/args.dart';
import 'package:ez_shop_sync/src/services/cli/bloc/main.dart';
import 'package:ez_shop_sync/src/services/cli/src/main.dart' as resource_gen;

const commandGenerate = "generate";
const generateBlocTemplatFlag = 'bloc-cubit';
const generateResource = 'resource';
const generateName = 'name';

void main(List<String> args) {
  final parser = ArgParser()
    ..addCommand(commandGenerate)
    ..addFlag(generateBlocTemplatFlag)
    ..addFlag(generateResource)
    ..addOption(generateName); // generate

  ArgResults argResults = parser.parse(args);

  switch (argResults.command?.name) {
    case commandGenerate:
      if (argResults[generateBlocTemplatFlag]) {
        BuildBloc().build(argResults);
      } else if (argResults[generateResource]) {
        resource_gen.main();
      }
      break;
    default:
      throw ('command invalid');
  }
}
