import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/section_header.dart';
import 'package:Movie_Night/src/components/segmented_toggle.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/pages/UI/all_reviews_page.dart';
import 'package:Movie_Night/src/widgets/global_Reviews.dart';
import 'package:Movie_Night/src/widgets/local_Reviews.dart';
import 'package:Movie_Night/src/widgets/review_card.dart';
import 'package:flutter/material.dart';

/// Brand name of the app's own reviews; not translated.
const String _movieNightLabel = 'Movie Night';

/// The detail page's Reviews section: a heading, a full-width source switch
/// (Movie Night's own reviews or TMDB's) and the chosen list, all on the
/// page margins. Everyone can read; writing needs an account.
class ReviewsPage extends StatefulWidget {
  const ReviewsPage({
    super.key,
    required this.isTvShow,
    required this.id,
    required this.isLoggedIn,
    required this.onRequireSignIn,
  });

  final bool isTvShow;
  final int id;
  final bool isLoggedIn;

  /// Opens the sign-in flow (from the "Log In to Write a Review" button).
  final VoidCallback onRequireSignIn;

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  bool _local = true;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final tmdb = s.tmdbLabel;
    final title = _local ? _movieNightLabel : tmdb;
    Widget seeAll(Stream<List<ReviewCardData>> stream,
            List<ReviewCardData> initial) =>
        AllReviewsPage(title: title, stream: stream, initialData: initial);
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: MNSpace.lg,
        bottom: MNSpace.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: s.reviewsTitle),
          const SizedBox(height: MNSpace.md),
          Padding(
            padding:
                const EdgeInsetsDirectional.symmetric(horizontal: MNSpace.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedToggle<bool>(
                  expand: true,
                  segments: [(true, _movieNightLabel), (false, tmdb)],
                  selected: _local,
                  onChanged: (v) => setState(() => _local = v),
                ),
                const SizedBox(height: MNSpace.md),
                if (_local)
                  LocalReviewsWidget(
                    id: widget.id,
                    isTvShow: widget.isTvShow,
                    isLoggedIn: widget.isLoggedIn,
                    onRequireSignIn: widget.onRequireSignIn,
                    seeAllBuilder: seeAll,
                  )
                else
                  GlobalReviewsWidget(
                    isTvShow: widget.isTvShow,
                    id: widget.id,
                    seeAllBuilder: seeAll,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
