# Movie Night UI Overhaul — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restyle and restructure the whole UI layer around the "Screening Room" design system. That means accessible, platform-native, fluid at 60 fps and recognisably Movie Night, with no change to data, repository or service logic beyond the behaviour fixes owner-approved in group B.

**Architecture:**
- **Foundation first.** A token layer (`lib/src/design/`) and a shared component library (`lib/src/components/`) land first.
- **App shell.** A rebuilt shell with four fixed tabs, each with its own navigator, and a routes helper.
- **Screens in parallel.** Each screen group then migrates in parallel onto those foundations. Groups own disjoint files.
- **Cleanup.** A final pass deletes dead code and adds a lint test, so hardcoded colors, sizes and durations can't come back.

**Tech Stack:** Flutter 3.35.5, Material 3, Cupertino widgets for iOS-adaptive controls, Provider, flutter_intl (`.arb`), flutter_test with accessibility guideline matchers.

**Spec:**
- `docs/ui-overhaul-design-system.md` (tokens, signature, motion, decisions D1–D3)
- `docs/ui-overhaul-audit.md` (finding IDs such as C1 and H5, cited per task)

## Global Constraints

- **No hardcoded design values outside `lib/src/design/`.** No `Color(0x…)`, `Color.fromARGB`, `Colors.*` (except `Colors.transparent`), `fontSize:`, `fontFamily:`, numeric `BorderRadius.circular(n)` or `Duration(milliseconds: n)`. Use `Theme.of(context).colorScheme`, `MNColors.of(context)`, `textTheme`, `MNSpace`, `MNRadius`, `MNSize`, `MNDuration` and `MNMotion.of(context)`.
- **Directional layout only.** Use `EdgeInsetsDirectional` and `AlignmentDirectional`; never left/right (the app ships Arabic).
- **Accessibility floor:**
  - Every tappable is at least 48×48 and has an accessible name.
  - Section titles get `Semantics(header: true)`.
  - Decorative images get `excludeFromSemantics: true`.
  - No text below 11 pt; nothing below 12 pt over imagery.
  - Never clamp `textScaler`.
- **Animation:** only `transform` and `opacity` animate. `AnimatedSize` is allowed only inside a single card.
- **Lists:** every list is a `.builder` or a sliver. No `shrinkWrap: true` inside a scroll view.
- **Reduce Motion:** every animation reads `MNMotion.of(context)`.
- **Strings:** every user-visible string comes from `S.of(context)`. Copy follows design system §11: Title Case for buttons, titles and tabs; sentence case for messages.
- **Icons:** Iconsax only (`IconsaxOutline` at rest, `IconsaxBold` selected). Brand logos come from `simple_icons` only where a third-party mark is required.
- **Out of scope:** data, repository, model and service files under `lib/src/data`, `lib/src/models`, `lib/src/services` and `lib/src/Provider/*` (except `theme_provider.dart`). Behaviour changes are limited to group B below.
- **Per-task gate:**
  - `flutter analyze` shows 0 errors and 0 warnings.
  - `flutter test` passes.
  - This grep returns nothing for the task's own files: `grep -nE "Color\(0x|Color\.fromARGB|Colors\.(?!transparent)|fontSize:|fontFamily:|Duration\(milliseconds|EdgeInsets\.only\(\s*(left|right)|Alignment\.center(Left|Right)" <files>`. Use `rg -P` for the lookahead.

### Group B: owner-approved behaviour fixes (D2)

The fixes are listed below; strike any you want kept as-is before execution.

- **B1 (T13):** Delete Account shows a destructive confirmation and awaits the auth delete before deleting the Firestore doc. On `requires-recent-login` it shows the localized message and deletes nothing.
- **B2 (T12):** Login, Register and Forgot Password:
  - validate first;
  - await the auth call with a busy state;
  - map `FirebaseAuthException.code` to inline localized errors;
  - pop exactly once, on success;
  - check that the confirm password matches;
  - on Login, only check that the password is non-empty.
- **B3 (T13):** Change Password, Update Profile and Send Report await their call, then report success or failure. Send Report requires both fields.
- **B4 (T11, T9):** Removing a watchlist or liked title happens immediately and offers Undo. Deleting a review asks for confirmation first.
- **B5 (T5, T11):** Four fixed tabs (Home, Search, Library, Profile). Watchlist moves from Settings into Library.
- **B6 (T8):** Share and IMDb show for signed-out users. Like, Watchlist and Reviews open a sign-in prompt when signed out.
- **B7 (T8):** The share text is localized and uses the TV URL and name for series.

## Review Focus

1. **Arabic (RTL).** Segmented order, chevrons, section headers, "See All" and the Detail header must mirror, and nothing should hug the wrong edge. *Test:* T4b `segmented_toggle_test` with an RTL case; T4a `section_header_test` RTL case.
2. **Text scale 2.0 and above.** Poster rails, the Detail header, buttons and settings rows must not overflow. Rails should switch to a vertical list at ≥ 1.5×. *Test:* T4a `poster_card_test` at a 2.0 scale with no overflow; T6 `movies_listview_test` at 1.6× renders a vertical list.
3. **Signed-out user.** All four tabs exist. Library and Profile show the sign-in invitation. On Detail, Share works and Like asks the user to log in. *Test:* T5 `app_shell_test` signed out shows 4 destinations and `SignInPrompt` on Library.
4. **Offline at launch.** Feeds show `ErrorState` with Try Again instead of disappearing, and retry refetches. *Test:* T4a `state_views_test` retry callback; T6 `movies_listview_test` with an errored future shows Try Again.
5. **The same title in two rails.** Hero tags must not collide (a duplicate tag throws on push). *Test:* T4a `poster_card_test` asserts `heroTagFor(source: 'trending', …) != heroTagFor(source: 'popular', …)`; T5 `routes_test` pushes Detail from a tree containing two cards for the same id without throwing.

## File Structure

```
lib/src/design/                         (T1)  tokens.dart · app_theme.dart · typography.dart · motion.dart
lib/src/navigation/routes.dart          (T5)  openTitle · openPosterViewer · presentSignIn · openSeeAll
lib/src/components/                     (T4a) pressable.dart · poster_card.dart · section_header.dart · rating_badge.dart
                                              state_views.dart · sign_in_prompt.dart · spill_glow.dart · poster_viewer.dart
                                              cached_image.dart (modify) · ../utils/poster_size.dart (modify)
                                        (T4b) app_text_field.dart · segmented_toggle.dart · action_tile.dart · feedback.dart
lib/src/widgets/Navbar/Navbar.dart      (T5)  → AppShell + ChromeBar (lib/src/widgets/Navbar/chrome_bar.dart)
lib/src/pages/UI/library_page.dart      (T5 create, T11 finish)
Screens (T6–T14): owned per the task table below; no file appears in two tasks.
Deleted in T15: colorpalette.dart, textbutton.dart, square_tile.dart, squaretile.dart, stars.dart, alertdialog.dart,
  snackbar.dart, Temp_text.dart, text.dart, textcustom.dart, formfield.dart, formfieldwithvalidation.dart,
  widgets/switch.dart, darkmodebutton.dart, feedbackwidget.dart, kBackgoundColor in utils.dart
```

