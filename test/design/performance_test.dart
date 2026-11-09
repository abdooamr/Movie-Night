import 'dart:ui' show FrameTiming;

import 'package:Movie_Night/src/design/performance.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const _budget = Duration(microseconds: 16667);

/// A frame whose build and raster phases take [buildUs] / [rasterUs].
FrameTiming _frame({int buildUs = 4000, int rasterUs = 6000}) => FrameTiming(
      vsyncStart: 0,
      buildStart: 0,
      buildFinish: buildUs,
      rasterStart: buildUs,
      rasterFinish: buildUs + rasterUs,
      rasterFinishWallTime: buildUs + rasterUs,
    );

final _fast = _frame();
final _slowRaster = _frame(rasterUs: 25000);
final _slowBuild = _frame(buildUs: 25000);

List<FrameTiming> _window({required int slow, required int total}) => [
      for (var i = 0; i < total; i++) i < slow ? _slowRaster : _fast,
    ];

PerformanceMonitor _monitor() => PerformanceMonitor(
      budget: _budget,
      warmUpFrames: 0,
    );

void main() {
  group('isJankyWindow', () {
    test('a window with 30% slow frames is janky', () {
      expect(isJankyWindow(_window(slow: 36, total: 120), _budget), isTrue);
    });

    test('a window with 10% slow frames is not', () {
      expect(isJankyWindow(_window(slow: 12, total: 120), _budget), isFalse);
    });

    test('a slow build counts as much as a slow raster', () {
      final frames = [
        for (var i = 0; i < 120; i++) i < 40 ? _slowBuild : _fast,
      ];
      expect(isJankyWindow(frames, _budget), isTrue);
    });

    test('an empty window is not janky', () {
      expect(isJankyWindow(const [], _budget), isFalse);
    });
  });

  group('PerformanceMonitor', () {
    test('one janky window does not degrade', () {
      final m = _monitor();
      m.debugAddTimings(_window(slow: 120, total: 120));
      m.debugAddTimings(_window(slow: 0, total: 120));
      expect(m.lowPower, isFalse);
      m.dispose();
    });

    test('janky windows separated by a good one do not degrade', () {
      final m = _monitor();
      m.debugAddTimings(_window(slow: 120, total: 120));
      m.debugAddTimings(_window(slow: 0, total: 120));
      m.debugAddTimings(_window(slow: 120, total: 120));
      expect(m.lowPower, isFalse);
      m.dispose();
    });

    test('two janky windows degrade and stay degraded', () {
      final m = _monitor();
      var notified = 0;
      m.addListener(() => notified++);
      m.debugAddTimings(_window(slow: 240, total: 240));
      expect(m.lowPower, isTrue);
      m.debugAddTimings(_window(slow: 0, total: 240));
      expect(m.lowPower, isTrue);
      expect(notified, 1);
      m.dispose();
    });

    test('warm-up frames are ignored', () {
      final m = PerformanceMonitor(budget: _budget, warmUpFrames: 120);
      // A slow start-up (one window's worth) followed by smooth frames.
      m.debugAddTimings(_window(slow: 120, total: 120));
      m.debugAddTimings(_window(slow: 120, total: 120));
      expect(m.lowPower, isFalse);
      m.debugAddTimings(_window(slow: 120, total: 120));
      expect(m.lowPower, isTrue);
      m.dispose();
    });

    test('debugForceLowPower starts in low power', () {
      final m = PerformanceMonitor(debugForceLowPower: true);
      expect(m.lowPower, isTrue);
      m.dispose();
    });

    test('frameBudgetFor follows the refresh rate', () {
      expect(frameBudgetFor(60), const Duration(microseconds: 16667));
      expect(frameBudgetFor(120), const Duration(microseconds: 8333));
      expect(frameBudgetFor(0), const Duration(microseconds: 16667));
    });
  });

  group('PerformanceScope', () {
    testWidgets('lowPowerOf is false without a scope', (tester) async {
      late bool low;
      await tester.pumpWidget(Builder(builder: (context) {
        low = PerformanceScope.lowPowerOf(context);
        return const SizedBox();
      }));
      expect(low, isFalse);
    });

    testWidgets('dependents rebuild when the monitor degrades', (tester) async {
      final m = _monitor();
      addTearDown(m.dispose);
      final seen = <bool>[];
      await tester.pumpWidget(PerformanceScope(
        notifier: m,
        child: Builder(builder: (context) {
          seen.add(PerformanceScope.lowPowerOf(context));
          return const SizedBox();
        }),
      ));
      m.debugAddTimings(_window(slow: 240, total: 240));
      await tester.pump();
      expect(seen, [false, true]);
    });
  });
}
