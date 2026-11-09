import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../generated/l10n.dart';
import '../../design/motion.dart';
import '../../design/tokens.dart';
import '../../widgets/changelangwidget.dart';
import 'Login.dart';
import 'Register.dart';

/// Brand name; not translatable.
const String _brandName = 'Movie Night';

/// First screen of the sign-in flow. Presented modally by `presentSignIn`,
/// which adds the Close button at the top end, and shown inline as the
/// signed-out Profile tab ([inSheet] false, no Close button).
class LoginWelcomeScreen extends StatelessWidget {
  const LoginWelcomeScreen({super.key, this.inSheet = true, this.title});

  /// Whether a Close button is overlaid at the top end.
  final bool inSheet;

  /// App bar title, announced as the page heading (the tab name when shown
  /// inline). The sheet has none.
  final String? title;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final text = Theme.of(context).textTheme;
    // The looping Lottie is decorative: off under Reduce Motion and in low
    // power.
    final allowMotion = MNMotion.of(context).allowRichMotion;

    return Scaffold(
      appBar: AppBar(
        // As a sheet, the Close button comes from presentSignIn; inline, the
        // tab is a root. Either way the app bar adds no button of its own.
        automaticallyImplyLeading: false,
        title: title == null
            ? null
            : Semantics(header: true, child: Text(title!)),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const Change_language_widget(),
              ),
            ),
            icon: const Icon(IconsaxOutline.global),
            label: Text(s.changelanguagelabel),
          ),
          // Keeps clear of the Close button overlaid at the top end.
          if (inSheet) const SizedBox(width: MNSize.minTap),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: MNSpace.xl,
                  vertical: MNSpace.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    ExcludeSemantics(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 220),
                        child: Lottie.asset(
                          'images/watchmovie.json',
                          animate: allowMotion,
                          repeat: allowMotion,
                        ),
                      ),
                    ),
                    const SizedBox(height: MNSpace.xl),
                    Semantics(
                      header: true,
                      child: Text(
                        _brandName,
                        textAlign: TextAlign.center,
                        style: text.displaySmall,
                      ),
                    ),
                    const SizedBox(height: MNSpace.sm),
                    Text(
                      s.signInPromptBody,
                      textAlign: TextAlign.center,
                      style: text.bodyLarge,
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => const Login()),
                      ),
                      child: Text(s.loginbuttonlabel),
                    ),
                    const SizedBox(height: MNSpace.md),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => const Register()),
                      ),
                      child: Text(s.createaccountlabel),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
