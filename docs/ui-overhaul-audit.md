# Movie Night — UI Audit (Phase 1)

**Date:** 2026-11-07 · **Branch:** `ui-overhaul` (from `improvements/phase-2` @ 5ea15af)
**Stack:** Flutter 3.35 · Material 3 · Provider · Firebase · TMDB · ships iOS + Android · 7 locales (en, ar RTL, fr, de, es, hi, it)
**Method:** six parallel read-only audits (navigation/layout, components, typography/color, motion, accessibility, states/copy) against Apple HIG pages in `~/.claude/skills/apple-design/references/hig/`, applied as design principles to a cross-platform Flutter app. Findings deduplicated below. All contrast ratios are computed WCAG 2.x values (alpha composited over the real background).
**Baseline:** `flutter analyze` 0 errors / 0 warnings / 224 infos · `flutter test` 66/66 pass.

## Summary

**Rating: Critical issues.** The dark theme has strong base contrast, a solid sliver/lazy detail page, and good offline and skeleton loading. But the app has **no accessibility semantics at all**: 0 `Semantics`, 0 `semanticLabel`, and only 4 of 20 icon- or image-only controls have a name.

- **Theme and type:** the light theme is broken in many places, and the Poppins weights are swapped in `pubspec.yaml`.
- **Destructive actions:** Delete Account runs on one tap.
- **Auth flows:** Login and Register pop before the auth call finishes.
- **Navigation:** the tab bar changes shape when you sign in.
- **Visual system:** about 330 hard-coded colors, 38 hard-coded font sizes, 9 different purples, 3 icon families, 5 poster-card variants and 4 feedback systems.

**Thesis today:** a dark poster browser with a purple accent. **Remembered by:** nothing specific yet. The palette is indigo-on-navy plus Material's baseline purple. Pacifico, a café-style script, is used on interactive links.

Severity counts after dedupe: **Critical 13 · High 22 · Medium 19 · Low 9**.

---

## Critical

**C1. Posters, avatars and video thumbnails have no accessible name.**
- Where (systemic): `widgets/movies_listview.dart:97`, `widgets/upcoming.dart:113`, `widgets/genreslistview.dart:63`, `widgets/cast_movies.dart:49`, `widgets/cast.dart:62`, `pages/UI/detail_page.dart:200`, `pages/UI/castdetails.dart:79`, `widgets/videos.dart:76`.
- What: a `GestureDetector` wraps the image, and the title is a sibling outside the tap target. Screen readers hear an unnamed button, then a title that does nothing. There are 0 `Semantics` and 0 `semanticLabel` in the app.
- Why: `voiceover.md › Descriptions`: "Provide alternative labels for all key interface elements."
- Fix: one shared `PosterCard`, an `InkWell` covering both poster and caption, wrapped in `Semantics(button: true, label: '$title, $year', excludeSemantics: true)`.

**C2. Six back buttons are icon-only with no tooltip, and they hard-code the iOS chevron in white.**
- Where: `pages/Login-Logout/Login.dart:66`, `Register.dart:57`, `Forget_password.dart:40`, `pages/Adminpages/report_page.dart:53`, `fulldetails.dart:29`, `add_admin.dart:50`.
- Why: `voiceover.md › Descriptions`: "Add labels to any custom elements your app defines." Also `toolbars.md › Navigation`: "Use the standard Back and Close buttons."
- Fix: delete the `leading:` overrides so `AppBar` supplies the adaptive `BackButton`, which has a localized tooltip.

**C3. The Google sign-in button is an unlabeled 60 pt image.**
- Where: `components/square_tile.dart:14-23`, used at `Login.dart:189` and `Register.dart:225`.
- Why: `buttons.md › Content`: "Ensure that each button clearly communicates its purpose."
- Fix: `OutlinedButton.icon(icon: Image.asset('images/google.png', height: 20, excludeFromSemantics: true), label: Text(S.continueWithGoogle))`, full width, at least 48 pt tall.

**C4. Removing a watchlist item is swipe-only.**
- Where: `widgets/watchlistwidget.dart:32-36`.
- Why: `accessibility.md › Mobility`: "if you use a swipe gesture to dismiss a view, also make a button available."
- Fix: add a visible trailing `IconButton(tooltip: …)` plus `Semantics(customSemanticsActions: {…remove…})`. Keep the swipe.

