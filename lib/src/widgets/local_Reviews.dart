import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/reviewsprovider.dart';
import 'package:Movie_Night/src/components/app_text_field.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/models/local_review_model.dart';
import 'package:Movie_Night/src/widgets/review_list.dart';
import 'package:Movie_Night/src/widgets/review_card.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LocalReviewsWidget extends StatefulWidget {
  const LocalReviewsWidget({super.key, required this.id, this.seeAllBuilder});

  final int id;

  final AllReviewsBuilder? seeAllBuilder;

  @override
  State<LocalReviewsWidget> createState() => _LocalReviewsWidgetState();
}

class _LocalReviewsWidgetState extends State<LocalReviewsWidget> {
  late ReviewProvider reviewProvider;
  final TextEditingController reviewController = TextEditingController();
  final currentuser = FirebaseAuth.instance.currentUser!;
  late DateFormat dateFormat;

  @override
  void initState() {
    super.initState();
    dateFormat = DateFormat('dd-MM-yyyy');
    reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  Stream<List<ReviewCardData>> _stream() {
    return reviewProvider.getReviews(widget.id.toString()).map(
          (reviews) => [
            for (final r in reviews)
              ReviewCardData(
                id: r.id,
                author: r.displayname,
                date: r.createdat,
                body: r.review ?? '',
                avatarUrl: r.ProfilePic,
                onDelete: currentuser.uid == r.id ? _delete : null,
              ),
          ],
        );
  }

  Future<void> _delete() async {
    final failMsg = S.of(context).genericError;
    try {
      await reviewProvider.deleteReview(
        movieId: widget.id.toString(),
        userId: currentuser.uid,
      );
    } catch (_) {
      if (mounted) AppFeedback.error(context, failMsg);
    }
  }

  Future<void> _send() async {
    final text = reviewController.text.trim();
    if (text.isEmpty) return;
    final failMsg = S.of(context).genericError;
    final localReview = Localreviews(
      ProfilePic: currentuser.photoURL ?? '',
      review: text,
      displayname: currentuser.displayName!,
      email: currentuser.email!,
      createdat: dateFormat.format(DateTime.now()),
      id: currentuser.uid,
    );
    try {
      await reviewProvider.addReview(
        movieId: widget.id.toString(),
        userId: currentuser.uid,
        localReview: localReview,
      );
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
