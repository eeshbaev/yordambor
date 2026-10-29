/// Display formats for money, ratings and search text.
///
/// Prices read "120 000 soʻm": no-break spaces between thousands, "soʻm"
/// instead of "UZS", no decimals. Ratings use a comma in Uzbek and Russian.
/// The stored currency code stays "UZS"; only what people see changes.
library;

const _nbsp = '\u00A0';

/// "120000" → "120 000" in Uzbek and Russian (no-break spaces, so a price
/// never wraps), "120,000" in English and Chinese.
String groupThousands(num amount, {String languageCode = 'uz'}) {
  final separator = languageCode == 'en' || languageCode == 'zh' ? ',' : _nbsp;
  final negative = amount < 0;
  final digits = amount.abs().round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(separator);
    buffer.write(digits[i]);
  }
  return negative ? '−$buffer' : buffer.toString();
}

/// The word people read for a currency code.
String currencyUnit(String? code, {String languageCode = 'uz'}) {
  final upper = (code == null || code.trim().isEmpty) ? 'UZS' : code.toUpperCase();
  if (upper == 'UZS') return languageCode == 'ru' ? 'сум' : 'soʻm';
  return upper;
}

/// "120 000 soʻm" (Russian: "120 000 сум").
String formatSom(num amount, {String languageCode = 'uz'}) =>
    '${groupThousands(amount, languageCode: languageCode)}$_nbsp'
    '${currencyUnit('UZS', languageCode: languageCode)}';

/// An amount in any currency: "120 000 soʻm", "$1 200", "50 EUR".
String formatMoney(num amount, String? currency, {String languageCode = 'uz'}) {
  final upper = (currency == null || currency.trim().isEmpty)
      ? 'UZS'
      : currency.toUpperCase();
  final digits = groupThousands(amount, languageCode: languageCode);
  if (upper == 'USD') return '\$$digits';
  return '$digits$_nbsp${currencyUnit(upper, languageCode: languageCode)}';
}

/// "4,9" in Uzbek and Russian, "4.9" in English and Chinese.
String formatRating(num rating, String languageCode) {
  final text = rating.toStringAsFixed(1);
  return languageCode == 'uz' || languageCode == 'ru'
      ? text.replaceAll('.', ',')
      : text;
}

/// "150 000", "150.000" and "150,000" all read as 150000. Rejects negatives
/// and anything that is not a whole number.
int? parseSom(String input) {
  final value = int.tryParse(input.replaceAll(RegExp('[\\s\u00A0\u202F.,]'), ''));
  return (value == null || value < 0) ? null : value;
}

/// Every apostrophe people type becomes one form, so "o'zbek", "o`zbek" and
/// "oʻzbek" all match in search.
String normalizeUz(String text) => text
    .toLowerCase()
    .replaceAll(RegExp("[ʻʼ'`‘’ʹ]"), "'")
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();
