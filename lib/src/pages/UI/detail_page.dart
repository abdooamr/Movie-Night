import 'dart:math' as math;
import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/cached_image.dart';
import 'package:Movie_Night/src/components/squaretile.dart';
import 'package:Movie_Night/src/components/stars.dart';
import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/pages/UI/Reviews_page.dart';
import 'package:Movie_Night/src/widgets/Buy_provider.dart';
import 'package:Movie_Night/src/widgets/addtowatchlist.dart';
import 'package:Movie_Night/src/widgets/watch_provider.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/widgets/shimmerWidgets/detailPageShimmerWidget.dart';
import 'package:Movie_Night/src/models/credit_model.dart';
import 'package:Movie_Night/src/repository/Getvideos.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:Movie_Night/src/widgets/allwidget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../models/movie_model.dart';

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
  late final bool _isLoggedIn;
  late final Future<MovieModel> _details;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final lang =
        Provider.of<DropdownProvider>(context, listen: false).selectedValue;
    _details = getdetails(widget.id!, widget.isTvShow, lang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MovieModel>(
        future: _details,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const detailPageShimmerWidget();
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('${S.of(context).error}: ${snapshot.error}'));
          }
          final movieDetails = snapshot.data;
          if (movieDetails == null) {
            return Center(child: Text(S.of(context).noDataFound));
          }
          return _buildBody(movieDetails);
        },
      ),
    );
  }

  Widget _buildBody(MovieModel movieDetails) {
    final id = movieDetails.id;
    final isTv = widget.isTvShow;

    // Each section is its own list item, so the SliverList only builds (and
    // runs initState / fires the request for) sections that come within the
    // viewport + cache extent. The network-backed sections are kept alive once
    // built so scrolling back up doesn't refetch them.
    final sections = <Widget>[
      _DetailHeader(movieDetails: movieDetails, isTvShow: isTv),
      const SizedBox(height: 5),
      _DetailActions(
        movieDetails: movieDetails,
        isTvShow: isTv,
        isLoggedIn: _isLoggedIn,
      ),
      const SizedBox(height: 5),
      if (movieDetails.overview.isNotEmpty) ...[
        Text(
          S.of(context).storyline,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          movieDetails.overview,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
      const SizedBox(height: 25),
      _KeepAlive(child: CastWidget(id: id, isTvShow: isTv)),
      _KeepAlive(child: WatchProviderWidget(id: id, isTvShow: isTv)),
      if (isTv) _KeepAlive(child: BuyProviderWidget(id: id, isTvShow: isTv)),
      _KeepAlive(child: SimilarWidget(id: id, isTvShow: isTv)),
      if (_isLoggedIn) _KeepAlive(child: ReviewsPage(id: id, isTvShow: isTv)),
    ];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          flexibleSpace: const FlexibleSpaceBar(
            stretchModes: [
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
              StretchMode.fadeTitle,
            ],
            collapseMode: CollapseMode.parallax,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Align(
                alignment: AlignmentDirectional.centerStart,
                child: sections[i],
              ),
              childCount: sections.length,
            ),
          ),
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

/// Backdrop card: poster, title, year/runtime, genres, rating, videos button.
class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.movieDetails, required this.isTvShow});

  final MovieModel movieDetails;
  final bool isTvShow;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(
              '$imageUrl${movieDetails.backdropPath ?? movieDetails.posterPath}'),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotoView(
                        imageProvider: NetworkImage(
                            '$imageUrl${movieDetails.posterPath!}'),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    width: 120,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedImageCustom(
                        decodeWidth: 120,
                        movieDetails.posterPath == null
                            ? 'images/placeholder.png'
                            : '$imageUrl${movieDetails.posterPath!}',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: math.min(200, MediaQuery.sizeOf(context).width * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          isTvShow ? movieDetails.name! : movieDetails.title!,
                          style: textTheme.titleLarge,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          (isTvShow
                                  ? movieDetails.firstAirDate
                                  : movieDetails.releaseDate)
                              .toString()
                              .substring(0, 4),
                          style: textTheme.titleSmall,
                        ),
                        const SizedBox(width: 4),
                        if (isTvShow)
                          Text(
                            " ${movieDetails.status}",
                            style:
                                textTheme.titleSmall!.copyWith(fontSize: 13),
                          )
                        else ...[
                          const Text(" . "),
                          Text(
                            " ${movieDetails.runtime}${S.of(context).minute}",
                            style: textTheme.titleSmall,
                          ),
                        ],
                      ],
                    ),
                    Wrap(
                      children: [
                        Text(
                          movieDetails.genres
                              .map((genre) => genre.name)
                              .join(' , '),
                          style: textTheme.bodyMedium!,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Image.asset('images/imdb-icon.png', scale: 20),
                        Text(
                          "  ${movieDetails.voteAverage.toStringAsFixed(1)} / 10",
                          style: textTheme.titleMedium,
                        ),
                      ],
                    ),
                    StarRating(movieDetails.voteAverage),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideosPage(
                      movieid: movieDetails.id,
                      isTvShow: isTvShow,
                    ),
                  ),
                );
              },
              label: Text(S.of(context).watchvideosbuttonlabel),
              icon: const Icon(IconsaxOutline.play_circle),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 49, 39, 112),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Season/episode counts (TV) and the IMDb / like / watchlist / share row.