**C5. The Liked-card rating is conveyed by color alone and is silent to screen readers.**
- Where: `pages/UI/liked.dart:204-214`.
- What: five identical stars, amber versus grey. Amber `#FFC107` on white is 1.63:1.
- Why: `color.md › Inclusive color`: "Avoid relying solely on color to differentiate…"
- Fix: a shared `RatingBadge` that shows the number plus one star, with `Semantics(label: '7.3 out of 10')`.

**C6. Delete Account runs on one tap, with no confirmation, and in an order that can half-delete.**
- Where: `pages/Userpage/Settings_screen.dart:168-192`.
- What: `Userx.delete()` is called without being awaited, and the Firestore document is deleted regardless. If Firebase returns `requires-recent-login`, the auth account survives while its profile data is gone.
- Why: `alerts.md › Best practices`: "…an uncommon destructive action that they can't undo, it's important to display an alert." Also `managing-accounts.md › Deleting accounts`.
- Fix: show an adaptive destructive confirmation with Cancel as the default. Then `await` the auth delete, and delete the Firestore document only after it succeeds. Show progress and a final confirmation. Move the row away from Log Out.

**C7. Login pops twice and never validates. Register closes even when the form is invalid.**
- Where: `Login.dart:26-49,140-143` and `Register.dart:152-171`.
- What:
  - Login: `SignIn()` is not awaited and is followed by a `pop`, then `SignIn` pops again. Errors land on a disposed context, and every failure shows the same hard-coded English password message.
  - Register: `pop` sits outside `if (validate())`. `createUser` is not awaited, and `passwordconfiremed()` is never called.
- Why: `feedback.md › Best practices`: "Show people when a command can't be carried out and help them understand why." Also `buttons.md › Mobile` (activity indicator).
- Fix: an async handler that validates first, sets a busy flag (button shows an adaptive spinner), awaits the call inside try/catch, maps `FirebaseAuthException.code` to localized inline errors, and pops once on success.

**C8. The light theme is broken by dark-only literals.**
- `components/text.dart:17`: white Pacifico on white is 1.00:1.
- `Update_User_details.dart:89-98`: black label on `#312770` is about 1.55:1.
- `Forget_password.dart:121`: black on indigo is about 1.6:1.
- `changelangwidget.dart:13-16`: forces `#171823`, so the app bar title is about 1.2:1.
- `formfield.dart:25`: white input text.
- Auth screens force `#201A30` in both themes.
- Why: `dark-mode.md › Best practices`: "Ensure that your app looks good in both appearance modes."
- Fix: semantic color tokens only (see the design system).

**C9. Poppins weights are swapped.**
- Where: `pubspec.yaml:127-130`.
- What: `Poppins-SemiBold.ttf` is declared as weight 400 and `Poppins-Regular.ttf` as 600. All default text renders SemiBold, and every "w600" title renders Regular, so the hierarchy is inverted on every screen.
- Why: `typography.md › Ensuring legibility`: "font weight can also impact how easy text is to read."
- Fix: map the weights correctly. Under the new type system Poppins is used for display text only.

**C10. There is no `ColorScheme`, so Material's baseline purple leaks in.**
- Where: `Provider/theme_provider.dart:37-87`.
- What: the light-theme "Watch videos" label is `#6750A4` on `#312770` at 1.97:1. The light "Read more" link is 2.40:1.
- Why: `color.md › Best practices`: "If you define a custom color, make sure to supply light and dark variants."
- Fix: explicit `ColorScheme`s for both appearances (see the design system).

**C11. Home and Explore headers sit under the status bar / Dynamic Island, then the list adds a second inset.**
- Where: `pages/UI/home_page.dart:48` (`SizedBox(height: 40)`) and `explore.dart:75`.
- What: the content starts at y≈50, but the top inset is 59–62 pt. The inner `ListView` then adds `padding.top` again, leaving a blank band of about 59 pt.
- Why: `layout.md › Guides and safe areas`: "Respecting the safe area is essential…"
- Fix: each tab is a `CustomScrollView` with a pinned `SliverAppBar`. Remove the magic heights.

