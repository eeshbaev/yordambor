/// Canonical service-area cities stored in [service_city] (slug ids).
abstract final class ServiceCityIds {
  static const toshkent = 'toshkent';
  static const toshkentViloyati = 'toshkent_viloyati';
  static const samarqand = 'samarqand';
  static const buxoro = 'buxoro';
  static const nukus = 'nukus';
  static const namangan = 'namangan';
  static const andijon = 'andijon';
  static const fargona = 'fargona';
  static const qarshi = 'qarshi';
  static const urganch = 'urganch';
  static const termiz = 'termiz';
  static const jizzax = 'jizzax';
  static const navoiy = 'navoiy';
  static const qoqon = 'qoqon';
  static const guliston = 'guliston';
  static const boshqa = 'boshqa';

  static const all = [
    toshkent,
    toshkentViloyati,
    samarqand,
    buxoro,
    nukus,
    namangan,
    andijon,
    fargona,
    qarshi,
    urganch,
    termiz,
    jizzax,
    navoiy,
    qoqon,
    guliston,
    boshqa,
  ];
}

abstract final class ServiceCities {
  static bool isValidId(String? id) {
    if (id == null || id.isEmpty) return false;
    return ServiceCityIds.all.contains(id);
  }

  /// Maps legacy free-text values to slug ids.
  static String? normalizeStored(String? raw) {
    final trimmed = raw?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    if (isValidId(trimmed)) return trimmed;

    final lower = trimmed.toLowerCase();
    const legacy = {
      'toshkent': ServiceCityIds.toshkent,
      'tashkent': ServiceCityIds.toshkent,
      'ташкент': ServiceCityIds.toshkent,
      'toshkent viloyati': ServiceCityIds.toshkentViloyati,
      'tashkent region': ServiceCityIds.toshkentViloyati,
      'samarqand': ServiceCityIds.samarqand,
      'samarkand': ServiceCityIds.samarqand,
      'самарканд': ServiceCityIds.samarqand,
      'buxoro': ServiceCityIds.buxoro,
      'bukhara': ServiceCityIds.buxoro,
      'бухара': ServiceCityIds.buxoro,
      'nukus': ServiceCityIds.nukus,
      'нукус': ServiceCityIds.nukus,
      'namangan': ServiceCityIds.namangan,
      'наманган': ServiceCityIds.namangan,
      'andijon': ServiceCityIds.andijon,
      'andijan': ServiceCityIds.andijon,
      'андijan': ServiceCityIds.andijon,
      'farg\'ona': ServiceCityIds.fargona,
      'fargona': ServiceCityIds.fargona,
      'fergana': ServiceCityIds.fargona,
      'qarshi': ServiceCityIds.qarshi,
      'karshi': ServiceCityIds.qarshi,
      'urganch': ServiceCityIds.urganch,
      'urgench': ServiceCityIds.urganch,
      'termiz': ServiceCityIds.termiz,
      'termez': ServiceCityIds.termiz,
      'jizzax': ServiceCityIds.jizzax,
      'jizzakh': ServiceCityIds.jizzax,
      'navoiy': ServiceCityIds.navoiy,
      'navoi': ServiceCityIds.navoiy,
      'qo\'qon': ServiceCityIds.qoqon,
      'qoqon': ServiceCityIds.qoqon,
      'kokand': ServiceCityIds.qoqon,
      'guliston': ServiceCityIds.guliston,
      'gulistan': ServiceCityIds.guliston,
      'boshqa': ServiceCityIds.boshqa,
      'other': ServiceCityIds.boshqa,
    };

    return legacy[lower];
  }

  /// Deterministic demo assignment when [service_city] is missing.
  static String demoCityForListingId(String id) {
    final roll = id.hashCode.abs() % 100;
    if (roll < 28) return ServiceCityIds.toshkent;
    if (roll < 56) return ServiceCityIds.samarqand;
    if (roll < 64) return ServiceCityIds.buxoro;
    if (roll < 72) return ServiceCityIds.andijon;
    if (roll < 80) return ServiceCityIds.toshkentViloyati;

    const spread = [
      ServiceCityIds.namangan,
      ServiceCityIds.fargona,
      ServiceCityIds.nukus,
      ServiceCityIds.qarshi,
      ServiceCityIds.urganch,
      ServiceCityIds.termiz,
      ServiceCityIds.jizzax,
      ServiceCityIds.navoiy,
      ServiceCityIds.qoqon,
      ServiceCityIds.guliston,
      ServiceCityIds.boshqa,
    ];
    return spread[roll % spread.length];
  }

  static String? resolveForFeed(String? raw, {required bool isDemo, String? listingId}) {
    final normalized = normalizeStored(raw);
    if (normalized != null) return normalized;
    if (isDemo && listingId != null) {
      return demoCityForListingId(listingId);
    }
    return null;
  }
}
