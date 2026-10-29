import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/kelishuv_providers.dart';
import 'package:yordambor/data/experience/experience_prefs_repository.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/entities/kelishuv_summary.dart';
import 'package:yordambor/domain/entities/request_draft.dart';

final experiencePrefsRepositoryProvider =
    Provider<ExperiencePrefsRepository>((ref) {
  return ExperiencePrefsRepository();
});

/// Bump when a release has something worth one "What's new" sheet.
const kWhatsNewVersion = 2;

/// Away at least this long, the greeting says "Welcome back" (manual WL-03).
const kWelcomeBackAfter = Duration(days: 14);

/// What the first minute of this launch should say (manual WL-01…WL-06).
class LaunchExperience {
  const LaunchExperience({
    this.isLoaded = false,
    this.welcomeBack = false,
    this.showWhatsNew = false,
  });

  final bool isLoaded;

  /// The previous launch was [kWelcomeBackAfter] ago or more.
  final bool welcomeBack;

  /// An existing user just updated to a release with notes. Never true on a
  /// fresh install.
  final bool showWhatsNew;

  LaunchExperience copyWith({bool? showWhatsNew}) => LaunchExperience(
        isLoaded: isLoaded,
        welcomeBack: welcomeBack,
        showWhatsNew: showWhatsNew ?? this.showWhatsNew,
      );
}

/// Read once at start-up (the splash waits for it), before onboarding can
/// mark the welcome as seen.
final launchExperienceProvider =
    StateNotifierProvider<LaunchExperienceNotifier, LaunchExperience>((ref) {
  return LaunchExperienceNotifier(ref.watch(experiencePrefsRepositoryProvider));
});

class LaunchExperienceNotifier extends StateNotifier<LaunchExperience> {
  LaunchExperienceNotifier(this._repository, {DateTime Function()? clock})
      : _clock = clock ?? DateTime.now,
        super(const LaunchExperience()) {
    _load();
  }

  final ExperiencePrefsRepository _repository;
  final DateTime Function() _clock;

  Future<void> _load() async {
    final now = _clock();
    final previous = await _repository.recordOpen(now);
    final welcomeSeen = await _repository.isWelcomeSeen();
    final seen = await _repository.whatsNewSeen();

    var showWhatsNew = false;
    if (!welcomeSeen) {
      // A fresh install starts on the current release: nothing is new to it.
      await _repository.setWhatsNewSeen(kWhatsNewVersion);
    } else if ((seen ?? 0) < kWhatsNewVersion) {
      showWhatsNew = true;
    }

    if (!mounted) return;
    state = LaunchExperience(
      isLoaded: true,
      welcomeBack:
          previous != null && now.difference(previous) >= kWelcomeBackAfter,
      showWhatsNew: showWhatsNew,
    );
  }

  Future<void> markWhatsNewSeen() async {
    state = state.copyWith(showWhatsNew: false);
    await _repository.setWhatsNewSeen(kWhatsNewVersion);
  }
}

/// The unfinished "Yordam kerak" request on this device, if any.
final requestDraftProvider =
    StateNotifierProvider<RequestDraftNotifier, RequestDraft?>((ref) {
  return RequestDraftNotifier(ref.watch(experiencePrefsRepositoryProvider));
});

class RequestDraftNotifier extends StateNotifier<RequestDraft?> {
  RequestDraftNotifier(this._repository) : super(null) {
    _loaded = _load();
  }

  final ExperiencePrefsRepository _repository;
  late final Future<void> _loaded;
  var _touched = false;

  Future<void> _load() async {
    final draft = await _repository.loadDraft();
    // A save or clear made while loading wins over the stored copy.
    if (!mounted || _touched) return;
    state = draft != null && draft.hasContent ? draft : null;
  }

  /// The draft once it has been read from the device.
  Future<RequestDraft?> current() async {
    await _loaded;
    return state;
  }

  Future<void> save(RequestDraft draft) async {
    if (!draft.hasContent) return clear();
    _touched = true;
    state = draft;
    await _repository.saveDraft(draft);
  }

  Future<void> clear() async {
    _touched = true;
    state = null;
    await _repository.clearDraft();
  }
}

/// Deals that ask something of the person, newest first.
class HomeDeals {
  const HomeDeals({
    this.awaitingReply = const [],
    this.inProgress = const [],
  });

  /// Negotiating, and the person has not accepted the current terms.
  final List<KelishuvSummary> awaitingReply;

  /// Agreed and under way.
  final List<KelishuvSummary> inProgress;
}

final homeDealsProvider = Provider<HomeDeals>((ref) {
  final incoming = ref.watch(incomingKelishuvProvider).valueOrNull ?? const [];
  final requests =
      ref.watch(myKelishuvRequestsProvider).valueOrNull ?? const [];

  final byId = <String, KelishuvSummary>{
    for (final group in incoming)
      for (final item in group.items) item.id: item,
    for (final item in requests) item.id: item,
  };
  int newestFirst(KelishuvSummary a, KelishuvSummary b) =>
      b.updatedAt.compareTo(a.updatedAt);

  return HomeDeals(
    awaitingReply: byId.values.where((k) => k.needsMyAccept).toList()
      ..sort(newestFirst),
    inProgress: byId.values
        .where((k) => k.status == KelishuvStatus.jarayonda)
        .toList()
      ..sort(newestFirst),
  );
});
