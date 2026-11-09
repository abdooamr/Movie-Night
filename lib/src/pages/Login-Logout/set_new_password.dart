import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../../generated/l10n.dart';
import '../../components/app_text_field.dart';
import '../../components/feedback.dart';
import '../../data/auth_repository.dart';
import '../../design/tokens.dart';
import '../../utils/app_logger.dart';
import 'auth_errors.dart';
import 'auth_form_parts.dart';

/// Opened by the password-reset email link (Supabase's `passwordRecovery`
/// event): the user is signed in for recovery and picks a new password.
class SetNewPasswordPage extends StatefulWidget {
  const SetNewPasswordPage({super.key});

  @override
  State<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy) return;
    if (!_formKey.currentState!.validate()) return;
    final s = S.of(context);
    setState(() {
      _busy = true;
      _error = null;
    });
    String? error;
    try {
      await AuthRepository.instance.updatePassword(_passwordController.text);
    } on AuthException catch (e) {
      AppLog.error('updatePassword', e);
      error = mounted ? authErrorText(context, e) : s.authErrorGeneric;
    } catch (e, stack) {
      AppLog.error('updatePassword', e, stack);
      error = s.authErrorGeneric;
    }
    if (!mounted) return;
    if (error == null) {
      final navigator = Navigator.of(context);
      AppFeedback.info(context, s.passwordUpdated);
      navigator.pop();
      return;
    }
    setState(() {
      _busy = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(MNSpace.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(s.setNewPasswordTitle, style: text.headlineMedium),
              ),
              const SizedBox(height: MNSpace.xs),
              Text(s.setNewPasswordSubtitle, style: text.bodyLarge),
              const SizedBox(height: MNSpace.xl),
              AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _passwordController,
                        label: s.newPasswordLabel,
                        kind: AppFieldKind.newPassword,
                        icon: IconsaxOutline.lock,
                        action: TextInputAction.next,
                        validator: (v) => strongPasswordPattern.hasMatch(v ?? '')
                            ? null
                            : s.passwordvalidationtext,
                      ),
                      const SizedBox(height: MNSpace.lg),
                      AppTextField(
                        controller: _confirmController,
                        label: s.passwordconfirmlabel,
                        kind: AppFieldKind.newPassword,
                        icon: IconsaxOutline.lock,
                        action: TextInputAction.done,
                        onSubmitted: (_) => _save(),
                        validator: (v) => v == _passwordController.text
                            ? null
                            : s.passwordsDontMatch,
                      ),
                    ],
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: MNSpace.md),
                AuthErrorText(_error!),
              ],
              const SizedBox(height: MNSpace.lg),
              AuthSubmitButton(
                label: s.savePasswordLabel,
                busy: _busy,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
