import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';

/// Forces the Google Play immediate-update flow when a newer build is
/// published. Android only, and best-effort: any failure (sideloaded build,
/// emulator without Play Services, debug run) is swallowed so it can never
/// block app start.
///
/// Call after the first frame — it needs a live Activity.
Future<void> checkForForcedUpdate() async {
  if (kIsWeb || !Platform.isAndroid) return;
  try {
    final info = await InAppUpdate.checkForUpdate();
    if (info.updateAvailability == UpdateAvailability.updateAvailable &&
        info.immediateUpdateAllowed) {
      // Full-screen, non-dismissible.
      await InAppUpdate.performImmediateUpdate();
    }
  } catch (e) {
    debugPrint('In-app update check skipped: $e');
  }
}
