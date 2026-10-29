import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_haptics.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';

/// Seven round toggles, Monday first: the days someone works. [days] holds
/// 1 = Monday … 7 = Sunday; [shortNames] the seven short names, Monday
/// first. Weekend days sit in a softer tone until picked.
class WeekdayPicker extends StatelessWidget {
  const WeekdayPicker({
    super.key,
    required this.days,
    required this.shortNames,
    required this.onChanged,
  });

  final List<int> days;
  final List<String> shortNames;
  final ValueChanged<List<int>> onChanged;

  void _toggle(int day) {
    AppHaptics.select();
    final next = {...days};
    if (!next.remove(day)) next.add(day);
    onChanged(next.toList()..sort());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final duration = AppMotion.of(context, AppMotion.quick);

    return Row(
      children: [
        for (var day = 1; day <= 7; day++) ...[
          if (day > 1) const SizedBox(width: 6),
          Expanded(
            child: Semantics(
              button: true,
              toggled: days.contains(day),
              label: shortNames.length == 7 ? shortNames[day - 1] : '$day',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _toggle(day),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: AnimatedContainer(
                    duration: duration,
                    curve: AppMotion.snap,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: days.contains(day) ? colors.teal : colors.card,
                      border: Border.all(
                        color: days.contains(day)
                            ? colors.teal
                            : colors.borderSubtle,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: ExcludeSemantics(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            shortNames.length == 7
                                ? shortNames[day - 1]
                                : '$day',
                            style: AppTypography.label.copyWith(
                              color: days.contains(day)
                                  ? colors.onTeal
                                  : day >= 6
                                      ? colors.ink3
                                      : colors.ink,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
