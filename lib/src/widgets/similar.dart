import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/poster_card.dart';
import 'package:Movie_Night/src/components/section_header.dart';
import 'package:Movie_Night/src/components/state_views.dart';
import 'package:Movie_Night/src/design/motion.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/navigation/routes.dart';
import 'package:Movie_Night/src/utils/poster_size.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/movie_model.dart';

/// "Recommendation" rail on Detail: a [SectionHeader] with See All and a
/// horizontal rail of [PosterCard]s. Hidden when there are no results.
class SimilarWidget extends StatefulWidget {
  const SimilarWidget({super.key, required this.id, required this.isTvShow});
  final int id;

  final bool isTvShow;
  @override
  State<SimilarWidget> createState() => _SimilarWidgetState();
}

class _SimilarWidgetState extends State<SimilarWidget> {
  static const String _heroSource = 'similar';

  late Future<Model> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Model> _load() {
    final lang =
        Provider.of<DropdownProvider>(context, listen: false).selectedValue;
    return getrecommendations(widget.id, widget.isTvShow, lang);
  }

  void _retry() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    final title = S.of(context).Recommendation;
    return FutureBuilder<Model>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _section(title, const _RailSkeleton());
        }
        if (snapshot.hasError) {
          return _section(
            title,
            ErrorState(
              compact: true,
              message: S.of(context).couldntLoadSection(title),
              onRetry: _retry,
            ),
          );
        }
        final results = snapshot.data?.results ?? const <Result>[];
        if (results.isEmpty) return const SizedBox.shrink();
        return _section(
          title,
          _Rail(results: results, isTv: widget.isTvShow),
          onSeeAll: () => openSeeAll(
            context,
            title: title,
            load: () => _future,
            isTv: widget.isTvShow,
          ),
        );
      },
    );
  }

  Widget _section(String title, Widget body, {VoidCallback? onSeeAll}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(title: title, onSeeAll: onSeeAll),
        const SizedBox(height: MNSpace.sm),
        body,
      ],
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({required this.results, required this.isTv});

  final List<Result> results;
  final bool isTv;

  static String? _year(String? date) =>
      date != null && date.length >= 4 ? date.substring(0, 4) : null;

  @override
  Widget build(BuildContext context) {
    final size = PosterSize.of(context);
    final gutter = (size.itemExtent - size.width) / 2;
    return SizedBox(
      height: size.cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: MNSpace.lg - gutter,
        ),
        itemExtent: size.itemExtent,
        itemCount: results.length,
        itemBuilder: (context, index) {
          final item = results[index];
          final id = item.id;
          final heroTag = id == null
              ? null
              : heroTagFor(
                  source: _SimilarWidgetState._heroSource,
                  isTv: isTv,
                  id: id,
                );
          return Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: gutter),
            child: PosterCard(
              posterPath: item.posterPath,
              title: (isTv ? item.name : item.title) ?? '',
              subtitle: _year(isTv ? item.firstAirDate : item.releaseDate),
              width: size.width,
              heroTag: heroTag,
              onTap: () {
                if (id == null) return;
                openTitle(context, id: id, isTv: isTv, heroTag: heroTag);
              },
            ),
          );
        },
      ),
    );
  }
}

/// One shimmer over the rail of poster blocks; static under Reduce Motion.
class _RailSkeleton extends StatelessWidget {
  const _RailSkeleton();

  @override
  Widget build(BuildContext context) {
    final size = PosterSize.of(context);
    final cs = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: SizedBox(
        height: size.cardHeight,
        child: Shimmer.fromColors(
          enabled: MNMotion.of(context).allowRichMotion,
          baseColor: cs.surfaceContainerHigh,
          highlightColor: cs.surfaceContainerHighest,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding:
                const EdgeInsetsDirectional.symmetric(horizontal: MNSpace.lg),
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: MNSpace.sm),
            itemBuilder: (_, __) => Align(
              alignment: AlignmentDirectional.topStart,
              child: Container(
                width: size.width,
                height: size.posterHeight,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHigh,
                  borderRadius: MNRadius.mdAll,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
