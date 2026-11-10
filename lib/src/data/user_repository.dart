import 'dart:async';
import 'dart:io';

import 'package:Movie_Night/src/models/user_model.dart';
import 'package:Movie_Night/src/utils/app_logger.dart';
import 'package:flutter/foundation.dart' show immutable, visibleForTesting;
import 'package:supabase_flutter/supabase_flutter.dart';

/// All reads and writes of a user's data in Supabase: the `profiles` row,
/// the avatar in Storage, the `watchlist` table, and the server functions
/// for writes RLS does not allow from the app (report, role, deletion).
///
/// Profile rows are created by a database trigger at sign-up, never here.
class UserRepository {
  UserRepository({SupabaseClient? client}) : _clientOverride = client;

  static UserRepository? _instance;
  static UserRepository get instance => _instance ??= UserRepository();

  @visibleForTesting
  static set instance(UserRepository repo) => _instance = repo;

  // Resolved lazily so constructing the repository never touches Supabase
  // before `Supabase.initialize()`.
  final SupabaseClient? _clientOverride;
  SupabaseClient get _db => _clientOverride ?? Supabase.instance.client;

  static const String avatarsBucket = 'avatars';

  /// Signed-in user's id (Supabase UUID). Throws [StateError] when signed out.
  String get currentUid {
    final id = _db.auth.currentUser?.id;
    if (id == null) throw StateError('No signed-in user');
    return id;
  }

  // ------------------------------------------------------------ watchlist

  /// Fires after this app adds to or removes from the watchlist, so open
  /// lists refresh at once (with or without Realtime).
  final StreamController<void> _watchlistChanged =
      StreamController<void>.broadcast();

  int _channelSeq = 0;

  /// `watchlist` rows as entries, most recently added first.
  @visibleForTesting
  static List<WatchlistEntry> watchlistEntriesFromRows(
    List<Map<String, dynamic>> rows,
  ) {
    final entries = [
      for (final r in rows)
        if (r['tmdb_id'] is num && r['is_tv'] is bool)
          WatchlistEntry(
            tmdbId: (r['tmdb_id'] as num).toInt(),
            isTv: r['is_tv'] as bool,
            addedAt: DateTime.tryParse('${r['created_at'] ?? ''}'),
          ),
    ];
    entries.sort((a, b) {
      final x = a.addedAt, y = b.addedAt;
      if (x == null && y == null) return 0;
      if (x == null) return 1;
      if (y == null) return -1;
      return y.compareTo(x);
    });
    return entries;
  }

  /// The signed-in user's watchlist (movies and TV), newest first.
  ///
  /// Loads with one request, then reloads after every change: this app's own
  /// adds and removes, and other devices' through Realtime. Realtime is a
  /// bonus: if its channel fails the error is logged and the list stays.
  /// Only a failed load reaches the listener as an error.
  Stream<List<WatchlistEntry>> watchlistEntries() {
    late final StreamController<List<WatchlistEntry>> controller;
    StreamSubscription<void>? localChanges;
    RealtimeChannel? channel;

    Future<void> load() async {
      try {
        final rows = await _db
            .from('watchlist')
            .select('tmdb_id, is_tv, created_at')
            .eq('user_id', currentUid);
        if (!controller.isClosed) {
          controller.add(watchlistEntriesFromRows(rows));
        }
      } catch (e, stack) {
        AppLog.error('watchlistLoad', e, stack);
        if (!controller.isClosed) controller.addError(e, stack);
      }
    }

    controller = StreamController<List<WatchlistEntry>>(
      onListen: () {
        unawaited(load());
        localChanges = _watchlistChanged.stream.listen((_) => load());
        try {
          channel = _db
              .channel('watchlist-${_channelSeq++}')
              .onPostgresChanges(
                event: PostgresChangeEvent.all,
                schema: 'public',
                table: 'watchlist',
                filter: PostgresChangeFilter(
                  type: PostgresChangeFilterType.eq,
                  column: 'user_id',
                  value: currentUid,
                ),
                callback: (_) => load(),
              )
              .subscribe((status, [error]) {
            if (status == RealtimeSubscribeStatus.channelError ||
                status == RealtimeSubscribeStatus.timedOut) {
              AppLog.error('watchlistRealtime', error ?? status);
            }
          });
        } catch (e, stack) {
          AppLog.error('watchlistRealtime', e, stack);
        }
      },
      onCancel: () async {
        await localChanges?.cancel();
        final c = channel;
        if (c != null) {
          try {
            await _db.removeChannel(c);
          } catch (_) {}
        }
      },
    );
    return controller.stream;
  }

  Future<bool> isInWatchlist(int id, {required bool isTvShow}) async {
    final row = await _db
        .from('watchlist')
        .select('tmdb_id')
        .eq('user_id', currentUid)
        .eq('tmdb_id', id)
        .eq('is_tv', isTvShow)
        .maybeSingle();
    return row != null;
  }

