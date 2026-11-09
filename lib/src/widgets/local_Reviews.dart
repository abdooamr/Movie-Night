import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/reviewsprovider.dart';
import 'package:Movie_Night/src/components/app_text_field.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/data/auth_repository.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/widgets/review_list.dart';
import 'package:Movie_Night/src/widgets/review_card.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocalReviewsWidget extends StatefulWidget {
  const LocalReviewsWidget({
    super.key,
    required this.id,
    required this.isTvShow,
    this.seeAllBuilder,
  });

  /// TMDB id of the title.
  final int id;

  /// Which page this is: TV and movie reviews are kept apart (old, untyped
  /// reviews show on both).
  final bool isTvShow;

  final AllReviewsBuilder? seeAllBuilder;

  @override
  State<LocalReviewsWidget> createState() => _LocalReviewsWidgetState();
}

class _LocalReviewsWidgetState extends State<LocalReviewsWidget> {
  late ReviewProvider reviewProvider;
  final TextEditingController reviewController = TextEditingController();

  /// Read when used, never cached: the user can sign out while this page
  /// stays open.
  String? get _me => AuthRepository.instance.currentUserId;

  @override
  void initState() {
    super.initState();
    reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  Stream<List<ReviewCardData>> _stream() {
    return reviewProvider.getReviews(widget.id, isTv: widget.isTvShow).map(
          (reviews) => [
            for (final r in reviews)
              ReviewCardData(
                id: r.id,
                author: r.displayname,
                date: r.createdat,
                body: r.review ?? '',
                avatarUrl: r.ProfilePic,
                onDelete: r.id.isNotEmpty && r.id == _me ? _delete : null,
              ),
          ],
        );
  }

  Future<void> _delete() async {
    final failMsg = S.of(context).genericError;
    try {
      await reviewProvider.deleteReview(
          movieId: widget.id, isTv: widget.isTvShow);
    } catch (_) {
      if (mounted) AppFeedback.error(context, failMsg);
    }
  }

  Future<void> _send() async {
    final text = reviewController.text.trim();
    if (text.isEmpty) return;
    final failMsg = S.of(context).genericError;
    if (_me == null) {
      AppFeedback.error(context, failMsg);
      return;
    }
    try {
      // Name, picture and date come from the profile and the row.
      await reviewProvider.saveReview(
          movieId: widget.id, isTv: widget.isTvShow, text: text);
      reviewController.clear();
    } catch (_) {
      if (mounted) AppFeedback.error(context, failMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReviewList(seeAllBuilder: widget.seeAllBuilder!, streamFactory: _stream),
        const SizedBox(height: MNSpace.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField(
                controller: reviewController,
                label: S.of(context).writeReview,
                kind: AppFieldKind.multiline,
              ),
            ),
            const SizedBox(width: MNSpace.sm),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: reviewController,
              builder: (context, value, _) => IconButton.filled(
                tooltip: S.of(context).sendReviewTooltip,
                onPressed: value.text.trim().isEmpty ? null : _send,
                icon: const Icon(IconsaxOutline.send_2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
