import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import 'state_views.dart';

/// Shown in place of signed-in-only content. Callers pass
/// `() => presentSignIn(context)` as [onLogIn].
class SignInPrompt extends StatelessWidget {
  const SignInPrompt({super.key, required this.onLogIn, this.title, this.body});

  final VoidCallback onLogIn;
  final String? title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return EmptyState(
      icon: IconsaxOutline.user,
      title: title ?? s.signInPromptTitle,
      body: body ?? s.signInPromptBody,
      actionLabel: s.loginbuttonlabel,
      onAction: onLogIn,
    );
  }
}
