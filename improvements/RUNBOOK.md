# Runbook — How to Actually Run This Plan

Step-by-step, with the exact commands and prompts to use, and which model for each.

---

## Model choice — the short version

| Phase / Task | Model | Why |
|---|---|---|
| **Phase 1** (all 12 tasks) | **Sonnet** | Mechanical edits against a spec that's already written. No design judgment left. |
| **2.12** (write tests) | **Sonnet** | Formulaic once the models are understood. |
| **2.1, 2.4, 2.7, 2.9, 2.10, 2.11** | **Sonnet** | Well-specified, single-file or near-enough. |
| **2.2** (rewrite `liked.dart`) | **Opus** | Three interacting bugs in tangled code. Needs judgment. |
| **2.3** (Explore lazy loading) | **Opus** | Depends on your Q1 answer; changes load semantics. |
| **2.5** (repository layer) | **Opus** | The one genuine architecture task in the plan. |
| **2.6** (split detail page) | **Opus** | Large extraction, easy to break silently. |
| **2.8** (unify auth) | **Opus** | Highest-risk item. Data implications. |
| **Phase 3** | **Sonnet** | Polish. 3.3 (responsive) is the only one worth Opus. |

**Default to Sonnet.** Reach for Opus only on the six tasks marked above.
Switching model: type `/model sonnet` or `/model opus` in Claude Code.

> Don't use Haiku for any of this. It's fine for one-line lookups, but these
> tasks span multiple files with cross-file consequences.

---

## Before you start anything

```bash
# 1. Confirm the toolchain works
flutter --version
flutter doctor

# 2. Make a branch — do NOT work on main
git checkout -b improvements/phase-1

# 3. Confirm a clean tree
git status
```

Then **rotate the TMDB key yourself** at https://www.themoviedb.org/settings/api
— that's task 1.1 and takes two minutes by hand. No reason to spend model
budget on it.

---

## Step 1 — Answer the open questions (10 minutes, no model needed)

Open `improvements/OPEN_QUESTIONS.md` and write your answers inline.

Only Q1–Q3 matter, and **only for Phase 2**. If you're just doing Phase 1,
skip this entirely and come back later.

---

## Step 2 — Capture the baseline (30 minutes, no model needed)

**Do this before any code changes or the after-numbers mean nothing.**

```bash
# App size
flutter build apk --release --analyze-size

# Startup (run 3x, take the median)
flutter run --profile --trace-startup
# then read build/start_up_info.json

# Live profiling — open DevTools from the URL this prints
flutter run --profile
```

In DevTools, capture the **Network tab request counts** for: Explore mount,
Home cold load, Liked scroll. Those three numbers are the headline of this
whole effort.

Write everything into `improvements/BASELINE_METRICS.md`.

Full procedure is in `improvements/VERIFICATION.md`.

---

## Step 3 — Run Phase 1

```bash
# In the project root
claude
```

Then in Claude Code:

```
/model sonnet
```

Then paste this:

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

**Expect this to take 1–3 sessions.** If you run out of context, start a fresh
session and say: *"Continue Phase 1 from task 1.7"* (or whichever is next —
the ticked checkboxes tell you where you are).

---

## Step 4 — Verify Phase 1

```bash
flutter analyze
flutter build apk --release --analyze-size   # compare to baseline
```

Then the manual walkthrough in `VERIFICATION.md` section 7. The two that
matter most after Phase 1:

- **Every screen in light mode** — task 1.2 deleted assets; a missed one throws
  at runtime, not compile time.
- **Profile picture change on iOS** — that's the C7 crash fix.

Record the after-numbers in `BASELINE_METRICS.md`, then:

```bash
git checkout main
git merge improvements/phase-1
```

---

## Step 5 — Phase 2 (only if the budget is there)

```bash
git checkout -b improvements/phase-2
```

New session. **Start with tests:**

```
/model sonnet
```
```
Read improvements/AUDIT_REPORT.md and improvements/PHASE_2_REFACTORS.md.
Execute ONLY task 2.12 (bootstrap the test suite). Stop when done.
```

Then switch per task. For a Sonnet task:
```
/clear
/model sonnet
```
```
Read improvements/AUDIT_REPORT.md, improvements/PHASE_2_REFACTORS.md, and my
answers in improvements/OPEN_QUESTIONS.md.
Execute ONLY task 2.1. Run `flutter test` when done. Stop.
```

For an Opus task, same thing with `/model opus` and the task number swapped.

**One task per session for Phase 2.** These are behaviour-changing refactors;
you want to test and commit between each.

Suggested order (it's dependency-correct):
`2.12 → 2.1 → 2.7 → 2.2 → 2.3 → 2.4 → 2.9 → 2.6 → 2.10 → 2.11 → 2.5 → 2.8`

> `2.5` (repository layer) and `2.8` (auth unification) are last on purpose.
> They're the most expensive and the most dangerous. **Both are genuinely
> optional** — you get most of Phase 2's user-visible benefit from 2.2, 2.3
> and 2.7 alone.

---

## Step 6 — Phase 3

Same pattern, `/model sonnet`, one or two tasks per session.

```
Read improvements/AUDIT_REPORT.md and improvements/PHASE_3_POLISH.md.
Execute tasks 3.1 and 3.2. Stop when done.
```

Skip 3.6 (renames) and 3.8 (dependency upgrades) unless you specifically need
them — worst value-per-token in the plan.

---

## Budget-saving habits

1. **`/clear` between tasks.** Context carries over otherwise, and you pay for
   it on every single tool call for the rest of the session.
2. **One phase per session minimum; one task per session for Phase 2.**
3. **Sonnet by default.** Only six tasks genuinely need Opus.
4. **Don't ask for re-reads.** The audit has the file:line references already —
   if you say "re-check the whole codebase" you've paid for the audit twice.
5. **Do the no-model steps yourself** — key rotation, baseline capture, manual
   walkthrough, the asset deletion in 1.2 (it's just `rm`).

---

## If something goes wrong

| Symptom | Fix |
|---|---|
| Asset-not-found crash after 1.2 | You deleted something referenced from a `.arb` file or native config, not Dart. `git checkout images/` and re-check. |
| Release build fails after 1.12 | R8 stripped something Firebase needs. Add keep rules to `android/app/proguard-rules.pro`. Don't just disable shrinking. |
| `flutter analyze` explodes after 1.5 | Expected — that's the point of the task. Triage, don't panic. |
| Language switcher broken after 1.8 | The `RadioGroup` migration. Test all 7 locales; `ar` is RTL. |
| Theme toggle stops working after 2.1 | You removed the wrong `ThemeProvider`. Only one should remain, in the `MultiProvider`. |
| Context runs out mid-phase | Start fresh, say "continue from task N". Checkboxes track your position. |

**Always on a branch.** `git reset --hard` is your undo for every one of these.
