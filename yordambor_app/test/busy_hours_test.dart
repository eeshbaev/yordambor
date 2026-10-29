import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/domain/entities/schedule_day_availability.dart';
import 'package:yordambor/domain/entities/working_hours.dart';
import 'package:yordambor/presentation/xizmat/widgets/xizmat_schedule_section.dart';

void main() {
  final day = DateTime(2030, 3, 10);
  const appt = TimeRange(14 * 60, 15 * 60 + 30);

  test('nothing booked: the marks stay as they are', () {
    final marks = {day: const DayMark(ScheduleDayAvailability.available)};
    expect(mergeBusyHours(marks, const {}), same(marks));
  });

  test('a free or unmarked day is busy at its appointment hours', () {
    for (final mark in [
      null,
      const DayMark(ScheduleDayAvailability.available),
    ]) {
      final merged = mergeBusyHours(
        {day: ?mark},
        {day: [appt]},
      );
      expect(merged[day]!.status, ScheduleDayAvailability.busy);
      expect(merged[day]!.slots, [appt]);
    }
  });

  test('busy hours the provider marked join the booked ones', () {
    final merged = mergeBusyHours(
      {
        day: const DayMark(
          ScheduleDayAvailability.busy,
          slots: [TimeRange(9 * 60, 10 * 60), TimeRange(15 * 60, 17 * 60)],
        ),
      },
      {day: [appt]},
    );
    expect(merged[day]!.slots, [
      const TimeRange(9 * 60, 10 * 60),
      const TimeRange(14 * 60, 17 * 60),
    ]);
  });

  test('a day busy all day stays busy all day', () {
    final merged = mergeBusyHours(
      {day: const DayMark(ScheduleDayAvailability.busy)},
      {day: [appt]},
    );
    expect(merged[day]!.wholeDay, isTrue);
  });

  test('touching ranges join', () {
    expect(
      unionTimeRanges(const [
        TimeRange(60, 120),
        TimeRange(0, 60),
        TimeRange(200, 300),
      ]),
      const [TimeRange(0, 120), TimeRange(200, 300)],
    );
  });
}
