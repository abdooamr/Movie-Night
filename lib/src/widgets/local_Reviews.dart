import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/reviewsprovider.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/data/auth_repository.dart';
import 'package:Movie_Night/src/design/tokens.dart';
import 'package:Movie_Night/src/widgets/review_list.dart';
import 'package:Movie_Night/src/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Movie Night's own reviews of a title: the composer first (or a log-in
/// button when signed out), then the live list.
class LocalReviewsWidget extends StatefulWidget {
  const LocalReviewsWidget({
    super.key,
    required this.id,
    required this.isTvShow,
    required this.isLoggedIn,
    required this.onRequireSignIn,
    this.seeAllBuilder,
  });

  /// TMDB id of the title.
  final int id;

  /// Which page this is: TV and movie reviews are kept apart (old, untyped
  /// reviews show on both).
  final bool isTvShow;

  /// Signed-in users get the composer; everyone can read.
  final bool isLoggedIn;

  /// Opens the sign-in flow.
  final VoidCallback onRequireSignIn;

  final AllReviewsBuilder? seeAllBuilder;

  @override
  State<LocalReviewsWidget> createState() => _LocalReviewsWidgetState();
}

class _LocalReviewsWidgetState extends State<LocalReviewsWidget> {
  late ReviewProvider reviewProvider;
  final TextEditingController reviewController = TextEditingController();
  bool _sending = false;

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
    if (text.isEmpty || _sending) return;
    final failMsg = S.of(context).genericError;
    if (_me == null) {
      AppFeedback.error(context, failMsg);
      return;
    }
    setState(() => _sending = true);
    try {
      // Name, picture and date come from the profile and the row.
      await reviewProvider.saveReview(
          movieId: widget.id, isTv: widget.isTvShow, text: text);
      reviewController.clear();
      if (mounted) FocusScope.of(context).unfocus();
    } catch (_) {
      if (mounted) AppFeedback.error(context, failMsg);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.isLoggedIn)
          _Composer(
            controller: reviewController,
            sending: _sending,
            onSend: _send,
          )
        else
          OutlinedButton(
            onPressed: widget.onRequireSignIn,
            child: Text(s.logInToReview),
          ),
        const SizedBox(height: MNSpace.md),
        ReviewList(
          seeAllBuilder: widget.seeAllBuilder!,
          streamFactory: _stream,
          emptyText: s.beFirstToReview,
        ),
      ],
    );
  }
}

/// A borderless filled field that grows to four lines, with a round send
/// button that lights up once there is text.
class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    const noBorder = OutlineInputBorder(
      borderRadius: MNRadius.mdAll,
      borderSide: BorderSide.none,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: s.writeReview,
              isDense: true,
              contentPadding: const EdgeInsetsDirectional.symmetric(
                horizontal: MNSpace.lg,
                vertical: MNSpace.md,
              ),
              border: noBorder,
              enabledBorder: noBorder,
              focusedBorder: noBorder,
            ),
          ),
        ),
        const SizedBox(width: MNSpace.sm),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => IconButton.filled(
            tooltip: s.sendReviewTooltip,
            onPressed: value.text.trim().isEmpty || sending ? null : onSend,
            icon: const Icon(Icons.arrow_upward_rounded),
          ),
        ),
      ],
    );
  }
}
