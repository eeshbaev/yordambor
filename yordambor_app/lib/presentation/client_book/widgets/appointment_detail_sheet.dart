import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/provider_tools_sync.dart';
import 'package:yordambor/application/providers/reminder_providers.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/data/client_book/provider_tools_service.dart';
import 'package:yordambor/domain/entities/reminder.dart';
import 'package:yordambor/presentation/reminders/widgets/appointment_status_chip.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_status_sheet.dart';
import 'package:yordambor/presentation/shared/appointment_date_format.dart';

Future<void> showBookingDetailSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppStrings strings,
  required BookingWithClient booking,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => _BookingDetailSheet(
      ref: ref,
      strings: strings,
      booking: booking,
    ),
  );
}

class _BookingDetailSheet extends ConsumerStatefulWidget {
  const _BookingDetailSheet({
    required this.ref,
    required this.strings,
    required this.booking,
  });

  final WidgetRef ref;
  final AppStrings strings;
  final BookingWithClient booking;

  @override
  ConsumerState<_BookingDetailSheet> createState() =>
      _BookingDetailSheetState();
}

class _BookingDetailSheetState extends ConsumerState<_BookingDetailSheet> {
  late final TextEditingController _notesController;
  late BookingWithClient _booking;
  Reminder? _reminder;
  bool _loadingReminder = true;
  bool _savingNotes = false;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
    _notesController = TextEditingController(
      text: _booking.booking.appointmentNotes ?? '',
    );
    _loadReminder();
  }

  Future<void> _loadReminder() async {
    final reminder = await ref
        .read(remindersRepositoryProvider)
        .fetchByBookingId(_booking.booking.id);
    if (!mounted) return;
    setState(() {
      _reminder = reminder;
      _loadingReminder = false;
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveNotes() async {
    if (_savingNotes) return;
    setState(() => _savingNotes = true);
    final updated = await ref
        .read(providerToolsServiceProvider)
        .updateBookingAppointmentNotes(
          bookingId: _booking.booking.id,
          appointmentNotes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );
    if (updated != null && mounted) {
      setState(() {
        _booking = BookingWithClient(
          booking: updated,
          client: _booking.client,
        );
      });
      invalidateProviderTools(ref);
    }
    if (mounted) setState(() => _savingNotes = false);
  }

  Future<void> _addPhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null || !mounted) return;

    final updated = await ref.read(providerToolsServiceProvider).addBookingPhoto(
          bookingId: _booking.booking.id,
          sourcePath: image.path,
        );
    if (updated != null && mounted) {
      setState(() {
        _booking = BookingWithClient(
          booking: updated,
          client: _booking.client,
        );
      });
      invalidateProviderTools(ref);
    }
  }

  Future<void> _removePhoto(String path) async {
    final updated =
        await ref.read(providerToolsServiceProvider).removeBookingPhoto(
              bookingId: _booking.booking.id,
              photoPath: path,
            );
    if (updated != null && mounted) {
      setState(() {
        _booking = BookingWithClient(
          booking: updated,
          client: _booking.client,
        );
      });
      invalidateProviderTools(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final strings = widget.strings;
    final booking = _booking.booking;
    final kelishuvId = booking.kelishuvId;

    return YbSheetBody(
      title: _booking.clientName,
      children: [
        Text(
          formatAppointmentDateTime(booking.slotStart),
          style: AppTypography.body.copyWith(color: colors.textSecondary),
        ),
        if (booking.xizmatName != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            booking.xizmatName!,
            style: AppTypography.body.copyWith(color: colors.textPrimary),
          ),
        ],
        if (booking.note != null && booking.note!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            booking.note!,
            style: AppTypography.body.copyWith(color: colors.textPrimary),
          ),
        ],
        if (!_loadingReminder && _reminder != null) ...[
          const SizedBox(height: AppSpacing.md),
          AppointmentStatusChip(status: _reminder!.status, strings: strings),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(
          strings.clientBookAppointmentNotesLabel,
          style: AppTypography.label.copyWith(color: colors.textTertiary),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: strings.clientBookAppointmentNotesLabel,
            border: const OutlineInputBorder(),
          ),
          onEditingComplete: _saveNotes,
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _savingNotes ? null : _saveNotes,
            child: Text(strings.actionSave),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Text(
              strings.clientBookPhotosLabel,
              style: AppTypography.label.copyWith(color: colors.textTertiary),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _addPhoto,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
              label: Text(strings.clientBookAddPhoto),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (booking.photoPaths.isEmpty)
          Text(
            strings.clientBookPhotosEmpty,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          )
        else
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: booking.photoPaths.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final path = booking.photoPaths[index];
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      child: Image.file(
                        File(path),
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: IconButton.filledTonal(
                        visualDensity: VisualDensity.compact,
                        iconSize: 16,
                        onPressed: () => _removePhoto(path),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        if (_reminder != null) ...[
          const SizedBox(height: AppSpacing.lg),
          YbSecondaryButton(
            label: strings.remindersUpdateStatus,
            onPressed: () async {
              Navigator.pop(context);
              await showReminderStatusSheet(
                context: context,
                ref: ref,
                strings: strings,
                reminder: _reminder!,
              );
            },
          ),
        ],
        if (kelishuvId != null) ...[
          const SizedBox(height: AppSpacing.sm),
          YbPrimaryButton(
            label: strings.clientBookOpenDeal,
            onPressed: () {
              Navigator.pop(context);
              context.push('/kelishuv/$kelishuvId');
            },
          ),
        ],
      ],
    );
  }
}
