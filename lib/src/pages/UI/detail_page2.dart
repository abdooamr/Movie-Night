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
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_view/photo_view.dart';
import '../../models/movie_model.dart';

class DetailPage2 extends StatefulWidget {
  const DetailPage2({
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
  State<DetailPage2> createState() => _DetailPage2State();
}

class _DetailPage2State extends State<DetailPage2> {
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
    // var box = Hive.box<LikedModel>('liked');
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
                  actions: [],
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
                                  child: Container(
                                    width:
                                        120, // Adjust the width as per your requirement
                                    height:
                                        180, // Adjust the height as per your requirement
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        scale: 4,
                                        '$imageUrl${movieDetails.posterPath!}',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey,
                                            child: Center(
                                              child: Text('No Image'),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
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
                                              ? movieDetails.firstAirDate
                                                  .toString()
                                                  .substring(0, 4)
                                              : movieDetails.releaseDate
                                                  .toString()
                                                  .substring(0, 4),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(" . "
                                            " Duration: ${movieDetails.runtime}"),
                                      ],
                                    ),
                                    Container(
                                      width:
                                          220, // Adjust the width as per your requirement
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.start,
                                        children: [
                                          Text(
                                            genress
                                                .map((genre) => genre.name)
                                                .join(' , '),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'images/imdb-icon.png',
                                          scale: 17,
                                        ),
                                        Text(
                                          "  ${movieDetails.voteAverage.toStringAsFixed(1)} / 10",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                  ],
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
                            SizedBox(height: 5),
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
