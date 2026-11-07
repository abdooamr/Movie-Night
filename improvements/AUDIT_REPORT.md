# Movie Night — Full Audit Report

**Date:** 2026-11-06 · **Version audited:** 1.5.8+39 · **Branch:** main
**Scope:** `lib/` (~10,803 LOC excluding generated l10n), `android/`, `ios/`, `pubspec.yaml`

---

## 1. Architecture Summary

| Concern | Implementation |
|---|---|
| State management | `provider` ChangeNotifier only — `ThemeProvider`, `UserProvider`, `UserData`, `ReviewProvider`, `DropdownProvider` |
| Navigation | Imperative `Navigator.push(MaterialPageRoute)` throughout + index-swapped `pages[currentIndex]` in `Navbar.dart:58`. `go_router` is declared but **never imported** |
| Networking | Bare `package:http` with top-level functions in `lib/src/services/services.dart`. `tmdb_api` declared but **never imported** |
| Local storage | Hive (`liked` box, `LikedModel`) + SharedPreferences (language, search history, darkMode flag) |
| Backend | Firebase — Auth, Firestore, Storage, Messaging |
| i18n | `intl` + `flutter_intl` ARB files, 7 locales (ar, de, en, es, fr, hi, it) |

**Assessment.** A feature-rich TMDB client with Firebase-backed auth and social
features. The layering is nominally `services -> models -> widgets -> pages`, but it
does not hold in practice:

- There is **no repository layer**. `lib/src/repository/Getvideos.dart` is actually
  a full `Scaffold` page, not a repository.
- Networking is called directly from widget `initState` (`home_page.dart:33-40`,
  `explore.dart:44-75`, `cast.dart:28`, `similar.dart:26`, `global_Reviews.dart:27`).
- Firestore calls are issued from inside widget `State` classes
  (`addtowatchlist.dart:31`, `Watchlist.dart:107`, `Settings_screen.dart:42`).
- State management is effectively "`FutureBuilder` + `setState`"; Provider is used
  only for theme, language, and reviews.

### Strengths

- Clean, consistent model layer with `fromJson`/`toJson` across 15 models.
- Genuine i18n coverage — 7 locales, device-locale detection, user override.
- A dedicated shimmer-widget family (`lib/src/widgets/shimmerWidgets/`, 6 widgets)
  already exists and is wired into the main list views.
- `CachedImageCustom` (`components/Cached_image.dart`) is a sound abstraction with
  shimmer placeholder and error fallback — it is simply not used everywhere.
- Hive is correctly registered and opened before `runApp` (`main.dart:20-22`).
- Android release signing is properly externalized to `key.properties`, and that
  file plus the keystore are correctly gitignored.

### Weaknesses

- No tests, no lints, no CI signal of any kind.
- Request-per-rebuild patterns in three separate screens.
- Resource disposal is inconsistent — 21 controllers declared, 8 `dispose()` overrides.
- Significant duplicated code and dead code.

### Inconsistencies flagged

- **Two auth implementations:** `Provider/Register_provider.dart:54` and
  `services/googleauth.dart:15` are near-identical Google sign-in flows that write
  **different Firestore field names** (`firstName`/`lastName` vs `firstname`/`lastname`).
- **Two `firebase_options.dart`** files (`lib/` and `lib/src/Auth/`), different
  content, **neither imported** — `main.dart:19` calls bare `Firebase.initializeApp()`.
- **Two square-tile components:** `square_tile.dart` (`Square_Tile`) and
  `squaretile.dart` (`SquareTile`). Three text helpers: `text.dart`,
  `textcustom.dart`, `Temp_text.dart`.
- **Naming is mixed:** `settings_screen`, `userwatchlist`, `googleauth`,
  `Videos_page`, `MODELL.dart`, `details category.dart` (space in filename),
  `AdminPanelV&D.dart` (`&` in filename).

---

## 2. Tooling Results

### `flutter analyze` — 22 issues, all `info`-level, 0 errors/warnings

| Count | Issue | Locations |
|---|---|---|
| 2 | `Share` / `Share.share` deprecated, use `SharePlus` | `detail_page.dart:427` |
| 16 | `Radio.groupValue` / `Radio.onChanged` deprecated, use `RadioGroup` | `changelangwidget.dart:24,25,35,36,46,47,57,58,68,69,79,80,90,91` |
| 1 | `Switch.activeColor` deprecated, use `activeThumbColor` | `darkmodebutton.dart:18` |
| 5 | `withOpacity` deprecated, use `withValues` | `genreListViewShimmerWidget.dart:85,93`; `movieListViewShimmerWidget.dart:92,100`; `upcomingShimmerWidget.dart:55` |

