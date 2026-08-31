import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/constants/feed_constants.dart';
import 'package:yordambor/data/auth/auth_repository.dart';
import 'package:yordambor/domain/auth/app_user.dart';
import 'package:yordambor/domain/auth/auth_requirement.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Email shown on verify screen when signup returns no session yet.
final pendingVerificationEmailProvider = StateProvider<String?>((ref) => null);

/// Email used for the latest password reset request.
final pendingPasswordResetEmailProvider = StateProvider<String?>((ref) => null);

class SessionState {
  const SessionState({
    required this.isLoading,
    this.user,
    this.profile,
    this.authEvent,
  });

  final bool isLoading;
  final User? user;
  final AppUser? profile;
  final AuthChangeEvent? authEvent;

  bool get isAuthenticated => user != null;
  bool get isEmailVerified => user?.emailConfirmedAt != null;

  SessionState copyWith({
    bool? isLoading,
    User? user,
    AppUser? profile,
    AuthChangeEvent? authEvent,
    bool clearUser = false,
    bool clearProfile = false,
  }) {
    return SessionState(
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : (user ?? this.user),
      profile: clearProfile ? null : (profile ?? this.profile),
      authEvent: authEvent ?? this.authEvent,
    );
  }
}

final sessionProvider =
    StateNotifierProvider<SessionNotifier, SessionState>((ref) {
  return SessionNotifier(ref.watch(authRepositoryProvider));
});

class SessionNotifier extends StateNotifier<SessionState> {
  SessionNotifier(this._repository)
      : super(const SessionState(isLoading: true)) {
    _init();
  }

  final AuthRepository _repository;

  StreamSubscription<AuthState>? _subscription;

  Future<void> _init() async {
    _subscription = _repository.authStateChanges().listen(_onAuthStateChange);

    final user = _resolveCurrentUser();
    _emitSession(
      user: user,
      profile: user != null ? _profileFromAuthUser(user) : null,
    );

    if (user != null) {
      unawaited(_hydrateProfile(user));
    }
  }

  User? _resolveCurrentUser() {
    final user = _repository.currentUser;
    if (user != null && _repository.isAccountDeleted) {
      unawaited(_repository.signOut());
      return null;
    }
    return user;
  }

  void _emitSession({
    required User? user,
    AppUser? profile,
    AuthChangeEvent? authEvent,
  }) {
    state = SessionState(
      isLoading: false,
      user: user,
      profile: profile,
      authEvent: authEvent,
    );
  }

  Future<void> _onAuthStateChange(AuthState authState) async {
    final nextUser = authState.session?.user;
    if (nextUser != null && _repository.isAccountDeleted) {
      await _repository.signOut();
      _emitSession(user: null, authEvent: AuthChangeEvent.signedOut);
      return;
    }

    _emitSession(
      user: nextUser,
      profile: nextUser != null ? _profileFromAuthUser(nextUser) : null,
      authEvent: authState.event,
    );

    if (nextUser != null) {
      unawaited(_hydrateProfile(nextUser));
    }
  }

  Future<void> _hydrateProfile(User user) async {
    try {
      await _loadProfileForUser().timeout(const Duration(seconds: 5));
      final profile = await _fetchProfileSafely(user);
      if (state.user?.id != user.id || profile == null) return;
      state = state.copyWith(profile: profile);
    } catch (_) {
      // Keep the auth-metadata fallback profile from the fast path.
    }
  }

  Future<void> _loadProfileForUser() async {
    await _repository.ensureProfile();
  }

  Future<AppUser?> _fetchProfileSafely(User user) async {
    try {
      final fetched = await _repository
          .fetchCurrentProfile()
          .timeout(FeedConstants.networkTimeout);
      return _mergeProfile(user, fetched);
    } catch (_) {
      return _profileFromAuthUser(user);
    }
  }

  AppUser? _mergeProfile(User user, AppUser? fetched) {
    if (fetched == null) return _profileFromAuthUser(user);
    if (fetched.fullName.trim().isNotEmpty) return fetched;

    final fallback = _profileFromAuthUser(user);
    return AppUser(
      id: fetched.id,
      email: fetched.email.isNotEmpty ? fetched.email : fallback.email,
      fullName: fallback.fullName,
      phone: fetched.phone.isNotEmpty ? fetched.phone : fallback.phone,
      isEmailVerified: fetched.isEmailVerified,
      language: fetched.language,
      avatarUrl: fetched.avatarUrl,
      showPhone: fetched.showPhone,
    );
  }

  AppUser _profileFromAuthUser(User user) {
    final metadata = user.userMetadata ?? {};
    final metaName = (metadata['full_name'] as String?)?.trim() ?? '';
    final email = user.email ?? '';
    final emailName =
        email.contains('@') ? email.split('@').first.trim() : '';

    return AppUser(
      id: user.id,
      email: email,
      fullName: metaName.isNotEmpty ? metaName : emailName,
      phone: (metadata['phone'] as String?)?.trim() ?? '',
      isEmailVerified: user.emailConfirmedAt != null,
      language: metadata['language'] as String? ?? 'uz',
      avatarUrl: metadata['avatar_url'] as String?,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> refreshProfile() async {
    final user = state.user;
    if (user == null) return;

    final profile = await _fetchProfileSafely(user);
    state = state.copyWith(profile: profile);
  }

  Future<void> signOut() async {
    await _repository.signOut();
  }

  Future<void> deleteAccount() async {
    await _repository.deleteAccount();
    state = const SessionState(isLoading: false);
  }
}

AuthRequirement requirementForAction(AuthRequirement requirement) =>
    requirement;

bool meetsRequirement(SessionState session, AuthRequirement requirement) {
  switch (requirement) {
    case AuthRequirement.none:
      return true;
    case AuthRequirement.account:
      return session.isAuthenticated;
    case AuthRequirement.verifiedEmail:
      return session.isAuthenticated && session.isEmailVerified;
  }
}
