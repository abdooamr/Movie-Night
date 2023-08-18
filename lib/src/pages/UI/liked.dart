import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/models/liked_model.dart';
import 'package:Movie_Night/src/pages/allpages.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Movie_Night/src/models/movie_model.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:Movie_Night/src/widgets/carousel_slider.dart';
import 'package:provider/provider.dart';

class Liked extends StatefulWidget {
  const Liked({super.key});

  @override
  State<Liked> createState() => _LikedState();
}

class _LikedState extends State<Liked> {
  late Future<Model> searchdetails;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Consumer<DropdownProvider>(
        builder: (context, dropdownProvider, child) {
      var lang = dropdownProvider.selectedValue;
      return ValueListenableBuilder(
        valueListenable: Hive.box<LikedModel>('liked').listenable(),
        builder: (context, Box<LikedModel> box, _) {
          if (box.isNotEmpty) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned.fill(
                  bottom: MediaQuery.of(context).size.height / 3,
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller: controller,
                    itemBuilder: (context, index) {
                      var liked = box.getAt(index);
                      return FadeInImage(
                        fit: BoxFit.fitWidth,
                        placeholder:
                            NetworkImage('$imageUrl${liked!.posterPath}'),
                        image: NetworkImage('$imageUrl${liked.posterPath}'),
                      );
                    },
                  ),
                ),
                Center(
                  child: MyCarouselSlider(
                    onPageChanged: (index, reason) {
                      controller.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastLinearToSlowEaseIn);
                    },
                    itemCount: box.values.length,
                    viewportFraction: .72,
                    aspectRatio: .7,
                    itemBuilder: (context, index, realindex) {
                      var liked = box.getAt(index);
                      if (!(liked?.isLiked ?? false)) {
                        liked!.delete();
                        controller.initialPage == index;
                      }

                      Widget content;

                      if (liked != null) {
                        content = FutureBuilder<Model>(
                          future: searchData(liked.title, lang),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(
                                color: Colors.deepPurpleAccent,
                                strokeWidth: 3,
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        id: liked.id,
                                        isTvShow: snapshot
                                                .data!.results[0].mediaType ==
                                            MediaType.tv,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(25),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 300,
                                          margin:
                                              const EdgeInsets.only(bottom: 25),
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  '$imageUrl${liked.posterPath}'),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          liked.title,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        // Stars
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(5, (i) {
                                            return Icon(
                                              Icons.star,
                                              color: i < (liked.voteAverage / 2)
                                                  ? Colors.amber
                                                  : Colors.grey,
                                            );
                                          }),
                                        ),
                                        const Spacer(),
                                        Expanded(
                                          child: Text(
                                            liked.genres,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        const Spacer(flex: 2),
                                        Expanded(
                                          child: IconButton(
                                            onPressed: () {
                                              liked.delete();
                                              if (box.values.length > 3) {
                                                controller.jumpToPage(index);
                                              } else if (box.values.length ==
                                                  2) {
                                                controller.jumpToPage(1);
                                              } else {
                                                controller.jumpToPage(0);
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.delete_sweep,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return Text('No data found.');
                            }
                          },
                        );
                      } else {
                        content = SizedBox();
                      }

                      return content;
                    },
                  ),
                ),
              ],
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.heart_broken,
                    color: Colors.red,
                    size: 70,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    S.of(context).ohnolabel,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 50),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  S.of(context).nolikedmovies,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
