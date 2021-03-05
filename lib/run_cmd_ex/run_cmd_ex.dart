import 'dart:async';
import 'dart:io';

import 'package:cli_util/cli_logging.dart';
import 'package:meta/meta.dart';
import 'package:process_run/cmd_run.dart';

Future<ProcessResult> runCmdEx(
  ProcessCmd cmd, {
  bool verbose,
  bool commandVerbose,
  Stream<List<int>> stdin,
  StreamSink<List<int>> stdout,
  StreamSink<List<int>> stderr,
  @required bool dryRun,
  @required Logger logger,
}) {
  if (dryRun) {
    if (logger == null) {
      throw 'logger may not be null when dryRun == true';
    }
    logger.stdout('>> ${cmd.toString()}');
    return null;
  }
  return runCmd(
    cmd,
    verbose: verbose,
  );
}