**C12. Nothing responds to Reduce Motion.**
- What: `MediaQuery.disableAnimations` is read 0 times. About 14 shimmer sites, 2 looping Lottie animations, `enlargeCenterPage` carousels, the Liked backdrop slide and the zoom transitions all ignore it.
- Why: `accessibility.md › Cognitive`: "…reducing automatic and repetitive animations, including zooming, scaling…" Also `motion.md › Best practices`: "Make motion optional."
- Fix: a `MNMotion.of(context)` helper that collapses durations to zero and swaps translate/scale for fades.

**C13. Fixed-height boxes hold scalable text, and the poster clamps cap text scale at 2.0×.**
- Where:
  - `explore.dart:88` (70)
  - `Login_welcome_screen.dart:24,35,81,110,138` (10% of height, 80)
  - `detail_page.dart:306-308` (40)
  - `components/squaretile.dart:19-20` (85×85: 36 + 8 + 2×11 pt at 200% is 88 pt)
  - `changelangwidget.dart:28` (`itemExtent: 60`)
  - `genreslistview.dart:84-91` (170×240 poster plus a 50 pt caption)
  - `cast_movies.dart:38,88`
  - `Login.dart:136`, `Register.dart:146` (`SizedBox(60×160)`)
  - `utils/poster_size.dart:27`, `upcoming.dart:150` (`.clamp(1.0, 2.0)`)
- Why: `typography.md › Supporting Dynamic Type`: "Keep text truncation to a minimum…" Also `accessibility.md › Vision`: "…enlarge text by at least 200 percent."
- Fix: use `minHeight` constraints, not exact heights. Size posters through `PosterSize`, with no upper clamp and `maxLines: 2`. At scale ≥ 1.5, rails stack to one column.

## High

**H1. The tab set changes on sign-in, and one tab is an action ("Login").**
- Where: `widgets/Navbar/Navbar.dart:27-34,118-131`.
- What: signed out shows 3 tabs; signed in shows 4. The index resets to Home, and signing out from Profile silently lands on Home.
- Why: `tab-bars.md › Best practices`: "Don't disable or hide tab bar buttons…" and "Use a tab bar to support navigation, not to provide actions."
- Fix: always show the same four tabs. Signed-out Library and Profile show a sign-in invitation.

**H2. Every push covers the tab bar. Tabs have no stack of their own, and re-tapping a tab does nothing.**
- Where: `Navbar.dart:73-76`.
- Why: `tab-bars.md › Best practices`: "Make sure the tab bar is visible when people navigate to different sections."
- Fix: give each tab a `Navigator`. Re-tapping the active tab pops to root, then scrolls to the top. Add a `PopScope` for Android back.

**H3. Watchlist is buried in Settings while Liked gets a tab, though the two are peer actions on Detail.**
- Where: `Settings_screen.dart:128-137`, `detail_page.dart:400-434`.
- Why: `layout.md › Visual hierarchy`: "Group related items…"
- Fix: a **Library** tab with a Liked | Watchlist segmented control.

**H4. The Detail and Cast pages lose their only Back button on scroll, and loading/error states have no bar.**
- Where: `detail_page.dart:123-133`, `castdetails.dart:51-59,69-71`.
- What: the `SliverAppBar` is not pinned, has no title and an empty `FlexibleSpaceBar`, and the `stretchModes` do nothing without `stretch: true`.
- Why: `toolbars.md › Titles`: "A title helps people confirm their location…"
- Fix: a pinned `SliverAppBar` with `expandedHeight`, the backdrop as `FlexibleSpaceBar.background`, and a title that fades in once collapsed. Waiting and error states get an `AppBar()`.

**H5. Same-axis nested scroll views.**
- Where: the reviews `ListView` inside `AspectRatio(1)` inside the detail scroll view (`local_Reviews.dart:52`, `global_Reviews.dart:41`), and the Videos `ListView` inside a `ListView` (`videos.dart:28`, `Getvideos.dart:38`).
- Why: `scroll-views.md › Best practices`: "Avoid putting a scroll view inside another scroll view with the same orientation."
- Fix: show the first 3 reviews inline plus "See All Reviews (n)", which pushes a full list. Videos becomes a single `ListView.separated`.

**H6. The Liked carousel height is width ÷ 0.7.**
- Where: `pages/UI/liked.dart:129-137`.
- What: on a phone in landscape this is about 1,205 pt in a 390 pt-tall viewport, so cards and their delete buttons are cut off.
- Why: `layout.md › Size classes`: "Determine layout based on size classes, not device type or orientation."
- Fix: use `LayoutBuilder`, with height `min(maxH × 0.75, 520)`. At width ≥ 600, switch to a grid.

