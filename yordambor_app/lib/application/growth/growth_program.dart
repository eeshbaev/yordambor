import 'package:flutter/widgets.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';

/// Who the 30-day program speaks to: a person giving a service, or an
/// organisation.
enum GrowthTrack { individual, institution }

/// What a tip asks the person to do, one tap away.
enum GrowthAction {
  none,
  photos,
  price,
  availability,
  hours,
  share,
  invite,
  reply,
  description,
  reviews,
  calendar,
  tools,
  certificates,
  moreServices,
  myServices,
}

/// One message of the program: shown in the app from its [day] on, and sent
/// as a notification that morning unless it is already done.
class GrowthTip {
  const GrowthTip(
    this.id,
    this.day,
    this.icon,
    this.action, {
    this.promo = false,
  });

  final String id;

  /// Days after the first service was added.
  final int day;
  final IconData icon;
  final GrowthAction action;

  /// Invites clients to YordamBor.
  final bool promo;
}

/// "Grow your business": a month of short, useful notes after someone adds
/// their first service, separate for people and organisations. About two a
/// week, front-loaded while they set up, each with one next step; tips
/// already done are not sent.
abstract final class GrowthProgram {
  static const days = 30;

  /// Notes arrive late in the morning, when people plan their day.
  static const sendHour = 11;

  static const individual = <GrowthTip>[
    GrowthTip('i00', 0, YbIcons.celebrationFilled, GrowthAction.none),
    GrowthTip('i01', 1, YbIcons.addAPhotoFilled, GrowthAction.photos),
    GrowthTip('i02', 3, YbIcons.paymentsFilled, GrowthAction.price),
    GrowthTip('i03', 5, YbIcons.boltFilled, GrowthAction.availability),
    GrowthTip(
      'i04',
      7,
      YbIcons.campaignFilled,
      GrowthAction.share,
      promo: true,
    ),
    GrowthTip('i05', 10, YbIcons.timerFilled, GrowthAction.reply),
    GrowthTip('i06', 13, YbIcons.editNoteFilled, GrowthAction.description),
    GrowthTip('i07', 16, YbIcons.starsFilled, GrowthAction.reviews),
    GrowthTip(
      'i08',
      20,
      YbIcons.diversity3Filled,
      GrowthAction.invite,
      promo: true,
    ),
    GrowthTip('i09', 23, YbIcons.calendarMonthFilled, GrowthAction.calendar),
    GrowthTip('i10', 27, YbIcons.savingsFilled, GrowthAction.tools),
    GrowthTip(
      'i11',
      30,
      YbIcons.rocketLaunchFilled,
      GrowthAction.share,
      promo: true,
    ),
  ];

  static const institution = <GrowthTip>[
    GrowthTip('o00', 0, YbIcons.celebrationFilled, GrowthAction.none),
    GrowthTip('o01', 1, YbIcons.addAPhotoFilled, GrowthAction.photos),
    GrowthTip('o02', 3, YbIcons.paymentsFilled, GrowthAction.price),
    GrowthTip('o03', 5, YbIcons.scheduleFilled, GrowthAction.hours),
    GrowthTip(
      'o04',
      7,
      YbIcons.campaignFilled,
      GrowthAction.share,
      promo: true,
    ),
    GrowthTip('o05', 10, YbIcons.verifiedFilled, GrowthAction.certificates),
    GrowthTip('o06', 13, YbIcons.gridViewFilled, GrowthAction.moreServices),
    GrowthTip('o07', 16, YbIcons.supportAgentFilled, GrowthAction.reply),
    GrowthTip('o08', 20, YbIcons.starsFilled, GrowthAction.reviews),
    GrowthTip(
      'o09',
      23,
      YbIcons.iosShareFilled,
      GrowthAction.share,
      promo: true,
    ),
    GrowthTip('o10', 27, YbIcons.receiptLongFilled, GrowthAction.tools),
    GrowthTip('o11', 30, YbIcons.emojiEventsFilled, GrowthAction.myServices),
  ];

  static List<GrowthTip> tipsFor(GrowthTrack track) =>
      track == GrowthTrack.institution ? institution : individual;

