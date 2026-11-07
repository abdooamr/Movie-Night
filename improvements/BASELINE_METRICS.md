# Baseline Metrics

**Fill the "Before" column in BEFORE changing any code.**
See `VERIFICATION.md` for how to capture each number.

Device used: _______________________  (model, Android/iOS version)
Build mode: `--profile`  ·  Date captured: ___________

> Run every timing measurement 3x and record the median. Cold-start and
> frame numbers are noisy.

---

## Network request counts

Tool: DevTools Network tab — clear, perform action, count rows.

| Scenario | Before | After P1 | After P2 | Target |
|---|---|---|---|---|
| Explore tab mount | | | | <= 5 |
| Home cold load | | | | <= 12 |
| Home Movie->TV toggle | | | | 0 (cached) |
| Liked — scroll 5 items | | | | 0 after first load |
| Watchlist — scroll 10 tiles | | | | 0 after first load |
| Search "batman" (6 keystrokes) | | | | 1 |
| Detail page open | | | | no change expected |

---

## Startup

`flutter run --profile --trace-startup` -> `build/start_up_info.json`

| Metric | Before | After P1 | After P2 | 
|---|---|---|---|
| `timeToFirstFrameRasterizedMicros` | | | |
| `timeToFirstFrameMicros` | | | |
| `engineEnterTimestampMicros` | | | |

---

## App size

`flutter build apk --release --analyze-size`

| Metric | Before | After 1.2 (assets) | After 1.12 (R8) |
|---|---|---|---|
| Total APK | | | |
| Asset bundle portion | | | |
| Total AAB (`build appbundle`) | | | |

Expected: roughly **-28 MB** from the asset deletion alone.

---

## Frame timing

Tool: DevTools Performance view. Record worst-frame and whether any frame
exceeds the budget during steady-state scroll.

| Scenario | Before (worst ms) | After | Jank frames? |
|---|---|---|---|
| Home cold load | | | |
| Home Movie/TV toggle | | | |
| Explore tab mount | | | |
| Explore tab swipe | | | |
| Detail page open | | | |
| Liked carousel scroll | | | |
| Long movie list scroll | | | |

Note UI-thread vs raster-thread separately — they point at different fixes
(see `VERIFICATION.md` section 2).

---

## Memory / leaks

Procedure: push+pop screen 10x, force GC, snapshot, filter by class.

| Screen | Class watched | Instances before | Instances after | Finding |
|---|---|---|---|---|
| Explore | `TabController` | | | C3 |
| Liked | `PageController` | | | C4 |
| SendReport | `TextEditingController` | | | M3 |
| Search | `DropdownProvider` | | | C8 |

Target: count returns to its starting value after GC.

| Metric | Before | After |
|---|---|---|
| Image cache size while scrolling posters | | |
| Heap after 10x Explore push/pop + GC | | |

---

## Static analysis

| Command | Before | After 1.5 | After P1 |
|---|---|---|---|
| `flutter analyze` issue count | 22 (all info) | | |
| `dart fix --dry-run` fixable count | 0 | | |
| `flutter test` | no test dir | | |
| Test coverage % | 0 | | |

---

## Notes and surprises

Record anything that contradicts the audit, or a fix that didn't move its
target metric — that means the bottleneck is somewhere else and is worth knowing.

>
