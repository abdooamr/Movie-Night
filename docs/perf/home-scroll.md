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

## Home v2 (branch feat/home-v2, 2026-11-12)

Home v2 replaces the carousel with an edge-to-edge featured title, adds an
ambient light behind the page, a glass type switch, and a floating glass tab
bar on Android too. The script now takes `--dart-define=WITH_TAB_BAR=true`
(Home inside a Scaffold with the floating `ChromeBar`, as in the app) and
`--dart-define=NO_BLUR=true` (glass drawn opaque). **Always pass
`--keep-app-running`:** without it `flutter drive` uninstalls the app when it
finishes, which wiped the owner's on-phone data on 2026-11-12. Profile builds
are debug-signed, so installing one over a release build also uninstalls it
first; sign the profile build type like release for the run, or warn first.

Same device (A50, 60 Hz, Impeller GLES), with the tab bar, medians:

| Configuration | Runs | raster avg | raster p90 | raster p99 | frames over budget |
| --- | --- | --- | --- | --- | --- |
| Home v2 as first built (real blur on Android) | 1 | 17.84 | 20.00 | 20.19 | 55 of 71 |
| Home v2, glass drawn opaque (`NO_BLUR`) | 1 | 7.54 | 11.08 | 13.77 | 0 of 77 |
| Home v2 final (tint on Android, cheap light and fades) | 5 | 7.48 | 11.59 | 16.12 | 2 of ~105 |
| Old Home from main, same script, same day | 5 | 7.11 | 10.30 | 13.79 | 0 of ~80 |

- The backdrop blur was almost all of the cost: Android now draws glass as a
  denser tint without blur (`GlassSurface`); iOS keeps the blur.
- Also changed, for cost not looks: the ambient light fades by painting the
  page colour over its ends and moves by translation (no mask, no relayout);
  the top fade is one gradient with interpolated colours (no Opacity layers);
  the featured image fades with a gradient overlay instead of a ShaderMask,
  decodes at most 780 px wide, and the next title is built ahead
  (`allowImplicitScrolling`).
- What remains is fill: a full-screen poster plus the light. The two slow
  frames per run fall where new posters upload while scrolling. The old Home
  issued far more save layers (its animated dots) and still drew faster.
- Run-to-run spread is large (raster avg 6.3 to 8.7 ms across the five final
  runs) because posters arrive from the network during the trace.

## Correction: what the numbers above cover (2026-11-12, later)

Every table above this line was computed from the timeline, which is a ring
buffer of about 32,000 events: it held only the **last ~4 s** of the 16 s
script (the last upward fling and the two rail flings, 70 to 105 frames out
of about 480). The featured flings and the page-down flings were never in
those numbers, for the old Home either.

The script now reports complete frame times per phase
(`build/home_scroll.phases.json`), and takes two more defines:

- `LIVE_FRAMES=true`: the engine draws every frame of a settling scroll.
  Without it the test draws one settle frame every ~117 ms, each carrying
  about seven frames' worth of new content.
- `TRACE=true`, with `flutter drive --endless-trace-buffer`: the whole
  timeline instead of the per-phase numbers (the two cannot be combined).

Safe way to run on the owner's phone (app data kept across six runs):
add a `profile` build type signed with the release config, `flutter build apk
--profile ... --target=integration_test/home_scroll_perf_test.dart`, confirm
with `apksigner verify --print-certs` that it has the release certificate,
then `flutter drive --use-application-binary=<apk> --keep-app-running ...`.
Afterwards remove the build type and `adb install -r` the release APK.

Home v2 with the tab bar, A50, frames over 16.7 ms of raster time:

| Phase | Old pacing (2 runs) | `LIVE_FRAMES` (2 runs) |
| --- | --- | --- |
| Featured flings | 0 of 83, 0 of 83 | 1 of 180, 0 of 181 |
| Page down | 0 of 157, 1 of 157 | 1 of 251, 2 of 253 |
| Page up | 13 of 170, 11 of 175 | 41 of 324, 37 of 276 |
| Rail flings | 1 of 70, 1 of 70 | 0 of 126, 0 of 126 |

- **The "2 slow frames" of the table above** are in the settle of the first
  rail fling. They are frames the test draws 117 ms apart, each adding a
  batch of new text to the glyph atlas (4 to 8 ms) on top of new posters.
  Drawn at the real frame rate the rail phase has none over budget (worst
  14.4 and 14.8 ms).
- **Page up** is the new finding. In every run, frames 2 and 3 of the first
  upward fling (starting from the bottom of the page) take 17 to 19 ms, each
  inside a single GL render pass, with no build, text, texture or layer work
  in them. The 30 to 140 frames that follow each measure almost exactly one
  refresh interval (16.2 to 16.9 ms): their drawing takes 5 to 8 ms and the
  rest is the raster thread waiting to hand the frame to the display, which
  is one frame behind. Those are counted as over budget but are not dropped
  frames.

### Old Home, same full run (main at 2e4f8fd, with the tab bar, `LIVE_FRAMES`)

Frames over 16.7 ms of raster time, two runs each:

| Phase | Old Home | Home v2 |
| --- | --- | --- |
| Featured flings | 62 of 185, 40 of 184 | 1 of 180, 0 of 181 |
| Page down | 3 of 260, 6 of 259 | 1 of 251, 2 of 253 |
| Page up | 0 of 414, 1 of 295 | 41 of 324, 37 of 276 |
| Rail flings | 24 of 135, 0 of 140 | 0 of 126, 0 of 126 |
| Whole run | 89 of 994, 47 of 878 | 43 of 881, 39 of 836 |

- The old Home shows the same pattern (one or two slow frames, then a long
  run of frames at exactly one refresh interval), so it is not something
  Home v2 introduced. It lands elsewhere: at the start of the carousel
  flings in both runs, and once each in the rails and in page down.
- The old carousel also has frames of 20 to 23 ms at its start, slower than
  anything in Home v2.
- Still not determined: what the one or two slow frames that start each run
  are waiting on. The count of frames over budget mostly measures how long
  the display stays one frame behind afterwards, so it overstates what is
  seen. Presented-frame times from SurfaceFlinger would give the number of
  frames actually shown late.
