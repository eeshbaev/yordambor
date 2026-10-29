import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/domain/entities/subsector_alert_subscription.dart';

class SubsectorAlertFailure implements Exception {
  SubsectorAlertFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

class SubsectorAlertRepository {
  static const maxSubscriptions = 25;

  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<List<SubsectorAlertSubscription>> fetchMine() async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) return [];

    final rows = await client
        .from('subsector_alert_subscriptions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (rows as List<dynamic>)
        .map((raw) => _map(Map<String, dynamic>.from(raw as Map)))
        .toList();
  }

  Future<SubsectorAlertSubscription> upsert(UpsertSubsectorAlertInput input) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw SubsectorAlertFailure('Kirish talab qilinadi');
    }

    if (!input.alertNewService &&
        !input.alertDiscount &&
        !input.alertHelpPost) {
      throw SubsectorAlertFailure('Kamida bitta bildirishnoma turini tanlang');
    }

    final existing = await client
        .from('subsector_alert_subscriptions')
        .select('id')
        .eq('user_id', userId)
        .eq('category_id', input.categoryId)
        .eq('subcategory_id', input.subcategoryId)
        .eq('provider_type', input.providerType)
        .maybeSingle();

    if (existing == null) {
      final countRows = await client
          .from('subsector_alert_subscriptions')
          .select('id')
          .eq('user_id', userId);
      if ((countRows as List).length >= maxSubscriptions) {
        throw SubsectorAlertFailure('Maksimal $maxSubscriptions ta sozlama');
      }
    }

    final payload = {
      'user_id': userId,
      'category_id': input.categoryId,
      'subcategory_id': input.subcategoryId,
      'provider_type': input.providerType,
      'alert_new_service': input.alertNewService,
      'alert_discount': input.alertDiscount,
      'alert_help_post': input.alertHelpPost,
    };

    final row = await client
        .from('subsector_alert_subscriptions')
        .upsert(payload, onConflict: 'user_id,category_id,subcategory_id,provider_type')
        .select()
        .single();

    return _map(Map<String, dynamic>.from(row));
  }

  /// Sets the alert's switches. With all off it is deleted, unless
  /// [keepWhenOff] (an alert made for a service).
  Future<void> updateFlags({
    required String id,
    required bool alertNewService,
    required bool alertDiscount,
    required bool alertHelpPost,
    bool keepWhenOff = false,
  }) async {
    if (!keepWhenOff && !alertNewService && !alertDiscount && !alertHelpPost) {
      await delete(id);
      return;
    }

    final client = _client;
    if (client == null) return;

    await client.from('subsector_alert_subscriptions').update({
      'alert_new_service': alertNewService,
      'alert_discount': alertDiscount,
      'alert_help_post': alertHelpPost,
    }).eq('id', id);
  }

  Future<void> delete(String id) async {
    final client = _client;
    if (client == null) return;
    await client.from('subsector_alert_subscriptions').delete().eq('id', id);
  }

  SubsectorAlertSubscription _map(Map<String, dynamic> map) =>
      SubsectorAlertSubscription.fromRow(map);
}
