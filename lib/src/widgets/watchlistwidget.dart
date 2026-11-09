import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../generated/l10n.dart';
import '../components/cached_image.dart';
import '../components/poster_card.dart';
import '../components/rating_badge.dart';
import '../design/tokens.dart';
import '../models/moviedetails.dart';
import '../navigation/routes.dart';
import '../pages/UI/detail_preview.dart';
import '../utils/utils.dart' show imageUrl;

/// One Watchlist row: poster thumbnail, title, year and rating, with a
/// trailing remove button. Removal is immediate (the caller offers Undo, B4);
/// swipe-to-remove and a screen-reader "Delete" action do the same.
class BookmarkWidget extends StatelessWidget {
  final MovieModel movieDetails;
  final bool isTvShow;
  final VoidCallback onRemove;

  const BookmarkWidget({
    super.key,
    required this.movieDetails,
    required this.isTvShow,
    required this.onRemove,
  });

  String get _title =>
      (isTvShow ? movieDetails.name : movieDetails.title) ?? '';

  int? get _year =>
      (isTvShow ? movieDetails.firstAirDate : movieDetails.releaseDate)?.year;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final s = S.of(context);
    final year = _year;
    final heroTag = heroTagFor(
      source: 'watchlist',
      isTv: isTvShow,
      id: movieDetails.id,
    );
    final posterPath = movieDetails.posterPath;
    const thumbWidth = MNSize.avatar;
    const thumbHeight = thumbWidth * 3 / 2;

    return Slidable(
      key: ValueKey('${isTvShow ? 'tv' : 'movie'}/${movieDetails.id}'),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: onRemove),
        children: [
          SlidableAction(
            onPressed: (_) => onRemove(),
            backgroundColor: cs.errorContainer,
            foregroundColor: cs.onErrorContainer,
            icon: IconsaxOutline.trash,
            label: s.delete,
          ),
        ],
      ),
      child: Semantics(
        customSemanticsActions: {
          CustomSemanticsAction(label: s.delete): onRemove,
        },
        child: InkWell(
          onTap: () => openTitle(
            context,
            id: movieDetails.id,
            isTv: isTvShow,
            heroTag: heroTag,
            preview: DetailPreview.fromDetails(movieDetails, isTv: isTvShow),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: MNSpace.lg,
              vertical: MNSpace.sm,
            ),
            child: Row(
              children: [
                Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: MNRadius.smAll,
                    child: SizedBox(
                      width: thumbWidth,
                      height: thumbHeight,
                      child: posterPath == null
                          ? ColoredBox(
                              color: cs.surfaceContainer,
                              child: Icon(
                                IconsaxOutline.video,
                                color: cs.onSurfaceVariant,
                              ),
                            )
                          : CachedImageCustom(
                              '$imageUrl$posterPath',
                              width: thumbWidth,
                              height: thumbHeight,
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
                        _title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium,
                      ),
                      if (year != null)
                        Text(
                          '$year',
                          style: theme.textTheme.labelMedium!
                              .copyWith(color: cs.onSurfaceVariant),
                        ),
                      const SizedBox(height: MNSpace.xs),
                      RatingBadge(score: movieDetails.voteAverage),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: s.deleteBookmark,
                  onPressed: onRemove,
                  icon: const Icon(IconsaxOutline.trash),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
