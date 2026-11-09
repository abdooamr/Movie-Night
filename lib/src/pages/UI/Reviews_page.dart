import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/segmented_toggle.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/pages/UI/all_reviews_page.dart';
import 'package:Movie_Night/src/widgets/global_Reviews.dart';
import 'package:Movie_Night/src/widgets/local_Reviews.dart';
import 'package:Movie_Night/src/widgets/review_card.dart';
import 'package:flutter/material.dart';

/// Brand name; deliberately not translated (no arb key exists for it).
const String _movieNightLabel = 'Movie Night';

class ReviewsPage extends StatefulWidget {
  final bool isTvShow;
  final int id;
  const ReviewsPage({super.key, required this.isTvShow, required this.id});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  bool _local = true;

  @override
  Widget build(BuildContext context) {
    final tmdb = S.of(context).tmdbLabel;
    final title = _local ? _movieNightLabel : tmdb;
    Widget seeAll(Stream<List<ReviewCardData>> stream,
            List<ReviewCardData> initial) =>
        AllReviewsPage(title: title, stream: stream, initialData: initial);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: MNSpace.lg),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SegmentedToggle<bool>(
            segments: [(true, _movieNightLabel), (false, tmdb)],
            selected: _local,
            onChanged: (v) => setState(() => _local = v),
          ),
        ),
        const SizedBox(height: MNSpace.md),
        if (_local)
          LocalReviewsWidget(
            id: widget.id,
            isTvShow: widget.isTvShow,
            seeAllBuilder: seeAll,
          )
        else
          GlobalReviewsWidget(
            isTvShow: widget.isTvShow,
            id: widget.id,
            seeAllBuilder: seeAll,
          ),
      ],
    );
  }
}
