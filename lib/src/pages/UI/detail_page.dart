import 'dart:async';
import 'dart:math' as math;

import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/components/poster_card.dart' show heroTagFor;
import 'package:Movie_Night/src/components/poster_viewer.dart';
import 'package:Movie_Night/src/components/rating_badge.dart';
import 'package:Movie_Night/src/components/section_header.dart';
import 'package:Movie_Night/src/components/spill_glow.dart';
import 'package:Movie_Night/src/components/state_views.dart';
import 'package:Movie_Night/src/data/auth_repository.dart';
import 'package:Movie_Night/src/design/motion.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/navigation/routes.dart';
import 'package:Movie_Night/src/pages/UI/Reviews_page.dart';
import 'package:Movie_Night/src/pages/UI/detail_preview.dart';
import 'package:Movie_Night/src/repository/Getvideos.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:Movie_Night/src/widgets/Buy_provider.dart';
import 'package:Movie_Night/src/widgets/addtowatchlist.dart';
import 'package:Movie_Night/src/widgets/cast.dart';
import 'package:Movie_Night/src/widgets/detail_actions.dart';
import 'package:Movie_Night/src/widgets/shimmerWidgets/detailPageShimmerWidget.dart';
import 'package:Movie_Night/src/widgets/similar.dart';
import 'package:Movie_Night/src/widgets/watch_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// A movie or TV show.
///
/// The backdrop is the screen and its light spills onto everything below
/// (the spill glow is lit from the backdrop). When opened from a rail, the
/// header (backdrop, poster, title, year, rating) is drawn at once from
/// [preview], so the poster's Hero flight lands in place; the actions and
/// sections fade in when the full details arrive.
class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.id,
    required this.isTvShow,
    this.heroTag,
    this.preview,
    @visibleForTesting this.fetch,
  });

  final int id;
  final bool isTvShow;

  /// Hero tag of the poster that opened this page (see `heroTagFor`).
  final String? heroTag;

  /// What the tapped rail item already knows; null shows a skeleton until
  /// the details load.
  final DetailPreview? preview;

  /// Test hook replacing the network details request.
  final Future<MovieModel> Function(int id, bool isTv, String lang)? fetch;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  /// Follows sign-in and sign-out while the page is open (e.g. signing in
  /// from this page's own prompt, or out from the Profile tab).
  bool _isLoggedIn = AuthRepository.instance.isSignedIn;
  StreamSubscription<Object?>? _authSub;
  late Future<MovieModel> _details;

  @override
  void initState() {
    super.initState();
    _authSub = AuthRepository.instance.authStateChanges.listen(
      (state) {
        final signedIn = state.session != null;
        if (mounted && signedIn != _isLoggedIn) {
          setState(() => _isLoggedIn = signedIn);
        }
      },
      onError: (Object _) {}, // Link errors are shown by AuthPage.
    );
    _details = _load();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<MovieModel> _load() {
    final lang =
        Provider.of<DropdownProvider>(context, listen: false).selectedValue;
    final fetch = widget.fetch;
    if (fetch != null) return fetch(widget.id, widget.isTvShow, lang);
    return getdetails(widget.id, widget.isTvShow, lang);
  }

  void _retry() => setState(() {
        _details = _load();
      });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieModel>(
      future: _details,
      builder: (context, snapshot) {
        final details = snapshot.data;
        final failed = snapshot.hasError && details == null;
        final header = details != null
            ? DetailPreview.fromDetails(details, isTv: widget.isTvShow)
            : widget.preview;

        // Opened without rail data (e.g. from Liked): nothing to draw yet.
        if (header == null) {
          return Scaffold(
            appBar: AppBar(),
            body: failed
                ? ErrorState(
                    message: S.of(context).couldntLoadTitle,
                    onRetry: _retry,
                  )
                : const detailPageShimmerWidget(),
          );
        }
        return Scaffold(
          body: _DetailBody(
            id: widget.id,
            isTv: widget.isTvShow,
            header: header,
            details: details,
            failed: failed,
            onRetry: _retry,
            isLoggedIn: _isLoggedIn,
            heroTag: widget.heroTag ??
                heroTagFor(
                    source: 'detail', isTv: widget.isTvShow, id: widget.id),
          ),
        );
      },
    );
  }
}

