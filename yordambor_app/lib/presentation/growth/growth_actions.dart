import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yordambor/application/growth/growth_program.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/share/app_share_links.dart';
import 'package:yordambor/core/share/xizmat_share.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/presentation/calendar/widgets/service_availability_sheet.dart';
import 'package:yordambor/presentation/xizmat/create_xizmat_gate.dart';

/// Does what a tip asks: opens the right screen or the share sheet.
Future<void> runGrowthAction(
  BuildContext context,
  WidgetRef ref,
  GrowthAction action,
  List<XizmatFeedItem> services, {
  VoidCallback? onCertificates,
}) async {
  final strings = ref.read(appStringsProvider);
  final target = GrowthProgram.serviceNeeding(action, services);

  switch (action) {
    case GrowthAction.none:
      return;
    case GrowthAction.photos:
    case GrowthAction.price:
    case GrowthAction.description:
      if (target != null) await context.push('/xizmat/${target.id}/manage');
    case GrowthAction.availability:
      if (target != null) {
        await showServiceAvailabilitySheet(context, ref, item: target);
      }
    case GrowthAction.hours:
      // Hours are set inside the service now.
      final service = target ?? (services.isNotEmpty ? services.first : null);
      if (service != null) {
        await showServiceAvailabilitySheet(context, ref, item: service);
      }
    case GrowthAction.calendar:
      context.go('/calendar');
    case GrowthAction.share:
      if (target != null) {
        await XizmatShare.share(
          strings: strings,
          xizmatId: target.id,
          xizmatName: target.serviceDisplayName,
        );
      }
    case GrowthAction.invite:
      await SharePlus.instance.share(
        ShareParams(
          text: strings.growthInviteShareText(AppShareLinks.playStoreLink),
          subject: strings.appName,
        ),
      );
    case GrowthAction.reply:
      await context.push('/kelishuv/incoming');
    case GrowthAction.reviews:
      await context.push('/kelishuv/archive');
    case GrowthAction.tools:
      await context.push('/earnings');
    case GrowthAction.certificates:
      // Certificates are kept inside the service, on its manage screen.
      if (onCertificates != null) {
        onCertificates();
      } else if (services.isNotEmpty) {
        await context.push('/xizmat/${services.first.id}/manage');
      }
    case GrowthAction.moreServices:
      await openCreateXizmat(context, ref);
    case GrowthAction.myServices:
      context.go('/xizmatlarim');
  }
}
