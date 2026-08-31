import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yordambor/application/providers/auth_providers.dart';
import 'package:yordambor/application/providers/feed_provider.dart';
import 'package:yordambor/application/providers/locale_provider.dart';
import 'package:yordambor/application/providers/xizmat_providers.dart';
import 'package:yordambor/data/storage/storage_repository.dart';
import 'package:yordambor/data/xizmat/xizmat_repository.dart';
import 'package:yordambor/core/utils/phone_validation.dart';
import 'package:yordambor/domain/entities/category_item.dart';
import 'package:yordambor/domain/entities/xizmat_availability_mode.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';
import 'package:yordambor/presentation/shared/xizmat_availability_section.dart';
import 'package:yordambor/presentation/shared/xizmat_pricing_section.dart';
import 'package:yordambor/presentation/shared/xizmat_promise_section.dart';
import 'package:yordambor/presentation/shared/xizmat_service_city_field.dart';

class PortfolioDraft {
  const PortfolioDraft({
    required this.bytes,
    required this.extension,
  });

  final Uint8List bytes;
  final String extension;
}

class CreateXizmatState {
  const CreateXizmatState({
    this.step = 0,
    this.providerType = 'individual',
    this.category,
    this.subcategory,
    this.name = '',
    this.description = '',
    this.portfolio = const [],
    this.isSubmitting = false,
    this.errorMessage,
    this.contactPhone = '',
    this.showContactPhone = false,
    this.pricingModel = XizmatPricingModel.negotiable,
    this.basePriceText = '',
    this.minDurationText = '',
    this.availabilityVisible = false,
    this.availabilityMode,
    this.availabilityFrom,
    this.availabilityUntil,
    this.showServicePromise = false,
    this.servicePromiseText = '',
    this.serviceCity = '',
  });

  final int step;
  final String providerType;
  final CategoryItem? category;
  final SubcategoryItem? subcategory;
  final String name;
  final String description;
  final List<PortfolioDraft> portfolio;
  final bool isSubmitting;
  final String? errorMessage;
  final String contactPhone;
  final bool showContactPhone;
  final XizmatPricingModel pricingModel;
  final String basePriceText;
  final String minDurationText;
  final bool availabilityVisible;
  final XizmatAvailabilityMode? availabilityMode;
  final DateTime? availabilityFrom;
  final DateTime? availabilityUntil;
  final bool showServicePromise;
  final String servicePromiseText;
  final String serviceCity;

  bool get canContinueStep1 =>
      name.trim().length >= 2 &&
      category != null &&
      subcategory != null &&
      providerType.isNotEmpty;

  bool get canContinueStep2 => portfolio.isNotEmpty;

  CreateXizmatState copyWith({
    int? step,
    String? providerType,
    CategoryItem? category,
    SubcategoryItem? subcategory,
    bool clearCategory = false,
    bool clearSubcategory = false,
    String? name,
    String? description,
    List<PortfolioDraft>? portfolio,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    String? contactPhone,
    bool? showContactPhone,
    XizmatPricingModel? pricingModel,
    String? basePriceText,
    String? minDurationText,
    bool? availabilityVisible,
    XizmatAvailabilityMode? availabilityMode,
    bool clearAvailabilityMode = false,
    DateTime? availabilityFrom,
    bool clearAvailabilityFrom = false,
    DateTime? availabilityUntil,
    bool clearAvailabilityUntil = false,
    bool? showServicePromise,
    String? servicePromiseText,
    String? serviceCity,
  }) {
    return CreateXizmatState(
      step: step ?? this.step,
      providerType: providerType ?? this.providerType,
      category: clearCategory ? null : (category ?? this.category),
      subcategory:
          clearSubcategory ? null : (subcategory ?? this.subcategory),
      name: name ?? this.name,
      description: description ?? this.description,
      portfolio: portfolio ?? this.portfolio,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      contactPhone: contactPhone ?? this.contactPhone,
      showContactPhone: showContactPhone ?? this.showContactPhone,
      pricingModel: pricingModel ?? this.pricingModel,
      basePriceText: basePriceText ?? this.basePriceText,
      minDurationText: minDurationText ?? this.minDurationText,
      availabilityVisible: availabilityVisible ?? this.availabilityVisible,
      availabilityMode: clearAvailabilityMode
          ? null
          : (availabilityMode ?? this.availabilityMode),
      availabilityFrom: clearAvailabilityFrom
          ? null
          : (availabilityFrom ?? this.availabilityFrom),
      availabilityUntil: clearAvailabilityUntil
          ? null
          : (availabilityUntil ?? this.availabilityUntil),
      showServicePromise: showServicePromise ?? this.showServicePromise,
      servicePromiseText: servicePromiseText ?? this.servicePromiseText,
      serviceCity: serviceCity ?? this.serviceCity,
    );
  }
}

