import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/category_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/constants/service_cities.dart';
import 'package:yordambor/core/design_system/app_fonts.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_info_tag.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/utils/category_icons.dart';
import 'package:yordambor/core/utils/money_format.dart';

/// The pictures of the introduction and the welcome: real photographs of
/// the kinds of help people find here, laid out as the app shows them.
/// They are pictures only: nothing in them can be tapped, and screen
/// readers skip them (the page's title and line say it all).

/// A photo from the app's bundle, cropped to fill its box.
class ServicePhoto extends StatelessWidget {
  const ServicePhoto(
    this.asset, {
    super.key,
    this.alignment = Alignment.center,
    this.radius = 0,
    this.zoom = 1,
  });

  final String asset;
  final Alignment alignment;
  final double radius;

  /// Closer in on [alignment], for a face in a small circle.
  final double zoom;

  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset(
      asset,
      fit: BoxFit.cover,
      alignment: alignment,
      // Decoded no larger than shown: the pictures are small.
      cacheWidth: 480,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, _, _) =>
          ColoredBox(color: context.ybColors.surface3),
    );
    if (zoom != 1) {
      image = ClipRect(
        child: Transform.scale(
          scale: zoom,
          alignment: alignment,
          child: image,
        ),
      );
    }
    if (radius == 0) return image;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: image,
    );
  }
}

/// The shadow under the floating cards of the pictures.
List<BoxShadow> _float(BuildContext context, {double strength = 1}) {
  final colors = context.ybColors;
  return [
    BoxShadow(
      color: colors.shadow.withValues(alpha: 0.11 * strength),
      blurRadius: 26,
      offset: const Offset(0, 10),
    ),
  ];
}

TextStyle _text(
  BuildContext context, {
  required double size,
  FontWeight weight = FontWeight.w600,
  Color? color,
}) =>
    AppFonts.ui(
      size: size,
      weight: weight,
      height: 1.25,
      color: color ?? context.ybColors.ink,
    );

/// A white card of the pictures.
class _FloatCard extends StatelessWidget {
  const _FloatCard({required this.child, this.padding = EdgeInsets.zero});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    return Container(
      padding: padding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(20),
        border: Theme.of(context).brightness == Brightness.dark
            ? Border.all(color: colors.line)
            : null,
        boxShadow: _float(context),
      ),
      child: child,
    );
  }
}

/// A soft glow of colour behind a picture.
class _Glow extends StatelessWidget {
  const _Glow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 19,
      top: 10,
      width: 320,
      height: 320,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
            stops: const [0.2, 1],
          ),
        ),
      ),
    );
  }
}

/// The kinds of service in the pictures, with their photo, label and
/// category (for the icon colour).
enum ShowcaseService {
  lawyer('assets/demo/corporate_law.jpg', 'legal', YbIcons.gavelFilled,
      Alignment(-0.4, 0)),
  beauty('assets/demo/nails.jpg', 'beauty', YbIcons.spaFilled,
      Alignment.center),
  catering('assets/demo/asal_tovuq.jpg', 'food_culinary',
      YbIcons.restaurantFilled, Alignment.center),
  vet('assets/demo/vet_clinic.jpg', 'veterinary', YbIcons.petsFilled,
      Alignment(-0.2, -0.4)),
  cleaning('assets/demo/cleaning.jpg', 'cleaning',
      YbIcons.cleaningServicesFilled, Alignment(0.2, -0.2)),
  electrician('assets/demo/electrician.jpg', 'home_repair',
      YbIcons.electricalServicesFilled, Alignment(-0.4, 0)),
  dental('assets/demo/dental.jpg', 'health', YbIcons.medicalServicesFilled,
      Alignment.center),
  tutor('assets/demo/english_tutor.jpg', 'education', YbIcons.schoolFilled,
      Alignment.center),
  auto('assets/demo/auto_repair.jpg', 'auto', YbIcons.carRepairFilled,
      Alignment(-0.1, -0.3)),
  renovation('assets/demo/interior_renovation.jpg', 'home_repair',
      YbIcons.constructionFilled, Alignment.center),
  fitness('assets/demo/fitness.jpg', 'sports_fitness',
      YbIcons.fitnessCenterFilled, Alignment(-0.3, 0)),
  translator('assets/demo/translator.jpg', 'personal_services',
      YbIcons.translateFilled, Alignment.center),
  barber('assets/demo/barbershop.jpg', 'beauty', YbIcons.spaFilled,
      Alignment.center),
  music('assets/demo/guitar_lesson.jpg', 'education', YbIcons.schoolFilled,
      Alignment(0.2, 0)),
  stylist('assets/demo/fashion_stylist.jpg', 'fashion_tailoring',
      YbIcons.checkroomFilled, Alignment(0, -0.4)),
  kindergarten('assets/demo/kindergarten.jpg', 'family',
      YbIcons.familyRestroomFilled, Alignment.center);

