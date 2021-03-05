import 'package:cli_util/cli_logging.dart';
import 'package:create_flutter_mono_repo/files/files.dart';
import 'package:create_flutter_mono_repo/folders/folders.dart';
import 'package:create_flutter_mono_repo/git/app.dart';
import 'package:create_flutter_mono_repo/git/generic.dart';
import 'package:create_flutter_mono_repo/git/project.dart';
import 'package:meta/meta.dart';

class Git {
  Git({
    @required Logger logger,
    @required bool dryRun,
    @required Files files,
    @required Folders folders,
    @required String projectPath,
    @required String appPath,
    @required bool verbose,
  }) {
    generic = Generic(
      logger: logger,
      folders: folders,
      dryRun: dryRun,
      gitExecutable: files.git,
      verbose: verbose,
    );
    project = Project(
      logger: logger,
      dryRun: dryRun,
      projectPath: projectPath,
      gitExecutable: files.git,
      verbose: verbose,
    );
    app = App(
      logger: logger,
      generic: generic,
      files: files,
      projectPath: projectPath,
      appPath: appPath,
      gitExecutable: files.git,
    );
  }

  Generic generic;
  Project project;
  App app;
}
