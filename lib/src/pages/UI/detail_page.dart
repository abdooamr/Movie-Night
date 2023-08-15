import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/Cached_image.dart';
import 'package:Movie_Night/src/components/squaretile.dart';
import 'package:Movie_Night/src/components/stars.dart';
import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/widgets/Buy_provider.dart';
import 'package:Movie_Night/src/widgets/addtowatchlist.dart';
import 'package:Movie_Night/src/widgets/watch_provider.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    Key? key,
    this.data,
    this.index,
    this.creditData,
    this.id,
    required this.isTvShow,
  }) : super(key: key);

  final int? index;
  final int? id;
  final Model? data;
  final Credit? creditData;
  final bool isTvShow;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isloggedin = false;
  late Future<MovieModel> details;
  Future<bool> isLoggedIn() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    if (user != null) {
      return isloggedin = true;
    } else {
      return isloggedin = false;
    }
  }

  late DropdownProvider dropdownProvider;

  @override
  void initState() {
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    super.initState();
    isLoggedIn();
    details =
        getdetails(widget.id!, widget.isTvShow, dropdownProvider.selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<LikedModel>('liked');
    return Scaffold(
      body: FutureBuilder<MovieModel>(
        future: details,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.deepPurpleAccent,
              strokeWidth: 3,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Access the movie details using 'snapshot.data'
            var movieDetails = snapshot.data;
            var genress = movieDetails!.genres;
            if (snapshot.data == null) {
              return Center(child: Text('No data found'));
            }
            return CustomScrollView(
              // sliver app bar
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  actions: [],
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: [
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                      StretchMode.fadeTitle,
                    ],
                    collapseMode: CollapseMode.parallax,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, _) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        '$imageUrl${movieDetails.backdropPath ?? movieDetails.posterPath}'),
                                    fit: BoxFit.cover,
                                    opacity: 0.3),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        child: Container(
                                          width:
                                              120, // Adjust the width as per your requirement
                                          height:
                                              180, // Adjust the height as per your requirement
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 5,
                                                spreadRadius: 2,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),

                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedImageCustom(
                                              movieDetails.posterPath == null
                                                  ? 'images/placeholder.png'
                                                  : '$imageUrl${movieDetails.posterPath!}',
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Wrap(
                                              children: [
                                                Text(
                                                  widget.isTvShow
                                                      ? movieDetails.name!
                                                      : movieDetails.title!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  widget.isTvShow
                                                      ? movieDetails
                                                          .firstAirDate
                                                          .toString()
                                                          .substring(0, 4)
                                                      : movieDetails.releaseDate
                                                          .toString()
                                                          .substring(0, 4),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall,
                                                ),
                                                SizedBox(width: 4),
                                                widget.isTvShow == true
                                                    ? Row(
                                                        children: [
                                                          Text(
                                                            " ${movieDetails.status}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall!
                                                                .copyWith(
                                                                    fontSize:
                                                                        13),
                                                          ),
                                                        ],
                                                      )
                                                    : Row(
                                                        children: [
                                                          Text(" . "),
                                                          Text(
                                                            " ${movieDetails.runtime}" +
                                                                S
                                                                    .of(context)
                                                                    .minute,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall,
                                                          ),
                                                        ],
                                                      )
                                              ],
                                            ),
                                            // Adjust the width as per your requirement
                                            Wrap(
                                              children: [
                                                Text(
                                                  genress
                                                      .map(
                                                          (genre) => genre.name)
                                                      .join(' , '),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!,
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'images/imdb-icon.png',
                                                  scale: 20,
                                                ),
                                                Text(
                                                  "  ${movieDetails.voteAverage.toStringAsFixed(1)} / 10",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                              ],
                                            ),
                                            StarRating(
                                                movieDetails.voteAverage),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Videos_page(
                                              movieid: movieDetails.id,
                                              isTvShow: widget.isTvShow,
                                            ),
                                          ),
                                        );
                                      },
                                      label: Text(
                                          S.of(context).watchvideosbuttonlabel),
                                      icon: const Icon(
                                          IconsaxOutline.play_circle),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Color.fromARGB(255, 49, 39, 112),
                                        ),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.isTvShow
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.tv_rounded,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            S.of(context).numberofseasons +
                                                ": " +
                                                movieDetails.numberOfSeasons
                                                    .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      )
                                    : SizedBox(height: 15),
                                widget.isTvShow
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.airplay_rounded,
                                            color: Colors.red,
                                          ),
                                          Text(
                                            S.of(context).numberofepisodes +
                                                ": " +
                                                movieDetails.numberOfEpisodes
                                                    .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      )
                                    : SizedBox(height: 15),
                              ],
                            ),
                            isloggedin == false
                                ? SizedBox.shrink()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      movieDetails.imdbId == null
                                          ? SizedBox.shrink()
                                          : SquareTile(
                                              icon: SimpleIcons.imdb,
                                              label: "IMDb",
                                              onTap: () {
                                                launchUrlString(
                                                    'https://www.imdb.com/title/${movieDetails.imdbId}/');
                                              }),
                                      SquareTile(
                                        icon:
                                            box.get(movieDetails.id)?.isLiked ==
                                                    true
                                                ? IconsaxBold.heart
                                                : IconsaxOutline.heart,
                                        label: S.of(context).like,
                                        onTap: () {
                                          box.put(
                                            movieDetails.id,
                                            LikedModel(
                                              title: widget.isTvShow
                                                  ? movieDetails.name!
                                                  : movieDetails.title!,
                                              voteAverage:
                                                  movieDetails.voteAverage,
                                              posterPath:
                                                  movieDetails.posterPath!,
                                              isLiked: !(box
                                                      .get(movieDetails.id)
                                                      ?.isLiked ??
                                                  false),
                                              genres: genress
                                                  .map((e) => e.name)
                                                  .toString(),
                                              id: movieDetails.id,
                                            ),
                                          );
                                          setState(() {});
                                        },
                                      ),
                                      Watchlistwidget(
                                          movieid: movieDetails.id,
                                          istvshow: widget.isTvShow),
                                      // SquareTile(
                                      //     icon: IconsaxBold.bookmark,
                                      //     label: "Add to Watchlist",
                                      //     onTap: () {}),
                                      SquareTile(
                                          icon: Icons.share_rounded,
                                          label: S.of(context).share,
                                          onTap: () {
                                            Share.share(
                                              "Check out this movie ${movieDetails.title} on Movie Night App\n\nhttps://www.themoviedb.org/movie/${movieDetails.id}",
                                            );
                                          })
                                    ],
                                  ),
                            SizedBox(height: 5),
                            movieDetails.overview.isEmpty
                                ? SizedBox.shrink()
                                : Text(
                                    S.of(context).storyline,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                            movieDetails.overview.isEmpty
                                ? SizedBox.shrink()
                                : Text(
                                    movieDetails.overview,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                            const SizedBox(height: 25),

                            CastWidget(
                              id: movieDetails.id,
                              isTvShow: widget.isTvShow,
                            ),
                            watch_provider_widget(
                              id: movieDetails.id,
                              isTvShow: widget.isTvShow,
                            ),
                            Visibility(
                              visible: widget.isTvShow,
                              child: buy_provider_widget(
                                id: movieDetails.id,
                                isTvShow: widget.isTvShow,
                              ),
                            ),

                            SimilarWidget(
                              id: movieDetails.id,
                              isTvShow: widget.isTvShow,
                            ),
                            // ReviewsWidget(
                            //     isTvShow: widget.isTvShow,
                            //     id: movieDetails.id!),
                          ],
                        ),
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
