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

/// When someone works: the days of the week and, on each of them, the
/// hours. Unless they set their own: Monday to Friday, 9:00–13:00 and
/// 14:00–18:00, with an hour for lunch.
///
/// Stored as the list of ranges it always was (the column must hold a JSON
/// array); each range also carries the working days as `days`, 1 = Monday
/// to 7 = Sunday ([DateTime.weekday]). Ranges stored before the days
/// existed read as Monday to Friday.
class WorkingHours {
  const WorkingHours(this.ranges, {this.days = weekdays});

  final List<TimeRange> ranges;

  /// The working days, 1 = Monday … 7 = Sunday, in order.
  final List<int> days;

  /// Monday to Friday.
  static const weekdays = [1, 2, 3, 4, 5];

  static const standard = WorkingHours([
    TimeRange(9 * 60, 13 * 60),
    TimeRange(14 * 60, 18 * 60),
  ]);

  /// From the stored list; null when nothing usable is stored.
  static WorkingHours? fromJson(Object? raw) {
    if (raw is! List) return null;
    final ranges = raw.map(TimeRange.parse).whereType<TimeRange>().toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    if (ranges.isEmpty) return null;
    List<int>? days;
    for (final item in raw) {
      if (item is Map && item['days'] is List) {
        days = normalizeDays(item['days'] as List);
        break;
      }
    }
    return WorkingHours(ranges, days: days ?? weekdays);
  }

  /// Valid weekday numbers, each once, Monday first.
  static List<int> normalizeDays(Iterable<Object?> raw) {
    final set = <int>{
      for (final day in raw)
        if (day is num && day.toInt() >= 1 && day.toInt() <= 7) day.toInt(),
    };
    return set.toList()..sort();
  }

  List<Map<String, Object>> toJson() => [
        for (final r in ranges) {...r.toJson(), 'days': days},
      ];

  /// Whether [date] falls on a working day.
  bool worksOn(DateTime date) => days.contains(date.weekday);

  /// "9:00–13:00, 14:00–18:00".
  String get label => ranges.map((range) => range.label).join(', ');

  /// The days in short names, runs joined: "Du–Ju", "Du–Ch, Sh".
  /// [shortNames] holds Monday … Sunday.
  String daysLabel(List<String> shortNames) {
    if (days.isEmpty || shortNames.length < 7) return '';
    final parts = <String>[];
    var i = 0;
    while (i < days.length) {
      var j = i;
      while (j + 1 < days.length && days[j + 1] == days[j] + 1) {
        j++;
      }
      final first = shortNames[days[i] - 1];
      final last = shortNames[days[j] - 1];
      if (j == i) {
        parts.add(first);
      } else if (j == i + 1) {
        parts
          ..add(first)
          ..add(last);
      } else {
        parts.add('$first–$last');
      }
      i = j + 1;
    }
    return parts.join(', ');
  }

  /// "Du–Ju · 9:00–13:00, 14:00–18:00".
  String fullLabel(List<String> shortNames) {
    final dayText = daysLabel(shortNames);
    return dayText.isEmpty ? label : '$dayText · $label';
  }

  WorkingHours copyWith({List<TimeRange>? ranges, List<int>? days}) =>
      WorkingHours(ranges ?? this.ranges, days: days ?? this.days);

  bool sameAs(WorkingHours other) {
    if (other.ranges.length != ranges.length) return false;
    if (other.days.length != days.length) return false;
    for (var i = 0; i < days.length; i++) {
      if (other.days[i] != days[i]) return false;
    }
    for (var i = 0; i < ranges.length; i++) {
      if (other.ranges[i] != ranges[i]) return false;
    }
    return true;
  }
}