**H7. Fixed grids and rails don't adapt.**
- Where: the Explore and See All grids are always 2 columns of 170×240 (`genreslistview.dart:47,84`). The cast and provider rails use `AspectRatio(1.9/2.1)`, which is about 518 pt tall on iPad (`cast.dart:48`, `watch_provider.dart:73`).
- Why: `designing-for-iphone-duo.md › Best practices`: "Avoid fixed widths."
- Fix: `SliverGridDelegateWithMaxCrossAxisExtent` driven by `PosterSize`, and fixed rail heights.

**H8. Most tappables give no press feedback, and there are no haptics anywhere.**
- What: 15 raw `GestureDetector` targets: every poster, the search card, the Movie/TV switch and the play button.
- Why: `gestures.md › Best practices`: "provide immediate feedback." Also `buttons.md › Best practices`: "Always include a press state for a custom button."
- Fix: `PressableScale` (0.97, transform only) plus `InkWell`. Add haptics on toggles and confirmations.

**H9. The Movie/TV "switch" is two bare text labels.**
- Where: `widgets/switch.dart:29-60`, used at `home_page.dart:51` and `Reviews_page.dart:27`.
- What: the hit target is about 24 pt tall, the selection is shown by color only, there is no selected semantics, and the separator is a literal `"   |   "`. TV comes first even though Movies is the default.
- Why: `buttons.md › Best practices`: "hit region of at least 44x44 pt." Also `accessibility.md › Vision`.
- Fix: `SegmentedToggle`, which uses `CupertinoSlidingSegmentedControl` on iOS and `SegmentedButton` on Android, with Movies first.

**H9b. Forms have no keyboard type, autofill, input action or working validators.**
- Where: `components/formfieldwithvalidation.dart:54-81`, `formfield.dart:22`, `Forget_password.dart:87`, and the 8 fields in Login and Register.
- What: there are 0 `keyboardType`, 0 `autofillHints` and 0 `textInputAction`. Login applies the sign-up complexity regex to an existing password. The confirm field is never checked. Unfocused fields have no visible boundary.
- Why: `text-fields.md › Best practices`: "show the appropriate keyboard type." Also `accessibility.md › Speech`.
- Fix: one `AppTextField` with `keyboardType`, `autofillHints`, `textInputAction` and `onFieldSubmitted`, a visible resting fill, and a password reveal. Wrap each form in `AutofillGroup`.

**H10. No button theme, so every button is styled by hand.**
- What: 15 hard-coded `#312770`/`#3A3A89` fills, radii 10/30/32/40, heights 40/60/80, and white, black or theme labels.
- Why: `buttons.md › Style`: "System buttons offer a range of styles that support customization…"
- Fix: `filledButtonTheme`, `outlinedButtonTheme` and `textButtonTheme` built from tokens.

**H11. The welcome screen has three equal filled buttons, and "Change Language" is first.**
- Where: `Login_welcome_screen.dart:85,114,142`. The admin `details_category.dart:45-97` has the same pattern.
- Why: `buttons.md › Style`: "Keep the number of prominent buttons to one or two per view."
- Fix: Log In as a filled button, Create Account as an outlined button, and language as a `TextButton` in the app bar.

**H12. Three icon families are mixed.**
- What: 17 Iconsax glyphs, about 36 Material glyphs and 1 Simple Icons glyph. Settings alone mixes them, and the watchlist "saved" state is drawn as a trash can (`addtowatchlist.dart:62`).
- Why: `icons.md › Best practices`: "consistent size, level of detail, stroke thickness." Also `toggles.md › Best practices`.
- Fix: use Iconsax only, Outline for rest and Bold for selected. The saved watchlist state becomes a filled bookmark.

**H13. A TMDB score is shown with the IMDb logo, and duplicated as stars.**
- Where: `detail_page.dart:292-299`.
- Why: judgment (it attributes the rating to the wrong brand).
- Fix: `RatingBadge` reading "★ 7.3" with a "TMDB" caption, shown once.

**H14. One color carries many meanings.**
- What: 9 different purples. Red means destructive, a decorative link, an episodes icon and an empty state. Green means account, bug report and the light-mode switch thumb. Settings icon chips use 5 Material primaries, and `Colors.purple` on dark is 2.80:1.
- Why: `color.md › Best practices`: "Avoid using the same color to mean different things."
- Fix: primary means interactive or brand, error means destructive only, and everything else is neutral.

