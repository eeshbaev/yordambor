import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yordambor/core/config/env.dart';
import 'package:yordambor/core/constants/feed_constants.dart';
import 'package:yordambor/data/categories/category_repository.dart';
import 'package:yordambor/domain/entities/category_item.dart';
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
    this.currency,
    this.categoryId,
    this.subcategoryId,
    this.startDate,
    this.durationMinutes,
    this.contactPhone,
    this.showContactPhone = false,
  });

  final String title;
  final String? message;
  final double? price;
  final String? currency;
  final String? categoryId;
  final String? subcategoryId;
  final DateTime? startDate;
  final int? durationMinutes;
  final String? contactPhone;
  final bool showContactPhone;
}

class YordamKerakRepository {
  YordamKerakRepository(this._categoryRepository);

  final CategoryRepository _categoryRepository;

  SupabaseClient? get _client =>
      Env.isConfigured ? Supabase.instance.client : null;

  Future<List<YordamKerakFeedItem>> fetchOpenPosts({
    String? categoryId,
    String? subcategoryId,
    required String language,
    int limit = FeedConstants.pageSize,
    int offset = 0,
  }) async {
    final page = await fetchOpenPostsPage(
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      language: language,
      limit: limit,
      offset: offset,
    );
    return page.items;
  }

  Future<FeedPage<YordamKerakFeedItem>> fetchOpenPostsPage({
    String? categoryId,
    String? subcategoryId,
    required String language,
    int limit = FeedConstants.pageSize,
    int offset = 0,
  }) async {
    final client = _client;
    if (client == null) {
      return const FeedPage(items: [], hasMore: false, nextOffset: 0);
    }

    var query = client.from('yordam_kerak_posts').select('''
          id,
          author_id,
          title,
          message,
          price,
          currency,
          start_date,
          duration_minutes,
          category_id,
          subcategory_id,
          created_at,
          contact_phone,
          show_contact_phone,
          show_profile,
          profiles!yordam_kerak_posts_author_id_fkey (
            full_name
          )
        ''').eq('status', 'open');

    if (categoryId != null) query = query.eq('category_id', categoryId);
    if (subcategoryId != null) {
      query = query.eq('subcategory_id', subcategoryId);
    }

    final rows = await query
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
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
      throw YordamKerakFailure('Sarlavha kamida 3 ta belgidan iborat bo\'lsin');
    }

    final message = input.message?.trim() ?? '';
    if (message.length < 10) {
      throw YordamKerakFailure(
        'Loyiha tavsifi kamida 10 ta belgidan iborat bo\'lsin',
      );
    }

    if (input.categoryId == null || input.categoryId!.isEmpty) {
      throw YordamKerakFailure('Sohani tanlang');
    }

    if (input.subcategoryId == null || input.subcategoryId!.isEmpty) {
      throw YordamKerakFailure('Subsohani tanlang');
    }

    final inserted = await client
        .from('yordam_kerak_posts')
        .insert({
          'author_id': userId,
          'title': input.title.trim(),
          'message': message,
          'price': input.price,
          'currency': input.price != null ? (input.currency ?? 'UZS') : null,
          'category_id': input.categoryId,
          'subcategory_id': input.subcategoryId,
          'start_date': input.startDate?.toIso8601String().split('T').first,
          'duration_minutes': input.durationMinutes,
          'status': 'open',
          'contact_phone': input.contactPhone,
          'show_contact_phone':
              input.showContactPhone && input.contactPhone != null,
          'show_profile': true,
        })
        .select('''
          id,
          author_id,
          title,
          message,
          price,
          currency,
          start_date,
          duration_minutes,
          category_id,
          subcategory_id,
          created_at,
          contact_phone,
          show_contact_phone,
          show_profile,
          profiles!yordam_kerak_posts_author_id_fkey (
            full_name
          )
        ''')
        .single();

    final map = Map<String, dynamic>.from(inserted);
    final profile = map['profiles'] as Map<String, dynamic>?;
    final categories = await _categoryRepository.loadCategories();
    return _mapRow(map, profile, categories, 'uz'    );
  }

  Future<YordamKerakFeedItem?> fetchById({
    required String id,
    required String language,
  }) async {
    final client = _client;
    if (client == null) return null;

    final rows = await client.from('yordam_kerak_posts').select('''
          id,
          author_id,
          title,
          message,
          price,
          currency,
          start_date,
          duration_minutes,
          category_id,
          subcategory_id,
          created_at,
          contact_phone,
          show_contact_phone,
          show_profile,
          profiles!yordam_kerak_posts_author_id_fkey (
            full_name
          )
        ''').eq('id', id).maybeSingle();

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

    final rows = await client
        .from('yordam_kerak_posts')
        .select('''
          id,
          author_id,
          title,
          message,
          price,
          currency,
          start_date,
          duration_minutes,
          category_id,
          subcategory_id,
          created_at,
          contact_phone,
          show_contact_phone,
          show_profile,
          profiles!yordam_kerak_posts_author_id_fkey (
            full_name
          )
        ''')
        .eq('author_id', authorId)
        .eq('status', 'open')
        .order('created_at', ascending: false);

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
    );
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
