import 'package:flutter/material.dart';
import 'package:yordambor/data/support/support_repository.dart';
import 'package:yordambor/domain/entities/appointment_status.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/growth/provider_tier.dart';
import 'package:yordambor/core/constants/service_cities.dart';
import 'package:yordambor/l10n/app_localizations.dart';

enum AuthContextType {
  generic,
  favorite,
  yordamKerak,
  yordamBor,
  postJob,
  deal,
}

/// Backward-compatible facade over generated [AppLocalizations].
class AppStrings {
  AppStrings(this._l10n);

  final AppLocalizations _l10n;

  static const supportedLanguages = ['uz', 'ru', 'en', 'zh'];

  static AppStrings forLanguage(String code) {
    final locale = switch (code) {
      'ru' => const Locale('ru'),
      'en' => const Locale('en'),
      'zh' => const Locale('zh'),
      _ => const Locale('uz'),
    };
    return AppStrings(lookupAppLocalizations(locale));
  }

  /// Language of these strings: uz, ru, en or zh.
  String get languageCode => _l10n.localeName.split(RegExp('[_-]')).first;

  static String languageLabel(String code) => switch (code) {
        'uz' => 'Oʻzbek',
        'ru' => 'Русский',
        'en' => 'English',
        'zh' => '中文',
        _ => code,
      };

  String get appName => _l10n.appName;
  String get splashTagline => _l10n.splashTagline;
  String get tabHome => _l10n.tabHome;
  String get tabCalendar => _l10n.tabCalendar;
  String get calendarGuestSubtitle => _l10n.calendarGuestSubtitle;
  String get calendarProviderHint => _l10n.calendarProviderHint;
  String get calendarClientHint => _l10n.calendarClientHint;
  String get calendarLegendAvailable => _l10n.calendarLegendAvailable;
  String get calendarLegendBusy => _l10n.calendarLegendBusy;
  String get calendarLegendAppointment => _l10n.calendarLegendAppointment;
  String get calendarMarkAvailable => _l10n.calendarMarkAvailable;
  String get calendarMarkBusy => _l10n.calendarMarkBusy;
  String get calendarMarkUnset => _l10n.calendarMarkUnset;
  String get calendarNoEventsDay => _l10n.calendarNoEventsDay;
  List<String> get calendarWeekdayShortLabels => [
        _l10n.calendarWeekdayMon,
        _l10n.calendarWeekdayTue,
        _l10n.calendarWeekdayWed,
        _l10n.calendarWeekdayThu,
        _l10n.calendarWeekdayFri,
        _l10n.calendarWeekdaySat,
        _l10n.calendarWeekdaySun,
      ];
  String get tabFavorites => _l10n.tabFavorites;
  String get tabBusiness => _l10n.tabBusiness;
  String get businessTabServices => _l10n.businessTabServices;
  String get businessTabTools => _l10n.businessTabTools;
  String get businessToolsSubtitle => _l10n.businessToolsSubtitle;
  String get myXizmatlarGuestSubtitle => _l10n.myXizmatlarGuestSubtitle;
  String get tabProfile => _l10n.tabProfile;
  String get filterYordamBor => _l10n.filterYordamBor;
  String get filterYordamKerak => _l10n.filterYordamKerak;
  String get filterCategory => _l10n.filterCategory;
  String get filterSubcategory => _l10n.filterSubcategory;
  String get filterPickCategoryFirst => _l10n.filterPickCategoryFirst;
  String get filterProviderType => _l10n.filterProviderType;
  String get filterProviderAll => _l10n.filterProviderAll;
  String get filterProviderTypeHint => _l10n.filterProviderTypeHint;
  String get filterProviderAllHint => _l10n.filterProviderAllHint;
  String get filterProviderIndividualHint => _l10n.filterProviderIndividualHint;
  String get filterProviderInstitutionHint =>
      _l10n.filterProviderInstitutionHint;
  String get filterAllCategories => _l10n.filterAllCategories;
  String get filterAllSubcategories => _l10n.filterAllSubcategories;
  String get filterCategoryHint => _l10n.filterCategoryHint;
  String get filterAllCategoriesHint => _l10n.filterAllCategoriesHint;
  String get filterAllSubcategoriesHint => _l10n.filterAllSubcategoriesHint;
  String get filterCity => _l10n.filterCity;
  String get filterAllCities => _l10n.filterAllCities;
  String get filterCityHint => _l10n.filterCityHint;
  String get filterAllCitiesHint => _l10n.filterAllCitiesHint;
  String get xizmatServiceCityRequired => _l10n.xizmatServiceCityRequired;
  String homeFeedShowing(String summary) => _l10n.homeFeedShowing(summary);

  String serviceCityLabel(String cityId) {
    return switch (cityId) {
      ServiceCityIds.toshkent => _l10n.serviceCityToshkent,
      ServiceCityIds.toshkentViloyati => _l10n.serviceCityToshkentViloyati,
      ServiceCityIds.samarqand => _l10n.serviceCitySamarqand,
      ServiceCityIds.buxoro => _l10n.serviceCityBuxoro,
      ServiceCityIds.nukus => _l10n.serviceCityNukus,
      ServiceCityIds.namangan => _l10n.serviceCityNamangan,
      ServiceCityIds.andijon => _l10n.serviceCityAndijon,
      ServiceCityIds.fargona => _l10n.serviceCityFargona,
      ServiceCityIds.qarshi => _l10n.serviceCityQarshi,
      ServiceCityIds.urganch => _l10n.serviceCityUrganch,
      ServiceCityIds.termiz => _l10n.serviceCityTermiz,
      ServiceCityIds.jizzax => _l10n.serviceCityJizzax,
      ServiceCityIds.navoiy => _l10n.serviceCityNavoiy,
      ServiceCityIds.qoqon => _l10n.serviceCityQoqon,
      ServiceCityIds.guliston => _l10n.serviceCityGuliston,
      ServiceCityIds.boshqa => _l10n.serviceCityBoshqa,
      _ => cityId,
    };
  }

  String? serviceCityDisplayLabel(String? rawCityId) {
    final id = ServiceCities.normalizeStored(rawCityId);
    if (id == null) return null;
    return serviceCityLabel(id);
  }
  String get filterPickProviderTypeFirst => _l10n.filterPickProviderTypeFirst;

  String providerTypeLabel(String providerType) =>
      providerType == 'institution'
          ? _l10n.xizmatProviderInstitution
          : _l10n.xizmatProviderIndividual;

  String providerTypeFilterLabel(String? providerType) {
    if (providerType == null) return filterProviderType;
    return providerTypeLabel(providerType);
  }

  String sectorLine(String categoryLabel, String subcategoryLabel) =>
      '$categoryLabel · $subcategoryLabel';

  String get homeEmptyTitle => _l10n.homeEmptyTitle;
  String get homeEmptySubtitle => _l10n.homeEmptySubtitle;
  String get homeDemoXizmat => _l10n.homeDemoXizmat;
  String get homeDemoPosts => _l10n.homeDemoPosts;
  String get homeJobsEmptyTitle => _l10n.homeJobsEmptyTitle;
  String get homeJobsEmptySubtitle => _l10n.homeJobsEmptySubtitle;
  String get favoritesEmptyTitle => _l10n.favoritesEmptyTitle;
  String get favoritesEmptySubtitle => _l10n.favoritesEmptySubtitle;
  String get profileGuestTitle => _l10n.profileGuestTitle;
  String get profileGuestSubtitle => _l10n.profileGuestSubtitle;
  String get profilePhone => _l10n.profilePhone;
  String get profileChangePhoto => _l10n.profileChangePhoto;
  String get profilePhotoUpdated => _l10n.profilePhotoUpdated;
  String get profilePhotoFailed => _l10n.profilePhotoFailed;
  String get login => _l10n.login;
  String get register => _l10n.register;
  String get notificationsTitle => _l10n.notificationsTitle;
  String get notificationsEmpty => _l10n.notificationsEmpty;
  String get fabPostYordamKerak => _l10n.fabPostYordamKerak;
  String get welcomeTitle => _l10n.welcomeTitle;
  String get welcomeBrand => _l10n.welcomeBrand;
  String get welcomeBody => _l10n.welcomeBody;
  String get startBrowsing => _l10n.startBrowsing;
  String get createAccount => _l10n.createAccount;
  String get alreadyHaveAccount => _l10n.alreadyHaveAccount;
  String get authContinueTitle => _l10n.authContinueTitle;
  String get later => _l10n.later;
  String get fullName => _l10n.fullName;
  String get email => _l10n.email;
  String get phone => _l10n.phone;
  String get password => _l10n.password;
  String get confirmPassword => _l10n.confirmPassword;
  String get fieldRequired => _l10n.fieldRequired;
  String get invalidEmail => _l10n.invalidEmail;
  String get invalidPhone => _l10n.invalidPhone;
  String get invalidNumber => _l10n.invalidNumber;
  String get invalidMinutes => _l10n.invalidMinutes;
  String get passwordTooShort => _l10n.passwordTooShort;
  String get passwordsDoNotMatch => _l10n.passwordsDoNotMatch;
  String get acceptTermsRequired => _l10n.acceptTermsRequired;
  String get acceptTerms => _l10n.acceptTerms;
  String get acceptTermsLead => _l10n.acceptTermsLead;
  String get acceptTermsLink => _l10n.acceptTermsLink;
  String get acceptTermsTrail => _l10n.acceptTermsTrail;
  String get forgotPassword => _l10n.forgotPassword;
  String get resetPasswordTitle => _l10n.resetPasswordTitle;
  String get resetPasswordBody => _l10n.resetPasswordBody;
  String get resetPasswordSubmit => _l10n.resetPasswordSubmit;
  String get resetPasswordSuccess => _l10n.resetPasswordSuccess;
  String get resetPasswordSendLink => _l10n.resetPasswordSendLink;
  String resetPasswordEmailSent(String emailAddress) =>
      _l10n.resetPasswordEmailSent(emailAddress);
  String get resetPasswordEmailHint => _l10n.resetPasswordEmailHint;
  String get resetPasswordExpiredTitle => _l10n.resetPasswordExpiredTitle;
  String get resetPasswordExpiredBody => _l10n.resetPasswordExpiredBody;
  String get continueAction => _l10n.continueAction;
  String get verifyEmailTitle => _l10n.verifyEmailTitle;
  String get openMail => _l10n.openMail;
  String get resendEmail => _l10n.resendEmail;
  String get continueBrowsing => _l10n.continueBrowsing;
  String get providerPromptTitle => _l10n.providerPromptTitle;
  String get providerPromptBody => _l10n.providerPromptBody;
  String get createXizmat => _l10n.createXizmat;
  String get signOut => _l10n.signOut;
  String get settings => _l10n.settings;
  String get settingsSubtitle => _l10n.settingsSubtitle;
  String get settingsAppearance => _l10n.settingsAppearance;
  String get settingsDarkMode => _l10n.settingsDarkMode;
  String get settingsThemeSystem => _l10n.settingsThemeSystem;
  String get settingsThemeLight => _l10n.settingsThemeLight;
  String get settingsThemeDark => _l10n.settingsThemeDark;
  String get settingsLanguage => _l10n.settingsLanguage;
  String get settingsTools => _l10n.settingsTools;
  String get settingsLegal => _l10n.settingsLegal;
  String get settingsPrivacy => _l10n.settingsPrivacy;
  String get settingsPrivacySection => _l10n.settingsPrivacySection;
  String get settingsShowPhoneLabel => _l10n.settingsShowPhoneLabel;
  String get settingsShowPhoneSubtitle => _l10n.settingsShowPhoneSubtitle;
  String get postContactSectionTitle => _l10n.postContactSectionTitle;
  String get postContactSectionSubtitle => _l10n.postContactSectionSubtitle;
  String get postContactPhoneLabel => _l10n.postContactPhoneLabel;
  String get postContactPhoneHint => _l10n.postContactPhoneHint;
  String get postContactPhoneOptional => _l10n.postContactPhoneOptional;
  String get postShowPhoneLabel => _l10n.postShowPhoneLabel;
  String get postShowPhoneSubtitle => _l10n.postShowPhoneSubtitle;
  String get postShowProfileLabel => _l10n.postShowProfileLabel;
  String get postShowProfileSubtitle => _l10n.postShowProfileSubtitle;
  String get postAuthorHidden => _l10n.postAuthorHidden;
  String get settingsTerms => _l10n.settingsTerms;
  String get settingsDeleteAccount => _l10n.settingsDeleteAccount;
  String get settingsDeleteAccountHint => _l10n.settingsDeleteAccountHint;
  String get settingsDeleteAccountConfirm => _l10n.settingsDeleteAccountConfirm;
  String get settingsDeleteAccountAction => _l10n.settingsDeleteAccountAction;
  String get settingsDeleteAccountDone => _l10n.settingsDeleteAccountDone;
  String get remindersTitle => _l10n.remindersTitle;
  String get remindersAdd => _l10n.remindersAdd;
  String get remindersEmptyTitle => _l10n.remindersEmptyTitle;
  String get remindersEmptySubtitle => _l10n.remindersEmptySubtitle;
  String get remindersUpcoming => _l10n.remindersUpcoming;
  String get remindersPast => _l10n.remindersPast;
  String get remindersFieldTitle => _l10n.remindersFieldTitle;
  String get remindersFieldClientName => _l10n.remindersFieldClientName;
  String get remindersFieldBody => _l10n.remindersFieldBody;
  String get remindersSave => _l10n.remindersSave;
  String get remindersSettingsSubtitle => _l10n.remindersSettingsSubtitle;
  String get legalPrivacyTitle => _l10n.legalPrivacyTitle;
  String get legalTermsTitle => _l10n.legalTermsTitle;
  String get legalPrivacyBody => _l10n.legalPrivacyBody;
  String get legalTermsBody => _l10n.legalTermsBody;
  String get shareXizmat => _l10n.shareXizmat;
  String get shareYordamKerak => _l10n.shareYordamKerak;
  String get shareCopied => _l10n.shareCopied;
  String get postNotFound => _l10n.postNotFound;

