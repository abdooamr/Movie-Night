import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/services/services.dart';
import 'package:Movie_Night/src/utils/utils.dart';
import 'package:Movie_Night/src/widgets/review_card.dart';
import 'package:Movie_Night/src/widgets/review_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GlobalReviewsWidget extends StatefulWidget {
  const GlobalReviewsWidget(
      {super.key, required this.isTvShow, required this.id, this.seeAllBuilder});
  final int id;
  final bool isTvShow;

  final AllReviewsBuilder? seeAllBuilder;
  @override
  State<GlobalReviewsWidget> createState() => _GlobalReviewsWidgetState();
}

class _GlobalReviewsWidgetState extends State<GlobalReviewsWidget> {
  late DropdownProvider dropdownProvider;

  @override
  void initState() {
    dropdownProvider = Provider.of<DropdownProvider>(context, listen: false);
    super.initState();
  }

  Stream<List<ReviewCardData>> _stream() {
    final dates = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    return Stream.fromFuture(
      getReviews(widget.id, widget.isTvShow, dropdownProvider.selectedValue),
    ).map((review) {
      return [
        for (final r in review.results)
          ReviewCardData(
            id: r.id,
            author: r.author,
            date: dates.format(r.createdAt),
            body: r.content,
            avatarUrl: _avatar(r.authorDetails.avatarPath),
          ),
      ];
    }).asBroadcastStream();
  }

  /// TMDB avatar paths are either relative or a full (gravatar) URL.
  String? _avatar(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('/http')) return path.substring(1);
    return '$imageUrl$path';
  }

  @override
  Widget build(BuildContext context) {
    return ReviewList(seeAllBuilder: widget.seeAllBuilder!, streamFactory: _stream);
  }
}
