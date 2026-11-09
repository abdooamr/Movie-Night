import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Movie_Night/src/design/motion.dart';
import 'package:Movie_Night/src/design/performance.dart';
import 'package:Movie_Night/src/design/tokens.dart';

void main() {
  Future<MNMotion> motionFor(WidgetTester tester, bool disable) async {
    late MNMotion m;
    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(disableAnimations: disable),
      child: Builder(builder: (ctx) {
        m = MNMotion.of(ctx);
        return const SizedBox();
      }),
    ));
    return m;
  }

  testWidgets('reduce motion', (tester) async {
    final m = await motionFor(tester, true);
    expect(m(MNDuration.long), Duration.zero);
    expect(m.fade(MNDuration.long), MNDuration.short);
    expect(m.fade(MNDuration.micro), MNDuration.micro);
    expect(m.allowScale, isFalse);
  });

  testWidgets('normal motion', (tester) async {
    final m = await motionFor(tester, false);
    expect(m(MNDuration.long), MNDuration.long);
    expect(m.allowScale, isTrue);
  });

  Future<MNMotion> motionWith(WidgetTester tester,
      {required bool reduce, required bool lowPower}) async {
    late MNMotion m;
    final monitor = PerformanceMonitor(debugForceLowPower: lowPower);
    addTearDown(monitor.dispose);
    await tester.pumpWidget(PerformanceScope(
      notifier: monitor,
      child: MediaQuery(
        data: MediaQueryData(disableAnimations: reduce),
        child: Builder(builder: (ctx) {
          m = MNMotion.of(ctx);
          return const SizedBox();
        }),
      ),
    ));
    return m;
  }

  testWidgets(
      'allowRichMotion is false under low power and under reduce motion',
      (tester) async {
    expect(
        (await motionWith(tester, reduce: false, lowPower: false))
            .allowRichMotion,
        isTrue);
    final low = await motionWith(tester, reduce: false, lowPower: true);
    expect(low.allowRichMotion, isFalse);
    expect(low.lowPower, isTrue);
    // Low power leaves Reduce Motion's own rules alone: Hero and durations.
    expect(low.allowScale, isTrue);
    expect(low(MNDuration.long), MNDuration.long);
    expect(
        (await motionWith(tester, reduce: true, lowPower: false))
            .allowRichMotion,
        isFalse);
  });

  test('token values', () {
    expect(MNDuration.medium, const Duration(milliseconds: 280));
    expect(MNSprings.press.damping, 49);
    expect(MNSprings.pop.stiffness, 400);
    expect(MNRadius.mdAll, BorderRadius.circular(12));
  });
}
