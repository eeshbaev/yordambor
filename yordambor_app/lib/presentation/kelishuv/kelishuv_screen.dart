import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
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
import 'package:yordambor/core/utils/demo_ids.dart';
import 'package:yordambor/core/design_system/app_elevation.dart';
import 'package:yordambor/core/design_system/app_motion.dart';
import 'package:yordambor/core/design_system/app_tokens.dart';
import 'package:yordambor/core/design_system/theme_extensions.dart';
import 'package:yordambor/core/design_system/widgets/yb_buttons.dart';
import 'package:yordambor/core/design_system/widgets/yb_confirm_dialog.dart';
import 'package:yordambor/core/design_system/widgets/yb_deal_bond.dart';
import 'package:yordambor/core/design_system/widgets/yb_empty_state.dart';
import 'package:yordambor/core/design_system/widgets/yb_inline_message.dart';
import 'package:yordambor/core/design_system/widgets/yb_skeleton.dart';
import 'package:yordambor/core/design_system/widgets/yb_status_badge.dart';
import 'package:yordambor/core/design_system/widgets/yb_surface_card.dart';
import 'package:yordambor/core/design_system/yb_icons.dart';
import 'package:yordambor/data/kelishuv/kelishuv_repository.dart';
import 'package:yordambor/data/safety/report_repository.dart';
import 'package:yordambor/domain/growth/app_review_prompt.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/entities/kelishuv_message.dart';
import 'package:yordambor/presentation/kelishuv/decline_offer_sheet.dart';
import 'package:yordambor/presentation/kelishuv/edit_kelishuv_terms_sheet.dart';
import 'package:yordambor/presentation/kelishuv/kelishuv_realtime_listener.dart';
import 'package:yordambor/presentation/kelishuv/repeat_booking_flow.dart';
import 'package:yordambor/presentation/kelishuv/review_sheet.dart';
import 'package:yordambor/presentation/kelishuv/taklif_sheet.dart';
import 'package:yordambor/presentation/shared/yb_safety_banner.dart';
import 'package:yordambor/presentation/safety/safety_actions_sheet.dart';
import 'package:yordambor/core/utils/money_format.dart';

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

  /// The status shown last, so a change made while the screen is open plays
  /// on the bond (and the review waits for the "done" moment to finish).
  KelishuvStatus? _shownStatus;
  bool _celebrating = false;

  /// Set when this person finishes the deal as the provider: the store may
  /// ask for a rating once the celebration is over (manual FB-05). Clients
  /// are asked after a five-star review instead.
  bool _storePromptPending = false;

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
        tooltip: ref.read(appStringsProvider).actionMore,
        icon: const Icon(YbIcons.moreVertFilled),
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
          : 'Ish toʻliq bajarilganini tasdiqlaysizmi? Ikkinchi tomon ham tasdiqlashi kerak.',
      confirmLabel: 'Bajarildi',
    );
    if (!ok || !mounted) return;

    final wasWaitingForOther = otherMarked;
    // Set before the status changes: the celebration may end (or be skipped
    // with reduced motion) before this method resumes.
    _storePromptPending =
        wasWaitingForOther && detail != null && !detail.isClient(userId);
    try {
      await ref
          .read(kelishuvRepositoryProvider)
          .markBajarildi(widget.kelishuvId, userId);
      if (!mounted) return;
      if (wasWaitingForOther) await recordKelishuvCompletedForReview(ref);
      _refreshKelishuvState();
      await ref.read(kelishuvDetailProvider(widget.kelishuvId).future);
      final detail = ref.read(kelishuvDetailProvider(widget.kelishuvId)).valueOrNull;
      final xizmatId = detail?.xizmatId;
      if (xizmatId != null) {
        ref.invalidate(xizmatDetailProvider(xizmatId));
        // A new milestone, if any, waits as a card on home.
        ref.invalidate(providerGrowthProvider);
      }
      if (wasWaitingForOther &&
          detail?.status == KelishuvStatus.bajarildi &&
          mounted) {
        await _completeLinkedAppointment(detail!, userId);
      }
    } on KelishuvFailure catch (error) {
      _storePromptPending = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    }
  }

  Future<void> _cancel(String userId, {bool withdraw = false}) async {
    final strings = ref.read(appStringsProvider);
    final ok = await showYbConfirmDialog(
      context,
      title: withdraw ? strings.dealWithdrawTitle : 'Bekor qilasizmi?',
      message: withdraw
          ? strings.dealWithdrawBody
          : 'Kelishuv bekor qilinadi. Bu amalni qaytarib boʻlmaydi.',
      confirmLabel:
          withdraw ? strings.dealWithdrawOffer : strings.kelishuvCancel,
      cancelLabel: strings.actionCancel,
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

  /// Declines with an optional reason, which stays in the deal's messages.
  Future<void> _reject(String userId) async {
    final comment = await showDeclineOfferSheet(
      context,
      ref.read(appStringsProvider),
    );
    if (comment == null || !mounted) return;

    final repo = ref.read(kelishuvRepositoryProvider);
    try {
      if (comment.trim().isNotEmpty) {
        await repo.sendMessage(widget.kelishuvId, comment);
        ref.invalidate(kelishuvMessagesProvider(widget.kelishuvId));
      }
      await repo.reject(widget.kelishuvId, userId);
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

  /// The ring has closed and the stars have risen, or the person tapped to
  /// skip: the review may follow.
  void _onDealCelebrated() {
    if (!mounted) return;
    if (_celebrating) setState(() => _celebrating = false);
    if (_storePromptPending) {
      _storePromptPending = false;
      maybePromptAppReview(
        context,
        ref,
        trigger: AppReviewTrigger.completedDeal,
      );
    }
  }

  YbBondState _bondState(KelishuvStatus status) => switch (status) {
        KelishuvStatus.muzokarada => YbBondState.negotiating,
        KelishuvStatus.jarayonda => YbBondState.agreed,
        KelishuvStatus.bajarildi => YbBondState.done,
        _ => YbBondState.closed,
      };

  /// One line that says whose turn it is.
  String _turnLine(
    AppStrings strings,
    Kelishuv kelishuv,
    String? userId,
    String otherName,
  ) {
    switch (kelishuv.status) {
      case KelishuvStatus.muzokarada:
        final myTurn = userId != null &&
            kelishuv.isParty(userId) &&
            !kelishuv.hasAccepted(userId);
        return myTurn
            ? strings.dealBondYourTurn
            : strings.dealBondWaiting(otherName);
      case KelishuvStatus.jarayonda:
        return strings.dealBondAgreed;
      case KelishuvStatus.bajarildi:
        return strings.dealBondDone;
      default:
        return strings.dealBondClosed;
    }
  }

  static String _initial(String name) {
    final trimmed = name.trim();
    return trimmed.isEmpty ? '?' : trimmed.characters.first.toUpperCase();
  }

  Future<void> _maybePromptReview(Kelishuv kelishuv, String? userId) async {
    if (_celebrating) return;
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
          error: (_, _) => YbEmptyState(
            icon: YbIcons.cloudOff,
            title: strings.stateErrorTitle,
            subtitle: strings.stateErrorBody,
            actionLabel: strings.actionRetry,
            onAction: () =>
                ref.invalidate(kelishuvDetailProvider(widget.kelishuvId)),
          ),
          data: (kelishuv) {
            if (kelishuv == null) {
              return YbEmptyState(
                icon: YbIcons.handshake,
                title: strings.kelishuvNotFound,
                subtitle: strings.kelishuvNotFound,
              );
            }

            final previousStatus = _shownStatus;
            _shownStatus = kelishuv.status;
            if (previousStatus != null &&
                previousStatus != KelishuvStatus.bajarildi &&
                kelishuv.status == KelishuvStatus.bajarildi &&
                !AppMotion.reduced(context)) {
              _celebrating = true;
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
            // You first, then the other person, instead of "Party A / B".
            final isPartyA = userId != null && userId == kelishuv.partyAId;
            final isPartyB = userId != null && userId == kelishuv.partyBId;
            final named = isPartyA || isPartyB;
            final firstLabel = named
                ? strings.dealBondYou
                : (kelishuv.partyAName ?? strings.kelishuvPartyA);
            final secondLabel = named
                ? otherName
                : (kelishuv.partyBName ?? strings.kelishuvPartyB);
            final firstAccepted =
                isPartyB ? kelishuv.acceptB : kelishuv.acceptA;
            final secondAccepted =
                isPartyB ? kelishuv.acceptA : kelishuv.acceptB;
            final firstDone = isPartyB ? kelishuv.completeB : kelishuv.completeA;
            final secondDone =
                isPartyB ? kelishuv.completeA : kelishuv.completeB;
            // An offer waits 10 days for an answer, then lapses.
            final daysLeft = kelishuv.daysLeftToRespond(DateTime.now());
            final iAmWaiting = userId != null && kelishuv.hasAccepted(userId);

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
                            // The bond: who is in this deal and where it
                            // stands; tap to skip the "done" moment.
                            GestureDetector(
                              onTap: _celebrating ? _onDealCelebrated : null,
                              child: YbDealBond(
                                state: _bondState(kelishuv.status),
                                myLabel: strings.dealBondYou,
                                otherInitial: _initial(otherName),
                                onCelebrationDone: _onDealCelebrated,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Semantics(
                              liveRegion: true,
                              child: Text(
                                _turnLine(strings, kelishuv, userId, otherName),
                                textAlign: TextAlign.center,
                                style: AppTypography.body.copyWith(
                                  color: colors.ink,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (daysLeft != null && named) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                iAmWaiting
                                    ? strings.dealOfferAutoCancel(daysLeft)
                                    : strings.dealOfferReplyWithin(daysLeft),
                                textAlign: TextAlign.center,
                                style: AppTypography.caption.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                            if (isSimulatedKelishuvId(widget.kelishuvId)) ...[
                              const SizedBox(height: AppSpacing.md),
                              YbInlineMessage(
                                message: strings.demoDealNote,
                                tone: YbInlineMessageTone.info,
                              ),
                            ],
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
                                  groupThousands(
                                    kelishuv.price!,
                                    languageCode: strings.languageCode,
                                  ),
                                  currencyUnit(
                                    kelishuv.currency,
                                    languageCode: strings.languageCode,
                                  ),
                                ),
                                // A number people act on: 17 pt, tabular.
                                style: AppTypography.price.copyWith(
                                  color: context.ybColors.ink,
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
                            _ChipRow(
                              caption: strings.dealAcceptedRow,
                              chips: [
                                _AcceptChip(
                                  label: firstLabel,
                                  accepted: firstAccepted,
                                ),
                                _AcceptChip(
                                  label: secondLabel,
                                  accepted: secondAccepted,
                                ),
                              ],
                            ),
                            if (kelishuv.status == KelishuvStatus.jarayonda ||
                                kelishuv.status == KelishuvStatus.bajarildi) ...[
                              const SizedBox(height: AppSpacing.md),
                              _ChipRow(
                                caption: strings.dealCompletedRow,
                                chips: [
                                  _AcceptChip(
                                    label: firstLabel,
                                    accepted: firstDone,
                                  ),
                                  _AcceptChip(
                                    label: secondLabel,
                                    accepted: secondDone,
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
                                tone: YbStatusTone.primary,
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
                                    icon: YbIcons.star,
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
                                    icon: YbIcons.replay,
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
                      // The card the sender attached: the other side can
                      // call straight from here.
                      if (kelishuv.contact != null) ...[
                        const SizedBox(height: AppSpacing.lg),
                        _DealContactCard(
                          contact: kelishuv.contact!,
                          title: userId == kelishuv.initiatorId
                              ? strings.dealContactSent
                              : strings.dealContactTitle,
                          callLabel: strings.userProfileCall,
                          canCall: userId != kelishuv.initiatorId,
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
                        error: (_, _) => Text(
                          strings.profileSectionLoadFailed,
                          style: AppTypography.caption.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
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
                _buildComposer(
                  context,
                  kelishuv,
                  userId,
                  strings,
                  otherSpoke: userId != null &&
                      (messagesAsync.valueOrNull
                              ?.any((message) => message.senderId != userId) ??
                          false),
                  otherName: otherName,
                ),
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
    AppStrings strings, {
    required bool otherSpoke,
    required String otherName,
  }) {
    final currentUserId = userId;
    final isParticipant =
        currentUserId != null && kelishuv.isParty(currentUserId);
    final negotiating = kelishuv.status == KelishuvStatus.muzokarada;

    // The sender's offer stands until the other side answers: accepts,
    // declines, offers new terms or writes. Until then the sender only
    // waits (or withdraws); after it, either side may accept, decline or
    // edit until both have accepted.
    final waiting = currentUserId != null &&
        isParticipant &&
        negotiating &&
        kelishuv.hasAccepted(currentUserId) &&
        !otherSpoke;

    final canAccept = isParticipant &&
        !kelishuv.hasAccepted(currentUserId) &&
        negotiating;

    final canEditTerms = isParticipant &&
        !waiting &&
        kelishuv.canEditTerms(currentUserId);

    final canComplete =
        isParticipant && kelishuv.canMarkComplete(currentUserId);

    final daysUntilComplete = currentUserId != null
        ? kelishuv.daysUntilCanComplete(currentUserId)
        : null;

    // An agreed deal can be cancelled; a waiting offer withdrawn.
    final canCancel = isParticipant &&
        (kelishuv.status == KelishuvStatus.jarayonda || waiting);

    final canReject = isParticipant && negotiating && !waiting;

    final canChat = isParticipant && kelishuv.isActive && !waiting;

    // A closed deal: whoever needed the service may start again.
    final canOfferAgain = currentUserId != null &&
        (kelishuv.status == KelishuvStatus.rad ||
            kelishuv.status == KelishuvStatus.bekor) &&
        kelishuv.xizmatId != null &&
        kelishuv.isClient(currentUserId);

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
              if (waiting) ...[
                // The offer is with the other side; nothing to discuss yet.
                YbInlineMessage(
                  tone: YbInlineMessageTone.info,
                  message: '${strings.dealBondWaiting(otherName)}. '
                      '${strings.dealChatOpensOnReply}',
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (canOfferAgain) ...[
                Text(
                  strings.dealClosedNewOfferHint,
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(
                    color: context.ybColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                YbPrimaryButton(
                  label: strings.dealSendNewOffer,
                  icon: YbIcons.handshake,
                  tone: YbButtonTone.ask,
                  onPressed: () => openTaklifFlow(
                    context,
                    ref,
                    target: TaklifTarget.xizmat(xizmatId: kelishuv.xizmatId!),
                    title: strings.taklifFlowTitleYordamKerak(
                      kelishuv.xizmatName ?? otherName,
                    ),
                  ),
                ),
              ],
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
                  icon: YbIcons.checkCircle,
                  onPressed: () => _accept(currentUserId),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (canComplete) ...[
                YbPrimaryButton(
                  label: strings.kelishuvComplete,
                  icon: YbIcons.taskAlt,
                  onPressed: () => _markComplete(currentUserId),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              if (canEditTerms)
                TextButton.icon(
                  onPressed: () => _editTerms(kelishuv),
                  icon: const Icon(YbIcons.edit, size: 18),
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
                          label: waiting
                              ? strings.dealWithdrawOffer
                              : strings.kelishuvCancel,
                          onPressed: () =>
                              _cancel(currentUserId, withdraw: waiting),
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
                      tooltip: strings.actionSend,
                      onPressed: _isSending ? null : _sendMessage,
                      icon: _isSending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(YbIcons.sendFilled),
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

}

/// A caption and the two people's chips under it; the chips wrap with
/// large text.
class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.caption, required this.chips});

  final String caption;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          caption,
          style: AppTypography.caption.copyWith(
            color: context.ybColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: chips,
        ),
      ],
    );
  }
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
          color: accepted ? context.ybColors.teal : colors.borderSubtle,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            accepted ? YbIcons.checkCircleFilled : YbIcons.radioButtonUnchecked,
            size: 18,
            color: accepted ? context.ybColors.teal : colors.textTertiary,
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

/// The sender's name and phone, with a call button for the other side.
class _DealContactCard extends StatelessWidget {
  const _DealContactCard({
    required this.contact,
    required this.title,
    required this.callLabel,
    required this.canCall,
  });

  final DealContact contact;
  final String title;
  final String callLabel;
  final bool canCall;

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: contact.phone.replaceAll(' ', ''));
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ybColors;
    final name = contact.fullName;
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.tealSoft,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(YbIcons.badge, size: 18, color: colors.tealInk),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.label.copyWith(
                      color: colors.tealInk,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: colors.card,
                  child: Text(
                    initial,
                    style: AppTypography.headline.copyWith(
                      color: colors.tealInk,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTypography.headline.copyWith(
                          color: colors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      SelectableText(
                        contact.phone,
                        style: AppTypography.tabular(
                          AppTypography.body.copyWith(color: colors.ink2),
                        ),
                      ),
                    ],
                  ),
                ),
                if (canCall)
                  IconButton.filled(
                    tooltip: callLabel,
                    onPressed: _call,
                    style: IconButton.styleFrom(
                      backgroundColor: colors.teal,
                      foregroundColor: colors.onTeal,
                    ),
                    icon: const Icon(YbIcons.call),
                  ),
              ],
            ),
          ],
        ),
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
