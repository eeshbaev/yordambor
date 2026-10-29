import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/domain/entities/working_hours.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/core/constants/feed_constants.dart';
import 'package:yordambor/core/constants/service_cities.dart';
import 'package:yordambor/core/constants/xizmat_limits.dart';
import 'package:yordambor/core/supabase/postgrest_errors.dart';
import 'package:yordambor/data/categories/category_repository.dart';
import 'package:yordambor/domain/entities/category_item.dart';
import 'package:yordambor/domain/entities/portfolio_item.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/xizmat_availability_mode.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';
import 'package:yordambor/core/l10n/current_strings.dart';

class XizmatFailure implements Exception {
  XizmatFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

class CreateXizmatInput {
  const CreateXizmatInput({
    required this.name,
    required this.providerType,
    required this.categoryId,
    required this.subcategoryId,
    required this.description,
    required this.portfolioImageUrls,
    this.contactPhone,
    this.showContactPhone = false,
    this.pricingModel = XizmatPricingModel.negotiable,
    this.basePrice,
    this.currency = 'UZS',
    this.minDurationMinutes,
    this.availabilityVisible = false,
    this.availabilityMode,
    this.availabilityFrom,
    this.availabilityUntil,
    this.showServicePromise = false,
    this.servicePromise,
    this.serviceCity,
  });

  final String name;
  final String providerType;
  final String categoryId;
  final String subcategoryId;
  final String description;
  final List<String> portfolioImageUrls;
  final String? contactPhone;
  final bool showContactPhone;
  final XizmatPricingModel pricingModel;
  final double? basePrice;
  final String currency;
  final int? minDurationMinutes;
  final bool availabilityVisible;
  final XizmatAvailabilityMode? availabilityMode;
  final DateTime? availabilityFrom;
  final DateTime? availabilityUntil;
  final bool showServicePromise;
  final String? servicePromise;
  final String? serviceCity;
}

class XizmatRepository {
  XizmatRepository(this._categoryRepository);

  final CategoryRepository _categoryRepository;

  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  bool get isAvailable => _client != null;

  Future<List<XizmatFeedItem>> fetchFeed({
    String? categoryId,
    String? subcategoryId,
    required String language,
    int limit = FeedConstants.pageSize,
    int offset = 0,
  }) async {
    final page = await fetchFeedPage(
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      language: language,
      limit: limit,
      offset: offset,
    );
    return page.items;
  }

  Future<FeedPage<XizmatFeedItem>> fetchFeedPage({
    String? categoryId,
    String? subcategoryId,
    String? providerType,
    String? serviceCityId,
    required String language,
    int limit = FeedConstants.pageSize,
    int offset = 0,
  }) async {
    final client = _client;
    if (client == null) {
      return const FeedPage(items: [], hasMore: false, nextOffset: 0);
    }

    var query = client.from('xizmatlar').select('''
          id,
          owner_id,
          name,
          provider_type,
          category_id,
          subcategory_id,
          description,
          rating_avg,
          completed_count,
          availability_visible,
          availability_mode,
          availability_from,
          availability_until,
          show_contact_phone,
          show_profile,
          pricing_model,
          base_price,
          currency_default,
          min_duration_minutes,
          show_service_promise,
          service_promise,
          service_city,
          created_at,
          profiles!xizmatlar_owner_id_fkey (
            full_name,
            avatar_url
          ),
          portfolio_items (
            image_url,
            is_hero,
            sort_order
          )
        ''');

    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    if (subcategoryId != null) {
      query = query.eq('subcategory_id', subcategoryId);
    }
    if (providerType != null) {
      query = query.eq('provider_type', providerType);
    }
    if (serviceCityId != null) {
      query = query.eq('service_city', serviceCityId);
    }

    final rows = await query
        .order('rating_avg', ascending: false)
        .range(offset, offset + limit - 1);

    final rowList = rows as List<dynamic>;
    final categories = await _categoryRepository.loadCategories();
    final items = <XizmatFeedItem>[];

    for (final raw in rowList) {
      final map = Map<String, dynamic>.from(raw as Map);
      final item = _mapRowToFeedItem(
        map,
        categories: categories,
        language: language,
      );
      if (item != null) {
        items.add(item);
      }
    }

    return FeedPage(
      items: items,
      hasMore: rowList.length == limit,
      nextOffset: offset + rowList.length,
    );
  }

