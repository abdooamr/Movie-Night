import 'package:Movie_Night/src/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

/// All reads/writes of the `users/{uid}` Firestore document that used to live
/// inside widget `State` classes.
///
/// Field names are kept exactly as they are written today
/// (`firstName`/`lastName`, `Moviewatchlist`/`tvwatchlist`, ...). Live users
/// exist in more than one document shape (OPEN_QUESTIONS Q2 = b): reads accept
/// both, writes only produce the canonical one. Rewriting stored legacy
/// documents is a separate, owner-run migration — not done in code here.
class UserRepository {
  UserRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestoreOverride = firestore,
        _authOverride = auth;

  static UserRepository? _instance;
  static UserRepository get instance => _instance ??= UserRepository();

  @visibleForTesting
  static set instance(UserRepository repo) => _instance = repo;

  // Resolved lazily so constructing the repository never touches Firebase
  // before `Firebase.initializeApp()`.
  final FirebaseFirestore? _firestoreOverride;
  final FirebaseAuth? _authOverride;
  FirebaseFirestore get _db => _firestoreOverride ?? FirebaseFirestore.instance;
  FirebaseAuth get _auth => _authOverride ?? FirebaseAuth.instance;

  static const String movieWatchlistField = 'Moviewatchlist';
  static const String tvWatchlistField = 'tvwatchlist';

  static String watchlistField(bool isTvShow) =>
      isTvShow ? tvWatchlistField : movieWatchlistField;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  DocumentReference<Map<String, dynamic>> _doc(String uid) => _users.doc(uid);

  /// Signed-in user's uid. Throws [StateError] when signed out.
  String get currentUid {
    final user = _auth.currentUser;
    if (user == null) throw StateError('No signed-in user');
    return user.uid;
  }

  // ------------------------------------------------------------ watchlist

  static List<int> _watchlistFrom(Map<String, dynamic>? data, bool isTvShow) {
    final raw = data?[watchlistField(isTvShow)];
    if (raw is! List) return const [];
    return [
      for (final v in raw)
        if (v is num) v.toInt(),
    ];
  }

  /// Live watchlist ids for the signed-in user.
  Stream<List<int>> watchlistStream({required bool isTvShow}) => _doc(currentUid)
      .snapshots()
      .map((s) => _watchlistFrom(s.data(), isTvShow));

  Future<bool> isInWatchlist(int id, {required bool isTvShow}) async {
    final snap = await _doc(currentUid).get();
    return _watchlistFrom(snap.data(), isTvShow).contains(id);
  }

  /// Creates the document if it does not exist yet (previous behaviour).
  Future<void> addToWatchlist(int id, {required bool isTvShow}) =>
      _doc(currentUid).set({
        watchlistField(isTvShow): FieldValue.arrayUnion([id]),
      }, SetOptions(merge: true));

  Future<void> removeFromWatchlist(int id, {required bool isTvShow}) =>
      _doc(currentUid).update({
        watchlistField(isTvShow): FieldValue.arrayRemove([id]),
      });

  // -------------------------------------------------------------- profile

  /// Maps the document to [Users]; `null` when it does not exist.
  /// Reads both the current and the legacy `firstname`/`lastname` shape
  /// (see [Users.fromFirestore]).
  Stream<Users?> userStream(String uid) => _doc(uid).snapshots().map((s) {
        final d = s.data();
        if (!s.exists || d == null) return null;
        return Users.fromFirestore(d);
      });

  // ------------------------------------------------------------- creation

  /// Email/password registration. Writes the canonical shape.
  Future<void> createUserDocument(String uid, Users user) =>
      _doc(uid).set({
        'id': uid,
        'role': user.role,
        'ProfilePic': user.ProfilePic,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'report': '',
      });

  /// Google sign-in. Creates the document only when it is missing, so it
  /// never overwrites an existing user — and it also back-fills accounts
  /// whose first sign-in crashed before the document was written (the old
  /// `displayName.split(" ")[1]` bug), which `isNewUser` alone would skip
  /// forever.
  Future<void> ensureGoogleUserDocument(User user) async {
    final ref = _doc(user.uid);
    final snap = await ref.get();
    if (snap.exists) return;
    final name = Users.splitDisplayName(user.displayName);
    await ref.set({
      'id': user.uid,
      'role': 'User',
      'ProfilePic': user.photoURL,
      'firstName': name.first,
      'lastName': name.last,
      'email': user.email,
      'report': '',
    });
  }

  /// `role` field, or `null` if the document/field is missing.
  Future<String?> role(String uid) async {
    final snap = await _doc(uid).get();
    final r = snap.data()?['role'];
    return r is String ? r : null;
  }

  Future<bool> isAdmin(String uid) async => await role(uid) == 'admin';

  Future<void> updateProfilePic(String uid, String url) =>
      _doc(uid).update({'ProfilePic': url});

  Future<void> updateNames(String uid,
          {required String firstName, required String lastName}) =>
      _doc(uid).update({'firstName': firstName, 'lastName': lastName});

  Future<void> deleteUserDocument(String uid) => _doc(uid).delete();
}
