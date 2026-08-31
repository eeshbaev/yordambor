import 'package:flutter/material.dart';
import 'package:yordambor/data/support/support_repository.dart';
import 'package:yordambor/domain/entities/appointment_status.dart';
import 'package:yordambor/domain/entities/kelishuv.dart';
import 'package:yordambor/domain/growth/provider_tier.dart';
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

  static String languageLabel(String code) => switch (code) {
        'uz' => 'O\'zbek',
        'ru' => 'Русский',
        'en' => 'English',
        'zh' => '中文',
        _ => code,
      };

  String get appName => _l10n.appName;
  String get splashTagline => _l10n.splashTagline;
  String get tabHome => _l10n.tabHome;
  String get tabFavorites => _l10n.tabFavorites;
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
  String homeFeedShowing(String summary) => _l10n.homeFeedShowing(summary);
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
  String notificationTypeTitle(String type) => switch (type) {
        'kelishuv_accept' => _l10n.notificationKelishuvAccept,
        'kelishuv_message' => _l10n.notificationKelishuvMessage,
        'kelishuv_complete' => _l10n.notificationKelishuvComplete,
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

  @Deprecated('Use settingsDeleteAccountConfirm')
  String get settingsDeleteAccountSoon => _l10n.settingsDeleteAccountConfirm;

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
}
