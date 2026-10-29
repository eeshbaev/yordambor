class ReminderSettings {
  const ReminderSettings({
    this.alertMinutesBefore = defaultAlerts,
    this.followUpHoursAfter = defaultFollowUps,
  });

  /// The lead times the settings offer: 1 day, 3 hours, 1 hour, 15 minutes
  /// before, and at the time.
  static const alertPresets = <int>[1440, 180, 60, 15, 0];

  /// Follow-up checks offered: 1, 2 and 24 hours after.
  static const followUpPresets = <int>[1, 2, 24];

  /// The day before, an hour before and at the time: enough to plan the
  /// day and still be on time.
  static const defaultAlerts = <int>[1440, 60, 0];
  static const defaultFollowUps = <int>[2, 24];

  /// Minutes before the appointment each alert fires (0 = at the time),
  /// longest first.
  final List<int> alertMinutesBefore;
  final List<int> followUpHoursAfter;

  Map<String, dynamic> toMap() => {
        'alertMinutesBefore': alertMinutesBefore,
        'followUpHoursAfter': followUpHoursAfter,
      };

  /// Reads what was saved; anything missing or unreadable falls back to the
  /// defaults, so reminders never end up with no alerts by accident.
  factory ReminderSettings.fromMap(Map<dynamic, dynamic> map) {
    return ReminderSettings(
      alertMinutesBefore: _readList(
            map['alertMinutesBefore'],
            descending: true,
          ) ??
          defaultAlerts,
      followUpHoursAfter: _readList(map['followUpHoursAfter']) ??
          defaultFollowUps,
    );
  }

  /// Whole, non-negative numbers without repeats, sorted; null when there
  /// are none.
  static List<int>? _readList(Object? raw, {bool descending = false}) {
    if (raw is! List) return null;
    final values = <int>{
      for (final value in raw)
        if (value is num && value >= 0)
          value.toInt()
        else if (value is String && (int.tryParse(value.trim()) ?? -1) >= 0)
          int.parse(value.trim()),
    }.toList()
      ..sort(descending ? (a, b) => b.compareTo(a) : null);
    return values.isEmpty ? null : values;
  }

  ReminderSettings copyWith({
    List<int>? alertMinutesBefore,
    List<int>? followUpHoursAfter,
  }) {
    return ReminderSettings(
      alertMinutesBefore: alertMinutesBefore ?? this.alertMinutesBefore,
      followUpHoursAfter: followUpHoursAfter ?? this.followUpHoursAfter,
    );
  }
}
