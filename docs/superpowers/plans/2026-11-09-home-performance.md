# Home Screen Performance Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Home scroll smoothly and stay stable on weak and strong devices: no dropped frames from the glow, no full-page rebuilds on carousel swipes, no layout jumps on refresh, and a lighter mode that turns itself on when a device can't keep up.

**Architecture:** First measure (a profile-mode scroll benchmark), then remove the four causes found in the code (below), then add an automatic low-power tier fed by real frame timings. Each fix is its own task with a widget test; the benchmark is re-run at the end and the numbers recorded.

**Tech Stack:** Flutter 3.35.5 (Impeller on by default on iOS and Android), `cached_network_image`, `carousel_slider` 5, `shimmer`, `provider`, `integration_test` + `flutter_driver` (added as SDK dev deps).

**Spec:** No separate spec. The user's request ("more optimized and more stable to work on all devices with different power levels … improve the scrolling in the main page as sometimes it gets glitchy") plus the **Findings** below. The glow's look is fixed by `docs/ui-overhaul-design-system.md` › 8, which Task 2 updates.

## Findings (why Home stutters)

1. **The spill glow re-blurs on every scroll frame.** `lib/src/components/spill_glow.dart:89` wraps the poster in `ImageFiltered(blur σ 60)`. The 200 px decode is stretched to screen width first, so the blur runs at full device resolution (σ 60 logical ≈ 180 physical px at 3x), and during the 420 ms cross-fade it runs twice. The glow sits inside the scroll content, and Impeller has no raster cache, so the blur is recomputed on every frame the band is visible. That makes the top of Home, where scrolling starts, the most expensive part. Design doc § 8 says "one small texture per source", but the code doesn't do that. The detail page uses the same widget.
2. **Every carousel swipe rebuilds all of Home.** `home_page.dart:78-83` calls `setState` on `HomePage` for each centred item. That rebuilds the `CustomScrollView`, `SpillGlow`, `AnimatedSwitcher`, all four `FutureBuilder`s and every visible rail item, right when the user's finger lifts.
3. **Nothing on Home is lazy.** `home_page.dart:110` places all four sections in one `SliverToBoxAdapter(Column)`, so all rails, their shimmers and their images are built and laid out up front. The Movies/TV switch cross-fades two complete trees (8 sections) in an `AnimatedSwitcher` *while* `animateTo(0)` scrolls (`home_page.dart:70`).
4. **Pull-to-refresh makes the page jump.** `FutureBuilder` keeps the previous data when the future changes, but `upcoming.dart:112` and `movies_listview.dart:59` show the shimmer whenever the state is `waiting`, even with data in hand. Every section swaps content → skeleton → content, the page height changes under the user's finger, and `upcoming.dart:78` resets the dot index to 0 while the carousel stays on its page, so the dots and glow no longer match the poster.
5. **Posters download and upload more pixels than needed.** Every poster uses TMDB `w500` (`utils.dart:4`). A rail poster on a 2x phone needs about 340 px, and the glow needs about 64 px.

## Global Constraints

- Flutter 3.35.5; Dart SDK `>=3.0.6 <4.0.0`. No new pub.dev dependencies; `integration_test` and `flutter_driver` come from the SDK.
- Design tokens only: `test/design/token_lint_test.dart` must stay green (no `Color(0x`, `Colors.*`, `fontSize:`, `Duration(milliseconds`, `EdgeInsets.only(left|right` outside `lib/src/design/`).
- Glow look per design doc § 8: top-anchored 16:9 band, opacity `MNColors.glowOpacity` (0.55 dark / 0.30 light), gradient to `surface` over the full band, 420 ms (`MNDuration.long`) cross-fade on `MNCurves.standard`, instant under Reduce Motion, off under High Contrast, no glow when the image fails.
- Reduce Motion (`MNMotion.of(context).reduce`) keeps its current meaning everywhere.
- The Movies/TV switch keeps the TikTok-style text tabs shipped in the previous change (`_TypeSwitch` in `home_page.dart`).
- All of `flutter test` passes after every task; `flutter analyze` reports nothing new in touched files.

