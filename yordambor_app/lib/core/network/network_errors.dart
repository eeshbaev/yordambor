import 'dart:async';

/// Best guess that [error] means "no connection" rather than a bug or a
/// server refusal: timeouts, DNS failures, refused or dropped sockets.
bool isLikelyOfflineError(Object error) {
  if (error is TimeoutException) return true;
  final text = error.toString().toLowerCase();
  const signs = [
    'socketexception',
    'failed host lookup',
    'network is unreachable',
    'connection refused',
    'connection reset',
    'connection closed',
    'connection timed out',
    'clientexception',
    'handshakeexception',
  ];
  return signs.any(text.contains);
}