> **That clean result is misleading — linting is switched off.**
> `analysis_options.yaml` has **no `include:` line**, and `flutter_lints: ^2.0.0`
> at `pubspec.yaml:95` is mis-indented *inside the `flutter_icons:` block*, so it is
> not a dev dependency at all. Confirmed: absent from `pubspec.lock`.
> **Zero lint rules are currently active.**

### `dart fix --dry-run` — "Nothing to fix!"

Consistent with no lints enabled.

### `flutter pub outdated`

- 50 dependencies locked behind newer resolvable versions.
- 22 constrained below a resolvable version.
- **`google_sign_in` is pinned to `6.2.1`** with no caret, while 7.x is current.
  This is the largest breaking-API delta in the tree.
- **Unused declared dependencies:** `go_router`, `google_fonts`, `query`,
  `tmdb_api`, `wheel_chooser`.

### `flutter test` — "Test directory \"test\" not found."

**Test coverage is 0%.** No `test/` directory exists.

---

## 3. Findings

### CRITICAL

| # | Issue | Location | Impact | Fix |
|---|---|---|---|---|
| C1 | **Hardcoded TMDB API key** committed to source | `lib/src/services/services.dart:12` | Key is in Git history and extractable from any APK | Move to `--dart-define` / `String.fromEnvironment`; **rotate the key** |
| C2 | **Explore tab fires ~80 sequential HTTP requests on mount** — 16 genres x a hardcoded `for (page = 1; page <= 5)` loop | `explore.dart:44-75` into `services.dart:100` | Multi-second stall, rate-limit risk, heavy data use; all 16 tabs load though 1 is visible | Load the visible tab lazily; parallelize pages with `Future.wait`; honour the ignored `pageCount` param (`services.dart:99`) |
| C3 | **`TabController` never disposed** — no `dispose()` in the file at all | `explore.dart:42` | Ticker leak each time Explore is built | Add `dispose()` |
| C4 | **`PageController` constructed inside `build()`** | `liked.dart:26` | New controller every rebuild, never disposed — leak plus broken page-animation state | Move to a `State` field; dispose it |
| C5 | **Network call inside a carousel `itemBuilder`** — `searchData(...)` | `liked.dart:75` | A TMDB request per item **per rebuild/scroll** — unbounded request storm | Hoist into a memoized `Future` map keyed by id |
| C6 | **Hive mutation during build** — `liked!.delete()` inside `itemBuilder` | `liked.dart:67` | Mutating the collection a `ValueListenableBuilder` is iterating, mid-build | Move to a pre-build filter step |
| C7 | **iOS `Info.plist` has no `NSPhotoLibraryUsageDescription`** despite `image_picker` use | `ios/Runner/Info.plist` vs `readuserdata.dart:37` | **Hard crash** on iOS when changing profile picture; App Store rejection | Add the usage-description keys |
| C8 | **`Search` delegate constructs its own `DropdownProvider`** instead of reading the app's | `search.dart:13` | Search always queries TMDB in `'en'`, ignoring user language; also an undisposed `ChangeNotifier` | Pass the locale in from `context` |

### HIGH

