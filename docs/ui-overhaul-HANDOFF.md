# UI Overhaul — Handoff

> **Update 2026-11-08:** Wave 3 (T6–T14) and T15 are committed (`d37b546`..`c875f60`). Full gate: `flutter analyze` 0 errors / 0 warnings, `flutter test` 209/209. Only Phase 5 remains: whole-branch review, `flutter build apk --debug`, and the by-hand device pass. The sections below describe the paused state from 2026-11-07 and are kept for history.

Read this first when you resume. It covers what was done, where everything is, and what to do next.

## TL;DR

- **Where the work is:** branch `ui-overhaul`, in the worktree at `D:\AAAAAAProjects\GIT-HUB\Movie-Night\.claude\worktrees\ui-overhaul`. It was cut from `improvements/phase-2` at `5ea15af`.
- **Phases:** 1 (audit), 2 (design system) and 3 (plan) are done and committed. Phase 4 (execution) is about 55% done. Phase 5 (verify) has not started.
- **Committed and reviewed:** Tasks 1, 2, 3, 4a, 4b and 5, covering the foundation, all shared components and the new app shell. Tests went from 66 to 172, all passing. `flutter analyze`: 0 errors, 0 warnings.
- **Uncommitted:** the nine Wave 3 screen tasks (6–14). They sit in the worktree in various states: some reviewed, some mid-fix, some half-built. Nothing from Wave 3 is committed yet.
- **Before closing:** if Claude Code asks whether to keep or remove the worktree when this session ends, choose **KEEP**. Removing it deletes the uncommitted Wave 3 work.

## Key documents (all in `docs/`)

| File | What it is |
|---|---|
| `ui-overhaul-audit.md` | Phase 1. 63 findings (13 Critical, 22 High, 19 Medium, 9 Low), each with What, Why (HIG citation) and Fix, plus file:line. Finding IDs (C1, H5, …) are cited everywhere else. |
| `ui-overhaul-design-system.md` | Phase 2, the "Screening Room" design system. Tokens, type scale, spacing, the spill-glow signature, motion, owner decisions D1–D3, and a self-critique. This is the binding spec. |
| `ui-overhaul-plan.md` | Phase 3, the implementation plan. 16 tasks in 5 waves, global constraints, behaviour fixes B1–B7, review focus. |
| `ui-overhaul-HANDOFF.md` | This file. |

## Execution workspace (git-ignored but on disk; don't delete it)

`.superpowers/sdd/ui-overhaul-plan/` inside the worktree holds:

- `progress.md`: **the ledger**. Every task status, fix round, deferred minor finding and ruling (R1–R18).
- `task-N-brief.md`: the exact requirements handed to each implementer.
- `task-N-report.md`: each implementer's report, with TDD evidence and fix-round appendices.
- `implementer-contract.md` and `reviewer-contract.md`: the rules every subagent followed. The global constraints and the token grep live here.
- `wave3-notes.md`: shared rules, APIs and migration items for the screen tasks.
- `review-*.diff`: the review packages already used.

The scripts used to produce briefs and review packages came from the `superpowers:subagent-driven-development` skill (`scripts/task-brief`, `scripts/review-package`). A copy is in the session scratchpad, but it's easy to regenerate from the skill.

## Owner decisions (approved)

- **D1 (appearance):** follow the system by default, with a three-way System / Dark / Light override.
- **D2:** all behaviour fixes B1–B7 are included. They are Delete Account confirmation and ordering, awaited auth flows, Undo instead of a dialog, four fixed tabs with a Library tab, Share for signed-out users, and a localized share text.
- **D3 (dependencies):** remove `fluttertoast`, `awesome_snackbar_content` and the Pacifico font. `intl_utils` was added as a dev dependency only, to run the l10n generator from the CLI.

## Done: committed and reviewed

