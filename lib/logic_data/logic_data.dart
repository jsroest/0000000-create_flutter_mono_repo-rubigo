import 'package:args/args.dart';
import 'package:meta/meta.dart';

class LogicData {
  LogicData({
    @required this.rootPath,
    @required this.customerId,
    @required this.projectName,
    @required this.customerName,
    @required this.company,
    @required this.iosLanguage,
    @required this.androidLanguage,
    @required this.flutterVersion,
    @required this.verbose,
    @required this.dryRun,
  });

  final Argument<String> rootPath;
  final Argument<String> customerId;
  final Argument<String> projectName;
  final Argument<String> customerName;
  final Argument<String> company;
  final Argument<String> iosLanguage;
  final Argument<String> androidLanguage;
  final Argument<String> flutterVersion;
  final Argument<bool> verbose;
  final Argument<bool> dryRun;

  @override
  String toString() {
    return [
      rootPath.toString(),
      customerId.toString(),
      projectName.toString(),
      customerName.toString(),
      company.toString(),
      iosLanguage.toString(),
      androidLanguage.toString(),
      flutterVersion.toString(),
      verbose.toString(),
      dryRun.toString(),
    ].join('\n');
  }
}

class ArgumentCreator {
  ArgumentCreator(ArgResults argResults) {
    _argResults = argResults;
  }

  ArgResults _argResults;

  Argument<T> create<T>(String arg) {
    return Argument(arg: arg, value: _argResults[arg] as T);
  }
}

class Argument<T> {
  Argument({this.arg, this.value});

  final String arg;
  final T value;

  @override
  String toString() {
    return '$arg: \'$value\'';
  }
}
