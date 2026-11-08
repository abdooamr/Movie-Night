import 'package:Movie_Night/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:ficonsax/ficonsax.dart';

class Fulldetail extends StatelessWidget {
  final String? id;
  final String? email;
  final String? firstname;
  final String? profilepic;
  final String? lastname;
  final String? role;
  final String? report;
  const Fulldetail({
    super.key,
    this.id,
    this.email,
    this.firstname,
    this.lastname,
    this.profilepic,
    this.report,
    this.role,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.fullUserProfile)),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(
            horizontal: MNSpace.lg, vertical: MNSpace.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Semantics(
              header: true,
              child: Text(l10n.fullUserProfile,
                  style: theme.textTheme.headlineMedium),
            ),
            const SizedBox(height: MNSpace.xl),
            ClipOval(
              child: (profilepic ?? '').isEmpty
                  ? SizedBox.square(
                      dimension: MNSize.avatar,
                      child: Icon(IconsaxOutline.user,
                          size: MNSize.avatar / 2,
                          color: cs.onSurfaceVariant),
                    )
                  : CachedImageCustom(
                      (profilepic ?? ''),
                      width: MNSize.avatar,
                      height: MNSize.avatar,
                      isPerson: true,
                    ),
            ),
            const SizedBox(height: MNSpace.xxl),
            Text("${l10n.name}: ${firstname ?? ''} ${lastname ?? ''}",
                style: theme.textTheme.bodyLarge),
            const SizedBox(height: MNSpace.lg),
            Text("${l10n.email}: ${email ?? ''}",
                style: theme.textTheme.bodyLarge),
            const SizedBox(height: MNSpace.lg),
            Text("${l10n.role}: ${role ?? ''}",
                style: theme.textTheme.bodyLarge),
            const SizedBox(height: MNSpace.lg),
            Text("${l10n.id}: ${id ?? ''}", style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
