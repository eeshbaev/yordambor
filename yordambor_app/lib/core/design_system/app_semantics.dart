/// Joins what a card shows into the one sentence a screen reader says
/// (manual A-02): "Santexnik xizmati. Santexnik · Chilonzor. reyting 4,8.
/// 150 000 soʻm". Empty parts are left out and a part's own full stop is
/// dropped, so no stop is read twice.
String ybSentence(Iterable<String?> parts) {
  final clean = <String>[];
  for (final part in parts) {
    final text = part?.trim() ?? '';
    if (text.isEmpty) continue;
    clean.add(text.replaceFirst(RegExp(r'[.。]+$'), ''));
  }
  return clean.join('. ');
}
