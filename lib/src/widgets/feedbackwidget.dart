import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:in_app_review/in_app_review.dart';

class Feedback_Widget extends StatelessWidget {
  final InAppReview _inAppReview = InAppReview.instance;

  Future<void> _openStoreReview(BuildContext context) async {
    if (await _inAppReview.isAvailable()) {
      // Open the store review popup
      await _inAppReview.requestReview();
    } else {
      // Handle the case where in-app reviews are not available
      // You can provide an alternative way for users to leave feedback
    }
  }

  Widget build(BuildContext context) => SimpleSettingsTile(
        //colorxz: Theme.of(context).listTileTheme.tileColor,
        title: "Send Feedback",
        subtitle: "",
        leading: Icon(
          IconsaxBold.arrow_up,
          color: Colors.purple,
        ),
        onTap: () {
          _openStoreReview(context); // Call the review function here
        },
      );
}
