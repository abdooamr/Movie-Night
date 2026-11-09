# Firebase → Supabase migration plan (app code only)

Status: **draft, awaiting approval.** Nothing in `lib/` has been changed.

Decisions (2026-11-09): 1 watchlist = new table (SQL A) · 2 report/role = RPCs (SQL B) · 3 avatars = Supabase bucket (SQL C) · 4 deletion = RPCs (SQL D). Items 5–9 use the stated defaults unless changed.

Scope: replace `firebase_auth`, `cloud_firestore`, `firebase_storage` with `supabase_flutter`; keep `google_sign_in` (native Google → `signInWithIdToken`). Keep `firebase_core` + `firebase_messaging` + the Android Firebase Analytics dependency. No tables, migrations or schema changes are run from here; any SQL below is a **proposal for you to run**.

---

## 1. Inventory: every Firebase touchpoint

### Setup
| File | Use |
| --- | --- |
| `pubspec.yaml` | `firebase_auth`, `cloud_firestore`, `firebase_storage`, `google_sign_in 6.2.1`, `firebase_core`, `firebase_messaging` |
| `lib/main.dart` | `Firebase.initializeApp()` (stays, for Messaging) |
| `android/app/build.gradle.kts` | google-services plugin, `firebase-analytics` (stay) |
| `lib/src/services/push_notification.dart` | `FirebaseMessaging.getToken()` (stays; currently unused) |

### Auth
| File | Use |
| --- | --- |
| `lib/src/Auth/auth.dart` | `FirebaseAuth.authStateChanges()` → signed-in / signed-out shell |
| `lib/src/Provider/register_provider.dart` | `createUserWithEmailAndPassword`, `updateDisplayName`, `updatePhotoURL`, Google `signInWithCredential` |
| `lib/src/pages/Login-Logout/Login.dart` | `signInWithEmailAndPassword` (trims the password: review finding, fixed here) |
| `lib/src/pages/Login-Logout/Register.dart` | catches `FirebaseAuthException` |
| `lib/src/pages/Login-Logout/Forget_password.dart` | `sendPasswordResetEmail` |
| `lib/src/pages/Login-Logout/auth_errors.dart` | maps `FirebaseAuthException` codes to copy |
| `lib/src/pages/Login-Logout/auth_form_parts.dart` | Google sign-in runner |
| `lib/src/pages/Userpage/changepassword.dart` | `sendPasswordResetEmail(currentUser.email)` |
| `lib/src/pages/Userpage/Settings_screen.dart` | `signOut`, `user.delete()`, `currentUser.uid`, admin check |
| `lib/src/pages/UI/detail_page.dart` | `currentUser != null` once in `initState` (stale: review finding, fixed here) |
| `test/pages/auth_error_mapping_test.dart`, `test/navigation/_shell_harness.dart` | Firebase types in tests |

### Profiles (Firestore `users/{uid}`)
| File | Use |
| --- | --- |
| `lib/src/data/user_repository.dart` | all reads/writes of `users/{uid}`: profile stream, create doc, Google back-fill, role, names, picture, delete, **watchlist arrays** |
| `lib/src/models/user_model.dart` | `Users` (firstName, lastName, email, ProfilePic, role, report) |
| `lib/src/Provider/readuserdata.dart` | profile stream; **Firebase Storage upload** `images/<millis>`; `updateDisplayName` |
| `lib/src/pages/Userpage/profilepic.dart` | **Firebase Storage upload** (second copy of the upload) |
| `lib/src/pages/Userpage/Update_User_details.dart` | edits first / last / **display name** (Auth-only field) |
| `lib/src/widgets/userinfotile.dart` | shows name, picture, **email** from the profile doc |
| `lib/src/pages/Userpage/SendReports.dart` | **writes `users/{uid}.report`** + opens an email |
| `lib/src/pages/Adminpages/admin_panel_vd.dart` | streams **all** users `orderBy("email")`, shows emails, **deletes `users/{id}`** |
| `lib/src/pages/Adminpages/report_page.dart` | **writes `report = ""`** on another user |
| `lib/src/pages/Adminpages/add_admin.dart` | **writes `role = "admin"`** on another user |
| `lib/src/pages/Adminpages/adminpanelwidget.dart` | fully commented out (deleted in this migration) |

### Watchlist (inside `users/{uid}`)
| File | Use |
| --- | --- |
| `user_repository.dart` | `Moviewatchlist` / `tvwatchlist` int arrays: stream, contains, arrayUnion, arrayRemove |
| `lib/src/pages/Userpage/Watchlist.dart` | live lists + undo |
| `lib/src/widgets/addtowatchlist.dart` | detail-page toggle |