## Review Focus

- **Pull-to-refresh fails after data was shown:** the user expects the last good content to stay with a retry, not a blank section. Covered in Task 5 (`refresh error keeps the old rail and shows retry`).
- **Swiping the carousel, then refreshing:** the dots, the glow and the centred poster must agree. Covered in Task 5 (`refresh keeps the carousel page and dot index`).
- **Switching Movies ↔ TV while scrolled deep:** the list starts at the top of the new mode with no cross-faded double tree. Covered in Task 4 (`mode switch jumps to top and builds only the new mode`).
- **A device that is slow only for a moment** (app start, a GC pause, thermal spike): it must not drop into low-power mode. Covered in Task 7 (`one janky window does not degrade`).
- **The Hero flight from a rail to the detail page** after posters change size: there must be no grey placeholder mid-flight. Covered in Task 6 (`hero shuttle reuses the rail image`).

---

### Task 1: Scroll benchmark and baseline

**Files:**
- Modify: `pubspec.yaml` (dev_dependencies: `integration_test: {sdk: flutter}`, `flutter_driver: {sdk: flutter}`)
- Create: `integration_test/home_scroll_perf_test.dart`
- Create: `test_driver/perf_driver.dart`
- Create: `docs/perf/home-scroll.md` (results log)

**Interfaces:**
- Produces: the command `flutter drive --profile --dart-define-from-file=env.json --driver=test_driver/perf_driver.dart --target=integration_test/home_scroll_perf_test.dart`, which writes `build/home_scroll.timeline_summary.json`. Tasks 2–8 cite numbers from it.

- [ ] **Step 1: Write the benchmark.** `integration_test/home_scroll_perf_test.dart`: `IntegrationTestWidgetsFlutterBinding.ensureInitialized()`; pump `MaterialApp(theme: buildAppTheme(Brightness.dark), localizationsDelegates: …, home: ChangeNotifierProvider(create: (_) => DropdownProvider(), child: const HomePage()))`; wait up to 10 s for the first `MoviesListView` to show posters; then `binding.traceAction(reportKey: 'home_scroll', () async { … })` performing, in order: 3 carousel swipes (`tester.fling(find.byType(PageView).first, const Offset(-300, 0), 1500)`), 4 vertical flings down and 4 up on the `CustomScrollView` (`Offset(0, -600)` / `Offset(0, 600)`, velocity 2000, `pumpAndSettle` after each), 2 horizontal flings on the first rail's `ListView`.
- [ ] **Step 2: Write the driver.** `test_driver/perf_driver.dart` calls `integrationDriver(responseDataCallback:)`, builds `TimelineSummary.summarize(Timeline.fromJson(data['home_scroll']))` and `writeTimelineToFile('home_scroll', pretty: true, includeSummary: true)`.
- [ ] **Step 3: Record the baseline.** Run the command above on a real low-end Android phone (≈2 GB RAM, ideally 60 Hz) and on one mid/high-end device, 3 runs each. In `docs/perf/home-scroll.md`, log the median of `average_frame_build_time_millis`, `90th_percentile_frame_build_time_millis`, `average_frame_rasterizer_time_millis`, `90th_percentile_frame_rasterizer_time_millis`, `99th_percentile_frame_rasterizer_time_millis`, `missed_frame_build_budget_count`, `missed_frame_rasterizer_budget_count`, along with the device, refresh rate and commit. Expected: raster p90 over budget on the low-end device (Finding 1).
- [ ] **Step 4: Confirm `flutter test` still ignores `integration_test/`.** Run: `flutter test` → All tests passed.
- [ ] **Step 5: Commit** `test(perf): home scroll benchmark and baseline`.

### Task 2: Bake the spill glow once per source

**Files:**
- Create: `lib/src/components/glow_baker.dart`
- Modify: `lib/src/components/spill_glow.dart` (replace `_Glow`)
- Modify: `docs/ui-overhaul-design-system.md` § 8 "How it's built"
- Test: `test/components/glow_baker_test.dart`, `test/components/spill_glow_test.dart`