  String verifyEmailBody(String emailAddress) =>
      _l10n.verifyEmailBody(emailAddress);
  String get verifyEmailBodyMissing => _l10n.verifyEmailBodyMissing;
  String get verifyEmailCheck => _l10n.verifyEmailCheck;
  String get verifyEmailPending => _l10n.verifyEmailPending;

  String welcomeBack(String name) => _l10n.welcomeBack(name);
  String get welcomeGuestName => _l10n.welcomeGuestName;
  String welcomeNewTitle(String name) => _l10n.welcomeNewTitle(name);
  String get welcomeNewBody => _l10n.welcomeNewBody;
  String welcomeLoginTitle(String name) => _l10n.welcomeLoginTitle(name);
  String get welcomeLoginBody => _l10n.welcomeLoginBody;
  String welcomeReturnTitle(String name) => _l10n.welcomeReturnTitle(name);
  String get welcomeReturnBody => _l10n.welcomeReturnBody;
  String get welcomeReturnBodyYordamKerak => _l10n.welcomeReturnBodyYordamKerak;
  String homeGreetingShort(String name) => _l10n.homeGreetingShort(name);
  String get homeGreetingYordamBor => _l10n.homeGreetingYordamBor;
  String get homeGreetingYordamKerak => _l10n.homeGreetingYordamKerak;

  String shareXizmatMessage(String name) => _l10n.shareXizmatMessage(name);
  String shareYordamKerakMessage(String title) =>
      _l10n.shareYordamKerakMessage(title);

