import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../../generated/l10n.dart';
import '../../Provider/register_provider.dart';
import '../../components/app_text_field.dart';
import '../../design/tokens.dart';
import '../../utils/app_logger.dart';
import 'Login.dart';
import 'auth_errors.dart';
import 'auth_form_parts.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _busy = false;
  String? _error;

  /// The address the confirmation link went to; non-null once sent.
  String? _confirmSentTo;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy) return;
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<UserProvider>();
    final email = _emailController.text.trim();
    setState(() {
      _busy = true;
      _error = null;
    });
    String? error;
    SignUpOutcome? outcome;
    try {
      outcome = await provider.createUser(
        email: email,
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );
    } on AuthException catch (e) {
      AppLog.error('register', e);
      if (!mounted) return;
      error = authErrorText(context, e);
    } catch (e, stack) {
      AppLog.error('register', e, stack);
      if (!mounted) return;
      error = S.of(context).authErrorGeneric;
    }
    if (!mounted) return;
    if (outcome == SignUpOutcome.signedIn) {
      closeSignInFlow(context);
      return;
    }
    setState(() {
      _busy = false;
      _error = error;
      if (outcome == SignUpOutcome.confirmEmail) _confirmSentTo = email;
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

    final confirmSentTo = _confirmSentTo;
    if (confirmSentTo != null) {
      // "Confirm email" is on: the account waits for the link.
      return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.all(MNSpace.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: MNSpace.xxl),
                ExcludeSemantics(
                  child: Icon(
                    IconsaxBold.sms_tracking,
                    size: MNSize.avatar,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: MNSpace.lg),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    s.confirmEmailSent(confirmSentTo),
                    textAlign: TextAlign.center,
                    style: text.bodyLarge,
                  ),
                ),
                const SizedBox(height: MNSpace.xl),
                FilledButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(builder: (_) => const Login()),
                  ),
                  child: Text(s.backToLogIn),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                child:
                    Text(s.createaccountlabel, style: text.headlineMedium),
              ),
              const SizedBox(height: MNSpace.xs),
              Text(s.pleasefillallfields, style: text.bodyLarge),
              const SizedBox(height: MNSpace.xl),
              AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _firstNameController,
                        label: s.firstnamelabel,
                        kind: AppFieldKind.name,
                        icon: IconsaxOutline.user,
                        action: TextInputAction.next,
                        validator: (v) =>
                            (v ?? '').trim().isEmpty ? s.enterFirstName : null,
                      ),
                      const SizedBox(height: MNSpace.lg),
                      AppTextField(
                        controller: _lastNameController,
                        label: s.lastnamelabel,
                        kind: AppFieldKind.name,
                        icon: IconsaxOutline.user,
                        autofillHints: const [AutofillHints.familyName],
                        action: TextInputAction.next,
                      ),
                      const SizedBox(height: MNSpace.lg),
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
                        onSubmitted: (_) => _submit(),
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
                label: s.createaccountlabel,
                busy: _busy,
                onPressed: _submit,
              ),
              const SizedBox(height: MNSpace.md),
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
                  Text(s.alreadyhaveanaccountlabel, style: text.bodyMedium),
                  TextButton(
                    onPressed: _busy
                        ? null
                        : () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (_) => const Login(),
                              ),
                            ),
                    child: Text(s.loginbuttonlabel),
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
