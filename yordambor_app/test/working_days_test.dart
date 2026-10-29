import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/domain/entities/working_hours.dart';

const _names = ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh', 'Ya'];

void main() {
  group('WorkingHours days', () {
    test('hours stored before the days existed read as Monday to Friday', () {
      final hours = WorkingHours.fromJson([
        {'from': '09:00', 'to': '13:00'},
      ])!;
      expect(hours.days, [1, 2, 3, 4, 5]);
    });

    test('days survive a round trip and stay a JSON array', () {
      const hours = WorkingHours(
        [TimeRange(540, 780), TimeRange(840, 1080)],
        days: [1, 2, 3, 4, 5, 6],
      );
      final json = hours.toJson();
      expect(json, isA<List>());
      final back = WorkingHours.fromJson(json)!;
      expect(back.days, [1, 2, 3, 4, 5, 6]);
      expect(back.sameAs(hours), isTrue);
    });

    test('bad and repeated days are dropped and sorted', () {
      expect(WorkingHours.normalizeDays([7, 3, 3, 0, 9, 'x', 1]), [1, 3, 7]);
    });

    test('worksOn follows the weekday', () {
      const hours = WorkingHours([TimeRange(540, 780)]);
      expect(hours.worksOn(DateTime(2026, 10, 30)), isTrue); // Friday
      expect(hours.worksOn(DateTime(2026, 10, 31)), isFalse); // Saturday
    });

    test('labels join runs of days', () {
      const range = [TimeRange(540, 780)];
      expect(const WorkingHours(range).daysLabel(_names), 'Du–Ju');
      expect(
        const WorkingHours(range, days: [1, 2, 3, 6]).daysLabel(_names),
        'Du–Ch, Sh',
      );
      expect(
        const WorkingHours(range, days: [6, 7]).daysLabel(_names),
        'Sh, Ya',
      );
      expect(
        const WorkingHours(range).fullLabel(_names),
        'Du–Ju · 9:00–13:00',
      );
    });
  });
}