  String get actionSave => _l10n.actionSave;
  String get actionCancel => _l10n.actionCancel;
  String get actionEdit => _l10n.actionEdit;
  String get actionDelete => _l10n.actionDelete;
  String get actionView => _l10n.actionView;
  String get actionUnblock => _l10n.actionUnblock;
  String get actionSubmit => _l10n.actionSubmit;
  String get kelishuvTitle => _l10n.kelishuvTitle;
  String get kelishuvNotFound => _l10n.kelishuvNotFound;
  String get kelishuvMessages => _l10n.kelishuvMessages;
  String get kelishuvNoMessages => _l10n.kelishuvNoMessages;
  String get kelishuvOpeningOffer => _l10n.kelishuvOpeningOffer;
  String get kelishuvReject => _l10n.kelishuvReject;
  String get kelishuvCancel => _l10n.kelishuvCancel;
  String get kelishuvAccept => _l10n.kelishuvAccept;
  String get kelishuvComplete => _l10n.kelishuvComplete;
  String get kelishuvEditTerms => _l10n.kelishuvEditTerms;
  String get kelishuvTermsChanged => _l10n.kelishuvTermsChanged;
  String get kelishuvAwaitingComplete => _l10n.kelishuvAwaitingComplete;
  String get kelishuvPartyA => _l10n.kelishuvPartyA;
  String get kelishuvPartyB => _l10n.kelishuvPartyB;
  String get kelishuvCompleteA => _l10n.kelishuvCompleteA;
  String get kelishuvCompleteB => _l10n.kelishuvCompleteB;
  String get kelishuvDualAccepted => _l10n.kelishuvDualAccepted;
  String get kelishuvCompleteTooEarly => _l10n.kelishuvCompleteTooEarly;
  String kelishuvCompleteDaysLeft(int days) =>
      _l10n.kelishuvCompleteDaysLeft(days);
  String get kelishuvMessageHint => _l10n.kelishuvMessageHint;
  String get kelishuvIncoming => _l10n.kelishuvIncoming;
  String get kelishuvIncomingSub => _l10n.kelishuvIncomingSub;
  String get kelishuvRequests => _l10n.kelishuvRequests;
  String get kelishuvRequestsSub => _l10n.kelishuvRequestsSub;
  String get kelishuvArchive => _l10n.kelishuvArchive;
  String get kelishuvArchiveSub => _l10n.kelishuvArchiveSub;
  String get kelishuvNeedsResponse => _l10n.kelishuvNeedsResponse;
  String get kelishuvNeedsConfirm => _l10n.kelishuvNeedsConfirm;
  String get profileBlocked => _l10n.profileBlocked;
  String get profileClientBook => _l10n.profileClientBook;
  String get profileClientBookSub => _l10n.profileClientBookSub;
  String get profileEarnings => _l10n.profileEarnings;
  String get profileEarningsSub => _l10n.profileEarningsSub;
  String get profileMargin => _l10n.profileMargin;
  String get profileMarginSub => _l10n.profileMarginSub;
  String get profilePaymentReceipt => _l10n.profilePaymentReceipt;
  String get profilePaymentReceiptSub => _l10n.profilePaymentReceiptSub;
  String get receiptTitle => _l10n.receiptTitle;
  String get receiptNew => _l10n.receiptNew;
  String get receiptEmptyTitle => _l10n.receiptEmptyTitle;
  String get receiptEmptySubtitle => _l10n.receiptEmptySubtitle;
  String get receiptDocumentTitle => _l10n.receiptDocumentTitle;
  String get receiptNumber => _l10n.receiptNumber;
  String get receiptDate => _l10n.receiptDate;
  String get receiptSeller => _l10n.receiptSeller;
  String get receiptBuyer => _l10n.receiptBuyer;
  String get receiptBuyerName => _l10n.receiptBuyerName;
  String get receiptBuyerPhone => _l10n.receiptBuyerPhone;
  String get receiptPickClient => _l10n.receiptPickClient;
  String get receiptXizmat => _l10n.receiptXizmat;
  String get receiptLines => _l10n.receiptLines;
  String get receiptLineTitle => _l10n.receiptLineTitle;
  String get receiptQuantity => _l10n.receiptQuantity;
  String get receiptUnitPrice => _l10n.receiptUnitPrice;
  String get receiptLineTotal => _l10n.receiptLineTotal;
  String get receiptAddLine => _l10n.receiptAddLine;
  String get receiptDiscount => _l10n.receiptDiscount;
  String get receiptTaxEnable => _l10n.receiptTaxEnable;
  String get receiptTaxRate => _l10n.receiptTaxRate;
  String get receiptTaxLabel => _l10n.receiptTaxLabel;
  String get receiptTaxDisclaimer => _l10n.receiptTaxDisclaimer;
  String get receiptSubtotal => _l10n.receiptSubtotal;
  String get receiptTotal => _l10n.receiptTotal;
  String get receiptNote => _l10n.receiptNote;
  String get receiptDueDate => _l10n.receiptDueDate;
  String get receiptCurrency => _l10n.receiptCurrency;
  String get receiptCurrencyUzs => _l10n.receiptCurrencyUzs;
  String get receiptCurrencyUsd => _l10n.receiptCurrencyUsd;
  String get receiptSharePdf => _l10n.receiptSharePdf;
  String get receiptPreview => _l10n.receiptPreview;
  String get receiptSaved => _l10n.receiptSaved;
  String get receiptValidationBuyer => _l10n.receiptValidationBuyer;
  String get receiptValidationXizmat => _l10n.receiptValidationXizmat;
  String get receiptValidationLines => _l10n.receiptValidationLines;
  String get receiptFooterBranding => _l10n.receiptFooterBranding;
  String get receiptDeleteConfirm => _l10n.receiptDeleteConfirm;
  String get receiptTaxPresetCustom => _l10n.receiptTaxPresetCustom;
  String get marginTitle => _l10n.marginTitle;
  String get marginUnitsTitle => _l10n.marginUnitsTitle;
  String get marginUnitsSubtitle => _l10n.marginUnitsSubtitle;
  String get marginOpenUnits => _l10n.marginOpenUnits;
  String get marginAddUnit => _l10n.marginAddUnit;
  String get marginEditUnit => _l10n.marginEditUnit;
  String get marginUnitName => _l10n.marginUnitName;
  String get marginUnitCost => _l10n.marginUnitCost;
  String get marginUnitBasis => _l10n.marginUnitBasis;
  String get marginUnitBasisHint => _l10n.marginUnitBasisHint;
  String get marginUnitsEmptyTitle => _l10n.marginUnitsEmptyTitle;
  String get marginUnitsEmptySub => _l10n.marginUnitsEmptySub;
  String get marginAddProduct => _l10n.marginAddProduct;
  String get marginEditProduct => _l10n.marginEditProduct;
  String get marginProductName => _l10n.marginProductName;
  String get marginSalePrice => _l10n.marginSalePrice;
  String get marginCostTotal => _l10n.marginCostTotal;
  String get marginProfit => _l10n.marginProfit;
  String get marginMarginPercent => _l10n.marginMarginPercent;
  String get marginCostBreakdown => _l10n.marginCostBreakdown;
  String get marginAddLine => _l10n.marginAddLine;
  String get marginEditLine => _l10n.marginEditLine;
  String get marginLineName => _l10n.marginLineName;
  String get marginLineQuantity => _l10n.marginLineQuantity;
  String get marginLineUnitCost => _l10n.marginLineUnitCost;
  String get marginLineQuantityLabel => _l10n.marginLineQuantityLabel;
  String get marginLineQuantityLabelHint => _l10n.marginLineQuantityLabelHint;
  String get marginSelectUnit => _l10n.marginSelectUnit;
  String get marginCustomLine => _l10n.marginCustomLine;
  String get marginProductsEmptyTitle => _l10n.marginProductsEmptyTitle;
  String get marginProductsEmptySub => _l10n.marginProductsEmptySub;
  String get marginNameRequired => _l10n.marginNameRequired;
  String get marginPriceRequired => _l10n.marginPriceRequired;
  String get marginCostRequired => _l10n.marginCostRequired;
  String get marginQuantityRequired => _l10n.marginQuantityRequired;
  String get marginAvgMargin => _l10n.marginAvgMargin;
  String get marginPerProduct => _l10n.marginPerProduct;
  String get marginDeleteProduct => _l10n.marginDeleteProduct;
  String get marginDeleteUnit => _l10n.marginDeleteUnit;
  String get profileMyXizmatlar => _l10n.profileMyXizmatlar;
  String get profileSetAvailability => _l10n.profileSetAvailability;
  String get profileSectionLoadFailed => _l10n.profileSectionLoadFailed;
  String get actionRetry => _l10n.actionRetry;
  String get clientBookTitle => _l10n.clientBookTitle;
  String get clientBookList => _l10n.clientBookList;
  String get clientBookCalendar => _l10n.clientBookCalendar;
  String get clientBookOpenDeal => _l10n.clientBookOpenDeal;
  String get clientBookEditClient => _l10n.clientBookEditClient;
  String get clientBookAdd => _l10n.clientBookAdd;
  String get clientBookBookClient => _l10n.clientBookBookClient;
  String get clientBookEditBooking => _l10n.clientBookEditBooking;
  String get clientBookNameRequired => _l10n.clientBookNameRequired;
  String get clientBookDateRequired => _l10n.clientBookDateRequired;
  String get clientBookNoteLabel => _l10n.clientBookNoteLabel;
  String get clientBookEmptyTitle => _l10n.clientBookEmptyTitle;
  String get clientBookEmptySub => _l10n.clientBookEmptySub;
  String get clientBookDateLabel => _l10n.clientBookDateLabel;
  String get clientBookBookDay => _l10n.clientBookBookDay;
  String get clientBookCalendarHint => _l10n.clientBookCalendarHint;
  String get clientBookMarkComplete => _l10n.clientBookMarkComplete;
  String get clientBookMarkCancelled => _l10n.clientBookMarkCancelled;
  String get clientBookMarkPending => _l10n.clientBookMarkPending;
  String get clientBookCompleteAmount => _l10n.clientBookCompleteAmount;
  String get clientBookDeliveryCompleted => _l10n.clientBookDeliveryCompleted;
  String get clientBookDeliveryPending => _l10n.clientBookDeliveryPending;
  String get clientBookDeliveryCancelled => _l10n.clientBookDeliveryCancelled;
  String get clientBookNewClientOption => _l10n.clientBookNewClientOption;
  String get clientBookSelectClient => _l10n.clientBookSelectClient;
  String get clientBookServiceLabel => _l10n.clientBookServiceLabel;
  String clientBookBookingCount(int count) => _l10n.clientBookBookingCount(count);
  String get appointmentStatusUpcoming => _l10n.appointmentStatusUpcoming;
  String get appointmentStatusCancelled => _l10n.appointmentStatusCancelled;
  String get appointmentStatusPostponed => _l10n.appointmentStatusPostponed;
  String get appointmentStatusIncomplete => _l10n.appointmentStatusIncomplete;
  String get appointmentStatusCompleted => _l10n.appointmentStatusCompleted;
  String get kelishuvAppointmentRequiredTitle =>
      _l10n.kelishuvAppointmentRequiredTitle;
  String get kelishuvAppointmentRequiredBody =>
      _l10n.kelishuvAppointmentRequiredBody;
  String get remindersSettingsFollowUpLabel =>
      _l10n.remindersSettingsFollowUpLabel;
  String get remindersFollowUpPrompt => _l10n.remindersFollowUpPrompt;
  String get clientBookAppointmentHistory => _l10n.clientBookAppointmentHistory;
  String get clientBookAppointmentNotesLabel =>
      _l10n.clientBookAppointmentNotesLabel;
  String get clientBookPhotosLabel => _l10n.clientBookPhotosLabel;
  String get clientBookPhotosEmpty => _l10n.clientBookPhotosEmpty;
  String get clientBookAddPhoto => _l10n.clientBookAddPhoto;
  String clientBookClientStats(int completed, int cancelled, int upcoming) =>
      _l10n.clientBookClientStats(completed, cancelled, upcoming);
  String get remindersUpdateStatus => _l10n.remindersUpdateStatus;
  String appointmentStatusLabel(AppointmentStatus status) => switch (status) {
        AppointmentStatus.upcoming => appointmentStatusUpcoming,
        AppointmentStatus.cancelled => appointmentStatusCancelled,
        AppointmentStatus.postponed => appointmentStatusPostponed,
        AppointmentStatus.incomplete => appointmentStatusIncomplete,
        AppointmentStatus.completed => appointmentStatusCompleted,
      };
  String get remindersSettingsTitle => _l10n.remindersSettingsTitle;
  String get remindersSettingsAlertsLabel => _l10n.remindersSettingsAlertsLabel;
  String get remindersSettingsAtTime => _l10n.remindersSettingsAtTime;
  String get earningsTitle => _l10n.earningsTitle;
  String get earningsTotal => _l10n.earningsTotal;
  String get earningsEdit => _l10n.earningsEdit;
  String get earningsAdd => _l10n.earningsAdd;
  String get earningsAmountLabel => _l10n.earningsAmountLabel;
  String get earningsNoteLabel => _l10n.earningsNoteLabel;
  String get earningsAmountRequired => _l10n.earningsAmountRequired;
  String get earningsEmptyTitle => _l10n.earningsEmptyTitle;
  String get earningsEmptySub => _l10n.earningsEmptySub;
  String get earningsDisclaimer => _l10n.earningsDisclaimer;
  String get notificationsEmptySub => _l10n.notificationsEmptySub;
  String get notificationAlertsTitle => _l10n.notificationAlertsTitle;
  String get notificationAlertsSubtitle => _l10n.notificationAlertsSubtitle;
  String get notificationAlertsAdd => _l10n.notificationAlertsAdd;
  String get notificationAlertsEmpty => _l10n.notificationAlertsEmpty;
  String get notificationAlertNewService => _l10n.notificationAlertNewService;
  String get notificationAlertDiscount => _l10n.notificationAlertDiscount;
  String get notificationAlertHelpPost => _l10n.notificationAlertHelpPost;
  String get notificationAlertSeekerHint => _l10n.notificationAlertSeekerHint;
  String get notificationAlertProviderHint =>
      _l10n.notificationAlertProviderHint;
  String get notificationAlertsSaved => _l10n.notificationAlertsSaved;
  String get notificationAlertsRemoved => _l10n.notificationAlertsRemoved;
  String notificationTypeTitle(String type) => switch (type) {
        'kelishuv_accept' => _l10n.notificationKelishuvAccept,
        'kelishuv_message' => _l10n.notificationKelishuvMessage,
        'kelishuv_complete' => _l10n.notificationKelishuvComplete,
        'subsector_new_service' => _l10n.notificationSubsectorNewService,
        'subsector_discount' => _l10n.notificationSubsectorDiscount,
        'subsector_help_post' => _l10n.notificationSubsectorHelpPost,
        _ => _l10n.notificationGeneric,
      };
  String notificationTimeMinutes(int count) =>
      _l10n.notificationTimeMinutes(count);
  String notificationTimeHours(int count) => _l10n.notificationTimeHours(count);
  String notificationTimeDate(int day, int month) =>
      _l10n.notificationTimeDate(day, month);
  String get reviewsTitle => _l10n.reviewsTitle;
  String get reviewProviderReplyLabel => _l10n.reviewProviderReplyLabel;
  String get reviewsEmpty => _l10n.reviewsEmpty;
  String get reviewsRate => _l10n.reviewsRate;
  String xizmatCompletedCount(int count) => _l10n.xizmatCompletedCount(count);
  String get demoKelishuvBlocked => _l10n.demoKelishuvBlocked;
  String get demoKelishuvSimulatedNote => _l10n.demoKelishuvSimulatedNote;
  String get genericUser => _l10n.genericUser;