/// Whether text is large enough that the title moves out of the header
/// (beside the poster) to its own full-width block below.
bool _stackTitle(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(1) >= 1.5;

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.id,
    required this.isTv,
    required this.header,
    required this.details,
    required this.failed,
    required this.onRetry,
    required this.isLoggedIn,
    required this.heroTag,
  });

  final int id;
  final bool isTv;
  final DetailPreview header;

  /// Null while loading (or after a failure).
  final MovieModel? details;
  final bool failed;
  final VoidCallback onRetry;
  final bool isLoggedIn;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final stacked = _stackTitle(context);
    final details = this.details;
    final backdrop = header.backdropPath;

    void share() => SharePlus.instance.share(ShareParams(
          text: s.shareText(
            header.title,
            'https://www.themoviedb.org/${isTv ? 'tv' : 'movie'}/$id',
          ),
        ));
    final imdb = details?.imdbId;
    final openImdb = imdb == null || imdb.isEmpty
        ? null
        : () => launchUrlString('https://www.imdb.com/title/$imdb/');

    // Each section is its own list item, so the SliverList only builds (and
    // fires the request for) sections that come near the viewport. Network
    // sections are kept alive so scrolling back doesn't refetch them. Order:
    // "where can I watch it" first, then what it is, then what people think.
    final sections = details == null
        ? const <Widget>[]
        : <Widget>[
            _KeepAlive(child: WatchProviderWidget(id: id, isTvShow: isTv)),
            if (isTv)
              _KeepAlive(child: BuyProviderWidget(id: id, isTvShow: isTv)),
            if (details.overview.isNotEmpty)
              Padding(
                padding: const EdgeInsetsDirectional.only(bottom: MNSpace.xl),
                child: _Storyline(text: details.overview),
              ),
            _KeepAlive(child: CastWidget(id: id, isTvShow: isTv)),
            // Everyone can read reviews; writing asks for an account.
            _KeepAlive(
              child: ReviewsPage(
                id: id,
                isTvShow: isTv,
                isLoggedIn: isLoggedIn,
                onRequireSignIn: () => presentSignIn(context),
              ),
            ),
            _KeepAlive(child: SimilarWidget(id: id, isTvShow: isTv)),
          ];

    final Widget below;
    if (details != null) {
      below = _FadeIn(
        order: 0,
        child: _Actions(
          details: details,
          isTv: isTv,
          isLoggedIn: isLoggedIn,
          onShare: share,
        ),
      );
    } else if (failed) {
      below = ErrorState(
        compact: true,
        message: s.couldntLoadTitle,
        onRetry: onRetry,
      );
    } else {
      below = const _ActionsSkeleton();
    }

    return CustomScrollView(
      slivers: [
        _HeaderBar(
          header: header,
          details: details,
          isTv: isTv,
          heroTag: heroTag,
          stacked: stacked,
          more: DetailMoreMenu(onShare: share, onOpenImdb: openImdb),
        ),
        SliverToBoxAdapter(
          // The glow: light from the backdrop (the "screen") falling onto
          // the info below it.
          child: SpillGlow(
            source: backdrop == null
                ? null
                : CachedNetworkImageProvider(
                    tmdbBackdrop(backdrop, SpillGlow.bakeWidth.toDouble())),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                  MNSpace.lg, MNSpace.md, MNSpace.lg, MNSpace.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (stacked) ...[
                    _TitleBlock(header: header, details: details, isTv: isTv),
                    const SizedBox(height: MNSpace.lg),
                  ],
                  if (header.genres.isNotEmpty) ...[
                    Text(
                      header.genres.join(' · '),
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: MNSpace.lg),
                  ],
                  below,
                ],
              ),
            ),
          ),
        ),
        SliverList.builder(
          itemCount: sections.length,
          itemBuilder: (context, i) =>
              i < 2 ? _FadeIn(order: i + 1, child: sections[i]) : sections[i],
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.paddingOf(context).bottom + MNSpace.xl,
          ),
        ),
      ],
    );
  }
}

