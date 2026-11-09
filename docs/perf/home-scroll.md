# Home scroll benchmark

Command (profile mode, real device, needs network and `env.json`):

```
flutter drive --no-dds --profile -d <device-id> \
  --dart-define-from-file=env.json \
  --driver=test_driver/perf_driver.dart \
  --target=integration_test/home_scroll_perf_test.dart
```

`--no-dds` is required: without it the test cannot reach the VM service
to record the timeline.

The run waits until Home has left every skeleton, then performs 3 carousel
flings, 4 flings down and 4 up on the page, and 2 on the first rail. Results
are in `build/home_scroll.timeline_summary.json`.

## Baseline (before any optimisation)

- Device: Samsung Galaxy A50 (SM-A505FN), Android 12, 60 Hz, Impeller (OpenGLES)
- Commit: a9f0ee1 plus the uncommitted Home / Search / Profile changes of 2026-11-09
- 3 runs, median shown

| Metric | Run 1 | Run 2 | Run 3 | Median |
| --- | --- | --- | --- | --- |
| average build ms | 2.62 | 2.71 | 2.53 | 2.62 |
| p90 build ms | 5.47 | 4.95 | 5.34 | 5.34 |
| average raster ms | 7.64 | 8.16 | 7.79 | 7.79 |
| p90 raster ms | 10.31 | 10.89 | 10.45 | 10.45 |
| p99 raster ms | 12.09 | 13.87 | 12.15 | 12.15 |
| missed build budget | 0 | 0 | 0 | 0 |
| missed raster budget | 0 | 0 | 0 | 0 |
| frames traced | 70 | 67 | 74 | 70 |

Frame budget at 60 Hz: 16.7 ms.

### Reading it

- The A50 stays inside the budget on this script, so it is a mid-range
  baseline, not a worst case. Raster is the heavier side (about 3x build),
  which matches the glow blur being the main cost (plan, Finding 1).
- Because nothing misses the budget, Task 8 cannot show a "missed frames
  down 70%" result. Compare average, p90 and p99 raster time instead.
- Still to record: the same run on a ~2 GB RAM phone and on a high-end
  phone.

## After Task 2 (baked spill glow)

Same device and script, 3 runs, median.

| Metric | Baseline | Task 2 | Change |
| --- | --- | --- | --- |
| average build ms | 2.62 | 2.78 | noise |
| p90 build ms | 5.34 | 5.49 | noise |
| average raster ms | 7.79 | 6.53 | -16% |
| p90 raster ms | 10.45 | 10.22 | noise |
| p99 raster ms | 12.15 | 12.76 | noise |
| missed raster budget | 0 | 0 | none |

The glow is only on screen near the top of Home, so the saving shows in
the average rather than the tail. Visual check on the A50 (dark): close to
the old look, slightly less bright at the very top. The hard line the old
blur left at the bottom edge of the band is gone.

## After Task 4 (lazy sections, instant mode switch)

Same device and script, 3 runs, median: build avg 2.78 / p90 5.78 ms, raster
avg 6.61 / p90 9.84 / p99 12.34 ms, no missed frames. Within noise of Task 2
(raster p90 10.22 -> 9.84). The script scrolls only within the first screens
and never switches mode, so the gain from not building off-screen rails is
mainly at startup and on weaker devices; the unit tests
(`test/pages/home_page_test.dart`) are what pin the behaviour.

## Final (Tasks 1-8)

Same device (A50, 60 Hz, Impeller GLES) and script, 3 runs each, median.

| Metric | Baseline | Final, normal | Final, low power | Rejected: full-screen pre-build |
| --- | --- | --- | --- | --- |
| average build ms | 2.62 | 2.98 | 3.24 | 3.17 |
| p90 build ms | 5.33 | 5.58 | 6.36 | 6.17 |
| average raster ms | 7.79 | 6.64 | 6.44 | 7.13 |
| p90 raster ms | 10.45 | 9.61 | 8.80 | 11.41 |
| p99 raster ms | 12.14 | 11.18 | 11.20 | 12.79 |
| missed build budget | 0.00 | 1.00 | 0.00 | 1.00 |
| missed raster budget | 0.00 | 0.00 | 0.00 | 0.00 |

- **Normal tier vs baseline:** average raster -15%, p90 raster -8%, p99
  raster -8%. Build time is up about 0.3 ms on average (more widgets now
  hold state, and the lazy list builds rails as they arrive) but stays
  around a third of the budget.
- **One slow build frame:** in 2 of 3 normal-tier runs one frame took
  ~19 ms to build (baseline worst: 8 ms; low power worst: 15.6 ms). Most
  likely a rail being built in a single frame as it scrolls into view: the
  baseline built every rail up front, before the trace started. One
  dropped frame per newly reached rail is the cost of the lazy list; worth
  a look with the timeline (`build/home_scroll.timeline.json`) if it shows
  on a weaker phone.
- **Low power** (`--dart-define=FORCE_LOW_POWER=true`) is the fastest
  configuration: p90 raster 8.8 ms.
- **Rejected:** Task 7 first set Home's `cacheExtent` to a full screen
  height in the normal tier. Measured, that made raster p90 worse
  (9.6 -> 11.4 ms) because more rails and posters are built and uploaded
  while scrolling, so the normal tier keeps Flutter's default. The last
  column is that rejected configuration, kept for the record.
- **Pass bar:** p90 build and raster are under the 16.7 ms budget in every
  configuration, and were already at baseline. The A50 is mid-range; a
  ~2 GB phone has not been measured.
- **Hero flight (Task 6):** checked on the A50 by capturing the screen
  0.2 s after tapping a poster of a title opened before: the flying poster
  shows the real image, with no grey box. On a *first* visit there is no
  flight at all, because the detail page builds its poster Hero only after
  its data loads (skeleton first). This predates this plan; see the
  handoff follow-ups.
