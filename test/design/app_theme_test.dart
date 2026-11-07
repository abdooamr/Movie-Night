import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/design/typography.dart';

void main() {
  final theme = buildAppTheme(Brightness.dark);

  test('type scale', () {
    final t = theme.textTheme;
    expect(t.bodyLarge!.fontSize, 17);
    expect(t.labelSmall!.fontSize, 11);
    expect(t.displaySmall!.fontFamily, 'poppins');
    expect(t.bodyLarge!.fontFamily, isNull);
    expect(t.titleLarge!.height, closeTo(25 / 20, 0.001));
    expect(t.displaySmall!.fontWeight, FontWeight.w700);
    expect(t.labelMedium!.fontWeight, FontWeight.w500);
  });

  test('highContrast makes onSurfaceVariant == onSurface', () {
    final hc = buildAppTheme(Brightness.light, highContrast: true).colorScheme;
    expect(hc.onSurfaceVariant, hc.onSurface);
    final normal = buildAppTheme(Brightness.light).colorScheme;
    expect(hc.outline, normal.onSurfaceVariant);
  });

  test('emboldenTextTheme raises weights one step', () {
    final t = buildTextTheme(theme.colorScheme.onSurface);
    final b = emboldenTextTheme(t);
    expect(b.bodyLarge!.fontWeight, FontWeight.w500);
    expect(b.titleMedium!.fontWeight, FontWeight.w700);
    expect(b.displaySmall!.fontWeight, FontWeight.w800);
    expect(b.bodyLarge!.fontSize, 17);
  });

  test('every role is set; only display and headline roles use Poppins', () {
    final t = theme.textTheme;
    final roles = {
      "displayLarge": t.displayLarge,
      "displayMedium": t.displayMedium,
      "displaySmall": t.displaySmall,
      "headlineLarge": t.headlineLarge,
      "headlineMedium": t.headlineMedium,
      "headlineSmall": t.headlineSmall,
      "titleLarge": t.titleLarge,
      "titleMedium": t.titleMedium,
      "titleSmall": t.titleSmall,
      "bodyLarge": t.bodyLarge,
      "bodyMedium": t.bodyMedium,
      "bodySmall": t.bodySmall,
      "labelLarge": t.labelLarge,
      "labelMedium": t.labelMedium,
      "labelSmall": t.labelSmall,
    };
    expect(roles.length, 15);
    roles.forEach((name, s) {
      expect(s, isNotNull, reason: name);
      final poppins = name.startsWith("display") ||
          name.startsWith("headline") ||
          name == "titleLarge";
      expect(s!.fontFamily, poppins ? "poppins" : isNull, reason: name);
    });
  });

  test('page transitions', () {
    final b = theme.pageTransitionsTheme.builders;
    expect(b[TargetPlatform.iOS], isA<CupertinoPageTransitionsBuilder>());
    expect(
        b[TargetPlatform.android], isA<PredictiveBackPageTransitionsBuilder>());
  });

  test('component themes', () {
    expect(theme.useMaterial3, isTrue);
    expect(theme.filledButtonTheme.style!.minimumSize!.resolve({}),
        const Size(48, 50));
    expect(theme.appBarTheme.scrolledUnderElevation, 0);
    expect(theme.snackBarTheme.behavior, SnackBarBehavior.floating);
    expect(theme.inputDecorationTheme.filled, isTrue);
  });

  test('boldText emboldens component themes, not just textTheme', () {
    final bold = buildAppTheme(Brightness.dark, boldText: true);
    FontWeight? w(ThemeData t) =>
        t.filledButtonTheme.style!.textStyle!.resolve({})!.fontWeight;
    expect(w(theme), FontWeight.w600);
    expect(w(bold), FontWeight.w700);
    expect(bold.listTileTheme.titleTextStyle!.fontWeight,
        isNot(theme.listTileTheme.titleTextStyle!.fontWeight));
    expect(bold.appBarTheme.titleTextStyle!.fontWeight,
        isNot(theme.appBarTheme.titleTextStyle!.fontWeight));
  });

  testWidgets('applyAccessibilityTheme emboldens under MediaQuery.boldText',
      (tester) async {
    Future<FontWeight?> weightFor(bool boldText) async {
      FontWeight? result;
      await tester.pumpWidget(MediaQuery(
        data: MediaQueryData(boldText: boldText),
        child: Theme(
          data: theme,
          child: Builder(
            builder: (context) => applyAccessibilityTheme(
              context,
              Builder(builder: (context) {
                result = Theme.of(context)
                    .filledButtonTheme
                    .style!
                    .textStyle!
                    .resolve({})!
                    .fontWeight;
                return const SizedBox();
              }),
            ),
          ),
        ),
      ));
      return result;
    }

    expect(await weightFor(false), FontWeight.w600);
    expect(await weightFor(true), FontWeight.w700);
  });
}
