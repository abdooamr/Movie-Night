import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/components/Cached_image.dart';
import 'package:Movie_Night/src/models/Knownfor_model.dart';
import 'package:Movie_Night/src/models/cast_model.dart';
import 'package:Movie_Night/src/Animation/CustomNavigationAnimation.dart';
import 'package:Movie_Night/src/widgets/cast_movies.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart';

class Cast_DetailPage extends StatefulWidget {
  Cast_DetailPage({
    Key? key,
    this.id,
  }) : super(key: key);

  final int? id;

  @override
  State<Cast_DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<Cast_DetailPage> {
  late Future<CastModel> details;
  late Future<KnownFor> castmovies;
  late Future<KnownFor> casttvshows;
  late DropdownProvider dropdownProvider;

  @override
  void initState() {
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    super.initState();
    details = getcastdetails(widget.id!, dropdownProvider.selectedValue);
    castmovies =
        getcastknownfor(widget.id!, false, dropdownProvider.selectedValue);
    casttvshows =
        getcastknownfor(widget.id!, true, dropdownProvider.selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<CastModel>(
        future: details,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).splashColor,
              strokeWidth: 3,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Access the movie details using 'snapshot.data'
            var castdetails = snapshot.data;
            if (castdetails == null) {
              return Center(child: Text('No data found'));
            }
            return CustomScrollView(
              // sliver app bar
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  expandedHeight: MediaQuery.of(context).size.height / 2.1,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: [
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                      StretchMode.fadeTitle,
                    ],
                    collapseMode: CollapseMode.parallax,
                    background: GestureDetector(
                      onTap: () {
                        PageTransitionBuilder.navigateWithCustomTransition(
                          context,
                          PhotoView(
                            imageProvider: NetworkImage(
                                '$imageUrl${castdetails.profilePath}'),
                          ),
                        );
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => PhotoView(
                        //       imageProvider: NetworkImage(
                        //           '$imageUrl${castdetails.profilePath}'),
                        //     ),
                        //   ),
                        // );
                      },
                      child: CachedImageCustom(
                        '$imageUrl${castdetails.profilePath}',
                      ),
                      // child: Image.network(
                      //   '$imageUrl${castdetails.profilePath}',
                      //   errorBuilder: (context, error, stackTrace) {
                      //     return Container(
                      //       color: Colors.grey,
                      //       child: const Center(child: Text('No Image')),
                      //     );
                      //   },
                      // ),
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
                                  castdetails.name!,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(IconsaxBold.calendar),
                                        Text(
                                          castdetails.birthday == null
                                              ? 'No birthday found'
                                              : DateFormat.yMMMd().format(
                                                  castdetails.birthday!),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        castdetails.deathday == null
                                            ? SizedBox(height: 0, width: 0)
                                            : Icon(IconsaxBold.danger),
                                        Text(
                                          castdetails.deathday == null
                                              ? ''
                                              : DateFormat.yMMMd().format(
                                                  castdetails.deathday!),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    launchUrlString(
                                        'https://www.imdb.com/name/${castdetails.imdbId}/');
                                  },
                                  label: Text("IMDB Profile"),
                                  icon: const Icon(Icons.link),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).splashColor,
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

                            const SizedBox(height: 12),
                            Text(
                              'biography',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),

                            Text(
                              castdetails.biography == null ||
                                      castdetails.biography!.isEmpty
                                  ? 'No biography found'
                                  : castdetails.biography!,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Cast_knownfor(
                                istvshow: false,
                                future: castmovies,
                                headlineText: "Movies Known For"),
                            Cast_knownfor(
                                istvshow: true,
                                future: casttvshows,
                                headlineText: "Tv Shows Known For"),

                            // Visibility(
                            //   visible: widget.isTvShow,
                            //   child: buy_provider_widget(
                            //     id: movieDetails.id,
                            //     isTvShow: widget.isTvShow,
                            //   ),
                            // ),
                            // CastWidget(
                            //   id: movieDetails.id,
                            //   isTvShow: widget.isTvShow,
                            // ),
                            // SimilarWidget(
                            //   data: widget.data,
                            //   index: widget.index,
                            //   isTvShow: widget.isTvShow,
                            // ),
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
