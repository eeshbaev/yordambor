import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/data/growth/provider_stats_repository.dart';

enum SupportCategory {
  bug,
  account,
  payment,
  other,
}

extension SupportCategoryX on SupportCategory {
  String get value => switch (this) {
        SupportCategory.bug => 'bug',
        SupportCategory.account => 'account',
        SupportCategory.payment => 'payment',
        SupportCategory.other => 'other',
      };
}

class SupportFailure implements Exception {
  SupportFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

class SupportRepository {
  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<void> submitTicket({
    required SupportCategory category,
    required String description,
    String? screenshotUrl,
    String? appVersion,
  }) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw SupportFailure('Kirish talab qilinadi');
    }

    final trimmed = description.trim();
    if (trimmed.length < 10) {
      throw SupportFailure('Tavsif kamida 10 ta belgidan iborat bo\'lsin');
    }

    await client.from('support_tickets').insert({
      'user_id': userId,
      'category': category.value,
      'description': trimmed,
      'app_version': appVersion,
      'platform': currentPlatformLabel(),
      'screenshot_url': screenshotUrl,
    });
  }
}

class FeedbackFailure implements Exception {
  FeedbackFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

class FeedbackRepository {
  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<void> submit({
    required String message,
    int? rating,
    String? appVersion,
  }) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw FeedbackFailure('Kirish talab qilinadi');
    }

    final trimmed = message.trim();
    if (trimmed.length < 3) {
      throw FeedbackFailure('Xabar juda qisqa');
    }

    await client.from('feedback_submissions').insert({
      'user_id': userId,
      'rating': rating,
      'message': trimmed,
      'app_version': appVersion,
      'platform': currentPlatformLabel(),
    });
  }
}
