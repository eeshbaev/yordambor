import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/data/demo/demo_reviews.dart';
import 'package:yordambor/domain/entities/review.dart';

class ReviewFailure implements Exception {
  ReviewFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

class ReviewRepository {
  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<List<Review>> fetchForXizmat(String xizmatId) async {
    if (xizmatId.startsWith('demo-')) {
      return DemoReviews.forXizmat(xizmatId);
    }

    final client = _client;
    if (client == null) return [];

    final rows = await client
        .from('reviews')
        .select('''
          id,
          kelishuv_id,
          xizmat_id,
          rating,
          comment,
          provider_reply,
          created_at,
          profiles!reviews_reviewer_id_fkey ( full_name )
        ''')
        .eq('xizmat_id', xizmatId)
        .order('created_at', ascending: false)
        .limit(20);

    return (rows as List<dynamic>).map((raw) {
      final map = Map<String, dynamic>.from(raw as Map);
      final profile = map['profiles'] as Map<String, dynamic>?;
      return Review(
        id: map['id'] as String,
        kelishuvId: map['kelishuv_id'] as String?,
        xizmatId: map['xizmat_id'] as String,
        rating: (map['rating'] as num).toInt(),
        comment: map['comment'] as String?,
        providerReply: map['provider_reply'] as String?,
        reviewerName: profile?['full_name'] as String?,
        createdAt: map['created_at'] != null
            ? DateTime.tryParse(map['created_at'] as String)
            : null,
      );
    }).toList();
  }

  Future<Review?> fetchForKelishuv(String kelishuvId) async {
    final client = _client;
    if (client == null) return null;

    final row = await client
        .from('reviews')
        .select('id, kelishuv_id, xizmat_id, rating, comment')
        .eq('kelishuv_id', kelishuvId)
        .maybeSingle();

    if (row == null) return null;
    final map = Map<String, dynamic>.from(row);
    return Review(
      id: map['id'] as String,
      kelishuvId: map['kelishuv_id'] as String?,
      xizmatId: map['xizmat_id'] as String,
      rating: (map['rating'] as num).toInt(),
      comment: map['comment'] as String?,
    );
  }

  Future<Review> create(CreateReviewInput input) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw ReviewFailure('Kirish talab qilinadi');
    }

    if (input.rating < 1 || input.rating > 5) {
      throw ReviewFailure('Baho 1 dan 5 gacha bo\'lishi kerak');
    }

    final existing = await fetchForKelishuv(input.kelishuvId);
    if (existing != null) {
      throw ReviewFailure('Bu kelishuv uchun baho allaqachon qoldirilgan');
    }

    final inserted = await client
        .from('reviews')
        .insert({
          'kelishuv_id': input.kelishuvId,
          'xizmat_id': input.xizmatId,
          'reviewer_id': userId,
          'rating': input.rating,
          'comment': input.comment?.trim().isEmpty ?? true
              ? null
              : input.comment!.trim(),
        })
        .select('id, kelishuv_id, xizmat_id, rating, comment, created_at')
        .single();

    await _refreshXizmatRating(input.xizmatId);

    final map = Map<String, dynamic>.from(inserted);
    return Review(
      id: map['id'] as String,
      kelishuvId: map['kelishuv_id'] as String?,
      xizmatId: map['xizmat_id'] as String,
      rating: (map['rating'] as num).toInt(),
      comment: map['comment'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
    );
  }

  Future<void> setProviderReply(String reviewId, String reply) async {
    if (reviewId.startsWith('demo-review-')) return;

    final client = _client;
    if (client == null) throw ReviewFailure('Supabase sozlanmagan');

    final trimmed = reply.trim();
    await client.from('reviews').update({
      'provider_reply': trimmed.isEmpty ? null : trimmed,
    }).eq('id', reviewId);
  }

  Future<void> _refreshXizmatRating(String xizmatId) async {
    final client = _client;
    if (client == null) return;

    final rows = await client
        .from('reviews')
        .select('rating')
        .eq('xizmat_id', xizmatId);

    final ratings = (rows as List<dynamic>)
        .map((row) => (row as Map<String, dynamic>)['rating'] as num)
        .toList();

    if (ratings.isEmpty) return;

    final avg = ratings.fold<double>(0, (sum, r) => sum + r.toDouble()) /
        ratings.length;

    await client.from('xizmatlar').update({
      'rating_avg': double.parse(avg.toStringAsFixed(2)),
      'review_count': ratings.length,
    }).eq('id', xizmatId);
  }
}
