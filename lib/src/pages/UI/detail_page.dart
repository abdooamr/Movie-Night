import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/components/poster_card.dart' show heroTagFor;
import 'package:Movie_Night/src/components/poster_viewer.dart';
import 'package:Movie_Night/src/components/rating_badge.dart';
import 'package:Movie_Night/src/components/section_header.dart';
import 'package:Movie_Night/src/components/sign_in_prompt.dart';
import 'package:Movie_Night/src/components/spill_glow.dart';
import 'package:Movie_Night/src/components/state_views.dart';
import 'package:Movie_Night/src/data/auth_repository.dart';
import 'package:Movie_Night/src/design/motion.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/models/credit_model.dart';
import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/navigation/routes.dart';
import 'package:Movie_Night/src/pages/UI/Reviews_page.dart';
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
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    this.data,
    this.index,
    this.creditData,
    this.id,
    required this.isTvShow,
    this.heroTag,
  });

  final int? index;
  final int? id;
  final Model? data;
  final Credit? creditData;
  final bool isTvShow;

  /// Hero tag of the poster that opened this page (see `heroTagFor`).
  final String? heroTag;

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
    return getdetails(widget.id!, widget.isTvShow, lang);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MovieModel>(
      future: _details,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const detailPageShimmerWidget(),
          );
        }
        final details = snapshot.data;
        if (snapshot.hasError || details == null) {
          return Scaffold(
            appBar: AppBar(),
            body: ErrorState(
              message: S.of(context).couldntLoadTitle,
              onRetry: () => setState(() => _details = _load()),
            ),
          );
        }
        return Scaffold(
          body: _DetailBody(
            details: details,
            isTv: widget.isTvShow,
            isLoggedIn: _isLoggedIn,
            heroTag: widget.heroTag ??
                heroTagFor(
                    source: 'detail', isTv: widget.isTvShow, id: details.id),
          ),
        );
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.details,
    required this.isTv,
    required this.isLoggedIn,
    required this.heroTag,
  });

  final MovieModel details;
  final bool isTv;
  final bool isLoggedIn;
  final String heroTag;

  String get _title => (isTv ? details.name : details.title) ?? '';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final cs = Theme.of(context).colorScheme;
    final mn = MNColors.of(context);
    final id = details.id;
    final backdrop = details.backdropPath ?? details.posterPath;
    final poster = details.posterPath;

    void share() => SharePlus.instance.share(ShareParams(
          text: s.shareText(
            _title,
            'https://www.themoviedb.org/${isTv ? 'tv' : 'movie'}/$id',
          ),
        ));

    // Each section is its own list item, so the SliverList only builds (and
    // fires the request for) sections that come near the viewport. Network
    // sections are kept alive so scrolling back doesn't refetch them.
    final sections = <Widget>[
      if (details.overview.isNotEmpty)
        Padding(
          padding: const EdgeInsetsDirectional.only(bottom: MNSpace.xl),
          child: _Storyline(text: details.overview),
        ),
      _KeepAlive(child: CastWidget(id: id, isTvShow: isTv)),
      _KeepAlive(child: WatchProviderWidget(id: id, isTvShow: isTv)),
      if (isTv) _KeepAlive(child: BuyProviderWidget(id: id, isTvShow: isTv)),
      _KeepAlive(child: SimilarWidget(id: id, isTvShow: isTv)),
      if (isLoggedIn)
        _KeepAlive(child: ReviewsPage(id: id, isTvShow: isTv))
      else
        Padding(
          padding: const EdgeInsetsDirectional.all(MNSpace.lg),
          child: SignInPrompt(onLogIn: () => presentSignIn(context)),
        ),
    ];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          stretch: true,
          expandedHeight: 260,
          backgroundColor: cs.surface,
          leading: BackButton(
            style: IconButton.styleFrom(backgroundColor: mn.chrome),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: MNSpace.xs),
              child: IconButtonTheme(
                data: IconButtonThemeData(
                  style: IconButton.styleFrom(backgroundColor: mn.chrome),
                ),
                child: DetailShareButton(onShare: share),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [StretchMode.zoomBackground],
            collapseMode: CollapseMode.parallax,
            titlePadding: const EdgeInsetsDirectional.only(
              start: MNSpace.xxxl + MNSpace.lg,
              end: MNSpace.xxxl + MNSpace.lg,
              bottom: MNSpace.md,
            ),
            // Fades in once the bar has collapsed.
            title: Builder(builder: (context) {
              final fs = context.dependOnInheritedWidgetOfExactType<
                  FlexibleSpaceBarSettings>();
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
                    _title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              );
            }),
            background: backdrop == null
                ? ColoredBox(color: cs.surfaceContainer)
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedImageCustom('$imageUrl$backdrop'),
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
                              stops: const [0.5, 1],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        SliverToBoxAdapter(
          child: SpillGlow(
            source: poster == null
                ? null
                : CachedNetworkImageProvider('$imageUrl$poster'),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                  MNSpace.lg, 0, MNSpace.lg, MNSpace.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _InfoBlock(
                    details: details,
                    isTv: isTv,
                    title: _title,
                    heroTag: heroTag,
                  ),
                  const SizedBox(height: MNSpace.xl),
                  _Actions(details: details, isTv: isTv, isLoggedIn: isLoggedIn),
                ],
              ),
            ),
          ),
        ),
        SliverList.builder(
          itemCount: sections.length,
          itemBuilder: (context, i) => sections[i],
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

/// Poster (Hero, opens the viewer), title, one meta line and the rating.
/// Side by side at 600 wide and up, stacked below that.
class _InfoBlock extends StatelessWidget {
  const _InfoBlock({
    required this.details,
    required this.isTv,
    required this.title,
    required this.heroTag,
  });

  final MovieModel details;
  final bool isTv;
  final String title;
  final String heroTag;

  static const double _posterWidth = 112;
  static const double _posterHeight = 168;

  String _meta(S s) {
    final date = isTv ? details.firstAirDate : details.releaseDate;
    final runtime = details.runtime;
    final status = details.status;
    return [
      if (date != null) '${date.year}',
      if (isTv && status != null) status,
      if (!isTv && runtime != null && runtime > 0) '$runtime ${s.minute}',
      if (details.genres.isNotEmpty)
        details.genres.map((g) => g.name).join(', '),
    ].where((p) => p.isNotEmpty).join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final posterPath = details.posterPath;
    final url = posterPath == null ? null : '$imageUrl$posterPath';

    final poster = Semantics(
      button: url != null,
      label: title,
      excludeSemantics: true,
      onTap: url == null ? null : () => _openViewer(context, url),
      child: GestureDetector(
        onTap: url == null ? null : () => _openViewer(context, url),
        child: SizedBox(
          width: _posterWidth,
          height: _posterHeight,
          child: Hero(
            tag: heroTag,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: MNRadius.mdAll,
                boxShadow: MNColors.of(context).posterShadow,
              ),
              child: CachedImageCustom(
                url ?? '',
                width: _posterWidth,
                height: _posterHeight,
                decodeWidth: _posterWidth,
                borderRadius: MNRadius.mdAll,
              ),
            ),
          ),
        ),
      ),
    );

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: theme.textTheme.headlineSmall),
        ),
        const SizedBox(height: MNSpace.xs),
        Text(
          _meta(s),
          style: theme.textTheme.bodyMedium!
              .copyWith(color: cs.onSurfaceVariant),
        ),
        if (isTv) ...[
          const SizedBox(height: MNSpace.xs),
          Text(
            '${s.numberofseasons}: ${details.numberOfSeasons ?? 0}'
            ' · ${s.numberofepisodes}: ${details.numberOfEpisodes ?? 0}',
            style: theme.textTheme.bodyMedium!
                .copyWith(color: cs.onSurfaceVariant),
          ),
        ],
        const SizedBox(height: MNSpace.sm),
        RatingBadge(score: details.voteAverage, showSource: true),
      ],
    );

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 600) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            poster,
            const SizedBox(width: MNSpace.lg),
            Expanded(child: info),
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          poster,
          const SizedBox(height: MNSpace.lg),
          info,
        ],
      );
    });
  }

  void _openViewer(BuildContext context, String url) {
    showPosterViewer(
      context,
      image: CachedNetworkImageProvider(url),
      heroTag: heroTag,
      semanticLabel: title,
    );
  }
}

/// Wires [DetailActions] to the like box, the watchlist tile, the videos page
/// and IMDb.
class _Actions extends StatelessWidget {
  const _Actions({
    required this.details,
    required this.isTv,
    required this.isLoggedIn,
  });

  final MovieModel details;
  final bool isTv;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    final imdb = details.imdbId;
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
          onOpenImdb: imdb == null || imdb.isEmpty
              ? null
              : () => launchUrlString('https://www.imdb.com/title/$imdb/'),
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

/// Overview clamped to 4 lines, with "Read more" when it actually overflows.
class _Storyline extends StatefulWidget {
  const _Storyline({required this.text});

  final String text;

  static const int collapsedLines = 4;

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
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: MNSpace.lg),
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
