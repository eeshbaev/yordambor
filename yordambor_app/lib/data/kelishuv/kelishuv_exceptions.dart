import 'package:yordambor/domain/entities/kelishuv_message.dart';

class KelishuvFailure implements Exception {
  KelishuvFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

class KelishuvSendMessageResult {
  const KelishuvSendMessageResult({
    required this.message,
    this.acceptsReset = false,
  });

  final KelishuvMessage message;
  final bool acceptsReset;
}
