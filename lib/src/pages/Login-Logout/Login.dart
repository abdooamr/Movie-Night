import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';

import '../../../generated/l10n.dart';
import '../../components/app_text_field.dart';
import '../../design/tokens.dart';
import '../../utils/app_logger.dart';
import 'Forget_password.dart';
import 'Register.dart';
import 'auth_errors.dart';
import 'auth_form_parts.dart';

/// Loose "something@something.tld" check; Firebase has the final say.
final RegExp authEmailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    String? error;
    var ok = false;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      ok = true;
    } on FirebaseAuthException catch (e) {
      AppLog.error('logIn', e);
      if (!mounted) return;
      // Don't reveal whether an account exists for this email.
      error = authErrorText(context, e, hideAccountExistence: true);
    } catch (e, stack) {
      AppLog.error('logIn', e, stack);
      if (!mounted) return;
      error = S.of(context).authErrorGeneric;
    }
    if (!mounted) return;
    if (ok) {
      closeSignInFlow(context);
      return;
    }
    setState(() {
      _busy = false;
      _error = error;
    });
  }

  Future<void> _google() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final outcome = await runGoogleSignIn(context);
    if (!mounted || outcome.signedIn) return;
    setState(() {
      _busy = false;
      _error = outcome.error;
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
                child: Text(s.loginbuttonlabel, style: text.headlineMedium),
              ),
              const SizedBox(height: MNSpace.xs),
              Text(s.logintocontinue, style: text.bodyLarge),
              const SizedBox(height: MNSpace.xl),
              AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _emailController,
                        label: s.emailaddresslabel,
                        kind: AppFieldKind.email,
                        icon: IconsaxOutline.sms,
                        action: TextInputAction.next,
                        validator: (v) =>
                            authEmailPattern.hasMatch((v ?? '').trim())
                                ? null
                                : s.enterValidEmail,
                      ),
                      const SizedBox(height: MNSpace.lg),
                      AppTextField(
                        controller: _passwordController,
                        label: s.passwordlabel,
                        kind: AppFieldKind.password,
                        icon: IconsaxOutline.lock,
                        action: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        validator: (v) => (v ?? '').trim().isEmpty
                            ? s.enterPassword
                            : null,
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
                label: s.loginbuttonlabel,
                busy: _busy,
                onPressed: _submit,
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: TextButton(
                  onPressed: _busy
                      ? null
                      : () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const ForgetNew(),
                            ),
                          ),
                  child: Text(s.forgotpasswordlabel),
                ),
              ),
              const SizedBox(height: MNSpace.sm),
              OutlinedButton.icon(
                onPressed: _busy ? null : _google,
                icon: const Icon(SimpleIcons.google),
                label: Text(s.continueWithGoogle),
              ),
              const SizedBox(height: MNSpace.lg),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(s.notamemberlabel, style: text.bodyMedium),
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (_) => const Register(),
                              ),
                            ),
                    child: Text(s.createaccountlabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