| Task | Commit(s) | What |
|---|---|---|
| Docs | `c66c20c`, `91466fa` | Audit, design system and plan; rating-colour spec fix |
| T1 Tokens/theme | `7630734`, `6d3e661` | `lib/src/design/{tokens,app_theme,typography,motion}.dart`; Poppins weights fixed in `pubspec.yaml`; all 15 TextTheme roles; contrast tests |
| T2 Appearance | `ec8b6aa` | `ThemeProvider` uses `AppAppearance {system, dark, light}` with migration from the old bool; `main.dart` wiring; Bold Text reaches component themes (`applyAccessibilityTheme`) |
| T3 Copy | `ad124dc` | 56 new and 17 revalued strings across all 7 `.arb` files; non-English files flagged `@@x-needs-review` |
| T4b Inputs | `36c582f` | `AppTextField`, `SegmentedToggle`, `ActionTile`, `AppFeedback` (info/error/undo/confirmDestructive); show/hide password strings |
| T4a Display | `5ef8f4a` | `PosterCard` + `heroTagFor`, `PressableScale`, `SectionHeader`, `RatingBadge`, `ErrorState`/`EmptyState`, `SignInPrompt`, `SpillGlow` (signature), `showPosterViewer`; `CachedImageCustom` and `PosterSize` upgraded |
| T5 App shell | `24e43b8`, `627f2eb` | `AppShell`: four fixed tabs (Home, Search, Library, Profile), a Navigator per tab, `HeroControllerScope`, re-tap pops to root then scrolls to top, `TickerMode`, back pops only the current tab. `ChromeBar` (iOS glass, Android opaque). `lib/src/navigation/routes.dart` (`openTitle`, `openSeeAll`, `presentSignIn`, `dismissSignIn`). `LibraryPage` shell |

## In progress: Wave 3 (uncommitted, in the worktree)

Each task owns disjoint files. Status when paused:

| Task | Status | Owned files (uncommitted) | Next step |
|---|---|---|---|
| **T9 Reviews** | Fix round 1 **done**, re-review not yet run | `pages/UI/{Reviews_page,all_reviews_page}.dart`, `widgets/{local_Reviews,global_Reviews,review_card,review_list}.dart`, `test/widgets/review_card_test.dart` | Run a scoped re-review (stable card keys, `ReviewList` moved to `widgets/`, overflow measurement), then commit |
| **T14 Admin + global** | Fix round 1 **done**; re-review was stopped mid-run | `widgets/offline_banner.dart`, `Auth/auth.dart`, `pages/Adminpages/*.dart`, `test/widgets/offline_banner_test.dart` | Re-run the scoped re-review (banner insets content so the app bar stays usable, liveRegion only), then commit |
| **T10 Cast** | Fix round 1 **interrupted** mid-way | `pages/UI/castdetails.dart`, `widgets/{cast,cast_movies}.dart`, `test/widgets/cast_rail_test.dart`, **plus `lib/src/design/tokens.dart` and `test/design/tokens_test.dart`** (adding `MNColors.onScrim`, ruling R17) | Finish the fix round (open items below), re-review, commit |
| **T12 Auth** | Fix round 1 **interrupted** mid-way | `pages/Login-Logout/{Login_welcome_screen,Login,Register,Forget_password,auth_errors,auth_form_parts}.dart`, `test/pages/{auth_error_mapping,auth_form_parts}_test.dart` | Finish the fix round (open items below), re-review, commit |
| **T6 Home** | Implementation **interrupted** (was building the sections widget and Home page) | `pages/UI/home_page.dart`, `pages/UI/showallmovies.dart`, `widgets/{Home_page_listview,movies_listview,upcoming,carousel_slider,tvshow_listview}.dart`, `shimmerWidgets/{movieListView,upcoming}ShimmerWidget.dart`, `test/widgets/movies_listview_test.dart` | Resume the implementation, review, commit |
| **T7 Search** | Implementation **interrupted** | `pages/UI/explore.dart`, `widgets/{genreslistview,search}.dart`, `shimmerWidgets/{genreListView,searchResult}ShimmerWidget.dart`, `test/widgets/genres_grid_test.dart` | Resume, review, commit |
| **T8 Detail** | Implementation **interrupted** (tests written and confirmed failing; was building `DetailActions`) | `pages/UI/detail_page.dart`, `widgets/{addtowatchlist,watch_provider,Buy_provider,similar,videos,detail_actions}.dart`, `repository/Getvideos.dart`, `shimmerWidgets/detailPageShimmerWidget.dart`, `test/widgets/detail_actions_test.dart` | Resume, review, commit |
| **T11 Library** | Implementation **interrupted** | `pages/UI/{liked,library_page}.dart`, `pages/Userpage/Watchlist.dart`, `widgets/{watchlistwidget,watchlistscreen}.dart`, `shimmerWidgets/{likedPage,watchList}ShimmerWidget.dart`, `test/widgets/library_test.dart` | Resume, review, commit |
| **T13 Profile** | Implementation **interrupted** (was on `profilepic`) | `pages/Userpage/{Settings_screen,account_setting,changepassword,Update_User_details,User_info_page,profilepic,SendReports}.dart`, `widgets/{changelangwidget,themechanger,customsettingscreen,iconwidget,userinfotile}.dart`, `shimmerWidgets/userInfoTileShimmerWidget.dart`, `test/widgets/appearance_setting_test.dart` | Resume, review, commit |