/// The collapsing header: a 16:9 backdrop under the status bar, with the
/// poster overlapping its bottom edge and the title beside the poster.
/// Collapses to a bar with back, the title and the "⋯" menu.
class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.header,
    required this.details,
    required this.isTv,
    required this.heroTag,
    required this.stacked,
    required this.more,
  });

  final DetailPreview header;
  final MovieModel? details;
  final bool isTv;
  final String heroTag;

  /// Large text: the title lives below the header instead.
  final bool stacked;
  final Widget more;

  static const double _maxBackdropHeight = 420;

  /// Share of the poster's height that hangs below the backdrop.
  static const double _posterHang = 0.55;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mn = MNColors.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final topInset = MediaQuery.paddingOf(context).top;
    final posterWidth = width >= 600 ? 140.0 : 112.0;
    final posterHeight = posterWidth * 1.5;
    final backdropHeight = math.min(width * 9 / 16, _maxBackdropHeight);
    final expandedHeight =
        backdropHeight + posterHeight * _posterHang + MNSpace.md;

    final backdropPath = header.backdropPath;
    final posterPath = header.posterPath;
    final Widget backdrop;
    if (backdropPath != null) {
      backdrop = CachedImageCustom(tmdbBackdrop(backdropPath, width * dpr));
    } else if (posterPath != null) {
      backdrop = CachedImageCustom(tmdbImage(posterPath, width * dpr));
    } else {
      backdrop = ColoredBox(color: cs.surfaceContainer);
    }

    final chromeButtons = IconButtonTheme(
      data: IconButtonThemeData(
        style: IconButton.styleFrom(backgroundColor: mn.chrome),
      ),
      child: more,
    );

    return SliverAppBar(
      pinned: true,
      expandedHeight: expandedHeight,
      backgroundColor: cs.surface,
      leading: BackButton(
        style: IconButton.styleFrom(backgroundColor: mn.chrome),
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: MNSpace.xs),
          child: chromeButtons,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        centerTitle: true,
        titlePadding: const EdgeInsetsDirectional.only(
          start: MNSpace.xxxl + MNSpace.lg,
          end: MNSpace.xxxl + MNSpace.lg,
          bottom: MNSpace.md,
        ),
        // Fades in once the bar has collapsed.
        title: Builder(builder: (context) {
          final fs = context
              .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
          final span = fs == null ? 0.0 : fs.maxExtent - fs.minExtent;
          final expanded = fs == null || span <= 0
              ? 0.0
              : ((fs.currentExtent - fs.minExtent) / span).clamp(0.0, 1.0);
          final shown = (1 - expanded * 2).clamp(0.0, 1.0);
          return ExcludeSemantics(
            excluding: shown == 0,
            child: Opacity(
              opacity: shown,
              child: Text(
                header.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        }),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: topInset + backdropHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ExcludeSemantics(child: backdrop),
                  IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: AlignmentDirectional.topCenter,
                          end: AlignmentDirectional.bottomCenter,
                          colors: [
                            cs.surface.withValues(alpha: 0),
                            cs.surface,
                          ],
                          stops: const [0.45, 1],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              start: MNSpace.lg,
              bottom: MNSpace.md,
              width: posterWidth,
              height: posterHeight,
              child: _Poster(
                path: posterPath,
                title: header.title,
                heroTag: heroTag,
                width: posterWidth,
                height: posterHeight,
              ),
            ),
            if (!stacked)
              PositionedDirectional(
                start: MNSpace.lg + posterWidth + MNSpace.md,
                end: MNSpace.lg,
                bottom: MNSpace.md,
                child:
                    _TitleBlock(header: header, details: details, isTv: isTv),
              ),
          ],
        ),
      ),
    );
  }
}

