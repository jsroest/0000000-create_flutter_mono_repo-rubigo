import 'package:cli_util/cli_logging.dart';
import 'package:create_flutter_mono_repo/files/files.dart';
import 'package:create_flutter_mono_repo/folders/folders.dart';
import 'package:create_flutter_mono_repo/fvm/fvm.dart';
import 'package:create_flutter_mono_repo/git/git.dart';
import 'package:create_flutter_mono_repo/idea/idea.dart';
import 'package:create_flutter_mono_repo/logic_data/logic_data.dart';
import 'package:path/path.dart' as path;

class Logic {
  Logic(LogicData logicData) {
    _logicDataAsText = logicData.toString();
    _dryRun = logicData.dryRun.value;
    _logger = logicData.verbose.value ? Logger.verbose() : Logger.standard();
    _folders = Folders(
      logger: _logger,
      dryRun: logicData.dryRun.value,
      rootPath: logicData.rootPath.value,
      customerId: logicData.customerId.value,
      projectName: logicData.projectName.value,
      customerName: logicData.customerName.value,
    );
    _files = Files(
      logger: _logger,
      folders: _folders,
      projectName: logicData.projectName.value,
    );
    _git = Git(
      logger: _logger,
      dryRun: logicData.dryRun.value,
      files: _files,
      folders: _folders,
      projectPath: _folders.projectPath,
      appPath: _folders.appPath,
      verbose: logicData.verbose.value,
    );
    _idea = Idea(
      logger: _logger,
      dryRun: logicData.dryRun.value,
      appPath: _folders.appPath,
      files: _files,
    );
    _fvm = Fvm(
      logger: _logger,
      dryRun: logicData.dryRun.value,
      files: _files,
      folders: _folders,
      appPath: _folders.appPath,
      flutterVersion: logicData.flutterVersion.value,
      packagesPath: _folders.packagesPath,
      projectName: logicData.projectName.value,
      customerName: logicData.customerName.value,
      company: logicData.company.value,
      iosLanguage: logicData.iosLanguage.value,
      androidLanguage: logicData.androidLanguage.value,
      verbose: logicData.verbose.value,
    );
  }

  String _logicDataAsText;
  bool _dryRun;
  Logger _logger;
  Folders _folders;
  Files _files;
  Git _git;
  Idea _idea;
  Fvm _fvm;

  Future<int> start() async {
    try {
      if (_dryRun) {
        _logger.stdout('These values will be used:');
        _logger.stdout(_logicDataAsText);
        _logger.stdout('\n');
        _logger.stdout('These actions will be performed:');
      }
      //First check if the supplier Flutter version is the same as set by: fvm use <version> --global
      await _fvm.checkFlutterVersion();

      //Create the folder for the project
      await _folders.createProjectDirectory();

      //Initialize git on this folder
      await _git.project.init();

      //Create the packages folder in the project folder
      await _folders.createPackagesDirectory();

      //Call 'fvm flutter create' with the options supplied
      await _fvm.createFlutterApp();

      //Commit the 'original' .gitignore file
      await _git.app.addAndCommitGitignore(message: 'Initial commit');

      //Adjust the .gitignore file to include some specific IntelliJ Idea files
      await _idea.adjustGitignore();

      //Commit the altered .gitignore file
      await _git.app.addAndCommitGitignore(
          message: 'Change .gitignore to include important .idea files');

      //Commit the 'original', freshly created flutter project
      await _git.app.addAndCommitAll(message: 'Initial flutter project');

      //Activate FVM on the Flutter project, with the version specified
      await _fvm.initFvm();

      //Adjust the .gitignore file to exclude the FVM symbolic link
      await _fvm.adjustGitignore();

      //Adjust the IntelliJ Idea file, to exclude the FVM symbolic link
      await _idea.excludeFolderFvm();

      //Commit the changes made for FVM
      await _git.app
          .addAndCommitAll(message: 'Init FVM (${_fvm.flutterVersion})');

      //Remove the Android Module from the IntelliJ Idea file, because it's not needed
      await _idea.removeAndroidModule();

      //Commit the changes for the Android Module removal
      await _git.app.addAndCommitAll(
          message:
              'Remove ${path.basename(_files.androidIml)} from ${path.basename(_files.ideaModules)}');

      return 0;
    } catch (exception) {
      _logger.stderr('Error');
      _logger.stderr(exception.toString());
      return 1;
    }
  }
}
