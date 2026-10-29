import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/core/theme/app_theme.dart';
import 'package:yordambor/presentation/calendar/widgets/schedule_month_grid.dart';
import 'package:yordambor/application/providers/appointment_providers.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';

Kelishuv _deal({
  KelishuvStatus status = KelishuvStatus.jarayonda,
  DateTime? start,
  bool hasTime = true,
  int? duration = 90,
}) =>
    Kelishuv(
      id: 'k1',
      status: status,
      partyAId: 'client',
      partyBId: 'provider',
      initiatorId: 'client',
      xizmatOwnerId: 'provider',
      xizmatName: 'Soch olish',
      startDate: start ?? DateTime(2030, 3, 10, 14, 30),
      startHasTime: hasTime,
      durationMinutes: duration,
      partyAName: 'Client',
      partyBName: 'Provider',
      partyAAvatarUrl: 'a.png',
      contact: const DealContact(firstName: 'Ali', phone: '+998901234567'),
    );

void main() {
  test('the other side, their avatar and the card they sent', () {
    final deal = _deal();
    expect(deal.otherPartyIdFor('provider'), 'client');
    expect(deal.otherPartyIdFor('client'), 'provider');
    expect(deal.otherPartyAvatarFor('provider'), 'a.png');
    // The client sent the card: the provider sees it, the client does not.
    expect(deal.otherPartyContactFor('provider')?.phone, '+998901234567');
    expect(deal.otherPartyContactFor('client'), isNull);
  });

  test('a time of day makes a range for busy hours', () {
    final appt = CalendarAppointment.of(_deal(), 'provider');
    expect(appt.iProvide, isTrue);
    expect(appt.hasTime, isTrue);
    expect(appt.range?.start, 14 * 60 + 30);
    expect(appt.range?.end, 16 * 60);
  });

  test('a day alone takes no hours and defaults to an hour', () {
    final appt = CalendarAppointment.of(
      _deal(start: DateTime(2030, 3, 10), hasTime: false, duration: null),
      'client',
    );
    expect(appt.range, isNull);
    expect(appt.durationMinutes, 60);
    expect(appt.otherPartyName, 'Provider');
  });

  test('a late appointment stops at midnight', () {
    final appt = CalendarAppointment.of(
      _deal(start: DateTime(2030, 3, 10, 23, 30)),
      'provider',
    );
    expect(appt.range?.end, 24 * 60);
  });

  test('phases through the day', () {
    final appt = CalendarAppointment.of(_deal(), 'provider');
    expect(appt.phaseAt(DateTime(2030, 3, 9, 12)), AppointmentPhase.planned);
    expect(appt.phaseAt(DateTime(2030, 3, 10, 9)), AppointmentPhase.today);
    expect(appt.phaseAt(DateTime(2030, 3, 10, 15)), AppointmentPhase.now);
    expect(appt.phaseAt(DateTime(2030, 3, 10, 17)), AppointmentPhase.past);
    expect(
      CalendarAppointment.of(
        _deal(status: KelishuvStatus.bekor),
        'provider',
      ).phaseAt(DateTime(2030, 3, 9)),
      AppointmentPhase.cancelled,
    );
  });

  testWidgets('the month grid fits its day bars at 200 % text',
      (tester) async {
    tester.view.physicalSize = const Size(360 * 3, 780 * 3);
    tester.view.devicePixelRatio = 3;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: ScheduleMonthGrid(
              month: DateTime(2030, 3),
              marks: const {},
              eventsByDay: const {},
              selectedDay: DateTime(2030, 3, 10),
              weekdayLabels: const ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh', 'Ya'],
              onDaySelected: (_) {},
              appointmentDays: {DateTime(2030, 3, 10), DateTime(2030, 3, 11)},
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
