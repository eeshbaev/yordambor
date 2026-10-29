import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/core/constants/feed_constants.dart';
import 'package:yordambor/core/constants/service_cities.dart';
import 'package:yordambor/data/categories/category_repository.dart';
import 'package:yordambor/domain/entities/category_item.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';
import 'package:yordambor/domain/entities/yordam_kerak_post.dart';

class YordamKerakFailure implements Exception {
  YordamKerakFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

class CreateYordamKerakInput {
  const CreateYordamKerakInput({
    required this.title,
    this.message,
    this.price,
    this.pricingModel = XizmatPricingModel.negotiable,
    this.currency,
    this.categoryId,
    this.subcategoryId,
    this.startDate,
    this.durationMinutes,
    this.contactPhone,
    this.showContactPhone = false,
    this.serviceCity,
  });

  final String title;
  final String? message;
  final double? price;

  /// How [price] is meant; negotiable requests have none.
  final XizmatPricingModel pricingModel;
  final String? currency;
  final String? categoryId;
  final String? subcategoryId;
  final DateTime? startDate;
  final int? durationMinutes;
  final String? contactPhone;
  final bool showContactPhone;

  /// Where the help is needed: a [ServiceCityIds] value. Required.
  final String? serviceCity;
}

class YordamKerakRepository {
  YordamKerakRepository(this._categoryRepository);

  final CategoryRepository _categoryRepository;

  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<List<YordamKerakFeedItem>> fetchOpenPosts({
    String? categoryId,
    String? subcategoryId,
    String? serviceCityId,
    required String language,
    int limit = FeedConstants.pageSize,
    int offset = 0,
  }) async {
    final page = await fetchOpenPostsPage(
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      serviceCityId: serviceCityId,
      language: language,
      limit: limit,
      offset: offset,
    );
    return page.items;
  }

  Future<FeedPage<YordamKerakFeedItem>> fetchOpenPostsPage({
    String? categoryId,
    String? subcategoryId,
    String? serviceCityId,
    required String language,
    int limit = FeedConstants.pageSize,
    int offset = 0,
  }) async {
    final client = _client;
    if (client == null) {
      return const FeedPage(items: [], hasMore: false, nextOffset: 0);
    }

    final rows = await _withColumnFallback(() {
      var query = client
          .from('yordam_kerak_posts')
          .select(_columns())
          .eq('status', 'open');

      if (categoryId != null) query = query.eq('category_id', categoryId);
      if (subcategoryId != null) {
        query = query.eq('subcategory_id', subcategoryId);
      }
      if (serviceCityId != null && !_cityColumnMissing) {
        query = query.eq('service_city', serviceCityId);
      }

      return query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);
    });
    final rowList = rows as List<dynamic>;
    final categories = await _categoryRepository.loadCategories();

    final items = rowList.map((raw) {
      final map = Map<String, dynamic>.from(raw as Map);
      final profile = map['profiles'] as Map<String, dynamic>?;
      return _mapRow(map, profile, categories, language);
    }).toList();

    return FeedPage(
      items: items,
      hasMore: rowList.length == limit,
      nextOffset: offset + rowList.length,
    );
  }

  Future<YordamKerakFeedItem> create(CreateYordamKerakInput input) async {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      throw YordamKerakFailure('Kirish talab qilinadi');
    }

    if (input.title.trim().length < 3) {
      throw YordamKerakFailure('Sarlavha kamida 3 ta belgidan iborat boʻlsin');
    }

    final message = input.message?.trim() ?? '';
    if (message.length < 10) {
      throw YordamKerakFailure(
        'Loyiha tavsifi kamida 10 ta belgidan iborat boʻlsin',
      );
    }

    if (input.categoryId == null || input.categoryId!.isEmpty) {
      throw YordamKerakFailure('Sohani tanlang');
    }

    if (input.subcategoryId == null || input.subcategoryId!.isEmpty) {
      throw YordamKerakFailure('Subsohani tanlang');
    }

    final serviceCity = input.serviceCity;
    if (!ServiceCities.isValidId(serviceCity)) {
      throw YordamKerakFailure('Shaharni tanlang');
    }

    final price = input.pricingModel.hasAmount ? input.price : null;
    final inserted = await _withColumnFallback(
      () => client
          .from('yordam_kerak_posts')
          .insert({
            'author_id': userId,
            'title': input.title.trim(),
            'message': message,
            'price': price,
            'currency': price != null ? (input.currency ?? 'UZS') : null,
            if (!_pricingColumnMissing)
              'pricing_model': price != null
                  ? input.pricingModel.toDb()
                  : XizmatPricingModel.negotiable.toDb(),
            'category_id': input.categoryId,
            'subcategory_id': input.subcategoryId,
            'start_date': input.startDate?.toIso8601String().split('T').first,
            'duration_minutes': input.durationMinutes,
            'status': 'open',
            'contact_phone': input.contactPhone,
            'show_contact_phone':
                input.showContactPhone && input.contactPhone != null,
            'show_profile': true,
            if (!_cityColumnMissing) 'service_city': serviceCity,
          })
          .select(_columns())
          .single(),
    );