  /// The columns a feed card needs.
  static const _cardColumns = '''
          id,
          owner_id,
          name,
          provider_type,
          category_id,
          subcategory_id,
          description,
          rating_avg,
          completed_count,
          availability_visible,
          availability_mode,
          availability_from,
          availability_until,
          show_contact_phone,
          show_profile,
          pricing_model,
          base_price,
          currency_default,
          min_duration_minutes,
          show_service_promise,
          service_promise,
          service_city,
          created_at,
          profiles!xizmatlar_owner_id_fkey (
            full_name,
            avatar_url
          ),
          portfolio_items (
            image_url,
            is_hero,
            sort_order
          )
        ''';

  /// Services whose name contains [query], whose provider or organization
  /// is called so, or whose trade is one of [subcategoryIds] (the trades
  /// whose names match). Best rated first within each kind of match.
  Future<List<XizmatFeedItem>> search(
    String query, {
    required String language,
    Set<String> subcategoryIds = const {},
    int limit = 30,
  }) async {
    final client = _client;
    final text = query.trim();
    if (client == null || text.length < 2) return [];
    final pattern = searchPattern(text);

    final ownerRows = await client
        .from('profiles')
        .select('id')
        .ilike('full_name', pattern)
        .limit(limit);
    final ownerIds = [
      for (final row in ownerRows as List<dynamic>)
        (row as Map)['id'] as String,
    ];

    final results = await Future.wait<dynamic>([
      client
          .from('xizmatlar')
          .select(_cardColumns)
          .ilike('name', pattern)
          .order('rating_avg', ascending: false)
          .limit(limit),
      if (ownerIds.isNotEmpty)
        client
            .from('xizmatlar')
            .select(_cardColumns)
            .inFilter('owner_id', ownerIds)
            .order('rating_avg', ascending: false)
            .limit(limit),
      if (subcategoryIds.isNotEmpty)
        client
            .from('xizmatlar')
            .select(_cardColumns)
            .inFilter('subcategory_id', subcategoryIds.toList())
            .order('rating_avg', ascending: false)
            .limit(limit),
    ]);

    final categories = await _categoryRepository.loadCategories();
    final seen = <String>{};
    final items = <XizmatFeedItem>[];
    for (final rows in results) {
      for (final raw in rows as List<dynamic>) {
        final item = _mapRowToFeedItem(
          Map<String, dynamic>.from(raw as Map),
          categories: categories,
          language: language,
        );
        if (item != null && seen.add(item.id)) items.add(item);
      }
    }
    return items;
  }

