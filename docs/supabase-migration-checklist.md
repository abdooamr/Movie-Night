# Supabase migration: manual checklist

The app code is migrated (plan: `docs/superpowers/plans/2026-11-09-supabase-migration.md`). These steps happen outside the code.

## Already done (2026-11-09)

- [x] SQL A–E run; Realtime on `profiles`, `reviews`, `watchlist`; old watchlists copied.
- [x] Google provider enabled with the **web** client ID and secret ("Skip nonce checks" can stay **off** for Android).
- [x] Redirect URL `eg.edu.miuegypt.csc422.movienight://reset-password` allow-listed.
- [x] "Confirm email" on; custom SMTP (Gmail) set up.
- [x] `SUPABASE_ANON_KEY` and `GOOGLE_WEB_CLIENT_ID` in `env.json`.

## Still to do

### Supabase dashboard
- [ ] **Authentication → URL Configuration → Redirect URLs:** also add `eg.edu.miuegypt.csc422.movienight://login-callback`, so the sign-up confirmation link opens the app on the phone. Without it Supabase sends people to the **Site URL** instead. The account is confirmed either way, but if the Site URL is still `http://localhost:3000` they land on a broken page. Set it to a real page either way.
- [ ] **Imported users:** in `auth.users`, check that migrated accounts have `email_confirmed_at` set. With "Confirm email" on, an unconfirmed imported user can't log in, and Google sign-in won't link to an existing account whose email is unconfirmed.
- [ ] **Avatars bucket:** if `avatars` already existed before SQL C, `on conflict do nothing` kept its old settings. Check it's public, 2 MB, `image/jpeg, image/png, image/webp`.
- [ ] **Account deletion:** test `delete_my_account` once with a throwaway account. If it fails with `permission denied for table users`, deletion needs an Edge Function (`auth.admin.deleteUser`, service-role key server-side only).

### Google Cloud console (the project that owns the web client ID)
- [ ] **Android OAuth client** for package `eg.edu.miuegypt.csc422.movienight` with the SHA-1 of **every** signing key you ship with:
  - the debug key (`./gradlew signingReport`),
  - your upload/release key,
  - and, with Play App Signing, the **app signing key** SHA-1 from Play Console → Setup → App integrity.

  A missing SHA-1 shows up as Google sign-in failing with `ApiException: 10`. If Firebase Google sign-in worked before, these clients probably exist already; check the release one.
- [ ] **OAuth consent screen:** published (or your testers added as test users).

### Builds
- [ ] Every run and build needs `--dart-define-from-file=env.json`, including CI and release builds. Without it the anon key is empty: debug builds stop on an assert, release builds can't reach Supabase.
- [ ] Test a **release** build (R8 minification is on for release) on a device before publishing.

### Firebase
- [ ] Keep the Firebase project: Cloud Messaging and Analytics still use it.
- [ ] **Old profile pictures:** imported `profile_pic` URLs that point to `firebasestorage.googleapis.com` only keep working while Firebase Storage exists. Copy those files into the `avatars` bucket (and update `profile_pic`) before switching Storage off. New uploads already go to Supabase.
- [ ] Once you're confident, lock Firestore and Storage down to deny all (the app no longer uses them).

### Test on the phone (in this order)
1. Create an account → "check your email" screen → open the link on the phone → log in.
2. Log in with an **old** account's old password → "Email or password is incorrect" plus the one-time "Reset Your Password Once" notice → Reset Password.
3. Forgot Password → email → open the link **on the same phone** (the link only works on the device that asked for it) → Set a New Password → log in with it.
4. Continue with Google, with a new Google account and with one that existed before.
5. Edit Profile: names, then a new picture.
6. Post a review, edit it (post again), delete it; check another account sees it live.
7. Watchlist: add and remove from a detail page and from the Watchlist screen; undo.
8. Report a Bug; as an admin, view the report, clear it, make someone admin, delete a test user.
9. Open a title, sign out from Profile, go back to the title: the page shows the sign-in prompt and doesn't crash.
10. Delete Account with a throwaway account.

## Known differences from the Firebase version

- **Picture upload** shows a spinning ring instead of a percentage (Supabase uploads report no progress).
- **Admin user list** refreshes on open, after each action and on pull-to-refresh, instead of updating live.
- **"Display name"** is gone from Edit Profile; reviews show first and last name.
- **Review dates** keep the `dd-MM-yyyy` format. Under Arabic they now use Western digits (today's `intl`); some imported Firestore dates were written with Arabic-Indic digits by an older `intl`.
- **Movie and TV reviews are kept apart** from 2026-11-10 (`docs/sql/2026-11-10-reviews-media-type.sql`, run before installing that build). Reviews imported from Firestore have no type and still show on both pages with that TMDB id.
- **New strings:** the 11 new sign-in strings were checked against each language's existing tone and wording (2026-11-10); a native speaker's pass is still worthwhile, Hindi and Arabic especially.
