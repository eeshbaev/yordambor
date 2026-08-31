import 'package:yordambor/data/auth/auth_repository.dart';

String? normalizeOptionalContactPhone(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return null;
  return AuthRepository.normalizePhone(trimmed);
}

bool isValidOptionalContactPhone(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return true;
  final normalized = normalizeOptionalContactPhone(trimmed);
  if (normalized == null) return false;
  final digits = normalized.replaceAll(RegExp(r'\D'), '');
  return digits.length >= 12;
}
