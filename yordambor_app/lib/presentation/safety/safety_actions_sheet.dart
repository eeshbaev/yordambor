import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/feed_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/safety_providers.dart';
import 'package:yordambor/application/providers/yordam_kerak_provider.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_confirm_dialog.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_sheet_body.dart';
import 'package:yordambor/data/safety/block_repository.dart';
import 'package:yordambor/data/safety/report_repository.dart';

Future<void> showSafetyActionsSheet(
  BuildContext context,
  WidgetRef ref, {
  required String targetUserId,
  String? targetUserName,
  ReportTargetType reportType = ReportTargetType.profile,
  required String reportTargetId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (context) => _SafetyActionsSheet(
      targetUserId: targetUserId,
      targetUserName: targetUserName,
      reportType: reportType,
      reportTargetId: reportTargetId,
    ),
  );
}

class _SafetyActionsSheet extends ConsumerStatefulWidget {
  const _SafetyActionsSheet({
    required this.targetUserId,
    required this.reportType,
    required this.reportTargetId,
    this.targetUserName,
  });

  final String targetUserId;
  final String? targetUserName;
  final ReportTargetType reportType;
  final String reportTargetId;

  @override
  ConsumerState<_SafetyActionsSheet> createState() =>
      _SafetyActionsSheetState();
}

class _SafetyActionsSheetState extends ConsumerState<_SafetyActionsSheet> {
  final _reasonController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _block() async {
    final strings = ref.read(appStringsProvider);
    final name = widget.targetUserName ?? strings.genericUser;
    final ok = await showYbConfirmDialog(
      context,
      title: strings.safetyBlock,
      message: strings.safetyBlockConfirmMessage(name),
      confirmLabel: strings.safetyBlock,
      isDestructive: true,
    );
    if (!ok || !mounted) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await ref.read(blockRepositoryProvider).blockUser(widget.targetUserId);
      ref.invalidate(blockedUserIdsProvider);
      ref.invalidate(blockedUsersProvider);
      ref.read(feedProvider.notifier).load();
      ref.read(yordamKerakFeedProvider.notifier).load();
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.safetyBlockDone)),
        );
      }
    } on BlockFailure catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _report() async {
    final strings = ref.read(appStringsProvider);
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await ref.read(reportRepositoryProvider).submit(
            targetType: widget.reportType,
            targetId: widget.reportTargetId,
            reason: _reasonController.text,
          );
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(strings.safetyReportDone)),
        );
      }
    } on ReportFailure catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final colors = context.ybColors;

    return YbSheetBody(
      title: strings.safetyTitle,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isSubmitting ? null : _block,
            borderRadius: BorderRadius.circular(AppRadius.chip),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Row(
                children: [
                  Icon(Icons.block_rounded, color: AppColors.error),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.safetyBlock,
                          style: AppTypography.headline.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          widget.targetUserName ?? strings.safetyHideUser,
                          style: AppTypography.caption.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
                ],
              ),
            ),
          ),
        ),
        const Divider(height: AppSpacing.xxxl),
        TextField(
          controller: _reasonController,
          enabled: !_isSubmitting,
          decoration: InputDecoration(
            labelText: strings.safetyReportReason,
            hintText: strings.safetyReportHint,
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: AppSpacing.md),
          YbInlineMessage(message: _errorMessage!),
        ],
        const SizedBox(height: AppSpacing.xl),
        YbPrimaryButton(
          label: strings.safetyReportSubmit,
          isLoading: _isSubmitting,
          onPressed: _isSubmitting ? null : _report,
        ),
      ],
    );
  }
}
