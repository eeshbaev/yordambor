import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.read,
    required this.createdAt,
    this.title,
    this.body,
    this.payload,
  });

  final String id;
  final String type;
  final bool read;
  final DateTime createdAt;
  final String? title;
  final String? body;
  final Map<String, dynamic>? payload;
}

class NotificationRepository {
  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<List<AppNotification>> fetchMine({int limit = 30}) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) return [];

    final rows = await client
        .from('notifications')
        .select('id, type, payload, read, created_at')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);

    return (rows as List<dynamic>).map((raw) {
      final map = Map<String, dynamic>.from(raw as Map);
      final payload = map['payload'] as Map<String, dynamic>?;
      return AppNotification(
        id: map['id'] as String,
        type: map['type'] as String,
        read: map['read'] as bool? ?? false,
        createdAt: DateTime.parse(map['created_at'] as String),
        title: payload?['title'] as String?,
        body: payload?['body'] as String?,
        payload: payload,
      );
    }).toList();
  }

  Future<void> markRead(String id) async {
    final client = _client;
    if (client == null) return;
    await client.from('notifications').update({'read': true}).eq('id', id);
  }

  Future<int> unreadCount() async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) return 0;

    final rows = await client
        .from('notifications')
        .select('id')
        .eq('user_id', userId)
        .eq('read', false);

    return (rows as List).length;
  }
}
