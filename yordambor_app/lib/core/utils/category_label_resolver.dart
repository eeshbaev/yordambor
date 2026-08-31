import 'package:yordambor/data/categories/category_repository.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/yordam_kerak_post.dart';

class CategoryLabelResolver {
  CategoryLabelResolver(this._repository);

  final CategoryRepository _repository;

  Future<void> ensureLoaded() => _repository.loadCategories();

  String categoryLabel(String categoryId, String language) =>
      _repository.categoryLabelFor(categoryId, language);

  String subcategoryLabel(
    String categoryId,
    String subcategoryId,
    String language,
  ) =>
      _repository.subcategoryLabelFor(categoryId, subcategoryId, language);

  XizmatFeedItem localizeXizmat(XizmatFeedItem item, String language) {
    return XizmatFeedItem(
      id: item.id,
      name: item.name,
      categoryLabel: categoryLabel(item.categoryId, language),
      subcategoryLabel: subcategoryLabel(
        item.categoryId,
        item.subcategoryId,
        language,
      ),
      categoryId: item.categoryId,
      subcategoryId: item.subcategoryId,
      heroImageUrl: item.heroImageUrl,
      rating: item.rating,
      completedCount: item.completedCount,
      isDemo: item.isDemo,
      description: item.description,
      portfolioImageUrls: item.portfolioImageUrls,
      providerType: item.providerType,
      ownerId: item.ownerId,
      ownerName: item.ownerName,
      ownerAvatarUrl: item.ownerAvatarUrl,
      contactPhone: item.contactPhone,
      showContactPhone: item.showContactPhone,
      showProfile: item.showProfile,
      pricingModel: item.pricingModel,
      basePrice: item.basePrice,
      currency: item.currency,
      minDurationMinutes: item.minDurationMinutes,
      availabilityVisible: item.availabilityVisible,
      availabilityMode: item.availabilityMode,
      availabilityFrom: item.availabilityFrom,
      availabilityUntil: item.availabilityUntil,
      showServicePromise: item.showServicePromise,
      servicePromise: item.servicePromise,
      serviceCity: item.serviceCity,
    );
  }

  YordamKerakFeedItem localizeYordamKerak(
    YordamKerakFeedItem item,
    String language,
  ) {
    return YordamKerakFeedItem(
      id: item.id,
      title: item.title,
      categoryLabel: categoryLabel(item.categoryId, language),
      subcategoryLabel: subcategoryLabel(
        item.categoryId,
        item.subcategoryId,
        language,
      ),
      categoryId: item.categoryId,
      subcategoryId: item.subcategoryId,
      authorName: item.authorName,
      message: item.message,
      price: item.price,
      currency: item.currency,
      startDate: item.startDate,
      durationMinutes: item.durationMinutes,
      seekingProviderType: item.seekingProviderType,
      isDemo: item.isDemo,
      authorId: item.authorId,
      contactPhone: item.contactPhone,
      showContactPhone: item.showContactPhone,
      showProfile: item.showProfile,
    );
  }

  List<XizmatFeedItem> localizeXizmatList(
    List<XizmatFeedItem> items,
    String language,
  ) =>
      items.map((item) => localizeXizmat(item, language)).toList();

  List<YordamKerakFeedItem> localizeYordamKerakList(
    List<YordamKerakFeedItem> items,
    String language,
  ) =>
      items.map((item) => localizeYordamKerak(item, language)).toList();
}
