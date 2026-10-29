import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/app_fonts.dart';

/// One destination of the tab bar.
class FloatingTabItem {
  const FloatingTabItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final Widget icon;
  final Widget selectedIcon;
  final String label;
}

/// The bottom tab bar. One indicator slides from tab to tab while the icons
/// cross-fade to their filled form: a single, even motion, nothing bounces.
/// Labels keep one weight in both states, so they never shift.
class FloatingTabBar extends StatelessWidget {
  const FloatingTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<FloatingTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const double _height = 68;
  static const double _indicatorTop = 8;
  static const Size _indicator = Size(64, 32);
  static const Duration _slide = Duration(milliseconds: 320);

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final still = AppMotion.reduced(context);
    final duration = still ? Duration.zero : _slide;
    final rtl = Directionality.of(context) == TextDirection.rtl;

    // Labels grow with the text size up to 1.3, and the bar with them.
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: Builder(
        builder: (context) {
          final labelScale = MediaQuery.textScalerOf(context).scale(12) / 12;
          final height = _height + (labelScale - 1) * 16;

          return SizedBox(
            height: height,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final slot = constraints.maxWidth / items.length;
                final width = math.min(_indicator.width, slot - 8);
                final position =
                    rtl ? items.length - 1 - selectedIndex : selectedIndex;

                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: duration,
                      curve: Curves.easeOutCubic,
                      top: _indicatorTop,
                      left: slot * position + (slot - width) / 2,
                      width: width,
                      height: _indicator.height,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.tealSoft,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (final (index, item) in items.indexed)
                          Expanded(
                            child: _Destination(
                              item: item,
                              selected: index == selectedIndex,
                              duration: duration,
                              onTap: () => onSelected(index),
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _Destination extends StatelessWidget {
  const _Destination({
    required this.item,
    required this.selected,
    required this.duration,
    required this.onTap,
  });

  final FloatingTabItem item;
  final bool selected;
  final Duration duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final iconSwap = Duration(milliseconds: duration.inMilliseconds ~/ 2);

    return MergeSemantics(
      child: Semantics(
        button: true,
        selected: selected,
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: Column(
            children: [
              const SizedBox(height: FloatingTabBar._indicatorTop),
              SizedBox(
                height: FloatingTabBar._indicator.height,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: iconSwap,
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: KeyedSubtree(
                      key: ValueKey<bool>(selected),
                      child: IconTheme.merge(
                        data: IconThemeData(
                          size: 24,
                          color: selected ? colors.tealInk : colors.ink2,
                        ),
                        child: selected ? item.selectedIcon : item.icon,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: AnimatedDefaultTextStyle(
                  duration: duration,
                  curve: Curves.easeOutCubic,
                  style: AppFonts.ui(
                    size: 12,
                    weight: FontWeight.w600,
                    height: 16 / 12,
                    color: selected ? colors.teal : colors.ink2,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
