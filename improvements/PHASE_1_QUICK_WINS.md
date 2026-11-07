# Phase 1 — Quick Wins

**Goal:** low risk, high impact. Nothing here requires an architectural decision.
**Order matters** — tasks are sequenced so later ones don't collide with earlier ones.
**Run `flutter analyze` after each task** and report the delta.

Effort: **S** = under 30 min · **M** = half a day · **L** = multi-day

---

## - [ ] 1.1 — Rotate and externalize the TMDB API key  (C1)

**Effort:** S · **Risk:** Low (build-config change)

`lib/src/services/services.dart:12` contains:

```dart
const String key = '?api_key=cc18b713f1ab56cfab6306f06b6c1b9d';
```

Steps:
1. **Rotate the key in the TMDB dashboard first.** It is already in Git history
   and in every shipped APK — treat it as compromised regardless of what we do next.
2. Replace with `String.fromEnvironment`:
   ```dart
   const String _apiKey = String.fromEnvironment('TMDB_API_KEY');
   const String key = '?api_key=$_apiKey';
   ```
3. Add a `--dart-define=TMDB_API_KEY=...` to the run/build configs, and document
   it in `README.md`.
4. Consider `--dart-define-from-file` with a gitignored JSON for local dev.

> Note: `--dart-define` keeps the key out of source control, but it is still
> present in the compiled binary. A proxy endpoint is the only real fix if the
> key must stay private. Out of scope for Phase 1 — flagged for Phase 2.5.

> **Status 2026-11-07:** code change DONE (`env.json` + `String.fromEnvironment`).
> **Key rotation deliberately deferred** by the owner. `env.json` currently holds
> the old, publicly-exposed key `cc18b713...`.
>
> **Constraint:** TMDb regenerates the v3 key *in place* — the old key dies the
> instant a new one is issued. There is no dual-key overlap window on a single
> account, so "ship the new key, then revoke the old one later" is NOT available.
> Any rotation instantly 401s every already-installed APK until users update.
>
> Options, cheapest first:
> 1. **Second TMDb account/app** -> a second, independent key. Build new releases
>    against key B while key A stays live for old installs; revoke A once adoption
>    is high. This is the only way to manufacture an overlap window. Check TMDb's
>    terms on multiple accounts first.
> 2. **Task 2.5 proxy endpoint** — server holds the key, app never ships one.
>    Permanent fix; makes all future rotations invisible to clients. Still requires
>    one shipped update, and old installs keep using key A directly until then.
> 3. **Accept and don't rotate.** Blast radius of a leaked v3 read key is bounded:
>    public read endpoints only, no user data, no writes, no billing. Worst case is
>    quota exhaustion or TMDb banning the key for third-party abuse.
>
>  4. **Task 1.13** adds a Play forced-update gate so a later rotation can at
>     least tell users to update. It must ship on the old key first.
>
> Do NOT close this task by silently regenerating the key.

---

## - [x] 1.2 — Delete unused assets and enumerate the rest  (H9)

**Effort:** S · **Risk:** Low — verify the 7 referenced files survive

`pubspec.yaml:117` ships the whole `images/` directory (30 MB). Only these are
referenced from Dart:

```
google.png   imdb-icon.png   logo.png   mov.jpg
placeholder.png   popcorn.json   watchmovie.json
```

Plus `Napp_logo.png` — used by `flutter_launcher_icons` at build time. **Keep it.**

Steps:
1. Delete the other ~56 files (28.5 MB), including the stray
   `kanpariyasoontorn2017.pdf` and `Advantages-and-Disadvantages-of-MCDM-Methods.png`.
2. Replace the wildcard in `pubspec.yaml` with an explicit list:
   ```yaml
   assets:
     - images/google.png
     - images/imdb-icon.png
     - images/logo.png
     - images/mov.jpg
     - images/placeholder.png
     - images/popcorn.json
     - images/watchmovie.json
     - images/Napp_logo.png
   ```
3. Run the app and walk every screen — a missed asset throws at runtime, not compile time.

