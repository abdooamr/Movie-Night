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
