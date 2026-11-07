# Verification — How to Measure the Improvements

**Capture the baseline BEFORE changing any code.** Record results in
`BASELINE_METRICS.md`. Without a before-number, none of the after-numbers mean
anything.

**Always profile on a physical mid-range Android device.** Debug mode and
emulators both lie about performance — debug builds are unoptimized, and
emulators don't reflect real GPU/thermal behaviour.

---

## Setup

```bash
flutter run --profile
```

Then open DevTools from the URL the command prints.

> Never measure in debug mode. Never draw conclusions from an emulator.

---

## 1. Network request counts  (C2, H3, H6, C5 — the biggest wins)

**Tool:** DevTools **Network** tab. Clear it, perform the action, count the rows.

| Scenario | Before (expected) | Target |
|---|---|---|
| Explore tab mount | ~80 | <= 5 (visible tab only) |
| Home cold load | ~34 | <= 12 |
| Liked page — scroll through 5 items | 1 per item **per rebuild** | 0 after first load |
| Watchlist — scroll 10 tiles | 1 per tile per rebuild | 0 after first load |
| Search — type "batman" (6 chars) | 6+ (one per keystroke) | 1 (debounced) |

This is the single most informative measurement in this document. The Explore
number alone should justify Phase 2.3.

---

## 2. Frame timing / jank  (M4, M7, M8)

**Tool:** DevTools **Performance** view, plus the performance overlay
(press `P` in the `flutter run` console).

Capture a timeline for each:
- Home cold load
- Movie <-> TV toggle on Home
- Explore tab mount and tab swipe
- Detail page open
- Liked page carousel scroll
- Scrolling a long movie list

**Target:** no frame crosses 16 ms (60 Hz) or 8 ms (120 Hz) during steady-state
scroll. Watch both bars in the overlay:

- **UI thread spikes** -> Dart work. Points at JSON parsing (M4) or oversized
  `build()` methods (H5).
- **Raster thread spikes** -> GPU work. Points at `BackdropFilter`/`saveLayer`
  (M7) in `Navbar.dart:62` and `upcoming.dart:136`.

Toggle **"Track widget rebuilds"** while switching Home's Movie/TV tabs — this
shows directly whether `Navbar.dart:43` is reconstructing all four pages (M11).

---

## 3. Memory and leaks  (C3, C4, M3)

**Tool:** DevTools **Memory** tab.

Procedure per screen:
1. Note the heap size.
2. Push and pop the screen **10 times**.
3. Force GC (the bin icon).
4. Take a heap snapshot and filter by class name.

| Screen | Watch for | Finding |
|---|---|---|
| Explore | retained `TabController` | C3 |
| Liked | retained `PageController` (one per rebuild!) | C4 |
| SendReport | retained `TextEditingController` | M3 |
| Search | retained `DropdownProvider` | C8 |

**Target:** instance count returns to its starting value after GC. Any growth
that survives GC is the leak.

Also watch the **image cache** line while scrolling posters — that is where M6
(`memCacheWidth`) shows up. A 500 px poster decoded for a 170 px slot costs
roughly 8.6x the pixels of one decoded at target size.

---

## 4. Startup time

```bash
flutter run --profile --trace-startup
```

Reads out to `build/start_up_info.json`. The number that matters:

- `timeToFirstFrameRasterizedMicros`

Compare before/after Phase 1 (asset removal, M13 shrinking) and after Phase 2.4
(lazy Home fetching). Run **3 times and take the median** — cold-start numbers
are noisy.

---

## 5. App size  (H9, M13)

```bash
flutter build apk --release --analyze-size
```

This opens a treemap showing exactly what is in the binary. Capture the total and
the asset-bundle portion.

**Expected after 1.2:** roughly -28 MB from deleted assets.
**Expected after 1.12:** additional reduction from R8 and resource shrinking.

Also build an app bundle, which is what users actually download:
```bash
flutter build appbundle --release --analyze-size
```

---

## 6. Static analysis and tests

```bash
flutter analyze          # must stay clean after 1.5 enables lints
dart fix --dry-run       # becomes meaningful only after 1.5
flutter test             # currently: "Test directory not found"
flutter test --coverage  # after 2.12
```

For coverage, `genhtml coverage/lcov.info -o coverage/html` gives a browsable
report. Don't chase a percentage — chase the model layer and the providers,
which is where regressions will actually bite.

---

## 7. Manual regression walkthrough

Run after **every** phase. These paths have no automated coverage and the
refactors in Phase 2 touch all of them:

- [ ] Cold start -> Home loads, both Movie and TV toggles
- [ ] Explore -> each of the 16 genre tabs renders
- [ ] Search -> type a query, open a movie, open a person
- [ ] Detail page -> poster zoom, videos, cast, providers, similar, reviews
- [ ] Like / unlike -> appears and disappears from the Liked page
- [ ] Watchlist -> add, remove via swipe, both Movies and TV tabs
- [ ] Login (email + Google), register, forgot password, logout
- [ ] Profile picture change **(iOS specifically — this is C7)**
- [ ] Write a review, delete own review
- [ ] Language switcher -> **all 7 locales** (ar is RTL — check layout)
- [ ] Dark/light toggle -> **and restart the app** to confirm it persisted (H2)
- [ ] Airplane mode -> at launch, and mid-session (M15/M16)
- [ ] Admin panel, if you have an admin account

---

## Reporting

For each change, record in `BASELINE_METRICS.md`:

```
Metric | Before | After | Delta
```

A change with no measurement is a guess. If a fix doesn't move its target metric,
that is worth knowing — it means the bottleneck is elsewhere.
