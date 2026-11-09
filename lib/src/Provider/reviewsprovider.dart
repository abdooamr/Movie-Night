import 'package:Movie_Night/src/models/local_review_model.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Movie Night reviews in the Supabase `reviews` table: one per user per
/// title and type (`UNIQUE NULLS NOT DISTINCT (movie_id, media_type,
/// user_id)`, see `docs/sql/2026-11-10-reviews-media-type.sql`).
///
/// `media_type` is 'movie' or 'tv' for new reviews. Reviews imported from
/// Firestore have none (NULL): Firestore keyed reviews by TMDB id only, so
/// they keep showing on both the movie and the TV page with that id.
class ReviewProvider extends ChangeNotifier {
  ReviewProvider({SupabaseClient? client}) : _clientOverride = client;

  // Resolved lazily so creating the provider never touches Supabase before
  // `Supabase.initialize()`.
  final SupabaseClient? _clientOverride;
  SupabaseClient get _db => _clientOverride ?? Supabase.instance.client;

  String get _uid {
    final id = _db.auth.currentUser?.id;
    if (id == null) throw StateError('No signed-in user');
    return id;
  }

  /// The `media_type` value for a page.
  static String mediaTypeOf({required bool isTv}) => isTv ? 'tv' : 'movie';

  /// Whether a `reviews` row belongs on the movie or TV page: its own type,
  /// or a legacy row with no type.
  @visibleForTesting
  static bool visibleOn(Map<String, dynamic> row, {required bool isTv}) {
    final type = row['media_type'];
    return type == null || type == mediaTypeOf(isTv: isTv);
  }

  /// Saves the signed-in user's review of [movieId] on the [isTv] page.
  ///
  /// - A legacy (untyped) review of this id is the user's review on both
  ///   pages, so it is edited in place.
  /// - Otherwise a new row the first time, then only its `review` column
  ///   (never an upsert, which RLS rejects).
  Future<void> saveReview({
    required int movieId,
    required bool isTv,
    required String text,
  }) async {
    final uid = _uid;
    final type = mediaTypeOf(isTv: isTv);
    try {
      final legacy = await _db
          .from('reviews')
          .select('id')
          .eq('movie_id', movieId)
          .eq('user_id', uid)
          .isFilter('media_type', null)
          .maybeSingle();
      if (legacy != null) {
        await _db
            .from('reviews')
            .update({'review': text}).eq('id', legacy['id'] as Object);
      } else {
        try {
          await _db.from('reviews').insert({
            'movie_id': movieId,
            'media_type': type,
            'user_id': uid,
            'review': text,
          });
        } on PostgrestException catch (e) {
          if (e.code != '23505') rethrow; // Not "already reviewed".
          await _db
              .from('reviews')
              .update({'review': text})
              .eq('movie_id', movieId)
              .eq('media_type', type)
              .eq('user_id', uid);
        }
      }
      notifyListeners();
    } catch (error, stack) {
      AppLog.error('saveReview', error, stack);
      rethrow; // The UI shows the failure.
    }
  }

  /// Live reviews of [movieId] for the [isTv] page, newest first (Realtime).
  /// Realtime streams can't join, so each change looks up the authors it
  /// hasn't seen yet in `profiles`; names and pictures are cached for the
  /// life of the stream.
  Stream<List<Localreviews>> getReviews(int movieId, {required bool isTv}) {
    final authors = <String, Map<String, dynamic>>{};
    final format = Localreviews.dateFormat;
    return _db
        .from('reviews')
        .stream(primaryKey: const ['id'])
        .eq('movie_id', movieId)
        .order('created_at', ascending: false)
        .asyncMap((all) async {
      // A stream takes one filter; the type is filtered here.
      final rows = all.where((r) => visibleOn(r, isTv: isTv)).toList();
      final missing = {
        for (final r in rows)
          if (r['user_id'] is String && !authors.containsKey(r['user_id']))
            r['user_id'] as String,
      };
      if (missing.isNotEmpty) {
        try {
          final found = await _db
              .from('profiles')
              .select('id, first_name, last_name, profile_pic')
              .inFilter('id', missing.toList());
          for (final p in found) {
            authors['${p['id']}'] = p;
          }
        } catch (e, stack) {
          // Reviews still show, without names, rather than failing.
          AppLog.error('reviewAuthors', e, stack);
        }
      }
      return [
        for (final r in rows)
          Localreviews.fromRow(r, author: authors[r['user_id']], format: format),
      ];
    });
  }

  /// Deletes the signed-in user's review shown on the [isTv] page of
  /// [movieId]: their typed review, or their legacy one.
  Future<void> deleteReview({required int movieId, required bool isTv}) async {
    try {
      await _db
          .from('reviews')
          .delete()
          .eq('movie_id', movieId)
          .eq('user_id', _uid)
          .or('media_type.eq.${mediaTypeOf(isTv: isTv)},media_type.is.null');
      notifyListeners();
    } catch (error, stack) {
      AppLog.error('deleteReview', error, stack);
      rethrow;
    }
  }
}
