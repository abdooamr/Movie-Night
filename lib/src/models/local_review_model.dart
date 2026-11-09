import 'package:intl/intl.dart';

/// A Movie Night review as the UI shows it: the `reviews` row plus the
/// author's name and picture from `profiles`.
class Localreviews {
  Localreviews({
    required this.review,
    required this.displayname,
    required this.ProfilePic,
    required this.createdat,
    required this.id,
  });

  String? review;

  /// Author's `first_name last_name`.
  String displayname;

  /// Author's `profile_pic` URL ('' when none).
  String ProfilePic;

  /// `created_at` formatted for display (`dd-MM-yyyy`, current locale).
  String createdat;

  /// Author's user id (Supabase UUID).
  String id;

  /// The display format the app has always used. Uses the current Intl
  /// locale, so Arabic shows Arabic-Indic digits, as before.
  static DateFormat get dateFormat => DateFormat('dd-MM-yyyy');

  /// Builds a review from a `reviews` row and its author's `profiles` row
  /// (null when the author is unknown, e.g. a deleted account).
  factory Localreviews.fromRow(
    Map<String, dynamic> row, {
    Map<String, dynamic>? author,
    DateFormat? format,
  }) {
    final first = author?['first_name'];
    final last = author?['last_name'];
    final name = [first, last]
        .whereType<String>()
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .join(' ');
    final created = DateTime.tryParse('${row['created_at'] ?? ''}');
    return Localreviews(
      review: row['review'] as String?,
      displayname: name,
      ProfilePic: author?['profile_pic'] is String
          ? author!['profile_pic'] as String
          : '',
      createdat:
          created == null ? '' : (format ?? dateFormat).format(created.toLocal()),
      id: '${row['user_id'] ?? ''}',
    );
  }
}
