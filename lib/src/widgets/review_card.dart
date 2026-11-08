import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../components/cached_image.dart';
import '../components/feedback.dart';
import '../design/motion.dart';
import '../design/tokens.dart';

/// Plain data for one review row, shared by the inline list and the full page.
class ReviewCardData {
  const ReviewCardData({
    required this.author,
    required this.date,
    required this.body,
    this.avatarUrl,
    this.onDelete,
    this.id,
  });

  final String author;
  final String date;
  final String body;
  final String? avatarUrl;

  /// Stable identity, when the source has one.
  final String? id;

  /// Identity that survives list reordering, so per-card state follows it.
  Key get key => ValueKey(id ?? '$author|$date|${body.hashCode}');

  /// Present only for the signed-in user's own review.
  final VoidCallback? onDelete;
}

/// One review. The body is clamped to [maxLines] with a per-card
/// "Read more" shown only when the text really overflows.
class ReviewCard extends StatefulWidget {
  const ReviewCard({
    super.key,
    required this.author,
    required this.date,
    required this.body,
    this.avatarUrl,
    this.onDelete,
    this.confirmDelete,
  });

  ReviewCard.fromData(ReviewCardData data)
      : this(
          key: data.key,
          author: data.author,
          date: data.date,
          body: data.body,
          avatarUrl: data.avatarUrl,
          onDelete: data.onDelete,
        );

  static const int maxLines = 5;

  final String author;
  final String date;
  final String body;
  final String? avatarUrl;

  /// Called after the user confirms. A null value hides the delete button.
  final VoidCallback? onDelete;

  /// Overrides the destructive confirmation (used by tests).
  final Future<bool> Function(BuildContext context)? confirmDelete;

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _expanded = false;

  Future<void> _delete() async {
    final s = S.of(context);
    final custom = widget.confirmDelete;
    final bool confirmed;
    if (custom != null) {
      confirmed = await custom(context);
    } else {
      confirmed = await AppFeedback.confirmDestructive(
        context,
        title: s.deleteReviewTitle,
        message: s.deleteReviewMessage,
        confirmLabel: s.delete,
      );
    }
    if (confirmed) widget.onDelete?.call();
  }

  bool _overflows(BuildContext context, TextStyle? style, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(
        text: widget.body,
        style: DefaultTextStyle.of(context).style.merge(style),
      ),
      maxLines: ReviewCard.maxLines,
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout(maxWidth: maxWidth);
    final result = painter.didExceedMaxLines;
    painter.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final bodyStyle = theme.textTheme.bodyMedium;
    final url = widget.avatarUrl;

    return Card(
      margin: const EdgeInsetsDirectional.symmetric(vertical: MNSpace.xs),
      color: cs.surfaceContainer,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: MNRadius.mdAll),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(MNSpace.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: MNSize.minTap,
                    height: MNSize.minTap,
                    child: url == null || url.isEmpty
                        ? ColoredBox(
                            color: cs.surfaceContainerHighest,
                            child: Icon(
                              IconsaxOutline.user,
                              color: cs.onSurfaceVariant,
                            ),
                          )
                        : CachedImageCustom(
                            url,
                            width: MNSize.minTap,
                            height: MNSize.minTap,
                            isPerson: true,
                          ),
                  ),
                ),
                const SizedBox(width: MNSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.author,
                        style: theme.textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.date,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                if (widget.onDelete != null)
                  IconButton(
                    tooltip: S.of(context).deleteReviewTooltip,
                    onPressed: _delete,
                    icon: Icon(IconsaxOutline.trash, color: cs.error),
                  ),
              ],
            ),
            const SizedBox(height: MNSpace.md),
            LayoutBuilder(
              builder: (context, constraints) {
                final overflows =
                    _overflows(context, bodyStyle, constraints.maxWidth);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSize(
                      duration:
                          MNMotion.of(context).call(MNDuration.medium),
                      curve: MNCurves.standard,
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        widget.body,
                        style: bodyStyle,
                        maxLines: _expanded ? null : ReviewCard.maxLines,
                        overflow: _expanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                    ),
                    if (overflows && !_expanded)
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () => setState(() => _expanded = true),
                          child: Text(S.of(context).readmorelabel),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
