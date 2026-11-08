import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../Provider/register_provider.dart';
import '../../design/tokens.dart';

/// Closes the whole sign-in flow (Welcome, Log In / Create Account and any
/// page above them) in one go.
///
/// Deliberately not `dismissSignIn()`: when the sheet is not the current
/// route (the log-in pages sit above it) that only removes the sheet and
/// leaves Login/Register on the stack, so the user would still see the form
/// after being signed in.
void closeSignInFlow(BuildContext context) =>
    Navigator.of(context, rootNavigator: true).popUntil((r) => r.isFirst);

/// Outcome of [runGoogleSignIn].
typedef GoogleSignInOutcome = ({bool signedIn, String? error});

/// Runs Google sign-in. On success closes the flow. A dismissed account
/// picker is silent; a real failure returns a localized [error].
/// The caller owns the busy state and must check `mounted` afterwards.
Future<GoogleSignInOutcome> runGoogleSignIn(BuildContext context) async {
  final provider = context.read<UserProvider>();
  final failed = S.of(context).authErrorGeneric;
  final result = await provider.signInWithGoogle();
  if (!context.mounted) return (signedIn: false, error: null);
  switch (result) {
    case GoogleSignInResult.success:
      closeSignInFlow(context);
      return (signedIn: true, error: null);
    case GoogleSignInResult.cancelled:
      return (signedIn: false, error: null);
    case GoogleSignInResult.failed:
      return (signedIn: false, error: failed);
  }
}

/// Inline form error, announced to screen readers.
class AuthErrorText extends StatelessWidget {
  const AuthErrorText(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}

/// Primary submit button that swaps its label for a spinner while [busy].
class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    super.key,
    required this.label,
    required this.busy,
    required this.onPressed,
  });

  final String label;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: busy ? null : onPressed,
      child: busy
          ? const SizedBox(
              width: MNSpace.xl - MNSpace.xs,
              height: MNSpace.xl - MNSpace.xs,
              child: CircularProgressIndicator.adaptive(),
            )
          : Text(label),
    );
  }
}
