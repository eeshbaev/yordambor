import 'package:flutter/material.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/core/l10n/app_strings.dart';

/// Asks before declining an offer, with room for an optional reason that
/// stays visible in the deal. Returns the reason ('' for none), or null
/// when the person keeps the offer.
Future<String?> showDeclineOfferSheet(
  BuildContext context,
  AppStrings strings,
) {
  return showModalBottomSheet<String>(
    sheetAnimationStyle: AppMotion.sheetOf(context),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => _DeclineOfferSheet(strings: strings),
  );
}

class _DeclineOfferSheet extends StatefulWidget {
  const _DeclineOfferSheet({required this.strings});

  final AppStrings strings;

  @override
  State<_DeclineOfferSheet> createState() => _DeclineOfferSheetState();
}

class _DeclineOfferSheetState extends State<_DeclineOfferSheet> {
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;

    return YbSheetBody(
      title: strings.dealRejectTitle,
      subtitle: strings.dealRejectBody,
      children: [
        TextField(
          controller: _comment,
          autofocus: true,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: strings.dealRejectCommentLabel,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        YbPrimaryButton(
          label: strings.kelishuvReject,
          tone: YbButtonTone.danger,
          onPressed: () => Navigator.of(context).pop(_comment.text.trim()),
        ),
        const SizedBox(height: AppSpacing.sm),
        YbSecondaryButton(
          label: strings.actionCancel,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
