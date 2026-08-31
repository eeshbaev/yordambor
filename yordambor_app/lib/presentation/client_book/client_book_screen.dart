import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/client_registry_entry.dart';
import 'package:yordambor/presentation/client_book/widgets/client_book_calendar.dart';
import 'package:yordambor/presentation/client_book/widgets/client_booking_sheet.dart';
import 'package:yordambor/presentation/client_book/widgets/appointment_detail_sheet.dart';
import 'package:yordambor/presentation/client_book/widgets/client_detail_sheet.dart';
import 'package:yordambor/presentation/client_book/widgets/client_registry_list_tile.dart';
import 'package:yordambor/presentation/client_book/widgets/client_registry_sheet.dart';

class ClientBookScreen extends ConsumerStatefulWidget {
  const ClientBookScreen({super.key});

  @override
  ConsumerState<ClientBookScreen> createState() => _ClientBookScreenState();
}

class _ClientBookScreenState extends ConsumerState<ClientBookScreen> {
  int _viewIndex = 0;

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final localeCode = ref.watch(onboardingPrefsProvider).language;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.clientBookTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: SegmentedButton<int>(
              segments: [
                ButtonSegment(value: 0, label: Text(strings.clientBookList)),
                ButtonSegment(
                  value: 1,
                  label: Text(strings.clientBookCalendar),
                ),
              ],
              selected: {_viewIndex},
              onSelectionChanged: (value) {
                setState(() => _viewIndex = value.first);
              },
            ),
          ),
        ),
      ),
      floatingActionButton: _viewIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => showClientRegistrySheet(
                context: context,
                ref: ref,
                strings: strings,
              ),
              icon: const Icon(Icons.person_add_outlined),
              label: Text(strings.clientBookAdd),
            )
          : null,
      body: AppLayout.page(
        context: context,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(clientRegistryProvider);
            ref.invalidate(bookingsProvider);
          },
          child: _viewIndex == 0
              ? _RegistryList(
                  strings: strings,
                  onClientTap: (client) => showClientDetailSheet(
                    context: context,
                    ref: ref,
                    strings: strings,
                    client: client,
                  ),
                )
              : _CalendarView(
                  strings: strings,
                  localeCode: localeCode,
                ),
        ),
      ),
    );
  }
}

class _RegistryList extends ConsumerWidget {
  const _RegistryList({
    required this.strings,
    required this.onClientTap,
  });

  final AppStrings strings;
  final ValueChanged<ClientRegistryEntry> onClientTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientRegistryProvider);

    return clientsAsync.when(
      loading: () => const YbSkeletonList(count: 4),
      error: (error, _) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          YbEmptyState(
            icon: Icons.error_outline_rounded,
            title: strings.clientBookTitle,
            subtitle: '$error',
          ),
        ],
      ),
      data: (clients) {
        if (clients.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              YbEmptyState(
                icon: Icons.menu_book_outlined,
                title: strings.clientBookEmptyTitle,
                subtitle: strings.clientBookEmptySub,
              ),
            ],
          );
        }

        return ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 88),
          itemCount: clients.length,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            color: context.ybColors.borderSubtle,
          ),
          itemBuilder: (context, index) => ClientRegistryListTile(
            client: clients[index],
            onTap: () => onClientTap(clients[index]),
          ),
        );
      },
    );
  }
}

class _CalendarView extends ConsumerWidget {
  const _CalendarView({
    required this.strings,
    required this.localeCode,
  });

  final AppStrings strings;
  final String localeCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingsProvider);

    return bookingsAsync.when(
      loading: () => const YbSkeletonList(count: 4),
      error: (error, _) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          YbEmptyState(
            icon: Icons.error_outline_rounded,
            title: strings.clientBookTitle,
            subtitle: '$error',
          ),
        ],
      ),
      data: (bookings) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 88),
        children: [
          ClientBookCalendar(
            bookings: bookings,
            strings: strings,
            localeCode: localeCode,
            onBookingTap: (booking) => showBookingDetailSheet(
              context: context,
              ref: ref,
              strings: strings,
              booking: booking,
            ),
            onDayTap: (date, _) => showClientBookingSheet(
              context: context,
              ref: ref,
              strings: strings,
              initialSlotStart: DateTime(date.year, date.month, date.day, 9),
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}