| # | Issue | Location | Impact | Fix |
|---|---|---|---|---|
| H1 | **`ThemeProvider` registered twice**; `MyApp` instantiated twice in `main` | `main.dart:26` + `main.dart:48-49`; `main.dart:31,33` | Root provider at :26 is dead; two live instances of the same notifier | Single `ThemeProvider` in the `MultiProvider`; delete the nested one and the stray `child: MyApp()` at :31 |
| H2 | **Dark-mode choice written but never read back** | writes `themechanger.dart:24`; never read in `Theme_provider.dart` | Theme resets to dark on every cold start | Hydrate `ThemeProvider` from SharedPreferences on init |
| H3 | **Home fires 8 feeds (6 of them 5-page loops, ~34 requests) regardless of Movie/TV toggle** | `home_page.dart:33-40` | Half the payload is for the hidden tab; slow first paint | Fetch on demand per toggle; cache results |
| H4 | **No timeouts, no retries, no caching on any HTTP call** | `services.dart` — all 16 functions | On a flaky network the app hangs on a spinner indefinitely | Add `.timeout()`, retry policy, response cache |
| H5 | **Detail page body is one `SliverChildBuilderDelegate` with `childCount: 1`** | `detail_page.dart:111,480` | Defeats sliver laziness — Cast, WatchProvider, Buy, Similar, Reviews all build and fetch immediately | Split into separate slivers so off-screen sections build lazily |
| H6 | **Watchlist refetches every item's details inside `itemBuilder`** | `Watchlist.dart:85-87` | One TMDB round-trip per tile per rebuild; re-fires on every Firestore snapshot | Memoize per `movieId` |
| H7 | **`isExpandedList.add(false)` inside `itemBuilder`** | `local_Reviews.dart:57` | List grows without bound on every rebuild; index/state mismatch | Key expansion state by review id |
| H8 | **`throw snapshot.error.toString()` inside `build()`** — throws a `String` | `cast.dart:118`, `upcoming.dart:171` | Unhandled exception in the build phase, red screen instead of an error state | Return an error widget |
| H9 | **28.5 MB of the 30 MB `images/` folder is unreferenced** — incl. `a5.png` 4.4 MB, `a2.png` 3.8 MB, `a4.png` 3.5 MB, `movie-countdown-venom.gif` 3.4 MB, `back2.jpg` 2.9 MB, and a stray `kanpariyasoontorn2017.pdf`. `pubspec.yaml` ships the whole directory | `pubspec.yaml:117` (`- images/`) | ~28 MB of dead weight in every build | Delete unused assets; list assets individually |
| H10 | **Lints effectively disabled** — no `include:` in `analysis_options.yaml`; `flutter_lints` mis-indented under `flutter_icons` | `analysis_options.yaml`, `pubspec.yaml:95` | No static-analysis safety net; explains the deceptively clean `analyze` | Move `flutter_lints` to `dev_dependencies`; add the `include:` line |
| H11 | **Zero tests** | no `test/` directory | No regression safety for any refactor below | Add model-parsing + provider unit tests first |

**Only 7 of 64 files in `images/` are referenced from Dart:**
`google.png`, `imdb-icon.png`, `logo.png`, `mov.jpg`, `placeholder.png`,
`popcorn.json`, `watchmovie.json`.
(`Napp_logo.png` is additionally used by `flutter_launcher_icons` at build time — keep it.)

### MEDIUM

