# Step-by-Step Manual Guide

A follow-along checklist. Tick each box as you go.

`RUNBOOK.md` is the detailed reference — **this file is the one you keep open
while working.**

Legend: 🧑 = you do it by hand (no model, no tokens) · 🤖 = Claude Code does it

---

## Model cheat sheet

**Default to Sonnet.** Only six tasks in the entire plan need Opus.

| What | Model | Command |
|---|---|---|
| All of Phase 1 (12 tasks) | **Sonnet** | `/model sonnet` |
| Phase 2 — tasks 2.2, 2.3, 2.5, 2.6, 2.8 | **Opus** | `/model opus` |
| Phase 2 — everything else | **Sonnet** | `/model sonnet` |
| All of Phase 3 | **Sonnet** | `/model sonnet` |

Don't use Haiku for any of this — these tasks span multiple files with
cross-file consequences.

---

# STAGE 0 — Setup 🧑

*~15 minutes. No model. No tokens.*

- [ ] **0.1** Confirm the toolchain works
      ```bash
      flutter --version
      flutter doctor
      ```

- [ ] **0.2** Create a branch — **never work on `main`**
      ```bash
      git checkout -b improvements/phase-1
      git status          # must be clean
      ```

- [ ] **0.3** Rotate the TMDB API key yourself at
      https://www.themoviedb.org/settings/api
      The old key `cc18b713...` is in your Git history and in every shipped
      APK. Treat it as compromised. Keep the new key somewhere safe — you'll
      paste it into a `--dart-define` during task 1.1.

- [ ] **0.4** Read `OPEN_QUESTIONS.md` and write your answers inline.
      *Only needed before Phase 2. Skip for now if you're just doing Phase 1.*

---

# STAGE 1 — Capture the baseline 🧑

*~30 minutes. No model. **Do this before any code changes** or every
"after" number is meaningless.*

- [ ] **1.1** App size
      ```bash
      flutter build apk --release --analyze-size
      ```
      Record total APK size and the asset-bundle portion.

- [ ] **1.2** Startup time — run 3x, take the median
      ```bash
      flutter run --profile --trace-startup
      ```
      Then read `build/start_up_info.json` →
      `timeToFirstFrameRasterizedMicros`

- [ ] **1.3** Live profiling on a **physical mid-range Android device**
      (emulators and debug mode both lie)
      ```bash
      flutter run --profile
      ```
      Open DevTools from the URL it prints. In the **Network tab**, clear it
      and count requests for:
      - Explore tab mount → expect **~80**
      - Home cold load → expect **~34**
      - Liked page, scroll 5 items → expect 1 per item **per rebuild**

      Those three numbers are the headline of this whole effort.

- [ ] **1.4** Write everything into `BASELINE_METRICS.md`

> Full procedure: `VERIFICATION.md`

---

# STAGE 2 — Run Phase 1 🤖

*Expect 1–3 sessions. Sonnet throughout.*

- [ ] **2.1** Open Claude Code in the project root
      ```bash
      claude
      ```

- [ ] **2.2** Set the model
      ```
      /model sonnet
      ```

- [ ] **2.3** Paste this prompt:

```
You are a senior Flutter engineer executing a pre-approved optimization plan.
A full audit is already done — do NOT re-audit.

Read, in order:
1. improvements/AUDIT_REPORT.md
2. improvements/PHASE_1_QUICK_WINS.md

Execute Phase 1 only, task by task in the listed order.

Rules:
- Tick the - [ ] checkbox in the phase file as each task completes.
- Run `flutter analyze` after every 3-4 tasks (not after each) and report the delta.
- Task 1.5 enables linting and will surface a large new warning list.
  Report the count. Do NOT auto-fix them all — that becomes its own task.
- Task 1.1: I have already rotated the key. Just do the code change.
- Task 1.12 (R8) must be smoke-tested with a real release build before you
  call it done.
- Commit after each task with a message naming the task number.
- Do not start Phase 2. Stop at the end of Phase 1 and summarize.
- If a task's premise is wrong (file moved, already fixed), say so and skip it.

Start with task 1.1.
```

- [ ] **2.4** If you run out of context mid-phase: start a **fresh session**
      and say *"Continue Phase 1 from task 1.7"* (use whichever is next —
      the ticked checkboxes in `PHASE_1_QUICK_WINS.md` tell you where you are).

---

# STAGE 3 — Verify Phase 1 🧑

- [ ] **3.1** Static checks
      ```bash
      flutter analyze
      flutter build apk --release --analyze-size
      ```
      Compare APK size to baseline — expect roughly **−28 MB**.