  String get actionPick => _l10n.actionPick;
  String get xizmatStepIdentity => _l10n.xizmatStepIdentity;
  String get xizmatStepPortfolio => _l10n.xizmatStepPortfolio;
  String get xizmatProviderIndividual => _l10n.xizmatProviderIndividual;
  String get xizmatProviderInstitution => _l10n.xizmatProviderInstitution;
  String get xizmatNameLabel => _l10n.xizmatNameLabel;
  String get xizmatDescriptionLabel => _l10n.xizmatDescriptionLabel;
  String get xizmatDescriptionFull => _l10n.xizmatDescriptionFull;
  String get xizmatServiceCityLabel => _l10n.xizmatServiceCityLabel;
  String get xizmatServiceCityHint => _l10n.xizmatServiceCityHint;
  String get xizmatContinue => _l10n.xizmatContinue;
  String get xizmatPortfolioHint => _l10n.xizmatPortfolioHint;
  String get xizmatHeroLabel => _l10n.xizmatHeroLabel;
  String get xizmatUploading => _l10n.xizmatUploading;
  String get xizmatReady => _l10n.xizmatReady;
  String get xizmatBack => _l10n.xizmatBack;
  String get xizmatSuccessTitle => _l10n.xizmatSuccessTitle;
  String get xizmatSuccessBody => _l10n.xizmatSuccessBody;
  String get xizmatEditTitle => _l10n.xizmatEditTitle;
  String get cannotRequestOwnXizmat => _l10n.cannotRequestOwnXizmat;
  String get xizmatNotFound => _l10n.xizmatNotFound;
  String get xizmatNoPermission => _l10n.xizmatNoPermission;
  String get xizmatBasicInfo => _l10n.xizmatBasicInfo;
  String get xizmatPortfolio => _l10n.xizmatPortfolio;
  String get xizmatPortfolioEmpty => _l10n.xizmatPortfolioEmpty;
  String get xizmatAddPhoto => _l10n.xizmatAddPhoto;
  String get xizmatSetHero => _l10n.xizmatSetHero;
  String get xizmatAnalytics => _l10n.xizmatAnalytics;
  String get xizmatReviewReplies => _l10n.xizmatReviewReplies;
  String get xizmatSaved => _l10n.xizmatSaved;
  String get xizmatReplySaved => _l10n.xizmatReplySaved;
  String get xizmatPickCategoryError => _l10n.xizmatPickCategoryError;
  String get yordamKerakPostTitle => _l10n.yordamKerakPostTitle;
  String get yordamKerakTitleLabel => _l10n.yordamKerakTitleLabel;
  String get yordamKerakTitleHint => _l10n.yordamKerakTitleHint;
  String get yordamKerakMessageLabel => _l10n.yordamKerakMessageLabel;
  String get yordamKerakMessageHint => _l10n.yordamKerakMessageHint;
  String get yordamKerakBudgetLabel => _l10n.yordamKerakBudgetLabel;
  String get yordamKerakDateLabel => _l10n.yordamKerakDateLabel;
  String get yordamKerakDurationLabel => _l10n.yordamKerakDurationLabel;
  String get yordamKerakPublish => _l10n.yordamKerakPublish;
  String get yordamKerakTitleTooShort => _l10n.yordamKerakTitleTooShort;
  String get yordamKerakMessageTooShort => _l10n.yordamKerakMessageTooShort;
  String get yordamKerakCategoryRequired => _l10n.yordamKerakCategoryRequired;
  String get yordamKerakSubcategoryRequired =>
      _l10n.yordamKerakSubcategoryRequired;
  String get userProfileTitle => _l10n.userProfileTitle;
  String get userProfileNotFound => _l10n.userProfileNotFound;
  String get userProfileServices => _l10n.userProfileServices;
  String get userProfileServicesEmpty => _l10n.userProfileServicesEmpty;
  String get userProfileRequests => _l10n.userProfileRequests;
  String get userProfileRequestsEmpty => _l10n.userProfileRequestsEmpty;
  String get userProfileAvailable => _l10n.userProfileAvailable;
  String get userProfileBusy => _l10n.userProfileBusy;
  String get userProfilePartiallyBusy => _l10n.userProfilePartiallyBusy;
  String get userProfileCall => _l10n.userProfileCall;
  String get userProfilePhoneHidden => _l10n.userProfilePhoneHidden;
  String get userProfileViewProfile => _l10n.userProfileViewProfile;
  String get xizmatProviderSection => _l10n.xizmatProviderSection;
  String get profileViewPublic => _l10n.profileViewPublic;
  String get profileCertificatesTitle => _l10n.profileCertificatesTitle;
  String get profileCertificatesSubtitle => _l10n.profileCertificatesSubtitle;
  String get profileCertificatesDisclaimer =>
      _l10n.profileCertificatesDisclaimer;
  String get profileCertificatesAdd => _l10n.profileCertificatesAdd;
  String get profileCertificatesTitleLabel =>
      _l10n.profileCertificatesTitleLabel;
  String get profileCertificatesTitleHint => _l10n.profileCertificatesTitleHint;
  String get profileCertificatesIssuerLabel =>
      _l10n.profileCertificatesIssuerLabel;
  String get profileCertificatesIssuerHint =>
      _l10n.profileCertificatesIssuerHint;
  String get profileCertificatesEmpty => _l10n.profileCertificatesEmpty;
  String get profileCertificatesMaxReached =>
      _l10n.profileCertificatesMaxReached;
  String get profileCertificatesAdded => _l10n.profileCertificatesAdded;
  String get profileCertificatesRemoved => _l10n.profileCertificatesRemoved;
  String get profileCertificatesRemoveTitle =>
      _l10n.profileCertificatesRemoveTitle;
  String get xizmatOtherServices => _l10n.xizmatOtherServices;
  String get xizmatViewAllServices => _l10n.xizmatViewAllServices;
  String get xizmatStatusAvailable => _l10n.xizmatStatusAvailable;
  String get xizmatStatusBusy => _l10n.xizmatStatusBusy;
  String get safetyTitle => _l10n.safetyTitle;
  String get safetyBlock => _l10n.safetyBlock;
  String safetyBlockConfirmMessage(String name) =>
      _l10n.safetyBlockConfirmMessage(name);
  String get safetyBlockDone => _l10n.safetyBlockDone;
  String get safetyHideUser => _l10n.safetyHideUser;
  String get safetyReportReason => _l10n.safetyReportReason;
  String get safetyReportHint => _l10n.safetyReportHint;
  String get safetyReportSubmit => _l10n.safetyReportSubmit;
  String get safetyReportDone => _l10n.safetyReportDone;
  String get reviewLater => _l10n.reviewLater;
  String get blockedUnblocked => _l10n.blockedUnblocked;
  String kelishuvMoreCount(int count) => _l10n.kelishuvMoreCount(count);
  String get demoPostPickReal => _l10n.demoPostPickReal;
  String get createXizmatFirst => _l10n.createXizmatFirst;
  String get pickXizmat => _l10n.pickXizmat;
  String get categoryPickTitle => _l10n.categoryPickTitle;
  String get categoryAll => _l10n.categoryAll;
  String get subcategoryAll => _l10n.subcategoryAll;
  String get analyticsViews => _l10n.analyticsViews;
  String get analyticsFavorites => _l10n.analyticsFavorites;
  String get analyticsActiveDeals => _l10n.analyticsActiveDeals;
  String get analyticsCompletedDeals => _l10n.analyticsCompletedDeals;
  String analyticsConversion(String rate) => _l10n.analyticsConversion(rate);
  String get kelishuvArchiveEmptyTitle => _l10n.kelishuvArchiveEmptyTitle;
  String get kelishuvArchiveEmptySub => _l10n.kelishuvArchiveEmptySub;

  String kelishuvStatusLabel(KelishuvStatus status) => switch (status) {
        KelishuvStatus.muzokarada => _l10n.kelishuvStatusNegotiating,
        KelishuvStatus.jarayonda => _l10n.kelishuvStatusInProgress,
        KelishuvStatus.bajarildi => _l10n.kelishuvStatusCompleted,
        KelishuvStatus.bekor => _l10n.kelishuvStatusCancelled,
        KelishuvStatus.rad => _l10n.kelishuvStatusRejected,
        KelishuvStatus.archived => _l10n.kelishuvStatusArchived,
      };

  String get busySlotTitle => _l10n.busySlotTitle;
  String busySlotMessage(String names) => _l10n.busySlotMessage(names);
  String get taklifTitle => _l10n.taklifTitle;
  String taklifFlowTitleYordamBor(String name) =>
      _l10n.taklifFlowTitleYordamBor(name);
  String taklifFlowTitleYordamKerak(String name) =>
      _l10n.taklifFlowTitleYordamKerak(name);
  String get repeatBook => _l10n.repeatBook;
  String get repeatBookTitle => _l10n.repeatBookTitle;
  String get taklifSubtitle => _l10n.taklifSubtitle;
  String get taklifMessageLabel => _l10n.taklifMessageLabel;
  String get taklifMessageHint => _l10n.taklifMessageHint;
  String get taklifPriceLabel => _l10n.taklifPriceLabel;
  String get taklifDateLabel => _l10n.taklifDateLabel;
  String get taklifDurationLabel => _l10n.taklifDurationLabel;
  String get taklifSubmit => _l10n.taklifSubmit;
  String get reviewCommentLabel => _l10n.reviewCommentLabel;
  String get reviewCommentHint => _l10n.reviewCommentHint;
  String get xizmatReplyLabel => _l10n.xizmatReplyLabel;
  String get xizmatReplyHint => _l10n.xizmatReplyHint;
  String get xizmatClientLabel => _l10n.xizmatClientLabel;
  String get kelishuvTermsDateLabel => _l10n.kelishuvTermsDateLabel;
  String get kelishuvTermsMessageLabel => _l10n.kelishuvTermsMessageLabel;
  String get kelishuvTermsPriceLabel => _l10n.kelishuvTermsPriceLabel;
  String kelishuvDetailPost(String title) => _l10n.kelishuvDetailPost(title);
  String kelishuvDetailPrice(String amount, String currency) =>
      _l10n.kelishuvDetailPrice(amount, currency);
  String kelishuvDetailTime(String slot) => _l10n.kelishuvDetailTime(slot);

  String get xizmatPricingSectionTitle => _l10n.xizmatPricingSectionTitle;
  String get xizmatPricingSectionSubtitle => _l10n.xizmatPricingSectionSubtitle;
  String get xizmatPricingNegotiable => _l10n.xizmatPricingNegotiable;
  String get xizmatPricingFixed => _l10n.xizmatPricingFixed;
  String get xizmatPricingHourly => _l10n.xizmatPricingHourly;
  String get xizmatPricingFixedRateLabel => _l10n.xizmatPricingFixedRateLabel;
  String get xizmatPricingHourlyRateLabel => _l10n.xizmatPricingHourlyRateLabel;
  String get xizmatPricingRateHint => _l10n.xizmatPricingRateHint;
  String get xizmatPricingMinDurationLabel => _l10n.xizmatPricingMinDurationLabel;
  String get xizmatPricingMinDurationHint => _l10n.xizmatPricingMinDurationHint;
  String get xizmatPricingRequiredError => _l10n.xizmatPricingRequiredError;
  String get xizmatPriceNegotiable => _l10n.xizmatPriceNegotiable;
  String xizmatPricePerHour(String amount) => _l10n.xizmatPricePerHour(amount);

  String get xizmatAvailabilitySectionTitle => _l10n.xizmatAvailabilitySectionTitle;
  String get xizmatAvailabilitySectionSubtitle =>
      _l10n.xizmatAvailabilitySectionSubtitle;
  String get xizmatAvailabilityShowLabel => _l10n.xizmatAvailabilityShowLabel;
  String get xizmatAvailabilityShowSubtitle =>
      _l10n.xizmatAvailabilityShowSubtitle;
  String get xizmatAvailabilityAvailableNow =>
      _l10n.xizmatAvailabilityAvailableNow;
  String get xizmatAvailabilityBusy => _l10n.xizmatAvailabilityBusy;
  String get xizmatAvailabilityCallMe => _l10n.xizmatAvailabilityCallMe;
  String get xizmatAvailabilityFromLabel => _l10n.xizmatAvailabilityFromLabel;
  String get xizmatAvailabilityUntilLabel => _l10n.xizmatAvailabilityUntilLabel;
  String xizmatAvailabilityUntilSuffix(String time) =>
      _l10n.xizmatAvailabilityUntilSuffix(time);
  String xizmatAvailabilityFromSuffix(String time) =>
      _l10n.xizmatAvailabilityFromSuffix(time);
  String xizmatAvailabilityRangeSuffix(String from, String until) =>
      _l10n.xizmatAvailabilityRangeSuffix(from, until);
  String get xizmatAvailabilityModeRequiredError =>
      _l10n.xizmatAvailabilityModeRequiredError;
  String get xizmatAvailabilityWindowInvalidError =>
      _l10n.xizmatAvailabilityWindowInvalidError;

  String get xizmatPromiseSectionTitle => _l10n.xizmatPromiseSectionTitle;
  String get xizmatPromiseSectionSubtitle => _l10n.xizmatPromiseSectionSubtitle;
  String get xizmatPromiseShowLabel => _l10n.xizmatPromiseShowLabel;
  String get xizmatPromiseShowSubtitle => _l10n.xizmatPromiseShowSubtitle;
  String get xizmatPromisePresetsLabel => _l10n.xizmatPromisePresetsLabel;
  String get xizmatPromiseFieldLabel => _l10n.xizmatPromiseFieldLabel;
  String get xizmatPromiseFieldHint => _l10n.xizmatPromiseFieldHint;
  String get xizmatPromisePreset1 => _l10n.xizmatPromisePreset1;
  String get xizmatPromisePreset2 => _l10n.xizmatPromisePreset2;
  String get xizmatPromisePreset3 => _l10n.xizmatPromisePreset3;
  String get xizmatPromiseDisclaimer => _l10n.xizmatPromiseDisclaimer;
  String get xizmatPromiseRequiredError => _l10n.xizmatPromiseRequiredError;
  String get xizmatPromiseTooLongError => _l10n.xizmatPromiseTooLongError;

