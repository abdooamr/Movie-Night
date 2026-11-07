# Movie Night — Improvement Plan

Generated from a full code review & optimization audit on **2026-11-06**
against commit on branch `main`, app version `1.5.8+39`.

## What's in this folder

| File | Purpose |
|---|---|
| `STEP_MANUAL_GUIDE.md` | **START HERE** — follow-along checklist: what you do by hand vs what Claude does, with model per task |
| `RUNBOOK.md` | Detailed reference behind the checklist |
| `PROMPT.md` | Paste-ready prompts to resume work |
| `AUDIT_REPORT.md` | Full findings: architecture summary, tooling output, every issue with `file:line` |
| `PHASE_1_QUICK_WINS.md` | 13 low-risk / high-impact tasks. Safe to start immediately. |
| `PHASE_2_REFACTORS.md` | 12 structural tasks. Needs the open questions answered first. |
| `PHASE_3_POLISH.md` | 8 polish tasks. Do last. |
| `VERIFICATION.md` | How to measure before/after (DevTools, profile mode, metrics to capture) |
| `OPEN_QUESTIONS.md` | 3 decisions needed from the project owner before Phase 2 |
| `BASELINE_METRICS.md` | Empty template — fill in BEFORE changing any code |

## How to use this

1. Read `OPEN_QUESTIONS.md` and write your answers into it.
2. Run the baseline captures in `VERIFICATION.md`, record them in `BASELINE_METRICS.md`.
3. Paste `PROMPT.md` into a new Claude Code session.
4. Work phase by phase. Tick checkboxes as you go — the files are the progress tracker.

## Severity legend

- **Critical** — crashes, leaks, security exposure, or request storms. Fix first.
- **High** — material perf/correctness problems or missing safety nets.
- **Medium** — real but bounded cost.
- **Low** — hygiene and polish.

## Headline numbers

- **0 tests** exist. `flutter test` reports no `test/` directory.
- **Linting is effectively disabled** — `flutter_lints` is mis-indented in `pubspec.yaml` and is not actually a dependency; `analysis_options.yaml` has no `include:` line.
- **28.5 MB of 30 MB** in `images/` is unreferenced by any Dart file.
- **~80 sequential HTTP requests** fire when the Explore tab mounts.
- **TMDB API key is hardcoded** in source at `lib/src/services/services.dart:12`.
  *(2026-11-07: externalized to `env.json`; rotation deferred — see task 1.1 and 1.13.)*
- **`images/placeholder.png` is referenced but does not exist** — `detail_page.dart:174`,
  `watchlistwidget.dart:109`. Throws at runtime for any item with no poster.
