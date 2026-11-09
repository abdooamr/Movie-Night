import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import '../design/tokens.dart';
import '../utils/poster_size.dart';
import '../utils/utils.dart' show tmdbImage;
import 'cached_image.dart';
import 'pressable.dart';

/// Hero tag for a poster, unique per rail ([source]) and media type, so the
/// same title in two rails never collides (spec section 9).
String heroTagFor({
  required String source,
  required bool isTv,
  required int id,
}) =>
    'poster-$source-${isTv ? 'tv' : 'movie'}-$id';

/// Hero flight child for rail and carousel posters: always the rail's own,
/// already decoded image (the "from" side when pushing, the "to" side when
/// popping), so the flight never shows a placeholder while the other side's
/// differently sized image loads.
Widget railHeroShuttle(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final rail = flightDirection == HeroFlightDirection.push
      ? fromHeroContext
      : toHeroContext;
  return (rail.widget as Hero).child;
}

/// The one poster tile: 2:3 image (radius md, light-theme shadow), a
/// two-line titleMedium title and an optional one-line subtitle. Exposed to
/// assistive tech as a single button "title, subtitle".
class PosterCard extends StatelessWidget {
  const PosterCard({
    super.key,
    required this.posterPath,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.heroTag,
    this.width,
  });

  /// TMDB poster path (e.g. `/abc.jpg`); null shows the placeholder glyph.
  final String? posterPath;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final String? heroTag;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final label =
        subtitle == null || subtitle!.isEmpty ? title : '$title, $subtitle';

    // The Hero sits inside the LayoutBuilder, so its child is a fixed-size
    // image: a flight changes the size around it, never its URL.
    final poster = AspectRatio(
      aspectRatio: PosterSize.posterAspect,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final path = posterPath;
          Widget image = DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: MNRadius.mdAll,
              boxShadow: MNColors.of(context).posterShadow,
            ),
            child: path == null
                ? ClipRRect(
                    borderRadius: MNRadius.mdAll,
                    child: ColoredBox(
                      color: cs.surfaceContainer,
                      child: Center(
                        child: Icon(
                          IconsaxOutline.video,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                : CachedImageCustom(
                    tmdbImage(
                      path,
                      constraints.maxWidth *
                          MediaQuery.devicePixelRatioOf(context),
                    ),
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    borderRadius: MNRadius.mdAll,
                  ),
          );
          if (heroTag != null) {
            image = Hero(
              tag: heroTag!,
              flightShuttleBuilder: railHeroShuttle,
              child: image,
            );
          }
          return image;
        },
      ),
    );

    Widget card = Semantics(
      container: true,
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: PressableScale(
        onTap: onTap,
        borderRadius: MNRadius.mdAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            poster,
            const SizedBox(height: MNSpace.sm),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
            if (subtitle != null && subtitle!.isNotEmpty)
              Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium!
                    .copyWith(color: cs.onSurfaceVariant),
              ),
          ],
        ),
      ),
    );
    if (width != null) card = SizedBox(width: width, child: card);
    return card;
  }
}
