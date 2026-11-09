import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../../generated/l10n.dart';
import '../../components/app_text_field.dart';
import '../../data/auth_repository.dart';
import '../../design/tokens.dart';
import '../../utils/app_logger.dart';
import 'Login.dart' show authEmailPattern;
import 'auth_errors.dart';
import 'auth_form_parts.dart';

class ForgetNew extends StatefulWidget {
  const ForgetNew({super.key, this.initialEmail});

  /// Pre-fills the email field (e.g. from a failed log-in).
  final String? initialEmail;

  @override
  _ForgetNewState createState() => _ForgetNewState();
}

class _ForgetNewState extends State<ForgetNew> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController =
      TextEditingController(text: widget.initialEmail);
  bool _busy = false;
  String? _error;

  /// The address the reset link went to; non-null once sent.
  String? _sentTo;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_busy) return;
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    setState(() {
      _busy = true;
      _error = null;
    });
    String? error;
    var ok = false;
    try {
      await AuthRepository.instance.sendPasswordReset(email);
      ok = true;
    } on AuthException catch (e) {
      AppLog.error('passwordReset', e);
      if (!mounted) return;
      if (e.code == 'user_not_found') {
        // Show the same success state, so this form can't be used to find
        // out which emails have an account.
        ok = true;
      } else {
        error = authErrorText(context, e);
      }
    } catch (e, stack) {
      AppLog.error('passwordReset', e, stack);
      if (!mounted) return;
      error = S.of(context).authErrorGeneric;
    }
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (ok) {
        _sentTo = email;
      } else {
        _error = error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final sentTo = _sentTo;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(MNSpace.xl),
          child: sentTo != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: MNSpace.xxl),
                    ExcludeSemantics(
                      child: Icon(
                        IconsaxBold.tick_circle,
                        size: MNSize.avatar,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(height: MNSpace.lg),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        s.resetLinkSent(sentTo),
                        textAlign: TextAlign.center,
                        style: text.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: MNSpace.xl),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(s.backToLogIn),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(s.resetPassword, style: text.headlineMedium),
                    ),
                    const SizedBox(height: MNSpace.xs),
                    Text(s.resetPasswordSubtitle, style: text.bodyLarge),
                    const SizedBox(height: MNSpace.xl),
                    Form(
                      key: _formKey,
                      child: AppTextField(
                        controller: _emailController,
                        label: s.emailaddresslabel,
                        kind: AppFieldKind.email,
                        icon: IconsaxOutline.sms,
                        action: TextInputAction.done,
                        onSubmitted: (_) => _send(),
                        validator: (v) =>
                            authEmailPattern.hasMatch((v ?? '').trim())
                                ? null
                                : s.enterValidEmail,
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: MNSpace.md),
                      AuthErrorText(_error!),
                    ],
                    const SizedBox(height: MNSpace.lg),
                    AuthSubmitButton(
                      label: s.sendEmail,
                      busy: _busy,
                      onPressed: _send,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
