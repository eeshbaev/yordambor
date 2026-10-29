class Review {
  const Review({
    required this.id,
    required this.xizmatId,
    required this.rating,
    this.kelishuvId,
    this.reviewerName,
    this.comment,
    this.providerReply,
    this.createdAt,
  });

  final String id;
  final String? kelishuvId;
  final String xizmatId;
  final int rating;
  final String? reviewerName;
  final String? comment;
  final String? providerReply;
  final DateTime? createdAt;
}

/// How a service's reviews add up: how many gave each number of stars, and
/// their average. Built from every rating, not only the reviews shown.
class RatingSummary {
  const RatingSummary._(this._counts);

  factory RatingSummary.fromRatings(Iterable<int> ratings) {
    final counts = List<int>.filled(5, 0);
    for (final rating in ratings) {
      if (rating >= 1 && rating <= 5) counts[rating - 1]++;
    }
    return RatingSummary._(List<int>.unmodifiable(counts));
  }

  static const empty = RatingSummary._([0, 0, 0, 0, 0]);

  final List<int> _counts;

  /// How many reviews gave [stars] (1 to 5).
  int countFor(int stars) => _counts[stars - 1];

  int get total => _counts.fold(0, (sum, count) => sum + count);

  /// The mean of all ratings; 0 while there are none.
  double get average {
    final count = total;
    if (count == 0) return 0;
    var sum = 0;
    for (var stars = 1; stars <= 5; stars++) {
      sum += stars * _counts[stars - 1];
    }
    return sum / count;
  }
}

class CreateReviewInput {
  const CreateReviewInput({
    required this.kelishuvId,
    required this.xizmatId,
    required this.rating,
    this.comment,
  });

  final String kelishuvId;
  final String xizmatId;
  final int rating;
  final String? comment;
}
