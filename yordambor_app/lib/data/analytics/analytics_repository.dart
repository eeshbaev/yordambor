import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';

class XizmatAnalytics {
  const XizmatAnalytics({
    required this.viewCount,
    required this.favoriteCount,
    required this.incomingDeals,
    required this.completedDeals,
  });

  final int viewCount;
  final int favoriteCount;
  final int incomingDeals;
  final int completedDeals;

  double get conversionRate =>
      viewCount == 0 ? 0 : (incomingDeals / viewCount) * 100;
}

class AnalyticsRepository {
  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<void> recordView(String xizmatId) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || xizmatId.startsWith('demo-')) return;

    await client.from('analytics_events').insert({
      'xizmat_id': xizmatId,
      'event_type': 'view',
      'user_id': userId,
    });
  }

  Future<XizmatAnalytics> fetchForXizmat(String xizmatId) async {
    final client = _client;
    if (client == null || xizmatId.startsWith('demo-')) {
      return const XizmatAnalytics(
        viewCount: 0,
        favoriteCount: 0,
        incomingDeals: 0,
        completedDeals: 0,
      );
    }

    final views = await client
        .from('analytics_events')
        .select('id')
        .eq('xizmat_id', xizmatId)
        .eq('event_type', 'view');

    final favorites = await client
        .from('favorites')
        .select('user_id')
        .eq('xizmat_id', xizmatId);

    final deals = await client
        .from('kelishuvlar')
        .select('status')
        .eq('xizmat_id', xizmatId);

    var incoming = 0;
    var completed = 0;
    for (final raw in deals as List<dynamic>) {
      final status = (raw as Map<String, dynamic>)['status'] as String;
      if (status == 'muzokarada' || status == 'jarayonda') incoming++;
      if (status == 'bajarildi') completed++;
    }

    return XizmatAnalytics(
      viewCount: (views as List).length,
      favoriteCount: (favorites as List).length,
      incomingDeals: incoming,
      completedDeals: completed,
    );
  }
}
