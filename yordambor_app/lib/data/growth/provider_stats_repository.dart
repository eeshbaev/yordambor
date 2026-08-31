import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/domain/growth/achievement.dart';
import 'package:yordambor/domain/growth/provider_tier.dart';

class ProviderStatsRepository {
  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<ProviderStats> fetchProviderStats(String userId) async {
    final completedJobs = await countCompletedAsProvider(userId);
    final rating = await aggregateProviderRating(userId);
    return buildProviderStats(
      completedJobs: completedJobs,
      averageRating: rating.avg,
      reviewCount: rating.reviewCount,
    );
  }

  Future<AchievementContext> fetchAchievementContext(String userId) async {
    final client = _client;
    if (client == null) {
      return const AchievementContext(
        xizmatCount: 0,
        completedJobs: 0,
        hasCertificate: false,
        hasFiveStarReview: false,
        maxRepeatClients: 0,
        unansweredReviewCount: 0,
        xizmatWithoutAvailability: 0,
        xizmatWithoutPricing: 0,
        minPortfolioPhotos: 0,
      );
    }

    final xizmatRows = await client
        .from('xizmatlar')
        .select(
          'id, pricing_model, availability_visible, rating_avg, review_count',
        )
        .eq('owner_id', userId);

    final xizmatList = (xizmatRows as List<dynamic>).cast<Map<String, dynamic>>();
    final xizmatIds = xizmatList.map((r) => r['id'] as String).toList();

    var minPortfolio = 999;
    var withoutAvailability = 0;
    var withoutPricing = 0;
    var hasFiveStar = false;

    for (final row in xizmatList) {
      if (row['availability_visible'] != true) withoutAvailability++;
      if (row['pricing_model'] == 'negotiable') withoutPricing++;
      final avg = (row['rating_avg'] as num?)?.toDouble() ?? 0;
      if (avg >= 4.99 && ((row['review_count'] as num?)?.toInt() ?? 0) > 0) {
        hasFiveStar = true;
      }
    }

    if (xizmatIds.isNotEmpty) {
      final portfolioRows = await client
          .from('portfolio_items')
          .select('xizmat_id')
          .inFilter('xizmat_id', xizmatIds);
      final counts = <String, int>{};
      for (final row in portfolioRows as List<dynamic>) {
        final id = (row as Map)['xizmat_id'] as String;
        counts[id] = (counts[id] ?? 0) + 1;
      }
      for (final id in xizmatIds) {
        final c = counts[id] ?? 0;
        if (c < minPortfolio) minPortfolio = c;
      }
    } else {
      minPortfolio = 0;
    }

    final certRows = await client
        .from('profile_certificates')
        .select('id')
        .eq('profile_id', userId)
        .limit(1);
    final hasCert = (certRows as List).isNotEmpty;

    final completedJobs = await countCompletedAsProvider(userId);
    final maxRepeat = await maxRepeatClientsForProvider(userId);

    var unanswered = 0;
    if (xizmatIds.isNotEmpty) {
      final reviewRows = await client
          .from('reviews')
          .select('provider_reply')
          .inFilter('xizmat_id', xizmatIds);
      for (final row in reviewRows as List<dynamic>) {
        final reply = (row as Map)['provider_reply'] as String?;
        if (reply == null || reply.trim().isEmpty) unanswered++;
      }
    }

    return AchievementContext(
      xizmatCount: xizmatList.length,
      completedJobs: completedJobs,
      hasCertificate: hasCert,
      hasFiveStarReview: hasFiveStar,
      maxRepeatClients: maxRepeat,
      unansweredReviewCount: unanswered,
      xizmatWithoutAvailability: withoutAvailability,
      xizmatWithoutPricing: withoutPricing,
      minPortfolioPhotos: minPortfolio == 999 ? 0 : minPortfolio,
    );
  }

  Future<int> countCompletedAsProvider(String userId) async {
    final client = _client;
    if (client == null) return 0;

    final rows = await client
        .from('xizmatlar')
        .select('completed_count')
        .eq('owner_id', userId);

    var total = 0;
    for (final raw in rows as List<dynamic>) {
      total += ((raw as Map)['completed_count'] as num?)?.toInt() ?? 0;
    }
    return total;
  }

  Future<int> maxRepeatClientsForProvider(String userId) async {
    final client = _client;
    if (client == null) return 0;

    final xizmatRows = await client
        .from('xizmatlar')
        .select('id')
        .eq('owner_id', userId);
    final xizmatIds = (xizmatRows as List<dynamic>)
        .map((r) => (r as Map)['id'] as String)
        .toList();
    if (xizmatIds.isEmpty) return 0;

    final rows = await client
        .from('kelishuvlar')
        .select('party_a_id, party_b_id')
        .eq('status', 'bajarildi')
        .inFilter('xizmat_id', xizmatIds);

    final clientCounts = <String, int>{};
    for (final raw in rows as List<dynamic>) {
      final map = raw as Map<String, dynamic>;
      final partyA = map['party_a_id'] as String;
      final partyB = map['party_b_id'] as String;
      final clientId = partyA == userId ? partyB : partyA;
      clientCounts[clientId] = (clientCounts[clientId] ?? 0) + 1;
    }

    if (clientCounts.isEmpty) return 0;
    return clientCounts.values.reduce((a, b) => a > b ? a : b);
  }

  Future<({double avg, int reviewCount})> aggregateProviderRating(
    String userId,
  ) async {
    final client = _client;
    if (client == null) return (avg: 0.0, reviewCount: 0);

    final rows = await client
        .from('xizmatlar')
        .select('rating_avg, review_count')
        .eq('owner_id', userId);

    double weightedSum = 0;
    var totalReviews = 0;
    for (final raw in rows as List<dynamic>) {
      final map = raw as Map<String, dynamic>;
      final count = (map['review_count'] as num?)?.toInt() ?? 0;
      if (count <= 0) continue;
      final avg = (map['rating_avg'] as num?)?.toDouble() ?? 0;
      weightedSum += avg * count;
      totalReviews += count;
    }

    if (totalReviews == 0) return (avg: 0.0, reviewCount: 0);
    return (avg: weightedSum / totalReviews, reviewCount: totalReviews);
  }

  Future<ProviderStats?> fetchPublicProviderStats(String userId) async {
    return fetchProviderStats(userId);
  }
}

String currentPlatformLabel() {
  if (Platform.isIOS) return 'ios';
  if (Platform.isAndroid) return 'android';
  if (Platform.isMacOS) return 'macos';
  if (Platform.isWindows) return 'windows';
  if (Platform.isLinux) return 'linux';
  return 'unknown';
}