  /// An ILIKE pattern for [text] anywhere in a name. Any apostrophe
  /// matches any other ("o'zbek" finds "oʻzbek"): it becomes a
  /// one-character wildcard.
  static String searchPattern(String text) =>
      '%${_likeEscape(text).replaceAll(RegExp("[ʻʼ'`‘’ʹ]"), '_')}%';

  /// [text] as a literal inside an ILIKE pattern.
  static String _likeEscape(String text) => text
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');

  Future<XizmatFeedItem?> fetchById(String id, String language) async {
    final client = _client;
    if (client == null) return null;

    final row = await client.from('xizmatlar').select('''
          id,
          owner_id,
          name,
          provider_type,
          category_id,
          subcategory_id,
          description,
          rating_avg,
          completed_count,
          availability_visible,
          availability_mode,
          availability_from,
          availability_until,
          show_contact_phone,
          show_profile,
          pricing_model,
          base_price,
          currency_default,
          min_duration_minutes,
          show_service_promise,
          service_promise,
          service_city,
          created_at,
          profiles!xizmatlar_owner_id_fkey (
            full_name,
            avatar_url
          ),
          portfolio_items (
            image_url,
            is_hero,
            sort_order
          )
        ''').eq('id', id).maybeSingle();

    if (row == null) return null;

    final map = Map<String, dynamic>.from(row);
    final portfolio = (map['portfolio_items'] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    portfolio.sort((a, b) {
      final aHero = a['is_hero'] == true ? 0 : 1;
      final bHero = b['is_hero'] == true ? 0 : 1;
      if (aHero != bHero) return aHero.compareTo(bHero);
      return ((a['sort_order'] as num?) ?? 0)
          .compareTo((b['sort_order'] as num?) ?? 0);
    });

    final urls = portfolio
        .map((p) => p['image_url'] as String)
        .where((url) => url.isNotEmpty)
        .toList();

    if (urls.isEmpty) return null;

    final categories = await _categoryRepository.loadCategories();
    final categoryIdValue = map['category_id'] as String?;
    final subcategoryIdValue = map['subcategory_id'] as String? ?? '';
    final providerType = map['provider_type'] as String? ?? 'individual';
    final (ownerName, ownerAvatarUrl) = _readOwnerProfile(map);
    final pricing = _readPricing(map);
    final availability = _readAvailability(map);

    return XizmatFeedItem(
      id: map['id'] as String,
      name: map['name'] as String,
      categoryLabel: _categoryLabel(
        categories: categories,
        categoryId: categoryIdValue,
        language: language,
      ),
      subcategoryLabel: _subcategoryLabel(
        categories: categories,
        categoryId: categoryIdValue,
        subcategoryId: subcategoryIdValue,
        providerType: providerType,
        language: language,
      ),
      categoryId: categoryIdValue ?? '',
      subcategoryId: subcategoryIdValue,
      heroImageUrl: urls.first,
      portfolioImageUrls: urls,
      rating: _toDouble(map['rating_avg']),
      completedCount: (map['completed_count'] as num?)?.toInt() ?? 0,
      description: map['description'] as String?,
      providerType: providerType,
      ownerId: map['owner_id'] as String?,
      ownerName: ownerName,
      ownerAvatarUrl: ownerAvatarUrl,
      contactPhone: map['contact_phone'] as String?,
      showContactPhone: map['show_contact_phone'] as bool? ?? false,
      showProfile: map['show_profile'] as bool? ?? true,
      pricingModel: pricing.pricingModel,
      basePrice: pricing.basePrice,
      currency: pricing.currency,
      minDurationMinutes: pricing.minDurationMinutes,
      availabilityVisible: availability.visible,
      availabilityMode: availability.mode,
      availabilityFrom: availability.from,
      availabilityUntil: availability.until,
      showServicePromise: map['show_service_promise'] as bool? ?? false,
      servicePromise: map['service_promise'] as String?,
      serviceCity: _readServiceCity(map['service_city']),
      createdAt: _readCreatedAt(map['created_at']),
    );
  }

  Future<List<XizmatFeedItem>> fetchByOwnerId(
    String ownerId,
    String language,
  ) =>
      fetchMine(ownerId, language);

  Future<List<XizmatFeedItem>> fetchByIds(
    List<String> ids,
    String language,
  ) async {
    if (ids.isEmpty) return [];

    final client = _client;
    if (client == null) return [];

    final rows = await client
        .from('xizmatlar')
        .select('''
          id,
          owner_id,
          name,
          provider_type,
          category_id,
          subcategory_id,
          description,
          rating_avg,
          completed_count,
          availability_visible,
          availability_mode,
          availability_from,
          availability_until,
          show_contact_phone,
          show_profile,
          pricing_model,
          base_price,
          currency_default,
          min_duration_minutes,
          show_service_promise,
          service_promise,
          service_city,
          created_at,
          profiles!xizmatlar_owner_id_fkey (
            full_name,
            avatar_url
          ),
          portfolio_items (
            image_url,
            is_hero,
            sort_order
          )
        ''')
        .inFilter('id', ids);

    final categories = await _categoryRepository.loadCategories();
    final byId = <String, XizmatFeedItem>{};

    for (final raw in rows as List<dynamic>) {
      final item = _mapRowToFeedItem(
        Map<String, dynamic>.from(raw as Map),
        categories: categories,
        language: language,
      );
      if (item != null) {
        byId[item.id] = item;
      }
    }

    return [
      for (final id in ids)
        if (byId.containsKey(id)) byId[id]!,
    ];
  }

  Future<List<XizmatFeedItem>> fetchMine(String ownerId, String language) async {
    final client = _client;
    if (client == null) return [];

    final rows = await client
        .from('xizmatlar')
        .select('''
          id,
          owner_id,
          name,
          provider_type,
          category_id,
          subcategory_id,
          description,
          rating_avg,
          completed_count,
          availability_visible,
          availability_mode,
          availability_from,
          availability_until,
          show_contact_phone,
          show_profile,
          pricing_model,
          base_price,
          currency_default,
          min_duration_minutes,
          show_service_promise,
          service_promise,
          service_city,
          created_at,
          profiles!xizmatlar_owner_id_fkey (
            full_name,
            avatar_url
          ),
          portfolio_items (
            image_url,
            is_hero,
            sort_order
          )
        ''')
        .eq('owner_id', ownerId)
        .order('created_at', ascending: false);

    final categories = await _categoryRepository.loadCategories();
    final items = <XizmatFeedItem>[];

    for (final raw in rows as List<dynamic>) {
      final map = Map<String, dynamic>.from(raw as Map);
      final item = _mapRowToFeedItem(
        map,
        categories: categories,
        language: language,
      );
      if (item != null) {
        items.add(item);
      }
    }

    return items;
  }

  Future<int> countMine(String ownerId) async {
    final client = _client;
    if (client == null) return 0;

    final rows = await client
        .from('xizmatlar')
        .select('id')
        .eq('owner_id', ownerId);

    return (rows as List).length;
  }

  Future<XizmatFeedItem> create(CreateXizmatInput input) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw XizmatFailure(CurrentStrings.value.errSignInRequired);
    }

    if (input.portfolioImageUrls.isEmpty) {
      throw XizmatFailure(CurrentStrings.value.errPhotoRequired);
    }

    final count = await countMine(userId);
    if (count >= XizmatLimits.maxPerAccount) {
      throw XizmatFailure(
        CurrentStrings.value.errMaxServices(XizmatLimits.maxPerAccount),
      );
    }

    final xizmatId = await _insertXizmatShell(input, userId);
    await _attachPortfolio(xizmatId, input.portfolioImageUrls);

    final created = await fetchById(xizmatId, 'uz');
    if (created == null) {
      throw XizmatFailure(CurrentStrings.value.errServiceNotUploaded);
    }
    return created;
  }

  Future<String> createShellForUpload(CreateXizmatInput input) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw XizmatFailure(CurrentStrings.value.errSignInRequired);
    }

    final count = await countMine(userId);
    if (count >= XizmatLimits.maxPerAccount) {
      throw XizmatFailure(
        CurrentStrings.value.errMaxServices(XizmatLimits.maxPerAccount),
      );
    }

    return _insertXizmatShell(input, userId);
  }

  Future<void> attachPortfolio(String xizmatId, List<String> urls) async {
    if (urls.isEmpty) {
      throw XizmatFailure(CurrentStrings.value.errPhotoRequired);
    }
    await _attachPortfolio(xizmatId, urls);
  }

  Future<void> updateXizmat(String xizmatId, UpdateXizmatInput input) async {
    await _assertOwner(xizmatId);
    final client = _client!;

    await client.from('xizmatlar').update({
      'name': input.name.trim(),
      'provider_type': input.providerType,
      'category_id': input.categoryId,
      'subcategory_id': input.subcategoryId,
      'description': input.description.trim().isEmpty
          ? null
          : input.description.trim(),
      if (!input.keepContactPhone) ...{
        'contact_phone': input.contactPhone,
        'show_contact_phone':
            input.showContactPhone && input.contactPhone != null,
      },
      'show_profile': true,
      ..._pricingPayload(
        pricingModel: input.pricingModel,
        basePrice: input.basePrice,
        currency: input.currency,
        minDurationMinutes: input.minDurationMinutes,
      ),
      ..._availabilityPayload(
        visible: input.availabilityVisible,
        mode: input.availabilityMode,
        from: input.availabilityFrom,
        until: input.availabilityUntil,
      ),
      ..._promisePayload(
        show: input.showServicePromise,
        promise: input.servicePromise,
      ),
      ..._cityPayload(input.serviceCity),
    }).eq('id', xizmatId);
  }

  /// Sets only when the service shows as free or busy: [until] is when the
  /// status ends (null: open-ended), starting now.
  Future<void> updateAvailability(
    String xizmatId, {
    required bool visible,
    XizmatAvailabilityMode? mode,
    DateTime? until,
  }) async {
    await _assertOwner(xizmatId);
    await _client!.from('xizmatlar').update(
      _availabilityPayload(
        visible: visible,
        mode: mode,
        from: DateTime.now(),
        until: until,
      ),
    ).eq('id', xizmatId);
  }

  /// Whether clients see the hours the owner's appointments take
  /// (migration 024). False on a server without it.
  Future<bool> fetchShowBusyHours(String xizmatId) async {
    final client = _client;
    if (client == null) return false;
    try {
      final row = await client
          .from('xizmatlar')
          .select('show_busy_hours')
          .eq('id', xizmatId)
          .maybeSingle();
      return row?['show_busy_hours'] as bool? ?? false;
    } on PostgrestException {
      return false;
    }
  }

  Future<void> setShowBusyHours(String xizmatId, bool show) async {
    await _assertOwner(xizmatId);
    await _client!
        .from('xizmatlar')
        .update({'show_busy_hours': show})
        .eq('id', xizmatId);
  }

  /// The hours the service's provider is taken by agreed appointments,
  /// day by day from [from] to [to]; empty unless they chose to show them.
  /// Only the times come back, nothing else about the deals.
  Future<Map<DateTime, List<TimeRange>>> fetchBusyHours({
    required String xizmatId,
    required DateTime from,
    required DateTime to,
  }) async {
    final client = _client;
    if (client == null || xizmatId.startsWith('demo-')) return const {};
    String day(DateTime value) => value.toIso8601String().split('T').first;
    int? minutes(Object? raw) {
      final parts = '${raw ?? ''}'.split(':');
      if (parts.length < 2) return null;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) return null;
      return hour * 60 + minute;
    }

    final List<dynamic> rows;
    try {
      rows = await client.rpc<List<dynamic>>(
        'get_xizmat_busy_hours',
        params: {'p_xizmat': xizmatId, 'p_from': day(from), 'p_to': day(to)},
      );
    } on PostgrestException catch (error) {
      if (isMissingRpc(error)) return const {};
      rethrow;
    }

    final byDay = <DateTime, List<TimeRange>>{};
    for (final raw in rows) {
      final row = Map<String, dynamic>.from(raw as Map);
      final date = DateTime.tryParse('${row['day']}');
      final start = minutes(row['starts']);
      var end = minutes(row['ends']);
      if (date == null || start == null || end == null) continue;
      // The server caps a range at 23:59; it means the end of the day.
      if (end == 23 * 60 + 59) end = 24 * 60;
      final range = TimeRange(start, end);
      if (!range.isValid) continue;
      byDay
          .putIfAbsent(DateTime(date.year, date.month, date.day), () => [])
          .add(range);
    }
    return byDay;
  }

  /// The contact phone on one of your own listings, for editing it. Only
  /// its owner may read it (migration 023); a server without that yet is
  /// read directly.
  Future<String?> fetchMyContactPhone(String xizmatId) async {
    final client = _client;
    if (client == null) return null;
    try {
      final phone = await client.rpc<dynamic>(
        'get_my_xizmat_contact_phone',
        params: {'p_xizmat_id': xizmatId},
      );
      return phone is String && phone.isNotEmpty ? phone : null;
    } on PostgrestException catch (error) {
      if (!isMissingRpc(error)) rethrow;
      final row = await client
          .from('xizmatlar')
          .select('contact_phone')
          .eq('id', xizmatId)
          .maybeSingle();
      return row?['contact_phone'] as String?;
    }
  }

  Future<List<PortfolioItem>> fetchPortfolioItems(String xizmatId) async {
    final client = _client;
    if (client == null) return [];

    final rows = await client
        .from('portfolio_items')
        .select('id, xizmat_id, image_url, caption, is_hero, sort_order')
        .eq('xizmat_id', xizmatId)
        .order('sort_order', ascending: true);

    return (rows as List<dynamic>).map((raw) {
      final map = Map<String, dynamic>.from(raw as Map);
      return PortfolioItem(
        id: map['id'] as String,
        xizmatId: map['xizmat_id'] as String,
        imageUrl: map['image_url'] as String,
        isHero: map['is_hero'] as bool? ?? false,
        sortOrder: (map['sort_order'] as num?)?.toInt() ?? 0,
        caption: map['caption'] as String?,
      );
    }).toList();
  }

  Future<void> addPortfolioItem(String xizmatId, String imageUrl) async {
    await _assertOwner(xizmatId);
    final client = _client!;

    final rows = await client
        .from('portfolio_items')
        .select('sort_order')
        .eq('xizmat_id', xizmatId);

    final nextOrder = (rows as List).length;
    final isFirst = nextOrder == 0;

    await client.from('portfolio_items').insert({
      'xizmat_id': xizmatId,
      'image_url': imageUrl,
      'is_hero': isFirst,
      'sort_order': nextOrder,
    });
  }

  Future<void> removePortfolioItem(String xizmatId, String itemId) async {
    await _assertOwner(xizmatId);
    final client = _client!;

    final rows = await client
        .from('portfolio_items')
        .select('id')
        .eq('xizmat_id', xizmatId);

    if ((rows as List).length <= 1) {
      throw XizmatFailure(CurrentStrings.value.errKeepOnePhoto);
    }

    final item = await client
        .from('portfolio_items')
        .select('is_hero')
        .eq('id', itemId)
        .maybeSingle();

    await client.from('portfolio_items').delete().eq('id', itemId);

    if (item?['is_hero'] == true) {
      final remaining = await fetchPortfolioItems(xizmatId);
      if (remaining.isNotEmpty) {
        await setHeroPortfolioItem(xizmatId, remaining.first.id);
      }
    }
  }

  Future<void> setHeroPortfolioItem(String xizmatId, String itemId) async {
    await _assertOwner(xizmatId);
    final client = _client!;

    await client
        .from('portfolio_items')
        .update({'is_hero': false})
        .eq('xizmat_id', xizmatId);

    await client
        .from('portfolio_items')
        .update({'is_hero': true})
        .eq('id', itemId);
  }

  Future<void> _assertOwner(String xizmatId) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw XizmatFailure(CurrentStrings.value.errSignInRequired);
    }

    final existing = await client
        .from('xizmatlar')
        .select('owner_id')
        .eq('id', xizmatId)
        .maybeSingle();

    if (existing == null || existing['owner_id'] != userId) {
      throw XizmatFailure(CurrentStrings.value.errNoPermission);
    }
  }

  Future<String> _insertXizmatShell(CreateXizmatInput input, String userId) async {
    final client = _client!;
    final inserted = await client
        .from('xizmatlar')
        .insert({
          'owner_id': userId,
          'name': input.name.trim(),
          'provider_type': input.providerType,
          'category_id': input.categoryId,
          'subcategory_id': input.subcategoryId,
          'description': input.description.trim().isEmpty
              ? null
              : input.description.trim(),
          'contact_phone': input.contactPhone,
          'show_contact_phone':
              input.showContactPhone && input.contactPhone != null,
          'show_profile': true,
          ..._pricingPayload(
            pricingModel: input.pricingModel,
            basePrice: input.basePrice,
            currency: input.currency,
            minDurationMinutes: input.minDurationMinutes,
          ),
          ..._availabilityPayload(
            visible: input.availabilityVisible,
            mode: input.availabilityMode,
            from: input.availabilityFrom,
            until: input.availabilityUntil,
          ),
          ..._promisePayload(
            show: input.showServicePromise,
            promise: input.servicePromise,
          ),
          ..._cityPayload(input.serviceCity),
        })
        .select('id')
        .single();

    return inserted['id'] as String;
  }

  Future<void> _attachPortfolio(String xizmatId, List<String> urls) async {
    final client = _client!;
    for (var i = 0; i < urls.length; i++) {
      await client.from('portfolio_items').insert({
        'xizmat_id': xizmatId,
        'image_url': urls[i],
        'is_hero': i == 0,
        'sort_order': i,
      });
    }
  }

  Future<XizmatFeedItem?> finalizeCreated(String xizmatId, String language) {
    return fetchById(xizmatId, language);
  }

  String _categoryLabel({
    required List<CategoryItem> categories,
    required String? categoryId,
    required String language,
  }) {
    for (final category in categories) {
      if (category.id == categoryId) return category.label(language);
    }
    return categoryId ?? '';
  }

  String _subcategoryLabel({
    required List<CategoryItem> categories,
    required String? categoryId,
    required String subcategoryId,
    required String providerType,
    required String language,
  }) {
    for (final category in categories) {
      if (category.id != categoryId) continue;
      for (final sub in category.subcategories) {
        if (sub.id == subcategoryId && sub.providerType == providerType) {
          return sub.label(language);
        }
      }
      for (final sub in category.subcategories) {
        if (sub.id == subcategoryId) return sub.label(language);
      }
    }
    return subcategoryId;
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse('$value') ?? 0;
  }

  (String?, String?) _readOwnerProfile(Map<String, dynamic> map) {
    final raw = map['profiles'];
    if (raw is Map) {
      final profile = Map<String, dynamic>.from(raw);
      return (
        profile['full_name'] as String?,
        profile['avatar_url'] as String?,
      );
    }
    return (null, null);
  }

  ({
    XizmatPricingModel pricingModel,
    double? basePrice,
    String currency,
    int? minDurationMinutes,
  }) _readPricing(Map<String, dynamic> map) {
    return (
      pricingModel:
          XizmatPricingModel.fromDb(map['pricing_model'] as String?),
      basePrice: (map['base_price'] as num?)?.toDouble(),
      currency: map['currency_default'] as String? ?? 'UZS',
      minDurationMinutes: (map['min_duration_minutes'] as num?)?.toInt(),
    );
  }

  XizmatFeedItem? _mapRowToFeedItem(
    Map<String, dynamic> map, {
    required List<CategoryItem> categories,
    required String language,
  }) {
    final portfolio = (map['portfolio_items'] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    portfolio.sort((a, b) {
      final aHero = a['is_hero'] == true ? 0 : 1;
      final bHero = b['is_hero'] == true ? 0 : 1;
      if (aHero != bHero) return aHero.compareTo(bHero);
      return ((a['sort_order'] as num?) ?? 0)
          .compareTo((b['sort_order'] as num?) ?? 0);
    });

    final urls = portfolio
        .map((p) => p['image_url'] as String)
        .where((url) => url.isNotEmpty)
        .toList();

    final categoryIdValue = map['category_id'] as String?;
    final subcategoryIdValue = map['subcategory_id'] as String? ?? '';
    final providerType = map['provider_type'] as String? ?? 'individual';
    final (ownerName, ownerAvatarUrl) = _readOwnerProfile(map);
    final pricing = _readPricing(map);
    final availability = _readAvailability(map);

    return XizmatFeedItem(
      id: map['id'] as String,
      name: map['name'] as String,
      categoryLabel: _categoryLabel(
        categories: categories,
        categoryId: categoryIdValue,
        language: language,
      ),
      subcategoryLabel: _subcategoryLabel(
        categories: categories,
        categoryId: categoryIdValue,
        subcategoryId: subcategoryIdValue,
        providerType: providerType,
        language: language,
      ),
      categoryId: categoryIdValue ?? '',
      subcategoryId: subcategoryIdValue,
      heroImageUrl: urls.isNotEmpty ? urls.first : '',
      portfolioImageUrls: urls,
      rating: _toDouble(map['rating_avg']),
      completedCount: (map['completed_count'] as num?)?.toInt() ?? 0,
      description: map['description'] as String?,
      providerType: providerType,
      ownerId: map['owner_id'] as String?,
      ownerName: ownerName,
      ownerAvatarUrl: ownerAvatarUrl,
      contactPhone: map['contact_phone'] as String?,
      showContactPhone: map['show_contact_phone'] as bool? ?? false,
      showProfile: map['show_profile'] as bool? ?? true,
      pricingModel: pricing.pricingModel,
      basePrice: pricing.basePrice,
      currency: pricing.currency,
      minDurationMinutes: pricing.minDurationMinutes,
      availabilityVisible: availability.visible,
      availabilityMode: availability.mode,
      availabilityFrom: availability.from,
      availabilityUntil: availability.until,
      showServicePromise: map['show_service_promise'] as bool? ?? false,
      servicePromise: map['service_promise'] as String?,
      serviceCity: _readServiceCity(map['service_city']),
      createdAt: _readCreatedAt(map['created_at']),
    );
  }

  Map<String, dynamic> _pricingPayload({
    required XizmatPricingModel pricingModel,
    double? basePrice,
    String currency = 'UZS',
    int? minDurationMinutes,
  }) {
    if (pricingModel == XizmatPricingModel.negotiable) {
      return {
        'pricing_model': 'negotiable',
        'base_price': null,
        'currency_default': currency,
        'min_duration_minutes': null,
      };
    }

    return {
      'pricing_model': pricingModel.toDb(),
      'base_price': basePrice,
      'currency_default': currency,
      'min_duration_minutes': pricingModel == XizmatPricingModel.hourly
          ? minDurationMinutes
          : null,
    };
  }

  ({
    bool visible,
    XizmatAvailabilityMode? mode,
    DateTime? from,
    DateTime? until,
  }) _readAvailability(Map<String, dynamic> map) {
    return (
      visible: map['availability_visible'] as bool? ?? false,
      mode: XizmatAvailabilityMode.fromDb(
        map['availability_mode'] as String?,
      ),
      from: _parseDateTime(map['availability_from']),
      until: _parseDateTime(map['availability_until']),
    );
  }

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value.toLocal();
    return DateTime.tryParse(value.toString())?.toLocal();
  }

  Map<String, dynamic> _availabilityPayload({
    required bool visible,
    XizmatAvailabilityMode? mode,
    DateTime? from,
    DateTime? until,
  }) {
    if (!visible || mode == null) {
      return {
        'availability_visible': false,
        'availability_mode': null,
        'availability_from': null,
        'availability_until': null,
      };
    }

    final includeWindow = mode != XizmatAvailabilityMode.callMe;

    return {
      'availability_visible': true,
      'availability_mode': mode.toDb(),
      'availability_from': includeWindow ? from?.toUtc().toIso8601String() : null,
      'availability_until':
          includeWindow ? until?.toUtc().toIso8601String() : null,
    };
  }

  Map<String, dynamic> _promisePayload({
    required bool show,
    String? promise,
  }) {
    final normalized = promise?.trim();
    final hasText = normalized != null && normalized.isNotEmpty;

    return {
      'show_service_promise': show && hasText,
      'service_promise': hasText ? normalized : null,
    };
  }

  Map<String, dynamic> _cityPayload(String? city) {
    final id = ServiceCities.normalizeStored(city);
    return {
      'service_city': ServiceCities.isValidId(id) ? id : null,
    };
  }


  String? _readServiceCity(Object? raw) =>
      ServiceCities.normalizeStored(raw as String?);

  DateTime? _readCreatedAt(Object? raw) =>
      raw is String ? DateTime.tryParse(raw) : null;
}
