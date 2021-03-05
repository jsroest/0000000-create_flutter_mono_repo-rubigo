import 'dart:io';

import 'package:args/args.dart';
import 'package:create_flutter_mono_repo/logic_data/logic_data.dart';
import 'package:meta/meta.dart';

class CommandLineArgumentParser {
  static final cliHelp = 'help';
  static final cliRootPath = 'root-path';
  static final cliCustomerId = 'customer-id';
  static final cliProjectName = 'project-name';
  static final cliCustomerName = 'customer-name';
  static final cliOrg = 'org';
  static final cliIosLanguage = 'ios-language';
  static final cliAndroidLanguage = 'android-language';
  static final cliFlutterVersion = 'flutter-version';
  static final cliVerbose = 'verbose';
  static final cliDryRun = 'dry-run';

  static CommandLineArgumentParserResult parse(List<String> arguments) {
    var argParser = ArgParser();
    argParser.addOption(cliRootPath,
        defaultsTo: Directory.current.path,
        help:
            'The directory where the project will be created. Defaults to the current directory.');
    argParser.addOption(cliCustomerId,
        defaultsTo: '0000000',
        help:
            'Unique id of the customer, only used for the name of the project folder. Convention: numeric, fixed 7 positions.');
    argParser.addOption(cliProjectName,
        defaultsTo: 'flutter_sample_app',
        help:
            'Used for the project folder and as the id of the app. Convention: lowercase and underscores.');
    argParser.addOption(cliCustomerName,
        defaultsTo: 'rubigo',
        help:
            'Name of the customer, only used for the name of the project folder. Convention: lowercase and underscores.');
    argParser.addOption(cliOrg,
        defaultsTo: 'com.example',
        help:
            'Name of the company in reverse domain name notation, like \'com.example\'.');
    argParser.addOption(
      cliIosLanguage,
      defaultsTo: 'swift',
      allowed: ['objc', 'swift'],
    );
    argParser.addOption(
      cliAndroidLanguage,
      defaultsTo: 'kotlin',
      allowed: ['java', 'kotlin'],
    );
    argParser.addOption(
      cliFlutterVersion,
      defaultsTo: '1.22.6',
      help: 'The flutter version to use for this project',
    );
    argParser.addFlag(
      cliVerbose,
      help: 'Verbose output',
    );
    argParser.addFlag(
      cliDryRun,
      abbr: 'd',
      negatable: true,
      help: 'Dry run, show only the commands.',
    );
    argParser.addFlag(
      cliHelp,
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information',
    );
    var argResults = argParser.parse(arguments);
    var argumentCreator = ArgumentCreator(argResults);
    final result = CommandLineArgumentParserResult(
      showHelp: argResults[cliHelp] as bool,
      helpText:
          'Usage: create_flutter_mono_repo [arguments]\n${argParser.usage}',
      logicData: LogicData(
        rootPath: argumentCreator.create(cliRootPath),
        customerId: argumentCreator.create(cliCustomerId),
        projectName: argumentCreator.create(cliProjectName),
        customerName: argumentCreator.create(cliCustomerName),
        company: argumentCreator.create(cliOrg),
        iosLanguage: argumentCreator.create(cliIosLanguage),
        androidLanguage: argumentCreator.create(cliAndroidLanguage),
        flutterVersion: argumentCreator.create(cliFlutterVersion),
        verbose: argumentCreator.create(cliVerbose),
        dryRun: argumentCreator.create(cliDryRun),
      ),
    );
    return result;
  }
}

class CommandLineArgumentParserResult {
  CommandLineArgumentParserResult({
    @required this.showHelp,
    @required this.helpText,
    @required this.logicData,
  });

  final bool showHelp;
  final String helpText;
  final LogicData logicData;
}
