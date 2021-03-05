import 'dart:io';

import 'package:create_flutter_mono_repo/command_line_argument_parser/command_line_argument_parser.dart';
import 'package:create_flutter_mono_repo/logic/logic.dart';

void libMain(List<String> arguments) async {
  var result = CommandLineArgumentParser.parse(arguments);
  if (result.showHelp) {
    print(result.helpText);
    exit(0);
  }
  var logic = Logic(result.logicData);
  exit(await logic.start());
}
