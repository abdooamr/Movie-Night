import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/Cached_image.dart';
import 'package:Movie_Night/src/components/stars.dart';
import 'package:Movie_Night/src/models/moviedetails.dart';
import 'package:Movie_Night/src/pages/UI/detail_page.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';

import 'package:Movie_Night/src/utils/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BookmarkWidget extends StatelessWidget {
  final MovieModel movieDetails;
  final bool isTvShow;
  final VoidCallback onPressDelete;

  const BookmarkWidget({
    super.key,
    required this.movieDetails,
    required this.isTvShow,
    required this.onPressDelete,
  });

  @override
  Widget build(BuildContext context) {
    var genress = movieDetails.genres;

    return Column(
      children: [
        const SizedBox(height: 15),
        Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_) async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(S.of(context).deleteBookmark),
                      content: Text(
                        S.of(context).deleteBookmarkConfirmation,
                      ),
                      actionsPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(S.of(context).cancelLabel,
                              style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(S.of(context).delete,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    onPressDelete();
                  }
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: IconsaxBold.trash,
                label: S.of(context).delete,
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    id: movieDetails.id,
                    isTvShow: isTvShow,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 230,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedImageCustom(
                      movieDetails.posterPath == null
                          ? 'images/placeholder.png'
                          : '$imageUrl${movieDetails.posterPath!}',
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTvShow ? movieDetails.name! : movieDetails.title!,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Row(
                        children: [
                          Text(
                            "${movieDetails.voteAverage.toStringAsFixed(1)}  ",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          StarRating(movieDetails.voteAverage),
                        ],
                      ),
                      Text(
                        genress.map((genre) => genre.name).join(' , '),
                        style: Theme.of(context).textTheme.labelLarge!,
                      ),
                      Text(
                        movieDetails.overview,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.grey.shade400,
                            ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
