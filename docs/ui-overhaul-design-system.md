# Movie Night — Design System ("Screening Room")

Phase 2 of the UI overhaul. Grounded in the audit (`docs/ui-overhaul-audit.md`); implemented by `docs/ui-overhaul-plan.md`.

## 1. Grounding

- **Product.** Movie Night is a "what are we watching tonight?" picker. You browse TMDB movies and series (including an Egyptian row), open a title, see who's in it and where it streams, then like it or put it on your watchlist.
- **Who uses it.** Casual viewers, usually in the evening, often in a dim room, sometimes with the phone handed around. It ships in 7 locales: English, Arabic (right-to-left), French, German, Spanish, Hindi and Italian.
- **The brand's own artifact.** The app icon is a **violet neon "M" glowing on charcoal**. That is a sign lit up in a dark room, not a flat logo.
- **Thesis.** *The app is a dark screening room. The posters are the light source.* The UI recedes like a theater going dark. Color comes from the films themselves. The brand violet appears only where the neon sign would: the one primary action on a screen, and the selected tab.
- **Each screen's single job:**

| Screen | Job |
|---|---|
| Home | Get from "what's on?" to a title in two taps |
| Search | Find a specific title, or browse by genre |
| Library | Find what I saved |
| Detail | Decide whether to watch this, and where |
| Profile | Manage my account |

## 2. Decisions that need the owner

| # | Decision | Recommendation | Alternative |
|---|---|---|---|
| D1 | Appearance | **Follow the system by default.** Keep the existing user override, upgraded to a three-way control: System, Dark, Light. Dark is still the reference design. | Dark-only. The Dark Mode guidelines allow this for immersive media apps ("In rare cases, consider using only a dark appearance"). It would delete the light theme and the toggle. |
| D2 | Behaviour fixes inside UI flows | **Include them**, listed as task group B in the plan: confirm-and-order for Delete Account; awaiting auth calls and closing the screen only on success; Undo instead of a dialog for watchlist and like removal; a fixed set of four tabs with a Library tab; Share shown to signed-out users. | Visual changes only. Every Critical item in C6 and C7 would stay open. |
| D3 | Dependencies | Remove `fluttertoast` and `awesome_snackbar_content` (replaced by one in-house feedback component). Remove the Pacifico font. **No new packages.** | Keep them. |

## 3. Color tokens

These replace `MyThemes` and `colorpalette.dart`. Each theme gets an explicit `ColorScheme`, plus a `ThemeExtension<MNColors>` for the roles Material doesn't cover. Every ratio below is computed WCAG 2.x.

| Role (ColorScheme / MNColors) | Dark ("lights down") | Light ("lights up") | Use |
|---|---|---|---|
| `surface` | `#121117` | `#FBFAFD` | Screen background (the auditorium) |
| `surfaceContainer` | `#1C1A23` | `#F2F0F6` | Cards, text fields, grouped settings |
| `surfaceContainerHigh` | `#26232F` | `#E9E6F0` | Sheets, dialogs, pressed fill |
| `onSurface` | `#F3F0F8` (16.7:1) | `#17151D` (17.4:1) | Primary text and icons |
| `onSurfaceVariant` | `#ABA6B8` (7.9:1 on surface, 6.5:1 on High) | `#575264` (7.2:1 on surface, 6.1:1 on High) | Secondary text, unselected tabs, metadata |
| `outline` | `#7A748C` (4.2:1 on surface, 3.45:1 on High) | `#7D778C` (3.5:1 on High) | Field borders, dividers between controls |
| `outlineVariant` | `#2E2B38` | `#E2DFE8` | Decorative hairlines only |
| `primary` ("neon") | `#BBA8FF` (9.1:1 on surface) | `#5A3FD6` (6.5:1 on surface) | Primary action fill, selected tab, links, focus |
| `onPrimary` | `#1B1235` (8.6:1 on primary) | `#FFFFFF` (6.7:1 on primary) | Label on a primary fill |
| `primaryContainer` / `onPrimaryContainer` | `#2C2350` / `#E6DEFF` | `#E6DEFF` / `#1B1235` | Selected segment, tab indicator pill |
| `error` | `#FF8E84` (8.5:1) | `#B3261E` (6.3:1) | Destructive actions and errors **only** |
| `onError` | `#3B0A07` (7.7:1) | `#FFFFFF` (6.5:1) | Label on an error fill |
| `MNColors.rating` ("marquee") | `#F5C04A` (11.2:1) | `#8A5800` (5.8:1 on surface, 4.9:1 on High) | Rating star and score **only** |
| `MNColors.scrim` | black, 0 → 80% gradient | same | Under any text on imagery. Over a pure-white poster: #333333, so white text is 12.6:1 |
| `MNColors.chrome` | `surface` at 86% + 0.5 px hairline at `onSurface` 8% | `surface` at 86% | The glass material (§7). Worst case, `onSurfaceVariant` on chrome over the opposite extreme: 5.4:1 dark, 5.2:1 light |