**Caution:** the interrupted tasks may leave the tree temporarily not compiling. That is expected until each task is finished. Don't run the full `flutter analyze` or `flutter test` as a gate until Wave 3 is done; gate each task on its own files.

### Open fix-round items for the interrupted fixes

**T10 Cast** (from its review):
1. Add `onScrim` (`#F3F0F8` in both themes) to `MNColors` in `tokens.dart`, including the constructor, `copyWith`, `lerp` and both instances. Add a test: contrast against `#333333` is ≥ 4.5.
2. Use `onScrim` for the cast name and icons over the headshot photo.
3. Show "Read more" whenever the bio actually overflows 6 lines. Measure it with `TextPainter`, not a 320-character count. Extract a `PersonBio` widget and test it at 2.0× text.
4. Minor fixes:
   - Request the headshot only when `profilePath` is not null.
   - Pad the rail by `MNSpace.lg - MNSpace.xs` so it lines up with the header.
   - Drop button semantics on cast items with a null id.

**T12 Auth** (from its review):
1. Extract the duplicated code into `auth_form_parts.dart`. That means `closeSignInFlow(ctx)` (root `popUntil(isFirst)`, with a comment explaining why `dismissSignIn()` isn't used), a shared Google handler, and `AuthErrorText` and `AuthSubmitButton` widgets. Use them in Login, Register and Forgot Password, and add widget tests.
2. Minor fixes:
   - Log `FirebaseAuthException` with `AppLog.error`.
   - Don't reveal whether an account exists: map `user-not-found` to the invalid-credential message on Login, and show the success state on Forgot Password.
   - Use `const` constructors.

**T6, T7, T8, T11 and T13 notes:**
- Text and icons drawn over imagery must use `MNColors.of(context).onScrim`, which T10 adds.
- Scroll views end with bottom padding for the floating iOS tab bar.
- Avatars pass `isPerson: true` to `CachedImageCustom`.

## Not started

- **T15 Cleanup and token lint** (plan step `task-15-brief.md`).
  - Delete the dead components listed in the plan, plus the old `Liked`/`UserWatchlist`/`toggleTheme` shims.
  - Remove `fluttertoast`, `awesome_snackbar_content` and Pacifico.
  - Move the `ChromeBar` 28 radius and 0.5 hairline into tokens.
  - Add `test/design/token_lint_test.dart`.
  - Add the pending strings to all 7 locales:
    - `Seealloptions` changes to "See All" (an existing key; no new key).
    - `readLess`: "Read less"
    - `deleteUserTitle`: "Delete {name}?"
    - `backOnline`: "You're back online."
- **Phase 5 verification:**
  - A whole-branch code review on the most capable model, with the ledger's deferred minor findings attached.
  - `flutter analyze`, `flutter test` and `flutter build apk --debug`.
  - A by-hand pass on an Android emulator: every screen in light, dark, 2.0× font, Arabic, Reduce Motion and High Contrast.
  - A profile-mode scroll check.
  - **By hand:** email log-in, Google log-in, Register, the sign-in sheet dismissal, drag-to-dismiss in the poster viewer, and the offline banner.
  - The before/after summary per screen.

## How to resume (paste into a new Claude Code session opened on the worktree folder)

> Resume the Movie Night UI overhaul. Read `docs/ui-overhaul-HANDOFF.md`, then `.superpowers/sdd/ui-overhaul-plan/progress.md` (the ledger). Continue with superpowers:subagent-driven-development from the "In progress" table:
> (1) re-review and commit T9 and T14;
> (2) finish the T10 and T12 fix rounds, re-review, commit;
> (3) resume T6, T7, T8, T11 and T13 (their briefs and partial work are on disk; tell each agent to inspect its owned files first), review and commit each;
> (4) run the full analyze and test gate;
> (5) T15;
> (6) Phase 5 verification and the before/after summary.
> Wave 3 agents must not commit; the controller commits each task's own files after review.

## Rulings made on your behalf (also in the ledger)

| # | What I decided | Why | Cost if wrong |
|---|---|---|---|
| R1 | Parallel agents never commit; the controller commits each task's files after review | Parallel commits in one git index collide | None; a stray file would show up in that task's diff |
| R2 | Wave 3 agents keep old public classes alive as thin shims; T15 removes them | Keeps the tree compiling while nine agents work in parallel | Some dead shims survive until T15 |
| R3 | Wave 3 gates each task on its own files; the full gate runs after the wave | Half-finished edits elsewhere break whole-project runs | A cross-task break surfaces at the wave gate, not per task |
| R4 | T15 removes the deprecated `toggleTheme` wrapper | T2 kept it only so the tree compiled | None |
| R5 | Parallel-task review diffs are scoped to each task's own files | The uncommitted tree mixes tasks | None |
| R6 | Light-theme rating colour changed to `#8A5800` | `#946000` measured 4.33:1 on sheets, below 4.5 | A slightly browner star in light mode |
| R7 | Accepted T1's neutral values for secondary and surface containers the spec didn't define | The spec is silent on them | Those tones may be off by one step |
| R8 | No explicit Poppins `fontFamilyFallback` | The engine already falls back per glyph | Visible in the Phase 5 Arabic check if wrong |
| R9 | Filled-button minimum size is `Size(48, 50)`, not full width | `Size.fromHeight` throws inside a `Row` | Full-width call sites must opt in |
| R10 | T2 and T3 ran in parallel | Their files don't overlap | None |
| R11 | The token grep applies to `lib/` only, not tests | Tests aren't shipped UI | None |
| R12 | T4b added the show/hide password strings during the arb freeze | Needed for an accessible reveal button | None |
| R13 | Image fade-in is 180 ms, not 150 ms | The spec maps fades to the `short` token | 30 ms longer |
| R14 | Token-grep regex uses `\bColors\.` | `MNColors.` was a false positive | None |
| R15 | Revalue the existing `Seealloptions` key to "See All" | Avoids a new key | None |
| R16 | `showallmovies` keeps its public constructor; T11 owns `library_page.dart` | Other code calls them | A compile break, caught at the wave gate |
| R17 | New `MNColors.onScrim` token for text over imagery | Theme text is dark in light mode, unreadable on the fixed dark scrim | One extra token |
| R18 | The offline banner stays an overlay but pushes app content down while offline | The overlay hid the back button and titles | Content shifts once when going offline |

## Home performance (2026-11-09)

Plan: `docs/superpowers/plans/2026-11-09-home-performance.md`. Results: `docs/perf/home-scroll.md`.

- **Spill glow is baked**, not live-blurred: `lib/src/components/glow_baker.dart` (64 × 36, cached 24). Design doc § 8 is updated.
- **Home** rebuilds only the glow on a carousel swipe, builds rails lazily (`SliverMainAxisGroup` + `SliverList`), switches Movies/TV instantly, and keeps content and carousel page through refreshes and failed refreshes.
- **Posters** use `tmdbImage(path, physicalWidth)` (smallest TMDB size covering 90%). Rail and carousel Heroes use `railHeroShuttle` so the flight shows the already-loaded image.
- **Low-power mode** (`lib/src/design/performance.dart`):
  - Turns on after 2 consecutive 120-frame windows where at least 25% of frames miss the budget (1 s / refresh rate). The first 120 frames are ignored. It stays on for the session.
  - Turns off: carousel zoom, card press-scale, image fade-ins, shimmer sweeps, and Home's one-screen pre-build (`cacheExtent`). Read it as `MNMotion.of(context).allowRichMotion` (or `.lowPower`).
  - Leaves alone: Reduce Motion rules, Hero flights, the spill glow.
  - Force it: `flutter run --dart-define=FORCE_LOW_POWER=true` (the benchmark accepts the same define).
- **Benchmark:** `flutter drive --no-dds --profile -d <device> --dart-define-from-file=env.json --driver=test_driver/perf_driver.dart --target=integration_test/home_scroll_perf_test.dart`. Needs network.

## Known follow-ups (deferred, not blocking)

- **Translations:** the 6 non-English locales are machine drafts and need native review. Spanish and French Title Case is inconsistent, German "Gemocht" reads awkwardly, and the Hindi "शीर्षक" wording should be checked.
- **Out of scope here:**
  - Register partial failure (pre-existing, provider-side): if the Firestore write fails after the auth account is created, the user is left signed in on the Register screen.
  - The forced immediate update at launch is a product decision.
- **Layout:** `NavigationRail` for wide screens (spec §6) is left for later.
- **Tests:** golden tests are left for later, since they need pinned fonts in CI.
- **Smaller items** are listed in the ledger, for example the `ActionTile` reduce-motion test, the error-snackbar content colour assertion, and the PhotoView drag-to-dismiss check on a device.
