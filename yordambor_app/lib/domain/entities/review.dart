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
