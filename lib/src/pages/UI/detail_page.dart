import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/widgets/Buy_provider.dart';
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
import '../../models/movie_model.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    Key? key,
    required this.data,
    required this.index,
    this.creditData,
    this.id,
    required this.isTvShow,
  }) : super(key: key);

  final int index;
  final int? id;
  final Model data;
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

  @override
  void initState() {
    super.initState();
    isLoggedIn();
    details = getdetails(widget.id!, widget.isTvShow);
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<LikedModel>('liked');
    return Scaffold(
      body: FutureBuilder<MovieModel>(
        future: details,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                  expandedHeight: MediaQuery.of(context).size.height / 2.1,
                  actions: [
                    isloggedin == true
                        ? Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: IconButton(
                              onPressed: () {
                                box.put(
                                  movieDetails.id,
                                  LikedModel(
                                    title: widget.isTvShow
                                        ? movieDetails.name!
                                        : movieDetails.title!,
                                    voteAverage: movieDetails.voteAverage,
                                    posterPath: movieDetails.posterPath!,
                                    isLiked:
                                        !(box.get(movieDetails.id)?.isLiked ??
                                            false),
                                    genres:
                                        genress.map((e) => e.name).toString(),
                                  ),
                                );
                                setState(() {});
                              },
                              icon: box.get(movieDetails.id)?.isLiked ?? false
                                  ? const Icon(IconsaxBold.heart)
                                  : const Icon(IconsaxOutline.heart),
                            ),
                          )
                        : const SizedBox(width: 0)
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: [
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                      StretchMode.fadeTitle,
                    ],
                    collapseMode: CollapseMode.parallax,
                    background: GestureDetector(
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
                      child: Image.network(
                        '$imageUrl${movieDetails.posterPath!}',
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey,
                            child: const Center(child: Text('No Image')),
                          );
                        },
                      ),
                    ),
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
                            Wrap(
                              children: [
                                Text(
                                  widget.isTvShow
                                      ? movieDetails.name!
                                      : movieDetails.title!,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                            Wrap(
                              children: List.generate(
                                genress.length,
                                (genreIndex) => Padding(
                                  padding:
                                      const EdgeInsets.only(right: 10, top: 4),
                                  child: Chip(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    side: const BorderSide(width: 0),
                                    backgroundColor:
                                        kBackgoundColor.withOpacity(.9),
                                    label: Text(
                                      "${genress[genreIndex].name}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.white70),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(IconsaxBold.calendar),
                                Text(
                                  widget.isTvShow
                                      ? movieDetails.firstAirDate
                                          .toString()
                                          .substring(0, 4)
                                      : movieDetails.releaseDate
                                          .toString()
                                          .substring(0, 4),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(width: 10),
                                const Icon(IconsaxBold.star),
                                Text(
                                  "IMDB: ${movieDetails.voteAverage.toStringAsFixed(1)}",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                ElevatedButton.icon(
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
                                  label: Text("Watch Videos"),
                                  icon: const Icon(IconsaxOutline.play_circle),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 49, 39, 112),
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                            "  Number of Seasons: " +
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
                                            "  Number of Episodes: " +
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
                            const SizedBox(height: 12),
                            Text(
                              'Story Line',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),

                            Text(
                              movieDetails.overview,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 25),
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
                            CastWidget(
                              id: movieDetails.id,
                              isTvShow: widget.isTvShow,
                            ),
                            SimilarWidget(
                              data: widget.data,
                              index: widget.index,
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
