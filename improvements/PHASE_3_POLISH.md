# Phase 3 — Polish and Nice-to-Haves

**Prerequisite:** Phases 1 and 2 complete.
Nothing here is urgent; all of it is visible to users.

Effort: **S** = under 30 min · **M** = half a day · **L** = multi-day

---

## - [x] 3.1 — Fix the light theme's invisible text  (L8)

**Effort:** S · **Risk:** Low

`Theme_provider.dart:42-67` — `lightTheme` sets:

```dart
scaffoldBackgroundColor: Colors.white,
// ...
textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,     // <- white on white
    ),
```

`bodyMedium` is white on a white scaffold. It is used in, among others,
`detail_page.dart:256-258` (genre list), `Cached_image.dart` error text, and
`local_Reviews.dart:93-95` (review body). Those are invisible in light mode today.

Fix `bodyMedium.color` to `Colors.black87` in `lightTheme`, then **walk every
screen in light mode** — this defect has likely been masking others.

While here, consider migrating both themes to `ColorScheme.fromSeed` (both have
a commented-out `colorScheme:` line at `:38` and `:66`) for consistent Material 3
surface colours.

---

## - [x] 3.2 — Localize the remaining hardcoded strings  (L9)

**Effort:** S · **Risk:** Low

The app has 7 locales and full ARB coverage, but these are hardcoded English:

| String | Location |
|---|---|
| `'No Reviews'` | `local_Reviews.dart:152` |
| `'Write a review'` | `local_Reviews.dart:170` |
| `'Terminating App'` | `main.dart:97` (removed entirely by Phase 2.11) |
| `"As ${data[index].character}"` | `cast.dart:102` — the "As " prefix |
| `"Error"` / `'Error please log in again and try again'` | `Settings_screen.dart:182-183` |

Add keys to `lib/l10n/intl_en.arb` and the six other locale files, regenerate,
and swap in `S.of(context).*`.

---

## - [x] 3.3 — Responsive sizing  (L11)

**Effort:** M · **Risk:** Medium

Hardcoded pixel dimensions throughout, with no breakpoints — the layout is tuned
for one phone size and will look wrong on tablets and small devices:

| Value | Location |
|---|---|
| `height: 310` | `movies_listview.dart:80` |
| `height: 240, width: 170` | `movies_listview.dart:113-114` |
| `width: 174.5, height: 250` | `upcoming.dart:125-126`, `:71-72` |
| `width: 185` | `upcoming.dart:140` |
| `width: 250` | `liked.dart:111` |
| `width: 120, height: 180` | `detail_page.dart:151-154` |
| `width: 150, height: 230` | `watchlistwidget.dart:100-101` |
| `width: 200` | `detail_page.dart:182`, `watchlistwidget.dart:115` |

Note `ios/Runner/Info.plist` permits landscape on both iPhone and iPad, so these
fixed widths will be exercised in landscape today.

Approach: derive poster dimensions from a single aspect-ratio constant and
`MediaQuery.sizeOf(context).width`, with a breakpoint at ~600 dp for tablets.
Coordinate with 1.9's `itemExtent` values — they must stay in sync.

---

## - [x] 3.4 — Accessibility pass  (L12)

**Effort:** M · **Risk:** Low

- **Icon-only buttons need labels.** `liked.dart:174-190` (delete),
  `local_Reviews.dart:122-133` (delete review), `local_Reviews.dart:178-201`
  (send review), `search.dart:24-29` (clear) — all are bare `IconButton`s with no
  `tooltip` and no `Semantics` label.
- **Contrast.** `Colors.white54` / `white70` on `Colors.black38` cards
  (`local_Reviews.dart:62,80,117`) is below WCAG AA.
- **Text scaling.** Fixed-height containers (`movies_listview.dart:124`
  `height: 50` holding two lines of text) will clip at larger system font sizes.
  Test at 200% text scale.
- **Tap targets.** `SquareTile` is 85x85 (`squaretile.dart:19-20`) — fine. But
  verify the carousel "See All" affordance at `upcoming.dart:57-98`.

Run the Flutter **accessibility inspector** in DevTools and fix what it flags.

---

## - [x] 3.5 — Replace remaining spinners with the existing shimmers

**Effort:** S · **Risk:** Low

The project already has a good shimmer family in
`lib/src/widgets/shimmerWidgets/` (6 widgets), wired into `movies_listview.dart`,
`upcoming.dart`, `genreslistview.dart`, `liked.dart` and `Watchlist.dart`.

These screens still show a bare `CircularProgressIndicator`, which is a visible
inconsistency:

| Location | Context |
|---|---|
| `detail_page.dart:80-84` | Full-page detail load |
| `search.dart:51-55`, `:63-68` | Search results |
| `auth.dart:14-18` | App-launch auth gate |
| `upcoming.dart:176-181` | Fallback branch |

Build a `detailPageShimmerWidget` and a `searchResultShimmerWidget` matching the
existing style, and swap them in. `auth.dart` is the first thing users see on
cold start — worth a proper splash rather than a centred spinner.

