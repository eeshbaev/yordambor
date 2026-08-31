import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/growth_providers.dart';
import 'package:yordambor/application/providers/app_review_service.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/client_book_providers.dart';
import 'package:yordambor/application/providers/provider_tools_sync.dart';
import 'package:yordambor/presentation/kelishuv/kelishuv_appointment_sheet.dart';
import 'package:yordambor/presentation/reminders/widgets/reminder_status_actions.dart';
import 'package:yordambor/application/providers/review_providers.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/core/l10n/app_strings.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_confirm_dialog.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/data/kelishuv/kelishuv_repository.dart';
import 'package:yordambor/data/safety/report_repository.dart';
import 'package:yordambor/domain/growth/app_review_prompt.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/entities/kelishuv_message.dart';
import 'package:yordambor/presentation/kelishuv/edit_kelishuv_terms_sheet.dart';
import 'package:yordambor/presentation/kelishuv/kelishuv_realtime_listener.dart';
import 'package:yordambor/presentation/kelishuv/repeat_booking_flow.dart';
import 'package:yordambor/presentation/kelishuv/review_sheet.dart';
import 'package:yordambor/presentation/shared/yb_safety_banner.dart';
import 'package:yordambor/presentation/safety/safety_actions_sheet.dart';

class KelishuvScreen extends ConsumerStatefulWidget {
  const KelishuvScreen({super.key, required this.kelishuvId});

  final String kelishuvId;

  @override
  ConsumerState<KelishuvScreen> createState() => _KelishuvScreenState();
}

