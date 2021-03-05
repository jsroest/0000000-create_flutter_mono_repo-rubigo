import 'package:cli_util/cli_logging.dart';
import 'package:create_flutter_mono_repo/run_cmd_ex/run_cmd_ex.dart';
import 'package:meta/meta.dart';
import 'package:process_run/cmd_run.dart';

class Project {
  Project({
    @required this.logger,
    @required this.dryRun,
    @required this.projectPath,
    @required this.gitExecutable,
    @required this.verbose,
  });

  final Logger logger;
  final bool dryRun;
  final String projectPath;
  final String gitExecutable;
  final bool verbose;

  Future<void> init() async {
    logger.stdout('Initialize git in folder: $projectPath');
    var cmd = ProcessCmd(
      gitExecutable,
      ['init'],
      workingDirectory: projectPath,
    );
    await runCmdEx(
      cmd,
      verbose: verbose,
      logger: logger,
      dryRun: dryRun,
    );
  }
}
