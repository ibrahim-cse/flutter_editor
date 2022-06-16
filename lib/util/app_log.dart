import 'package:flutter_logs/flutter_logs.dart';

class AppLog extends FlutterLogs {
  late FlutterLogs logger;
  static void info(String tag, String subTag, String logMessage) {
    FlutterLogs.logInfo(tag, subTag, logMessage);
  }

  static void warn(String tag, String subTag, String logMessage) {
    FlutterLogs.logWarn(tag, subTag, logMessage);
  }

  static void error(String tag, String subTag, String logMessage) {
    FlutterLogs.logError(tag, subTag, logMessage);
  }
}
