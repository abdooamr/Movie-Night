# Open Questions — Answer Before Phase 2

Three decisions I can't make from the code alone. Phase 1 does **not** depend on
any of them — it can start immediately.

Write your answers under each question. The resume prompt in `PROMPT.md` tells
Claude to read this file first.

---

## Q1 — Were the 5-page loops in `services.dart` deliberate?

**Blocks:** Phase 2.3 (Explore), Phase 2.4 (Home)

Six functions in `lib/src/services/services.dart` contain a hardcoded loop:

```dart
for (int page = 1; page <= 5; page++) {
  final String url = '$baseUrl$endPoint$key&page=$page&language=$lang';
  final response = await http.get(Uri.parse(url));   // sequential
  // ...
}
```

`getUpcomingMovies:23`, `getTrending:47`, `getPopular:71`, `discoverMovies:100`,
`getEgyptionmovies:214`.

And `discoverMovies` accepts a `pageCount` parameter that it never uses —
`services.dart:99` even has a comment saying so:

```dart
// NOTE: you currently ignore `pageCount`; keeping behavior the same (always 5 pages).
```

Meanwhile every consumer caps display at 20 items anyway
(`movies_listview.dart:83`, `cast.dart:54`, `upcoming.dart:51`) — so roughly
**80% of the fetched data is never shown.**

Which is it?

- [ ] **(a) Deliberate** — "fetch ~100 results up front so See-All has data".
      Then Phase 2.3 parallelizes the 5 pages with `Future.wait` and makes
      loading lazy per tab. Fast to do, low risk.
- [ ] **(b) A stand-in for real pagination.**
      Then Phase 2.3 replaces it with page-1-plus-infinite-scroll and honours
      `pageCount`. Bigger change, better outcome.
- [ ] **(c) Don't know / no strong preference** — I'll go with (a) first since it
      is strictly less risky, and note (b) as a follow-up.

**Your answer:**

>a

---

## Q2 — Are there live users with both Firestore field shapes?

**Blocks:** Phase 2.8 (unify Google sign-in). **This is the highest-risk item in the plan.**

Two sign-in paths write **different field names** for the same user:

| `Register_provider.dart:70-78` | `googleauth.dart:31-39` |
|---|---|
| `firstName` | `firstname` |
| `lastName` | `lastname` |
| `report: ""` | `report: " "` (a space) |

`readuserdata.dart:19-27` reads `firstName` / `lastName`. So any user created via
`googleauth.dart` reads back **null** for both names.

- [ ] **(a) No live users / test data only** — safe to just delete
      `googleauth.dart` and move on. Phase 2.8 is a 30-minute task.
- [ ] **(b) Live users exist in both shapes** — then this needs a Firestore
      migration script before the code change. I'll scope that as a separate
      task and not touch it in Phase 2.
- [ ] **(c) Unsure** — I'll write a read-only audit script first that counts
      documents of each shape, and we decide from the result.

**Your answer:**b

>

Related, worth knowing either way: **is `googleauth.dart` even reachable?** I
found no imports of it. If it is genuinely dead, (a) applies regardless.

---

## Q3 — Should the app still terminate itself when offline?

**Blocks:** Phase 2.11 (connectivity)

`main.dart:87-103` shows a non-dismissible dialog when offline whose only action is:

```dart
Fluttertoast.showToast(msg: 'Terminating App');
SystemNavigator.pop();   // kills the app
```

Three observations:
1. There is **no retry path** — the user is ejected with no way back in.
2. The check is **one-shot at startup** (`main.dart:68-69`), so losing
   connectivity mid-session is never noticed.
3. The check itself is **probably broken** — `main.dart:42-43` compares the
   result of `checkConnectivity()` against a single `ConnectivityResult`, but
   `connectivity_plus` 7.x returns a `List`. If so, this dialog likely never
   fires today and the behaviour is already effectively "do nothing".

- [ ] **(a) Replace it** — non-blocking offline banner, cached content stays
      readable, auto-recovers when connectivity returns. **This is my recommendation**
      and what Phase 2.11 is currently written to do.
- [ ] **(b) Keep the hard block** but add a working Retry button instead of
      terminating.
- [ ] **(c) Keep as-is** — just fix the broken `List` comparison so it actually works.

**Your answer:**

>a

---

## Not blocking, but worth a decision

- **`detail_page2.dart`** (326 lines) appears to be an abandoned duplicate of
  `detail_page.dart`. Delete it? (Phase 2.6 assumes yes if unreachable.)
- **`lib/firebase_options.dart`** and **`lib/src/Auth/firebase_options.dart`** —
  neither is imported; `main.dart:19` uses bare `Firebase.initializeApp()`.
  Delete both, or wire one up? You need explicit options for web/desktop support;
  Android/iOS work fine without them via the plist/json config files.
- **Platform targets.** The repo has `web/`, `windows/`, `linux/`, `macos/`
  directories. Are any of those actually supported? It changes how much the
  `firebase_options` question and the responsive-layout work in Phase 3.3 matter.
