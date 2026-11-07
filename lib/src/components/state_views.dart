import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../design/tokens.dart';

/// Load failure with a "Try Again" action. [compact] is the one-line in-rail
/// version with a text button.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.compact = false,
  });

  final String message;
  final VoidCallback onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final retry = S.of(context).tryAgain;
    if (compact) {
      return Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: MNSpace.lg),
        child: Row(
          children: [
            Icon(IconsaxOutline.danger, color: cs.onSurfaceVariant),
            const SizedBox(width: MNSpace.sm),
            Expanded(
              child: Text(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: cs.onSurfaceVariant),
              ),
            ),
            TextButton(onPressed: onRetry, child: Text(retry)),
          ],
        ),
      );
    }
    return _StateLayout(
      icon: IconsaxOutline.danger,
      body: message,
      action: FilledButton.tonal(onPressed: onRetry, child: Text(retry)),
    );
  }
}

/// Nothing to show yet: icon, title, optional body and filled action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return _StateLayout(
      icon: icon,
      title: title,
      body: body,
      action: actionLabel != null && onAction != null
          ? FilledButton(onPressed: onAction, child: Text(actionLabel!))
          : null,
    );
  }
}

class _StateLayout extends StatelessWidget {
  const _StateLayout({
    required this.icon,
    this.title,
    this.body,
    this.action,
  });

  final IconData icon;
  final String? title;
  final String? body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(MNSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: MNSpace.xxxl, color: cs.onSurfaceVariant),
            const SizedBox(height: MNSpace.lg),
            if (title != null)
              Semantics(
                header: true,
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
              ),
            if (title != null && body != null)
              const SizedBox(height: MNSpace.sm),
            if (body != null)
              Text(
                body!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: cs.onSurfaceVariant),
              ),
            if (action != null) ...[
              const SizedBox(height: MNSpace.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
