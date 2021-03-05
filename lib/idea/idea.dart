import 'dart:convert';
import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:create_flutter_mono_repo/files/files.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:xml/xml.dart';

class Idea {
  Idea({
    @required this.logger,
    @required this.dryRun,
    @required this.appPath,
    @required this.files,
  });

  final Logger logger;
  final bool dryRun;
  final String appPath;
  final Files files;

  Future<void> adjustGitignore() async {
    logger.stdout('Adjust gitignore to include important idea files');
    if (dryRun) {
      return;
    }
    var fileSourcePath = path.join(appPath, '.gitignore');
    var fileSource = File(fileSourcePath);
    var inputStream = fileSource.openRead();

    var fileDestinationPath = fileSourcePath + '.tmp';
    var fileDestination = File(fileDestinationPath);
    var outputStream = fileDestination.openWrite();

    var intelliJBlockReplacer = IntelliJBlockReplacer(
      logger: logger,
      outputStream: outputStream,
    );

    var lineStream = inputStream.transform(utf8.decoder).transform(
          LineSplitter(),
        );

    await for (String line in lineStream) {
      intelliJBlockReplacer.onData(line);
    }
    await outputStream.close();
    await fileDestination.rename(fileSourcePath);
  }

  Future<void> excludeFolderFvm() async {
    logger.stdout('Adjust ${files.appIml}, to exclude fvm folder');
    if (dryRun) {
      return;
    }
    final file = File(files.appIml);
    final document = XmlDocument.parse(await file.readAsString());
    var module = document
        .findElements('module')
        .where((element) => element.attributes
            .where((attribute) =>
                attribute.name == XmlName('type') &&
                attribute.value == 'JAVA_MODULE')
            .isNotEmpty)
        .first;
    var component = module
        .findElements('component')
        .where((element) => element.attributes
            .where((attribute) =>
                attribute.name == XmlName('name') &&
                attribute.value == 'NewModuleRootManager')
            .isNotEmpty)
        .first;
    var content = component
        .findElements('content')
        .where((element) => element.attributes
            .where((attribute) =>
                attribute.name == XmlName('url') &&
                attribute.value == r'file://$MODULE_DIR$')
            .isNotEmpty)
        .first;
    var excludeFolder = content.findElements('excludeFolder').where((element) =>
        element.attributes
            .where((attribute) =>
                attribute.name == XmlName('url') &&
                attribute.value == r'file://$MODULE_DIR$/.fvm/flutter_sdk')
            .isNotEmpty);
    if (excludeFolder.isEmpty) {
      final builder = XmlBuilder();
      builder.element('excludeFolder', nest: () {
        builder.attribute('url', r'file://$MODULE_DIR$/.fvm/flutter_sdk');
      });
      content.children.add(builder.buildFragment());
      //Remove empty XmlText elements containing only a '\n  '
      content.children.removeWhere((element) => element is XmlText);
      content.children.sort(nodeComparator);
      file.writeAsStringSync(
        document.toXmlString(pretty: true),
      );
    }
  }

  Comparator<XmlNode> nodeComparator = (a, b) {
    if (a is XmlElement && b is XmlElement) {
      var compareByName = b.name.local.compareTo(a.name.local);
      if (compareByName != 0) {
        return compareByName;
      }
      var urlA = a.attributes.firstWhere((a) => a.name == XmlName('url')).value;
      var urlB = b.attributes.firstWhere((b) => b.name == XmlName('url')).value;
      return urlA.compareTo(urlB);
    }
    return 0;
  };

  Future<void> removeAndroidModule() async {
    logger.stdout('Remove Android project from ${files.ideaModules}');
    if (dryRun) {
      return;
    }
    final file = File(files.ideaModules);
    final document = XmlDocument.parse(await file.readAsString());
    var project = document.findElements('project').first;
    var component = project
        .findElements('component')
        .where((element) => element.attributes
            .where((attribute) =>
                attribute.name == XmlName('name') &&
                attribute.value == 'ProjectModuleManager')
            .isNotEmpty)
        .first;
    var modules = component.findElements('modules').first;
    var androidModule = modules
        .findElements('module')
        .where((element) => element.attributes
            .where((attribute) =>
                attribute.name == XmlName('fileurl') &&
                attribute.value.contains('${path.basename(files.androidIml)}'))
            .isNotEmpty)
        .first;
    modules.children.remove(androidModule);
    await file.writeAsString(document.toXmlString(pretty: true));
  }
}

class IntelliJBlockReplacer {
  IntelliJBlockReplacer({
    @required this.logger,
    @required this.outputStream,
  });

  final Logger logger;
  final IOSink outputStream;
  bool inBlock = false;

  void onData(String line) {
    if (!inBlock) {
      if (line.startsWith('# IntelliJ related')) {
        logger.stdout('IntelliJ block found in .gitignore');
        inBlock = true;
        outputStream.writeln(line);
        outputStream.writeln('.idea/**/workspace.xml');
        outputStream.writeln('.idea/**/tasks.xml');
        outputStream.writeln('.idea/**/usage.statistics.xml');
        outputStream.writeln('.idea/**/dictionaries');
        outputStream.writeln('.idea/**/shelf');
        outputStream.writeln('.idea/**/libraries');
        return;
      }
      outputStream.writeln(line);
      return;
    }
    if (line.trim() == '') {
      inBlock = false;
      outputStream.writeln(line);
      return;
    }
  }
}
