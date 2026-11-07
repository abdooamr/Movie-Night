import 'package:flutter/foundation.dart';

/// Single sink for non-fatal errors.
///
/// Debug builds print to the console. To forward release errors to a crash
/// reporter (e.g. Crashlytics once added as a dependency), set [onError].
class AppLog {
  AppLog._();

  static void Function(String context, Object error, StackTrace? stack)?
      onError;

  static void error(String context, Object error, [StackTrace? stack]) {
    debugPrint('[$context] $error');
    if (kDebugMode && stack != null) debugPrint(stack.toString());
    onError?.call(context, error, stack);
  }
}
