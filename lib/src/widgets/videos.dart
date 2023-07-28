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
        var data = snapshot.data?.results;
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: data!.length,
                    shrinkWrap: false,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  children: [
                                    Text(
                                      data[index].name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Image.network(
                                          "https://img.youtube.com/vi/${data[index].key}/0.jpg",
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey,
                                              child: const Center(
                                                  child: Text(
                                                'No Image',
                                                style: TextStyle(fontSize: 50),
                                              )),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  launchUrlString(
                                      "https://www.youtube.com/watch?v=${data[index].key}");
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 120, vertical: 65),
                                  child: const Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white54,
                                    size: 130,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('No Videos'),
          );
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
