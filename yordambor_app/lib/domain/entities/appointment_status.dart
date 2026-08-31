enum AppointmentStatus {
  upcoming,
  cancelled,
  postponed,
  incomplete,
  completed;

  String get storageValue => name;

  static AppointmentStatus fromStorage(String? value) {
    return switch (value) {
      'cancelled' => AppointmentStatus.cancelled,
      'postponed' => AppointmentStatus.postponed,
      'incomplete' => AppointmentStatus.incomplete,
      'completed' => AppointmentStatus.completed,
      _ => AppointmentStatus.upcoming,
    };
  }

  bool get isActive =>
      this == AppointmentStatus.upcoming ||
      this == AppointmentStatus.postponed ||
      this == AppointmentStatus.incomplete;
}
