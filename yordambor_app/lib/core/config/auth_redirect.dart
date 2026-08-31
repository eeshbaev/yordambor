/// Supabase email/OAuth redirect target for the mobile app.
///
/// Must also be added in Supabase Dashboard → Authentication → URL Configuration:
/// - Redirect URLs: `yordambor://auth/callback`
abstract final class AuthRedirectConfig {
  static const emailRedirectTo = 'yordambor://auth/callback';
}
