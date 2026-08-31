import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/auth_redirect.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/domain/auth/app_user.dart';

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

    final row = await client
        .from('profiles')
        .select('full_name, email, phone, language, avatar_url, show_phone')
        .eq('id', user.id)
        .maybeSingle();

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

  Future<void> updateShowPhone(bool showPhone) async {
    final user = currentUser;
    final client = _client;
    if (user == null || client == null) {
      throw AuthFailure('Kirish talab qilinadi');
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
      throw AuthFailure('Kirish talab qilinadi');
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
      throw AuthFailure('Supabase sozlanmagan');
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
        throw AuthFailure('Ro\'yxatdan o\'tish amalga oshmadi');
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
      throw AuthFailure('Supabase sozlanmagan');
    }

    try {
      final email = await _resolveLoginEmail(identifier.trim());
      await client.auth.signInWithPassword(email: email, password: password);
      await ensureProfile();
    } on AuthFailure {
      rethrow;
    } on AuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    } on PostgrestException catch (e) {
      throw AuthFailure(_mapPostgrestError(e));
    }
  }

  Future<void> signOut() async {
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
      throw AuthFailure('Kirish talab qilinadi');
    }

    try {
      await client.rpc('delete_user_account');
      await client.auth.updateUser(
        UserAttributes(data: const {'account_deleted': true}),
      );
      await signOut();
    } on PostgrestException catch (e) {
      throw AuthFailure(e.message);
    } on AuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    }
  }

  Future<void> resetPassword(String email) async {
    final client = _client;
    if (client == null) {
      throw AuthFailure('Supabase sozlanmagan');
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
      throw AuthFailure('Supabase sozlanmagan');
    }
    if (currentUser == null) {
      throw AuthFailure('Parolni tiklash havolasi muddati tugagan. Qayta so\'rang.');
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
      throw AuthFailure('Supabase sozlanmagan');
    }

    final targetEmail = email?.trim().isNotEmpty == true
        ? email!.trim()
        : currentUser?.email;
    if (targetEmail == null || targetEmail.isEmpty) {
      throw AuthFailure('Email topilmadi');
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

    await client.from('profiles').upsert({
      'id': userId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
    });
  }

  Future<String> _resolveLoginEmail(String identifier) async {
    if (identifier.contains('@')) {
      return identifier;
    }

    final client = _client;
    if (client == null) {
      throw AuthFailure('Supabase sozlanmagan');
    }

    final phone = normalizePhone(identifier);
    final row = await client
        .from('profiles')
        .select('email')
        .eq('phone', phone)
        .maybeSingle();

    if (row == null) {
      throw AuthFailure('Bu telefon yoki email bilan hisob topilmadi');
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
    final message = error.message.toLowerCase();
    if (message.contains('invalid api key')) {
      return 'Supabase API kaliti noto\'g\'ri. .env.json faylida anon key ni tekshiring va ilovani qayta ishga tushiring.';
    }
    if (message.contains('invalid login credentials')) {
      return 'Email yoki parol noto\'g\'ri';
    }
    if (message.contains('already registered') ||
        message.contains('user already registered')) {
      return 'Bu email bilan hisob mavjud. Kirishni sinab ko\'ring.';
    }
    return error.message;
  }

  static String _mapPostgrestError(PostgrestException error) {
    if (error.code == '23505') {
      if (error.message.contains('email')) {
        return 'Bu email bilan hisob mavjud. Kirishni sinab ko\'ring.';
      }
      if (error.message.contains('phone')) {
        return 'Bu telefon raqami allaqachon ro\'yxatdan o\'tgan';
      }
    }
    return error.message;
  }
}
