import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:Movie_Night/src/widgets/Buy_provider.dart';
import 'package:Movie_Night/src/widgets/watch_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/credit_model.dart';
import 'package:Movie_Night/src/repository/Getvideos.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:Movie_Night/src/widgets/allwidget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/movie_model.dart';

class DetailPage extends StatefulWidget {
  const DetailPage(
      {Key? key,
      required this.data,
      required this.index,
      this.creditData,
      required this.isTvShow})
      : super(key: key);
  final int index;
  final Model data;
  final Credit? creditData;
  final bool isTvShow;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Model> VideoFuture;

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<LikedModel>('liked');
    return Scaffold(
        body: CustomScrollView(
      // sliver app bar
      slivers: [
        SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          expandedHeight: MediaQuery.of(context).size.height / 2.1,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                  onPressed: () {
                    box.put(
                        widget.data.results[widget.index].id,
                        LikedModel(
                            title: widget.data.results[widget.index].title ??
                                widget.data.results[widget.index].name!,
                            genres: widget.data.results[widget.index].genreIds!,
                            voteAverage:
                                widget.data.results[widget.index].voteAverage!,
                            posterPath:
                                widget.data.results[widget.index].posterPath!,
                            isLiked: !(box
                                    .get(
                                      widget.data.results[widget.index].id,
                                    )
                                    ?.isLiked ??
                                false)));
                    setState(() {});
                  },
                  icon: box
                              .get(
                                widget.data.results[widget.index].id,
                              )
                              ?.isLiked ??
                          false
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border)),
            )
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Image.network(
              '$imageUrl${widget.data.results[widget.index].posterPath}',
              fit: BoxFit.scaleDown,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Center(child: Text('No Image')),
                );
              },
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((ctx, _) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    Text(
                      widget.data.results[widget.index].title ??
                          widget.data.results[widget.index].name!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),

                Wrap(
                  children: List.generate(
                      widget.data.results[widget.index].genreIds!.length,
                      (genreIndex) => Padding(
                            padding: const EdgeInsets.only(right: 10, top: 4),
                            child: Chip(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              side: const BorderSide(width: 0),
                              backgroundColor: kBackgoundColor.withOpacity(.9),
                              label: Text(
                                getGenres(widget
                                        .data.results[widget.index].genreIds!)
                                    .split(',')
                                    .elementAt(genreIndex),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.white70),
                              ),
                            ),
                          )),
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.date_range,
                    ),
                    Text(
                      widget.data.results[widget.index].releaseDate == null
                          ? widget.data.results[widget.index].firstAirDate
                              .toString()
                              .substring(0, 4)
                          : widget.data.results[widget.index].releaseDate
                              .toString()
                              .substring(0, 4),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(Icons.star),
                    Text(
                        "IMDB: " +
                            widget.data.results[widget.index].voteAverage
                                .toString(),
                        style: Theme.of(context).textTheme.titleMedium),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Videos_page(
                                      movieid:
                                          widget.data.results[widget.index].id,
                                      isTvShow: widget.isTvShow,
                                    )));
                      },
                      child: Text("Watch Videos"),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 49, 39, 112)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                    )
                  ],
                ),

                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Story Line',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.data.results[widget.index].overview!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 25,
                ),
                watch_provider_widget(
                  id: widget.data.results[widget.index].id!,
                  isTvShow: widget.isTvShow,
                ),
                Visibility(
                  visible: (widget.isTvShow == true) ? false : true,
                  child: buy_provider_widget(
                      id: widget.data.results[widget.index].id!,
                      isTvShow: widget.isTvShow),
                ),
                CastWidget(
                  id: widget.data.results[widget.index].id!,
                  isTvShow: widget.isTvShow,
                ),
                //Videoxx(id: widget.data.results[widget.index].id!),
                SimilarWidget(
                    data: widget.data,
                    index: widget.index,
                    isTvShow: widget.isTvShow),
                ReviewsWidget(
                    isTvShow: widget.isTvShow,
                    id: widget.data.results[widget.index].id!),
              ],
            ),
          );
        }, childCount: 1))
      ],
    ));
  }
}
