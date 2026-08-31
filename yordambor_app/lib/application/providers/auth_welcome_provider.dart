import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';

enum AuthWelcomeKind {
  newMember,
  returningLogin,
  returningSession,
}

class AuthWelcomeMessage {
  const AuthWelcomeMessage({
    required this.kind,
    required this.displayName,
  });

  final AuthWelcomeKind kind;
  final String displayName;
}

final authWelcomeProvider = StateProvider<AuthWelcomeMessage?>(
  (ref) => null,
);

String firstNameFromFullName(String? fullName) {
  final trimmed = fullName?.trim();
  if (trimmed == null || trimmed.isEmpty) return '';
  return trimmed.split(RegExp(r'\s+')).first;
}

/// Best available display name while profile sync is pending or offline.
String sessionDisplayFullName(SessionState session, {String fallback = ''}) {
  final fromProfile = session.profile?.fullName.trim();
  if (fromProfile != null && fromProfile.isNotEmpty) return fromProfile;

  final user = session.user;
  if (user != null) {
    final metadata = user.userMetadata ?? {};
    final fromMeta = (metadata['full_name'] as String?)?.trim();
    if (fromMeta != null && fromMeta.isNotEmpty) return fromMeta;

    final email = user.email?.trim();
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
  }

  return fallback;
}

String sessionGreetingName(SessionState session, String guestFallback) {
  final first = firstNameFromFullName(sessionDisplayFullName(session));
  return first.isNotEmpty ? first : guestFallback;
}