---

## - [x] 3.6 — Naming and file conventions

**Effort:** M · **Risk:** Medium — wide import churn

Current naming does not follow Dart conventions and in two cases uses characters
that break tooling:

| Current | Should be |
|---|---|
| `pages/Adminpages/details category.dart` | `details_category.dart` (**space in filename**) |
| `pages/Adminpages/AdminPanelV&D.dart` | `admin_panel_vd.dart` (**`&` in filename**) |
| `models/MODELL.dart` | a descriptive name |
| `Provider/Register_provider.dart` | `register_provider.dart` |
| `components/Cached_image.dart` | `cached_image.dart` |
| class `settings_screen` | `SettingsScreen` |
| class `userwatchlist` | `UserWatchlist` |
| class `googleauth` | deleted in 2.8 |
| class `Videos_page` | `VideosPage` |
| class `loWelcomeScreen` | `LoginWelcomeScreen` |

Note `Provider/allproviders.dart` already exports lowercase paths
(`register_provider.dart`, `theme_provider.dart`) that differ in case from the
actual filenames — this works on Windows' case-insensitive filesystem but **will
break a case-sensitive CI runner or a macOS/Linux build**. Worth fixing even if
the rest of this task is deferred.

Do this as one mechanical commit with no behaviour change, so it is easy to review
and easy to revert.

---

## - [x] 3.7 — Structured error handling  (M9, M10)

**Effort:** M · **Risk:** Low

Replace `print`-and-swallow with something a user and a developer can both act on:

| Location | Current |
|---|---|
| `Register_provider.dart:49` | `print('Error creating user: $error')` then rethrow |
| `reviewsprovider.dart:35` | `print('Error adding review: $error')` — swallowed |
| `reviewsprovider.dart:67` | `print('Error deleting review: $error')` — swallowed |
| `Forget_password.dart:24` | `print(e)` |
| `readuserdata.dart:54-56` | **empty `catch`** — profile-picture upload fails silently |
| `Settings_screen.dart:30-38` | empty `else` branch when in-app review is unavailable |
| `Register_provider.dart:83-87` | catches, shows a toast, returns `false` — caller can't distinguish cancel from failure |

Two changes:
1. Surface failures to the user — the app already has `awesome_snackbar_content`
   and `fluttertoast` available.
2. Route errors to a single logging sink (`debugPrint` in debug, Crashlytics in
   release — Firebase is already a dependency).

Note `readuserdata.dart:54-56` is the worst of these: a user changes their profile
picture, the upload fails, and **nothing at all happens** — no error, no revert.

---

## - [x] 3.8 — Dependency upgrade sweep  (partial; remaining majors deferred until a Flutter SDK upgrade)

**Effort:** L · **Risk:** High — breaking APIs

`flutter pub outdated` reports 50 locked-behind packages and 22 constrained below
a resolvable version. Do this last, one package at a time, with the test suite
from 2.12 in place.

**Start with the low-risk ones:** `flutter_cache_manager`, `octo_image`, `mime`,
`uuid`, `posix`, `shared_preferences_platform_interface`.

**Leave for last — `google_sign_in` is pinned at `6.2.1`** (no caret) while 7.x is
current. The 7.x API is substantially different: `GoogleSignIn()` becomes a
singleton with an `initialize()` call, and `signIn()` is replaced by
`authenticate()`. Both `Register_provider.dart:57-61` and (if not yet deleted)
`googleauth.dart:18-22` would need rewriting. **Do task 2.8 before this**, so
there is only one call site to migrate.

Also pending: `material_color_utilities` 0.11 -> 0.13, `win32` 5 -> 6,
`xml` 6 -> 7, `petitparser` 6 -> 7 — most are transitive and will follow their
parents.

---

> **Status (2026-11-07):** 3.1–3.7 done. 3.8 partial: in-constraint upgrades, simple_icons 16,
> devicelocale 0.9 and the Firebase majors (core 5, auth 7, messaging 17, storage 14, firestore 7) applied;
> analyze/tests pass but Firebase needs a manual device check (login, Firestore, push, upload).
> Still blocked by Flutter 3.35.5 / Dart 3.9: flutter_email_sender, fluttertoast, shimmer, flutter_slidable,
> share_plus, cached_network_image, in_app_update (need Dart 3.10–3.13). google_sign_in left at 6.2.1.
> Not verified on device: light-mode walkthrough, 200% text scale, tablet/landscape, a11y inspector.

## Phase 3 exit criteria

- [ ] Light mode is fully legible on every screen
- [ ] No hardcoded user-facing English strings remain
- [ ] Layout holds at 320 dp wide, on a tablet, and in landscape
- [ ] Accessibility inspector reports no missing labels; 200% text scale doesn't clip
- [ ] Loading states are visually consistent (shimmer everywhere, no bare spinners)
- [ ] `flutter pub outdated` shows no *direct* dependency more than one major behind
