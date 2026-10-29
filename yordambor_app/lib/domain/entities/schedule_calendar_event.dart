enum ScheduleEventKind { reminder, deal }

/// Whose appointment a reminder is: help the person asked for, help they
/// give, or a note of their own.
enum ScheduleEventRole { needHelp, giveHelp, personal }

class ScheduleCalendarEvent {
  const ScheduleCalendarEvent({
    required this.id,
    required this.title,
    required this.day,
    required this.scheduledAt,
    required this.kind,
    this.subtitle,
    this.kelishuvId,
    this.role = ScheduleEventRole.personal,
  });

  final String id;
  final String title;
  final String? subtitle;
  final DateTime day;
  final DateTime scheduledAt;
  final ScheduleEventKind kind;
  final String? kelishuvId;
  final ScheduleEventRole role;
}
