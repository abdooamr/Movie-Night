import 'package:Movie_Night/src/components/Cached_image.dart';
import 'package:Movie_Night/src/models/Knownfor_model.dart';
import 'package:Movie_Night/src/pages/UI/detail_page.dart';

import 'package:flutter/material.dart';

import 'package:Movie_Night/src/utils/utils.dart';

class Cast_knownfor extends StatelessWidget {
  const Cast_knownfor({
    required this.future,
    required this.istvshow,
    Key? key,
    required this.headlineText,
  }) : super(key: key);
  final String headlineText;
  final bool istvshow;
  final Future<KnownFor> future;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<KnownFor>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data?.cast;
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headlineText,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 310,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        isTvShow: istvshow,
                                        index: index,
                                        id: data[index].id,
                                      ),
                                    ));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedImageCustom(
                                    height: 240,
                                    width: 170,
                                    '$imageUrl${data[index].posterPath}'
                                    // height: 240,
                                    // width: 170,
                                    ),
                                // child: Image.network(
                                //   '$imageUrl${data[index].posterPath}',
                                //   height: 240,
                                //   width: 170,
                                //   fit: BoxFit.cover,
                                //   errorBuilder: (context, error, stackTrace) {
                                //     return Container(
                                //       height: 240,
                                //       width: 170,
                                //       color: Colors.grey,
                                //     );
                                //   },
                                // ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: 170,
                              height: 50,
                              margin: const EdgeInsets.only(left: 5),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      data[index].title == null
                                          ? data[index].name.toString()
                                          : data[index].title.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  Text(data[index].character.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
