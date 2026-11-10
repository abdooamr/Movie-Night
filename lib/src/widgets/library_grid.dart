import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show CustomSemanticsAction;
import 'package:flutter/services.dart';

import '../../generated/l10n.dart';
import '../components/poster_card.dart';
import '../design/tokens.dart';
import '../utils/poster_size.dart';

/// What the Library shows: everything, or one kind.
enum LibraryFilter {
  all,
  movies,
  tv;

  bool keeps({required bool isTv}) => switch (this) {
        LibraryFilter.all => true,
        LibraryFilter.movies => !isTv,
        LibraryFilter.tv => isTv,
      };
}

/// The Library's shelf: 3 posters a row on phones (2 at very large text),
/// more on tablets. Each cell fits a 2:3 poster and a two-line caption.
class LibraryGrid extends StatelessWidget {
  const LibraryGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  static const double _maxTabletTile = 160;

  /// Columns for [width] of usable space.
  static int columnsFor(BuildContext context, double width) {
    if (PosterSize.of(context).stackRails) return 2;
    if (width < PosterSize.tabletBreakpoint) return 3;
    return (width / _maxTabletTile).floor().clamp(4, 8);
  }

  @override
  Widget build(BuildContext context) {
    final size = PosterSize.of(context);
    return SliverPadding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: MNSpace.lg),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.crossAxisExtent;
          final columns = columnsFor(context, width);
          final tile = (width - (columns - 1) * MNSpace.md) / columns;
          return SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: MNSpace.md,
              mainAxisSpacing: MNSpace.lg,
              // Poster, gap, caption, and a pixel for text rounding.
              mainAxisExtent: tile / PosterSize.posterAspect +
                  MNSpace.sm +
                  size.captionHeight +
                  1,
            ),
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          );
        },
      ),
    );
  }
}

/// A Library title: a poster card that opens on tap and offers [removeLabel]
/// on long press (and as a screen-reader action).
class LibraryTile extends StatelessWidget {
  const LibraryTile({
    super.key,
    required this.posterPath,
    required this.title,
    required this.subtitle,
    required this.heroTag,
    required this.onOpen,
    required this.removeLabel,
    required this.onRemove,
  });

  final String? posterPath;
  final String title;
  final String? subtitle;
  final String? heroTag;
  final VoidCallback onOpen;
  final String removeLabel;
  final VoidCallback onRemove;

  Future<void> _showActions(BuildContext context) async {
    HapticFeedback.mediumImpact();
    final remove = await showModalBottomSheet<bool>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (sheet) => _RemoveSheet(title: title, removeLabel: removeLabel),
    );
    if (remove == true) onRemove();
  }

  @override
  Widget build(BuildContext context) {
    return PosterCard(
      posterPath: posterPath,
      title: title,
      subtitle: subtitle,
      heroTag: heroTag,
      onTap: onOpen,
      onLongPress: () => _showActions(context),
      semanticsActions: {
        CustomSemanticsAction(label: removeLabel): onRemove,
      },
    );
  }
}

/// The title being acted on, then the destructive action and Cancel.
class _RemoveSheet extends StatelessWidget {
  const _RemoveSheet({required this.title, required this.removeLabel});

  final String title;
  final String removeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
            MNSpace.lg, 0, MNSpace.lg, MNSpace.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium!
                  .copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: MNSpace.lg),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: cs.errorContainer,
                foregroundColor: cs.onErrorContainer,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(IconsaxOutline.trash),
              label: Text(removeLabel),
            ),
            const SizedBox(height: MNSpace.sm),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(S.of(context).cancelLabel),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder posters while a shelf loads: static, so it is Reduce Motion
/// safe and cheap on slow phones.
class LibraryGridSkeleton extends StatelessWidget {
  const LibraryGridSkeleton({super.key, this.count = 6});

  final int count;

  @override
  Widget build(BuildContext context) {
    return LibraryGrid(
      itemCount: count,
      itemBuilder: (context, _) => const LibraryTileSkeleton(),
    );
  }
}

/// One placeholder poster with two caption bars.
class LibraryTileSkeleton extends StatelessWidget {
  const LibraryTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Widget bar(double widthFactor) => FractionallySizedBox(
          widthFactor: widthFactor,
          child: Container(
            height: MNSpace.md,
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: MNRadius.smAll,
            ),
          ),
        );
    return ExcludeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: PosterSize.posterAspect,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: cs.surfaceContainer,
                borderRadius: MNRadius.mdAll,
              ),
            ),
          ),
          const SizedBox(height: MNSpace.sm),
          bar(0.85),
          const SizedBox(height: MNSpace.xs),
          bar(0.5),
        ],
      ),
    );
  }
}

/// "12 titles", on the page margin under the switch.
class LibraryCount extends StatelessWidget {
  const LibraryCount({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
            MNSpace.lg, 0, MNSpace.lg, MNSpace.md),
        child: Text(
          S.of(context).titlesCount(count),
          style: theme.textTheme.labelLarge!
              .copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
