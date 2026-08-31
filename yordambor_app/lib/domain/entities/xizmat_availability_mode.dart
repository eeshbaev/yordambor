enum XizmatAvailabilityMode {
  availableNow,
  busy,
  callMe;

  static XizmatAvailabilityMode? fromDb(String? value) => switch (value) {
        'available_now' => XizmatAvailabilityMode.availableNow,
        'busy' => XizmatAvailabilityMode.busy,
        'call_me' => XizmatAvailabilityMode.callMe,
        _ => null,
      };

  String toDb() => switch (this) {
        XizmatAvailabilityMode.availableNow => 'available_now',
        XizmatAvailabilityMode.busy => 'busy',
        XizmatAvailabilityMode.callMe => 'call_me',
      };
}
