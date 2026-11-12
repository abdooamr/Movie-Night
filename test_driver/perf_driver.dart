import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:integration_test/integration_test_driver.dart';

/// Writes `build/home_scroll.timeline_summary.json` for the Home scroll
/// benchmark (`integration_test/home_scroll_perf_test.dart`).
Future<void> main() {
  return integrationDriver(
    responseDataCallback: (data) async {
      if (data == null) return;
      // Default run: complete per-phase frame times, the numbers to quote.
      final phases = {
        for (final entry in data.entries)
          if (entry.key.startsWith('phase_')) entry.key: entry.value,
      };
      if (phases.isNotEmpty) {
        await File('build/home_scroll.phases.json')
            .writeAsString(const JsonEncoder.withIndent('  ').convert(phases));
      }

      // TRACE run: the timeline.
      final traced = data['home_scroll'];
      if (traced == null) return;
      final timeline = Timeline.fromJson(traced as Map<String, dynamic>);
      final summary = TimelineSummary.summarize(timeline);
      // The summary throws when the kept tail of the timeline has no frames.
      var includeSummary = true;
      try {
        summary.summaryJson;
      } catch (_) {
        includeSummary = false;
      }
      await summary.writeTimelineToFile(
        'home_scroll',
        pretty: true,
        includeSummary: includeSummary,
      );
    },
  );
}