class _KelishuvScreenState extends ConsumerState<KelishuvScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;
  bool _reviewPromptShown = false;
  bool _showTermsChangedBanner = false;
  String? _providerToolsSyncedForKelishuv;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _refreshKelishuvState() {
    ref.invalidate(kelishuvDetailProvider(widget.kelishuvId));
    ref.invalidate(incomingKelishuvProvider);
    ref.invalidate(myKelishuvRequestsProvider);
    ref.invalidate(archivedKelishuvProvider);
  }

  List<Widget> _buildAppBarActions(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<Kelishuv?> detailAsync,
    String? userId,
  ) {
    if (userId == null) return const [];

    final kelishuv = detailAsync.valueOrNull;
    if (kelishuv == null || !kelishuv.isParty(userId)) return const [];

    final otherId =
        kelishuv.partyAId == userId ? kelishuv.partyBId : kelishuv.partyAId;

    return [
      IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () => showSafetyActionsSheet(
          context,
          ref,
          targetUserId: otherId,
          targetUserName: kelishuv.otherPartyNameFor(userId),
          reportType: ReportTargetType.kelishuv,
          reportTargetId: widget.kelishuvId,
        ),
      ),
    ];
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    try {
      final result = await ref
          .read(kelishuvRepositoryProvider)
          .sendMessage(widget.kelishuvId, text);
      _messageController.clear();
      ref.invalidate(kelishuvMessagesProvider(widget.kelishuvId));
      if (result.acceptsReset) {
        setState(() => _showTermsChangedBanner = true);
        _refreshKelishuvState();
      }
    } on KelishuvFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _accept(String userId) async {
    final ok = await showYbConfirmDialog(
      context,
      title: 'Qabul qilasizmi?',
      message: 'Kelishuv shartlarini qabul qilganingizdan keyin ikkinchi tomon ham tasdiqlashi kerak.',
      confirmLabel: 'Qabul qilaman',
    );
    if (!ok || !mounted) return;

    try {
      await ref
          .read(kelishuvRepositoryProvider)
          .accept(widget.kelishuvId, userId);
      if (mounted) setState(() => _showTermsChangedBanner = false);
      _refreshKelishuvState();
      final updated =
          await ref.read(kelishuvDetailProvider(widget.kelishuvId).future);
      if (updated != null) {
        await _handleKelishuvSync(updated, userId);
      }
    } on KelishuvFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    }
  }

  Future<void> _editTerms(Kelishuv kelishuv) async {
    final saved = await showEditKelishuvTermsSheet(context, kelishuv: kelishuv);
    if (saved != true || !mounted) return;

    setState(() => _showTermsChangedBanner = true);
    _refreshKelishuvState();
  }

  Future<void> _markComplete(String userId) async {
    final detail = ref.read(kelishuvDetailProvider(widget.kelishuvId)).valueOrNull;
    final otherMarked = detail != null &&
        ((userId == detail.partyAId && detail.completeB) ||
            (userId == detail.partyBId && detail.completeA));

    final ok = await showYbConfirmDialog(
      context,
      title: 'Ish bajarildimi?',
      message: otherMarked
          ? 'Siz tasdiqlasangiz, kelishuv yakunlanadi.'
          : 'Ish to\'liq bajarilganini tasdiqlaysizmi? Ikkinchi tomon ham tasdiqlashi kerak.',
      confirmLabel: 'Bajarildi',
    );
    if (!ok || !mounted) return;

    try {
      final wasWaitingForOther = otherMarked;
      await ref
          .read(kelishuvRepositoryProvider)
          .markBajarildi(widget.kelishuvId, userId);
      _refreshKelishuvState();
      await ref.read(kelishuvDetailProvider(widget.kelishuvId).future);
      final detail = ref.read(kelishuvDetailProvider(widget.kelishuvId)).valueOrNull;
      final xizmatId = detail?.xizmatId;
      if (xizmatId != null) {
        ref.invalidate(xizmatDetailProvider(xizmatId));
        ref.invalidate(providerGrowthProvider);
        final growth = await ref.read(providerGrowthProvider.future);
        if (mounted && growth != null) {
          await showPendingAchievementCelebrations(
            context,
            ref,
            growth.unlockedIds,
          );
        }
      }
      if (wasWaitingForOther &&
          detail?.status == KelishuvStatus.bajarildi &&
          mounted) {
        await recordKelishuvCompletedForReview(ref);
        await maybePromptAppReview(
          context,
          ref,
          trigger: AppReviewTrigger.completedDeal,
        );
        await _completeLinkedAppointment(detail!, userId);
      }
    } on KelishuvFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    }
  }

  Future<void> _cancel(String userId) async {
    final ok = await showYbConfirmDialog(
      context,
      title: 'Bekor qilasizmi?',
      message: 'Kelishuv bekor qilinadi. Bu amalni qaytarib bo\'lmaydi.',
      confirmLabel: 'Bekor qilish',
      isDestructive: true,
    );
    if (!ok || !mounted) return;

    try {
      await ref.read(kelishuvRepositoryProvider).cancel(widget.kelishuvId, userId);
      await ref
          .read(providerToolsServiceProvider)
          .cancelKelishuvAppointment(widget.kelishuvId);
      invalidateProviderTools(ref);
      _refreshKelishuvState();
    } on KelishuvFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    }
  }

  Future<void> _reject(String userId) async {
    final ok = await showYbConfirmDialog(
      context,
      title: 'Rad etasizmi?',
      message: 'Taklif rad etiladi.',
      confirmLabel: 'Rad etish',
      isDestructive: true,
    );
    if (!ok || !mounted) return;

    try {
      await ref.read(kelishuvRepositoryProvider).reject(widget.kelishuvId, userId);
      _refreshKelishuvState();
    } on KelishuvFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    }
  }

  Future<void> _handleKelishuvSync(Kelishuv kelishuv, String userId) async {
    final strings = ref.read(appStringsProvider);
    final result = await syncProviderToolsFromKelishuv(ref, kelishuv, userId);
    if (!mounted) return;

    if (result.needsAppointmentDate) {
      await showKelishuvAppointmentSheet(
        context: context,
        ref: ref,
        strings: strings,
        kelishuv: kelishuv,
        userId: userId,
      );
      return;
    }

    if (result.synced) {
      _providerToolsSyncedForKelishuv = kelishuv.id;
    }
  }

  Future<void> _completeLinkedAppointment(Kelishuv kelishuv, String userId) async {
    final strings = ref.read(appStringsProvider);
    final service = ref.read(providerToolsServiceProvider);
    final booking = await service.findBookingByKelishuvId(kelishuv.id);
    if (booking == null || !mounted) return;

    if (kelishuv.isProvider(userId)) {
      final amount = await showCompleteAmountSheet(
        context: context,
        strings: strings,
        initialAmount: kelishuv.price,
      );
      if (amount == null) return;
      await service.completeKelishuvAppointment(
        kelishuvId: kelishuv.id,
        userId: userId,
        amount: amount,
        currency: kelishuv.currency ?? 'UZS',
      );
    } else {
      await service.completeKelishuvAppointment(
        kelishuvId: kelishuv.id,
        userId: userId,
      );
    }
    invalidateProviderTools(ref);
  }

  Future<void> _maybeSyncProviderTools(
    Kelishuv kelishuv,
    String? userId,
  ) async {
    if (userId == null || kelishuv.status != KelishuvStatus.jarayonda) return;
    if (_providerToolsSyncedForKelishuv == kelishuv.id &&
        kelishuv.startDate != null) {
      return;
    }
    await _handleKelishuvSync(kelishuv, userId);
  }

  Future<void> _maybePromptReview(Kelishuv kelishuv, String? userId) async {
    if (_reviewPromptShown || userId == null) return;
    if (kelishuv.status != KelishuvStatus.bajarildi) return;
    if (!kelishuv.isClient(userId)) return;
    if (kelishuv.xizmatId == null) return;

    final existing =
        await ref.read(kelishuvReviewProvider(widget.kelishuvId).future);
    if (existing != null || !mounted) return;

    _reviewPromptShown = true;
    await showReviewSheet(
      context,
      kelishuvId: widget.kelishuvId,
      xizmatId: kelishuv.xizmatId!,
      xizmatName: kelishuv.xizmatName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(kelishuvDetailProvider(widget.kelishuvId));
    final messagesAsync =
        ref.watch(kelishuvMessagesProvider(widget.kelishuvId));
    final reviewAsync = ref.watch(kelishuvReviewProvider(widget.kelishuvId));
    final userId = ref.watch(sessionProvider).user?.id;
    final strings = ref.watch(appStringsProvider);

    return KelishuvRealtimeListener(
      kelishuvId: widget.kelishuvId,
      child: Scaffold(
        appBar: AppBar(
          title: Text(strings.kelishuvTitle),
          actions: _buildAppBarActions(context, ref, detailAsync, userId),
        ),
        body: detailAsync.when(
          loading: () => const YbSkeletonList(count: 2),
          error: (error, _) => YbEmptyState(
            icon: Icons.error_outline_rounded,
            title: strings.kelishuvTitle,
            subtitle: '$error',
          ),
          data: (kelishuv) {
            if (kelishuv == null) {
              return YbEmptyState(
                icon: Icons.handshake_outlined,
                title: strings.kelishuvNotFound,
                subtitle: strings.kelishuvNotFound,
              );
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _maybePromptReview(kelishuv, userId);
              _maybeSyncProviderTools(kelishuv, userId);
            });

            final otherName = userId == null
                ? 'Foydalanuvchi'
                : kelishuv.otherPartyNameFor(userId);
            final slotLabel = strings.kelishuvSlotLabel(
              kelishuv.startDate,
              kelishuv.durationMinutes,
            );
            final colors = context.ybColors;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      YbSurfaceCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            YbStatusBadge(
                              label: strings.kelishuvStatusLabel(kelishuv.status),
                              tone: _toneForStatus(kelishuv.status),
                            ),
                            if (kelishuv.status == KelishuvStatus.muzokarada ||
                                kelishuv.status == KelishuvStatus.jarayonda) ...[
                              const SizedBox(height: AppSpacing.md),
                              YbSafetyBanner(strings: strings),
                            ],
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              otherName,
                              style: AppTypography.title.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            if (kelishuv.xizmatName != null) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                kelishuv.xizmatName!,
                                style: AppTypography.caption.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                            if (kelishuv.postTitle != null) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                strings.kelishuvDetailPost(kelishuv.postTitle!),
                                style: AppTypography.caption.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                            if (kelishuv.price != null) ...[
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                strings.kelishuvDetailPrice(
                                  kelishuv.price!.toStringAsFixed(0),
                                  kelishuv.currency ?? 'UZS',
                                ),
                                style: AppTypography.body.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                            if (slotLabel != null) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                strings.kelishuvDetailTime(slotLabel),
                                style: AppTypography.bodyRegular.copyWith(
                                  color: colors.textPrimary,
                                ),
                              ),
                            ],
                            if (_showTermsChangedBanner &&
                                kelishuv.status == KelishuvStatus.muzokarada) ...[
                              const SizedBox(height: AppSpacing.md),
                              YbInlineMessage(
                                tone: YbInlineMessageTone.warning,
                                message: strings.kelishuvTermsChanged,
                              ),
                            ],
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              children: [
                                _AcceptChip(
                                  label: strings.kelishuvPartyA,
                                  accepted: kelishuv.acceptA,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                _AcceptChip(
                                  label: strings.kelishuvPartyB,
                                  accepted: kelishuv.acceptB,
                                ),
                              ],
                            ),
                            if (kelishuv.status == KelishuvStatus.jarayonda ||
                                kelishuv.status == KelishuvStatus.bajarildi) ...[
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                children: [
                                  _AcceptChip(
                                    label: strings.kelishuvCompleteA,
                                    accepted: kelishuv.completeA,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  _AcceptChip(
                                    label: strings.kelishuvCompleteB,
                                    accepted: kelishuv.completeB,
                                  ),
                                ],
                              ),
                            ],
                            if (kelishuv.status == KelishuvStatus.jarayonda &&
                                userId != null &&
                                kelishuv.awaitingMyComplete(userId)) ...[
                              const SizedBox(height: AppSpacing.md),
                              YbInlineMessage(
                                tone: YbInlineMessageTone.info,
                                message: strings.kelishuvAwaitingComplete,
                              ),
                            ],
                            if (kelishuv.isDualAccepted) ...[
                              const SizedBox(height: AppSpacing.md),
                              YbStatusBadge(
                                label: strings.kelishuvDualAccepted,
                                tone: YbStatusTone.success,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (kelishuv.status == KelishuvStatus.bajarildi) ...[
                        const SizedBox(height: AppSpacing.md),
                        reviewAsync.when(
                          loading: () => const SizedBox.shrink(),
                          error: (_, _) => const SizedBox.shrink(),
                          data: (review) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (review != null)
                                  YbStatusBadge(
                                    label: 'Baho: ${review.rating}/5',
                                    tone: YbStatusTone.primary,
                                  )
                                else if (userId != null &&
                                    kelishuv.isClient(userId))
                                  YbSecondaryButton(
                                    label: strings.reviewsRate,
                                    icon: Icons.star_outline,
                                    onPressed: kelishuv.xizmatId == null
                                        ? null
                                        : () => showReviewSheet(
                                              context,
                                              kelishuvId: widget.kelishuvId,
                                              xizmatId: kelishuv.xizmatId!,
                                              xizmatName: kelishuv.xizmatName,
                                            ),
                                  ),
                                if (userId != null &&
                                    kelishuv.canRepeatBook(userId)) ...[
                                  if (review != null ||
                                      kelishuv.isClient(userId))
                                    const SizedBox(height: AppSpacing.sm),
                                  YbPrimaryButton(
                                    label: strings.repeatBook,
                                    icon: Icons.replay_outlined,
                                    onPressed: kelishuv.xizmatId == null
                                        ? null
                                        : () => openRepeatBookFlow(
                                              context,
                                              ref,
                                              kelishuv: kelishuv,
                                            ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        strings.kelishuvMessages,
                        style: AppTypography.headline.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (kelishuv.message != null &&
                          kelishuv.message!.isNotEmpty)
                        _OpeningMessageBubble(
                          content: kelishuv.message!,
                          label: strings.kelishuvOpeningOffer,
                        ),
                      messagesAsync.when(
                        loading: () => const Padding(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          child: LinearProgressIndicator(),
                        ),
                        error: (error, _) => Text('$error'),
                        data: (messages) {
                          if (messages.isEmpty &&
                              (kelishuv.message == null ||
                                  kelishuv.message!.isEmpty)) {
                            return Text(
                              strings.kelishuvNoMessages,
                              style: AppTypography.caption.copyWith(
                                color: colors.textSecondary,
                              ),
                            );
                          }

                          return Column(
                            children: messages
                                .map(
                                  (message) => _ChatBubble(
                                    message: message,
                                    isMine: message.senderId == userId,
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.xxxl),
                    ],
                  ),
                ),
                _buildComposer(context, kelishuv, userId, strings),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildComposer(
    BuildContext context,
    Kelishuv kelishuv,
    String? userId,
    AppStrings strings,
  ) {
    final currentUserId = userId;
    final isParticipant =
        currentUserId != null && kelishuv.isParty(currentUserId);

    final canAccept = isParticipant &&
        !kelishuv.hasAccepted(currentUserId) &&
        kelishuv.status == KelishuvStatus.muzokarada;

    final canEditTerms =
        isParticipant && kelishuv.canEditTerms(currentUserId);

    final canComplete =
        isParticipant && kelishuv.canMarkComplete(currentUserId);

    final daysUntilComplete = currentUserId != null
        ? kelishuv.daysUntilCanComplete(currentUserId)
        : null;

    final canCancel = isParticipant && kelishuv.isActive;

    final canReject =
        isParticipant && kelishuv.status == KelishuvStatus.muzokarada;

    final canChat = isParticipant && kelishuv.isActive;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.ybColors.surfaceElevated.withValues(alpha: 0.96),
        border: Border(top: BorderSide(color: context.ybColors.borderSubtle)),
        boxShadow: AppElevation.navBar(context),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (daysUntilComplete != null) ...[
                YbInlineMessage(
                  tone: YbInlineMessageTone.warning,
                  message: strings.kelishuvCompleteDaysLeft(daysUntilComplete),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (canAccept) ...[
                YbPrimaryButton(
                  label: strings.kelishuvAccept,
                  icon: Icons.check_circle_outline,
                  onPressed: () => _accept(currentUserId),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (canComplete) ...[
                YbPrimaryButton(
                  label: strings.kelishuvComplete,
                  icon: Icons.task_alt_outlined,
                  onPressed: () => _markComplete(currentUserId),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (canEditTerms)
                TextButton.icon(
                  onPressed: () => _editTerms(kelishuv),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: Text(strings.kelishuvEditTerms),
                ),
              if (canReject || canCancel) ...[
                if (canEditTerms) const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    if (canReject)
                      Expanded(
                        child: YbSecondaryButton(
                          label: strings.kelishuvReject,
                          onPressed: () => _reject(currentUserId),
                        ),
                      ),
                    if (canReject && canCancel)
                      const SizedBox(width: AppSpacing.sm),
                    if (canCancel)
                      Expanded(
                        child: YbSecondaryButton(
                          label: strings.kelishuvCancel,
                          onPressed: () => _cancel(currentUserId),
                        ),
                      ),
                  ],
                ),
              ],
              if (canChat) ...[
                if (canAccept ||
                    canComplete ||
                    canReject ||
                    canCancel ||
                    canEditTerms)
                  const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: strings.kelishuvMessageHint,
                          isDense: true,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton.filled(
                      onPressed: _isSending ? null : _sendMessage,
                      icon: _isSending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  YbStatusTone _toneForStatus(KelishuvStatus status) => switch (status) {
        KelishuvStatus.jarayonda => YbStatusTone.success,
        KelishuvStatus.bajarildi => YbStatusTone.primary,
        KelishuvStatus.bekor || KelishuvStatus.rad => YbStatusTone.warning,
        _ => YbStatusTone.neutral,
      };
}

class _AcceptChip extends StatelessWidget {
  const _AcceptChip({required this.label, required this.accepted});

  final String label;
  final bool accepted;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: accepted ? colors.primaryMuted : colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        border: Border.all(
          color: accepted ? AppColors.primary : colors.borderSubtle,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            accepted ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: 18,
            color: accepted ? AppColors.primary : colors.textTertiary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.caption.copyWith(color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}

class _OpeningMessageBubble extends StatelessWidget {
  const _OpeningMessageBubble({
    required this.content,
    required this.label,
  });

  final String content;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.label.copyWith(color: colors.textTertiary),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                content,
                style: AppTypography.bodyRegular.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, required this.isMine});

  final KelishuvMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.75,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isMine ? colors.primaryMuted : colors.surface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(AppRadius.card),
              topRight: const Radius.circular(AppRadius.card),
              bottomLeft: Radius.circular(isMine ? AppRadius.card : AppRadius.xs),
              bottomRight: Radius.circular(isMine ? AppRadius.xs : AppRadius.card),
            ),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMine && message.senderName != null)
                Text(
                  message.senderName!,
                  style: AppTypography.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              Text(
                message.content,
                style: AppTypography.bodyRegular.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