**H15. Contrast failures.**
- deepPurpleAccent links on dark: 3.66:1 / 3.48:1 (`Login.dart:174,225`, `Register.dart:212`, `local_Reviews.dart:215`).
- Light-mode nav unselected: 2.15:1 (`Navbar.dart:93`).
- Light-mode switch and tab unselected: 2.68:1 (`switch.dart:36`, `explore.dart:112`).
- Light review metadata: 2.07 / 1.77 / 2.40:1 (`global_Reviews.dart:50`, `local_Reviews.dart:63`).
- Carousel caption over a bright poster: 1.88:1, genre 1.58:1 (`upcoming.dart:156-171`).
- Stars on light: 1.22:1 (`stars.dart:21`).
- White on `#F44336`: 3.68:1 (`watchlistwidget.dart:56`, `alertdialog.dart:49`).
- Why: `accessibility.md › Vision`: "Up to 17 pts … 4.5:1."
- Fix: the token palette (every pair at ≥ 4.5:1 is listed in the design system), plus a gradient scrim at 0 → 80% black under every caption on imagery.

**H16. Nav labels are 10 pt, below the 11 pt minimum.**
- Where: `Navbar.dart:97-100`.
- Why: `accessibility.md › Vision`: "Minimum size 11 pt."
- Fix: 12 pt (`labelMedium`).

**H17. Hierarchy is built from hard-coded sizes.**
- What: 38 literals in 25 files, and the theme defines only 3 text styles. Default body is 14 pt against HIG's 17 pt.
- Why: `typography.md › Using system fonts`: "Consider using the built-in text styles."
- Fix: a full `TextTheme` mapped to the HIG Large (default) scale (see the design system).

**H18. Raw exception text is shown to users, and nothing has a retry.**
- Raw text: `detail_page.dart:74`, `castdetails.dart:59`, `userinfotile.dart:24`, `liked.dart:76`, `Forget_password.dart:30`.
- No retry: errors collapse to `SizedBox.shrink()` (`movies_listview.dart:169`, `genreslistview.dart:137`), so an offline Home is blank. The `tryAgain`, `noResults` and `noResultsMessage` keys exist but are unused.
- Why: `alerts.md › Content`: avoid "'Error' or 'Error 329347 occurred'". Also `writing.md › Best practices`: "Provide clear next steps on any blank screens."
- Fix: shared `ErrorState(message, onRetry)` and `EmptyState(title, body, action)`. Feeds get `RefreshIndicator.adaptive`.

**H19. Change Password and Update Profile always report success, and Send Report never confirms.**
- Where: `changepassword.dart:42-56`, `Update_User_details.dart:95-114`, `SendReports.dart:113-118`.
- What: none of these calls are awaited.
- Why: `feedback.md › Best practices`.
- Fix: await the call, show a busy state, then report success or a mapped error.

**H20. Confirmations are inverted.**
- What: removing from the Watchlist (one tap to re-add) shows an alert, while deleting your own review (unrecoverable) and unliking get nothing.
- Where: `watchlistwidget.dart:38`, `liked.dart:89,230`, `local_Reviews.dart:126`.
- Why: `alerts.md › Best practices`: "Avoid displaying alerts for common, undoable actions."
- Fix: Watchlist and Liked removal happen immediately and show an "Undo" snackbar. Deleting a review shows a destructive confirmation.

**H21. Signed-out users lose Share, IMDb, Like, Watchlist and Reviews on Detail, with no hint why.**
- Where: `detail_page.dart:118,379-380`.
- Why: `managing-accounts.md › Best practices`: "Explain the benefits of creating an account…"
- Fix: always show Share and the external link. Account-only actions open a sign-in sheet.

**H22. Performance: blur and tickers.**
- The tab bar blurs at σ50 over scrolling content on every platform (`Navbar.dart:76`).
- There is one `BackdropFilter` per carousel card (`upcoming.dart:142`).
- Every image placeholder runs its own shimmer controller (`cached_image.dart:44`).
- `IndexedStack` keeps tickers alive on hidden tabs, so the Lottie loops play offstage (`Navbar.dart:74`).
- Why: `liquid-glass.md`: "Backdrop blur. Regular about 20 to 40 px… On Android… prefer an opaque or lightly translucent bar." Also `motion.md`.
- Fix: one glass surface, used only on iOS. Captions use a gradient scrim. Placeholders are static fills with a 150 ms fade-in. Wrap tabs in `TickerMode`.

