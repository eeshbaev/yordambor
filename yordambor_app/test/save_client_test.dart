import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:yordambor/core/notifications/local_notification_service.dart';
import 'package:yordambor/data/client_book/booking_repository.dart';
import 'package:yordambor/data/client_book/client_book_migration.dart';
import 'package:yordambor/data/client_book/client_registry_repository.dart';
import 'package:yordambor/data/client_book/provider_tools_service.dart';
import 'package:yordambor/data/earnings/earnings_repository.dart';
import 'package:yordambor/data/reminders/reminders_repository.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';

import 'helpers/app_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    setUpPluginFakes();
    Hive.init(Directory.systemTemp.createTempSync('yb_clients').path);
  });

  test('an agreed deal does not fill the client book until saved', () async {
    final registry = ClientRegistryRepository();
    final bookings = BookingRepository();
    final service = ProviderToolsService(
      registry,
      bookings,
      RemindersRepository(LocalNotificationService.instance),
      EarningsRepository(),
      ClientBookMigration(registry, bookings),
    );
    final deal = Kelishuv(
      id: 'k1',
      status: KelishuvStatus.jarayonda,
      partyAId: 'client',
      partyBId: 'provider',
      initiatorId: 'client',
      xizmatId: 'x1',
      xizmatOwnerId: 'provider',
      xizmatName: 'Soch olish',
      partyAName: 'Ali',
      startDate: DateTime.now().add(const Duration(days: 2)),
      startHasTime: true,
    );

    final result = await service.syncFromKelishuv(deal, 'provider');
    expect(result.synced, isTrue);
    // The booking exists, with its client kept out of view.
    expect(await service.findBookingByKelishuvId('k1'), isNotNull);
    expect(await registry.fetchActive(), isEmpty);

    final saved = await service.saveClientFromDeal(
      otherPartyId: 'client',
      name: 'Ali',
    );
    final active = await registry.fetchActive();
    expect(active.map((c) => c.id), [saved.id]);
    expect(active.single.yordamBorUserId, 'client');
    // The same entry the booking uses, not a second one.
    final booking = await service.findBookingByKelishuvId('k1');
    expect(booking!.clientId, saved.id);
  });
}