**Interfaces:**
- Produces: `Future<ui.Image?> bakeGlow(ImageProvider source, ImageConfiguration config)` returns a **64 × 36** image (16:9), with the source cover-cropped to the centre and drawn through `ImageFilter.blur(sigmaX: 8, sigmaY: 8, tileMode: TileMode.clamp)` (σ 8 at 64 px ≈ the spec's σ 60 across a ~480 dp band). It returns `null` if the image fails. Results are cached in an LRU of **24** entries keyed by `source` (provider equality). Callers get a `clone()` and dispose it; evicted originals are disposed by the cache. Also `@visibleForTesting void debugClearGlowCache()`.
- Produces: `SpillGlow` keeps its public API (`source`, `child`, `decodeWidth`, `blurSigma` removed → `bakeWidth = 64`, `bakeHeight = 36`, `bakeSigma = 8`).

- [ ] **Step 1: Write failing baker tests** in `glow_baker_test.dart` (use `tester.runAsync` and the 1×1 PNG from `spill_glow_test.dart`):
  - `bakes a 64x36 image`: `img!.width == 64 && img.height == 36`.
  - `same source hits the cache`: two calls with an equal `MemoryImage` resolve the provider once (count with a `MemoryImage` subclass that overrides `loadImage` and increments a counter).
  - `failed image returns null`: a `MemoryImage` of invalid bytes → `null`.
- [ ] **Step 2: Run** `flutter test test/components/glow_baker_test.dart` → FAIL (file missing).
- [ ] **Step 3: Implement `glow_baker.dart`.** Resolve `ResizeImage.resizeIfNeeded(64, null, source)` through an `ImageStream` into a `Completer`, draw onto a `PictureRecorder` canvas of 64×36 using `canvas.drawImageRect` with a centre cover crop and a `Paint` carrying the blur filter, then `picture.toImage(64, 36)`.
- [ ] **Step 4: Update `spill_glow_test.dart`** so it expects `RawImage` instead of `ImageFiltered`: high contrast and null source → `find.byType(RawImage)` findsNothing; `renders a baked glow behind the child` → after `tester.runAsync` + `pump`, `find.byType(RawImage)` findsOneWidget, `find.byType(ImageFiltered)` findsNothing, and a `RepaintBoundary` ancestor exists; `cross-fades to a new source` → two `RawImage` mid-fade at 100 ms, one after settle; add `failed image renders only the child`.
- [ ] **Step 5: Replace `_Glow`** with a `StatefulWidget` that bakes in `didChangeDependencies`/`didUpdateWidget` (when `image` changes), shows nothing until ready, then renders `RawImage(image: clone, fit: BoxFit.fill, filterQuality: FilterQuality.medium, opacity: AlwaysStoppedAnimation(opacity))`, and disposes its clone. Keep the `AnimatedSwitcher`, the gradient and the `RepaintBoundary` as they are.
- [ ] **Step 6: Run** `flutter test test/components` → PASS.
- [ ] **Step 7: Update design doc § 8** "How it's built" to: "The source is baked once into a 64 × 36 image (blur σ 8 at that size, cached, 24 entries) and stretched to the band with medium filtering. No live filter runs while scrolling."
- [ ] **Step 8: Check the look on a device** in light and dark against a screenshot taken before the change (Home and Detail). If the band looks blocky, raise `bakeWidth` to 96 / `bakeHeight` to 54 and `bakeSigma` to 12 together.
- [ ] **Step 9: Commit** `perf(glow): bake the spill glow once per source instead of blurring every frame`.

### Task 3: Carousel swipes stop rebuilding Home

**Files:**
- Modify: `lib/src/pages/UI/home_page.dart`
- Test: `test/pages/home_page_test.dart` (create)

**Interfaces:**
- Produces: `HomePage({super.key, @visibleForTesting this.fetch})`, where `final Future<Model> Function(HomeFeed feed, String lang)? fetch;` replaces the `switch` in `_fetch` when it is set. Tasks 4 and 5 use it.
- Produces: in `_HomePageState`, `final ValueNotifier<ImageProvider?> _glow` (replaces the `ImageProvider? _glow` field; disposed in `dispose`).

- [ ] **Step 1: Write the failing test** `carousel swipe does not rebuild the rails`: pump `HomePage(fetch: (f, _) async => _model(f, 10))` inside the `test/components/_harness.dart` app with a `ChangeNotifierProvider<DropdownProvider>` (posters `null`, so there's no network). Take `final before = tester.widget(find.byType(MoviesListView).first);`, `fling(find.byType(PageView).first, const Offset(-300, 0), 1500)`, `pumpAndSettle`, then `expect(identical(before, tester.widget(find.byType(MoviesListView).first)), isTrue)`.
- [ ] **Step 2: Run** `flutter test test/pages/home_page_test.dart` → FAIL (`fetch` param missing).
- [ ] **Step 3: Implement.** Add `fetch`; `_onFocus` sets `_glow.value` (no `setState`), and `_setMode` resets `_glow.value = null`. Around the hero section use `ValueListenableBuilder<ImageProvider?>(valueListenable: _glow, builder: (_, src, child) => SpillGlow(source: src, child: child!), child: …)` so the section is passed as `child` and does not rebuild.
- [ ] **Step 4: Run** `flutter test test/pages/home_page_test.dart` → PASS.
- [ ] **Step 5: Commit** `perf(home): carousel focus updates only the glow`.

### Task 4: Lazy sliver layout and an instant mode switch

**Files:**
- Modify: `lib/src/widgets/Home_page_listview.dart`, `lib/src/pages/UI/home_page.dart`
- Test: `test/pages/home_page_test.dart`

**Interfaces:**
- Consumes: `HomePage.fetch`, `_glow` (Task 3).
- Produces: `Home_page_listview` returns a sliver: `SliverMainAxisGroup(slivers: [SliverToBoxAdapter(child: heroSection), SliverList.list(children: rails)])`. A new required parameter `final Widget Function(Widget hero) wrapHero` lets `HomePage` put the `ValueListenableBuilder` + `SpillGlow` around the hero only. The glow band (16:9 of the width) is shorter than the hero section, so the look doesn't change.

- [ ] **Step 1: Write failing tests:**
  - `rails below the fold are not built`: with a 600 px-tall test surface, `tester.widgetList(find.byType(MoviesListView, skipOffstage: false)).length` is `lessThan(3)`; after `tester.scrollUntilVisible(find.text('<third rail title>'), 300)` it is found.
  - `mode switch jumps to top and builds only the new mode`: scroll down 800 px, tap the TV label, `pump()` once; `PrimaryScrollController.of(context).offset == 0`; `fetch` has received `HomeFeed.airingToday`; `find.byType(UpcomingMovies, skipOffstage: false)` findsOneWidget (no cross-faded second tree).
- [ ] **Step 2: Run** → FAIL.
- [ ] **Step 3: Implement.** Swap the `SliverToBoxAdapter` + `AnimatedSwitcher` in `HomePage` for `Home_page_listview(key: ValueKey(_isMovie), …)` placed directly in `slivers`. In `_setMode` use `controller.jumpTo(0)` instead of `animateTo` (TikTok swaps instantly, and a scroll animation plus a rebuild in the same frames is what stutters). Leave `cacheExtent` at the default for now (Task 7 tunes it).
- [ ] **Step 4: Run** `flutter test` → All tests passed.
- [ ] **Step 5: Commit** `perf(home): build sections lazily; instant Movies/TV switch`.

### Task 5: Refresh keeps what's on screen

**Files:**
- Modify: `lib/src/widgets/upcoming.dart:75-79,112`, `lib/src/widgets/movies_listview.dart:59`
- Test: `test/widgets/movies_listview_test.dart`, `test/widgets/upcoming_test.dart` (create)

**Interfaces:**
- Produces: a section shows its shimmer only when `!snapshot.hasData` and the state is `waiting`. While a new future is pending, the previous `snapshot.data` stays on screen.
- Produces: `_UpcomingMoviesState` and `MoviesListView` (which becomes a `StatefulWidget`) each keep a `Model? _lastGood`, set whenever a snapshot has data. On error with `_lastGood != null`, the section renders `_lastGood` plus a compact `ErrorState(onRetry:)` under it instead of replacing the content.

- [ ] **Step 1: Write failing tests:**
  - `refresh keeps the old rail visible` (movies_listview_test): pump with a completed `_model(5)`, then re-pump with a `Completer<Model>().future`; `find.text('Film 0')` findsOneWidget and `find.byType(movieListViewShimmerWidget)` findsNothing.
  - `refresh error keeps the old rail and shows retry` (same file): complete with data, re-pump with `Future.error(...)`, settle; `find.text('Film 0')` and the Try Again button are both found.
  - `refresh keeps the carousel page and dot index` (upcoming_test): swipe to page 2, re-pump with a new completed future holding the same items; the centred poster is still item 2 and `onFocusChanged` last received item 2.
- [ ] **Step 2: Run** → FAIL.
- [ ] **Step 3: Implement.** Change the waiting checks; drop the `_index.value = 0` reset in `didUpdateWidget` (clamp in `_reportInitial` already handles shorter lists); add `_lastGood` to both widgets.
- [ ] **Step 4: Run** `flutter test` → All tests passed.
- [ ] **Step 5: Commit** `fix(home): refresh keeps content and carousel position`.

### Task 6: Right-sized TMDB posters

**Files:**
- Modify: `lib/src/utils/utils.dart`, `lib/src/components/poster_card.dart`, `lib/src/widgets/upcoming.dart` (`_HeroPoster`), `lib/src/widgets/movies_listview.dart` (`_PosterRow`), `lib/src/pages/UI/home_page.dart` (`_onFocus`)
- Test: `test/utils/tmdb_image_test.dart` (create), `test/components/poster_card_test.dart`

**Interfaces:**
- Produces: `String tmdbImage(String path, double physicalWidth)` in `utils.dart` picks the smallest of `[92, 154, 185, 342, 500, 780]` that is `>= physicalWidth * 0.9`, falling back to 780, and returns `'https://image.tmdb.org/t/p/w$size$path'`. `imageUrl` stays for the screens that are not touched.
- Produces: `Widget railHeroShuttle(BuildContext, Animation<double>, HeroFlightDirection, BuildContext from, BuildContext to)` in `poster_card.dart` returns the rail side's `Hero.child` (`from` on push, `to` on pop). It's passed as `flightShuttleBuilder` on the rail/carousel Heroes so the flight always shows the image that's already decoded.

- [ ] **Step 1: Write failing tests.** `tmdbImage('/a.jpg', 40)` → `.../w92/a.jpg`; `(300)` → `w342`; `(510)` → `w500`; `(2000)` → `w780`. In poster_card_test, `hero shuttle reuses the rail image`: the `Hero` inside `PosterCard` has a non-null `flightShuttleBuilder`, and calling it with direction push returns the source Hero's child.
- [ ] **Step 2: Run** → FAIL.
- [ ] **Step 3: Implement.** Poster widgets already have `constraints.maxWidth` and can read `MediaQuery.devicePixelRatioOf`. Pass `tmdbImage(path, maxWidth * dpr)` to `CachedImageCustom`. Home's `_onFocus` builds the glow source with `tmdbImage(path, SpillGlow.bakeWidth.toDouble())` (→ `w92`, about 3 KB).
- [ ] **Step 4: Run** `flutter test` → All tests passed. On a device, check that a rail → detail → back Hero flight never shows a grey box.
- [ ] **Step 5: Commit** `perf(images): request TMDB poster sizes that match the display`.

### Task 7: Automatic low-power tier

**Files:**
- Create: `lib/src/design/performance.dart`
- Modify: `lib/src/design/motion.dart`, `lib/main.dart` (wrap `MaterialApp` in `PerformanceScope`), `lib/src/widgets/carousel_slider.dart:41`, `lib/src/components/pressable.dart`, `lib/src/components/cached_image.dart:64`, the 6 shimmer widgets that use `enabled: !MNMotion.of(context).reduce`, `lib/src/pages/UI/home_page.dart` (`cacheExtent`)
- Test: `test/design/performance_test.dart` (create), `test/design/motion_test.dart`

**Interfaces:**
- Produces: `bool isJankyWindow(List<FrameTiming> frames, Duration budget, {double ratio = 0.25})` is true when at least `ratio` of frames have `buildDuration > budget || rasterDuration > budget`.
- Produces: `class PerformanceMonitor extends ChangeNotifier` with `bool get lowPower`, `void start()`, `void stop()` and `PerformanceMonitor({bool? debugForceLowPower})`. It listens through `SchedulerBinding.instance.addTimingsCallback` in windows of **120 frames**, with budget `1 s / PlatformDispatcher.instance.views.first.display.refreshRate`. It turns `lowPower` on after **2 consecutive** janky windows and keeps it on for the session (no persistence; once on, it stops listening).
- Produces: `class PerformanceScope extends InheritedNotifier<PerformanceMonitor>` with `static bool lowPowerOf(BuildContext context)`, which is `false` when no scope is present, so existing tests are unaffected.
- Produces: `MNMotion({required bool reduce, bool lowPower = false})`; `MNMotion.of` also reads `PerformanceScope.lowPowerOf`; new getter `bool get allowRichMotion => !reduce && !lowPower`. `allowScale` keeps meaning only Reduce Motion, so Hero flights stay.
- Low power turns off: carousel `enlargeCenterPage` (uses `allowRichMotion`), the `PressableScale` press scale, image fade-in (`Duration.zero`) and shimmer sweeps (static). Home `cacheExtent` becomes `MediaQuery.sizeOf(context).height` normally and `0` in low power. The glow stays on in both tiers: after Task 2 it costs almost nothing, and it is the app's signature.

- [ ] **Step 1: Write failing tests** in `performance_test.dart` with synthetic `FrameTiming(vsyncStart:, buildStart:, buildFinish:, rasterStart:, rasterFinish:, rasterFinishWallTime:)`:
  - `a window with 30% slow frames is janky` / `a window with 10% slow frames is not`.
  - `one janky window does not degrade`: feed 120 slow + 120 fast frames → `lowPower == false`.
  - `two janky windows degrade and stay degraded`: feed 240 slow, then 240 fast → `lowPower == true`.
  - In `motion_test.dart`: `allowRichMotion is false under low power and under reduce motion`.
- [ ] **Step 2: Run** `flutter test test/design` → FAIL.
- [ ] **Step 3: Implement** `performance.dart` and the `MNMotion` change. In `main.dart`, create the monitor once and call `start()`. Switch the listed call sites to `allowRichMotion`.
- [ ] **Step 4: Add a widget test** `low power turns off carousel enlarge` (upcoming_test): wrap in `PerformanceScope(notifier: PerformanceMonitor(debugForceLowPower: true))`; `tester.widget<CarouselSlider>(…).options.enlargeCenterPage` is `false`.
- [ ] **Step 5: Run** `flutter test` → All tests passed.
- [ ] **Step 6: Commit** `feat(perf): automatic low-power tier from frame timings`.

### Task 8: Re-measure and record

**Files:**
- Modify: `docs/perf/home-scroll.md`, `docs/ui-overhaul-HANDOFF.md`

- [ ] **Step 1: Re-run the Task 1 benchmark** on the same devices (3 runs each), plus one run on the low-end device with `debugForceLowPower: true` wired through a `--dart-define=FORCE_LOW_POWER=true` read in `main.dart`.
- [ ] **Step 2: Record the before/after table.** Pass bar on the low-end device: raster p90 and build p90 under the frame budget (16.7 ms at 60 Hz), with `missed_frame_rasterizer_budget_count` down at least 70% from baseline. If raster is still over budget, check the timeline for `carousel_slider` item rebuilds before considering replacing it with a `PageView.builder`; that replacement is a separate plan.
- [ ] **Step 3: Note in the handoff** what low-power mode turns off and how to force it.
- [ ] **Step 4: Commit** `docs(perf): home scroll results after optimisation`.
