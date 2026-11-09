import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/components/feedback.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:Movie_Night/src/widgets/customsettingscreen.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

/// "Rate Movie Night": asks for an in-app review, then opens the store
/// listing. Works signed in or out.
class RateAppRow extends StatelessWidget {
  const RateAppRow({super.key});

  Future<void> _rate(BuildContext context) async {
    final failMsg = S.of(context).genericError;
    final review = InAppReview.instance;
    try {
      if (await review.isAvailable()) {
        await review.requestReview();
      }
      // In-app review may show nothing (quota, emulator): open the store too.
      await review.openStoreListing();
    } catch (e, st) {
      AppLog.error('openStoreListing', e, st);
      if (context.mounted) AppFeedback.error(context, failMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsRow(
      icon: IconsaxOutline.star,
      title: S.of(context).rateMovieNight,
      onTap: () => _rate(context),
    );
  }
}
