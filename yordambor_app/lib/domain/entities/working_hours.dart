/// A stretch of a day, in minutes from midnight: 9:00–13:00 is 540–780.
class TimeRange {
  const TimeRange(this.start, this.end);

  final int start;
  final int end;

  bool get isValid => start >= 0 && end <= 24 * 60 && end > start;

  /// From `{"from": "09:00", "to": "13:00"}`; null when it is not a range.
  static TimeRange? parse(Object? raw) {
    if (raw is! Map) return null;
    final from = _minutes(raw['from']);
    final to = _minutes(raw['to']);
    if (from == null || to == null) return null;
    final range = TimeRange(from, to);
    return range.isValid ? range : null;
  }

  static int? _minutes(Object? text) {
    if (text is! String) return null;
    final parts = text.trim().split(':');
    if (parts.length < 2) return null;
    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);
    if (hours == null || minutes == null) return null;
    if (hours < 0 || hours > 24 || minutes < 0 || minutes > 59) return null;
    final total = hours * 60 + minutes;
    return total > 24 * 60 ? null : total;
  }

  /// "9:00".
  static String clock(int minutes) =>
      '${minutes ~/ 60}:${(minutes % 60).toString().padLeft(2, '0')}';

  /// "09:00", as stored.
  static String _stored(int minutes) =>
      '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
      '${(minutes % 60).toString().padLeft(2, '0')}';

  Map<String, String> toJson() => {'from': _stored(start), 'to': _stored(end)};

  /// "9:00–13:00".
  String get label => '${clock(start)}–${clock(end)}';

  @override
  bool operator ==(Object other) =>
      other is TimeRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}

/// When someone works on a usual day. Unless they set their own: 9:00–13:00
/// and 14:00–18:00, with an hour for lunch.
class WorkingHours {
  const WorkingHours(this.ranges);

  final List<TimeRange> ranges;

  static const standard = WorkingHours([
    TimeRange(9 * 60, 13 * 60),
    TimeRange(14 * 60, 18 * 60),
  ]);

  /// From the stored list; null when nothing usable is stored.
  static WorkingHours? fromJson(Object? raw) {
    if (raw is! List) return null;
    final ranges = raw.map(TimeRange.parse).whereType<TimeRange>().toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    return ranges.isEmpty ? null : WorkingHours(ranges);
  }

  List<Map<String, String>> toJson() => [for (final r in ranges) r.toJson()];

  /// "9:00–13:00, 14:00–18:00".
  String get label => ranges.map((range) => range.label).join(', ');

  bool sameAs(WorkingHours other) {
    if (other.ranges.length != ranges.length) return false;
    for (var i = 0; i < ranges.length; i++) {
      if (other.ranges[i] != ranges[i]) return false;
    }
    return true;
  }
}
