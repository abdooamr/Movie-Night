import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../components/poster_card.dart';
import '../components/state_views.dart';
import '../design/tokens.dart';
import '../models/movie_model.dart';
import '../navigation/routes.dart';
import '../utils/poster_size.dart';
import '../utils/utils.dart';
import 'package:ficonsax/ficonsax.dart';
import 'shimmerWidgets/genreListViewShimmerWidget.dart';

/// Space the end of a scroll view needs so its last row clears the floating
/// tab bar.
double tabBarClearance(BuildContext context) =>
    MNSize.minTap + MNSpace.lg * 2 + MediaQuery.paddingOf(context).bottom;

/// Grid delegate for a poster grid: columns of at most `PosterSize.width + 12`,
/// each tall enough for a [PosterCard] (2:3 image, gap, caption) at the
/// column's real width.
SliverGridDelegateWithMaxCrossAxisExtent posterGridDelegate(
  BuildContext context,
  double crossAxisExtent,
) {
  final size = PosterSize.of(context);
  final maxExtent = size.width + 12;
  final count = (crossAxisExtent / (maxExtent + MNSpace.md)).ceil().clamp(1, 99);
  final tileWidth = (crossAxisExtent - (count - 1) * MNSpace.md) / count;
  return SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: maxExtent,
    mainAxisSpacing: MNSpace.lg,
    crossAxisSpacing: MNSpace.md,
    mainAxisExtent: tileWidth / PosterSize.posterAspect +
        MNSpace.sm +
        size.captionHeight +
        1,
  );
}

/// A scrolling poster grid for one genre (or any discover/see-all feed).
///
/// Loading shows a shimmer grid, failure an [ErrorState] (retry through
/// [onRetry]), and an empty feed an [EmptyState].
class GenresListView extends StatelessWidget {
  const GenresListView({
    required this.future,
    Key? key,
    required this.headlineText,
    this.istvshow = true,
    this.genreId,
    this.onRetry,
    this.overlapHandle,
  }) : super(key: key);
  final String headlineText;
  final Future<Model> future;
  final bool istvshow;

  /// Used only to keep Hero tags unique per genre tab.
  final int? genreId;

  /// Called by the error state's "Try Again". When null the error state
  /// retries by rebuilding with the same future (a no-op for a failed one).
  final VoidCallback? onRetry;

  /// Set when hosted in a NestedScrollView body, so the first row is not
  /// hidden under the pinned header.
  final SliverOverlapAbsorberHandle? overlapHandle;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Model>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _scroll(context, const genreListViewShimmerWidget());
        }
        if (snapshot.hasError) {
          return _fill(
            context,
            ErrorState(
              message: S.of(context).noDataFound,
              onRetry: onRetry ?? () {},
            ),
          );
        }
        final data = snapshot.data?.results;
        if (data == null || data.isEmpty) {
          return _fill(
            context,
            EmptyState(
              icon: IconsaxOutline.video,
              title: S.of(context).noDataFound,
            ),
          );
        }
        final source = genreId == null ? 'genre' : 'genre-$genreId';
        return _scroll(
          context,
          SliverLayoutBuilder(
            builder: (context, constraints) => SliverGrid.builder(
              gridDelegate: posterGridDelegate(
                  context, constraints.crossAxisExtent),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                final id = item.id!;
                return PosterCard(
                  posterPath: item.posterPath,
                  title: item.title ?? item.name ?? '',
                  subtitle: (item.genreIds ?? const []).isNotEmpty
                      ? getGenres(item.genreIds!)
                      : null,
                  heroTag: heroTagFor(source: source, isTv: istvshow, id: id),
                  onTap: () => openTitle(
                    context,
                    id: id,
                    isTv: istvshow,
                    heroTag: heroTagFor(source: source, isTv: istvshow, id: id),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _scroll(BuildContext context, Widget grid) {
    return CustomScrollView(
      physics: grid is genreListViewShimmerWidget
          ? const NeverScrollableScrollPhysics()
          : null,
      slivers: [
        if (overlapHandle != null)
          SliverOverlapInjector(handle: overlapHandle!),
        SliverPadding(
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: MNSpace.lg, vertical: MNSpace.sm),
          sliver: grid,
        ),
        SliverToBoxAdapter(child: SizedBox(height: tabBarClearance(context))),
      ],
    );
  }

  Widget _fill(BuildContext context, Widget child) {
    return CustomScrollView(
      slivers: [
        if (overlapHandle != null)
          SliverOverlapInjector(handle: overlapHandle!),
        SliverFillRemaining(hasScrollBody: false, child: child),
        SliverToBoxAdapter(child: SizedBox(height: tabBarClearance(context))),
      ],
    );
  }
}