/// The poster (Hero target of the rail poster); tapping opens the viewer.
class _Poster extends StatelessWidget {
  const _Poster({
    required this.path,
    required this.title,
    required this.heroTag,
    required this.width,
    required this.height,
  });

  final String? path;
  final String title;
  final String heroTag;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final path = this.path;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final viewerUrl = path == null ? null : '$imageUrl$path';
    void open() => showPosterViewer(
          context,
          image: CachedNetworkImageProvider(viewerUrl!),
          heroTag: heroTag,
          semanticLabel: title,
        );

    return Semantics(
      button: viewerUrl != null,
      label: title,
      excludeSemantics: true,
      onTap: viewerUrl == null ? null : open,
      child: GestureDetector(
        onTap: viewerUrl == null ? null : open,
        child: Hero(
          tag: heroTag,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: MNRadius.mdAll,
              boxShadow: MNColors.of(context).posterShadow,
            ),
            child: path == null
                ? ClipRRect(
                    borderRadius: MNRadius.mdAll,
                    child: ColoredBox(color: cs.surfaceContainer),
                  )
                : CachedImageCustom(
                    tmdbImage(path, width * dpr),
                    width: width,
                    height: height,
                    decodeWidth: width,
                    borderRadius: MNRadius.mdAll,
                  ),
          ),
        ),
      ),
    );
  }
}

/// Title, one meta line ("2026 · 2h 53m" / "2017 · 3 seasons · 26
/// episodes") and the rating. The year and rating come from the preview, the
/// rest once the details load.
class _TitleBlock extends StatelessWidget {
  const _TitleBlock({
    required this.header,
    required this.details,
    required this.isTv,
  });

  final DetailPreview header;
  final MovieModel? details;
  final bool isTv;

  String _meta(S s) {
    final d = details;
    return [
      if (header.year != null) '${header.year}',
      if (d != null && !isTv && (d.runtime ?? 0) > 0)
        formatRuntime(s, d.runtime!),
      if (d != null && isTv && (d.numberOfSeasons ?? 0) > 0)
        s.seasonsCount(d.numberOfSeasons!),
      if (d != null && isTv && (d.numberOfEpisodes ?? 0) > 0)
        s.episodesCount(d.numberOfEpisodes!),
    ].join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final meta = _meta(s);
    final score = header.voteAverage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          header: true,
          child: Text(
            header.title,
            maxLines: _stackTitle(context) ? null : 2,
            overflow: _stackTitle(context) ? null : TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall,
          ),
        ),
        if (meta.isNotEmpty) ...[
          const SizedBox(height: MNSpace.xs),
          Text(
            meta,
            maxLines: _stackTitle(context) ? null : 2,
            overflow: _stackTitle(context) ? null : TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium!
                .copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
        if (score != null && score > 0) ...[
          const SizedBox(height: MNSpace.sm),
          RatingBadge(score: score, showSource: true),
        ],
      ],
    );
  }
}

/// Holds the actions' place while the details load, so nothing jumps.
class _ActionsSkeleton extends StatelessWidget {
  const _ActionsSkeleton();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Widget block(double height) => SizedBox(
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: MNRadius.mdAll,
            ),
          ),
        );
    return ExcludeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          block(MNSize.buttonHeight),
          const SizedBox(height: MNSpace.md),
          Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                if (i > 0) const SizedBox(width: MNSpace.sm),
                Expanded(child: block(MNSize.avatar)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Fades its child in when first built, [order] steps after the others
/// (staggered by `MNDuration.micro`). Fades only (no movement), so it stays
/// under Reduce Motion, without the stagger; skipped in low power.
class _FadeIn extends StatefulWidget {
  const _FadeIn({required this.order, required this.child});

  final int order;
  final Widget child;

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _opacity;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    final motion = MNMotion.of(context);
    if (motion.lowPower) return; // Show at once.
    final fade = motion.fade(MNDuration.short);
    final delay = motion.allowRichMotion
        ? MNDuration.micro * widget.order
        : Duration.zero;
    final total = delay + fade;
    final controller = AnimationController(vsync: this, duration: total);
    final start = total.inMicroseconds == 0
        ? 0.0
        : delay.inMicroseconds / total.inMicroseconds;
    _opacity = CurvedAnimation(
      parent: controller,
      curve: Interval(start, 1, curve: MNCurves.standard),
    );
    _controller = controller..forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opacity = _opacity;
    if (opacity == null) return widget.child;
    return FadeTransition(opacity: opacity, child: widget.child);
  }
}