  /// The track of the person's first service.
  static GrowthTrack trackOf(List<XizmatFeedItem> services) {
    final first = [...services]..sort(
        (a, b) => (a.createdAt ?? DateTime(2100))
            .compareTo(b.createdAt ?? DateTime(2100)),
      );
    return first.isNotEmpty && first.first.providerType == 'institution'
        ? GrowthTrack.institution
        : GrowthTrack.individual;
  }

  /// The tip already done: nothing to send about it.
  static bool isDone(GrowthAction action, List<XizmatFeedItem> services) {
    if (services.isEmpty) return false;
    return switch (action) {
      GrowthAction.photos =>
        services.every((item) => item.galleryUrls.length >= 3),
      GrowthAction.price => services.every(
          (item) => item.pricingModel.hasAmount && (item.basePrice ?? 0) > 0,
        ),
      GrowthAction.availability =>
        services.any((item) => item.availabilityVisible),
      GrowthAction.description => services.every(
          (item) => (item.aboutText ?? '').trim().length >= 120,
        ),
      GrowthAction.moreServices => services.length >= 2,
      _ => false,
    };
  }

  /// The first service that still needs what [action] asks for.
  static XizmatFeedItem? serviceNeeding(
    GrowthAction action,
    List<XizmatFeedItem> services,
  ) {
    for (final item in services) {
      if (!isDone(action, [item])) return item;
    }
    return services.isEmpty ? null : services.first;
  }

  static String title(AppStrings s, String id) => switch (id) {
        'i00' => s.growthI00Title,
        'i01' => s.growthI01Title,
        'i02' => s.growthI02Title,
        'i03' => s.growthI03Title,
        'i04' => s.growthI04Title,
        'i05' => s.growthI05Title,
        'i06' => s.growthI06Title,
        'i07' => s.growthI07Title,
        'i08' => s.growthI08Title,
        'i09' => s.growthI09Title,
        'i10' => s.growthI10Title,
        'i11' => s.growthI11Title,
        'o00' => s.growthO00Title,
        'o01' => s.growthO01Title,
        'o02' => s.growthO02Title,
        'o03' => s.growthO03Title,
        'o04' => s.growthO04Title,
        'o05' => s.growthO05Title,
        'o06' => s.growthO06Title,
        'o07' => s.growthO07Title,
        'o08' => s.growthO08Title,
        'o09' => s.growthO09Title,
        'o10' => s.growthO10Title,
        'o11' => s.growthO11Title,
        _ => s.growthProgramTitle,
      };

  static String body(AppStrings s, String id) => switch (id) {
        'i00' => s.growthI00Body,
        'i01' => s.growthI01Body,
        'i02' => s.growthI02Body,
        'i03' => s.growthI03Body,
        'i04' => s.growthI04Body,
        'i05' => s.growthI05Body,
        'i06' => s.growthI06Body,
        'i07' => s.growthI07Body,
        'i08' => s.growthI08Body,
        'i09' => s.growthI09Body,
        'i10' => s.growthI10Body,
        'i11' => s.growthI11Body,
        'o00' => s.growthO00Body,
        'o01' => s.growthO01Body,
        'o02' => s.growthO02Body,
        'o03' => s.growthO03Body,
        'o04' => s.growthO04Body,
        'o05' => s.growthO05Body,
        'o06' => s.growthO06Body,
        'o07' => s.growthO07Body,
        'o08' => s.growthO08Body,
        'o09' => s.growthO09Body,
        'o10' => s.growthO10Body,
        'o11' => s.growthO11Body,
        _ => '',
      };

  /// The button under a tip; null when there is nothing to do.
  static String? actionLabel(AppStrings s, GrowthAction action) =>
      switch (action) {
        GrowthAction.none => null,
        GrowthAction.photos => s.growthActionPhotos,
        GrowthAction.price => s.growthActionPrice,
        GrowthAction.availability => s.growthActionAvailability,
        GrowthAction.hours => s.growthActionHours,
        GrowthAction.share => s.growthActionShare,
        GrowthAction.invite => s.growthActionInvite,
        GrowthAction.reply => s.growthActionReply,
        GrowthAction.description => s.growthActionDescription,
        GrowthAction.reviews => s.growthActionReviews,
        GrowthAction.calendar => s.growthActionCalendar,
        GrowthAction.tools => s.growthActionTools,
        GrowthAction.certificates => s.growthActionCertificates,
        GrowthAction.moreServices => s.growthActionMoreServices,
        GrowthAction.myServices => s.growthActionMyServices,
      };
}
