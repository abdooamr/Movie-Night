-- Movie / TV review split (section F). Run in the Supabase SQL editor
-- BEFORE installing the app build that tags reviews.
--
-- Old (imported) reviews keep media_type NULL and keep showing on both the
-- movie and the TV page with that TMDB id, exactly as before. Every new
-- review is saved as 'movie' or 'tv'. Nothing is dropped or rewritten.

-- 1. The column. NULL = legacy review from before the split.
alter table public.reviews
  add column if not exists media_type text
  check (media_type in ('movie', 'tv'));

-- 2. One review per user per title *and type* instead of per TMDB id.
--    NULLS NOT DISTINCT keeps "at most one legacy review per id" as well.
--    First find the name of the existing UNIQUE (movie_id, user_id)
--    constraint (normally reviews_movie_id_user_id_key):
select conname
from pg_constraint
where conrelid = 'public.reviews'::regclass
  and contype = 'u';

--    Then replace it (adjust the name if the query above shows another):
alter table public.reviews
  drop constraint if exists reviews_movie_id_user_id_key;

alter table public.reviews
  add constraint reviews_movie_id_media_type_user_id_key
  unique nulls not distinct (movie_id, media_type, user_id);

-- 3. Let the app set media_type when it inserts a review. (Updates stay
--    limited to the review column: media_type is never changed afterwards.)
grant insert (media_type) on public.reviews to authenticated;

-- Check: every existing review is still there, all with media_type NULL.
select media_type, count(*) from public.reviews group by media_type;
