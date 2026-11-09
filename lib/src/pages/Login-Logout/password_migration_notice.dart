import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../generated/l10n.dart';
import 'Forget_password.dart';

/// One-time explanation shown after a failed email log-in: accounts moved
/// from Firebase to Supabase, and old passwords did not move with them.
class PasswordMigrationNotice {
  const PasswordMigrationNotice._();

  static const String prefsKey = 'passwordMigrationNoticeShown';

  /// True the first time only, and records that it was shown. If storage is
  /// unavailable the notice is skipped rather than repeated.
  static Future<bool> claim() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(prefsKey) ?? false) return false;
      await prefs.setBool(prefsKey, true);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Shows the notice; "Reset Password" opens the reset screen for [email].
  static Future<void> show(BuildContext context, {String? email}) {
    final s = S.of(context);
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(s.passwordMigrationTitle),
        content: Text(s.passwordMigrationBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(s.notNowLabel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ForgetNew(initialEmail: email),
                ),
              );
            },
            child: Text(s.resetPassword),
          ),
        ],
      ),
    );
  }
}