**Verify:** `flutter build apk --release --analyze-size` before and after.

---

## - [x] 1.3 — Add iOS permission usage descriptions  (C7)

**Effort:** S · **Risk:** None

`readuserdata.dart:37` calls `imagePicker.pickImage(source: ImageSource.gallery)`
but `ios/Runner/Info.plist` declares no usage description. This is a **hard crash
on iOS** and an automatic App Store rejection.

Add to `ios/Runner/Info.plist`:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Movie Night needs access to your photos so you can set a profile picture.</string>
<key>NSCameraUsageDescription</key>
<string>Movie Night needs camera access to take a profile picture.</string>
```

(Add the camera key only if you intend to offer `ImageSource.camera`; currently
only `gallery` is used, so `NSPhotoLibraryUsageDescription` alone is sufficient.)

---

## - [x] 1.4 — Fix the disposal gaps  (C3, M3)

**Effort:** S · **Risk:** None

**`lib/src/pages/UI/explore.dart`** — has **no `dispose()` at all**, yet creates a
`TabController` at line 42. Add:

```dart
@override
void dispose() {
  _tabController.dispose();
  super.dispose();
}
```

**`lib/src/pages/Userpage/SendReports.dart:14,15`** — `_subjectController` and
`_bodycontroller` are never disposed. Add a `dispose()` override disposing both.

**Verify:** DevTools Memory tab — push/pop Explore 10x, force GC, confirm no
retained `TabController`.

---

## - [x] 1.5 — Enable linting  (H10)

**Effort:** S · **Risk:** Low, but surfaces a lot of follow-up work

Two separate defects:

1. `pubspec.yaml:95` — `flutter_lints: ^2.0.0` is indented *inside the
   `flutter_icons:` block*, so it is a map key, not a dependency. Confirmed absent
   from `pubspec.lock`. Move it under `dev_dependencies:` and bump to `^6.0.0`.
2. `analysis_options.yaml` has **no `include:` line**. Add as the first line:
   ```yaml
   include: package:flutter_lints/flutter.yaml
   ```

Then `flutter pub get && flutter analyze`.

> **Expect a large new warning list.** Report the count. **Do not auto-fix them
> all in this task** — triage and fold them into 1.6 / Phase 3.7 as appropriate.
> `dart fix --dry-run` will become useful for the first time once this lands.

---

## - [x] 1.6 — Remove dead code and unused dependencies  (M14, L1-L6)

**Effort:** S · **Risk:** Low

**Unused dependencies** — remove from `pubspec.yaml`, none are imported anywhere:
`go_router`, `google_fonts`, `query`, `tmdb_api`, `wheel_chooser`

**Dead files** — delete:
- `lib/src/widgets/try.dart` (30 lines, fully commented out)
- `lib/src/widgets/Navbar/loggedinmainpage.dart` (72 lines, fully commented out)
- `lib/firebase_options.dart` and `lib/src/Auth/firebase_options.dart` — neither is
  imported; `main.dart:19` calls bare `Firebase.initializeApp()`.
  **Check first** whether you intend to switch to explicit options (needed for
  web/desktop). If yes, keep ONE and wire it up instead of deleting both.

**Dead code:**
- `liked.dart:22` — `late Future<Model> searchdetails;` never assigned
- `liked.dart:23-24` — duplicate `@override`
- `liked.dart:68` — `controller.initialPage == index;` is a no-op comparison
- `Reviews_page.dart:20` — `late DropdownProvider dropdownProvider;` never assigned
- `Getvideos.dart:29-30` — duplicate `@override`
- `Getvideos.dart:22` — `initState` is missing its `@override` annotation

---

## - [x] 1.7 — Fix the email typo and theme persistence  (M2, H2)

**Effort:** S · **Risk:** Low

**`SendReports.dart:16`:**
```dart
final recipient_email = "miu.team4.27@gmail,com";  // comma, not a dot
```
Every bug report sent through this screen is undeliverable. Fix to `gmail.com`.

**Theme persistence (H2):** `themechanger.dart:24` writes
`prefs.setBool('darkMode', value)` but `Theme_provider.dart` never reads it —
the theme resets to dark on every cold start. Hydrate it:

```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  ThemeProvider() { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('darkMode');
    if (isDark != null) {
      themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }
  // ... existing toggleTheme
}
```

Move the `prefs.setBool` write into `toggleTheme` so the provider owns both sides.

---

## - [x] 1.8 — Clear the 22 deprecation warnings

**Effort:** M · **Risk:** Low — but the `Radio` migration touches 16 call sites

| Fix | Files |
|---|---|
| `Share.share(...)` to `SharePlus.instance.share(ShareParams(text: ...))` | `detail_page.dart:427` |
| `Radio.groupValue`/`onChanged` to a `RadioGroup` ancestor | `changelangwidget.dart` — 8 `Radio`s, lines 24-91 |
| `Switch.activeColor` to `activeThumbColor` | `darkmodebutton.dart:18` |
| `withOpacity(x)` to `withValues(alpha: x)` | `genreListViewShimmerWidget.dart:85,93`, `movieListViewShimmerWidget.dart:92,100`, `upcomingShimmerWidget.dart:55` |

The `changelangwidget.dart` change is the only non-mechanical one: wrap the eight
`Radio` widgets in a single `RadioGroup<String>` and lift `groupValue`/`onChanged`
onto it. **Test the language switcher for all 7 locales afterwards.**

---

## - [x] 1.9 — Image decode sizing, repaint boundaries, item extents  (M6, M7, M8)

**Effort:** S · **Risk:** Low

**M6 — decode downscaling.** Posters come from TMDB at `w500` but render into
170x240 and 120x180 slots. Add optional cache dimensions to
`components/Cached_image.dart` and pass them through:

```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  memCacheWidth: width != null ? (width! * MediaQuery.devicePixelRatioOf(context)).round() : null,
  // ... existing
)
```
Call sites: `movies_listview.dart:112-116`, `detail_page.dart:172-176`,
`watchlistwidget.dart:107-111`.

**M7 — `RepaintBoundary`.** There are currently zero in the codebase. Two hot spots:
- `Navbar.dart:62-63` — a `BackdropFilter(sigma 50)` on the persistent bottom bar
  does a full-width `saveLayer` every frame. Wrap in `RepaintBoundary`.
- `upcoming.dart:136-137` — `BackdropFilter(sigma 10)` per carousel item.
  Wrap each item; consider whether a plain translucent `Container` would look
  close enough for far less cost.

**M8 — `itemExtent`.** Widths are already fixed, so this is free:
- `movies_listview.dart:81` — horizontal list, items are 170 wide + 6 padding
- `cast.dart:50` — horizontal list
- `genreslistview.dart:45`

Add `itemExtent:` (or `prototypeItem:`) to each `ListView.builder`.

---

## - [x] 1.10 — Hoist the genre map out of `getGenres`  (M12)

**Effort:** S · **Risk:** None

`utils.dart:8-36` allocates a 28-entry `Map<int, String>` on **every call** —
and it is called once per list tile, per frame. Because the values are
`S.current.*` (locale-dependent) it cannot be a plain `const`. Use a lazily
rebuilt cache keyed on locale:

```dart
String? _cachedLocale;
Map<int, String>? _cachedGenres;

