import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

class Folders {
  Folders({
    @required this.logger,
    @required this.dryRun,
    @required String rootPath,
    @required String customerId,
    @required String projectName,
    @required String customerName,
  }) {
    _rootPath = rootPath;
    _customerId = customerId;
    _projectName = projectName;
    _customerName = customerName;
  }

  Logger logger;
  bool dryRun;
  String _rootPath;
  String _customerId;
  String _projectName;
  String _customerName;

  String _projectPath;

  String get projectPath => _projectPath ??= path.join(
        _rootPath,
        '$_customerId-$_projectName-$_customerName',
      );

  String _packagesPath;

  String get packagesPath =>
      _packagesPath ??= path.join(projectPath, 'packages');

  String _appPath;

  String get appPath => _appPath ??= path.join(packagesPath, 'app');

  String _androidPath;

  String get androidPath => _androidPath ??= path.join(appPath, 'android');

  String _ideaPath;

  String get ideaPath => _ideaPath ??= path.join(appPath, '.idea');

  Future<void> createProjectDirectory() async {
    await _createDirectory(path: projectPath);
  }

  Future<void> createPackagesDirectory() async {
    await _createDirectory(path: packagesPath);
  }

  Future<void> _createDirectory({
    @required String path,
  }) async {
    var directory = Directory(path);

    if (await directory.exists()) {
      throw ('Folder already exists: $path');
    }
    logger.stdout('Create folder: ${directory.path}');
    if (!dryRun) {
      await directory.create(recursive: true);
    }
  }
}
