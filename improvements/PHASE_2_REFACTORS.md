# Phase 2 — Structural Refactors

**Prerequisite:** Phase 1 complete, and `OPEN_QUESTIONS.md` answered.
**Strongly recommended:** do task 2.12 (tests) FIRST — everything else here is a
behaviour-changing refactor with no safety net otherwise.

Effort: **S** = under 30 min · **M** = half a day · **L** = multi-day

---

## - [x] 2.12 — Bootstrap a test suite  (H11)  — DO THIS FIRST

**Effort:** M · **Risk:** None

There is no `test/` directory. Before refactoring anything below, create a
baseline that will catch regressions:

```
test/
  models/
    movie_model_test.dart      # fromJson/toJson round-trip, null handling
    moviedetails_test.dart
    credit_model_test.dart
  providers/
    theme_provider_test.dart   # toggle + persistence (after 1.7)
    langprovider_test.dart     # fallback to 'en' for unsupported locales
  utils/
    get_genres_test.dart       # the map hoisted in 1.10
```

Start with the model layer — it is pure, dependency-free, and the highest-value
place to lock behaviour before touching `services.dart`. Use real TMDB JSON
fixtures captured from the live API.

Target for this task: the models and `getGenres` under test. Widget tests can wait.

---

## - [x] 2.1 — Fix the provider graph in `main.dart`  (H1)

**Effort:** S · **Risk:** Medium — theme-toggle resolution changes, test both toggles

`lib/main.dart` currently has three defects in 10 lines:

```dart
runApp(MultiProvider(providers: [
  ChangeNotifierProvider(create: (context) => ThemeProvider()),   // :26  <- dead
  // ...
  ChangeNotifierProvider(
    create: (context) => DropdownProvider(),
    child: MyApp(),                                               // :31  <- stray
  ),
], child: MyApp()));                                              // :33

// then inside MyApp.build:
return ChangeNotifierProvider(
  create: (context) => ThemeProvider(),                           // :48-49 <- shadows :26
```

- The `ThemeProvider` at `:26` is shadowed by the one at `:48` for every descendant,
  so it is dead weight — but two live instances exist.
- The `child: MyApp()` at `:31` is ignored by `MultiProvider`'s composition; it
  constructs a throwaway widget.

Fix: keep exactly one `ThemeProvider` in the `MultiProvider` list, delete the
nested provider at `:48-49` and the stray `child:` at `:31`, and make `MyApp`
`const`-constructible.

**Test after:** both theme toggles (`darkmodebutton.dart` and `themechanger.dart`)
must still drive `MaterialApp.themeMode`.

---

## - [x] 2.2 — Rewrite `liked.dart`  (C4, C5, C6)

**Effort:** M · **Risk:** Medium — this page's logic is tangled

Three critical bugs in one 250-line `build()`:

| Line | Problem |
|---|---|
| 26 | `PageController` constructed **inside `build()`** — new instance every rebuild, never disposed |
| 75 | `searchData(liked.title, lang)` called inside the carousel `itemBuilder` — a TMDB request per item per rebuild |
| 67 | `liked!.delete()` inside the `itemBuilder` — mutating the Hive box while `ValueListenableBuilder` iterates it |

Plan:
1. Convert to a proper `StatefulWidget` lifecycle: `PageController` as a `State`
   field, created in `initState`, disposed in `dispose`.
2. Replace the per-item `searchData` call with a memoized map
   `Map<int, Future<Model>> _detailsCache` keyed by movie id, populated once.
   Better still: store `mediaType` on `LikedModel` at like-time so the lookup
   is unnecessary — the only thing `searchData` is used for here is deciding
   `isTvShow` at `liked.dart:103-105`.
3. Move the "drop un-liked entries" sweep (`:66-69`) out of `build()` into a
   `WidgetsBinding.instance.addPostFrameCallback` or, better, into the like-toggle
   path so stale entries never enter the box.
4. Delete the no-op at `:68` and the unused field at `:22` (already covered by 1.6).

---

## - [x] 2.3 — Make Explore lazy and parallel  (C2)

