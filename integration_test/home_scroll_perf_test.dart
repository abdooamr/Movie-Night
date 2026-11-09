import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/design/performance.dart';
import 'package:Movie_Night/src/pages/UI/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

/// Home scroll benchmark. Run in profile mode on a real device:
///
///   flutter drive --no-dds --profile --dart-define-from-file=env.json \
///     --driver=test_driver/perf_driver.dart \
///     --target=integration_test/home_scroll_perf_test.dart
///
/// Needs network (TMDB). Results: build/home_scroll.timeline_summary.json.
///
/// Add `--dart-define=FORCE_LOW_POWER=true` to measure the low-power tier.
/// The automatic monitor is not started here, so a normal run never
/// switches tiers mid-benchmark.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home scroll', (tester) async {
    // The TMDB disk cache needs Hive, as in main().
    await Hive.initFlutter();

    final performance = PerformanceMonitor(
      debugForceLowPower:
          const bool.fromEnvironment('FORCE_LOW_POWER') ? true : null,
    );
    addTearDown(performance.dispose);

    await tester.pumpWidget(
      PerformanceScope(
        notifier: performance,
        child: ChangeNotifierProvider(
          create: (_) => DropdownProvider(),
          child: MaterialApp(
            theme: buildAppTheme(Brightness.dark),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: const HomePage(),
          ),
        ),
      ),
    );

    // Wait (up to 20 s) until every section has left its skeleton.
    for (var i = 0; i < 200; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (i > 5 && find.byType(Shimmer).evaluate().isEmpty) break;
    }
    expect(find.byType(Shimmer), findsNothing, reason: 'Home never loaded');
    expect(find.byType(PageView), findsWidgets, reason: 'No hero carousel');
    await tester.pump(const Duration(seconds: 1)); // images settle

    final scroll = find.byType(CustomScrollView).first;
    final carousel = find.byType(PageView).first;
    final rail = find.byType(ListView).first;

    await binding.traceAction(() async {
      for (var i = 0; i < 3; i++) {
        await tester.fling(carousel, const Offset(-300, 0), 1500);
        await tester.pumpAndSettle();
      }
      for (var i = 0; i < 4; i++) {
        await tester.fling(scroll, const Offset(0, -600), 2000);
        await tester.pumpAndSettle();
      }
      for (var i = 0; i < 4; i++) {
        await tester.fling(scroll, const Offset(0, 600), 2000);
        await tester.pumpAndSettle();
      }
      for (var i = 0; i < 2; i++) {
        await tester.fling(rail, const Offset(-400, 0), 1500);
        await tester.pumpAndSettle();
      }
    }, reportKey: 'home_scroll');
  });
}