### Reviews (Firestore `reviews/{tmdbId}/users/{uid}`)
| File | Use |
| --- | --- |
| `lib/src/Provider/reviewsprovider.dart` | `set` (overwrites your review), `snapshots()` live list, `delete` |
| `lib/src/widgets/local_Reviews.dart` | `currentUser!` in a field (crash after sign-out: review finding, fixed here), writes name/email/photo/date string |
| `lib/src/models/local_review_model.dart` | `Localreviews` (displayname, email, ProfilePic, createdat string, id) |

(Liked titles are local Hive, not Firebase; untouched.)

---

## 2. Things that do not map cleanly: decisions needed

1. **Watchlist has no home in the schema.** Today it is two arrays on `users/{uid}`. Was it migrated? Proposal: a `watchlist` table (SQL A). Alternatives: keep it on-device in Hive like Liked (loses existing cloud data and sync), or drop the feature.
2. **`report` and `role` are written by the app** (user report; admin clears a report; admin promotes a user). Proposal: three `security definer` RPCs (SQL B) called with `supabase.rpc(...)`.
3. **Profile picture uploads exist** (two places, Firebase Storage `images/`). Proposal: an `avatars` bucket with per-user folders (SQL C), one upload path, URL saved to `profiles.profile_pic`. Old `firebasestorage.googleapis.com` URLs keep working only while the Firebase project's Storage exists.
4. **Account deletion and admin "delete user".** Supabase has no client-side self-delete, and `profiles` has no delete policy. Proposal: `delete_my_account()` and `admin_delete_user(uuid)` RPCs (SQL D). Note the old admin delete only removed the Firestore doc, not the login.
5. **Admin panel shows and sorts by email**, which is no longer in `profiles` and other users' emails are not readable from the app. Proposal: an admin-only `admin_list_users()` RPC joining `auth.users` (SQL E). Default if you say no: show names only, sorted by name.
6. **"Display name"** (a Firebase Auth field on the edit-profile page) has no column; reviews now show `first_name last_name` via the join. Default: remove the display-name field.
7. **Movie vs TV review ids collide.** Firestore keyed reviews by the TMDB id for both movies and TV shows, and `reviews.movie_id` keeps that (a movie and a show with the same id share reviews). Default: keep today's behaviour and flag it; a `media_type` column would be a schema change.
8. **Email confirmation.** If "Confirm email" is on in Supabase, `signUp` returns no session. Default: the Register screen handles both (signed in, or "check your email").
9. **Google on iOS was never configured** (no `GoogleService-Info.plist`, no URL scheme in `Info.plist`). Default: add the iOS client-ID plumbing; it works once you create the iOS OAuth client (checklist).

---

## 3. Design

- **Keys and config** via `--dart-define` (in the git-ignored `env.json`): `SUPABASE_ANON_KEY`, `GOOGLE_WEB_CLIENT_ID`, `GOOGLE_IOS_CLIENT_ID`. The project URL `https://ipnhdpidtktfjuyxcgoj.supabase.co` is public and lives in code. No service-role key anywhere.
- **Repositories with an injectable `SupabaseClient`**, resolved lazily so widget tests never touch Supabase:
  - `AuthRepository` (`lib/src/data/auth_repository.dart`): sign up (with `data: {first_name, last_name}`), email sign-in, Google (`google_sign_in` → `signInWithIdToken`), sign out (Supabase + Google), reset email, update password, `onAuthStateChange`, `currentUserId`, `currentEmail`.
  - `ProfileRepository` (replaces `UserRepository`): `profileStream(id)` (`.stream()` on `profiles`), `updateNames`, `updateProfilePic`, `isAdmin`, and the RPCs.
  - `ReviewRepository`: see reviews below.
  - `WatchlistRepository` (if decision 1 = table).