**Effort:** M · **Risk:** Medium — changes load semantics

`explore.dart:44-75` kicks off 16 `discoverMovies` calls in `initState`. Each one
runs `for (page = 1; page <= 5)` **sequentially** (`services.dart:100`). That is
~80 serial HTTP round-trips for a screen showing one tab.

Also note `services.dart:99`: the `pageCount` parameter is accepted and then
ignored, with a comment saying so.

Depends on **OPEN_QUESTIONS #1**. Two possible shapes:

- **If the 5-page loop is a deliberate "give me ~100 results":** keep the count but
  `Future.wait` the five page requests instead of awaiting serially, and only fire
  the request for the tab the user is actually on (`_tabController.addListener`,
  or a `Map<int, Future<Model>>` populated on first view).
- **If it was a stand-in for pagination:** replace it with real paging — fetch page
  1, then load more on scroll. Honour `pageCount`.

Either way: **lazy per-tab loading is the big win** and applies in both cases.
Do that part first.

---

## - [x] 2.4 — Make Home fetch per toggle  (H3)

**Effort:** M · **Risk:** Medium

`home_page.dart:33-40` fires all 8 feeds in `initState` — 4 movie feeds and 4 TV
feeds — but `Home_page_listview.dart:37-82` renders only one set at a time based
on the `movie`/`tvshow` booleans. Half the ~34 requests are always wasted.

Fix: fetch the TV feeds lazily on first switch to the TV tab, and cache both sets
so toggling back and forth doesn't re-fetch. Same `Future`-memoization approach
as 2.3.

While here: `home_page.dart:26-27` tracks the same state in two mutually exclusive
booleans (`movie` / `tvshow`). Collapse to a single enum or bool.

---

## - [x] 2.5 — Introduce a real repository layer  (H4, H6)

> **Done 2026-11-07.** `lib/src/data/{tmdb_client,tmdb_disk_cache,tmdb_repository,user_repository}.dart`.
> `services.dart` is now a set of thin shims over `TmdbRepository.instance`, so
> every existing call site already gets the shared client, retry, typed
> `TmdbException`s and the memory (identical-Future) + Hive disk cache (stale
> fallback up to 7 days on offline/timeout/5xx/429). Firestore moved out of
> `addtowatchlist.dart`, `Watchlist.dart`, `Settings_screen.dart`,
> `readuserdata.dart`. Tests: `test/data/` (19). Analyzer 226 → 226.
> **Follow-ups:** migrate screens off the shims onto `TmdbRepository` one at a
> time; surface `TmdbErrorKind` in error widgets (needs new ARB strings);
> Firestore still in `SendReports`, `reviewsprovider`, admin pages, and
> `Register_provider`/`googleauth` (the last two are task 2.8, blocked on the
> Q2(b) migration).

**Effort:** L · **Risk:** High — touches every page

This is the big one. Current state:
- 16 top-level functions in `services.dart`, each constructing its own URL and
  calling `http.get` with no shared client, no cache, no retry.
- Widgets call them directly from `initState`.
- Firestore calls live inside widget `State` classes.

Target:
```
lib/src/data/
  tmdb_client.dart       # single http.Client, timeout, retry, error mapping
  tmdb_repository.dart   # typed methods, in-memory + disk cache
  user_repository.dart   # all Firestore reads/writes currently in widgets
```

Key behaviours to add:
- **One shared `http.Client`** instead of a new connection per call.
- **Retry** with backoff on 5xx and timeouts (not on 4xx).
- **Response caching** — TMDB feed data is highly cacheable; a short TTL memory
  cache plus Hive-backed disk cache would eliminate most repeat traffic and give
  the app meaningful offline behaviour.
- **Typed errors** instead of `throw Exception('Failed to load X')`, so the UI can
  distinguish offline / rate-limited / not-found.
- Move Firestore out of `addtowatchlist.dart:31`, `Watchlist.dart:107`,
  `Settings_screen.dart:42`, `readuserdata.dart`.

