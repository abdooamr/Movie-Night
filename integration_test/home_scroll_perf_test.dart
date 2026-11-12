import 'dart:developer' show Timeline;

import 'package:Movie_Night/generated/l10n.dart';
import 'package:Movie_Night/src/Provider/langprovider.dart';
import 'package:Movie_Night/src/design/app_theme.dart';
import 'package:Movie_Night/src/components/glass.dart';
import 'package:Movie_Night/src/design/performance.dart';
import 'package:Movie_Night/src/pages/UI/home_page.dart';
import 'package:Movie_Night/src/widgets/Navbar/chrome_bar.dart';
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
/// Needs network (TMDB). Results: build/home_scroll.phases.json (complete
/// frame times per phase). On the owner's phone follow the safe procedure in
/// docs/perf/home-scroll.md, or the run uninstalls the app.
///
/// `--dart-define=LIVE_FRAMES=true` draws every settle frame, as in real use;
/// `--dart-define=TRACE=true` records the timeline instead (see below).
/// Add `--dart-define=FORCE_LOW_POWER=true` to measure the low-power tier,
/// `--dart-define=WITH_TAB_BAR=true` to include the floating tab bar, and
/// `--dart-define=NO_BLUR=true` to draw the glass opaque (its blur's cost).
/// The automatic monitor is not started here, so a normal run never
/// switches tiers mid-benchmark.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home scroll', (tester) async {
    // The TMDB disk cache needs Hive, as in main().
    await Hive.initFlutter();

    const withTabBar = bool.fromEnvironment('WITH_TAB_BAR');
    GlassSurface.debugForceOpaque = const bool.fromEnvironment('NO_BLUR');

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
            // As the app shell provides it (Home v2's ambient light and top
            // layer follow it), optionally with the floating tab bar.
            home: PrimaryScrollController(
              controller: ScrollController(),
              child: withTabBar
                  ? Scaffold(
                      extendBody: true,
                      body: const HomePage(signedIn: false),
                      bottomNavigationBar: ChromeBar(
                        selectedIndex: 0,
                        onDestinationSelected: (_) {},
                        destinations: const [
                          NavigationDestination(
                              icon: Icon(Icons.home), label: 'Home'),
                          NavigationDestination(
                              icon: Icon(Icons.search), label: 'Search'),
                          NavigationDestination(
                              icon: Icon(Icons.favorite), label: 'Library'),
                          NavigationDestination(
                              icon: Icon(Icons.person), label: 'Profile'),
                        ],
                      ),
                    )
                  : const HomePage(signedIn: false),
            ),
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
    expect(find.byType(PageView), findsWidgets, reason: 'No featured title');
    await tester.pump(const Duration(seconds: 1)); // images settle

    final scroll = find.byType(CustomScrollView).first;
    final carousel = find.byType(PageView).first;
    final rail = find.byType(ListView).first;

    // With LIVE_FRAMES the engine draws every frame of a settling scroll, as
    // on a phone in use. Without it the test draws one frame per
    // `pumpAndSettle` step (every ~117 ms), each carrying several frames'
    // worth of new content.
    if (const bool.fromEnvironment('LIVE_FRAMES')) {
      binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
    }

    // Default: complete frame times per phase (`phase_<name>` in the report,
    // written to build/home_scroll.phases.json). These are the numbers to
    // quote.
    //
    // With TRACE: the timeline instead (build/home_scroll.timeline.json), to
    // see what a slow frame spent its time on. The two cannot be combined
    // (`watchPerformance` resets the timeline), and the timeline is a ring
    // buffer holding only the last ~4 s unless `flutter drive` is given
    // `--endless-trace-buffer`.
    const trace = bool.fromEnvironment('TRACE');

    Future<void> phase(String name, int count, Finder target, Offset offset,
        double speed) {
      Future<void> flings() async {
        for (var i = 0; i < count; i++) {
          await tester.fling(target, offset, speed);
          await tester.pumpAndSettle();
        }
      }

      if (trace) {
        Timeline.instantSync('phase_$name');
        return flings();
      }
      return binding.watchPerformance(flings, reportKey: 'phase_$name');
    }

    Future<void> script() async {
      await phase('1_featured', 3, carousel, const Offset(-300, 0), 1500);
      await phase('2_page_down', 4, scroll, const Offset(0, -600), 2000);
      await phase('3_page_up', 4, scroll, const Offset(0, 600), 2000);
      await phase('4_rail', 2, rail, const Offset(-400, 0), 1500);
    }

    if (trace) {
      await binding.traceAction(script, reportKey: 'home_scroll');
    } else {
      await script();
    }
  });
}
