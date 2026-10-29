import 'package:yordambor/domain/entities/working_hours.dart';

enum ScheduleDayAvailability {
  unset,
  available,
  busy;

  static ScheduleDayAvailability fromStorage(String? value) => switch (value) {
        'available' => ScheduleDayAvailability.available,
        'busy' => ScheduleDayAvailability.busy,
        _ => ScheduleDayAvailability.unset,
      };

  String? get storageValue => switch (this) {
        ScheduleDayAvailability.unset => null,
        ScheduleDayAvailability.available => 'available',
        ScheduleDayAvailability.busy => 'busy',
      };

  ScheduleDayAvailability cycleNext() => switch (this) {
        ScheduleDayAvailability.unset => ScheduleDayAvailability.available,
        ScheduleDayAvailability.available => ScheduleDayAvailability.busy,
        ScheduleDayAvailability.busy => ScheduleDayAvailability.unset,
      };
}

/// A day marked in the calendar: free or busy, for the whole working day or
/// only at [slots]. Clients see it on the person's services.
class DayMark {
  const DayMark(this.status, {this.slots});

  final ScheduleDayAvailability status;

  /// Null or empty: the whole working day.
  final List<TimeRange>? slots;

  bool get wholeDay => slots == null || slots!.isEmpty;

  /// From a stored `slots` list.
  static List<TimeRange>? slotsFrom(Object? raw) {
    if (raw is! List) return null;
    final slots = raw.map(TimeRange.parse).whereType<TimeRange>().toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    return slots.isEmpty ? null : slots;
  }

  List<Map<String, String>>? slotsJson() =>
      wholeDay ? null : [for (final slot in slots!) slot.toJson()];
}