## Medium

**M1. Search is a fake card, results are unscoped, and history can't be cleared.**
- Where: `explore.dart:78-108`, `search.dart:84-158`.
- Why: `search-fields.md › Search as a tab` and `searching.md › Best practices`: "provide a way for people to clear it."
- Fix: name the tab "Search", with genres as its landing page. Add a real `SearchBar`, scope chips, and a "Clear" control for history.

**M2. The full-screen image viewer has no close control, no zoom limits and no Hero.**
- Where: `detail_page.dart:202`, `castdetails.dart:81`.
- Why: `modality.md › Best practices`: "Always give people an obvious way to dismiss a modal view." Also `scroll-views.md` (scale limits).
- Fix: a `fullscreenDialog` route with a `CloseButton`, drag-down to dismiss, and `min/maxScale`.

**M3. Inconsistent margins and section headers.**
- What: leading margins of 8/10/13/15/20/24. The Upcoming header is centered. "See All" uses the same size as the heading, and it is only reachable as the 21st carousel card.
- Why: `layout.md › Visual hierarchy`: "Align elements to make them easier to scan."
- Fix: a 16 pt page margin token and one `SectionHeader`.

**M4. Five poster-card variants, and radii of 4/6/10/12/16/20/30/32/50.**
- Why: `collections.md › Best practices`.
- Fix: one `PosterCard` and three radius tokens.

**M5. Three rating implementations, two of them with half stars.**
- Why: `rating-indicators.md`: "rounds the value to display complete symbols only."
- Fix: one `RatingBadge`.

**M6. Four feedback systems.**
- What: `AwesomeSnackbarContent`, `Fluttertoast`, plain `SnackBar` and alerts, plus "Error" used as a title.
- Why: `feedback.md` and `alerts.md › Content`.
- Fix: one `AppFeedback` built on a themed floating `SnackBar`.

**M7. Settings rows are inconsistent.**
- What: an empty `subtitle: ""` line on every row, a 20 pt bold red "Delete" row, Dark Mode outside any group, and red chips on non-destructive rows.
- Why: `lists-and-tables.md › Style`.
- Fix: grouped sections, neutral chips, and red only for Delete.

**M8. The app overrides the system appearance and defaults to dark.**
- Where: `theme_provider.dart:5`.
- Why: `dark-mode.md › Best practices`: "Avoid offering an app-specific appearance setting." That page also allows "only a dark appearance" for immersive media.
- Fix: decision D1 in the design system.

**M9. Loading looks the same as empty for reviews and watch providers, and the "not available" text vanishes after 2 s.**
- Where: `local_Reviews.dart:155`, `watch_provider.dart:128`, `Temp_text.dart:24`.
- Why: `loading.md › Best practices`: "Show something as soon as possible."

**M10. A Watchlist stream error shimmers forever, and failed items vanish.**
- Where: `Watchlist.dart:72,106`.
- Why: `progress-indicators.md › Best practices`.

**M11. Search has no "no results" state, and errors read "No Data Found".**
- Where: `search.dart:84,148`.
- Why: `writing.md › Best practices`.

**M12. The like toggle has no animation, haptic or confirmation, and its ripple is a square on a rounded tile. A watchlist failure rolls back silently.**
- Where: `detail_page.dart:400-431`, `squaretile.dart:16`, `addtowatchlist.dart:52`.
- Why: `motion.md › Providing feedback` and `playing-haptics.md › Best practices`.

**M13. The Liked backdrop animates after the gesture ends (500 ms), and fast swipes stack animations.**
- Where: `liked.dart:113-134`.
- Why: `accessibility.md › Cognitive`: "Tracking animations directly with people's gestures."
- Fix: cross-fade, which also covers Reduce Motion.

**M14. Flipping Movie/TV swaps the whole feed in one frame and keeps the scroll offset.**
- Where: `home_page.dart:56`.
- Fix (judgment): a 180 ms fade plus a scroll reset.