  const ShowcaseService(this.photo, this.category, this.icon, this.focus);

  final String photo;
  final String category;
  final IconData icon;

  /// Which part of the photo stays in view when it is cropped.
  final Alignment focus;

  String label(AppStrings strings) => switch (this) {
        ShowcaseService.lawyer => strings.onbTileLawyer,
        ShowcaseService.beauty => strings.onbTileBeauty,
        ShowcaseService.catering => strings.onbTileCatering,
        ShowcaseService.vet => strings.onbTileVet,
        ShowcaseService.cleaning => strings.onbTileCleaning,
        ShowcaseService.electrician => strings.onbTileElectrician,
        ShowcaseService.dental => strings.onbTileDental,
        ShowcaseService.tutor => strings.onbTileTutor,
        ShowcaseService.auto => strings.onbTileAuto,
        ShowcaseService.renovation => strings.onbTileRenovation,
        ShowcaseService.fitness => strings.onbTileFitness,
        ShowcaseService.translator => strings.onbTileTranslator,
        ShowcaseService.barber => strings.onbTileBarber,
        ShowcaseService.music => strings.onbTileMusic,
        ShowcaseService.stylist => strings.onbTileStylist,
        ShowcaseService.kindergarten => strings.onbTileKindergarten,
      };
}

/// A photo tile with its label in a light pill: one kind of service.
class ShowcaseTile extends StatelessWidget {
  const ShowcaseTile({super.key, required this.service, required this.label});

