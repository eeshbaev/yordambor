import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yordambor/application/providers/feed_filter_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/onboarding_providers.dart';
import 'package:yordambor/core/constants/service_cities.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/presentation/onboarding/widgets/onboarding_previews.dart';
import 'package:yordambor/presentation/onboarding/widgets/yordambor_logo.dart';

enum _Step { services, ask, offer, city }

/// First run: three short pages on what YordamBor is for, each a picture
/// of the app at work with one line under it, then the city. Everyone sees
/// them once, so nothing skips them (the city is optional); registering is
/// never asked for here.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pages = PageController();

  int _index = 0;
  String? _cityId;
  bool _finishing = false;

  static const _steps = _Step.values;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _next() {
    if (_index >= _steps.length - 1) {
      _finish();
      return;
    }
    _goTo(_index + 1);
  }

  void _goTo(int page) {
    if (AppMotion.reduced(context)) {
      _pages.jumpToPage(page);
      return;
    }
    _pages.animateToPage(
      page,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);
    final city = _cityId;
    if (city != null) {
      ref.read(feedFilterProvider.notifier).setServiceCity(city);
    }
    await ref.read(onboardingPrefsProvider.notifier).completeOnboarding();
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;
    final isLast = _index == _steps.length - 1;

    // Back goes to the page before; the introduction itself is not left
    // half seen.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _index > 0) _goTo(_index - 1);
      },
      child: Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                0,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: YbAppBrandTitle(
                  logoSize: 28,
                  style: AppTypography.headline.copyWith(
                    color: colors.ink,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pages,
                itemCount: _steps.length,
                onPageChanged: (page) => setState(() => _index = page),
                itemBuilder: (context, page) => switch (_steps[page]) {
                  _Step.services => _IntroPage(
                      controller: _pages,
                      page: page,
                      title: strings.onbIntro1Title,
                      body: strings.onbIntro1Body,
                      canvas: OnboardingServicesPreview.canvas,
                      preview: const OnboardingServicesPreview(),
                    ),
                  _Step.ask => _IntroPage(
                      controller: _pages,
                      page: page,
                      title: strings.onbIntro2Title,
                      body: strings.onbIntro2Body,
                      canvas: OnboardingRequestPreview.canvas,
                      preview: const OnboardingRequestPreview(),
                    ),
                  _Step.offer => _IntroPage(
                      controller: _pages,
                      page: page,
                      title: strings.onbIntro3Title,
                      body: strings.onbIntro3Body,
                      canvas: OnboardingOfferPreview.canvas,
                      preview: const OnboardingOfferPreview(),
                    ),
                  _Step.city => _CityPage(
                      strings: strings,
                      selectedId: _cityId,
                      onSelected: (id) => setState(
                        () => _cityId = _cityId == id ? null : id,
                      ),
                    ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                children: [
                  _Dots(
                    count: _steps.length,
                    index: _index,
                    label: strings.onbStep(_index + 1, _steps.length),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  YbPrimaryButton(
                    label: isLast ? strings.onbStart : strings.onbNext,
                    isLoading: _finishing,
                    onPressed: _finishing ? null : _next,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

/// One page: a piece of the app on a soft panel, a short title and one
/// line. With a swipe the panel and the words drift a little behind the
/// finger; nothing else moves.
class _IntroPage extends StatelessWidget {
  const _IntroPage({
    required this.controller,
    required this.page,
    required this.title,
    required this.body,
    required this.canvas,
    required this.preview,
  });

  final PageController controller;
  final int page;
  final String title;
  final String body;

  /// The size [preview] is drawn at, before it is scaled to the page.
  final Size canvas;
  final Widget preview;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final width = MediaQuery.sizeOf(context).width;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final position = controller.hasClients &&
                controller.position.hasContentDimensions
            ? controller.page ?? page.toDouble()
            : page.toDouble();
        // -1..1: how far this page is from the middle of the screen.
        final away = (page - position).clamp(-1.0, 1.0);
        return Opacity(
          opacity: 1 - 0.4 * away.abs(),
          child: Transform.translate(
            offset: Offset(away * width * 0.12, 0),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            // The picture, as large as the page allows.
            Expanded(
              child: Center(
                child: FittedBox(
                  child: ExcludeSemantics(
                    child: IgnorePointer(
                      child: SizedBox.fromSize(
                        size: canvas,
                        child: preview,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Semantics(
              header: true,
              child: Text(
                title,
                style: AppTypography.largeTitle.copyWith(color: colors.ink),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              style: AppTypography.bodyRegular.copyWith(color: colors.ink2),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

/// The last page: the city, so the feeds open nearby. Optional.
class _CityPage extends StatelessWidget {
  const _CityPage({
    required this.strings,
    required this.selectedId,
    required this.onSelected,
  });

  final AppStrings strings;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              strings.onbCityTitle,
              style: AppTypography.largeTitle.copyWith(color: colors.ink),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            strings.onbCitySub,
            style: AppTypography.bodyRegular.copyWith(color: colors.ink2),
          ),
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final id in ServiceCityIds.all)
                _CityChip(
                  label: strings.serviceCityLabel(id),
                  selected: selectedId == id,
                  onTap: () => onSelected(id),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Where the person is in the steps: the current one is a longer bar.
class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index, required this.label});

  final int count;
  final int index;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final duration = AppMotion.of(context, AppMotion.quick);

    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: duration,
              curve: AppMotion.quickCurve,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == index ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == index ? colors.teal : colors.line,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
        ],
      ),
    );
  }
}

/// A city to pick, with its pin; chosen, it turns violet like city tags.
class _CityChip extends StatelessWidget {
  const _CityChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: selected ? colors.placeSoft : colors.card,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? colors.place : colors.line,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppTouch.minTarget),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected ? YbIcons.locationOnFilled : YbIcons.locationOn,
                    size: 18,
                    color: selected ? colors.place : colors.ink2,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      style: AppTypography.body.copyWith(
                        color: selected ? colors.placeInk : colors.ink,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