- **Auth gate:** `AuthPage` listens to `onAuthStateChange`, starting from `currentSession`. The `passwordRecovery` event pushes a new **Set New Password** screen (`updateUser(UserAttributes(password:))`) on a root `navigatorKey` added to `MaterialApp`.
- **Reset deep link:** `eg.edu.miuegypt.csc422.movienight://reset-password`. Android `intent-filter` + iOS `CFBundleURLTypes`; `supabase_flutter` picks up the link itself.
- **Old-password message:** when email sign-in fails with `invalid_credentials`, show once (flag stored in `shared_preferences`, which also gets declared in `pubspec.yaml`): "Movie Night moved to a new sign-in system. If you had an account before this update, reset your password once with Forgot password." with a button to the reset screen.
- **Profiles:** `Users` keeps its shape for the UI; `fromRow` reads `first_name`/`last_name`/`profile_pic`/`role`/`report`; email comes from `auth.currentUser.email` (own profile only). No profile creation code: the trigger does it.
- **Reviews:**
  - Read: `.stream(primaryKey: ['id']).eq('movie_id', id)` for live changes; author names/pictures fetched with one `profiles.select().inFilter('id', ids)` per change and cached by id (streams cannot join). Ordered by `created_at`.
  - Write: `insert({movie_id, user_id, review})`; on unique violation (`23505`) `update({review}).eq(movie_id).eq(user_id)`. Never `upsert`.
  - Delete: own review by `movie_id` + `user_id`.
  - Date: `DateFormat('dd-MM-yyyy').format(created_at.toLocal())` with the app's locale, as before (Arabic digits under Arabic).
- **Errors:** `auth_errors.dart` maps `AuthException.code` (`invalid_credentials`, `user_already_exists`, `weak_password`, `email_not_confirmed`, `over_email_send_rate_limit`, network) to the existing copy; Postgrest errors to the generic message.
- **Review findings folded in:** password no longer trimmed; detail page and reviews follow auth changes (no `currentUser!` crash); account deletion becomes one RPC (no half-deleted accounts); watchlist toggle ignores a late initial read; Watchlist error handler no longer rethrows.

## 4. Order of work (each stage ends with `flutter analyze` + `flutter test`, then a commit)

1. **Setup:** add `supabase_flutter` (+ `shared_preferences`), `Supabase.initialize` in `main.dart` next to `Firebase.initializeApp`, config constants, deep-link intent filter / URL scheme.
2. **Auth:** `AuthRepository`, auth gate, Login / Register / Google / Forgot password / Set New Password / change password / sign out, error mapping, old-password notice, detail-page auth state. Tests: error mapping, notice shown once, reset-link routing.
3. **Profiles:** `ProfileRepository`, profile stream, edit names, avatar upload (decision 3), user tile email, account deletion (decision 4), reports and admin (decisions 2, 5). Tests: row mapping, RPC names/args via a fake client.
4. **Reviews:** `ReviewRepository`, insert-or-update, stream + author lookup, delete, date formatting. Tests: mapping, date incl. Arabic digits, 23505 → update path.
5. **Watchlist** (decision 1).
6. **Cleanup:** delete `adminpanelwidget.dart`, remove `firebase_auth` / `cloud_firestore` / `firebase_storage` from `pubspec.yaml` once nothing references them, update the handoff, manual checklist.

---

## Appendix: proposed SQL (you run it; nothing is run from here)

**A. Watchlist**
```sql
create table public.watchlist (
  user_id    uuid    not null references public.profiles(id) on delete cascade,
  tmdb_id    integer not null,
  is_tv      boolean not null,
  created_at timestamptz not null default now(),
  primary key (user_id, tmdb_id, is_tv)
);
alter table public.watchlist enable row level security;
create policy "watchlist: read own"   on public.watchlist for select using (auth.uid() = user_id);
create policy "watchlist: add own"    on public.watchlist for insert with check (auth.uid() = user_id);
create policy "watchlist: remove own" on public.watchlist for delete using (auth.uid() = user_id);
```

