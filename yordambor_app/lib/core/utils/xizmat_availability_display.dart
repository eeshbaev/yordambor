import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/xizmat_availability_mode.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';

class XizmatAvailabilityDisplay {
  const XizmatAvailabilityDisplay({
    required this.label,
    required this.tone,
    required this.mode,
  });

  final String label;
  final YbStatusTone tone;
  final XizmatAvailabilityMode mode;
}

bool isXizmatAvailabilityActive(
  XizmatFeedItem item, {
  DateTime? now,
}) {
  final clock = now ?? DateTime.now();
  if (!item.availabilityVisible || item.availabilityMode == null) {
    return false;
  }
  if (item.availabilityUntil != null && clock.isAfter(item.availabilityUntil!)) {
    return false;
  }
  if (item.availabilityFrom != null && clock.isBefore(item.availabilityFrom!)) {
    return false;
  }
  return true;
}

String formatAvailabilityTime(DateTime dateTime) {
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

XizmatAvailabilityDisplay? xizmatAvailabilityDisplay(
  XizmatFeedItem item,
  AppStrings strings, {
  DateTime? now,
}) {
  if (!isXizmatAvailabilityActive(item, now: now)) return null;

  final mode = item.availabilityMode!;
  final baseLabel = switch (mode) {
    XizmatAvailabilityMode.availableNow => strings.xizmatAvailabilityAvailableNow,
    XizmatAvailabilityMode.busy => strings.xizmatAvailabilityBusy,
    XizmatAvailabilityMode.callMe => strings.xizmatAvailabilityCallMe,
  };

  final tone = switch (mode) {
    XizmatAvailabilityMode.availableNow => YbStatusTone.success,
    XizmatAvailabilityMode.busy => YbStatusTone.warning,
    XizmatAvailabilityMode.callMe => YbStatusTone.primary,
  };

  final from = item.availabilityFrom;
  final until = item.availabilityUntil;
  String suffix = '';
  if (mode != XizmatAvailabilityMode.callMe) {
    if (from != null && until != null) {
      suffix = strings.xizmatAvailabilityRangeSuffix(
        formatAvailabilityTime(from),
        formatAvailabilityTime(until),
      );
    } else if (until != null) {
      suffix = strings.xizmatAvailabilityUntilSuffix(
        formatAvailabilityTime(until),
      );
    } else if (from != null) {
      suffix = strings.xizmatAvailabilityFromSuffix(
        formatAvailabilityTime(from),
      );
    }
  }

  return XizmatAvailabilityDisplay(
    label: '$baseLabel$suffix',
    tone: tone,
    mode: mode,
  );
}

String? userProfileAvailabilitySummary(
  List<XizmatFeedItem> items,
  AppStrings strings,
) {
  if (items.isEmpty) return null;

  var availableCount = 0;
  var busyCount = 0;

  for (final item in items) {
    final display = xizmatAvailabilityDisplay(item, strings);
    if (display == null) continue;
    switch (display.mode) {
      case XizmatAvailabilityMode.availableNow:
      case XizmatAvailabilityMode.callMe:
        availableCount++;
      case XizmatAvailabilityMode.busy:
        busyCount++;
    }
  }

  final activeCount = availableCount + busyCount;
  if (activeCount == 0) return null;
  if (busyCount == 0) return strings.userProfileAvailable;
  if (availableCount == 0) return strings.userProfileBusy;
  return strings.userProfilePartiallyBusy;
}