  final ShowcaseService service;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tint = CategoryIcons.tint(context, service.category);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: _float(context, strength: 1.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ServicePhoto(service.photo, alignment: service.focus),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(7, 5, 10, 5),
                  decoration: BoxDecoration(
                    color: AppColors.onPhotoPill,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(service.icon, size: 15, color: tint.ink),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _text(
                            context,
                            size: 12.5,
                            color: AppColors.onPhotoInk,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// How many kinds of service the app lists, rounded down to fifty: "350".
int _serviceKinds(WidgetRef ref) {
  final categories = ref.watch(categoriesProvider).valueOrNull;
  if (categories == null) return 0;
  var count = 0;
  for (final category in categories) {
    count += category.subcategories.where((sub) => sub.id != 'other').length;
  }
  return count ~/ 50 * 50;
}

/// Page one: services of every kind, and none of those on the welcome:
/// one large card as in the feed, a pair of smaller ones, then many more
/// kinds as chips.
class OnboardingServicesPreview extends ConsumerWidget {
  const OnboardingServicesPreview({super.key});

  /// Taller than the other pages' canvas: it holds three kinds of block.
  static const canvas = Size(358, 476);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final language = strings.languageCode;
    final kinds = _serviceKinds(ref);

    Widget small(ShowcaseService service, String cityId) {
      return _FloatCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 96,
              child: ServicePhoto(service.photo, alignment: service.focus),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.label(strings),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _text(context, size: 15, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        YbIcons.locationOnFilled,
                        size: 14,
                        color: colors.place,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          strings.serviceCityLabel(cityId),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _text(
                            context,
                            size: 13,
                            weight: FontWeight.w400,
                            color: colors.ink2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget chip(ShowcaseService service) {
      return Container(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 12, 4),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: _float(context, strength: 0.6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 26,
              height: 26,
              child: ClipOval(
                child: ServicePhoto(service.photo, alignment: service.focus),
              ),
            ),
            const SizedBox(width: 6),
            Text(service.label(strings), style: _text(context, size: 13)),
          ],
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _Glow(color: colors.tealSoft),
        // One service large, as in the feed.
        Positioned(
          left: 0,
          top: 0,
          width: 358,
          child: _FloatCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 124,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ServicePhoto(
                        ShowcaseService.tutor.photo,
                        alignment: ShowcaseService.tutor.focus,
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.onPhotoPill,
                            borderRadius:
                                BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: colors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                strings.xizmatTodayFree,
                                style: _text(
                                  context,
                                  size: 13,
                                  color: AppColors.onPhotoInk,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          YbInfoTag(
                            icon: ShowcaseService.tutor.icon,
                            label: strings.onbTileTutor,
                            tone: YbInfoTone.service,
                          ),
                          YbInfoTag(
                            icon: YbIcons.locationOnFilled,
                            label: strings.serviceCityLabel(
                              ServiceCityIds.toshkent,
                            ),
                            tone: YbInfoTone.place,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              strings.onbIllTutorTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: _text(
                                context,
                                size: 16,
                                weight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            formatSom(100000, languageCode: language),
                            style: _text(
                              context,
                              size: 15,
                              weight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Two more, side by side.
        Positioned(
          left: 0,
          top: 222,
          width: 171,
          child: small(ShowcaseService.auto, ServiceCityIds.andijon),
        ),
        Positioned(
          left: 187,
          top: 222,
          width: 171,
          child: small(ShowcaseService.renovation, ServiceCityIds.namangan),
        ),
        // And many kinds besides.
        Positioned(
          left: 0,
          right: 0,
          top: 398,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              chip(ShowcaseService.fitness),
              chip(ShowcaseService.translator),
              chip(ShowcaseService.barber),
              chip(ShowcaseService.music),
              if (kinds > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colors.tealSoft,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    strings.onbKindsChip(kinds),
                    style: _text(
                      context,
                      size: 13,
                      weight: FontWeight.w700,
                      color: colors.tealInk,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Page two: a request (a toothache), and providers answering it.
class OnboardingRequestPreview extends ConsumerWidget {
  const OnboardingRequestPreview({super.key});

  static const canvas = Size(358, 378);

  /// Who answers: a dental clinic and a dentist, seen nowhere else in
  /// the introduction.
  static const _faces = [
    (
      photo: 'assets/demo/dental.jpg',
      focus: Alignment(-0.2, 0.3),
      zoom: 1.8,
    ),
    (
      photo: 'assets/demo/elderly_care.jpg',
      focus: Alignment(0, -0.6),
      zoom: 1.0,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final language = strings.languageCode;

    Widget offer(
      ({String photo, Alignment focus, double zoom}) face,
      String name,
      String message,
      int price,
    ) {
      return _FloatCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: ClipOval(
                child: ServicePhoto(
                  face.photo,
                  alignment: face.focus,
                  zoom: face.zoom,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: _text(context, size: 15, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _text(
                      context,
                      size: 13,
                      weight: FontWeight.w400,
                      color: colors.ink2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              groupThousands(price, languageCode: language),
              style: _text(
                context,
                size: 14,
                weight: FontWeight.w700,
                color: colors.success,
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _Glow(color: colors.apricotSoft),
        Positioned(
          left: 0,
          top: 0,
          width: 358,
          child: _FloatCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.apricotSoft,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        YbIcons.campaignFilled,
                        size: 20,
                        color: colors.apricotInk,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        strings.onbIllDentalRequestTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _text(
                          context,
                          size: 17,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    YbInfoTag(
                      icon: YbIcons.medicalServicesFilled,
                      label: strings.onbTileDentist,
                      tone: YbInfoTone.request,
                    ),
                    YbInfoTag(
                      icon: YbIcons.locationOnFilled,
                      label: strings.serviceCityLabel(ServiceCityIds.toshkent),
                      tone: YbInfoTone.place,
                    ),
                    YbInfoTag(
                      icon: YbIcons.paymentsFilled,
                      label: formatSom(200000, languageCode: language),
                      tone: YbInfoTone.money,
                    ),
                    YbInfoTag(
                      icon: YbIcons.calendarTodayFilled,
                      label: strings.onbIllToday,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // The offers arriving.
        Positioned(
          left: 0,
          right: 0,
          top: 172,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: colors.teal,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                boxShadow: [
                  BoxShadow(
                    color: colors.teal.withValues(alpha: 0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    YbIcons.notificationsActiveFilled,
                    size: 18,
                    color: colors.onTeal,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    strings.onbIllNewOffers,
                    style: _text(context, size: 14, color: colors.onTeal),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 22,
          top: 228,
          width: 336,
          child: offer(
            _faces[0],
            strings.onbTileDental,
            strings.onbIllDentalOffer1,
            180000,
          ),
        ),
        Positioned(
          left: 22,
          top: 306,
          width: 336,
          child: offer(
            _faces[1],
            strings.onbIllName2,
            strings.onbIllDentalOffer2,
            150000,
          ),
        ),
      ],
    );
  }
}

/// Page three: offering services, as an individual or an organization,
/// and the requests and earnings that follow.
class OnboardingOfferPreview extends ConsumerWidget {
  const OnboardingOfferPreview({super.key});

  static const canvas = Size(358, 352);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final language = strings.languageCode;

    Widget provider({
      required ShowcaseService service,
      required String title,
      required String cityId,
      required bool institution,
    }) {
      return _FloatCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 120,
              child: ServicePhoto(service.photo, alignment: service.focus),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  YbInfoTag(
                    icon: institution
                        ? YbIcons.apartmentFilled
                        : YbIcons.personFilled,
                    label: strings.providerTypeLabel(
                      institution ? 'institution' : 'individual',
                    ),
                    tone: institution ? YbInfoTone.place : YbInfoTone.service,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _text(context, size: 16, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    strings.serviceCityLabel(cityId),
                    style: _text(
                      context,
                      size: 13,
                      weight: FontWeight.w400,
                      color: colors.ink2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _Glow(color: colors.tealSoft),
        Positioned(
          left: 4,
          top: 8,
          width: 168,
          child: Transform.rotate(
            angle: -4 * math.pi / 180,
            child: provider(
              service: ShowcaseService.stylist,
              title: strings.onbTileStylist,
              cityId: ServiceCityIds.toshkent,
              institution: false,
            ),
          ),
        ),
        Positioned(
          left: 186,
          top: 24,
          width: 168,
          child: Transform.rotate(
            angle: 4 * math.pi / 180,
            child: provider(
              service: ShowcaseService.kindergarten,
              title: strings.onbTileKindergarten,
              cityId: ServiceCityIds.samarqand,
              institution: true,
            ),
          ),
        ),
        // What follows: earnings, and new requests.
        Positioned(
          left: 8,
          top: 234,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: colors.success,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              boxShadow: [
                BoxShadow(
                  color: colors.success.withValues(alpha: 0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Text(
              '+${formatSom(150000, languageCode: language)}',
              style: _text(
                context,
                size: 14,
                weight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          left: 40,
          top: 282,
          width: 300,
          child: _FloatCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.apricotSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    YbIcons.notificationsActiveFilled,
                    size: 20,
                    color: colors.apricotInk,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.onbIllNewRequest,
                        style: _text(
                          context,
                          size: 15,
                          weight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${strings.onbIllStylistRequest} · '
                        '${strings.onbIllToday}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _text(
                          context,
                          size: 13,
                          weight: FontWeight.w400,
                          color: colors.ink2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The welcome's picture: six kinds of service, from lawyers to cleaning,
/// in a mosaic of photos.
class WelcomeMosaic extends ConsumerWidget {
  const WelcomeMosaic({super.key});

  /// The canvas it is drawn on, scaled to the space it gets.
  static const canvas = Size(358, 310);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);

    Widget tile(ShowcaseService service, Rect at) => Positioned.fromRect(
          rect: at,
          child: ShowcaseTile(service: service, label: service.label(strings)),
        );

    return ExcludeSemantics(
      child: SizedBox.fromSize(
        size: canvas,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            tile(ShowcaseService.lawyer, const Rect.fromLTWH(0, 0, 112, 150)),
            tile(ShowcaseService.beauty, const Rect.fromLTWH(0, 158, 112, 150)),
            tile(
              ShowcaseService.catering,
              const Rect.fromLTWH(121, 22, 116, 126),
            ),
            tile(ShowcaseService.vet, const Rect.fromLTWH(121, 156, 116, 152)),
            tile(
              ShowcaseService.cleaning,
              const Rect.fromLTWH(246, 0, 112, 126),
            ),
            tile(
              ShowcaseService.electrician,
              const Rect.fromLTWH(246, 134, 112, 174),
            ),
          ],
        ),
      ),
    );
  }
}
