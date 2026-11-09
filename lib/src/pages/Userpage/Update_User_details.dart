import 'dart:async';

import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/allproviders.dart';
import 'package:Movie_Night/src/components/app_text_field.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/data/auth_repository.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/pages/Userpage/profilepic.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Edit Profile: picture and first/last name (reviews show them). Saves with an
/// awaited result and closes only on success.
class User_update_info_page extends StatefulWidget {
  const User_update_info_page({super.key});

  @override
  State<User_update_info_page> createState() => _User_update_info_pageState();
}

class _User_update_info_pageState extends State<User_update_info_page> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  /// Fills the fields with the current values so Save never blanks them.
  Future<void> _prefill() async {
    final uid = AuthRepository.instance.currentUserId;
    if (uid == null) return;
    try {
      final data = await context
          .read<UserData>()
          .getUserDataStream(uid)
          .first
          .timeout(const Duration(seconds: 10));
      if (!mounted || data == null) return;
      if (_firstNameController.text.isEmpty) {
        _firstNameController.text = data.firstName;
      }
      if (_lastNameController.text.isEmpty) {
        _lastNameController.text = data.lastName;
      }
    } catch (e, st) {
      AppLog.error('prefillProfile', e, st);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !(_formKey.currentState?.validate() ?? false)) return;
    final s = S.of(context);
    if (!AuthRepository.instance.isSignedIn) {
      AppFeedback.error(context, s.genericError);
      return;
    }
    setState(() => _saving = true);
    String? error;
    try {
      await context.read<UserData>().updateuser(
            _firstNameController.text.trim(),
            _lastNameController.text.trim(),
          );
    } catch (e, st) {
      AppLog.error('updateProfile', e, st);
      error = s.genericError;
    }
    if (!mounted) return;
    setState(() => _saving = false);
    if (error != null) {
      AppFeedback.error(context, error);
      return;
    }
    // Show on the screen we return to.
    final navigator = Navigator.of(context);
    AppFeedback.info(context, s.updateprofilesuccess);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    const gap = SizedBox(height: MNSpace.lg);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Semantics(header: true, child: Text(s.editprofilelabel)),
          ),
          SliverPadding(
            padding: const EdgeInsetsDirectional.all(MNSpace.lg),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: ProfilePic()),
                      const SizedBox(height: MNSpace.xl),
                      AppTextField(
                        controller: _firstNameController,
                        label: s.firstnamelabel,
                        kind: AppFieldKind.name,
                        icon: IconsaxOutline.user,
                        action: TextInputAction.next,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? s.enterFirstName
                            : null,
                      ),
                      gap,
                      AppTextField(
                        controller: _lastNameController,
                        label: s.lastnamelabel,
                        kind: AppFieldKind.name,
                        icon: IconsaxOutline.user,
                        autofillHints: const [AutofillHints.familyName],
                        action: TextInputAction.done,
                        onSubmitted: (_) => _save(),
                      ),
                      const SizedBox(height: MNSpace.xl),
                      FilledButton(
                        onPressed: _saving ? null : _save,
                        child: _saving
                            ? SizedBox.square(
                                dimension: MNSpace.xl,
                                child: CircularProgressIndicator(
                                  strokeWidth: MNSpace.xxs,
                                  semanticsLabel: s.savelabel,
                                ),
                              )
                            : Text(s.savelabel),
                      ),
                    ],
                  ),
                ),
              ),
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
