import 'package:flutter/material.dart';
import 'package:Movie_Night/src/models/video_model.dart';
import 'package:Movie_Night/src/pages/UI/detail_page.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/movie_model.dart';

class Videos_list extends StatelessWidget {
  const Videos_list({
    required this.future,
    Key? key,
    required this.headlineText,
  }) : super(key: key);
  final String headlineText;
  final Future<Video> future;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Video>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data?.results;
          return Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    reverse: false,
                    physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                    scrollDirection: Axis.vertical,
                    itemCount: data!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  "https://img.youtube.com/vi/${data[index].key}/0.jpg",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  launchUrlString(
                                      "https://www.youtube.com/watch?v=${data[index].key}");
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 120, vertical: 70),
                                  child: const Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white54,
                                    size: 130,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              child: Text(
                            data[index].name,
                            style: Theme.of(context).textTheme.titleLarge,
                          )),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          throw snapshot.error.toString();
        } else {
          return Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
