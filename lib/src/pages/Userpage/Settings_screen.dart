import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/data/auth_repository.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/pages/Adminpages/admin_panel_vd.dart';
import 'package:Movie_Night/src/pages/Userpage/SendReports.dart';
import 'package:Movie_Night/src/pages/Userpage/User_info_page.dart';
import 'package:Movie_Night/src/pages/Userpage/account_setting.dart';
import 'package:Movie_Night/src/pages/Userpage/changepassword.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:Movie_Night/src/widgets/customsettingscreen.dart';
import 'package:Movie_Night/src/widgets/themechanger.dart';
import 'package:Movie_Night/src/widgets/userinfotile.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

/// The Profile tab (signed in): user tile, Appearance, General, Account and
/// the spaced-apart Delete Account row.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserRepository _users = UserRepository.instance;
  final InAppReview _inAppReview = InAppReview.instance;
  bool _isAdmin = false;
  bool _signingOut = false;

  @override
  void initState() {
    super.initState();
    _checkIsAdmin();
  }

  Future<void> _checkIsAdmin() async {
    if (!AuthRepository.instance.isSignedIn) return;
    bool admin;
    try {
      admin = await _users.isAdmin();
    } catch (_) {
      admin = false;
    }
    if (mounted) setState(() => _isAdmin = admin);
  }

  Future<void> _openStoreReview() async {
    final failMsg = S.of(context).genericError;
    try {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
      }
      // In-app review may show nothing (quota, emulator): open the store too.
      await _inAppReview.openStoreListing();
    } catch (e, st) {
      AppLog.error('openStoreListing', e, st);
      if (mounted) AppFeedback.error(context, failMsg);
    }
  }

  Future<void> _logOut() async {
    final failMsg = S.of(context).genericError;
    setState(() => _signingOut = true);
    try {
      // The shell swaps this tab to the sign-in prompt via the auth stream.
      await AuthRepository.instance.signOut();
    } catch (e, st) {
      AppLog.error('signOut', e, st);
      if (mounted) {
        setState(() => _signingOut = false);
        AppFeedback.error(context, failMsg);
      }
    }
  }

  /// Confirm, block, then one server call (`delete_my_account`) deletes the
  /// login, profile, reviews and watchlist together; then sign out.
  Future<void> _deleteAccount() async {
    final s = S.of(context);
    final confirmed = await AppFeedback.confirmDestructive(
      context,
      title: s.deleteAccountTitle,
      message: s.deleteAccountMessage,
      confirmLabel: s.deleteaccountlabel,
    );
    if (!confirmed || !mounted) return;
    if (!AuthRepository.instance.isSignedIn) return;

    // This screen is replaced (and unmounted) as soon as the auth user is
    // gone, so keep the root navigator for the dialog and the feedback.
    final rootNav = Navigator.of(context, rootNavigator: true);
    showDialog<void>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );

    String? error;
    try {
      // One server call deletes the login, profile, reviews and watchlist
      // together, so a failure never leaves half an account behind.
      await _users.deleteMyAccount();
    } catch (e, st) {
      AppLog.error('deleteAccount', e, st);
      error = s.genericError;
    }
    if (error == null) {
      // The account is gone; drop the local session (the shell then shows
      // the signed-out tabs).
      try {
        await AuthRepository.instance.signOut();
      } catch (e, st) {
        AppLog.error('signOutAfterDelete', e, st);
      }
    }

    rootNav.pop();
    final feedbackContext = mounted ? context : rootNav.context;
    if (!feedbackContext.mounted) return;
    if (error != null) {
      AppFeedback.error(feedbackContext, error);
    } else {
      AppFeedback.info(feedbackContext, s.deleteAccountDone);
    }
  }

  void _push(Widget page) => Navigator.of(context)
      .push(MaterialPageRoute<void>(builder: (_) => page));

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
                const userinfotile(),
                gap,
                const AppearanceSetting(),
                gap,
                SettingsSection(
                  title: s.generalsettingslabel,
                  children: [
                    const LanguageSettingsRow(),
                    SettingsRow(
                      icon: IconsaxOutline.message_question,
                      title: s.reportabuglabel,
                      opensScreen: true,
                      onTap: () => _push(const SendReport()),
                    ),
                    SettingsRow(
                      icon: IconsaxOutline.star,
                      title: s.rateMovieNight,
                      onTap: _openStoreReview,
                    ),
                  ],
                ),
                gap,
                SettingsSection(
                  title: s.accountGroupLabel,
                  children: [
                    const EditProfileRow(),
                    const ResetPasswordRow(),
                    SettingsRow(
                      icon: IconsaxOutline.logout,
                      title: s.logoutlabel,
                      busy: _signingOut,
                      onTap: _logOut,
                    ),
                  ],
                ),
                if (_isAdmin) ...[
                  gap,
                  SettingsSection(
                    title: s.adminsettingslabel,
                    children: [
                      SettingsRow(
                        icon: IconsaxOutline.security_user,
                        title: s.adminpanellabel,
                        opensScreen: true,
                        onTap: () => _push(adminpanel()),
                      ),
                    ],
                  ),
                ],
                // Danger zone, spaced apart from everything else.
                const SizedBox(height: MNSpace.xxxl),
                SettingsSection(
                  children: [
                    SettingsRow(
                      icon: IconsaxOutline.trash,
                      title: s.deleteaccountlabel,
                      destructive: true,
                      onTap: _deleteAccount,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Clears the floating iOS tab bar (and the safe area).
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