**Rules**
- **One color, one meaning.**
  - Primary means "interactive" or "brand".
  - Error means "destructive".
  - Rating means "score".
  - Everything else is neutral.
- **Settings icon chips** use `surfaceContainerHigh` with `onSurfaceVariant` glyphs. Delete Account is the only red row.
- **Primary fill budget:** at most one filled primary button per view.
- **High contrast.** When `MediaQuery.highContrastOf` is on, `onSurfaceVariant` becomes `onSurface`, `outline` becomes `onSurfaceVariant`, and chrome becomes opaque.

## 4. Type

- **Body, controls, captions and all non-Latin scripts** use the platform system font: SF Pro on iOS, Roboto on Android. Set no `fontFamily` on these roles. That gives correct Arabic and Devanagari rendering, plus Bold Text and system scaling for free. (Poppins has no Arabic or Devanagari glyphs.)
- **Display text only** uses Poppins (already bundled, weights fixed: 400 / 500 / 600 / 700), with `fontFamilyFallback` set to the system font. It is used with restraint: screen titles, the title on the detail screen, and section headers.
- **Pacifico is removed.** A script face on links reads as a café, not a cinema, and the brand mark isn't script.

The scale follows HIG Large (default). Names are Flutter `TextTheme` roles.

| Role | HIG equivalent | Size / leading | Weight | Face |
|---|---|---|---|---|
| `displaySmall` | Large Title | 34 / 41 | 700 | Poppins |
| `headlineMedium` | Title 1 | 28 / 34 | 700 | Poppins |
| `headlineSmall` | Title 2 | 22 / 28 | 600 | Poppins |
| `titleLarge` | Title 3 (section headers) | 20 / 25 | 600 | Poppins |
| `titleMedium` | Headline | 17 / 22 | 600 | system |
| `bodyLarge` | Body | 17 / 22 | 400 | system |
| `labelLarge` | Callout (buttons) | 16 / 21 | 600 | system |
| `bodyMedium` | Subhead | 15 / 20 | 400 | system |
| `bodySmall` | Footnote | 13 / 18 | 400 | system |
| `labelMedium` | Caption 1 (tab labels, poster meta) | 12 / 16 | 500 | system |
| `labelSmall` | Caption 2 (the floor) | 11 / 13 | 500 | system |

**Rules**
- No text below 11 pt.
- Nothing below 12 pt over imagery.
- `textScaler` is never clamped.
- When `MediaQuery.boldTextOf` is on, raise every weight by one step.
- At a text scale of 1.5 or more, horizontal rails become a single-column list (see §6).

## 5. Space, radius, size

| Token | Values |
|---|---|
| `MNSpace` | `xxs` 2 · `xs` 4 · `sm` 8 · `md` 12 · `lg` 16 (**page margin**) · `xl` 24 (gap inside a section) · `xxl` 32 (gap between sections) · `xxxl` 48 |
| `MNRadius` | `sm` 8 (thumbnails, chips, search result poster) · `md` 12 (**posters**, cards, fields) · `lg` 20 (sheets, dialogs, the Liked hero card) · `pill` = `StadiumBorder` (buttons, segmented control, tab indicator) |
| `MNSize` | `minTap` 48 (Android) / 44 (iOS); use 48 everywhere · `buttonHeight` 50 · `posterAspect` 2/3 · `railItemWidth` from `PosterSize` (existing) · `avatar` 72 |

