import 'package:flutter/material.dart';

import '../../design/tokens.dart';
import '../../widgets/review_card.dart';

/// Every review for a title, as a lazy list. [initialData] is what the inline
/// section had already loaded, so the page opens without a spinner.
class AllReviewsPage extends StatelessWidget {
  const AllReviewsPage({
    super.key,
    required this.title,
    required this.stream,
    this.initialData,
  });

  final String title;
  final Stream<List<ReviewCardData>> stream;
  final List<ReviewCardData>? initialData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Semantics(header: true, child: Text(title))),
      body: SafeArea(
        child: StreamBuilder<List<ReviewCardData>>(
          stream: stream,
          initialData: initialData,
          builder: (context, snapshot) {
            final data = snapshot.data ?? const <ReviewCardData>[];
            return ListView.builder(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: MNSpace.lg,
                vertical: MNSpace.sm,
              ),
              itemCount: data.length,
              itemBuilder: (context, i) => ReviewCard.fromData(data[i]),
            );
          },
        ),
      ),
    );
  }
}
