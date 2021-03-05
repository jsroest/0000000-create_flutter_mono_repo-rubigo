import 'package:cli_util/cli_logging.dart';
import 'package:create_flutter_mono_repo/folders/folders.dart';
import 'package:create_flutter_mono_repo/run_cmd_ex/run_cmd_ex.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path_package;
import 'package:process_run/cmd_run.dart';

class Generic {
  Generic({
    @required this.logger,
    @required this.dryRun,
    @required this.folders,
    @required this.gitExecutable,
    @required this.verbose,
  });

  final Logger logger;
  final Folders folders;
  final bool dryRun;
  final String gitExecutable;
  final bool verbose;

  Future<void> gitAdd({
    String path,
    String file,
  }) async {
    var cmd = ProcessCmd(
        gitExecutable,
        [
          'add',
          file,
        ],
        workingDirectory: path);
    await runCmdEx(
      cmd,
      verbose: verbose,
      logger: logger,
      dryRun: dryRun,
    );
  }

  Future<void> gitCommit({
    String path,
    String message,
  }) async {
    var cmd = ProcessCmd(
        gitExecutable,
        [
          'commit',
          '-m',
          '[${path_package.basename(folders.appPath)}] $message',
        ],
        workingDirectory: path);
    await runCmdEx(
      cmd,
      verbose: verbose,
      logger: logger,
      dryRun: dryRun,
    );
  }
}
