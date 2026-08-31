import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/earnings_providers.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/data/client_book/booking_repository.dart';
import 'package:yordambor/data/client_book/client_book_migration.dart';
import 'package:yordambor/data/client_book/client_registry_repository.dart';
import 'package:yordambor/data/client_book/provider_tools_service.dart';
import 'package:yordambor/domain/entities/client_registry_entry.dart';

final clientRegistryRepositoryProvider =
    Provider<ClientRegistryRepository>((ref) {
  return ClientRegistryRepository();
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository();
});

final providerToolsServiceProvider = Provider<ProviderToolsService>((ref) {
  final registry = ref.watch(clientRegistryRepositoryProvider);
  final bookings = ref.watch(bookingRepositoryProvider);
  return ProviderToolsService(
    registry,
    bookings,
    ref.watch(remindersRepositoryProvider),
    ref.watch(earningsRepositoryProvider),
    ClientBookMigration(registry, bookings),
  );
});

final clientBookingServiceProvider = providerToolsServiceProvider;

final clientRegistryProvider =
    FutureProvider<List<ClientRegistryEntry>>((ref) async {
  final service = ref.watch(providerToolsServiceProvider);
  await service.ensureReady();
  return ref.watch(clientRegistryRepositoryProvider).fetchActive();
});

final bookingsProvider = FutureProvider<List<BookingWithClient>>((ref) async {
  final service = ref.watch(providerToolsServiceProvider);
  return service.fetchBookingsWithClients();
});

/// Legacy alias used by calendar/conflict checks.
final clientBookEntriesProvider = bookingsProvider;

final clientBookRepositoryProvider = clientRegistryRepositoryProvider;
