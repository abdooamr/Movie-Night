# Resume Prompt — paste this into Claude Code

> ## CURRENT STATE — updated 2026-11-07. Read this before using any prompt below.
>
> - Branch **`improvements/phase-1`** already exists and is checked out. Do not
>   create another one. Do not work on `main`.
> - **Task 1.1 code change is DONE.** The key now reads from
>   `String.fromEnvironment('TMDB_API_KEY')`; `env.json` (gitignored) holds it,
>   `env.example.json` is the committed template, `.vscode/launch.json` passes
>   the flag, and `README.md` documents it.
> - **DO NOT ROTATE THE TMDB KEY.** `env.json` deliberately still contains the
>   old key `cc18b713...`. TMDb regenerates in place, which would instantly break
>   the live Play Store app. Rotation happens at deploy time, by the owner, after
>   task 1.13 ships. The 1.1 checkbox stays unticked until then.
> - **Every build and run needs the flag:**
>   `flutter run --dart-define-from-file=env.json`
>   Without it the key is empty and every TMDb call returns 401.
> - **Task 1.13 was added** (Play in-app forced-update gate). It is not in the
>   original 12-task list.
> - **Known pre-existing bug:** `images/placeholder.png` is referenced at
>   `detail_page.dart:174` and `watchlistwidget.dart:109` but does not exist on
>   disk. Confirm with the owner before task 1.2 whether to create it or leave it.
>   Do not list it in `pubspec.yaml` — the build fails on a missing asset.
> - **Do not touch these files.** They are the owner's unrelated work in progress:
>   `lib/main.dart`, `lib/src/widgets/userinfotile.dart`,
>   `lib/src/widgets/shimmerWidgets/userInfoTileShimmerWidget.dart`
> - **Next task is 1.2.** Capture the APK baseline first — see below.

Copy everything between the lines below into a new Claude Code session
opened at the repo root (`D:\AAAAAAProjects\GIT-HUB\Movie-Night`).

---

You are a senior Flutter engineer continuing a previously-approved optimization
plan for this project. A full audit has already been done — **do not re-audit.**

Read these files first, in this order:

1. `improvements/AUDIT_REPORT.md` — all findings with file:line references
2. `improvements/OPEN_QUESTIONS.md` — my answers to the blocking questions
3. `improvements/PHASE_1_QUICK_WINS.md` — the task list to execute
4. `improvements/BASELINE_METRICS.md` — before-metrics, if I captured them

Then execute **Phase 1 only** (`improvements/PHASE_1_QUICK_WINS.md`), **starting at task 1.2** — 1.1's code change is already done.

Rules:
- Work task by task in the listed order. Tasks are ordered so later ones
  don't collide with earlier ones.
- After each task: run `flutter analyze` and report the delta. Do not batch
  ten tasks and then check once.
- Tick the `- [ ]` checkbox in the phase file as each task completes.
- Task 1.5 (enabling `flutter_lints`) will surface a large new warning list.
  Report the count, do NOT auto-fix them all — that becomes its own task.
- Do not start Phase 2. Stop at the end of Phase 1 and summarize.
- If a task's premise turns out to be wrong (code already changed, file moved),
  say so and skip it rather than inventing a substitute.
- Do not commit or push unless I ask.

Start by confirming the current state matches the audit (spot-check 3 findings),
then begin Task 1.1.

---

## Variants

**To run a single phase:** swap `PHASE_1_QUICK_WINS.md` for `PHASE_2_REFACTORS.md`
or `PHASE_3_POLISH.md` above, and change "Phase 1 only" to match.

**To run a single task:** replace the execute line with:
> Execute only task **1.4** from `improvements/PHASE_1_QUICK_WINS.md`.

**To re-measure:** 
> Follow `improvements/VERIFICATION.md` and fill in the "after" column of
> `improvements/BASELINE_METRICS.md`. Do not change application code.