class _DetailActions extends StatelessWidget {
  const _DetailActions({
    required this.movieDetails,
    required this.isTvShow,
    required this.isLoggedIn,
  });

  final MovieModel movieDetails;
  final bool isTvShow;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    final titleLarge = Theme.of(context).textTheme.titleLarge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isTvShow) ...[
          Row(
            children: [
              const Icon(Icons.tv_rounded, color: Colors.white),
              Text(
                "${S.of(context).numberofseasons}: ${movieDetails.numberOfSeasons}",
                style: titleLarge,
              ),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.airplay_rounded, color: Colors.red),
              Text(
                "${S.of(context).numberofepisodes}: ${movieDetails.numberOfEpisodes}",
                style: titleLarge,
              ),
            ],
          ),
        ] else
          const SizedBox(height: 30),
        if (isLoggedIn) _buildActionRow(context),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context) {
    final box = Hive.box<LikedModel>('liked');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (movieDetails.imdbId != null)
          SquareTile(
            icon: SimpleIcons.imdb,
            label: "IMDb",
            onTap: () {
              launchUrlString(
                  'https://www.imdb.com/title/${movieDetails.imdbId}/');
            },
          ),
        // Rebuilds only the like tile when this entry changes in the box.
        ValueListenableBuilder<Box<LikedModel>>(
          valueListenable: box.listenable(keys: [movieDetails.id]),
          builder: (context, box, _) {
            final isLiked = box.get(movieDetails.id)?.isLiked == true;
            return SquareTile(
              icon: isLiked ? IconsaxBold.heart : IconsaxOutline.heart,
              label:
                  isLiked ? S.of(context).likednavbar : S.of(context).like,
              onTap: () {
                if (isLiked) {
                  // Remove instead of storing isLiked=false, so un-liked
                  // entries never sit in the box.
                  box.delete(movieDetails.id);
                } else {
                  box.put(
                    movieDetails.id,
                    LikedModel(
                      title: isTvShow
                          ? movieDetails.name!
                          : movieDetails.title!,
                      voteAverage: movieDetails.voteAverage,
                      posterPath: movieDetails.posterPath!,
                      isLiked: true,
                      genres:
                          movieDetails.genres.map((e) => e.name).toString(),
                      id: movieDetails.id,
                      isTvShow: isTvShow,
                    ),
                  );
                }
              },
            );
          },
        ),
        Watchlistwidget(movieid: movieDetails.id, istvshow: isTvShow),
        SquareTile(
          icon: Icons.share_rounded,
          label: S.of(context).share,
          onTap: () {
            SharePlus.instance.share(
              ShareParams(
                text:
                    "Check out this movie ${movieDetails.title} on Movie Night App\n\nhttps://www.themoviedb.org/movie/${movieDetails.id}",
              ),
            );
          },
        ),
      ],
    );
  }
}
