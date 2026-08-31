import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/data/feed/feed_filter_prefs_repository.dart';

enum FeedMode { yordamBor, yordamKerak }

class FeedFilterState {
  const FeedFilterState({
    this.mode = FeedMode.yordamBor,
    this.categoryId,
    this.subcategoryId,
    this.categoryLabel,
    this.subcategoryLabel,
    this.providerType,
  });

  final FeedMode mode;
  final String? categoryId;
  final String? subcategoryId;
  final String? categoryLabel;
  final String? subcategoryLabel;

  /// `individual`, `institution`, or null for all provider types.
  final String? providerType;

  FeedFilterState copyWith({
    FeedMode? mode,
    String? categoryId,
    String? subcategoryId,
    String? categoryLabel,
    String? subcategoryLabel,
    String? providerType,
    bool clearCategory = false,
    bool clearSubcategory = false,
    bool clearProviderType = false,
  }) {
    return FeedFilterState(
      mode: mode ?? this.mode,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      subcategoryId:
          clearSubcategory ? null : (subcategoryId ?? this.subcategoryId),
      categoryLabel:
          clearCategory ? null : (categoryLabel ?? this.categoryLabel),
      subcategoryLabel: clearSubcategory
          ? null
          : (subcategoryLabel ?? this.subcategoryLabel),
      providerType: clearProviderType
          ? null
          : (providerType ?? this.providerType),
    );
  }
}

final feedFilterProvider =
    StateNotifierProvider<FeedFilterNotifier, FeedFilterState>(
  (ref) {
    final notifier = FeedFilterNotifier(ref.read(feedFilterPrefsRepositoryProvider));
    unawaited(notifier.restore());
    return notifier;
  },
);

class FeedFilterNotifier extends StateNotifier<FeedFilterState> {
  FeedFilterNotifier(this._repository) : super(const FeedFilterState());

  final FeedFilterPrefsRepository _repository;

  Future<void> restore() async {
    final saved = await _repository.load();
    if (saved == null) return;
    state = _fromJson(saved);
  }

  void setMode(FeedMode mode) => _update(state.copyWith(mode: mode));

  void setCategory(String? id, {String? label}) => _update(
        state.copyWith(
          categoryId: id,
          categoryLabel: label,
          clearCategory: id == null,
          clearSubcategory: true,
        ),
      );

  void setSubcategory(
    String? id, {
    String? label,
    String? providerType,
  }) =>
      _update(
        state.copyWith(
          subcategoryId: id,
          subcategoryLabel: label,
          providerType: providerType,
          clearSubcategory: id == null,
          clearProviderType: id == null && providerType == null,
        ),
      );

  void setProviderType(String? type) => _update(
        state.copyWith(
          providerType: type,
          clearProviderType: type == null,
          clearSubcategory: true,
        ),
      );

  void clearSubcategory() =>
      _update(state.copyWith(clearSubcategory: true));

  void clearFilters() => _update(FeedFilterState(mode: state.mode));

  void _update(FeedFilterState next) {
    state = next;
    unawaited(_repository.save(_toJson(next)));
  }

  Map<String, dynamic> _toJson(FeedFilterState state) => {
        'mode': state.mode.name,
        'categoryId': state.categoryId,
        'subcategoryId': state.subcategoryId,
        'categoryLabel': state.categoryLabel,
        'subcategoryLabel': state.subcategoryLabel,
        'providerType': state.providerType,
      };

  FeedFilterState _fromJson(Map<String, dynamic> json) {
    final modeName = json['mode'] as String?;
    final mode = FeedMode.values.cast<FeedMode?>().firstWhere(
          (value) => value?.name == modeName,
          orElse: () => null,
        ) ??
        FeedMode.yordamBor;

    return FeedFilterState(
      mode: mode,
      categoryId: json['categoryId'] as String?,
      subcategoryId: json['subcategoryId'] as String?,
      categoryLabel: json['categoryLabel'] as String?,
      subcategoryLabel: json['subcategoryLabel'] as String?,
      providerType: json['providerType'] as String?,
    );
  }
}
