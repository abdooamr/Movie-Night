import 'package:Movie_Night/src/models/local_review_model.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Movie Night reviews in the Supabase `reviews` table: one per user per
/// title (`UNIQUE (movie_id, user_id)`). `movie_id` is the TMDB id for both
/// movies and TV shows, as it was in Firestore.
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

  /// Saves the signed-in user's review of [movieId]: a new row the first
  /// time, otherwise only the `review` column of their existing row (never
  /// an upsert, which RLS rejects).
  Future<void> saveReview({required int movieId, required String text}) async {
    final uid = _uid;
    try {
      try {
        await _db
            .from('reviews')
            .insert({'movie_id': movieId, 'user_id': uid, 'review': text});
      } on PostgrestException catch (e) {
        if (e.code != '23505') rethrow; // Not "already reviewed".
        await _db
            .from('reviews')
            .update({'review': text})
            .eq('movie_id', movieId)
            .eq('user_id', uid);
      }
      notifyListeners();
    } catch (error, stack) {
      AppLog.error('saveReview', error, stack);
      rethrow; // The UI shows the failure.
    }
  }

  /// Live reviews of [movieId], newest first (Realtime). Realtime streams
  /// can't join, so each change looks up the authors it hasn't seen yet in
  /// `profiles`; names and pictures are cached for the life of the stream.
  Stream<List<Localreviews>> getReviews(int movieId) {
    final authors = <String, Map<String, dynamic>>{};
    final format = Localreviews.dateFormat;
    return _db
        .from('reviews')
        .stream(primaryKey: const ['id'])
        .eq('movie_id', movieId)
        .order('created_at', ascending: false)
        .asyncMap((rows) async {
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

  /// Deletes the signed-in user's review of [movieId].
  Future<void> deleteReview({required int movieId}) async {
    try {
      await _db
          .from('reviews')
          .delete()
          .eq('movie_id', movieId)
          .eq('user_id', _uid);
      notifyListeners();
    } catch (error, stack) {
      AppLog.error('deleteReview', error, stack);
      rethrow;
    }
  }
}
