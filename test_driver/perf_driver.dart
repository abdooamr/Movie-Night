import 'package:flutter_driver/flutter_driver.dart';
import 'package:integration_test/integration_test_driver.dart';

/// Writes `build/home_scroll.timeline_summary.json` for the Home scroll
/// benchmark (`integration_test/home_scroll_perf_test.dart`).
Future<void> main() {
  return integrationDriver(
    responseDataCallback: (data) async {
      if (data == null) return;
      final timeline = Timeline.fromJson(
        data['home_scroll'] as Map<String, dynamic>,
      );
      final summary = TimelineSummary.summarize(timeline);
      await summary.writeTimelineToFile(
        'home_scroll',
        pretty: true,
        includeSummary: true,
      );
    },
  );
}