## Execution waves

| Wave | Tasks | Parallel? | Depends on |
|---|---|---|---|
| 0 | T1 tokens and theme → T2 appearance and app wiring → T3 copy foundation | serial | none |
| 1 | T4a display components ‖ T4b input and feedback components | **parallel** (2 agents) | T1, T3 |
| 2 | T5 app shell, routes, Library shell | serial | T4a, T4b |
| 3 | T6 Home ‖ T7 Search ‖ T8 Detail ‖ T9 Reviews ‖ T10 Cast ‖ T11 Library ‖ T12 Auth ‖ T13 Profile ‖ T14 Admin + global | **parallel** (9 agents) | T5 |
| 4 | T15 cleanup and token lint → Phase 5 verification | serial | all |

Each Wave 3 agent edits only its own files. Arb strings are frozen after T3. If a screen needs a string T3 didn't add, the agent reports it as `NEEDS_STRING <key>: <English>` and does not edit the arb. The controller batches those strings into T15.

---

### Task 1: Design tokens, theme and typography

**Audit:** C8, C9, C10, H10, H14, H15, H17. **Spec:** §3, §4, §5, §9.

**Files:**
- Create: `lib/src/design/tokens.dart`, `lib/src/design/typography.dart`, `lib/src/design/app_theme.dart`, `lib/src/design/motion.dart`
- Modify: `pubspec.yaml:121-131` (Poppins weights: Regular 400, Medium 500, SemiBold 600, Bold 700)
- Test: `test/design/tokens_test.dart`, `test/design/app_theme_test.dart`, `test/design/motion_test.dart`

**Interfaces (Produces):**
- `class MNSpace { static const double xxs=2, xs=4, sm=8, md=12, lg=16, xl=24, xxl=32, xxxl=48; }`
- `class MNRadius { static const double sm=8, md=12, lg=20; static const BorderRadius smAll, mdAll, lgAll; }`
- `class MNSize { static const double minTap=48, buttonHeight=50, avatar=72; }`
- `class MNDuration { static const Duration micro=100ms, short=180ms, medium=280ms, long=420ms; }`
- `class MNCurves { static const Curve standard = Cubic(0.2,0,0,1), exit = Cubic(0.3,0,1,1); }`
- `class MNSprings { static const SpringDescription press = (1, 600, 49), pop = (1, 400, 22); }`
- `class MNColors extends ThemeExtension<MNColors>`:
  - fields: `rating`, `chrome`, `chromeHairline`, `scrim` (`LinearGradient` from transparent to black 80%), `glowOpacity` (double: 0.55 dark, 0.30 light), `posterShadow` (`List<BoxShadow>`, empty in dark)
  - `static MNColors of(BuildContext)`
  - `copyWith` and `lerp`
- `ThemeData buildAppTheme(Brightness brightness, {bool highContrast = false})`. This sets:
  - `colorScheme` (spec §3, exact hex);
  - `textTheme` (spec §4);
  - `filledButtonTheme`: StadiumBorder, `minimumSize: Size.fromHeight(MNSize.buttonHeight)`, `labelLarge`;
  - `outlinedButtonTheme` and `textButtonTheme`, both with min 48;
  - `inputDecorationTheme`: filled `surfaceContainer`, `outline` enabled border, `primary` focused border, radius md;
  - `cardTheme`, `appBarTheme` (surface, no tint, `scrolledUnderElevation: 0`), `navigationBarTheme`, `segmentedButtonTheme`, `snackBarTheme` (floating, `surfaceContainerHigh`), `dialogTheme` (radius lg), `listTileTheme`, `tabBarTheme`;
  - `pageTransitionsTheme`: iOS uses `CupertinoPageTransitionsBuilder`, Android uses `PredictiveBackPageTransitionsBuilder`;
  - `extensions: [MNColors…]`.
  - When `highContrast` is true: `onSurfaceVariant := onSurface`, `outline := onSurfaceVariant`, and `chrome` is opaque.
- `TextTheme buildTextTheme(Color onSurface)` and `TextTheme emboldenTextTheme(TextTheme t)`. The second raises each weight one step (400→500→600→700→800).
- `class MNMotion`:
  - constructor `const MNMotion({required bool reduce})`
  - `static MNMotion of(BuildContext)`, which reads `MediaQuery.disableAnimationsOf`
  - `Duration call(Duration d)`: returns `Duration.zero` when `reduce` is true
  - `Duration fade(Duration d)`: returns `min(d, short)`; used for fades that stay on under Reduce Motion
  - `bool get allowScale`: equals `!reduce`

- [ ] **Step 1: Write failing tests**
  - `tokens_test`:
    - For every row in spec §3 and both brightnesses, build the theme and assert the WCAG ratio (implement `double contrast(Color a, Color b)` in the test from `computeLuminance()`). Thresholds: `onSurface`, `onSurfaceVariant`, `primary`, `error` and `rating` on `surface`, `surfaceContainer` and `surfaceContainerHigh` must be ≥ 4.5. `onPrimary`/`primary` and `onError`/`error` must be ≥ 4.5. `outline` on `surface` and `surfaceContainer` must be ≥ 3.0.
    - Assert `colorScheme.primary == Color(0xFFBBA8FF)` (dark) and `== Color(0xFF5A3FD6)` (light).
  - `app_theme_test`:
    - `textTheme.bodyLarge!.fontSize == 17`, `labelSmall!.fontSize == 11`, `displaySmall!.fontFamily == 'poppins'`, `bodyLarge!.fontFamily == null`.
    - The highContrast theme has `onSurfaceVariant == onSurface`.
    - `emboldenTextTheme(t).bodyLarge!.fontWeight == FontWeight.w500`.
    - `pageTransitionsTheme.builders[TargetPlatform.iOS] is CupertinoPageTransitionsBuilder`.
  - `motion_test`:
    - Pump with `MediaQueryData(disableAnimations: true)` and assert `MNMotion.of(ctx)(MNDuration.long) == Duration.zero` and `.fade(MNDuration.long) == MNDuration.short`.