  List<String> get xizmatPromisePresets => [
        xizmatPromisePreset1,
        xizmatPromisePreset2,
        xizmatPromisePreset3,
      ];

  String? kelishuvSlotLabel(DateTime? startDate, int? durationMinutes) {
    if (startDate == null) return null;
    final date =
        '${startDate.day.toString().padLeft(2, '0')}.${startDate.month.toString().padLeft(2, '0')}.${startDate.year}';
    if (durationMinutes != null) {
      return _l10n.kelishuvSlotDateDuration(date, durationMinutes);
    }
    return date;
  }

  String authContextSubtitle(AuthContextType type) => switch (type) {
        AuthContextType.generic => _l10n.authContextGeneric,
        AuthContextType.favorite => _l10n.authContextFavorite,
        AuthContextType.yordamKerak => _l10n.authContextYordamKerak,
        AuthContextType.yordamBor => _l10n.authContextYordamBor,
        AuthContextType.postJob => _l10n.authContextPostJob,
        AuthContextType.deal => _l10n.authContextDeal,
      };

  String get settingsHelp => _l10n.settingsHelp;
  String get settingsSafety => _l10n.settingsSafety;
  String get supportReportTitle => _l10n.supportReportTitle;
  String get supportReportSubtitle => _l10n.supportReportSubtitle;
  String get supportCategoryLabelField => _l10n.supportCategoryLabelField;
  String supportCategoryLabel(SupportCategory category) =>
      switch (category) {
        SupportCategory.bug => _l10n.supportCategoryBug,
        SupportCategory.account => _l10n.supportCategoryAccount,
        SupportCategory.payment => _l10n.supportCategoryPayment,
        SupportCategory.other => _l10n.supportCategoryOther,
      };
  String get supportDescriptionLabel => _l10n.supportDescriptionLabel;
  String get supportDescriptionHint => _l10n.supportDescriptionHint;
  String get supportSubmit => _l10n.supportSubmit;
  String get supportSubmitted => _l10n.supportSubmitted;
  String get supportLoginRequired => _l10n.supportLoginRequired;
  String get supportContactHint => _l10n.supportContactHint;
  String get supportMailtoFailed => _l10n.supportMailtoFailed;
  String get feedbackTitle => _l10n.feedbackTitle;
  String get feedbackSubtitle => _l10n.feedbackSubtitle;
  String get feedbackMessageLabel => _l10n.feedbackMessageLabel;
  String get feedbackMessageHint => _l10n.feedbackMessageHint;
  String get feedbackSubmit => _l10n.feedbackSubmit;
  String get feedbackThanks => _l10n.feedbackThanks;
  String get feedbackOpenFromSheet => _l10n.feedbackOpenFromSheet;
  String get appReviewTitle => _l10n.appReviewTitle;
  String get appReviewSubtitle => _l10n.appReviewSubtitle;
  String get appReviewYes => _l10n.appReviewYes;
  String get appReviewNo => _l10n.appReviewNo;
  String get appReviewLater => _l10n.appReviewLater;
  String get providerProgressTitle => _l10n.providerProgressTitle;
  String get providerProgressSubtitle => _l10n.providerProgressSubtitle;
  String providerTierLabel(ProviderTier tier) => switch (tier) {
        ProviderTier.newProvider => _l10n.providerTierNew,
        ProviderTier.active => _l10n.providerTierActive,
        ProviderTier.trusted => _l10n.providerTierTrusted,
        ProviderTier.top => _l10n.providerTierTop,
      };
  String providerJobsRating(int jobs, String rating) =>
      _l10n.providerJobsRating(jobs, rating);
  String providerNextMilestone(int count, String tier) =>
      _l10n.providerNextMilestone(count, tier);
  String get providerTipsTitle => _l10n.providerTipsTitle;
  String progressTipLabel(String tipId) => switch (tipId) {
        'add_certificate' => _l10n.progressTipAddCertificate,
        'set_availability' => _l10n.progressTipSetAvailability,
        'reply_reviews' => _l10n.progressTipReplyReviews,
        'add_portfolio' => _l10n.progressTipAddPortfolio,
        'set_pricing' => _l10n.progressTipSetPricing,
        'get_repeat_clients' => _l10n.progressTipRepeatClients,
        _ => tipId,
      };
  String get achievementsTitle => _l10n.achievementsTitle;
  String get achievementsEmptySub => _l10n.achievementsEmptySub;
  String achievementTitle(String id) => switch (id) {
        'first_xizmat' => _l10n.achievementFirstXizmat,
        'first_deal' => _l10n.achievementFirstDeal,
        'jobs_5' => _l10n.achievementJobs5,
        'jobs_10' => _l10n.achievementJobs10,
        'jobs_25' => _l10n.achievementJobs25,
        'first_five_star' => _l10n.achievementFirstFiveStar,
        'certificate_added' => _l10n.achievementCertificate,
        'repeat_client_3' => _l10n.achievementRepeatClient,
        _ => id,
      };
  String achievementBody(String id) => switch (id) {
        'first_xizmat' => _l10n.achievementBodyFirstXizmat,
        'first_deal' => _l10n.achievementBodyFirstDeal,
        'jobs_5' => _l10n.achievementBodyJobs5,
        'jobs_10' => _l10n.achievementBodyJobs10,
        'jobs_25' => _l10n.achievementBodyJobs25,
        'first_five_star' => _l10n.achievementBodyFirstFiveStar,
        'certificate_added' => _l10n.achievementBodyCertificate,
        'repeat_client_3' => _l10n.achievementBodyRepeatClient,
        _ => '',
      };
  String get actionContinue => _l10n.actionContinue;
  String get guidesTitle => _l10n.guidesTitle;
  String get guidesSubtitle => _l10n.guidesSubtitle;
  String guideTitle(String slug) => switch (slug) {
        'xizmat-that-converts' => _l10n.guideXizmatConvertsTitle,
        'pricing-models' => _l10n.guidePricingTitle,
        'repeat-clients' => _l10n.guideRepeatClientsTitle,
        'certificates-trust' => _l10n.guideCertificatesTitle,
        'review-replies' => _l10n.guideReviewRepliesTitle,
        _ => slug,
      };
  String guideBody(String slug) => switch (slug) {
        'xizmat-that-converts' => _l10n.guideXizmatConvertsBody,
        'pricing-models' => _l10n.guidePricingBody,
        'repeat-clients' => _l10n.guideRepeatClientsBody,
        'certificates-trust' => _l10n.guideCertificatesBody,
        'review-replies' => _l10n.guideReviewRepliesBody,
        _ => '',
      };
  String get safetyPaymentsBanner => _l10n.safetyPaymentsBanner;
  String get legalSafetyTitle => _l10n.legalSafetyTitle;
  String get legalSafetyBody => _l10n.legalSafetyBody;
  String get greetingMorning => _l10n.greetingMorning;
  String get greetingAfternoon => _l10n.greetingAfternoon;
  String get greetingEvening => _l10n.greetingEvening;
  String get greetingNight => _l10n.greetingNight;
  String get greetingWelcomeBack => _l10n.greetingWelcomeBack;
  String get greetingWelcomeNew => _l10n.greetingWelcomeNew;
  String greetingWithName(String greeting, String name) =>
      _l10n.greetingWithName(greeting, name);
  String homeFactAwaitingReply(int count) => _l10n.homeFactAwaitingReply(count);
  String homeFactInProgress(int count) => _l10n.homeFactInProgress(count);
  String get homeFactNewMember => _l10n.homeFactNewMember;
  String get continueYourTurn => _l10n.continueYourTurn;
  String get continueReplyToDeal => _l10n.continueReplyToDeal;
  String get continueInProgress => _l10n.continueInProgress;
  String get continueMarkDone => _l10n.continueMarkDone;
  String get continueDraftTitle => _l10n.continueDraftTitle;
  String get continueDraftUntitled => _l10n.continueDraftUntitled;
  String get continueDraftHint => _l10n.continueDraftHint;
  String get draftDelete => _l10n.draftDelete;
  String get draftDeleted => _l10n.draftDeleted;
  String get draftRestored => _l10n.draftRestored;
  String get draftStartOver => _l10n.draftStartOver;
  String get actionUndo => _l10n.actionUndo;
  String get quickAskHelp => _l10n.quickAskHelp;
  String get quickOfferService => _l10n.quickOfferService;
  String get feedEndTitle => _l10n.feedEndTitle;
  String get feedEndAskPrompt => _l10n.feedEndAskPrompt;
  String get feedEndJobsHint => _l10n.feedEndJobsHint;
  String get whatsNewTitle => _l10n.whatsNewTitle;
  String get whatsNewLookTitle => _l10n.whatsNewLookTitle;
  String get whatsNewLookBody => _l10n.whatsNewLookBody;
  String get whatsNewNextStepTitle => _l10n.whatsNewNextStepTitle;
  String get whatsNewNextStepBody => _l10n.whatsNewNextStepBody;
  String get whatsNewDraftsTitle => _l10n.whatsNewDraftsTitle;
  String get whatsNewDraftsBody => _l10n.whatsNewDraftsBody;
  String get whatsNewDone => _l10n.whatsNewDone;
  String get xizmatCardNew => _l10n.xizmatCardNew;
  String get favoriteAdd => _l10n.favoriteAdd;
  String get favoriteRemove => _l10n.favoriteRemove;
  String statJobsDone(int count) => _l10n.statJobsDone(count);
  String get statRating => _l10n.statRating;
  String get dealBondYou => _l10n.dealBondYou;
  String get dealBondYourTurn => _l10n.dealBondYourTurn;
  String dealBondWaiting(String name) => _l10n.dealBondWaiting(name);
  String get dealBondAgreed => _l10n.dealBondAgreed;
  String get dealBondDone => _l10n.dealBondDone;
  String get dealBondClosed => _l10n.dealBondClosed;
  String get undoDeleted => _l10n.undoDeleted;
  String get savedRemoved => _l10n.savedRemoved;
  String get yordamKerakTitleRequired => _l10n.yordamKerakTitleRequired;
  String get yordamKerakMessageRequired => _l10n.yordamKerakMessageRequired;
  String get stateErrorTitle => _l10n.stateErrorTitle;
  String get stateErrorBody => _l10n.stateErrorBody;
  String get stateOfflineBanner => _l10n.stateOfflineBanner;
  String get disabledHintServiceName => _l10n.disabledHintServiceName;
  String get disabledHintServiceCity => _l10n.disabledHintServiceCity;
  String get disabledHintServicePhoto => _l10n.disabledHintServicePhoto;
  String get disabledHintPickSubcategory => _l10n.disabledHintPickSubcategory;
  String get disabledHintOneAlert => _l10n.disabledHintOneAlert;
  String get milestoneOverline => _l10n.milestoneOverline;
  String get milestoneDismiss => _l10n.milestoneDismiss;
  String get notificationsTooltip => _l10n.notificationsTooltip;
  String a11yRating(String rating) => _l10n.a11yRating(rating);
  String get a11yNewProvider => _l10n.a11yNewProvider;
  String get filtersClear => _l10n.filtersClear;
  String get actionClose => _l10n.actionClose;
  String get actionMore => _l10n.actionMore;
  String get actionSend => _l10n.actionSend;
  String get actionPreviousMonth => _l10n.actionPreviousMonth;
  String get actionNextMonth => _l10n.actionNextMonth;
  String get a11yShowPassword => _l10n.a11yShowPassword;
  String get a11yHidePassword => _l10n.a11yHidePassword;
  String a11yStarRating(int count) => _l10n.a11yStarRating(count);
  String get detailPaneEmptyTitle => _l10n.detailPaneEmptyTitle;
  String get detailPaneEmptyBody => _l10n.detailPaneEmptyBody;
  String get taklifAskHint => _l10n.taklifAskHint;
  String get taklifAskSubtitle => _l10n.taklifAskSubtitle;
  String get taklifAskSubmit => _l10n.taklifAskSubmit;
  String dealOfferAutoCancel(int days) => _l10n.dealOfferAutoCancel(days);
  String dealOfferReplyWithin(int days) => _l10n.dealOfferReplyWithin(days);
  String get dealAcceptedRow => _l10n.dealAcceptedRow;
  String get dealCompletedRow => _l10n.dealCompletedRow;
  String get dealWithdrawOffer => _l10n.dealWithdrawOffer;
  String get dealWithdrawTitle => _l10n.dealWithdrawTitle;
  String get dealWithdrawBody => _l10n.dealWithdrawBody;
  String get dealChatOpensOnReply => _l10n.dealChatOpensOnReply;
  String get dealRejectTitle => _l10n.dealRejectTitle;
  String get dealRejectBody => _l10n.dealRejectBody;
  String get dealRejectCommentLabel => _l10n.dealRejectCommentLabel;
  String get dealSendNewOffer => _l10n.dealSendNewOffer;
  String get dealClosedNewOfferHint => _l10n.dealClosedNewOfferHint;
  String get archiveTabNeeded => _l10n.archiveTabNeeded;
  String get archiveTabProvided => _l10n.archiveTabProvided;
  String get archiveNeededEmpty => _l10n.archiveNeededEmpty;
  String get archiveProvidedEmpty => _l10n.archiveProvidedEmpty;
  String achievementsProgress(int unlocked, int total) =>
      _l10n.achievementsProgress(unlocked, total);
  String get achievementsShow => _l10n.achievementsShow;
  String get achievementsHide => _l10n.achievementsHide;
  String get yordamKerakCityRequired => _l10n.yordamKerakCityRequired;
  String get taklifContactTitle => _l10n.taklifContactTitle;
  String get taklifContactNote => _l10n.taklifContactNote;
  String get taklifFirstNameLabel => _l10n.taklifFirstNameLabel;
  String get taklifLastNameLabel => _l10n.taklifLastNameLabel;
  String get taklifFirstNameRequired => _l10n.taklifFirstNameRequired;
  String get taklifPhoneRequired => _l10n.taklifPhoneRequired;
  String get taklifMessageOptionalLabel => _l10n.taklifMessageOptionalLabel;
  String get dealContactTitle => _l10n.dealContactTitle;
  String get dealContactSent => _l10n.dealContactSent;
  String get dealsSectionTitle => _l10n.dealsSectionTitle;
  String get dealStateYourTurn => _l10n.dealStateYourTurn;
  String get dealStateSent => _l10n.dealStateSent;
  String get dealStateInProgress => _l10n.dealStateInProgress;
  String get dealStateAwaitingConfirm => _l10n.dealStateAwaitingConfirm;
  String get actionAdd => _l10n.actionAdd;
  String get businessEarningsTitle => _l10n.businessEarningsTitle;
  String get businessEarningsSee => _l10n.businessEarningsSee;
  String get businessStatWaitingLabel => _l10n.businessStatWaitingLabel;
  String get businessNextStepsTitle => _l10n.businessNextStepsTitle;
  String businessNextStepsProgress(int done, int total) =>
      _l10n.businessNextStepsProgress(done, total);
  String get businessStepPhotos => _l10n.businessStepPhotos;
  String get businessStepPhotosWhy => _l10n.businessStepPhotosWhy;
  String get businessStepPrice => _l10n.businessStepPrice;
  String get businessStepPriceWhy => _l10n.businessStepPriceWhy;
  String get businessStepAvailability => _l10n.businessStepAvailability;
  String get businessStepAvailabilityWhy => _l10n.businessStepAvailabilityWhy;
  String get businessStepShare => _l10n.businessStepShare;
  String get businessStepShareWhy => _l10n.businessStepShareWhy;
  String businessServicesCount(int count, int max) =>
      _l10n.businessServicesCount(count, max);
  String xizmatLimitReached(int max) => _l10n.xizmatLimitReached(max);
  String get calendarStatusCaption => _l10n.calendarStatusCaption;
  String get calendarLegendNeedHelp => _l10n.calendarLegendNeedHelp;
  String get calendarLegendGiveHelp => _l10n.calendarLegendGiveHelp;
  String get calendarLegendPersonal => _l10n.calendarLegendPersonal;
  String get calendarHintMark => _l10n.calendarHintMark;
  String get calendarHintClient => _l10n.calendarHintClient;
  String get calendarDayNotMarked => _l10n.calendarDayNotMarked;
  String get calendarWholeWorkingDay => _l10n.calendarWholeWorkingDay;
  String get calendarAddHours => _l10n.calendarAddHours;
  String get calendarRemoveHours => _l10n.calendarRemoveHours;
  String get calendarHoursFrom => _l10n.calendarHoursFrom;
  String get calendarHoursTo => _l10n.calendarHoursTo;
  String get calendarDayEvents => _l10n.calendarDayEvents;
  String get workingHoursTitle => _l10n.workingHoursTitle;
  String get workingHoursHint => _l10n.workingHoursHint;
  String get workingHoursSheetHint => _l10n.workingHoursSheetHint;
  String get workingHoursReset => _l10n.workingHoursReset;
  String get workingHoursInvalid => _l10n.workingHoursInvalid;
  String get workingHoursSaved => _l10n.workingHoursSaved;
  String get calendarDayWorking => _l10n.calendarDayWorking;
  String get calendarDayOff => _l10n.calendarDayOff;
  String get calendarSlotMarkBusy => _l10n.calendarSlotMarkBusy;
  String get calendarSlotMarkFree => _l10n.calendarSlotMarkFree;
  String get calendarPreviousDay => _l10n.calendarPreviousDay;
  String get calendarNextDay => _l10n.calendarNextDay;
  String get remindersShowBusy => _l10n.remindersShowBusy;
  String get remindersShowBusyHint => _l10n.remindersShowBusyHint;
  String get workingDaysTitle => _l10n.workingDaysTitle;
  String get workingDaysNone => _l10n.workingDaysNone;
  String get xizmatTodayDayOff => _l10n.xizmatTodayDayOff;
  String get remindersCancelledEmpty => _l10n.remindersCancelledEmpty;
  String get notificationsAppointmentsTitle => _l10n.notificationsAppointmentsTitle;
  String get xizmatOwnHoursTitle => _l10n.xizmatOwnHoursTitle;
  String xizmatOwnHoursOff(String hours) => _l10n.xizmatOwnHoursOff(hours);
  String get xizmatHoursInCalendar => _l10n.xizmatHoursInCalendar;
  String get xizmatHoursOpenCalendar => _l10n.xizmatHoursOpenCalendar;
  String get xizmatScheduleTitle => _l10n.xizmatScheduleTitle;
  String get xizmatScheduleNextDays => _l10n.xizmatScheduleNextDays;
  String get xizmatTodayFree => _l10n.xizmatTodayFree;
  String get xizmatTodayBusy => _l10n.xizmatTodayBusy;
  String xizmatTodayBusyAt(String hours) => _l10n.xizmatTodayBusyAt(hours);
  String xizmatTodayFreeAt(String hours) => _l10n.xizmatTodayFreeAt(hours);
  String get calendarNoRemindersDay => _l10n.calendarNoRemindersDay;
  String get sampleTag => _l10n.sampleTag;
  String get demoDealNote => _l10n.demoDealNote;
  String get feedInviteProvidersTitle => _l10n.feedInviteProvidersTitle;
  String get feedInviteProvidersBody => _l10n.feedInviteProvidersBody;
  String get feedInviteAskTitle => _l10n.feedInviteAskTitle;
  String get feedInviteAskBody => _l10n.feedInviteAskBody;
  String get feedInviteProvidersAction => _l10n.feedInviteProvidersAction;
  String get feedInviteAskAction => _l10n.feedInviteAskAction;
  String get sampleFindProvider => _l10n.sampleFindProvider;
  String get sampleFindProviderHint => _l10n.sampleFindProviderHint;
  String get sampleAlertNewServices => _l10n.sampleAlertNewServices;
  String get sampleRequestPosted => _l10n.sampleRequestPosted;
  String get sampleRequestTitle => _l10n.sampleRequestTitle;
  String get sampleRequestBody => _l10n.sampleRequestBody;
  String get sampleAlertHelpPosts => _l10n.sampleAlertHelpPosts;
  String get sampleAlertOn => _l10n.sampleAlertOn;
  String get foundingBadge => _l10n.foundingBadge;
  String get foundingBadgeNote => _l10n.foundingBadgeNote;
  String get inviteTitle => _l10n.inviteTitle;
  String get inviteBody => _l10n.inviteBody;
  String get inviteShare => _l10n.inviteShare;
  String get invitePrepare => _l10n.invitePrepare;
  String get inviteMessage => _l10n.inviteMessage;
  String invitePersonalMessage(String name, String trade, String city) =>
      _l10n.invitePersonalMessage(name, trade, city);
  String inviteOpenLink(String link) => _l10n.inviteOpenLink(link);
  String inviteAppLink(String link) => _l10n.inviteAppLink(link);
  String get invitePrepareTitle => _l10n.invitePrepareTitle;
  String get invitePrepareBody => _l10n.invitePrepareBody;
  String get invitePersonName => _l10n.invitePersonName;
  String get invitePersonPhone => _l10n.invitePersonPhone;
  String get invitePickTrade => _l10n.invitePickTrade;
  String get inviteSendWhatsApp => _l10n.inviteSendWhatsApp;
  String get inviteSendSms => _l10n.inviteSendSms;
  String get inviteSendOther => _l10n.inviteSendOther;
  String get inviteNeedTradeCity => _l10n.inviteNeedTradeCity;
  String get onbGoalTitle => _l10n.onbGoalTitle;
  String get onbGoalNeedHelp => _l10n.onbGoalNeedHelp;
  String get onbGoalNeedHelpSub => _l10n.onbGoalNeedHelpSub;
  String get onbGoalOffer => _l10n.onbGoalOffer;
  String get onbGoalOfferSub => _l10n.onbGoalOfferSub;
  String get onbGoalBoth => _l10n.onbGoalBoth;
  String get onbGoalBothSub => _l10n.onbGoalBothSub;
  String get onbCityTitle => _l10n.onbCityTitle;
  String get onbCitySub => _l10n.onbCitySub;
  String get onbNext => _l10n.onbNext;
  String get onbDone => _l10n.onbDone;
  String get onbSkip => _l10n.onbSkip;
  String onbStep(int current, int total) => _l10n.onbStep(current, total);
  String get onbIntro1Title => _l10n.onbIntro1Title;
  String get onbIntro1Body => _l10n.onbIntro1Body;
  String get onbIntro2Title => _l10n.onbIntro2Title;
  String get onbIntro2Body => _l10n.onbIntro2Body;
  String get onbIntro3Title => _l10n.onbIntro3Title;
  String get onbIntro3Body => _l10n.onbIntro3Body;
  String get onbIntro4Title => _l10n.onbIntro4Title;
  String get onbIntro4Body => _l10n.onbIntro4Body;
  String get onbTypeTitle => _l10n.onbTypeTitle;
  String get onbTypeSub => _l10n.onbTypeSub;
  String get onbTypeIndividualSub => _l10n.onbTypeIndividualSub;
  String get onbTypeInstitutionSub => _l10n.onbTypeInstitutionSub;
  String onbReadyToOffer(String action) => _l10n.onbReadyToOffer(action);
  String get inviteAction => _l10n.inviteAction;
  String invitePersonalMessageNoName(String trade, String city) =>
      _l10n.invitePersonalMessageNoName(trade, city);
  String get joinTitle => _l10n.joinTitle;
  String get joinBody => _l10n.joinBody;
  String get joinLookAround => _l10n.joinLookAround;
  String get onbStart => _l10n.onbStart;
  String get welcomeFindHelp => _l10n.welcomeFindHelp;
  String get welcomeGiveHelp => _l10n.welcomeGiveHelp;
  String get onbTileLawyer => _l10n.onbTileLawyer;
  String get onbTileBeauty => _l10n.onbTileBeauty;
  String get onbTileCatering => _l10n.onbTileCatering;
  String get onbTileVet => _l10n.onbTileVet;
  String get onbTileCleaning => _l10n.onbTileCleaning;
  String get onbTileElectrician => _l10n.onbTileElectrician;
  String get onbTilePlumber => _l10n.onbTilePlumber;
  String get onbTileDental => _l10n.onbTileDental;
  String onbMoreServices(int count) => _l10n.onbMoreServices(count);
  String get onbIllRequestTitle => _l10n.onbIllRequestTitle;
  String get onbIllToday => _l10n.onbIllToday;
  String get onbIllNewOffers => _l10n.onbIllNewOffers;
  String get onbIllName1 => _l10n.onbIllName1;
  String get onbIllName2 => _l10n.onbIllName2;
  String get onbIllOffer1 => _l10n.onbIllOffer1;
  String get onbIllOffer2 => _l10n.onbIllOffer2;
  String get onbIllNewRequest => _l10n.onbIllNewRequest;
  String get onbIllSocket => _l10n.onbIllSocket;
  String get onbTileTutor => _l10n.onbTileTutor;
  String get onbTileAuto => _l10n.onbTileAuto;
  String get searchTooltip => _l10n.searchTooltip;
  String get searchHint => _l10n.searchHint;
  String get searchPrompt => _l10n.searchPrompt;
  String get searchNoResults => _l10n.searchNoResults;
  String get searchNoResultsHint => _l10n.searchNoResultsHint;
  String get searchOffline => _l10n.searchOffline;
  String get onbTileRenovation => _l10n.onbTileRenovation;
  String get onbTileFitness => _l10n.onbTileFitness;
  String get onbTileTranslator => _l10n.onbTileTranslator;
  String get onbTileBarber => _l10n.onbTileBarber;
  String get onbTileMusic => _l10n.onbTileMusic;
  String get onbTileStylist => _l10n.onbTileStylist;
  String get onbTileKindergarten => _l10n.onbTileKindergarten;
  String get onbIllTutorTitle => _l10n.onbIllTutorTitle;
  String get onbIllStylistRequest => _l10n.onbIllStylistRequest;
  String onbKindsChip(int count) => _l10n.onbKindsChip(count);
  String get onbIllDentalRequestTitle => _l10n.onbIllDentalRequestTitle;
  String get onbTileDentist => _l10n.onbTileDentist;
  String get onbIllDentalOffer1 => _l10n.onbIllDentalOffer1;
  String get onbIllDentalOffer2 => _l10n.onbIllDentalOffer2;
  String get xizmatStatNoReviews => _l10n.xizmatStatNoReviews;
  String get xizmatStatPrice => _l10n.xizmatStatPrice;
  String get xizmatStatPerHour => _l10n.xizmatStatPerHour;
  String get xizmatStatNegotiable => _l10n.xizmatStatNegotiable;
  String get xizmatPromiseOwnWords => _l10n.xizmatPromiseOwnWords;
  String get xizmatAboutTitle => _l10n.xizmatAboutTitle;
  String get actionReadMore => _l10n.actionReadMore;
  String get actionReadLess => _l10n.actionReadLess;
  String reviewsCount(int count) => _l10n.reviewsCount(count);
  String reviewsSeeAll(int count) => _l10n.reviewsSeeAll(count);
  String get reviewsFilterAll => _l10n.reviewsFilterAll;
  String get reviewsFilterEmpty => _l10n.reviewsFilterEmpty;
  String reviewsBarA11y(int stars, int count) =>
      _l10n.reviewsBarA11y(stars, count);
  String get xizmatHowTitle => _l10n.xizmatHowTitle;
  String get xizmatHowAsk => _l10n.xizmatHowAsk;
  String get xizmatHowChat => _l10n.xizmatHowChat;
  String get xizmatHowAgree => _l10n.xizmatHowAgree;
  String providerMemberSince(String year) => _l10n.providerMemberSince(year);
  String providerServicesCount(int count) => _l10n.providerServicesCount(count);
  String get xizmatAboutHint => _l10n.xizmatAboutHint;
  String xizmatPricePerDay(String amount) => _l10n.xizmatPricePerDay(amount);
  String xizmatPricePerMonth(String amount) =>
      _l10n.xizmatPricePerMonth(amount);
  String xizmatPricePerUnit(String amount) => _l10n.xizmatPricePerUnit(amount);
  String get xizmatStatPerDay => _l10n.xizmatStatPerDay;
  String get xizmatStatPerMonth => _l10n.xizmatStatPerMonth;
  String get xizmatStatPerUnit => _l10n.xizmatStatPerUnit;
  String get priceChoiceTitle => _l10n.priceChoiceTitle;
  String get priceChoiceServiceHint => _l10n.priceChoiceServiceHint;
  String get priceChoiceRequestHint => _l10n.priceChoiceRequestHint;
  String get priceChoiceNegotiable => _l10n.priceChoiceNegotiable;
  String get priceChoiceNegotiableHint => _l10n.priceChoiceNegotiableHint;
  String get priceChoiceAmount => _l10n.priceChoiceAmount;
  String get priceChoiceAmountHint => _l10n.priceChoiceAmountHint;
  String get priceAmountLabel => _l10n.priceAmountLabel;
  String get priceAmountHint => _l10n.priceAmountHint;
  String get priceUnitFixed => _l10n.priceUnitFixed;
  String get priceUnitHour => _l10n.priceUnitHour;
  String get priceUnitDay => _l10n.priceUnitDay;
  String get priceUnitMonth => _l10n.priceUnitMonth;
  String get priceUnitUnit => _l10n.priceUnitUnit;
  String get priceChoiceRequired => _l10n.priceChoiceRequired;
  String get growthI00Title => _l10n.growthI00Title;
  String get growthI00Body => _l10n.growthI00Body;
  String get growthI01Title => _l10n.growthI01Title;
  String get growthI01Body => _l10n.growthI01Body;
  String get growthI02Title => _l10n.growthI02Title;
  String get growthI02Body => _l10n.growthI02Body;
  String get growthI03Title => _l10n.growthI03Title;
  String get growthI03Body => _l10n.growthI03Body;
  String get growthI04Title => _l10n.growthI04Title;
  String get growthI04Body => _l10n.growthI04Body;
  String get growthI05Title => _l10n.growthI05Title;
  String get growthI05Body => _l10n.growthI05Body;
  String get growthI06Title => _l10n.growthI06Title;
  String get growthI06Body => _l10n.growthI06Body;
  String get growthI07Title => _l10n.growthI07Title;
  String get growthI07Body => _l10n.growthI07Body;
  String get growthI08Title => _l10n.growthI08Title;
  String get growthI08Body => _l10n.growthI08Body;
  String get growthI09Title => _l10n.growthI09Title;
  String get growthI09Body => _l10n.growthI09Body;
  String get growthI10Title => _l10n.growthI10Title;
  String get growthI10Body => _l10n.growthI10Body;
  String get growthI11Title => _l10n.growthI11Title;
  String get growthI11Body => _l10n.growthI11Body;
  String get growthO00Title => _l10n.growthO00Title;
  String get growthO00Body => _l10n.growthO00Body;
  String get growthO01Title => _l10n.growthO01Title;
  String get growthO01Body => _l10n.growthO01Body;
  String get growthO02Title => _l10n.growthO02Title;
  String get growthO02Body => _l10n.growthO02Body;
  String get growthO03Title => _l10n.growthO03Title;
  String get growthO03Body => _l10n.growthO03Body;
  String get growthO04Title => _l10n.growthO04Title;
  String get growthO04Body => _l10n.growthO04Body;
  String get growthO05Title => _l10n.growthO05Title;
  String get growthO05Body => _l10n.growthO05Body;
  String get growthO06Title => _l10n.growthO06Title;
  String get growthO06Body => _l10n.growthO06Body;
  String get growthO07Title => _l10n.growthO07Title;
  String get growthO07Body => _l10n.growthO07Body;
  String get growthO08Title => _l10n.growthO08Title;
  String get growthO08Body => _l10n.growthO08Body;
  String get growthO09Title => _l10n.growthO09Title;
  String get growthO09Body => _l10n.growthO09Body;
  String get growthO10Title => _l10n.growthO10Title;
  String get growthO10Body => _l10n.growthO10Body;
  String get growthO11Title => _l10n.growthO11Title;
  String get growthO11Body => _l10n.growthO11Body;
  String get growthProgramTitle => _l10n.growthProgramTitle;
  String growthProgramDay(int day) => _l10n.growthProgramDay(day);
  String get growthTipDone => _l10n.growthTipDone;
  String get growthEarlierTips => _l10n.growthEarlierTips;
  String get growthTipsOff => _l10n.growthTipsOff;
  String get growthTipsOffDone => _l10n.growthTipsOffDone;
  String get growthTipsSetting => _l10n.growthTipsSetting;
  String get growthTipsSettingSub => _l10n.growthTipsSettingSub;
  String growthInviteShareText(String link) =>
      _l10n.growthInviteShareText(link);
  String get growthActionPhotos => _l10n.growthActionPhotos;
  String get growthActionPrice => _l10n.growthActionPrice;
  String get growthActionAvailability => _l10n.growthActionAvailability;
  String get growthActionHours => _l10n.growthActionHours;
  String get growthActionShare => _l10n.growthActionShare;
  String get growthActionInvite => _l10n.growthActionInvite;
  String get growthActionReply => _l10n.growthActionReply;
  String get growthActionDescription => _l10n.growthActionDescription;
  String get growthActionReviews => _l10n.growthActionReviews;
  String get growthActionCalendar => _l10n.growthActionCalendar;
  String get growthActionTools => _l10n.growthActionTools;
  String get growthActionCertificates => _l10n.growthActionCertificates;
  String get growthActionMoreServices => _l10n.growthActionMoreServices;
  String get growthActionMyServices => _l10n.growthActionMyServices;
  String get appointmentPhaseNow => _l10n.appointmentPhaseNow;
  String get appointmentPhaseToday => _l10n.appointmentPhaseToday;
  String get appointmentPhasePlanned => _l10n.appointmentPhasePlanned;
  String get appointmentPhasePast => _l10n.appointmentPhasePast;
  String get appointmentPhaseDone => _l10n.appointmentPhaseDone;
  String get appointmentPhaseCancelled => _l10n.appointmentPhaseCancelled;
  String get appointmentRoleProvider => _l10n.appointmentRoleProvider;
  String get appointmentRoleClient => _l10n.appointmentRoleClient;
  String get appointmentPartyClient => _l10n.appointmentPartyClient;
  String get appointmentPartyProvider => _l10n.appointmentPartyProvider;
  String get appointmentCall => _l10n.appointmentCall;
  String get actionChat => _l10n.actionChat;
  String get actionKeep => _l10n.actionKeep;
  String get appointmentCancel => _l10n.appointmentCancel;
  String get appointmentCancelTitle => _l10n.appointmentCancelTitle;
  String get appointmentCancelBody => _l10n.appointmentCancelBody;
  String get appointmentCancelConfirm => _l10n.appointmentCancelConfirm;
  String get appointmentSaveClient => _l10n.appointmentSaveClient;
  String get appointmentFactPrice => _l10n.appointmentFactPrice;
  String get appointmentFactDuration => _l10n.appointmentFactDuration;
  String appointmentDuration(int minutes) => _l10n.appointmentDuration(minutes);
  String get availabilitySheetCaption => _l10n.availabilitySheetCaption;
  String get availabilityTileNowHint => _l10n.availabilityTileNowHint;
  String get availabilityTileBusyHint => _l10n.availabilityTileBusyHint;
  String get availabilityTileBookingHint => _l10n.availabilityTileBookingHint;
  String get availabilityTileHidden => _l10n.availabilityTileHidden;
  String get availabilityTileHiddenHint => _l10n.availabilityTileHiddenHint;
  String get availabilityUntilTitle => _l10n.availabilityUntilTitle;
  String get availabilityUntilHour => _l10n.availabilityUntilHour;
  String get availabilityUntilToday => _l10n.availabilityUntilToday;
  String get availabilityUntilForever => _l10n.availabilityUntilForever;
  String get availabilityHoursTitle => _l10n.availabilityHoursTitle;
  String get availabilityHoursOwn => _l10n.availabilityHoursOwn;
  String get availabilityHoursShared => _l10n.availabilityHoursShared;
  String get availabilityBusyToggle => _l10n.availabilityBusyToggle;
  String get availabilityBusyToggleHint => _l10n.availabilityBusyToggleHint;
  String get availabilityPreview => _l10n.availabilityPreview;
  String get availabilityHiddenPreview => _l10n.availabilityHiddenPreview;
  String get availabilitySaved => _l10n.availabilitySaved;
  String get businessEmptyTitle => _l10n.businessEmptyTitle;
  String get businessEmptyBody => _l10n.businessEmptyBody;
  String get calendarTabTitle => _l10n.calendarTabTitle;
  String get calendarNoAppointments => _l10n.calendarNoAppointments;
  String get calendarNoAppointmentsHint => _l10n.calendarNoAppointmentsHint;
  String get calendarSectionToday => _l10n.calendarSectionToday;
  String get calendarSectionUpcoming => _l10n.calendarSectionUpcoming;
  String get calendarSectionPast => _l10n.calendarSectionPast;
  String get calendarBusyTitle => _l10n.calendarBusyTitle;
  String get calendarBusyAllDay => _l10n.calendarBusyAllDay;
  String get calendarBusyHours => _l10n.calendarBusyHours;
  String get calendarServicesStrip => _l10n.calendarServicesStrip;
  String get calendarReminders => _l10n.calendarReminders;
  String get reminderLeadDay => _l10n.reminderLeadDay;
  String get reminderLead3Hours => _l10n.reminderLead3Hours;
  String get reminderLeadHour => _l10n.reminderLeadHour;
  String get reminderLead15Min => _l10n.reminderLead15Min;
  String reminderLeadMinutes(int count) => _l10n.reminderLeadMinutes(count);
  String reminderLeadHours(int count) => _l10n.reminderLeadHours(count);
  String reminderLeadDays(int count) => _l10n.reminderLeadDays(count);
  String reminderFollowUpAfterHours(int count) =>
      _l10n.reminderFollowUpAfterHours(count);
  String get reminderFollowUpServiceDone => _l10n.reminderFollowUpServiceDone;
  String reminderDefaultBody(String name) => _l10n.reminderDefaultBody(name);
  String get remindersSettingsPickOne => _l10n.remindersSettingsPickOne;
  String get alertFromServiceTag => _l10n.alertFromServiceTag;
  String get alertFromServiceHint => _l10n.alertFromServiceHint;
  String get alertAnyCity => _l10n.alertAnyCity;
  String get errBadApiKey => _l10n.errBadApiKey;
  String get errWrongEmailOrPassword => _l10n.errWrongEmailOrPassword;
  String get errEmailNotConfirmed => _l10n.errEmailNotConfirmed;
  String get errEmailTaken => _l10n.errEmailTaken;
  String get errPhoneTaken => _l10n.errPhoneTaken;
  String get errSignInRequired => _l10n.errSignInRequired;
  String get errServerNotSetUp => _l10n.errServerNotSetUp;
  String get errGoogleSignInFailed => _l10n.errGoogleSignInFailed;
  String get errTelegramOpenFailed => _l10n.errTelegramOpenFailed;
  String get socialOrEmail => _l10n.socialOrEmail;
  String get socialContinueGoogle => _l10n.socialContinueGoogle;
  String get socialContinueTelegram => _l10n.socialContinueTelegram;
  String get profileSetupTitle => _l10n.profileSetupTitle;
  String get profileSetupNameHint => _l10n.profileSetupNameHint;
  String get profileSetupNameRequired => _l10n.profileSetupNameRequired;
  String get profileSetupNameFull => _l10n.profileSetupNameFull;
  String get profileSetupPhoneRequired => _l10n.profileSetupPhoneRequired;
  String get profileSetupPhoneIncomplete => _l10n.profileSetupPhoneIncomplete;
  String get profileSetupPhoneOnce => _l10n.profileSetupPhoneOnce;
  String profileSetupSignedInWith(String provider) =>
      _l10n.profileSetupSignedInWith(provider);
  String get errNoPermission => _l10n.errNoPermission;
  String get errDealNotFound => _l10n.errDealNotFound;
  String get errServiceNotFound => _l10n.errServiceNotFound;
  String get errOwnService => _l10n.errOwnService;
  String get errOwnRequest => _l10n.errOwnRequest;
  String get errDealNotCreated => _l10n.errDealNotCreated;
  String get errPhotoRequired => _l10n.errPhotoRequired;
  String get errOfferViaOwnService => _l10n.errOfferViaOwnService;
  String get errRequestNotFound => _l10n.errRequestNotFound;
  String get errServiceNotUploaded => _l10n.errServiceNotUploaded;
  String get errMessageTooShort => _l10n.errMessageTooShort;
  String get errMessageEmpty => _l10n.errMessageEmpty;
  String get errWrongPhoneOrPassword => _l10n.errWrongPhoneOrPassword;
  String get errDescriptionTooShort => _l10n.errDescriptionTooShort;
  String get errPickSubcategory => _l10n.errPickSubcategory;
  String get errPickCategory => _l10n.errPickCategory;
  String get errTermsOnlyOpenDeal => _l10n.errTermsOnlyOpenDeal;
  String get errPickCity => _l10n.errPickCity;
  String get errTitleMin3 => _l10n.errTitleMin3;
  String get errTitleMin2 => _l10n.errTitleMin2;
  String get errSignUpFailed => _l10n.errSignUpFailed;
  String get errResetLinkExpired => _l10n.errResetLinkExpired;
  String get errCannotBlockSelf => _l10n.errCannotBlockSelf;
  String errMaxAlerts(int count) => _l10n.errMaxAlerts(count);
  String errMaxCertificates(int count) => _l10n.errMaxCertificates(count);
  String get errDealNotUpdated => _l10n.errDealNotUpdated;
  String get errKeepOnePhoto => _l10n.errKeepOnePhoto;
  String get errPickAlertType => _l10n.errPickAlertType;
  String get errOwnProfileOnly => _l10n.errOwnProfileOnly;
  String get errOnlyAgreedDone => _l10n.errOnlyAgreedDone;
  String get errEmailNotFound => _l10n.errEmailNotFound;
  String get errDealAlreadyOpen => _l10n.errDealAlreadyOpen;
  String get errAccountNotFound => _l10n.errAccountNotFound;
  String get errAlreadyReviewed => _l10n.errAlreadyReviewed;
  String get errUserBlocked => _l10n.errUserBlocked;
  String get errNotNow => _l10n.errNotNow;
  String get errRatingRange => _l10n.errRatingRange;
  String get errTermsLocked => _l10n.errTermsLocked;
  String get errSlowNetwork => _l10n.errSlowNetwork;
  String get errTooManyAttempts => _l10n.errTooManyAttempts;
  String get errProjectDescriptionTooShort => _l10n.errProjectDescriptionTooShort;
  String errMaxServices(int count) => _l10n.errMaxServices(count);
  String get errDoneAfter3Days => _l10n.errDoneAfter3Days;
  String get errOffline => _l10n.errOffline;
  String get dealAcceptTitle => _l10n.dealAcceptTitle;
  String get dealAcceptBody => _l10n.dealAcceptBody;
  String get dealDoneTitle => _l10n.dealDoneTitle;
  String get dealDoneBodyLast => _l10n.dealDoneBodyLast;
  String get dealDoneBodyFirst => _l10n.dealDoneBodyFirst;
  String get dealDoneConfirm => _l10n.dealDoneConfirm;
  String get dealCancelTitle => _l10n.dealCancelTitle;
  String get dealCancelBody => _l10n.dealCancelBody;
  String get dealEditTitle => _l10n.dealEditTitle;
  String get dealEditBody => _l10n.dealEditBody;
  String get actionYes => _l10n.actionYes;
  String get actionNo => _l10n.actionNo;
  String get fallbackUserName => _l10n.fallbackUserName;
  String get fallbackServiceName => _l10n.fallbackServiceName;
  String get fallbackYou => _l10n.fallbackYou;
  String get channelAlerts => _l10n.channelAlerts;
  String get channelAlertsSub => _l10n.channelAlertsSub;
  String get channelReminders => _l10n.channelReminders;
  String get channelRemindersSub => _l10n.channelRemindersSub;
  String get channelTips => _l10n.channelTips;
  String get channelTipsSub => _l10n.channelTipsSub;
  String get remindersSettingsFollowUpHint =>
      _l10n.remindersSettingsFollowUpHint;

  /// "1 day before", "3 hours before", "15 minutes before" or "At time".
  String reminderLead(int minutes) {
    if (minutes <= 0) return remindersSettingsAtTime;
    if (minutes % 1440 == 0) return reminderLeadDays(minutes ~/ 1440);
    if (minutes % 60 == 0) return reminderLeadHours(minutes ~/ 60);
    return reminderLeadMinutes(minutes);
  }
  String get saveClientPromptTitle => _l10n.saveClientPromptTitle;
  String saveClientPromptBody(String name) => _l10n.saveClientPromptBody(name);
  String get saveClientConfirm => _l10n.saveClientConfirm;
  String get saveClientSkip => _l10n.saveClientSkip;
  String get saveClientDone => _l10n.saveClientDone;
  String get notifSectionSoon => _l10n.notifSectionSoon;
  String get notifAppointmentCancelledTitle =>
      _l10n.notifAppointmentCancelledTitle;
  String get notifSubsectorHelpTitle => _l10n.notifSubsectorHelpTitle;
}
