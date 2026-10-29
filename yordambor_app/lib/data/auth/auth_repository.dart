import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yordambor/core/constants/feed_constants.dart';
import 'package:yordambor/core/config/auth_redirect.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/core/supabase/postgrest_errors.dart';
import 'package:yordambor/core/supabase/supabase_auth_errors.dart';
import 'package:yordambor/data/storage/storage_repository.dart';
import 'package:yordambor/domain/auth/app_user.dart';
import 'package:yordambor/core/l10n/current_strings.dart';

class AuthFailure implements Exception {
  AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthRepository {
  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Stream<AuthState> authStateChanges() {
    final client = _client;
    if (client == null) {
      return Stream.value(const AuthState(AuthChangeEvent.initialSession, null));
    }
    return client.auth.onAuthStateChange;
  }

  User? get currentUser => _client?.auth.currentUser;

  bool get isAuthenticated => currentUser != null;

  bool get isEmailVerified => currentUser?.emailConfirmedAt != null;

  Future<AppUser?> fetchCurrentProfile() async {
    final user = currentUser;
    final client = _client;
    if (user == null || client == null) return null;

    final row = await _readOwnProfile(client, user.id);
    if (row == null) return null;

    return AppUser(
      id: user.id,
      email: row['email'] as String? ?? user.email ?? '',
      fullName: row['full_name'] as String? ?? '',
      phone: row['phone'] as String? ?? '',
      isEmailVerified: isEmailVerified,
      language: row['language'] as String? ?? 'uz',
      avatarUrl: row['avatar_url'] as String?,
      showPhone: row['show_phone'] as bool? ?? false,
    );
  }

  /// Your own profile, email and phone included. Only you can read those
  /// (migration 023), so they come through get_my_profile(); a server
  /// without it yet is read the old way.
  Future<Map<String, dynamic>?> _readOwnProfile(
    SupabaseClient client,
    String userId,
  ) async {
    try {
      return await client.rpc('get_my_profile').maybeSingle();
    } on PostgrestException catch (error) {
      if (!isMissingRpc(error)) rethrow;
      return client
          .from('profiles')
          .select('full_name, email, phone, language, avatar_url, show_phone')
          .eq('id', userId)
          .maybeSingle();
    }
  }

  Future<void> updateShowPhone(bool showPhone) async {
    final user = currentUser;
    final client = _client;
    if (user == null || client == null) {
      throw AuthFailure(CurrentStrings.value.errSignInRequired);
    }

    try {
      await client
          .from('profiles')
          .update({'show_phone': showPhone})
          .eq('id', user.id);
    } on PostgrestException catch (e) {
      throw AuthFailure(_mapPostgrestError(e));
    }
  }

  Future<void> updateAvatarUrl(String avatarUrl) async {
    final user = currentUser;
    final client = _client;
    if (user == null || client == null) {
      throw AuthFailure(CurrentStrings.value.errSignInRequired);
    }

    try {
      await client
          .from('profiles')
          .update({'avatar_url': avatarUrl})
          .eq('id', user.id);
    } on PostgrestException catch (e) {
      throw AuthFailure(_mapPostgrestError(e));
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final client = _client;
    if (client == null) {
      throw AuthFailure(CurrentStrings.value.errServerNotSetUp);
    }

    try {
      final normalizedPhone = normalizePhone(phone);
      final response = await client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'full_name': fullName.trim(),
          'phone': normalizedPhone,
        },
      );

      final user = response.user;
      if (user == null) {
        throw AuthFailure(CurrentStrings.value.errSignUpFailed);
      }

      if (response.session != null) {
        await _upsertProfile(
          userId: user.id,
          fullName: fullName.trim(),
          email: email.trim(),
          phone: normalizedPhone,
        );
      }
    } on AuthFailure {
      rethrow;
    } on AuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    } on PostgrestException catch (e) {
      throw AuthFailure(_mapPostgrestError(e));
    }
  }

  Future<void> signIn({
    required String identifier,
    required String password,
  }) async {
    final client = _client;
    if (client == null) {
      throw AuthFailure(CurrentStrings.value.errServerNotSetUp);
    }

    try {
      await _signInWithTimeout(
        client,
        identifier: identifier,
        password: password,
      );
    } on AuthFailure {
      rethrow;
    } on TimeoutException {
      throw AuthFailure(
        CurrentStrings.value.errSlowNetwork,
      );
    } on AuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    } on PostgrestException catch (e) {
      throw AuthFailure(_mapPostgrestError(e));
    }
  }

  Future<void> _signInWithTimeout(
    SupabaseClient client, {
    required String identifier,
    required String password,
  }) async {
    final email = await _resolveLoginEmail(identifier.trim(), password)
        .timeout(FeedConstants.networkTimeout);
    await client.auth
        .signInWithPassword(email: email, password: password)
        .timeout(FeedConstants.networkTimeout);
    await ensureProfile().timeout(FeedConstants.networkTimeout);
  }

  // ──────────────────────────────────────────────────────────────
  // Google Sign-In
  // ──────────────────────────────────────────────────────────────

  final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Signs in with Google using the native account picker.
  /// Returns `true` if a session was created, `false` if the user cancelled.
  Future<bool> signInWithGoogle() async {
    final client = _client;
    if (client == null) throw AuthFailure(CurrentStrings.value.errServerNotSetUp);

    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return false; // user cancelled

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        throw AuthFailure(CurrentStrings.value.errGoogleSignInFailed);
      }

      await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: auth.accessToken,
      );

      await ensureProfile();
      return true;
    } on AuthFailure {
      rethrow;
    } on AuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('sign_in_canceled') ||
          msg.contains('network_error') ||
          msg.contains('PlatformException(sign_in_canceled')) {
        return false; // user cancelled
      }
      throw AuthFailure(msg);
    }
  }

  Future<void> _signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }

  // ──────────────────────────────────────────────────────────────
  // Telegram Login (browser → deep link flow)
  // ──────────────────────────────────────────────────────────────

  /// Opens the Telegram Login page hosted as a Supabase Edge Function.
  ///
  /// The function verifies the Telegram HMAC hash server-side, creates /
  /// retrieves the Supabase account, then redirects to
  /// `yordambor://auth/callback` with the session tokens.
  /// `app_links` in the app intercepts that deep link and completes the flow.
  ///
  /// [projectRef] is the short Supabase project reference, e.g. `abcdefghijk`.
  Future<void> signInWithTelegram(String projectRef) async {
    final uri = Uri.parse(
      'https://$projectRef.supabase.co/functions/v1/telegram-auth',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw AuthFailure(CurrentStrings.value.errTelegramOpenFailed);
    }
  }

  // ──────────────────────────────────────────────────────────────
  // Profile completion (after social auth)
  // ──────────────────────────────────────────────────────────────

  /// Saves full name and phone for a user who just signed in via
  /// Google or Telegram and hasn't yet provided those details.
  Future<void> completeProfile({
    required String fullName,
    required String phone,
  }) async {
    final client = _client;
    final user = currentUser;
    if (client == null || user == null) {
      throw AuthFailure(CurrentStrings.value.errSignInRequired);
    }

    final normalizedPhone = normalizePhone(phone);

    try {
      await client.from('profiles').upsert(
        {
          'id': user.id,
          'full_name': fullName.trim(),
          'phone': normalizedPhone,
        },
        onConflict: 'id',
      );

      // Keep user metadata in sync so the in-memory profile is correct.
      await client.auth.updateUser(
        UserAttributes(
          data: {
            'full_name': fullName.trim(),
            'phone': normalizedPhone,
          },
        ),
      );
    } on PostgrestException catch (e) {
      throw AuthFailure(_mapPostgrestError(e));
    } on AuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    }
  }

  // ──────────────────────────────────────────────────────────────
  // Sign-out
  // ──────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _signOutGoogle();
    await _client?.auth.signOut();
  }

  bool get isAccountDeleted {
    final metadata = currentUser?.userMetadata;
    return metadata?['account_deleted'] == true;
  }

  Future<void> deleteAccount() async {
    final client = _client;
    final user = currentUser;
    if (client == null || user == null) {
      throw AuthFailure(CurrentStrings.value.errSignInRequired);
    }

    try {
      // Files first: once the account is gone, nobody may remove them.
      await StorageRepository().deleteAllFor(user.id);
      // Removes the data and the sign-in itself (migration 025).
      await client.rpc('delete_user_account');
    } on StorageException catch (e) {
      throw AuthFailure(e.message);
    } on PostgrestException catch (e) {
      throw AuthFailure(e.message);
    }
    try {
      await signOut();
    } catch (_) {
      // The session belonged to an account that no longer exists.
    }
  }

  Future<void> resetPassword(String email) async {
    final client = _client;
    if (client == null) {
      throw AuthFailure(CurrentStrings.value.errServerNotSetUp);
    }

    try {
      await client.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: AuthRedirectConfig.emailRedirectTo,
      );
    } on AuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    }
  }

  Future<void> updatePassword(String password) async {
    final client = _client;
    if (client == null) {
      throw AuthFailure(CurrentStrings.value.errServerNotSetUp);
    }
    if (currentUser == null) {
      throw AuthFailure(CurrentStrings.value.errResetLinkExpired);
    }

    try {
      await client.auth.updateUser(UserAttributes(password: password));
    } on AuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    }
  }

  Future<void> resendVerificationEmail({String? email}) async {
    final client = _client;
    if (client == null) {
      throw AuthFailure(CurrentStrings.value.errServerNotSetUp);
    }

    final targetEmail = email?.trim().isNotEmpty == true
        ? email!.trim()
        : currentUser?.email;
    if (targetEmail == null || targetEmail.isEmpty) {
      throw AuthFailure(CurrentStrings.value.errEmailNotFound);
    }

    try {
      await client.auth.resend(type: OtpType.signup, email: targetEmail);
    } on AuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    }
  }

  Future<void> ensureProfile() async {
    final client = _client;
    final user = currentUser;
    if (client == null || user == null) return;

    final existing = await client
        .from('profiles')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    if (existing != null) return;

    final metadata = user.userMetadata ?? {};
    await _upsertProfile(
      userId: user.id,
      fullName:
          metadata['full_name'] as String? ?? user.email?.split('@').first ?? '',
      email: user.email ?? '',
      phone: metadata['phone'] as String? ?? '',
    );
  }

  Future<void> _upsertProfile({
    required String userId,
    required String fullName,
    required String email,
    required String phone,
  }) async {
    final client = _client;
    if (client == null) return;

    // Adds the row once; an existing profile is left as it is.
    await client.from('profiles').upsert(
      {
        'id': userId,
        'full_name': fullName,
        'email': email,
        'phone': phone.isNotEmpty ? phone : null,
      },
      ignoreDuplicates: true,
    );
  }

  /// The email to sign in with. A phone number is looked up on the server,
  /// which names the account only for the right password and stops after
  /// five wrong tries in 15 minutes (migration 023), so nobody can collect
  /// emails by trying numbers.
  Future<String> _resolveLoginEmail(String identifier, String password) async {
    if (identifier.contains('@')) {
      return identifier;
    }

    final client = _client;
    if (client == null) {
      throw AuthFailure(CurrentStrings.value.errServerNotSetUp);
    }

    final phone = normalizePhone(identifier);
    try {
      final email = await client.rpc<dynamic>(
        'login_email_for_phone',
        params: {'p_phone': phone, 'p_password': password},
      );
      if (email is String && email.isNotEmpty) return email;
      throw AuthFailure(CurrentStrings.value.errWrongPhoneOrPassword);
    } on PostgrestException catch (error) {
      if (error.message.contains('too_many_attempts')) {
        throw AuthFailure(
          CurrentStrings.value.errTooManyAttempts,
        );
      }
      if (!isMissingRpc(error)) rethrow;
    }

    // A server without the function yet: the old lookup.
    final row = await client
        .from('profiles')
        .select('email')
        .eq('phone', phone)
        .maybeSingle();

    if (row == null) {
      throw AuthFailure(CurrentStrings.value.errAccountNotFound);
    }

    return row['email'] as String;
  }

  static String normalizePhone(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('998')) {
      return '+$digits';
    }
    if (digits.length == 9) {
      return '+998$digits';
    }
    if (input.startsWith('+')) {
      return input;
    }
    return '+$digits';
  }

  static String _mapAuthError(AuthException error) {
    if (isSupabaseAuthNetworkError(error)) {
      return mapSupabaseNetworkMessage(error);
    }

    final message = error.message.toLowerCase();
    if (message.contains('invalid api key')) {
      return CurrentStrings.value.errBadApiKey;
    }
    if (message.contains('invalid login credentials')) {
      return CurrentStrings.value.errWrongEmailOrPassword;
    }
    if (message.contains('email not confirmed')) {
      return CurrentStrings.value.errEmailNotConfirmed;
    }
    if (message.contains('already registered') ||
        message.contains('user already registered')) {
      return CurrentStrings.value.errEmailTaken;
    }
    return error.message;
  }

  static String _mapPostgrestError(PostgrestException error) {
    if (error.code == '23505') {
      if (error.message.contains('email')) {
        return CurrentStrings.value.errEmailTaken;
      }
      if (error.message.contains('phone')) {
        return CurrentStrings.value.errPhoneTaken;
      }
    }
    return error.message;
  }
}
