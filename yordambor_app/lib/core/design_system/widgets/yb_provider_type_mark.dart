import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';

/// Who gives a service, at a glance, on its photo: an organisation shows a
/// deep-teal rounded square with a building, like a company logo; a person
/// shows a light circle with a figure, like an avatar. Shape, colour and
/// icon all differ, so the two never read alike on any photo. Long press
/// shows the word; screen readers say it.
class YbProviderTypeMark extends StatelessWidget {
  const YbProviderTypeMark({
    super.key,
    required this.isInstitution,
    required this.label,
    this.size = 40,
  });

  final bool isInstitution;

  /// "Tashkilot" / "Jismoniy shaxs".
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Fixed colours: the mark sits on photos in both themes.
    final fill = isInstitution ? AppColors.primaryDark : AppColors.onPhotoPill;
    final ink = isInstitution ? Colors.white : AppColors.primaryDark;
    final radius = isInstitution
        ? BorderRadius.circular(size * 0.28)
        : BorderRadius.circular(size / 2);

    return Semantics(
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        message: label,
        excludeFromSemantics: true,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: radius,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            isInstitution ? YbIcons.apartmentFilled : YbIcons.personFilled,
            size: size * 0.52,
            color: ink,
          ),
        ),
      ),
    );
  }
}