**Rules**
- Only posters cast a shadow, and only in the light theme: y 2, blur 8, black 12%.
- The dark theme uses no shadows. Elevation there comes from a lighter surface step.

## 6. Layout

**Every tab is a `CustomScrollView`**, built from top to bottom as:
- a pinned `SliverAppBar`, which handles the safe area exactly once;
- an optional pinned control row, such as the Movies/TV segmented control;
- a list of sections;
- bottom padding equal to the tab bar height plus the bottom safe-area inset.

**Navigation**
- **Four fixed tabs:** Home · Search · Library · Profile. Each tab has its own `Navigator`.
- **Re-tapping a tab** pops it back to its root. If it is already at the root, it scrolls to the top instead.
- **Modal flows** (sign in, the full-screen poster viewer, confirmations) present on the root navigator.

**Width breakpoints** come from `MediaQuery.sizeOf`, never from orientation:
- **compact** (under 600 pt): wireframes below.
- **regular** (600 pt and up):
  - Grids use `maxCrossAxisExtent` of `PosterSize.width + 12`.
  - The Library carousel becomes a grid.
  - Detail places the poster and the info side by side, with up to 3 cast rows visible.
  - The bottom bar stays a bottom bar. A `NavigationRail` is left for later and noted in the plan.

```
HOME — compact (390pt)                    HOME — regular (≥600pt)
┌───────────────────────────────┐        ┌──────────────────────────────────────────────┐
│ status bar / island           │        │ Movie Night             [Movies|TV Shows]    │
│ Movie Night        (large ttl)│        │ ░░░░░░ spill glow (16:9 band, top) ░░░░░░░░░ │
│ ░░░░░░ spill glow ░░░░░░░░░░░░│        │  ┌───┐ ┌─────┐ ┌───┐ ┌───┐                   │
│ [ Movies | TV Shows ] (pinned)│        │  │   │ │ HERO│ │   │ │   │  ← carousel     │
│  ┌──┐ ┌──────┐ ┌──┐           │        │  └───┘ └─────┘ └───┘ └───┘    • • ● • •     │
│  │  │ │ HERO │ │  │  carousel │        │ Trending                         See All ›   │
│  └──┘ └──────┘ └──┘   • ● •   │        │ ┌──┐┌──┐┌──┐┌──┐┌──┐┌──┐┌──┐┌──┐            │
│ Trending            See All › │        │ Popular ...                                  │
│ ┌──┐┌──┐┌──┐┌─               │        └──────────────────────────────────────────────┘
│ Popular             See All › │
│ ┌──┐┌──┐┌──┐┌─               │        DETAIL — compact
│ Egyptian Movies     See All › │        ┌───────────────────────────────┐
│ ┌──┐┌──┐┌──┐┌─               │        │ ‹  (glass)          ⤴ share   │ pinned bar, title fades in
│ ░ tab bar (glass, floating) ░ │        │ ███ backdrop + spill glow ███ │ expandedHeight 260
│ Home  Search  Library Profile │        │ ┌────┐ Title (headlineSmall)   │
└───────────────────────────────┘        │ │post│ 2023 · 2h 6m · Action   │
                                         │ └────┘ ★ 7.3 TMDB              │
                                         │ [ ▶ Watch Trailer ] (filled)  │ the one primary action
                                         │ ♡ Like   ⊕ Watchlist  ↗ IMDb   │ tonal action tiles
                                         │ Storyline …            More   │
                                         │ Cast ›  Where to Watch  Similar│
                                         │ Reviews (3 inline) See All (n)│
                                         └───────────────────────────────┘
```

## 7. Materials: two layers

- **Content layer.** Opaque `surface` / `surfaceContainer*`. **No blur in content.** The carousel captions' `BackdropFilter`s become gradient scrims.
- **Functional layer ("chrome").** The tab bar, a pinned app bar once content scrolls under it, and the controls in the image viewer.
  - **iOS:** `BackdropFilter(blur σ 24)` plus a `MNColors.chrome` fill at 86%, a 0.5 px top hairline, and the tab bar floating 8 pt above the home indicator with a 28 pt radius.
  - **Android:** an **opaque** `surfaceContainer` `NavigationBar` with no blur. This follows `liquid-glass.md`: "On Android, blur is costly… Prefer an opaque or lightly translucent bar."
  - Exactly one `BackdropFilter` is live per screen.
