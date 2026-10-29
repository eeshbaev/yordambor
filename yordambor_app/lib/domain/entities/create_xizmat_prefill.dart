import 'package:yordambor/core/constants/service_cities.dart';

/// What an invite link carries into "new service": a trade, a city and how
/// the person works. Every part is optional and only fills the form; the
/// person still checks it and publishes the service themselves.
class CreateXizmatPrefill {
  const CreateXizmatPrefill({
    this.categoryId,
    this.subcategoryId,
    this.cityId,
    this.providerType,
  });

  final String? categoryId;
  final String? subcategoryId;
  final String? cityId;

  /// 'individual' or 'institution'.
  final String? providerType;

  static const providerTypes = {'individual', 'institution'};

  bool get isEmpty =>
      categoryId == null &&
      subcategoryId == null &&
      cityId == null &&
      providerType == null;

  /// Reads a link's query, keeping only values that look right: ids of
  /// letters, digits, "_" and "-", a known city, a known provider type.
  /// Anything else is dropped rather than trusted.
  factory CreateXizmatPrefill.fromQuery(Map<String, String> query) {
    final city = query['city']?.trim();
    final type = query['type']?.trim();
    return CreateXizmatPrefill(
      categoryId: _cleanId(query['category']),
      subcategoryId: _cleanId(query['sub']),
      cityId: ServiceCities.isValidId(city) ? city : null,
      providerType: providerTypes.contains(type) ? type : null,
    );
  }

  /// The query a link carries; empty parts are left out.
  Map<String, String> toQuery() => {
        'category': ?categoryId,
        'sub': ?subcategoryId,
        'city': ?cityId,
        'type': ?providerType,
      };

  static final _idPattern = RegExp(r'^[A-Za-z0-9_-]{1,64}$');

  static String? _cleanId(String? raw) {
    final value = raw?.trim();
    if (value == null || !_idPattern.hasMatch(value)) return null;
    return value;
  }
}
