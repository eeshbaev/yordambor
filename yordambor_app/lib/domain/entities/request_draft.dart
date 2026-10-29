/// A "Yordam kerak" request the person started but did not publish.
///
/// Kept on this device only and saved as they type (manual S-06), so closing
/// the sheet never loses their words.
class RequestDraft {
  const RequestDraft({
    required this.savedAt,
    this.ownerId,
    this.title = '',
    this.message = '',
    this.price = '',
    this.duration = '',
    this.categoryId,
    this.subcategoryId,
    this.startDate,
    this.serviceCity,
  });

  final DateTime savedAt;

  /// The signed-in user who wrote it; another account on this device does
  /// not see it.
  final String? ownerId;
  final String title;
  final String message;
  final String price;
  final String duration;
  final String? categoryId;
  final String? subcategoryId;
  final DateTime? startDate;

  /// Where the help is needed: a [ServiceCityIds] value.
  final String? serviceCity;

  bool belongsTo(String? userId) => ownerId == userId;

  /// Worth keeping: the person typed something of their own. A category
  /// that came from the feed filter alone is not a draft.
  bool get hasContent =>
      title.trim().isNotEmpty ||
      message.trim().isNotEmpty ||
      price.trim().isNotEmpty;

  Map<String, Object?> toJson() => {
        'savedAt': savedAt.toIso8601String(),
        'ownerId': ownerId,
        'title': title,
        'message': message,
        'price': price,
        'duration': duration,
        'categoryId': categoryId,
        'subcategoryId': subcategoryId,
        'startDate': startDate?.toIso8601String(),
        'serviceCity': serviceCity,
      };

  static RequestDraft? fromJson(Object? json) {
    if (json is! Map) return null;
    final savedAt = DateTime.tryParse('${json['savedAt']}');
    if (savedAt == null) return null;
    String text(String key) {
      final value = json[key];
      return value is String ? value : '';
    }

    String? id(String key) {
      final value = json[key];
      return value is String && value.isNotEmpty ? value : null;
    }

    final start = json['startDate'];
    return RequestDraft(
      savedAt: savedAt,
      ownerId: id('ownerId'),
      title: text('title'),
      message: text('message'),
      price: text('price'),
      duration: text('duration'),
      categoryId: id('categoryId'),
      subcategoryId: id('subcategoryId'),
      startDate: start is String ? DateTime.tryParse(start) : null,
      serviceCity: id('serviceCity'),
    );
  }
}