Map<int, String> _genreMap() {
  final loc = Intl.getCurrentLocale();
  if (_cachedLocale != loc) {
    _cachedLocale = loc;
    _cachedGenres = { 28: S.current.Actiongenre, /* ... */ };
  }
  return _cachedGenres!;
}
```

Also simplify the accumulation loop (lines 38-53) to
`genres.map((g) => map[g]).whereType<String>().join(', ')`.

---

## - [x] 1.11 — Add timeouts to every service call  (H4, partial)

**Effort:** S · **Risk:** Low

All 16 functions in `lib/src/services/services.dart` call `http.get` with no
timeout. On a flaky network the UI sits on a spinner forever — and
`cast.dart:118` / `upcoming.dart:171` then `throw` a raw String into `build()`.

Introduce one helper and route every call through it:

```dart
const _timeout = Duration(seconds: 15);

Future<http.Response> _get(String url) =>
    http.get(Uri.parse(url)).timeout(_timeout);
```

Retry/caching is Phase 2.5 — this task is just the timeout.

**Pair with H8:** while in these files, replace
`throw snapshot.error.toString()` at `cast.dart:118` and `upcoming.dart:171`
with a returned error widget. Throwing a `String` from `build()` produces a red
screen rather than a recoverable state.

---

## - [x] 1.12 — Enable Android release shrinking  (M13)

**Effort:** S · **Risk:** Medium — requires a release-build smoke test

`android/app/build.gradle.kts` has a `release` buildType with signing and
`debugSymbolLevel`, but no shrinking. Add:

```kotlin
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        isMinifyEnabled = true
        isShrinkResources = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
        ndk { debugSymbolLevel = "SYMBOL_TABLE" }
    }
}
```

**This must be smoke-tested on a real release build.** R8 can strip classes that
Firebase and reflection-based plugins need. If anything breaks, add keep rules to
`android/app/proguard-rules.pro` rather than disabling shrinking.

---

## - [x] 1.13 — Add a Play Store forced-update gate  (deploy enabler, pairs with 1.1)

**Effort:** S · **Risk:** Low (additive, Android-only) · **Model:** Sonnet

**Why this exists:** task 1.1 cannot be closed without rotating the TMDB key, and
TMDb regenerates the v3 key *in place* — the old key dies the moment a new one is
issued, instantly 401-ing every installed APK. Google Play has no server-side
force-update switch and old builds contain no update check, so there is currently
**no way to tell existing users to update.** This task ships that capability so a
later rotation is survivable.

The app is distributed on Google Play only, so the Play In-App Updates API applies.

Steps:
1. Add the dependency:
   ```yaml
   in_app_update: ^5.0.0
   ```
   Requires Android API 21+. The project inherits `flutter.minSdkVersion`, which
   already satisfies this — no `build.gradle.kts` change needed.

2. Check on app start (after the first frame, not in `main()` — it needs a
   live Activity):
   ```dart
   final info = await InAppUpdate.checkForUpdate();
   if (info.updateAvailability == UpdateAvailability.updateAvailable) {
     await InAppUpdate.performImmediateUpdate();   // full-screen, non-dismissible
   }
   ```
   Use `performImmediateUpdate()` — `startFlexibleUpdate()` is dismissible and
   does not gate anything.

3. Wrap in try/catch. `checkForUpdate()` throws on sideloaded builds, on
   emulators without Play Services, and in debug. **A failed check must never
   block app start.**

4. Guard with `Platform.isAndroid` so iOS/web/desktop builds are unaffected.

**Verify:** cannot be tested from a debug build. Requires an internal-testing
track release in Play Console with a `versionCode` lower than the one published,
installed via Play. Budget time for this — it is the only way to see the real flow.

> **Ordering note:** this must ship in a release built with the **old** key. It
> protects the *next* rotation, not the current one. Sequence:
> ship 1.13 on the old key -> watch adoption in Play Console -> rotate the key ->
> ship again. Stragglers then hit a hard update wall instead of silent empty lists.
>
> Alternative that collapses this into one release: register a second TMDb
> account for an independent key B, build against it, and leave key A alive for
> old installs. See the note under task 1.1.

---

## Phase 1 exit criteria

- [ ] `flutter analyze` is clean (or every remaining item is triaged and logged)
- [ ] `flutter build apk --release` succeeds and the app launches
- [ ] Manual walkthrough: Home, Explore, Detail, Liked, Watchlist, Settings,
      language switcher (all 7 locales), dark/light toggle, login/logout
- [ ] APK size recorded in `BASELINE_METRICS.md` — expect roughly -28 MB from
      assets plus whatever R8 contributes
- [ ] No retained controllers in the DevTools Memory tab after 10 push/pop cycles