/// Wires [DetailActions] to the like box, the watchlist tile, the videos page
/// and the share sheet.
class _Actions extends StatelessWidget {
  const _Actions({
    required this.details,
    required this.isTv,
    required this.isLoggedIn,
    required this.onShare,
  });

  final MovieModel details;
  final bool isTv;
  final bool isLoggedIn;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    Widget actions(bool liked, VoidCallback toggle) => DetailActions(
          isLoggedIn: isLoggedIn,
          isLiked: liked,
          onToggleLike: toggle,
          onRequireSignIn: () => presentSignIn(context),
          onWatchTrailers: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  VideosPage(movieid: details.id, isTvShow: isTv),
            ),
          ),
          onShare: onShare,
          watchlist: isLoggedIn
              ? Watchlistwidget(movieid: details.id, istvshow: isTv)
              : null,
        );

    if (!isLoggedIn) return actions(false, () {});

    final box = Hive.box<LikedModel>('liked');
    // Rebuilds only when this title's entry changes.
    return ValueListenableBuilder<Box<LikedModel>>(
      valueListenable: box.listenable(keys: [details.id]),
      builder: (context, box, _) {
        final liked = box.get(details.id)?.isLiked == true;
        return actions(liked, () {
          if (liked) {
            // Remove rather than store isLiked=false, so the box only holds
            // liked titles.
            box.delete(details.id);
          } else {
            box.put(
              details.id,
              LikedModel(
                title: (isTv ? details.name : details.title) ?? '',
                voteAverage: details.voteAverage,
                posterPath: details.posterPath ?? '',
                isLiked: true,
                genres: details.genres.map((e) => e.name).toString(),
                id: details.id,
                isTvShow: isTv,
              ),
            );
          }
        });
      },
    );
  }
}

/// Overview clamped to 3 lines, with "Read more" when it actually overflows.
class _Storyline extends StatefulWidget {
  const _Storyline({required this.text});

  final String text;

  static const int collapsedLines = 3;

  @override
  State<_Storyline> createState() => _StorylineState();
}

class _StorylineState extends State<_Storyline> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge;
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);
    final motion = MNMotion.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: S.of(context).storyline),
        Padding(
          padding:
              const EdgeInsetsDirectional.symmetric(horizontal: MNSpace.lg),
          child: LayoutBuilder(builder: (context, constraints) {
            final painter = TextPainter(
              text: TextSpan(text: widget.text, style: style),
              textDirection: direction,
              textScaler: scaler,
              maxLines: _Storyline.collapsedLines,
            )..layout(maxWidth: constraints.maxWidth);
            final overflows = painter.didExceedMaxLines;
            painter.dispose();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRect(
                  child: AnimatedSize(
                    duration: motion(MNDuration.medium),
                    curve: MNCurves.standard,
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      widget.text,
                      maxLines: _expanded ? null : _Storyline.collapsedLines,
                      overflow: _expanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: style,
                    ),
                  ),
                ),
                if (overflows)
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsetsDirectional.zero,
                      alignment: AlignmentDirectional.centerStart,
                    ),
                    onPressed: () => setState(() => _expanded = !_expanded),
                    child: Text(_expanded
                        ? S.of(context).readLess
                        : S.of(context).readmorelabel),
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

/// Keeps a lazily-built section alive after it first scrolls into view, so its
/// State (and the Future it fetched in initState) survives scrolling away.
class _KeepAlive extends StatefulWidget {
  const _KeepAlive({required this.child});

  final Widget child;

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
