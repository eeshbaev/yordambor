enum BookingDeliveryStatus {
  pending,
  completed,
  cancelled;

  String get storageValue => name;

  static BookingDeliveryStatus? fromStorage(String? value) {
    return switch (value) {
      'pending' => BookingDeliveryStatus.pending,
      'completed' => BookingDeliveryStatus.completed,
      'cancelled' => BookingDeliveryStatus.cancelled,
      _ => null,
    };
  }
}