| # | Issue | Location | Impact | Fix |
|---|---|---|---|---|
| M1 | Duplicate Google sign-in writing **different Firestore field casings** | `Register_provider.dart:54` vs `googleauth.dart:15` | Users get `firstName` or `firstname` depending on entry point | Delete `googleauth.dart`; keep one |
| M2 | Typo in support email: `miu.team4.27@gmail,com` (comma, not dot) | `SendReports.dart:16` | Bug reports are undeliverable | Fix the string |
| M3 | Two `TextEditingController`s never disposed | `SendReports.dart:14,15` | Leak per visit | Add `dispose()` |
| M4 | JSON decode + model mapping on the UI isolate, ~100 results/feed | `movie_model.dart:3`, called from `services.dart:28,52,76,108,220` | Frame drops during list population | `compute(modelFromJson, body)` |
| M5 | `Image.network` with no cache/resize in a carousel; a **remote URL used as a `FadeInImage` placeholder** | `upcoming.dart:121`; `cast.dart:79-80`, `local_Reviews.dart:73-74` | Re-downloads, no decode downscaling; the placeholder itself needs a network round-trip | Use `CachedImageCustom`; local asset placeholder |
| M6 | No `cacheWidth`/`cacheHeight` anywhere — 500px-wide posters decoded at full size into 170x240 / 120x180 slots | `movies_listview.dart:112-116`, `detail_page.dart:172-176` | ~2-4x the necessary image memory | Add `memCacheWidth`/`memCacheHeight` to `CachedImageCustom` |
| M7 | `RepaintBoundary` used **nowhere**; `BackdropFilter` in the persistent nav bar (sigma 50) and per-carousel-item (sigma 10) | `Navbar.dart:62-63`, `upcoming.dart:136-137` | `saveLayer` every frame for the whole bottom bar and each poster | Wrap in `RepaintBoundary`; consider a cheaper translucent fill |
| M8 | Horizontal lists have no `itemExtent` and no keys | `movies_listview.dart:81`, `cast.dart:50`, `genreslistview.dart:45` | Costlier layout; lost element state on reorder | Add `itemExtent`/`prototypeItem` — widths are already fixed at 170/185 |
| M9 | `print()` used for error reporting in production paths | `Register_provider.dart:49`, `reviewsprovider.dart:35,67`, `Forget_password.dart:24` | Errors silently swallowed; leaks into release logs | Structured error surface |
| M10 | Empty `catch {}` swallowing upload failures | `readuserdata.dart:54-56` | Profile-picture upload fails silently | Surface the error |
| M11 | `Navbar.dart:43` rebuilds the full `pages` list every `build`, and swaps by index | `Navbar.dart:43-58` | All four pages reconstructed on each tab tap; `initState` refetches | `IndexedStack` or `PageStorage` |
| M12 | `getGenres` rebuilds a 28-entry map on every call, once per list tile | `utils.dart:8-36` | Needless allocation per tile per frame | Hoist to a top-level map |
| M13 | No release shrinking configured | `android/app/build.gradle.kts` `release` block | Larger APK than necessary | `isMinifyEnabled` + `shrinkResources` |
| M14 | 5 unused dependencies | `pubspec.yaml` | Build time + size | Remove `go_router`, `google_fonts`, `query`, `tmdb_api`, `wheel_chooser` |
| M15 | Offline handling is one-shot at startup only; app **terminates itself** if offline | `main.dart:41-44,97-98` | No reconnect path; user is ejected from the app | Listen to `onConnectivityChanged`; show a retry state |
| M16 | `connectivityResult != ConnectivityResult.none` compares against a single value, but `checkConnectivity()` returns a `List` in `connectivity_plus` 7.x | `main.dart:42-43` | Condition may be permanently true — the offline dialog likely never fires | Verify against the 7.x API |

### LOW

| # | Issue | Location |
|---|---|---|
| L1 | Dead fully-commented files: `widgets/try.dart` (30 lines), `Navbar/loggedinmainpage.dart` (72 lines) |
| L2 | Duplicate `@override` annotation — `liked.dart:23-24`, `Getvideos.dart:29-30` |
| L3 | No-op statement `controller.initialPage == index;` (comparison, result discarded) — `liked.dart:68` |
| L4 | Unused field `late Future<Model> searchdetails;` never assigned — `liked.dart:22` |
| L5 | Unused field `late DropdownProvider dropdownProvider;` never assigned — `Reviews_page.dart:20` |
| L6 | Two unused `firebase_options.dart` files — `lib/firebase_options.dart`, `lib/src/Auth/firebase_options.dart` |
| L7 | Filenames with spaces / `&` break some tooling — `pages/Adminpages/details category.dart`, `pages/Adminpages/AdminPanelV&D.dart` |
| L8 | `lightTheme.textTheme.bodyMedium` is **white on a white scaffold** — `Theme_provider.dart:55-57`, light-mode text invisible in places |
| L9 | Hardcoded English strings despite full i18n — `local_Reviews.dart:152` 'No Reviews', `:170` 'Write a review', `main.dart:97` 'Terminating App' |
| L10 | `Visibility` still builds its child subtree — `detail_page.dart:457-463` |
| L11 | Fixed pixel sizes with no responsive breakpoints — `movies_listview.dart:80` (310), `upcoming.dart:125` (174.5), `liked.dart:111` (250) |
| L12 | No `Semantics`/`tooltip` on icon-only buttons — `liked.dart:174`, `local_Reviews.dart:122` |

---

## 4. Largest Files (refactor candidates)

| Lines | File |
|---|---|
| 544 | `lib/src/models/video_prov_model.dart` |
| 490 | `lib/src/pages/UI/detail_page.dart` |
| 326 | `lib/src/pages/UI/detail_page2.dart` |
| 282 | `lib/src/services/services.dart` |
| 250 | `lib/src/pages/UI/liked.dart` |
| 250 | `lib/src/models/tvshow_model.dart` |
| 243 | `lib/src/pages/Login-Logout/Register.dart` |
| 240 | `lib/src/pages/UI/castdetails.dart` |
| 239 | `lib/src/pages/UI/explore.dart` |
