import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/pages/Login-Logout/auth_errors.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:Movie_Night/src/widgets/customsettingscreen.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Account > Reset Password: emails the signed-in user a reset link and
/// reports the real result.
class ResetPasswordRow extends StatefulWidget {
  const ResetPasswordRow({super.key});

  @override
  State<ResetPasswordRow> createState() => _ResetPasswordRowState();
}

class _ResetPasswordRowState extends State<ResetPasswordRow> {
  bool _busy = false;

  Future<void> _send() async {
    final s = S.of(context);
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null || email.isEmpty) {
      AppFeedback.error(context, s.changepassworderror);
      return;
    }
    setState(() => _busy = true);
    String? error;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e, st) {
      AppLog.error('sendPasswordResetEmail', e, st);
      error = mounted ? authErrorText(context, e) : s.changepassworderror;
    } catch (e, st) {
      AppLog.error('sendPasswordResetEmail', e, st);
      error = s.changepassworderror;
    }
    if (!mounted) return;
    setState(() => _busy = false);
    if (error != null) {
      AppFeedback.error(context, error);
    } else {
      AppFeedback.info(context, s.changepasswordsuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SettingsRow(
      icon: IconsaxOutline.key,
      title: s.resetPassword,
      subtitle: s.resetPasswordSubtitle,
      busy: _busy,
      onTap: _send,
    );
  }
}
