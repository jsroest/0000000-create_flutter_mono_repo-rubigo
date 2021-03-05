import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:create_flutter_mono_repo/files/files.dart';
import 'package:create_flutter_mono_repo/folders/folders.dart';
import 'package:create_flutter_mono_repo/run_cmd_ex/run_cmd_ex.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:process_run/cmd_run.dart';

class Fvm {
  Fvm({
    @required this.logger,
    @required this.dryRun,
    @required this.files,
    @required this.folders,
    @required this.appPath,
    @required this.flutterVersion,
    @required this.customerName,
    @required this.packagesPath,
    @required this.company,
    @required this.projectName,
    @required this.iosLanguage,
    @required this.androidLanguage,
    @required this.verbose,
  });

  final Logger logger;
  final bool dryRun;
  final Files files;
  final Folders folders;
  final String appPath;
  final String flutterVersion;
  final String packagesPath;
  final String customerName;
  final String company;
  final String projectName;
  final String iosLanguage;
  final String androidLanguage;
  final bool verbose;

  Future<void> checkFlutterVersion() async {
    logger.stdout('Check if fvm uses global version $flutterVersion');
    var cmd = ProcessCmd(
      files.fvm,
      [
        'flutter',
        '--version',
      ],
    );
    var results = await runCmdEx(
      cmd,
      verbose: verbose,
      logger: logger,
      dryRun: dryRun,
    );
    if (!dryRun) {
      var output = results.stdout as String;
      if (!output.contains('Flutter $flutterVersion')) {
        throw ('fvm does not use $flutterVersion as the global version.\nUse \'fvm use $flutterVersion --global\' to fix this.');
      }
    }
  }

  Future<void> adjustGitignore() async {
    logger.stdout('Adjust gitignore to exclude .fvm folder');
    if (dryRun) {
      return;
    }
    var fileSourcePath = files.gitignore;
    var fileSource = File(fileSourcePath);
    var outputStream = fileSource.openWrite(mode: FileMode.append);
    await outputStream.writeln('');
    await outputStream.writeln('# FVM related');
    await outputStream.writeln('/.fvm/flutter_sdk');
    await outputStream.close();
  }

  Future<void> initFvm() async {
    logger.stdout('Init FVM with version: $flutterVersion');
    var cmd = ProcessCmd(
        files.fvm,
        [
          'use',
          flutterVersion,
        ],
        workingDirectory: appPath);
    await runCmdEx(
      cmd,
      verbose: verbose,
      logger: logger,
      dryRun: dryRun,
    );
  }

  Future<void> createFlutterApp() async {
    logger.stdout('Create flutter project');
    var cmd = ProcessCmd(
      files.fvm,
      [
        'flutter',
        'create',
        '--org',
        '$company',
        '--project-name',
        '$projectName',
        '--ios-language',
        '$iosLanguage',
        '--android-language',
        '$androidLanguage',
        path.basename(folders.appPath),
      ],
    );
    cmd.workingDirectory = packagesPath;
    await runCmdEx(
      cmd,
      verbose: verbose,
      logger: logger,
      dryRun: dryRun,
    );
  }
}