- **Reduced transparency.** Flutter exposes no reduce-transparency signal, so `MediaQuery.highContrastOf` is the proxy (as the glass guide recommends). When it is on, chrome is opaque on both platforms and the spill glow is off.

## 8. Signature: the spill glow

**What it is.** A soft field of the current film's own color falls from the top of the screen into the dark room, like light from a cinema screen spilling over the front rows.
- **Home:** the source is the centered carousel poster. It cross-fades as you swipe.
- **Detail:** the source is the title's backdrop.

**Why it belongs to this product.** The icon is a light source in a dark room, and so is a cinema. Brand color moves into the content layer, where the Branding guidelines say it belongs ("consider moving it into the content layer"). The UI chrome stays monochrome.

**How it's built.**
- The poster is decoded at 200 px wide (cached provider) and wrapped in `ImageFiltered(blur σ 60)`. This is a static blur of a tiny image, not a `BackdropFilter`.
- It is clipped to a 16:9 band anchored at the top. Opacity is 0.55 in dark, 0.30 in light.
- A gradient fades it into `surface` by 100% of the band height.
- It is wrapped in a `RepaintBoundary`.
- Total cost: one small texture per source.

**Motion.** A 420 ms cross-fade on `MNCurves.standard`.

**Fallbacks.**
- Reduce Motion: switch instantly.
- High Contrast: off.
- Image fails: no glow, just `surface`.

**Restraint.** It appears on two screens only, Home and Detail. Nowhere else.

## 9. Motion

| Token | Value | Use |
|---|---|---|
| `MNDuration.micro` | 100 ms | press-down scale |
| `MNDuration.short` | 180 ms | icon swaps, segment change, fade-ins, snackbar |
| `MNDuration.medium` | 280 ms | expand/collapse ("Read more"), feed cross-fade, sheet content |
| `MNDuration.long` | 420 ms | spill-glow cross-fade, Hero |
| `MNCurves.standard` | `Cubic(0.2, 0.0, 0.0, 1.0)` | entering, moving |
| `MNCurves.exit` | `Cubic(0.3, 0.0, 1.0, 1.0)` | leaving |
| `MNSprings.press` | `SpringDescription(mass: 1, stiffness: 600, damping: 49)` (critically damped, no bounce) | press-release scale 0.97 → 1 |
| `MNSprings.pop` | `SpringDescription(mass: 1, stiffness: 400, damping: 22)` (about 8% overshoot) | Like-heart pop (1 → 1.18 → 1) |

**Transitions**
- **Screen transitions** use the platform defaults. iOS: `CupertinoPageTransitionsBuilder`, which keeps edge-swipe back. Android: `PredictiveBackPageTransitionsBuilder`.
- **Poster to Detail:** a `Hero` on the poster. The tag is `'poster-<source>-<mediaType>-<id>'`, which stays unique when the same title appears in two rails.
- **Image viewer:** a fade route with a Hero, dismissed by tapping Close or dragging down.

**Micro-interactions**

| Interaction | Behavior |
|---|---|
| Cards | Scale 0.97 on press, transform only, plus an ink highlight |
| Like | Heart pop + `HapticFeedback.lightImpact` |
| Watchlist | Bookmark icon swap (180 ms) + `lightImpact`; failure → `heavyImpact` + snackbar |
| Segmented control | `selectionClick` |
| Destructive confirm | `mediumImpact` |
| Pull to refresh | `RefreshIndicator.adaptive` |
| Hover (desktop/web builds) | `InkWell` hover color |

**Reduce Motion** (`MediaQuery.disableAnimationsOf`), read through `MNMotion.of(context)`:
- All durations become 0, except fades, which keep 180 ms.
- Scales and Hero animations are skipped.
- Shimmer becomes a static skeleton.
- Lottie shows its first frame, with no loop.
- The carousel loses `enlargeCenterPage`.
- The glow switches instantly.
- Springs are critically damped.