final createXizmatProvider =
    StateNotifierProvider.autoDispose<CreateXizmatNotifier, CreateXizmatState>(
        (ref) {
  return CreateXizmatNotifier(ref);
});

class CreateXizmatNotifier extends StateNotifier<CreateXizmatState> {
  CreateXizmatNotifier(this._ref) : super(const CreateXizmatState());

  final Ref _ref;

  void setProviderType(String type) {
    state = state.copyWith(
      providerType: type,
      clearSubcategory: true,
      clearError: true,
    );
  }

  void setCategory(CategoryItem category) {
    state = state.copyWith(
      category: category,
      clearSubcategory: true,
      clearError: true,
    );
  }

  void setSubcategory(SubcategoryItem subcategory) {
    state = state.copyWith(subcategory: subcategory, clearError: true);
  }

  void setName(String name) => state = state.copyWith(name: name);

  void setDescription(String description) =>
      state = state.copyWith(description: description);

  void setServiceCity(String city) =>
      state = state.copyWith(serviceCity: city);

  void setContactPhone(String phone) =>
      state = state.copyWith(contactPhone: phone);

  void setShowContactPhone(bool value) =>
      state = state.copyWith(showContactPhone: value);

  void setPricingModel(XizmatPricingModel model) =>
      state = state.copyWith(pricingModel: model, clearError: true);

  void setBasePriceText(String value) =>
      state = state.copyWith(basePriceText: value);

  void setMinDurationText(String value) =>
      state = state.copyWith(minDurationText: value);

  void setAvailabilityVisible(bool value) {
    if (value) {
      state = state.copyWith(
        availabilityVisible: true,
        availabilityMode:
            state.availabilityMode ?? XizmatAvailabilityMode.availableNow,
        clearError: true,
      );
      return;
    }
    state = state.copyWith(
      availabilityVisible: false,
      clearAvailabilityMode: true,
      clearAvailabilityFrom: true,
      clearAvailabilityUntil: true,
      clearError: true,
    );
  }

  void setAvailabilityMode(XizmatAvailabilityMode mode) {
    state = state.copyWith(
      availabilityMode: mode,
      clearAvailabilityFrom: mode == XizmatAvailabilityMode.callMe,
      clearAvailabilityUntil: mode == XizmatAvailabilityMode.callMe,
      clearError: true,
    );
  }

  void setAvailabilityFrom(DateTime? value) =>
      state = state.copyWith(availabilityFrom: value, clearError: true);

  void setAvailabilityUntil(DateTime? value) =>
      state = state.copyWith(availabilityUntil: value, clearError: true);

  void setShowServicePromise(bool value) =>
      state = state.copyWith(showServicePromise: value, clearError: true);

  void setServicePromiseText(String value) =>
      state = state.copyWith(servicePromiseText: value, clearError: true);

  void prefillContactPhone(String? phone) {
    if (state.contactPhone.isNotEmpty || phone == null || phone.isEmpty) return;
    state = state.copyWith(contactPhone: phone);
  }

  void addPortfolio(PortfolioDraft draft) {
    state = state.copyWith(
      portfolio: [...state.portfolio, draft],
      clearError: true,
    );
  }

