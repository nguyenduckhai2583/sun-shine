import 'dart:developer' as dev;

import 'package:logger/logger.dart';

/// Console logging, in the same shape and format the employer app uses.
class LogUtils {
  static bool _isDebugMode = false;

  static String logPrefix = '';

  static LogOutput _output = LogOutputDecorator();

  static Logger _logger = Logger(printer: AppPrettyPrinter(), output: _output);

  static void init({
    bool isDebug = false,
    String prefix = '',
    LogOutput? logOutput,
  }) {
    _isDebugMode = isDebug;
    logPrefix = prefix;
    if (logOutput != null) {
      _output = logOutput;
      _logger = Logger(printer: AppPrettyPrinter(), output: logOutput);
    }
  }

  static void d(Object object) => _logIfDebug(() => _logger.d(object));

  static void e(Object object, {Object? error, StackTrace? stackTrace}) =>
      _logIfDebug(
        () => _logger.e(object, error: error, stackTrace: stackTrace),
      );

  static void i(Object object) => _logIfDebug(() => _logger.i(object));

  static void w(Object object) => _logIfDebug(() => _logger.w(object));

  static void longText(Object object) =>
      _logIfDebug(() => dev.log(object.toString(), name: logPrefix));

  static void _logIfDebug(void Function() logFunction) {
    if (_isDebugMode) logFunction();
  }
}

class LogOutputDecorator extends LogOutput {
  @override
  void output(OutputEvent event) {
    dev.log(event.lines.join('\n'), name: LogUtils.logPrefix);
  }
}

class AppPrettyPrinter extends PrettyPrinter {
  AppPrettyPrinter({
    super.stackTraceBeginIndex = 0,
    super.methodCount = 1,
    super.errorMethodCount = 8,
    super.lineLength = 24,
    super.colors = false,
    super.printEmojis = true,
    super.dateTimeFormat = DateTimeFormat.none,
    super.excludeBox = const {},
    super.noBoxingByDefault = false,
    super.excludePaths = const [],
    super.levelColors,
    super.levelEmojis,
  });

  @override
  String? formatStackTrace(StackTrace? stackTrace, int? methodCount) {
    final lines = stackTrace
        .toString()
        .split('\n')
        .where((line) => !line.contains('LogUtils'))
        .toList();
    return super.formatStackTrace(
      StackTrace.fromString(lines.join('\n')),
      methodCount,
    );
  }
}