**Also resolves H6:** `Watchlist.dart:85-87` calls `getdetails(movieId, ...)` inside
`itemBuilder`, so every tile refetches on every rebuild — and the enclosing
`StreamBuilder` rebuilds on every Firestore snapshot. With a cache in place this
becomes free; without one it is a per-scroll request storm.

Do this incrementally — one screen at a time, not a big-bang rewrite.

---

## - [x] 2.6 — Split `detail_page.dart` into real slivers  (H5)

**Effort:** M · **Risk:** Medium

`detail_page.dart:110-482` is a `SliverList` whose delegate has
**`childCount: 1`** — a single child containing a 370-line `Column`. This defeats
sliver laziness entirely: `CastWidget`, `WatchProviderWidget`, `BuyProviderWidget`,
`SimilarWidget` and `ReviewsPage` all mount immediately and each fires its own
network request, even though they are far below the fold.

Plan:
1. Extract the header block (`:118-321`) into `_DetailHeader`.
2. Extract the metadata/actions block (`:322-447`) into `_DetailActions`.
3. Emit each section as its own sliver (`SliverToBoxAdapter` per section) so
   Flutter builds them on demand.
4. `detail_page.dart:457-463` — `Visibility` still builds its child. Use an
   `if (widget.isTvShow)` in the children list instead.

Target: the file drops from 490 lines to roughly 150 plus extracted widgets.

> `detail_page2.dart` (326 lines) looks like an abandoned duplicate — check whether
> it is reachable. If not, delete it as part of this task.

---

## - [x] 2.7 — Fix search locale and add debounce  (C8)

**Effort:** S · **Risk:** Low

`search.dart:13`:
```dart
DropdownProvider dropdownProvider = DropdownProvider();
```
This constructs a **brand-new** provider rather than reading the app's. Its
`_initPrefs()` runs async, so `selectedValue` is `'en'` for the lifetime of the
delegate — **search always queries TMDB in English**, ignoring the user's language.
It is also a `ChangeNotifier` that is never disposed.

Fix: take the locale as a constructor argument from the caller
(`explore.dart:89-92` has a live `context`), or read it via `context` inside
`buildResults`/`buildSuggestions`.

**Also:** `search.dart:60` calls `searchData(query, ...)` directly in the
`FutureBuilder`'s `future:` argument, so a fresh request fires on **every
keystroke and every rebuild**. Add a debounce (~300 ms) and memoize per query string.

---

## - [x] 2.8 — Unify the two Google sign-in paths  (M1)

> **Done 2026-11-07 (code side only, Q2 = b).** `googleauth.dart` had zero
> imports — deleted. **No stored data was renamed or migrated.** Instead,
> reads tolerate both shapes: `Users.fromFirestore` uses
> `firstName ?? firstname` / `lastName ?? lastname`, with `''` fallbacks, so
> legacy docs no longer throw a TypeError on the non-nullable fields. It's used
> by `UserRepository.userStream` and `AdminPanelV&D.dart`. Writes still produce
> only the canonical shape. Sign-up and Google-sign-in Firestore writes moved from
> `Register_provider` into `UserRepository` (`createUserDocument`,
> `ensureGoogleUserDocument`).
> **Bug fixed along the way:** `displayName.split(" ")[1]` threw a RangeError for
> one-word Google names *after* auth succeeded. No doc was written, and
> `isNewUser` meant it was never retried. Now `Users.splitDisplayName`, plus
> "create the doc if it is missing" instead of `isNewUser`, so those stranded
> accounts get back-filled on their next sign-in. A cancelled picker now returns
> `false` cleanly. Tests: `test/models/user_model_test.dart` (8). Analyzer
> 226 → 224.
> **Follow-up (owner, separate task):** an optional Firestore migration that
> rewrites legacy `firstname`/`lastname` docs to the canonical keys. It is no
> longer required for correctness. Firestore is still called directly in
> `SendReports`, `reviewsprovider` and the admin pages (delete/role writes).

**Effort:** M · **Risk:** HIGH — see OPEN_QUESTIONS #2

`Provider/Register_provider.dart:54` and `services/googleauth.dart:15` are
near-identical, but write **different Firestore documents**:

