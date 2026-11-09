// ignore_for_file: must_be_immutable

import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/data/user_repository.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:ficonsax/ficonsax.dart';

class Report_screen extends StatefulWidget {
  Report_screen({
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
  String? report;

  @override
  State<Report_screen> createState() => _Report_screenState();
}

class _Report_screenState extends State<Report_screen> {
  bool _busy = false;

  /// Clears the report through `admin_clear_report` and shows the result.
  Future<void> remove_report() async {
    final id = widget.id;
    if (id == null || _busy) return;
    final failMsg = S.of(context).genericError;
    setState(() => _busy = true);
    try {
      await UserRepository.instance.adminClearReport(id);
      if (!mounted) return;
      setState(() => widget.report = '');
    } catch (e, st) {
      AppLog.error('adminClearReport', e, st);
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
    final hasReport = widget.report != null && widget.report != "";
    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportPage)),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(
            horizontal: MNSpace.lg, vertical: MNSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Semantics(
              header: true,
              child:
                  Text(l10n.userProfile, style: theme.textTheme.headlineMedium),
            ),
            const SizedBox(height: MNSpace.xl),
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
            const SizedBox(height: MNSpace.xxl),
            Text(
                "${l10n.name}: ${widget.firstname ?? ''} ${widget.lastname ?? ''}",
                style: theme.textTheme.bodyLarge),
            const SizedBox(height: MNSpace.lg),
            Text("${l10n.email}: ${widget.email ?? ''}",
                style: theme.textTheme.bodyLarge),
            const SizedBox(height: MNSpace.lg),
            if (!hasReport)
              Text("${l10n.report}: ${l10n.noReport}",
                  style: theme.textTheme.bodyLarge)
            else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsetsDirectional.all(MNSpace.lg),
                decoration: BoxDecoration(
                  color: cs.errorContainer,
                  borderRadius: MNRadius.mdAll,
                ),
                child: Text(
                  "${l10n.report}: ${widget.report}",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: cs.onErrorContainer),
                ),
              ),
              const SizedBox(height: MNSpace.lg),
              FilledButton(
                onPressed: _busy ? null : remove_report,
                child: Text(l10n.clearReport),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
