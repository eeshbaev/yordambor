import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/application/schedule/reminder_busy_sync.dart';
import 'package:yordambor/domain/entities/schedule_day_availability.dart';
import 'package:yordambor/domain/entities/working_hours.dart';

const _busy = ScheduleDayAvailability.busy;

void main() {
  group('combineBusy', () {
    test('no reminders: the own mark as it is', () {
      const own = DayMark(_busy, slots: [TimeRange(600, 660)]);
      expect(combineBusy(own, const []), same(own));
      expect(combineBusy(null, const []), isNull);
    });

    test('reminder time joins the own busy hours', () {
      const own = DayMark(_busy, slots: [TimeRange(600, 660)]);
      final mark = combineBusy(own, const [TimeRange(660, 720)])!;
      expect(mark.status, _busy);
      expect(mark.slots, const [TimeRange(600, 720)]);
    });

    test('a day busy all day stays so', () {
      const own = DayMark(_busy);
      expect(combineBusy(own, const [TimeRange(600, 660)]), same(own));
    });

    test('no own mark: busy only at the reminder', () {
      final mark = combineBusy(null, const [TimeRange(840, 900)])!;
      expect(mark.slots, const [TimeRange(840, 900)]);
    });
  });

  group('stripReminderSlots', () {
    test('takes the reminder time out of the own mark', () {
      const mark = DayMark(_busy, slots: [TimeRange(600, 720)]);
      final own = stripReminderSlots(mark, const [TimeRange(660, 720)])!;
      expect(own.slots, const [TimeRange(600, 660)]);
    });

    test('nothing left: no own mark', () {
      const mark = DayMark(_busy, slots: [TimeRange(600, 660)]);
      expect(stripReminderSlots(mark, const [TimeRange(600, 660)]), isNull);
    });

    test('whole-day and free marks are kept', () {
      const whole = DayMark(_busy);
      const free = DayMark(ScheduleDayAvailability.available);
      expect(stripReminderSlots(whole, const [TimeRange(600, 660)]),
          same(whole));
      expect(stripReminderSlots(free, const [TimeRange(600, 660)]),
          same(free));
    });

    test('cancel round trip: strip then combine gives the own mark back', () {
      const own = DayMark(_busy, slots: [TimeRange(540, 600)]);
      const reminder = [TimeRange(840, 900)];
      final shown = combineBusy(own, reminder)!;
      final back = stripReminderSlots(shown, reminder)!;
      expect(back.slots, const [TimeRange(540, 600)]);
      // Reminder cancelled: no reminder time, the own mark alone.
      expect(combineBusy(back, const [])!.slots, const [TimeRange(540, 600)]);
    });
  });
}