- [ ] **Step 2:** Run `flutter test test/design`. Expect a FAIL (the files don't exist yet).
- [ ] **Step 3:** Implement the four files and fix `pubspec.yaml` weights. Leave the Pacifico declaration (T15 removes it). Do not wire the theme into `main.dart` yet.
- [ ] **Step 4:** Run `flutter test test/design && flutter analyze`. Expect PASS and 0 errors/warnings.
- [ ] **Step 5:** Commit with `feat(design): Screening Room tokens, theme, typography and motion`.

### Task 2: Appearance setting and app wiring

**Audit:** M8, L6, H17 (Bold Text). **Spec:** D1, §4 rules.

**Files:**
- Modify: `lib/src/Provider/theme_provider.dart` (delete `MyThemes`), `lib/main.dart:36-57`
- Test: `test/providers/theme_provider_test.dart` (rewrite)

**Interfaces:**
- Consumes `buildAppTheme` and `emboldenTextTheme` (T1).
- Produces:
  - `enum AppAppearance { system, dark, light }`
  - `ThemeProvider`:
    - `AppAppearance appearance` (default `system`)
    - `ThemeMode get themeMode`
    - `Future<void> setAppearance(AppAppearance a)`, persisted under the string key `'appearance'`
    - a one-time migration: an old bool `'darkMode'` maps to dark/light
    - `toggleTheme(bool)`, kept as a thin `@Deprecated` wrapper until T13 removes its caller
- `MaterialApp`:
  - `title: 'Movie Night'`
  - `theme` / `darkTheme` / `highContrastTheme` / `highContrastDarkTheme` from `buildAppTheme`
  - `builder` applies `emboldenTextTheme` when `MediaQuery.boldTextOf` is true, then wraps `OfflineBanner` (as now)

- [ ] **Step 1: Write failing tests.**
  - Defaults to `system` with nothing stored.
  - Migrates `{'darkMode': false}` → `light`, and the old key is removed.
  - `setAppearance(dark)` notifies once and persists `'dark'`.
  - `themeMode` maps each enum value.
- [ ] **Step 2:** Run `flutter test test/providers/theme_provider_test.dart` and confirm it fails.
- [ ] **Step 3:** Implement the provider and the `main.dart` wiring.
- [ ] **Step 4:** Run `flutter test && flutter analyze`. Expect a full pass.
- [ ] **Step 5:** Commit with `feat(theme): three-way appearance following system by default`.

### Task 3: Copy foundation (all 7 locales)

**Audit:** M15, M16, H18, L5. **Spec:** §11.

**Files:**
- Modify: `pubspec.yaml` (dev_dependencies: `intl_utils: ^2.8.7`; dev-only, used to run the generator from the CLI)
- Modify: `lib/l10n/intl_{en,ar,de,es,fr,hi,it}.arb`
- Regenerate: `lib/generated/**`

**Interfaces (Produces):** the `S.of(context)` getters listed below, which every later task consumes. Read each `.arb` first. If an equivalent key already exists, reuse it and record the mapping in the commit message.

- **Revalue existing keys** (English shown; translate the rest):
  - `egyptmovieswidget_title` → "Egyptian Movies"; `egypttvwidget_title` → "Egyptian TV Shows"
  - `explorenavbar` → "Search"; `likednavbar` → "Library"
  - login label → "Log In"; logout → "Log Out"; sign-up and register labels → "Create Account"
  - `readmorelabel` → "Read more"; `noDataFound` → "Nothing to show"; `somethingwentwrong` → "Couldn't load this. Try again."
  - `noReport` → "No reports"; `updateprofilesuccess` → "Profile updated"
  - `nolikedmovies` → "No liked titles yet"
  - `passwordvalidationtext` → "Use at least 8 characters, including an uppercase letter, a lowercase letter, a number and a symbol."
  - `searchhint` → "Movies, TV shows, people"
- **New keys:**
  - Library and empty states: `libraryLiked` "Liked", `libraryWatchlist` "Watchlist", `likedEmptyBody` "Tap ♡ on any movie or show to keep it here.", `watchlistEmptyBody` "Add titles to your Watchlist to find them here later.", `browseMovies` "Browse Movies"
  - Sign-in prompts: `signInPromptTitle` "Log In to Save Titles", `signInPromptBody` "Log in to keep a watchlist, like titles and write reviews.", `signInToReview` "Log in to read and write reviews.", `continueWithGoogle` "Continue with Google"
  - Load errors: `couldntLoadSection` "Couldn't load {section}.", `couldntLoadTitle` "Couldn't load this title."
  - Search: `noResultsFor` "No results for “{query}”. Check the spelling or try another title.", `clearHistory` "Clear"
  - Undo: `undo` "Undo", `removedFromWatchlist` "Removed from Watchlist", `removedFromLiked` "Removed from Liked"
  - Delete Account: `deleteAccountTitle` "Delete Account?", `deleteAccountMessage` "Your profile, watchlist and reviews will be permanently deleted. This can't be undone.", `deleteAccountDone` "Your account has been deleted."
  - Delete Review: `deleteReviewTitle` "Delete Review?", `deleteReviewMessage` "This can't be undone."
  - Auth errors: `authErrorInvalidCredential` "Email or password is incorrect.", `authErrorNetwork` "You're offline. Check your connection and try again.", `authErrorTooManyRequests` "Too many attempts. Try again in a few minutes.", `authErrorEmailInUse` "An account with this email already exists.", `authErrorWeakPassword` "Choose a stronger password.", `authErrorUserNotFound` "No account uses this email.", `authErrorInvalidEmail` "Enter an email like name@example.com.", `authErrorGeneric` "Couldn't complete that. Try again.", `authErrorRecentLogin` "For your security, log in again to delete your account."
  - Validation: `passwordsDontMatch` "Passwords don't match.", `enterValidEmail` "Enter a valid email address.", `enterPassword` "Enter your password.", `enterFirstName` "Enter a first name."
  - Reset password: `resetLinkSent` "Check your email. We sent a reset link to {email}.", `backToLogIn` "Back to Log In", `resetPassword` "Reset Password", `resetPasswordSubtitle` "We'll email you a reset link"
  - Reports: `reportSent` "Report sent. Thanks for helping improve Movie Night.", `reportFailed` "Couldn't send report. Try again.", `reportSummaryRequired` "Add a short summary."
  - Watchlist: `watchlistUpdateFailed` "Couldn't update Watchlist. Try again.", `inWatchlist` "In Watchlist"
  - Appearance: `appearance` "Appearance", `appearanceSystem` "System", `appearanceDark` "Dark", `appearanceLight` "Light"
  - Detail and media: `seeAllReviews` "See All Reviews ({count})", `watchTrailers` "Watch Trailers", `viewPosterFullScreen` "View poster full screen", `playVideo` "Play {title}", `ratingOutOf10` "{score} out of 10", `tmdbLabel` "TMDB", `shareText` "Check out {title} on Movie Night\n{url}"
  - Misc: `close` "Close", `liked` "Liked", `like` "Like"
  - **Translations:** machine-draft the 6 non-English locales. Add `"@@x-needs-review": true` at the top of each non-en `.arb`. Arabic strings must not contain LTR punctuation marks.

- [ ] **Step 1:** Add the `intl_utils` dev dependency, then run `flutter pub get`.
- [ ] **Step 2:** Edit all 7 `.arb` files.
- [ ] **Step 3:** Run `dart run intl_utils:generate`. Expect `lib/generated/l10n.dart` to contain `String get libraryLiked` and `String couldntLoadSection(Object section)`.
- [ ] **Step 4:** Run `flutter analyze && flutter test`. Expect PASS. Revaluing keys changes no call sites.
- [ ] **Step 5:** Commit with `feat(l10n): copy foundation for UI overhaul (7 locales, non-en flagged for review)`.

### Task 4a: Display components (parallel with 4b)

**Audit:** C1, C5, C13, H8, H13, H18, H22, M3, M4, M5, L3, L9. **Spec:** §5, §8, §9, §10.

**Files:**
- Create in `lib/src/components/`: `pressable.dart`, `poster_card.dart`, `section_header.dart`, `rating_badge.dart`, `state_views.dart`, `sign_in_prompt.dart`, `spill_glow.dart`, `poster_viewer.dart`
- Modify: `lib/src/components/cached_image.dart` (static `surfaceContainer` placeholder, 150 ms fade-in, local `IconsaxOutline.video`/`user` error glyph, `semanticLabel` param, `borderRadius` param; the third-party URL fallbacks are removed), `lib/src/utils/poster_size.dart` (remove the `.clamp(1.0, 2.0)` upper bound, add `bool get stackRails => textScale >= 1.5`, caption height = `2 × titleMedium` line height × scale + `labelMedium` line)
- Test: `test/components/{pressable,poster_card,section_header,rating_badge,state_views,spill_glow}_test.dart`

**Interfaces (Produces):**
- `PressableScale({required Widget child, VoidCallback? onTap, VoidCallback? onLongPress, BorderRadius? borderRadius})`
  - Scales to 0.97 on tap-down via `MNSprings.press`, transform only.
  - Has an `InkWell` overlay.
  - Skips the scale when `!MNMotion.of(ctx).allowScale`.
- `String heroTagFor({required String source, required bool isTv, required int id})`, returning `'poster-$source-${isTv?'tv':'movie'}-$id'`.
- `PosterCard({required String? posterPath, required String title, String? subtitle, required VoidCallback onTap, String? heroTag, double? width})`:
  - Image at 2:3 with radius md.
  - Title `titleMedium` (max 2 lines), subtitle `labelMedium onSurfaceVariant` (max 1 line).
  - One `Semantics(button: true, label: '$title, $subtitle', excludeSemantics: true)`.
  - Light-theme `posterShadow`; wrapped in `Hero` when `heroTag != null`.
- `SectionHeader({required String title, VoidCallback? onSeeAll})`:
  - `titleLarge` in `Semantics(header: true)`.
  - A trailing `TextButton` "See All" with a directional chevron.
  - Page margin `MNSpace.lg`.
- `RatingBadge({required double score, bool showSource = false})`:
  - "★ 7.3", star in `MNColors.rating`, number `labelLarge`, optional "TMDB" caption.
  - `Semantics(label: S.ratingOutOf10(score.toStringAsFixed(1)))`.
- `ErrorState({required String message, required VoidCallback onRetry, bool compact = false})` shows an icon, the message, and a `FilledButton.tonal` "Try Again". `compact` is the in-rail version, 1 line plus a TextButton.
- `EmptyState({required IconData icon, required String title, String? body, String? actionLabel, VoidCallback? onAction})`.
- `SignInPrompt({required VoidCallback onLogIn, String? title, String? body})` shows `EmptyState` with a "Log In" filled button that calls `onLogIn`. Callers pass `() => presentSignIn(context)` (T5).
- `SpillGlow({required ImageProvider? source, required Widget child})`:
  - Top-anchored 16:9 band, image resized to width 200, `ImageFiltered(blur σ 60)`.
  - Opacity `MNColors.glowOpacity`, fades to `surface`.
  - Cross-fades on source change with `MNMotion(long)`.
  - `RepaintBoundary`.
  - Renders only `child` when `highContrast` is on or the source is null.
- `Future<void> showPosterViewer(BuildContext, {required ImageProvider image, required String heroTag, required String semanticLabel})`:
  - Root-navigator `PageRouteBuilder(opaque: false)` with a fade.
  - `Scaffold` (black) with a `CloseButton`.
  - `PhotoView` (`minScale: contained`, `maxScale: covered*3`, `heroAttributes`).
  - Vertical-drag-down dismiss when at initial scale.

- [ ] **Step 1: Write failing tests.**
  - `poster_card_test`:
    - `meetsGuideline(androidTapTargetGuideline)` and `labeledTapTargetGuideline`.
    - Semantics label equals 'Dune, 2021'.
    - At `textScaler: TextScaler.linear(2.0)`, inside a 170-wide box, no `FlutterError` (overflow).
    - `heroTagFor` uniqueness across sources.
  - `section_header_test`: header semantics; under `Directionality(rtl)` the See All button sits at the start edge (`tester.getTopLeft(...).dx < 100`).
  - `rating_badge_test`: label "7.3 out of 10" and contrast `textContrastGuideline` on both themes.
  - `state_views_test`: tapping Try Again calls `onRetry` once.
  - `pressable_test`: with `disableAnimations: true`, no `Transform` scale ≠ 1 after tap-down.
  - `spill_glow_test`: `highContrast: true` → no `ImageFiltered` in the tree.
  - Wrap every test in `MaterialApp(theme: buildAppTheme(...), localizationsDelegates: [S.delegate, …])`.
- [ ] **Step 2:** Run `flutter test test/components` and confirm it fails.
- [ ] **Step 3:** Implement the components and the `cached_image`/`poster_size` changes.
- [ ] **Step 4:** Run `flutter test && flutter analyze` plus the token grep on the new files. Expect PASS and a clean grep.
- [ ] **Step 5:** Commit with `feat(components): poster card, section header, rating badge, states, spill glow, viewer`.

### Task 4b: Input and feedback components (parallel with 4a)

**Audit:** C3, H9, H9b, H12, H20, M6, M12, M19. **Spec:** §9, §10.

**Files:**
- Create in `lib/src/components/`: `app_text_field.dart`, `segmented_toggle.dart`, `action_tile.dart`, `feedback.dart`
- Test: `test/components/{app_text_field,segmented_toggle,action_tile,feedback}_test.dart`

**Interfaces (Produces):**
- `enum AppFieldKind { text, email, password, newPassword, name, multiline }`
- `AppTextField(...)`:
  - Parameters: `{required TextEditingController controller, required String label, AppFieldKind kind = AppFieldKind.text, IconData? icon, String? Function(String?)? validator, TextInputAction? action, ValueChanged<String>? onSubmitted, String? errorText, Iterable<String>? autofillHints}`.
  - `kind` sets `keyboardType`, `autofillHints` (email→`email`, password→`password`, newPassword→`newPassword`, name→`givenName`), `obscureText` plus a reveal `IconButton` with a tooltip, and `minLines 1 / maxLines 5` for multiline.
  - Uses a `labelText` (never hint-only).
  - `autovalidateMode: onUserInteraction`.
- `SegmentedToggle<T>({required List<(T value, String label)> segments, required T selected, required ValueChanged<T> onChanged})`:
  - iOS: `CupertinoSlidingSegmentedControl`.
  - Others: `SegmentedButton<T>(showSelectedIcon: false)`.
  - Min height 48. `HapticFeedback.selectionClick()` on change.
  - Each segment has `Semantics(selected:)`.
- `ActionTile({required IconData icon, IconData? selectedIcon, required String label, bool selected = false, required VoidCallback onTap})`:
  - Min 72×72. Tonal `surfaceContainer` fill, or `primaryContainer` when selected. Radius md.
  - `labelMedium`, max 2 lines, grows with text scale.
  - `Semantics(button: true, toggled: selected when selectedIcon != null)`.
  - Icon swaps via `AnimatedSwitcher(MNMotion(short))`, pop scale via `MNSprings.pop` when `allowScale`.
- `class AppFeedback`:
  - `static void info(BuildContext, String msg)`
  - `static void error(BuildContext, String msg, {VoidCallback? onRetry})`
  - `static void undo(BuildContext, String msg, {required VoidCallback onUndo})`
  - All three use one floating `SnackBar`, `duration` 6 s (10 s with an action), with `SemanticsService.sendAnnouncement` for errors.
  - `static Future<bool> confirmDestructive(BuildContext, {required String title, required String message, required String confirmLabel})`: `showAdaptiveDialog`; the iOS action uses `isDestructiveAction`; Android shows a `TextButton` in `colorScheme.error`; Cancel is the default; `HapticFeedback.mediumImpact()` on confirm.

- [ ] **Step 1: Write failing tests.**
  - `app_text_field_test`: `kind: email` → `TextField.keyboardType == TextInputType.emailAddress` and `autofillHints == [AutofillHints.email]`; password reveal toggles `obscureText`; the reveal button has a tooltip.
  - `segmented_toggle_test`: tapping the second segment calls `onChanged`; on `debugDefaultTargetPlatformOverride = iOS` it finds `CupertinoSlidingSegmentedControl`; under `Directionality(rtl)` the first segment is right of the second; `androidTapTargetGuideline` passes.
  - `action_tile_test`: `toggled` semantics true when selected; the tap-target guideline passes.
  - `feedback_test`: `confirmDestructive` returns false on Cancel and true on confirm; `undo` shows a `SnackBarAction` whose tap calls `onUndo`.
- [ ] **Step 2:** Run `flutter test test/components` and confirm the new tests fail.
- [ ] **Step 3:** Implement the four components.
- [ ] **Step 4:** Run `flutter test && flutter analyze` plus the grep. Expect PASS.
- [ ] **Step 5:** Commit with `feat(components): text field, segmented toggle, action tile, feedback`.

### Task 5: App shell, routes and Library shell

**Audit:** C11 (shell part), H1, H2, H3, H16, H22 (tab bar and tickers). **Spec:** §6, §7.

**Files:**
- Modify: `lib/src/widgets/Navbar/Navbar.dart` (becomes `AppShell`; keep the old class name `CustomBottomNavigationBar` as a typedef so `auth.dart` compiles)
- Create: `lib/src/widgets/Navbar/chrome_bar.dart`, `lib/src/navigation/routes.dart`, `lib/src/pages/UI/library_page.dart`
- Modify (constructor only): `lib/src/pages/UI/detail_page.dart:30-44`, adding `final String? heroTag;`
- Modify (barrel): `lib/src/pages/allpages.dart`, adding the `library_page.dart` export
- Test: `test/navigation/app_shell_test.dart`, `test/navigation/routes_test.dart`

**Interfaces:**
- Consumes `SignInPrompt`, `SegmentedToggle` and `PosterCard`.
- Produces:
  - `Future<void> openTitle(BuildContext, {required int id, required bool isTv, String? heroTag})` pushes `DetailPage` on the **tab's** navigator.
  - `Future<void> openSeeAll(BuildContext, {required String title, required Future<Model> Function() load, required bool isTv})`.
  - `Future<void> presentSignIn(BuildContext)` pushes `LoginWelcomeScreen` on the **root** navigator with `fullscreenDialog: true`.
  - `class AppShell`:
    - 4 destinations, always: Home, Search (Explore), Library, Profile (`SettingsScreen` when signed in, `SignInPrompt` when signed out).
    - A `GlobalKey<NavigatorState>` per tab.
    - Re-tapping the current tab pops to the first route; if already at the root, it animates `PrimaryScrollController` to 0.
    - `PopScope` pops the inner navigator first.
    - Each tab is wrapped in `TickerMode(enabled: i == current)`.
    - `currentIndex` is preserved across auth changes.
    - `static AppShellState of(BuildContext)` / `maybeOf`.
    - `void selectTab(int index)` (used by Library's "Browse Movies").
  - `ChromeBar`:
    - iOS: floating `ClipRRect(radius 28)` + `BackdropFilter(σ 24)` + `MNColors.chrome` + hairline, with an 8 pt inset above the home indicator.
    - Others: `NavigationBar` with background `surfaceContainer`, opaque.
    - Labels `labelMedium` (12 pt); Iconsax outline/bold icons.
    - `highContrast` → opaque on both platforms.
  - `LibraryPage`:
    - A `SliverAppBar` titled `S.likednavbar`.
    - A `SegmentedToggle` with Liked | Watchlist; bodies are the current `Liked()` and the existing Watchlist page body. T11 replaces both with `LikedView` / `WatchlistView`.
    - Signed out: `SignInPrompt`.
  - Remove the Watchlist row from Settings in T13, not here.

- [ ] **Step 1: Write failing tests.**
  - `app_shell_test`:
    - Pump `AppShell(isSignedIn: false)` with Firebase-free fakes; inject the page builders through an optional `pagesBuilder` param for tests.
    - Expect 4 `NavigationDestination`s (Android) and `SignInPrompt` on tab 3.
    - Toggling `isSignedIn` keeps the index.
    - Re-tapping the active tab after a push pops back to the root.
  - `routes_test`: two `PosterCard`s for id 1 with different sources inside a tab navigator; `openTitle(heroTag: heroTagFor(source: 'trending', …))` pushes without throwing.
- [ ] **Step 2:** Run `flutter test test/navigation` and confirm it fails.
- [ ] **Step 3:** Implement the shell, `ChromeBar`, `routes.dart`, `LibraryPage` and the `DetailPage.heroTag` field.
- [ ] **Step 4:** Run `flutter test && flutter analyze` plus the grep on the new files. Expect PASS.
- [ ] **Step 5:** Commit with `feat(shell): four fixed tabs with per-tab navigators, chrome bar, routes`.

---

**Wave 3. Every task below runs in parallel, owns only the files it lists, and follows the same five steps:**
1. Write the listed tests.
2. Run them and see them fail.
3. Implement.
4. Run `flutter test && flutter analyze` plus the token grep on the owned files.
5. Commit with `feat(<area>): …`.

Screens that call `FirebaseAuth.instance` or TMDB directly in `initState` are not widget-tested. Test the extracted pieces named in each task. Phase 5 checks the screens by hand.

### Task 6: Home

**Audit:** C11, C13, H8, H9, H15, H22, M3, M14, L8. **Signature:** spill glow (Home).
**Files:** `pages/UI/home_page.dart`, `widgets/Home_page_listview.dart`, `widgets/movies_listview.dart`, `widgets/upcoming.dart`, `widgets/carousel_slider.dart`, `widgets/tvshow_listview.dart`, `pages/UI/showallmovies.dart`, `widgets/shimmerWidgets/{movieListViewShimmerWidget,upcomingShimmerWidget}.dart`. Test: `test/widgets/movies_listview_test.dart`.

**Decisions:**
- **Page structure:**
  - `CustomScrollView` with `SliverAppBar.large(title: 'Movie Night')`.
  - A pinned `SegmentedToggle` (Movies first) in a `SliverPersistentHeader`.
  - `SpillGlow` behind the top, sourced from the focused carousel poster.
  - `RefreshIndicator.adaptive`. Futures become non-final State fields rebuilt by `_reload()`.
  - The Movies/TV switch cross-fades the sections (`AnimatedSwitcher`, `MNMotion.fade(short)`) and scrolls back to the top.
- **Rails:**
  - `SectionHeader` + `ListView.builder(itemExtent: PosterSize.itemExtent)` of `PosterCard(heroTag: heroTagFor(source: <section key>, …))`.
  - When `PosterSize.stackRails`, show the first 6 items as a vertical list of `PosterCard`-row variants.
  - Errors render `ErrorState(compact: true, onRetry)`.
- **Carousel:**
  - Uses `CachedImageCustom` and a scrim gradient instead of `BackdropFilter`.
  - A dot indicator (`AnimatedContainer`-free: opacity/scale transforms only).
  - `enlargeCenterPage: MNMotion.of(ctx).allowScale`.
  - Remove the 21st "See all" card; the `SectionHeader` covers it.
  - `selectionClick` haptic only on `CarouselPageChangedReason.manual`.

**Test:**
- `MoviesListView(future: Future.error(...))` shows "Try Again"; tapping it calls the injected `onRetry`.
- At `textScaler 1.6` it renders vertically (`find.byType(ListView)` axis vertical).

### Task 7: Search and genres

**Audit:** C11, C13, H7, M1, M11, L4.
**Files:** `pages/UI/explore.dart`, `widgets/genreslistview.dart`, `widgets/search.dart`, `widgets/shimmerWidgets/{genreListViewShimmerWidget,searchResultShimmerWidget}.dart`. Test: `test/widgets/genres_grid_test.dart`.

**Decisions:**
- **Explore page:**
  - `SliverAppBar.large(title: S.explorenavbar)`.
  - A real `SearchBar` (hint `S.searchhint`) that opens the existing `showSearch` delegate.
  - A genre `TabBar` (`isScrollable`, `tabAlignment: start`).
  - Each genre is a `SliverGrid(SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: PosterSize.width + 12, childAspectRatio: width / (height + captionHeight)))` of `PosterCard`.
- **Search delegate:**
  - `buildLeading` → `BackButton()`.
  - Result rows use an `MNRadius.sm` 40×60 poster thumbnail, subtitle "Movie · 2023".
  - Empty results → `EmptyState(S.noResultsFor(query))`; error → `ErrorState`.
  - History has a "Clear" `TextButton` and swipe-to-remove plus a trailing remove `IconButton` with a tooltip. Persistence stays in the existing prefs key.

**Test:**
- The grid at 390 wide has 2 columns; at 834 wide, ≥ 4 columns.
- The error future shows `ErrorState`.

### Task 8: Detail (core)

**Audit:** C1, C13, H4, H5 (videos), H12, H13, H15, H21, M2, M9, M12, L2, L3, L5, L9. **Behaviour:** B6, B7. **Signature:** spill glow (Detail).
**Files:**
- `pages/UI/detail_page.dart` (except the constructor field T5 already added)
- `widgets/addtowatchlist.dart`, `widgets/watch_provider.dart`, `widgets/Buy_provider.dart`, `widgets/similar.dart`, `widgets/videos.dart`, `repository/Getvideos.dart`, `widgets/shimmerWidgets/detailPageShimmerWidget.dart`

Test: `test/widgets/detail_actions_test.dart`.

**Decisions:**
- **Header:**
  - `SliverAppBar(pinned: true, stretch: true, expandedHeight: 260)`.
  - Backdrop as `FlexibleSpaceBar.background` inside `SpillGlow`.
  - The title fades in when collapsed.
  - The share `IconButton` (tooltip) sits in the app bar `actions`.
  - Waiting and error branches get a plain `AppBar()` and an `ErrorState(S.couldntLoadTitle, onRetry)`. No raw `snapshot.error`.
- **Info block:**
  - Poster in `Hero(widget.heroTag)`. Tapping it calls `showPosterViewer`.
  - Below the header (`LayoutBuilder`; side-by-side at ≥ 600): title `headlineSmall`, meta `bodyMedium onSurfaceVariant` "2023 · 2h 6m · Action, Drama" (one `Text`, no " . " widgets), `RatingBadge(showSource: true)`. The IMDb logo is removed from the score.
- **Actions:**
  - One `FilledButton.icon` "Watch Trailers" (the single primary action).
  - A row of `ActionTile`s:
    - Like (heart): pop + `lightImpact`.
    - Watchlist (bookmark outline/bold; label `inWatchlist` when selected): `lightImpact`; failure → `heavyImpact` + `AppFeedback.error(watchlistUpdateFailed)`.
    - IMDb (`SimpleIcons.imdb`, opens the URL).
  - Signed out: Like, Watchlist and Reviews call `presentSignIn`; Share and IMDb work.
  - Share text: `S.shareText(isTv ? name : title, 'https://www.themoviedb.org/${isTv?'tv':'movie'}/$id')`.
- **Sections:**
  - Storyline: `bodyLarge`, `maxLines: 4` plus a "Read more" `TextButton` (`AnimatedSize` inside its own box).
  - Cast and Similar keep the `_KeepAlive` sliver pattern and use `SectionHeader`.
  - Watch and buy providers: a loading skeleton, then a persistent empty text (no timer), with fixed `SizedBox(height: 96)` rails.
- **Videos page:** a single `ListView.separated` of 16:9 `InkWell` cards with a centered 64 pt play icon. Each card has `Semantics(label: S.playVideo(name))`, platform physics, and `ConstrainedBox(maxWidth: 700)`.

**Test:** an extracted `DetailActions` widget (`isLoggedIn` param, injected callbacks). Signed out: tapping Like calls the injected `onRequireSignIn`; Share stays enabled; all `ActionTile`s pass `labeledTapTargetGuideline`.

### Task 9: Reviews

**Audit:** H5, H15, H20, L1, M18. **Behaviour:** B4 (review delete confirm).
**Files:** `pages/UI/Reviews_page.dart`, `widgets/local_Reviews.dart`, `widgets/global_Reviews.dart`. Create `pages/UI/all_reviews_page.dart`. Test: `test/widgets/review_card_test.dart`.

**Decisions:**
- `SegmentedToggle` (Movie Night | TMDB) replaces `Typeswitch`.
- Inline: the first 3 reviews as plain `Column` children (no inner scroll view), then a `TextButton` `S.seeAllReviews(n)` that pushes `AllReviewsPage` (a `ListView.builder`).
- Extract `ReviewCard({author, date, body, onDelete?})`:
  - `surfaceContainer` card, author `titleMedium`, date `bodySmall onSurfaceVariant`.
  - Body `maxLines: 5` with per-card expand state; "Read more" shows only when `TextPainter.didExceedMaxLines`.
- The composer uses `AppTextField(kind: multiline, label: …)` with an `IconButton.filled` send, disabled while the field is empty.
- Delete goes through `AppFeedback.confirmDestructive(deleteReviewTitle…)`.
- Loading shows a skeleton, not "No Reviews".
- Signed out shows `SignInPrompt(body: signInToReview)`. That is wired by T8, which decides the visibility; T9 renders the reviews section only.

**Test:** a long body shows Read more and a short body does not; expanding one card does not expand another; delete calls the injected confirm.

### Task 10: Cast

**Audit:** C1, H4, H7, M2. **Files:** `pages/UI/castdetails.dart`, `widgets/cast.dart`, `widgets/cast_movies.dart`. Test: `test/widgets/cast_rail_test.dart`.

**Decisions:**
- `castdetails`:
  - Uses the `DetailPage` sections pattern: pinned `SliverAppBar(expandedHeight: 320, stretch)` with the headshot, name as title, a bio with "Read more", then "Known For" rails of `PosterCard(heroTag: heroTagFor(source: 'cast-$personId', …))`.
  - Has a shimmer skeleton instead of a spinner and `ErrorState` instead of raw error text.
  - Tapping the headshot calls `showPosterViewer`.
- Cast rail:
  - `SizedBox(height: MNSize.avatar + caption)`.
  - Each item is a `PressableScale` with `Semantics(button, label: '$name, $character')`.
  - The local `IconsaxOutline.user` placeholder replaces the `http://` hot-link.

**Test:** a cast item has a label containing name and character; at text scale 2.0 there is no overflow.

### Task 11: Library (Liked and Watchlist)

**Audit:** C4, C5, H3, H6, H20, M10, M13, L8. **Behaviour:** B4, B5.
**Files:**
- `pages/UI/liked.dart` → `LikedView`
- `pages/Userpage/Watchlist.dart` → `WatchlistView`, without its own Scaffold
- `widgets/watchlistwidget.dart`, `widgets/watchlistscreen.dart`, `pages/UI/library_page.dart` (finish)
- `widgets/shimmerWidgets/{likedPageShimmerWidget,watchListShimmerWidget}.dart`

Test: `test/widgets/library_test.dart`.

**Decisions:**
- **Liked (compact):**
  - A `LayoutBuilder` carousel with height `min(maxH * 0.75, 520)` and `enableInfiniteScroll: false`.
  - The backdrop **cross-fades** (`AnimatedSwitcher` keyed by index, `MNMotion.fade(medium)`) instead of sliding.
  - A dot indicator.
  - Cards: `surfaceContainerHigh`, radius lg, `RatingBadge`, a remove `IconButton` (tooltip).
  - Regular width (≥ 600): a `SliverGrid` of `PosterCard`.
- **Watchlist:**
  - Movies/TV `SegmentedToggle`.
  - Rows show poster thumbnail, title, year and `RatingBadge`, with a trailing remove `IconButton` (tooltip) plus a `Slidable` with `DismissiblePane` plus a `customSemanticsActions` remove.
  - The confirmation dialog is gone.
  - A stream error shows `ErrorState`. A failed item shows a compact retry row instead of vanishing.
- **Removal (both):** remove immediately, then `AppFeedback.undo(removedFrom…, onUndo: restore)`. Liked restores via `box.put(key, model)`; Watchlist via the existing add call.
- **Empty states:** `EmptyState(IconsaxOutline.heart, nolikedmovies, likedEmptyBody, browseMovies → AppShell.maybeOf(context)?.selectTab(0))`.

**Test:** `LikedView` with a fake `Box` of 2 items: tap remove → item gone and a SnackBar with Undo shows; tap Undo → item restored. The empty box shows Browse Movies.

### Task 12: Auth flow

**Audit:** C2, C3, C7, C8, H9b, H11, H15, M15. **Behaviour:** B2.
**Files:** `pages/Login-Logout/{Login_welcome_screen,Login,Register,Forget_password}.dart`, `components/square_tile.dart` (stop using it; T15 deletes it). Test: `test/pages/auth_error_mapping_test.dart`.

**Decisions:**
- **Welcome:**
  - Presented modally by `presentSignIn` with a `CloseButton`.
  - `SafeArea`, the Lottie in `ConstrainedBox(maxHeight: 220)` with `animate: allowScale, repeat: false` under reduce motion.
  - Title "Movie Night" `displaySmall`, body `signInPromptBody`.
  - Bottom-anchored: Log In (`FilledButton`), Create Account (`OutlinedButton`), language as a `TextButton.icon` in the app bar actions.
  - The Pacifico "Hello" wordmark is removed.
- **Login and Register screens:**
  - Theme surface (no `#201A30`), default `BackButton`.
  - `AutofillGroup` around the fields, built from `AppTextField` kinds with `TextInputAction.next`/`done`.
  - The Google button is `OutlinedButton.icon(continueWithGoogle)`.
  - Login ↔ Register uses `pushReplacement`.
- **Submit handler:**
  - `if (!form.validate()) return;`, then `busy = true` (the button shows `CircularProgressIndicator.adaptive` at 20).
  - `await` the auth call in try/catch, mapping errors through `String authErrorText(BuildContext, FirebaseAuthException e)` (new, in `pages/Login-Logout/auth_errors.dart`).
  - Errors render inline above the button in `colorScheme.error`.
  - On success: `Navigator.of(context, rootNavigator: true).popUntil((r) => r.isFirst)`, once.
- **Forgot Password:** success replaces the form inline with a check icon, `resetLinkSent(email)` and "Back to Log In".

**Test:** `authErrorText` maps `invalid-credential`, `wrong-password`, `user-not-found`, `email-already-in-use`, `weak-password`, `invalid-email`, `network-request-failed`, `too-many-requests`, `requires-recent-login` and an unknown code to the T3 keys (English).

### Task 13: Profile and settings

**Audit:** C6, C8, C13, H12, H14, H19, M7, M8. **Behaviour:** B1, B3, B5 (remove the Watchlist row).
**Files:** `pages/Userpage/{Settings_screen,account_setting,changepassword,Update_User_details,User_info_page,profilepic,SendReports}.dart`, `widgets/{changelangwidget,themechanger,customsettingscreen,iconwidget,userinfotile}.dart`, `widgets/shimmerWidgets/userInfoTileShimmerWidget.dart`. Test: `test/widgets/appearance_setting_test.dart`.

**Decisions:**
- **Screen layout:** `SliverAppBar.large(title: profilenavbar)`, then the user tile (avatar 72, name `titleMedium`, email `bodyMedium onSurfaceVariant`), then the groups below. `Iconwidget` becomes a neutral chip (`surfaceContainerHigh`/`onSurfaceVariant`); there is no empty subtitle line.

  | Group | Rows |
  |---|---|
  | Appearance | `SegmentedToggle<AppAppearance>` System/Dark/Light, calling `setAppearance` |
  | General | Language · Report a Bug · Rate Movie Night |
  | Account | Edit Profile · Reset Password · Log Out |
  | Danger zone (spaced apart) | Delete Account (red text, default size) |

- **Delete flow (B1):** `confirmDestructive` → a blocking progress dialog → `await user.delete()` → then the Firestore delete → `AppFeedback.info(deleteAccountDone)`. On `requires-recent-login`, show `AppFeedback.error(authErrorRecentLogin)` and delete nothing.
- **Change Password** becomes "Reset Password" with subtitle `resetPasswordSubtitle`. It awaits the call and reports the real result.
- **Edit Profile:** `AppTextField`s, validators (`enterFirstName`), a Save `FilledButton` with a busy state, and the awaited result.
- **Profile picture:** a determinate `CircularProgressIndicator(value:)` from `UploadTask.snapshotEvents`, and no `snapshot.data!` crash on null.
- **Send Report:** a `Form` with required validators; the button stays disabled until it is valid. It awaits, then pops and shows `reportSent`, or `reportFailed`.
- **Language list:** default `RadioListTile` rows, no `itemExtent`, theme background.
- **Cleanup:** remove `themechanger`'s `toggleTheme` call.

**Test:** the appearance `SegmentedToggle` with a fake `ThemeProvider`. Tapping Light calls `setAppearance(AppAppearance.light)`; the selected segment reflects the provider.

### Task 14: Admin and global surfaces

**Audit:** C2, H18, M19, admin alert (M-level). **Scope:** tokens, accessibility and states only, no redesign.
**Files:** `pages/Adminpages/*.dart`, `widgets/offline_banner.dart`, `Auth/auth.dart` (splash). Test: `test/widgets/offline_banner_test.dart`.

**Decisions:**
- **Admin pages:**
  - Default `BackButton`s.
  - The loading/error branches are fixed in `admin_panel_vd` (waiting → spinner, error → `ErrorState`).
  - Delete-user uses `confirmDestructive(title: 'Delete {name}?')` with the label "Delete". **Strings:** no T3 key exists for this, so report `NEEDS_STRING deleteUserTitle`.
  - Category buttons become `ListTile`s with chevrons.
- **Offline banner:**
  - Overlay `SlideTransition` + `FadeTransition` (`MNMotion`) instead of `AnimatedSize` around the app.
  - `Semantics(liveRegion: true)`, plus `SemanticsService.sendAnnouncement` on change.
- **Splash:** logo on `surface`.

**Test:** the banner announces (`tester.takeAnnouncements()` or the liveRegion flag present) when connectivity flips to offline, via an injected stream.

### Task 15: Cleanup and token lint

**Audit:** L7, global constraints. **Files:**
- Delete the files listed under File Structure.
- `pubspec.yaml`: remove `fluttertoast`, `awesome_snackbar_content` and the Pacifico font block.
- Update the barrels `components/allcomp.dart` and `widgets/allwidget.dart`.
- Add any `NEEDS_STRING` keys to all 7 `.arb` files and regenerate.
- Create `test/design/token_lint_test.dart`.

- [ ] **Step 1:** Write `token_lint_test`. It walks `lib/src/**/*.dart`, excluding `lib/src/design/` and `lib/generated/`, and fails on the regex in Global Constraints, printing `path:line`. Allowlist exactly two sites: `simple_icons` brand colors and the `Colors.black`/`white` inside `poster_viewer.dart`, each with a one-line reason.
- [ ] **Step 2:** Run it and fix every remaining hit. Expect no hits in files owned by T6–T14. Anything left is a regression to fix here.
- [ ] **Step 3:** Delete the dead files and dependencies. Run `flutter pub get`, `dart run intl_utils:generate`, `flutter analyze` (0 errors/warnings) and `flutter test` (all pass).
- [ ] **Step 4:** Commit with `chore(ui): remove dead components and deps; enforce design tokens`.

---

## Phase 5: Verification (after T15)

1. `superpowers:requesting-code-review` on `ui-overhaul` vs `improvements/phase-2`.
2. `superpowers:verification-before-completion`:
   - `flutter analyze` (0 errors/warnings).
   - `flutter test` (all pass, count reported).
   - `flutter build apk --debug`.
   - iOS build only if a macOS host is available; otherwise reported as not verified.
3. **Manual pass on an Android emulator.** Record per-screen screenshots in `docs/ui-overhaul-screens/`.
   - Every screen (Home, Search, results, Detail, Cast, Videos, poster viewer, Library both segments, Profile, Edit Profile, Report, Language, Welcome, Log In, Create Account, Forgot Password, Admin) in:
     - light at 1.0×
     - dark at 1.0×
     - dark at 2.0× font scale (`adb shell settings put system font_scale 2.0`)
     - Arabic dark at 1.0×
   - Reduce Motion on (`adb shell settings put global animator_duration_scale 0`, which Flutter reports as `disableAnimations`).
   - High contrast on, which is Android's "High contrast text".
4. **Performance spot-check:** `flutter run --profile` Home scroll and Detail scroll; report raster/UI frame times from DevTools (target: no frames > 16 ms in steady scroll).
5. A before/after summary per screen, plus the "left for later" list (below).

## Left for later (not in this plan)

- **NavigationRail** on regular width (spec §6).
- **Forced immediate update at launch** (`services/app_update.dart`). This is a product decision.
- **Native review** of the 6 machine-translated locales (`@@x-needs-review`).
- **Golden tests**, which need pinned fonts in CI.