**Performance (60 fps)**
- Animate only `transform` and `opacity`. `AnimatedSize` is allowed only on content inside a single card, never on app-level layout.
- Hidden tabs are wrapped in `TickerMode(enabled: false)`.
- Image placeholders are static fills; shimmer is used only for section skeletons, with one `Shimmer` per section.
- Every list is a `.builder` / sliver; no `shrinkWrap` inside a scroll view.
- Images are decoded at display size.

## 10. Components (shared, in `lib/src/components/`)

| Component | Replaces |
|---|---|
| `PosterCard` | 5 poster variants |
| `PressableScale` | raw `GestureDetector`s |
| `SectionHeader` | per-rail headers and the 21st-card "See all" |
| `RatingBadge` | `stars.dart` and the Liked hand-rolled stars |
| `SegmentedToggle<T>` | `switch.dart` |
| `ActionTile` | `squaretile.dart` |
| `AppTextField` | `formfield`, `formfieldwithvalidation`, inline fields |
| `ErrorState` / `EmptyState` | raw error text, `SizedBox.shrink`, "Oh No!" |
| `AppFeedback` (`showInfo` / `showError` / `showUndo` / `confirmDestructive`) | the 4 feedback systems |
| `SpillGlow` | — (signature) |
| `ChromeBar` | the blurred `BottomNavigationBar` |
| `SignInPrompt` | hidden actions and tabs when signed out |

## 11. Copy rules

- **Capitalization:** Title Case for buttons, titles, tab labels and section headers. Sentence case for messages, empty-state bodies and errors.
- **One name per action, everywhere:** "Log In", "Create Account", "Log Out", "Delete Account", "Edit Profile", "Save", "See All", "Try Again", "Undo".
- **Errors** say what happened and what to do, with no interjections and no raw exception text. Example: "You're offline. Check your connection and try again."
- **Empty states** invite the next action. Example: "No liked titles yet. Tap ♡ on any movie or show to keep it here." paired with [Browse Movies].
- **Translations:** every new key ships in all 7 locales. Non-English strings are machine-drafted, flagged in the plan for native review, and marked `@@x-needs-review`.

## 12. Self-critique against generated defaults

- **"Near-black with one acid accent."** This is the closest risk. The draft I first sketched used tungsten amber `#F5B544` as the accent. That is the generic "cinema = gold" cue, and it collided with the rating color. **Revised:** the accent is the logo's own soft violet neon `#BBA8FF`, at low saturation and never acid, spent only on the primary action and the selected tab. The amber becomes the dedicated rating color, so each color keeps one meaning.
- **Would this plan fit another product?** An "art-derived blurred background" is also Apple Music's move, so the first-draft glow was a media-app default. **Revised:** it is a top-anchored 16:9 band falling off downward, the shape of a screen lighting a room, used on two screens only rather than as full-bleed wallpaper. It is tied to the neon-sign icon, a light in the dark.
- **Template checks.**
  - No cream-and-serif palette.
  - No broadsheet hairline grid.
  - No "big number over small label" hero.
  - No 01/02/03 markers.
  - The display face is the existing Poppins, kept for continuity, rather than the cliché Bebas Neue poster face, which I considered and rejected.
- **Platform fit.** Navigation and controls are platform components: tab bar, `SegmentedButton` / `CupertinoSlidingSegmentedControl`, adaptive dialogs, `BackButton`, `RefreshIndicator.adaptive`. Identity lives in color, the glow and the display type.
- **One thing removed.** The Pacifico script and the logo-on-screen moments (the "Hello" wordmark on Welcome). Also dropped: the gradient palette file and the per-card blur. **Nothing else could go without loss.**
- **Quality floor.**
  - Works down to 320 pt width.
  - Text scales to 200% and beyond: no clamps, and rails stack at ≥ 1.5×.
  - Reduce Motion and High Contrast (standing in for Reduce Transparency) both have answers.
  - Keyboard focus is visible via the M3 focus ring in `primary` (desktop and web builds).
