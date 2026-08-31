class ReminderSettings {
  const ReminderSettings({
    this.alertMinutesBefore = const [360, 120, 60, 30, 0],
    this.followUpHoursAfter = const [1, 2, 24],
  });

  /// Minutes before appointment to fire alerts (e.g. 360 = 6h, 0 = at time).
  final List<int> alertMinutesBefore;
  final List<int> followUpHoursAfter;

  Map<String, dynamic> toMap() => {
        'alertMinutesBefore': alertMinutesBefore,
        'followUpHoursAfter': followUpHoursAfter,
      };

  factory ReminderSettings.fromMap(Map<dynamic, dynamic> map) {
    return ReminderSettings(
      alertMinutesBefore: (map['alertMinutesBefore'] as List<dynamic>?)
              ?.map((value) => value as int)
              .toList() ??
          const [360, 120, 60, 30, 0],
      followUpHoursAfter: (map['followUpHoursAfter'] as List<dynamic>?)
              ?.map((value) => value as int)
              .toList() ??
          const [1, 2, 24],
    );
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
