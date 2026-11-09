// ignore_for_file: must_be_immutable
import 'package:Movie_Night/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:ficonsax/ficonsax.dart';

class AddAdmin extends StatefulWidget {
  AddAdmin({
    super.key,
    this.id,
    this.email,
    this.firstname,
    this.lastname,
    this.profilepic,
    this.report,
    this.role,
  });
  final String? id;
  final String? email;
  final String? firstname;
  final String? profilepic;
  final String? lastname;
  String? role;
  final String? report;

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  bool _busy = false;

  /// Promotes the user through `admin_make_admin` and shows the result.
  Future<void> addAdmin() async {
    final id = widget.id;
    if (id == null || _busy) return;
    final failMsg = S.of(context).genericError;
    setState(() => _busy = true);
    try {
      await UserRepository.instance.adminMakeAdmin(id);
      if (!mounted) return;
      setState(() => widget.role = 'admin');
    } catch (e, st) {
      AppLog.error('adminMakeAdmin', e, st);
      if (mounted) AppFeedback.error(context, failMsg);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.userProfile)),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(
            horizontal: MNSpace.lg, vertical: MNSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: (widget.profilepic ?? '').isEmpty
                  ? SizedBox.square(
                      dimension: MNSize.avatar,
                      child: Icon(IconsaxOutline.user,
                          size: MNSize.avatar / 2,
                          color: cs.onSurfaceVariant),
                    )
                  : CachedImageCustom(
                      (widget.profilepic ?? ''),
                      width: MNSize.avatar,
                      height: MNSize.avatar,
                      isPerson: true,
                    ),
            ),
            const SizedBox(height: MNSpace.xl),
            Text(
              "${l10n.name}: ${widget.firstname ?? ''} ${widget.lastname ?? ''}",
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: MNSpace.sm),
            Text("${l10n.email}: ${widget.email ?? ''}",
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: MNSpace.sm),
            Text("${l10n.role}: ${widget.role ?? ''}",
                style: theme.textTheme.bodyMedium),
            const SizedBox(height: MNSpace.xl),
            if (widget.role != "admin")
              FilledButton(
                onPressed: _busy ? null : addAdmin,
                child: Text(l10n.addAdmin),
              ),
          ],
        ),
      ),
    );
  }
}