  void removePortfolioAt(int index) {
    final next = [...state.portfolio]..removeAt(index);
    state = state.copyWith(portfolio: next, clearError: true);
  }

  void nextStep() {
    if (state.step == 0 && state.canContinueStep1) {
      state = state.copyWith(step: 1, clearError: true);
    }
  }

  void previousStep() {
    if (state.step > 0) {
      state = state.copyWith(step: state.step - 1, clearError: true);
    }
  }

  Future<bool> submit() async {
    if (!state.canContinueStep2 || state.isSubmitting) return false;

    final session = _ref.read(sessionProvider);
    final userId = session.user?.id;
    if (userId == null) {
      state = state.copyWith(errorMessage: 'Kirish talab qilinadi');
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final xizmatRepo = _ref.read(xizmatRepositoryProvider);
      final storageRepo = _ref.read(storageRepositoryProvider);

      final pricingError = validateXizmatPricing(
        model: state.pricingModel,
        priceText: state.basePriceText,
        strings: _ref.read(appStringsProvider),
      );
      if (pricingError != null) {
        state = state.copyWith(isSubmitting: false, errorMessage: pricingError);
        return false;
      }

      final availabilityError = validateXizmatAvailability(
        visible: state.availabilityVisible,
        mode: state.availabilityMode,
        from: state.availabilityFrom,
        until: state.availabilityUntil,
        strings: _ref.read(appStringsProvider),
      );
      if (availabilityError != null) {
        state =
            state.copyWith(isSubmitting: false, errorMessage: availabilityError);
        return false;
      }

      final promiseError = validateXizmatPromise(
        visible: state.showServicePromise,
        promiseText: state.servicePromiseText,
        strings: _ref.read(appStringsProvider),
      );
      if (promiseError != null) {
        state = state.copyWith(isSubmitting: false, errorMessage: promiseError);
        return false;
      }

      final basePrice = state.pricingModel == XizmatPricingModel.negotiable
          ? null
          : parseOptionalPrice(state.basePriceText);
      final minDuration = state.pricingModel == XizmatPricingModel.hourly
          ? parseOptionalMinutes(state.minDurationText)
          : null;

      final shell = CreateXizmatInput(
        name: state.name,
        providerType: state.providerType,
        categoryId: state.category!.id,
        subcategoryId: state.subcategory!.id,
        description: state.description,
        portfolioImageUrls: const [],
        contactPhone: normalizeOptionalContactPhone(state.contactPhone),
        showContactPhone: state.showContactPhone,
        pricingModel: state.pricingModel,
        basePrice: basePrice,
        minDurationMinutes: minDuration,
        availabilityVisible: state.availabilityVisible,
        availabilityMode: state.availabilityMode,
        availabilityFrom: state.availabilityFrom,
        availabilityUntil: state.availabilityUntil,
        showServicePromise: state.showServicePromise,
        servicePromise: normalizeServicePromise(state.servicePromiseText),
        serviceCity: normalizeServiceCity(state.serviceCity),
      );

      final xizmatId = await xizmatRepo.createShellForUpload(shell);
      final uploadedUrls = <String>[];

      for (final draft in state.portfolio) {
        final url = await storageRepo.uploadPortfolioImage(
          ownerId: userId,
          xizmatId: xizmatId,
          bytes: draft.bytes,
          fileExtension: draft.extension,
        );
        uploadedUrls.add(url);
      }

      await xizmatRepo.attachPortfolio(xizmatId, uploadedUrls);

      _ref.invalidate(myXizmatlarProvider);
      _ref.invalidate(feedProvider);
      state = state.copyWith(isSubmitting: false, step: 2);
      return true;
    } on XizmatFailure catch (error) {
      state = state.copyWith(isSubmitting: false, errorMessage: error.message);
      return false;
    } on StorageFailure catch (error) {
      state = state.copyWith(isSubmitting: false, errorMessage: error.message);
      return false;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString(),
      );
      return false;
    }
  }

  void reset() => state = const CreateXizmatState();
}