    final map = Map<String, dynamic>.from(inserted);
    final profile = map['profiles'] as Map<String, dynamic>?;
    final categories = await _categoryRepository.loadCategories();
    // Until the server keeps the city and price unit, the new post still
    // shows the ones the person chose.
    map['service_city'] ??= serviceCity;
    if (price != null) map['pricing_model'] ??= input.pricingModel.toDb();
    return _mapRow(map, profile, categories, 'uz');
  }

  Future<YordamKerakFeedItem?> fetchById({
    required String id,
    required String language,
  }) async {
    final client = _client;
    if (client == null) return null;

    final rows = await _withColumnFallback(
      () => client
          .from('yordam_kerak_posts')
          .select(_columns())
          .eq('id', id)
          .maybeSingle(),
    );

    if (rows == null) return null;

    final map = Map<String, dynamic>.from(rows);
    final profile = map['profiles'] as Map<String, dynamic>?;
    final categories = await _categoryRepository.loadCategories();
    return _mapRow(map, profile, categories, language);
  }

  Future<List<YordamKerakFeedItem>> fetchOpenPostsByAuthor({
    required String authorId,
    required String language,
  }) async {
    final client = _client;
    if (client == null) return [];

    final rows = await _withColumnFallback(
      () => client
          .from('yordam_kerak_posts')
          .select(_columns())
          .eq('author_id', authorId)
          .eq('status', 'open')
          .order('created_at', ascending: false),
    );

    final categories = await _categoryRepository.loadCategories();
    return (rows as List<dynamic>).map((raw) {
      final map = Map<String, dynamic>.from(raw as Map);
      final profile = map['profiles'] as Map<String, dynamic>?;
      return _mapRow(map, profile, categories, language);
    }).toList();
  }

  YordamKerakFeedItem _mapRow(
    Map<String, dynamic> map,
    Map<String, dynamic>? profile,
    List<CategoryItem> categories,
    String language,
  ) {
    final categoryId = map['category_id'] as String?;
    final subcategoryId = map['subcategory_id'] as String? ?? '';
    final startDateRaw = map['start_date'] as String?;

    return YordamKerakFeedItem(
      id: map['id'] as String,
      authorId: map['author_id'] as String?,
      title: map['title'] as String,
      message: map['message'] as String?,
      price: (map['price'] as num?)?.toDouble(),
      pricingModel: XizmatPricingModel.fromDb(map['pricing_model'] as String?),
      currency: map['currency'] as String?,
      startDate: startDateRaw != null ? DateTime.tryParse(startDateRaw) : null,
      durationMinutes: (map['duration_minutes'] as num?)?.toInt(),
      categoryId: categoryId ?? '',
      subcategoryId: subcategoryId,
      categoryLabel: _categoryLabel(categories, categoryId, language),
      subcategoryLabel: _subcategoryLabel(
        categories,
        categoryId,
        subcategoryId,
        language,
      ),
      authorName: profile?['full_name'] as String? ?? 'Foydalanuvchi',
      contactPhone: map['contact_phone'] as String?,
      showContactPhone: map['show_contact_phone'] as bool? ?? false,
      showProfile: map['show_profile'] as bool? ?? true,
      serviceCity: ServiceCities.normalizeStored(
        map['service_city'] as String?,
      ),
    );
  }

  /// The post columns, with the city and price unit while the server has
  /// them.
  /// What a request shows. Its contact phone is not readable (migration
  /// 023).
  static String _columns() => '''
          id,
          author_id,
          title,
          message,
          price,
          ${_pricingColumnMissing ? '' : 'pricing_model,'}
          currency,
          start_date,
          duration_minutes,
          category_id,
          subcategory_id,
          created_at,
          show_contact_phone,
          show_profile,
          ${_cityColumnMissing ? '' : 'service_city,'}
          profiles!yordam_kerak_posts_author_id_fkey (
            full_name
          )
        ''';

  /// True once the server answers that `service_city` does not exist yet
  /// (migration 020 not applied), so later calls stop asking for it.
  static bool _cityColumnMissing = false;

  /// The same for `pricing_model` (migration 024).
  static bool _pricingColumnMissing = false;

  /// Runs [run]; each time the server lacks the city or price-unit column,
  /// notes that and runs it again without it, so posts still load and save.
  Future<T> _withColumnFallback<T>(Future<T> Function() run) async {
    while (true) {
      try {
        return await run();
      } on PostgrestException catch (error) {
        if (!_cityColumnMissing && error.message.contains('service_city')) {
          _cityColumnMissing = true;
        } else if (!_pricingColumnMissing &&
            error.message.contains('pricing_model')) {
          _pricingColumnMissing = true;
        } else {
          rethrow;
        }
      }
    }
  }

  String _categoryLabel(
    List<CategoryItem> categories,
    String? categoryId,
    String language,
  ) {
    if (categoryId == null) return '';
    for (final category in categories) {
      if (category.id == categoryId) return category.label(language);
    }
    return categoryId;
  }

  String _subcategoryLabel(
    List<CategoryItem> categories,
    String? categoryId,
    String subcategoryId,
    String language,
  ) {
    if (categoryId == null) return subcategoryId;
    for (final category in categories) {
      if (category.id != categoryId) continue;
      for (final sub in category.subcategories) {
        if (sub.id == subcategoryId) return sub.label(language);
      }
    }
    return subcategoryId;
  }
}
