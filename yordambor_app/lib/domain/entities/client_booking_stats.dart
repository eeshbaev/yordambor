class ClientBookingStats {
  const ClientBookingStats({
    this.completed = 0,
    this.cancelled = 0,
    this.upcoming = 0,
    this.postponed = 0,
    this.incomplete = 0,
  });

  final int completed;
  final int cancelled;
  final int upcoming;
  final int postponed;
  final int incomplete;

  int get total =>
      completed + cancelled + upcoming + postponed + incomplete;
}