- [ ] **3.2** Manual walkthrough — the two that matter most after Phase 1:
      - **Every screen, in light mode.** Task 1.2 deleted ~56 asset files; a
        missed reference throws at *runtime*, not compile time.
      - **Profile picture change on iOS.** That's the C7 crash fix.

- [ ] **3.3** Rest of the walkthrough (`VERIFICATION.md` §7):
      Home both toggles · all 16 Explore tabs · search · detail page ·
      like/unlike · watchlist add+remove · login/register/logout ·
      write+delete review · **all 7 locales** (`ar` is RTL) ·
      dark/light toggle **then restart the app** to confirm it persisted ·
      airplane mode

- [ ] **3.4** Record the "after" numbers in `BASELINE_METRICS.md`

- [ ] **3.5** Merge
      ```bash
      git checkout main
      git merge improvements/phase-1
      ```

**Stop here and check your remaining weekly budget before deciding on Phase 2.**

---

# STAGE 4 — Phase 2 🤖

*Only if the budget is there. **One task per session**, `/clear` between each.*

- [ ] **4.1** New branch
      ```bash
      git checkout -b improvements/phase-2
      ```

- [ ] **4.2** Confirm `OPEN_QUESTIONS.md` is answered — 2.3 and 2.8 depend on it.

- [ ] **4.3** **Start with tests** so everything after has a safety net
      ```
      /model sonnet
      ```
      ```
      Read improvements/AUDIT_REPORT.md and improvements/PHASE_2_REFACTORS.md.
      Execute ONLY task 2.12 (bootstrap the test suite). Stop when done.
      ```

- [ ] **4.4** Then one task at a time. Between every task:
      ```
      /clear
      /model sonnet        (or /model opus — see the cheat sheet)
      ```
      ```
      Read improvements/AUDIT_REPORT.md, improvements/PHASE_2_REFACTORS.md, and
      my answers in improvements/OPEN_QUESTIONS.md.
      Execute ONLY task 2.1. Run `flutter test` when done. Stop.
      ```
      Swap the task number each time.

### Order (dependency-correct — don't improvise)

```
2.12 → 2.1 → 2.7 → 2.2 → 2.3 → 2.4 → 2.9 → 2.6 → 2.10 → 2.11 → 2.5 → 2.8
 S      S     S     O     O     S     S     O     S      S      O     O
```
`S` = Sonnet · `O` = Opus

> **2.5** (repository layer) and **2.8** (auth unification) are last on purpose —
> most expensive, most dangerous, and **both genuinely optional.** You get most
> of Phase 2's user-visible benefit from **2.2, 2.3 and 2.7 alone.**

- [ ] **4.5** Test and commit after **every** task. These are behaviour-changing
      refactors.

---

# STAGE 5 — Phase 3 🤖

*Sonnet. One or two tasks per session.*

- [ ] **5.1**
      ```
      /model sonnet
      ```
      ```
      Read improvements/AUDIT_REPORT.md and improvements/PHASE_3_POLISH.md.
      Execute tasks 3.1 and 3.2. Stop when done.
      ```

- [ ] **5.2** **Skip 3.6 (renames) and 3.8 (dependency upgrades)** unless you
      specifically need them — worst value-per-token in the plan. 3.8 in
      particular can spiral (`google_sign_in` 6→7 is a real migration).

---

# Budget-saving habits

1. **`/clear` between tasks.** Otherwise you pay for stale context on every
   single tool call for the rest of the session. This is the biggest lever.
2. **Sonnet by default.** Only six tasks need Opus.
3. **One phase per session minimum; one task per session for Phase 2.**
4. **Never say "re-check the codebase."** The audit already has every
   `file:line` — asking for a re-scan means paying for the audit twice.
5. **Do the 🧑 steps yourself** — key rotation, baseline capture, manual
   walkthrough. The asset deletion in task 1.2 is literally `rm`.

---

# If something breaks

| Symptom | Fix |
|---|---|
| Asset-not-found crash after 1.2 | You deleted something referenced from an `.arb` or native config, not Dart. `git checkout images/` and re-check. |
| Release build fails after 1.12 | R8 stripped something Firebase needs. Add keep rules to `android/app/proguard-rules.pro`. Don't just disable shrinking. |
| `flutter analyze` explodes after 1.5 | **Expected** — that's the whole point of the task. Triage, don't panic. |
| Language switcher broken after 1.8 | The `RadioGroup` migration. Test all 7 locales; `ar` is RTL. |
| Theme toggle dead after 2.1 | Wrong `ThemeProvider` removed. Exactly one should remain, in the `MultiProvider`. |
| Context runs out mid-phase | Fresh session, *"continue from task N"*. Checkboxes track your position. |
| Anything else | You're on a branch. `git reset --hard` is your undo. |
