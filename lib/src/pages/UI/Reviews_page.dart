import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/widgets/global_Reviews.dart';
import 'package:Movie_Night/src/widgets/local_Reviews.dart';
import 'package:Movie_Night/src/widgets/switch.dart';
import 'package:flutter/material.dart';

class ReviewsPage extends StatefulWidget {
  final bool isTvShow;
  final int id;
  ReviewsPage({required this.isTvShow, required this.id});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  bool Local = true;
  bool Global = false;
  late DropdownProvider dropdownProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Typeswitch(
          selectedcolor: Theme.of(context).textTheme.bodyLarge!.color!,
          unselectedcolor:
              Theme.of(context).textTheme.bodyLarge!.color! == Colors.white
                  ? Colors.grey.shade400
                  : Colors.grey.shade600,
          title1: S.of(context).globalreviewswitch,
          title2: S.of(context).localreviewswitch,
          movie: Local,
          tvshow: Global,
          onMovieSelected: () {
            setState(() {
              Local = true;
              Global = false;
            });
          },
          onTvShowSelected: () {
            setState(() {
              Local = false;
              Global = true;
            });
          },
        ),
        if (Local) LocalReviewsWidget(id: widget.id),
        if (Global)
          GlobalReviewsWidget(isTvShow: widget.isTvShow, id: widget.id)
      ],
    );
  }
}
