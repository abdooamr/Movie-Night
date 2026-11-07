import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Movie_Night/src/design/motion.dart';
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

  test('token values', () {
    expect(MNDuration.medium, const Duration(milliseconds: 280));
    expect(MNSprings.press.damping, 49);
    expect(MNSprings.pop.stiffness, 400);
    expect(MNRadius.mdAll, BorderRadius.circular(12));
  });
}
