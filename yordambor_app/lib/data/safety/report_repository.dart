import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';

class ReportFailure implements Exception {
  ReportFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

enum ReportTargetType {
  profile,
  xizmat,
  kelishuv,
  post,
}

extension ReportTargetTypeX on ReportTargetType {
  String get value => switch (this) {
        ReportTargetType.profile => 'profile',
        ReportTargetType.xizmat => 'xizmat',
        ReportTargetType.kelishuv => 'kelishuv',
        ReportTargetType.post => 'post',
      };
}

class ReportRepository {
  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<void> submit({
    required ReportTargetType targetType,
    required String targetId,
    String? reason,
  }) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw ReportFailure('Kirish talab qilinadi');
    }

    final trimmed = reason?.trim();
    await client.from('reports').insert({
      'reporter_id': userId,
      'target_type': targetType.value,
      'target_id': targetId,
      'reason': trimmed == null || trimmed.isEmpty ? null : trimmed,
    });
  }
}
