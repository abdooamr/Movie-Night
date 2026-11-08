import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../components/state_views.dart';
import '../design/tokens.dart';
import 'review_card.dart';

/// Builds the "all reviews" page from the live stream and what is loaded.
typedef AllReviewsBuilder = Widget Function(
  Stream<List<ReviewCardData>> stream,
  List<ReviewCardData> initialData,
);

/// Inline reviews section: a skeleton while loading, the first
/// [previewCount] reviews, then a "See All Reviews (n)" button.
class ReviewList extends StatefulWidget {
  const ReviewList({
    super.key,
    required this.seeAllBuilder,
    required this.streamFactory,
  });

  static const int previewCount = 3;

  final AllReviewsBuilder seeAllBuilder;
  final Stream<List<ReviewCardData>> Function() streamFactory;

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  late Stream<List<ReviewCardData>> _stream;

  @override
  void initState() {
    super.initState();
    _stream = widget.streamFactory();
  }

  void _retry() => setState(() => _stream = widget.streamFactory());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ReviewCardData>>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              vertical: MNSpace.sm,
            ),
            child: ErrorState(
              compact: true,
              message: S.of(context).genericError,
              onRetry: _retry,
            ),
          );
        }
        final data = snapshot.data;
        if (data == null) return const _ReviewsSkeleton();
        if (data.isEmpty) {
          return Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              vertical: MNSpace.xl,
            ),
            child: Center(
              child: Text(
                S.of(context).noReviews,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          );
        }
        final preview = data.take(ReviewList.previewCount).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final r in preview) ReviewCard.fromData(r),
            if (data.length > preview.length)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => widget.seeAllBuilder(_stream, data),
                    ),
                  ),
                  child: Text(S.of(context).seeAllReviews(data.length)),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Static placeholder cards (no shimmer, so it is Reduce-Motion safe).
class _ReviewsSkeleton extends StatelessWidget {
  const _ReviewsSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: Column(
        children: [
          for (var i = 0; i < ReviewList.previewCount; i++)
            Container(
              height: MNSize.avatar + MNSpace.xl,
              margin: const EdgeInsetsDirectional.symmetric(
                vertical: MNSpace.xs,
              ),
              decoration: BoxDecoration(
                color: cs.surfaceContainer,
                borderRadius: MNRadius.mdAll,
              ),
            ),
        ],
      ),
    );
  }
}
