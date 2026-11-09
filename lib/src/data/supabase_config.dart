/// Supabase and Google sign-in configuration.
///
/// Keys come from `--dart-define-from-file=env.json` (git-ignored), never from
/// source. The app only ever uses the publishable (anon) key; the
/// service-role key and database password must never ship in the app.
class SupabaseConfig {
  const SupabaseConfig._();

  /// Project URL (public).
  static const String url = 'https://ipnhdpidtktfjuyxcgoj.supabase.co';

  /// Publishable / anon key (`SUPABASE_ANON_KEY` in env.json).
  static const String anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Google OAuth *web* client ID (`GOOGLE_WEB_CLIENT_ID` in env.json). Used
  /// as `serverClientId` so Google returns an ID token Supabase accepts.
  static const String googleWebClientId =
      String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');

  /// Deep-link scheme (the Android application id).
  static const String scheme = 'eg.edu.miuegypt.csc422.movienight';

  /// Where the password-reset email sends the user (allow-listed in the
  /// Supabase dashboard).
  static const String resetPasswordRedirect = '$scheme://reset-password';

  /// Where the sign-up confirmation email sends the user. If this URL is not
  /// allow-listed, Supabase falls back to the project's Site URL; the
  /// account is confirmed either way.
  static const String loginRedirect = '$scheme://login-callback';
}
