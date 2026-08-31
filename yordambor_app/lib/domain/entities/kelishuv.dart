enum KelishuvStatus {
  muzokarada,
  jarayonda,
  bajarildi,
  bekor,
  rad,
  archived,
}

class Kelishuv {
  const Kelishuv({
    required this.id,
    required this.status,
    required this.partyAId,
    required this.partyBId,
    required this.initiatorId,
    this.xizmatId,
    this.yordamKerakPostId,
    this.message,
    this.price,
    this.currency,
    this.startDate,
    this.durationMinutes,
    this.acceptA = false,
    this.acceptB = false,
    this.completeA = false,
    this.completeB = false,
    this.otherPartyName,
    this.partyAName,
    this.partyBName,
    this.xizmatName,
    this.postTitle,
    this.createdAt,
    this.updatedAt,
    this.xizmatOwnerId,
    this.jarayondaAt,
  });

  final String id;
  final KelishuvStatus status;
  final String partyAId;
  final String partyBId;
  final String initiatorId;
  final String? xizmatId;
  final String? yordamKerakPostId;
  final String? message;
  final double? price;
  final String? currency;
  final DateTime? startDate;
  final int? durationMinutes;
  final bool acceptA;
  final bool acceptB;
  final bool completeA;
  final bool completeB;
  final String? otherPartyName;
  final String? partyAName;
  final String? partyBName;
  final String? xizmatName;
  final String? postTitle;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? xizmatOwnerId;
  final DateTime? jarayondaAt;

  bool canRepeatBook(String userId) {
    if (xizmatId == null || xizmatOwnerId == null) return false;
    if (status != KelishuvStatus.bajarildi) return false;
    return isClient(userId);
  }

  bool isProvider(String userId) => xizmatOwnerId == userId;

  bool isClient(String userId) =>
      xizmatOwnerId != null && xizmatOwnerId != userId && isParty(userId);

  bool get isActive =>
      status == KelishuvStatus.muzokarada ||
      status == KelishuvStatus.jarayonda;

  bool get isClosed =>
      status == KelishuvStatus.bajarildi ||
      status == KelishuvStatus.bekor ||
      status == KelishuvStatus.rad ||
      status == KelishuvStatus.archived;

  String otherPartyNameFor(String userId) {
    if (userId == partyAId) {
      return partyBName ?? 'Foydalanuvchi';
    }
    if (userId == partyBId) {
      return partyAName ?? 'Foydalanuvchi';
    }
    return otherPartyName ?? 'Foydalanuvchi';
  }

  bool isParty(String userId) => userId == partyAId || userId == partyBId;

  bool hasAccepted(String userId) {
    if (userId == partyAId) return acceptA;
    if (userId == partyBId) return acceptB;
    return false;
  }

  bool hasMarkedComplete(String userId) {
    if (userId == partyAId) return completeA;
    if (userId == partyBId) return completeB;
    return false;
  }

  bool get isDualAccepted => acceptA && acceptB;

  bool get isDualComplete => completeA && completeB;

  bool awaitingMyComplete(String userId) {
    if (status != KelishuvStatus.jarayonda || !isParty(userId)) return false;
    if (hasMarkedComplete(userId)) return false;
    return completeA || completeB;
  }

  bool canMarkComplete(String userId) {
    if (status != KelishuvStatus.jarayonda || !isParty(userId)) return false;
    if (hasMarkedComplete(userId)) return false;
    if (jarayondaAt == null) return true;
    return DateTime.now().difference(jarayondaAt!).inDays >= 3;
  }

  int? daysUntilCanComplete(String userId) {
    if (status != KelishuvStatus.jarayonda || !isParty(userId)) return null;
    if (hasMarkedComplete(userId) || jarayondaAt == null) return null;
    final remaining = 3 - DateTime.now().difference(jarayondaAt!).inDays;
    return remaining > 0 ? remaining : null;
  }

  bool canEditTerms(String userId) {
    if (!isParty(userId) || !isActive) return false;
    if (status == KelishuvStatus.muzokarada) return true;
    if (status == KelishuvStatus.jarayonda) {
      if (jarayondaAt == null) return true;
      return DateTime.now().difference(jarayondaAt!).inDays <= 3;
    }
    return false;
  }
}

class TaklifInput {
  const TaklifInput({
    this.message,
    this.price,
    this.currency,
    this.startDate,
    this.durationMinutes,
  });

  final String? message;
  final double? price;
  final String? currency;
  final DateTime? startDate;
  final int? durationMinutes;
}
