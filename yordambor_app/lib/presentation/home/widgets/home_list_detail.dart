import 'dart:math' as math;
import 'dart:ui' show DisplayFeatureState, DisplayFeatureType;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/core/design_system/app_layout.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/presentation/shared/detail_pane.dart';
import 'package:yordambor/presentation/xizmat/xizmat_profile_screen.dart';
import 'package:yordambor/presentation/yordam_kerak/yordam_kerak_post_screen.dart';

/// Home on wide windows (tablets, foldables open, landscape): the feed on
/// the left and the open card on the right, so browsing never loses the
/// list. On a foldable whose hinge splits the screen, the panes meet at the
/// hinge and nothing sits under it. On phones the feed is the whole page
/// and cards open as pages, as before.
class HomeListDetail extends StatefulWidget {
  const HomeListDetail({super.key, required this.list});

  /// The feed. Kept alive across a fold or unfold.
  final Widget list;

  @override
  State<HomeListDetail> createState() => _HomeListDetailState();
}

class _HomeListDetailState extends State<HomeListDetail> {
  final _controller = DetailPaneController();
  final _listKey = GlobalKey(debugLabel: 'home-list');

  /// Narrowest a pane may be.
  static const _minPane = 320.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = KeyedSubtree(key: _listKey, child: widget.list);
    if (!context.windowClass.isAtLeastExpanded) return list;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final (listWidth, gap) = _split(context, width);
        final colors = context.ybColors;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: listWidth,
              child: DetailPane(controller: _controller, child: list),
            ),
            if (gap > 0)
              SizedBox(width: gap)
            else
              VerticalDivider(width: 1, thickness: 1, color: colors.line),
            Expanded(
              child: ValueListenableBuilder<DetailTarget?>(
                valueListenable: _controller,
                builder: (context, target, _) => AnimatedSwitcher(
                  duration: AppMotion.of(context, AppMotion.quick),
                  child: _DetailPage(
                    key: ValueKey(target),
                    target: target,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// The list pane's width and the gap after it. Along a vertical hinge (or
  /// a half-open fold) when there is one; else about two fifths, between
  /// 360 and 480.
  (double, double) _split(BuildContext context, double width) {
    final window = MediaQuery.sizeOf(context).width;
    // The body ends at the window's right edge; the rail is on the left.
    final bodyLeft = window - width;
    for (final feature in MediaQuery.displayFeaturesOf(context)) {
      final bounds = feature.bounds;
      final vertical = bounds.height >= bounds.width;
      final separates = feature.type == DisplayFeatureType.hinge ||
          feature.state == DisplayFeatureState.postureHalfOpened;
      if (feature.type == DisplayFeatureType.cutout) continue;
      if (!vertical || !separates) continue;
      final left = bounds.left - bodyLeft;
      if (left >= _minPane && width - (left + bounds.width) >= _minPane) {
        return (left, bounds.width);
      }
    }
    final share = math.min(math.max(width * 0.4, 360.0), 480.0);
    return (math.min(share, width - _minPane), 0.0);
  }
}

/// The open card, or a quiet "pick a card" when nothing is open. Heroes are
/// off here: the same photo is already in the list beside it.
class _DetailPage extends ConsumerWidget {
  const _DetailPage({super.key, required this.target});

  final DetailTarget? target;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final target = this.target;
    if (target == null) {
      final strings = ref.watch(appStringsProvider);
      return ColoredBox(
        color: context.ybColors.surface,
        child: Center(
          child: YbEmptyState(
            icon: YbIcons.touchApp,
            title: strings.detailPaneEmptyTitle,
            subtitle: strings.detailPaneEmptyBody,
          ),
        ),
      );
    }
    return HeroMode(
      enabled: false,
      child: switch (target.kind) {
        DetailKind.xizmat => XizmatProfileScreen(xizmatId: target.id),
        DetailKind.post => YordamKerakPostScreen(postId: target.id),
      },
    );
  }
}
