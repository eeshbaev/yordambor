import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/l10n/app_strings.dart';

enum AppReviewSheetResult {
  lovingIt,
  notReally,
  notNow,
}

Future<AppReviewSheetResult?> showAppReviewSheet(
  BuildContext context,
  AppStrings strings,
) {
  return showModalBottomSheet<AppReviewSheetResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => AppReviewSheet(strings: strings),
  );
}

class AppReviewSheet extends StatelessWidget {
  const AppReviewSheet({super.key, required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return YbSheetBody(
      title: strings.appReviewTitle,
      subtitle: strings.appReviewSubtitle,
      children: [
        YbPrimaryButton(
          label: strings.appReviewYes,
          onPressed: () =>
              Navigator.pop(context, AppReviewSheetResult.lovingIt),
        ),
        const SizedBox(height: AppSpacing.sm),
        YbSecondaryButton(
          label: strings.appReviewNo,
          onPressed: () =>
              Navigator.pop(context, AppReviewSheetResult.notReally),
        ),
        TextButton(
          onPressed: () =>
              Navigator.pop(context, AppReviewSheetResult.notNow),
          child: Text(strings.appReviewLater),
        ),
      ],
    );
  }
}
