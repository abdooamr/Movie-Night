import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/data/auth_repository.dart';
import 'package:Movie_Night/src/pages/Login-Logout/auth_errors.dart';
import 'package:Movie_Night/src/pages/Login-Logout/set_new_password.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:Movie_Night/src/widgets/Navbar/Navbar.dart';

/// Root of the app: the shell, signed in or out, following Supabase's auth
/// state. A password-reset link (`passwordRecovery`) opens the Set New
/// Password screen on top.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late bool _signedIn = AuthRepository.instance.isSignedIn;
  StreamSubscription<AuthState>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = AuthRepository.instance.authStateChanges.listen(
      _onAuthState,
      // A reset or confirmation link that failed (expired, opened on another
      // device): say so instead of failing silently.
      onError: (Object e, StackTrace stack) {
        AppLog.error('authLink', e, stack);
        if (!mounted) return;
        AppFeedback.error(
          context,
          e is AuthException
              ? authErrorText(context, e)
              : S.of(context).authErrorGeneric,
        );
      },
    );
  }

  void _onAuthState(AuthState state) {
    if (!mounted) return;
    final signedIn = state.session != null;
    if (signedIn != _signedIn) setState(() => _signedIn = signedIn);
    if (state.event == AuthChangeEvent.passwordRecovery) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const SetNewPasswordPage()),
      );
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomBottomNavigationBar(isSignedIn: _signedIn),
    );
  }
}