  /// Adding a title that is already listed is a no-op (as `arrayUnion` was).
  Future<void> addToWatchlist(int id, {required bool isTvShow}) async {
    try {
      await _db.from('watchlist').insert({
        'user_id': currentUid,
        'tmdb_id': id,
        'is_tv': isTvShow,
      });
    } on PostgrestException catch (e) {
      if (e.code != '23505') rethrow; // 23505: already in the watchlist.
    }
    _watchlistChanged.add(null);
  }

  Future<void> removeFromWatchlist(int id, {required bool isTvShow}) async {
    await _db
        .from('watchlist')
        .delete()
        .eq('user_id', currentUid)
        .eq('tmdb_id', id)
        .eq('is_tv', isTvShow);
    _watchlistChanged.add(null);
  }

  // -------------------------------------------------------------- profile

  /// Live profile row for [uid], or `null` when there is none. The email is
  /// filled only for the signed-in user (it lives in auth, not `profiles`).
  Stream<Users?> userStream(String uid) => _db
      .from('profiles')
      .stream(primaryKey: const ['id'])
      .eq('id', uid)
      .map((rows) {
        if (rows.isEmpty) return null;
        final me = _db.auth.currentUser;
        return Users.fromRow(
          rows.first,
          email: me != null && me.id == uid ? (me.email ?? '') : '',
        );
      });

  /// Whether the signed-in user is an admin (the database's `is_admin()`).
  Future<bool> isAdmin() async => await _db.rpc<dynamic>('is_admin') == true;

  Future<void> updateNames({
    required String firstName,
    required String lastName,
  }) =>
      _db
          .from('profiles')
          .update({'first_name': firstName, 'last_name': lastName})
          .eq('id', currentUid);

  Future<void> updateProfilePic(String url) => _db
      .from('profiles')
      .update({'profile_pic': url}).eq('id', currentUid);

  /// Content type for an avatar file, from its extension.
  @visibleForTesting
  static String avatarContentType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  /// Uploads [file] to `avatars/<uid>/`, points the profile at its public
  /// URL and removes the user's older avatar files. Returns the URL.
  Future<String> uploadAvatar(File file) async {
    final uid = currentUid;
    final type = avatarContentType(file.path);
    final ext = type.split('/').last == 'jpeg' ? 'jpg' : type.split('/').last;
    final path = '$uid/avatar-${DateTime.now().millisecondsSinceEpoch}.$ext';
    final bucket = _db.storage.from(avatarsBucket);
    await bucket.upload(
      path,
      file,
      fileOptions: FileOptions(contentType: type, cacheControl: '3600'),
    );
    final url = bucket.getPublicUrl(path);
    await updateProfilePic(url);
    await _removeAvatars(uid, keep: path);
    return url;
  }

  /// Best effort: a leftover file only costs storage.
  Future<void> _removeAvatars(String uid, {String? keep}) async {
    try {
      final bucket = _db.storage.from(avatarsBucket);
      final files = await bucket.list(path: uid);
      final stale = [
        for (final f in files)
          if ('$uid/${f.name}' != keep) '$uid/${f.name}',
      ];
      if (stale.isNotEmpty) await bucket.remove(stale);
    } catch (e, stack) {
      AppLog.error('removeAvatars', e, stack);
    }
  }

  // -------------------------------------------- server functions (RPCs)

  /// Stores [body] as the signed-in user's report (`submit_report`).
  Future<void> submitReport(String body) =>
      _db.rpc<void>('submit_report', params: {'body': body});

  /// Deletes the signed-in user's avatar files, then their account, profile,
  /// reviews and watchlist (`delete_my_account`). The caller signs out.
  Future<void> deleteMyAccount() async {
    await _removeAvatars(currentUid);
    await _db.rpc<void>('delete_my_account');
  }

  /// Every user with their email, sorted by email (`admin_list_users`,
  /// admins only).
  Future<List<Users>> adminListUsers() async {
    final rows = await _db.rpc<List<dynamic>>('admin_list_users');
    return [
      for (final r in rows) Users.fromRow(Map<String, dynamic>.from(r as Map)),
    ];
  }

  Future<void> adminClearReport(String userId) =>
      _db.rpc<void>('admin_clear_report', params: {'target': userId});

  Future<void> adminMakeAdmin(String userId) =>
      _db.rpc<void>('admin_make_admin', params: {'target': userId});

  /// Deletes another user's account and data (`admin_delete_user`).
  Future<void> adminDeleteUser(String userId) =>
      _db.rpc<void>('admin_delete_user', params: {'target': userId});
}

/// One title on the watchlist.
@immutable
class WatchlistEntry {
  const WatchlistEntry({
    required this.tmdbId,
    required this.isTv,
    this.addedAt,
  });

  final int tmdbId;
  final bool isTv;
  final DateTime? addedAt;

  @override
  bool operator ==(Object other) =>
      other is WatchlistEntry &&
      other.tmdbId == tmdbId &&
      other.isTv == isTv &&
      other.addedAt == addedAt;

  @override
  int get hashCode => Object.hash(tmdbId, isTv, addedAt);
}