**M15. Copy: one action has several names.**
- Login / Log in / Sign Up / Register / Create Account.
- "Login" and "Logout" are used as verbs.
- The profile action is called Update Profile, Update Account and Edit Profile.
- Why: `writing.md › Best practices`: "decide how you want to label the actions… be consistent."

**M16. Copy: vague, interjecting and mis-capitalized strings.**
- Vague or interjecting: "Oh No!", "No Report!!!", "Error" as a title.
- Misspelled: "Egyption".
- Mixed Title Case and sentence case within the same element types.
- Password rules don't match the regex.
- Why: `writing.md › Write clear error messages`: "Interjections like 'oops!'… can sound insincere."

**M17. RTL is not respected in layout.**
- What: 19 `EdgeInsets.only(left/right)` and 3 `Alignment.centerRight` in an app that ships Arabic.
- Why: `right-to-left.md › Text alignment`.
- Fix: `EdgeInsetsDirectional` and `AlignmentDirectional`.

**M18. Section titles aren't marked as headings, so there is no heading navigation on long pages.**
- Why: `voiceover.md › Navigation`: "Use titles and headings to help people navigate…"

**M19. The offline banner is not announced, and essential errors only appear in auto-dismissing toasts.**
- Where: `offline_banner.dart:47`, plus 11 toast and snackbar call sites.
- Why: `voiceover.md › Navigation`. Also `accessibility.md › Cognitive`: "Prefer dismissing views with an explicit action."

## Low

- **L1.** "Read more" expands every review at once, and `isExpandedList` grows on every rebuild. Where: `global_Reviews.dart:32,79`, `local_Reviews.dart:58`.
- **L2.** `BouncingScrollPhysics` is forced on Android. Where: `videos.dart:30`. Why: `scroll-views.md`.
- **L3.** Placeholders hot-link third-party images, one over plain http. Where: `cast.dart:81`, `upcoming.dart:132`, `genreslistview.dart:83`, `search.dart:118`. Why: `image-views.md`. `images/placeholder.png` doesn't exist but is used as a network URL (`detail_page.dart:233`, `watchlistwidget.dart:114`).
- **L4.** Search results crop posters into circles and have no media-type subtitle. Where: `search.dart:113`. Why: `lists-and-tables.md › Style`.
- **L5.** The share text is hard-coded English and wrong for TV ("this movie null", `/movie/` URL). Where: `detail_page.dart:442`. Why: `writing.md`.
- **L6.** The app title is `'Movie app'` (recent-apps switcher). Where: `main.dart:41`.
- **L7.** The `colorpalette.dart` gradients (28 colors) are dead code. `customtextbutton` is unused and broken (`textbutton.dart:19`). `CustomDialog`, `snackbar.dart`, `darkmodebutton.dart` and `feedbackwidget.dart` are unused.
- **L8.** Carousels have no position indicator, and the Liked carousel wraps infinitely. Where: `carousel_slider.dart:30`, `liked.dart:129`. Why: `scroll-views.md › Mobile`.
- **L9.** Decorative glyphs are read aloud: the IMDb icon next to its number, stars next to the number, and `" . "` read as "dot". Where: `detail_page.dart:271,292,299`. Why: `voiceover.md › Descriptions`.

## Out of scope / left for later

- **Forced immediate update on launch** (`services/app_update.dart:19`). `alerts.md` advises against interrupting at launch, but changing the update policy is a product decision, not UI.
- **Admin pages** get only a token, accessibility and states pass. No redesign.

## What works (keep)

- **Scroll architecture:** the DetailPage sections build lazily in a `SliverList` and are kept alive.
- **Poster sizing and caching:** `PosterSize` scales with text, and `CachedImageCustom` uses `memCacheWidth`.
- **Watchlist toggle:** the optimistic update has a busy guard.
- **Offline banner:** non-blocking, icon plus text, and it handles the safe area correctly.
- **Navigation basics:** signed-out browsing works, iOS edge-swipe back works everywhere, and `IndexedStack` preserves tab state.
- **Futures and search:** futures are cached across rebuilds, and search is debounced at 300 ms.
- **Built-in controls:** `SwitchListTile.adaptive`, `RadioListTile` and `TabBar` give correct roles for free.
- **Localization:** seven locales with near-equal key coverage, and localized tooltips on the four labeled icon buttons.
- **Dark-first:** defensible for a media app, and the dark theme is the stronger of the two today. Body text on `#171823` is 17.6:1.
