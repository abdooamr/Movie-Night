import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/pages/Login-Logout/Login.dart';
import 'package:Movie_Night/src/pages/Login-Logout/Register.dart';
import 'package:Movie_Night/src/pages/Userpage/account_setting.dart';
import 'package:Movie_Night/src/pages/Userpage/rate_app_row.dart';
import 'package:Movie_Night/src/widgets/customsettingscreen.dart';
import 'package:Movie_Night/src/widgets/themechanger.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

/// The Profile tab while signed out: the same settings page as signed in,
/// with a log-in card where the account header would be. Appearance,
/// language and rating work without an account.
class SignedOutProfile extends StatelessWidget {
  const SignedOutProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    const gap = SizedBox(height: MNSpace.xl);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Semantics(header: true, child: Text(s.profilenavbar)),
          ),
          SliverPadding(
            padding:
                const EdgeInsetsDirectional.symmetric(horizontal: MNSpace.lg),
            sliver: SliverList.list(
              children: [
                const _LogInCard(),
                gap,
                const AppearanceSetting(),
                gap,
                SettingsSection(
                  title: s.generalsettingslabel,
                  children: const [
                    LanguageSettingsRow(),
                    RateAppRow(),
                  ],
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.paddingOf(context).bottom + MNSpace.xl,
            ),
          ),
        ],
      ),
    );
  }
}

/// What an account adds, and the two ways in. Log In and Create Account
/// open inside the tab; the shell swaps in the profile once signed in.
class _LogInCard extends StatelessWidget {
  const _LogInCard();

  void _push(BuildContext context, Widget page) => Navigator.of(context)
      .push(MaterialPageRoute<void>(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: MNRadius.lgAll,
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(MNSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ExcludeSemantics(
                  child: SizedBox.square(
                    dimension: MNSize.avatar - MNSpace.lg,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        IconsaxBold.user,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: MNSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.profileSignInTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: MNSpace.xxs),
                      Text(
                        s.profileSignInBody,
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: MNSpace.lg),
            FilledButton(
              onPressed: () => _push(context, const Login()),
              child: Text(s.loginbuttonlabel),
            ),
            const SizedBox(height: MNSpace.sm),
            OutlinedButton(
              onPressed: () => _push(context, const Register()),
              child: Text(s.createaccountlabel),
            ),
          ],
        ),
      ),
    );
  }
}