| `Register_provider.dart:70-78` | `googleauth.dart:31-39` |
|---|---|
| `firstName` (split from displayName) | `firstname` (full displayName) |
| `lastName` | `lastname` (empty string) |
| `role: "User"` | `role: userrole` ("User") |
| `report: ""` | `report: " "` (a space) |

Existing user documents may be in either shape. `readuserdata.dart:19-27` reads
`firstName`/`lastName` — so users created via `googleauth.dart` would read back
`null` for both.

**Do not start this until OPEN_QUESTIONS #2 is answered.** If live users exist in
both shapes this needs a Firestore migration, not just a code deletion — scope
that separately.

Code side: delete `services/googleauth.dart`, keep `Register_provider`, and check
`googleauth.dart:9` (`FirebaseFirestore.instance.collection('users').doc()` at
field-initializer level) — that creates a throwaway doc reference on every
instantiation.

---

## - [x] 2.9 — Replace index-swapped pages with `IndexedStack`  (M11)

**Effort:** S · **Risk:** Medium — changes page lifecycle

`Navbar.dart:43-50` rebuilds the entire `pages` list inside `build()`, then
`:58` renders `pages[currentIndex]`. Every tab tap tears down the previous page
and constructs a new one — which re-runs `initState` and re-fires every network
call on that page.

Fix: hoist the list out of `build()` and use `IndexedStack` so state and scroll
position survive tab switches.

**Trade-off to confirm:** `IndexedStack` keeps all four pages alive, so all four
`initState`s run on first build. Combined with 2.3/2.4 (lazy fetching) that is
fine. Done *before* those, it would make startup worse — so **sequence this after
2.3 and 2.4**.

---

## - [x] 2.10 — Move JSON parsing off the UI isolate  (M4)

**Effort:** M · **Risk:** Low

`movie_model.dart:3` — `Model.fromJson(json.decode(str))` runs on the UI isolate.
With the 5-page loops that is ~100 results decoded and mapped per feed, called
from `services.dart:28,52,76,108,220`.

Wrap in `compute()`:
```dart
final model = await compute(movie.modelFromJson, response.body);
```

`modelFromJson` is already a top-level function, so it is `compute`-compatible as-is.

Measure before and after — if 2.3/2.4 reduce the payload enough, this may stop
mattering. Check the DevTools timeline for UI-thread jank during list population
before investing here.

---

## - [x] 2.11 — Rework connectivity handling  (M15, M16)

**Effort:** M · **Risk:** Medium

Two problems in `main.dart:41-44` and `:87-103`:

1. **The app terminates itself when offline** (`SystemNavigator.pop()` at `:98`),
   with a toast saying "Terminating App". There is no retry path — the user is
   ejected from the app. See OPEN_QUESTIONS #3.
2. **The check is one-shot**, run once in a `FutureBuilder` at `:68-69`. Going
   offline mid-session is never detected; coming back online never recovers.
3. **The comparison is likely wrong for `connectivity_plus` 7.x:**
   ```dart
   var connectivityResult = await (Connectivity().checkConnectivity());
   return connectivityResult != ConnectivityResult.none;
   ```
   In 7.x `checkConnectivity()` returns `List<ConnectivityResult>`. Comparing a
   `List` to a single enum value is always `true` — so the offline dialog
   **probably never fires at all today.** Verify against the installed version.

Target: subscribe to `Connectivity().onConnectivityChanged`, surface a
non-blocking offline banner, and let the repository layer (2.5) serve cached data.
Never call `SystemNavigator.pop()`.

---

## Phase 2 exit criteria

- [ ] Test suite from 2.12 passes
- [ ] Explore mount issues <= 5 requests (down from ~80) — see `VERIFICATION.md`
- [ ] Home cold load issues <= 12 requests (down from ~34)
- [ ] Liked and Watchlist issue zero requests on scroll
- [ ] DevTools Memory: no retained controllers after 10 push/pop cycles per screen
- [ ] Airplane-mode test: app stays usable and recovers when connectivity returns
