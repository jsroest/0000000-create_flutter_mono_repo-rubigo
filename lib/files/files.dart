import 'package:cli_util/cli_logging.dart';
import 'package:create_flutter_mono_repo/folders/folders.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:process_run/shell.dart';

class Files {
  Files({
    @required this.logger,
    @required this.folders,
    @required this.projectName,
  });

  final Logger logger;
  final Folders folders;
  final String projectName;

  String _fvm;

  String get fvm => _fvm ??= _getExecutable(name: 'fvm');

  String _git;

  String get git => _git ??= _getExecutable(name: 'git');

  String _gitignore;

  String get gitignore =>
      _gitignore ??= path.join(folders.appPath, '.gitignore');

  String _appIml;
  String get appIml =>
      _appIml ??= path.join(folders.appPath, '$projectName.iml');

  String _androidIml;
  String get androidIml => _androidIml ??=
      path.join(folders.androidPath, '${projectName}_android.iml');

  String _ideaModules;
  String get ideaModules =>
      _ideaModules ??= path.join(folders.ideaPath, 'modules.xml');

  String _getExecutable({
    @required String name,
  }) {
    var executable = whichSync(name);
    if (executable == null) {
      throw ('Could not find $name');
    }
    return executable;
  }
}
