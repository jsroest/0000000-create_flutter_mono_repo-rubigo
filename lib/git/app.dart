import 'package:cli_util/cli_logging.dart';
import 'package:create_flutter_mono_repo/files/files.dart';
import 'package:create_flutter_mono_repo/git/generic.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

class App {
  App({
    @required this.logger,
    @required this.generic,
    @required this.files,
    @required this.projectPath,
    @required this.appPath,
    @required String gitExecutable,
  });

  final Logger logger;
  final Generic generic;
  final Files files;
  final String projectPath;
  final String appPath;

  Future<void> addAndCommitAll({
    @required String message,
  }) async {
    logger.stdout('Add and commit all files in path: $appPath');
    await generic.gitAdd(path: appPath, file: '-A');
    await generic.gitCommit(path: projectPath, message: message);
  }

  Future<void> addAndCommitGitignore({
    @required String message,
  }) async {
    logger.stdout('Add and commit: ${path.join(appPath, files.gitignore)}');
    await generic.gitAdd(path: appPath, file: files.gitignore);
    await generic.gitCommit(path: projectPath, message: message);
  }
}