**A** is applied (policies `to authenticated` with `(select auth.uid())`). Realtime is on for `profiles`, `reviews`, `watchlist`. `public.is_admin()` already exists (security definer, `search_path = ''`, true when the caller's `profiles.role = 'admin'`) and is reused below, not redefined.

**B. Reports and roles**
```sql
-- The signed-in user stores a report on their own profile.
create or replace function public.submit_report(body text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  caller uuid := auth.uid();
begin
  if caller is null then
    raise exception 'not signed in' using errcode = '42501';
  end if;
  if body is null or length(trim(body)) = 0 then
    raise exception 'report is empty' using errcode = '22023';
  end if;
  if length(body) > 5000 then
    raise exception 'report is too long' using errcode = '22001';
  end if;

  update public.profiles set report = body where id = caller;
  if not found then
    raise exception 'profile not found' using errcode = 'P0002';
  end if;
end;
$$;

-- An admin clears another user's report.
create or replace function public.admin_clear_report(target uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not public.is_admin() then
    raise exception 'not allowed' using errcode = '42501';
  end if;

  update public.profiles set report = '' where id = target;
  if not found then
    raise exception 'profile not found' using errcode = 'P0002';
  end if;
end;
$$;

-- An admin promotes another user to admin.
create or replace function public.admin_make_admin(target uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not public.is_admin() then
    raise exception 'not allowed' using errcode = '42501';
  end if;

  update public.profiles set role = 'admin' where id = target;
  if not found then
    raise exception 'profile not found' using errcode = 'P0002';
  end if;
end;
$$;

revoke execute on function public.submit_report(text)     from public, anon;
revoke execute on function public.admin_clear_report(uuid) from public, anon;
revoke execute on function public.admin_make_admin(uuid)   from public, anon;
grant  execute on function public.submit_report(text)     to authenticated;
grant  execute on function public.admin_clear_report(uuid) to authenticated;
grant  execute on function public.admin_make_admin(uuid)   to authenticated;
```

**C. Avatars bucket**
```sql
-- Public bucket: anyone can view a picture through its public URL.
-- 2 MB cap; the app uploads a 512 px JPEG (~50-150 KB).
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('avatars', 'avatars', true, 2097152,
        array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do nothing;

-- Files live at avatars/<user id>/<file>. Users only touch their own folder.
-- Viewing goes through the public URL, so SELECT is limited to the owner's
-- folder: it is needed to replace (upsert) a file, and it stops anyone from
-- listing every user's files.
create policy "avatars: read own folder"
  on storage.objects for select
  to authenticated
  using (bucket_id = 'avatars'
         and (storage.foldername(name))[1] = (select auth.uid())::text);

create policy "avatars: upload to own folder"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'avatars'
              and (storage.foldername(name))[1] = (select auth.uid())::text);

create policy "avatars: replace in own folder"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'avatars'
         and (storage.foldername(name))[1] = (select auth.uid())::text)
  with check (bucket_id = 'avatars'
              and (storage.foldername(name))[1] = (select auth.uid())::text);

create policy "avatars: delete in own folder"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'avatars'
         and (storage.foldername(name))[1] = (select auth.uid())::text);
```

**D. Account deletion**
```sql
-- The signed-in user deletes their own account and data.
-- (Avatar files are deleted by the app through the Storage API first:
-- Supabase does not allow deleting storage objects with SQL.)
create or replace function public.delete_my_account()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  caller uuid := auth.uid();
begin
  if caller is null then
    raise exception 'not signed in' using errcode = '42501';
  end if;

  delete from public.watchlist where user_id = caller;
  delete from public.reviews   where user_id = caller;
  delete from public.profiles  where id      = caller;
  delete from auth.users       where id      = caller;
end;
$$;

-- An admin deletes another user's account and data (not their own:
-- that goes through delete_my_account).
create or replace function public.admin_delete_user(target uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if not public.is_admin() then
    raise exception 'not allowed' using errcode = '42501';
  end if;
  if target = auth.uid() then
    raise exception 'use delete_my_account for your own account'
      using errcode = '22023';
  end if;
  if not exists (select 1 from auth.users where id = target) then
    raise exception 'user not found' using errcode = 'P0002';
  end if;

  delete from public.watchlist where user_id = target;
  delete from public.reviews   where user_id = target;
  delete from public.profiles  where id      = target;
  delete from auth.users       where id      = target;
end;
$$;

revoke execute on function public.delete_my_account()     from public, anon;
revoke execute on function public.admin_delete_user(uuid) from public, anon;
grant  execute on function public.delete_my_account()     to authenticated;
grant  execute on function public.admin_delete_user(uuid) to authenticated;
```

**E. Admin user list with emails**
```sql
create or replace function public.admin_list_users()
returns table (
  id          uuid,
  first_name  text,
  last_name   text,
  profile_pic text,
  role        text,
  report      text,
  email       text
)
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if not public.is_admin() then
    raise exception 'not allowed' using errcode = '42501';
  end if;

  return query
    select p.id, p.first_name, p.last_name, p.profile_pic,
           p.role, p.report, u.email::text
    from public.profiles p
    join auth.users u on u.id = p.id
    order by u.email nulls last;
end;
$$;

revoke execute on function public.admin_list_users() from public, anon;
grant  execute on function public.admin_list_users() to authenticated;
```
(An RPC is not live like the old Firestore stream; the admin list refreshes on open and after each action.)
