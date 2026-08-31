import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/client_book/provider_tools_service.dart';

typedef ClientBookDayTap = void Function(
  DateTime date,
  List<BookingWithClient> dayBookings,
);

class ClientBookCalendar extends StatefulWidget {
  const ClientBookCalendar({
    super.key,
    required this.bookings,
    required this.strings,
    required this.localeCode,
    required this.onBookingTap,
    required this.onDayTap,
  });

  final List<BookingWithClient> bookings;
  final AppStrings strings;
  final String localeCode;
  final ValueChanged<BookingWithClient> onBookingTap;
  final ClientBookDayTap onDayTap;

  @override
  State<ClientBookCalendar> createState() => _ClientBookCalendarState();
}

class _ClientBookCalendarState extends State<ClientBookCalendar> {
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _visibleMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final daysInMonth = DateUtils.getDaysInMonth(
      _visibleMonth.year,
      _visibleMonth.month,
    );
    final firstWeekday =
        DateTime(_visibleMonth.year, _visibleMonth.month).weekday;
    final leadingEmpty = firstWeekday - 1;
    final busyDays = _busyDayKeys();
    final today = DateUtils.dateOnly(DateTime.now());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() {
                  _visibleMonth = DateTime(
                    _visibleMonth.year,
                    _visibleMonth.month - 1,
                  );
                }),
                icon: Icon(Icons.chevron_left_rounded, color: colors.textPrimary),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM(widget.localeCode).format(_visibleMonth),
                  textAlign: TextAlign.center,
                  style: AppTypography.headline.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() {
                  _visibleMonth = DateTime(
                    _visibleMonth.year,
                    _visibleMonth.month + 1,
                  );
                }),
                icon:
                    Icon(Icons.chevron_right_rounded, color: colors.textPrimary),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            widget.strings.clientBookCalendarHint,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            children: _weekdayLabels(widget.localeCode)
                .map((label) => _WeekdayLabel(label))
                .toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
            ),
            itemCount: leadingEmpty + daysInMonth,
            itemBuilder: (context, index) {
              if (index < leadingEmpty) return const SizedBox.shrink();

              final day = index - leadingEmpty + 1;
              final date =
                  DateTime(_visibleMonth.year, _visibleMonth.month, day);
              final dateOnly = DateUtils.dateOnly(date);
              final key = _dayKey(date);
              final isBusy = busyDays.contains(key);
              final isToday = dateOnly == today;
              final dayBookings = widget.bookings
                  .where((item) => _dayKey(item.slotStart) == key)
                  .toList();

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _handleDayTap(context, date, dayBookings),
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: isBusy ? colors.primaryMuted : colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(AppRadius.chip),
                      border: Border.all(
                        color: isToday
                            ? AppColors.primary
                            : isBusy
                                ? AppColors.primary
                                : colors.borderSubtle,
                        width: isToday ? 1.5 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$day',
                          style: AppTypography.body.copyWith(
                            color: colors.textPrimary,
                            fontWeight:
                                isToday ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        if (isBusy)
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Set<String> _busyDayKeys() {
    return widget.bookings.map((item) => _dayKey(item.slotStart)).toSet();
  }

  String _dayKey(DateTime date) => '${date.year}-${date.month}-${date.day}';

  List<String> _weekdayLabels(String localeCode) {
    final monday = DateTime(2024, 1, 1);
    return List.generate(
      7,
      (index) => DateFormat.E(localeCode).format(
        monday.add(Duration(days: index)),
      ),
    );
  }

  void _handleDayTap(
    BuildContext context,
    DateTime date,
    List<BookingWithClient> dayBookings,
  ) {
    if (dayBookings.isEmpty) {
      widget.onDayTap(date, dayBookings);
      return;
    }
    _showDaySheet(context, date, dayBookings);
  }

  void _showDaySheet(
    BuildContext context,
    DateTime date,
    List<BookingWithClient> bookings,
  ) {
    final colors = context.ybColors;
    final title = DateFormat.yMMMd(widget.localeCode).format(date);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) => YbSheetBody(
        title: title,
        children: [
          for (var i = 0; i < bookings.length; i++) ...[
            if (i > 0) Divider(height: 1, color: colors.borderSubtle),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  widget.onBookingTap(bookings[i]);
                },
                borderRadius: BorderRadius.circular(AppRadius.chip),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookings[i].clientName,
                              style: AppTypography.headline.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              _formatTime(bookings[i].slotStart),
                              style: AppTypography.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: colors.textTertiary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          YbPrimaryButton(
            label: widget.strings.clientBookBookDay,
            onPressed: () {
              Navigator.pop(context);
              widget.onDayTap(date, bookings);
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    return DateFormat.Hm(widget.localeCode).format(date);
  }
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Expanded(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTypography.caption.copyWith(color: colors.textTertiary),
      ),
    );
  }
}
