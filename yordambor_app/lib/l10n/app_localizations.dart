import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'YordamBor'**
  String get appName;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'On YordamBor, help is here!'**
  String get splashTagline;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabFavorites.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get tabFavorites;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @filterYordamBor.
  ///
  /// In en, this message translates to:
  /// **'Help here'**
  String get filterYordamBor;

  /// No description provided for @filterYordamKerak.
  ///
  /// In en, this message translates to:
  /// **'Help needed'**
  String get filterYordamKerak;

  /// No description provided for @filterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get filterCategory;

  /// No description provided for @filterSubcategory.
  ///
  /// In en, this message translates to:
  /// **'Subcategory'**
  String get filterSubcategory;

  /// No description provided for @filterPickCategoryFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a category first'**
  String get filterPickCategoryFirst;

  /// No description provided for @filterProviderType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get filterProviderType;

  /// No description provided for @filterProviderAll.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get filterProviderAll;

  /// No description provided for @filterProviderTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a provider type'**
  String get filterProviderTypeHint;

  /// No description provided for @filterProviderAllHint.
  ///
  /// In en, this message translates to:
  /// **'Individuals and organizations'**
  String get filterProviderAllHint;

  /// No description provided for @filterProviderIndividualHint.
  ///
  /// In en, this message translates to:
  /// **'Freelancers, tutors, specialists'**
  String get filterProviderIndividualHint;

  /// No description provided for @filterProviderInstitutionHint.
  ///
  /// In en, this message translates to:
  /// **'Clinics, studios, companies'**
  String get filterProviderInstitutionHint;

  /// No description provided for @filterAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All sectors'**
  String get filterAllCategories;

  /// No description provided for @filterAllSubcategories.
  ///
  /// In en, this message translates to:
  /// **'All subsectors'**
  String get filterAllSubcategories;

  /// No description provided for @filterCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Which field are you looking in?'**
  String get filterCategoryHint;

  /// No description provided for @filterAllCategoriesHint.
  ///
  /// In en, this message translates to:
  /// **'Services across every field'**
  String get filterAllCategoriesHint;

  /// No description provided for @filterAllSubcategoriesHint.
  ///
  /// In en, this message translates to:
  /// **'All specialties in the selected field'**
  String get filterAllSubcategoriesHint;

  /// No description provided for @homeFeedShowing.
  ///
  /// In en, this message translates to:
  /// **'Showing: {summary}'**
  String homeFeedShowing(String summary);

  /// No description provided for @filterPickProviderTypeFirst.
  ///
  /// In en, this message translates to:
  /// **'Select individual or organization first'**
  String get filterPickProviderTypeFirst;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Services will appear here soon'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wait while service listings are added across categories'**
  String get homeEmptySubtitle;

  /// No description provided for @homeDemoXizmat.
  ///
  /// In en, this message translates to:
  /// **'Demo services shown as examples'**
  String get homeDemoXizmat;

  /// No description provided for @homeDemoPosts.
  ///
  /// In en, this message translates to:
  /// **'Demo posts shown as examples'**
  String get homeDemoPosts;

  /// No description provided for @homeJobsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Help needed posts'**
  String get homeJobsEmptyTitle;

  /// No description provided for @homeJobsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Post the first request or change filters'**
  String get homeJobsEmptySubtitle;

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Save services you like'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap ♥ on a card'**
  String get favoritesEmptySubtitle;

  /// No description provided for @profileGuestTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to YordamBor'**
  String get profileGuestTitle;

  /// No description provided for @profileGuestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up for deals and posting. Favorites work without an account.'**
  String get profileGuestSubtitle;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @profileChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get profileChangePhoto;

  /// No description provided for @profilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated'**
  String get profilePhotoUpdated;

  /// No description provided for @profilePhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not upload photo'**
  String get profilePhotoFailed;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get register;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmpty;

  /// No description provided for @fabPostYordamKerak.
  ///
  /// In en, this message translates to:
  /// **'Post request'**
  String get fabPostYordamKerak;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'On YordamBor, help is here!'**
  String get welcomeTitle;

  /// No description provided for @welcomeBrand.
  ///
  /// In en, this message translates to:
  /// **'YordamBor.'**
  String get welcomeBrand;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Discover all kinds of services. Offer help or ask for help.'**
  String get welcomeBody;

  /// No description provided for @startBrowsing.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get startBrowsing;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @authContinueTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authContinueTitle;

  /// No description provided for @authContextGeneric.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get authContextGeneric;

  /// No description provided for @authContextFavorite.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save favorites'**
  String get authContextFavorite;

  /// No description provided for @authContextYordamKerak.
  ///
  /// In en, this message translates to:
  /// **'Sign in to send a request'**
  String get authContextYordamKerak;

  /// No description provided for @authContextYordamBor.
  ///
  /// In en, this message translates to:
  /// **'Sign in to send an offer'**
  String get authContextYordamBor;

  /// No description provided for @authContextPostJob.
  ///
  /// In en, this message translates to:
  /// **'Sign in to post'**
  String get authContextPostJob;

  /// No description provided for @authContextDeal.
  ///
  /// In en, this message translates to:
  /// **'Sign in to start a deal'**
  String get authContextDeal;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number (+998...)'**
  String get invalidPhone;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get invalidNumber;

  /// No description provided for @invalidMinutes.
  ///
  /// In en, this message translates to:
  /// **'Enter valid minutes'**
  String get invalidMinutes;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @acceptTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms of use'**
  String get acceptTermsRequired;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the terms of use'**
  String get acceptTerms;

  /// No description provided for @acceptTermsLead.
  ///
  /// In en, this message translates to:
  /// **'I accept the '**
  String get acceptTermsLead;

  /// No description provided for @acceptTermsLink.
  ///
  /// In en, this message translates to:
  /// **'terms of use'**
  String get acceptTermsLink;

  /// No description provided for @acceptTermsTrail.
  ///
  /// In en, this message translates to:
  /// **''**
  String get acceptTermsTrail;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Enter and save your new password.'**
  String get resetPasswordBody;

  /// No description provided for @resetPasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get resetPasswordSubmit;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get resetPasswordSuccess;

  /// No description provided for @resetPasswordSendLink.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get resetPasswordSendLink;

  /// No description provided for @resetPasswordEmailSent.
  ///
  /// In en, this message translates to:
  /// **'We sent a password reset link to {emailAddress}.'**
  String resetPasswordEmailSent(String emailAddress);

  /// No description provided for @resetPasswordEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Open the link on your phone. The app will open so you can set a new password.'**
  String get resetPasswordEmailHint;

  /// No description provided for @resetPasswordExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Link expired'**
  String get resetPasswordExpiredTitle;

  /// No description provided for @resetPasswordExpiredBody.
  ///
  /// In en, this message translates to:
  /// **'Request a new password reset link.'**
  String get resetPasswordExpiredBody;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailBody.
  ///
  /// In en, this message translates to:
  /// **'We sent a confirmation link to {emailAddress}.'**
  String verifyEmailBody(String emailAddress);

  /// No description provided for @verifyEmailBodyMissing.
  ///
  /// In en, this message translates to:
  /// **'We sent a confirmation link to your email. After opening it, tap \"I confirmed\".'**
  String get verifyEmailBodyMissing;

  /// No description provided for @verifyEmailCheck.
  ///
  /// In en, this message translates to:
  /// **'I confirmed'**
  String get verifyEmailCheck;

  /// No description provided for @verifyEmailPending.
  ///
  /// In en, this message translates to:
  /// **'Email not verified yet. Check your inbox.'**
  String get verifyEmailPending;

  /// No description provided for @openMail.
  ///
  /// In en, this message translates to:
  /// **'Open mail app'**
  String get openMail;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resendEmail;

  /// No description provided for @continueBrowsing.
  ///
  /// In en, this message translates to:
  /// **'Continue browsing'**
  String get continueBrowsing;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcomeBack(String name);

  /// No description provided for @welcomeGuestName.
  ///
  /// In en, this message translates to:
  /// **'friend'**
  String get welcomeGuestName;

  /// No description provided for @welcomeNewTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcomeNewTitle(String name);

  /// No description provided for @welcomeNewBody.
  ///
  /// In en, this message translates to:
  /// **'We\'re so glad you joined YordamBor. Find services, offer help, or post a job — we\'re here for you every step of the way.'**
  String get welcomeNewBody;

  /// No description provided for @welcomeLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String welcomeLoginTitle(String name);

  /// No description provided for @welcomeLoginBody.
  ///
  /// In en, this message translates to:
  /// **'Great to see you again. What can we help you with today?'**
  String get welcomeLoginBody;

  /// No description provided for @welcomeReturnTitle.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String welcomeReturnTitle(String name);

  /// No description provided for @welcomeReturnBody.
  ///
  /// In en, this message translates to:
  /// **'The services you need are waiting for you.'**
  String get welcomeReturnBody;

  /// No description provided for @welcomeReturnBodyYordamKerak.
  ///
  /// In en, this message translates to:
  /// **'Do your services match client needs?'**
  String get welcomeReturnBodyYordamKerak;

  /// No description provided for @homeGreetingShort.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String homeGreetingShort(String name);

  /// No description provided for @homeGreetingYordamBor.
  ///
  /// In en, this message translates to:
  /// **'What help do you need today?'**
  String get homeGreetingYordamBor;

  /// No description provided for @homeGreetingYordamKerak.
  ///
  /// In en, this message translates to:
  /// **'Can you help today?'**
  String get homeGreetingYordamKerak;

  /// No description provided for @providerPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Do you offer services?'**
  String get providerPromptTitle;

  /// No description provided for @providerPromptBody.
  ///
  /// In en, this message translates to:
  /// **'Add a portfolio — clients will find you.'**
  String get providerPromptBody;

  /// No description provided for @createXizmat.
  ///
  /// In en, this message translates to:
  /// **'Create service'**
  String get createXizmat;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Language, privacy, account'**
  String get settingsSubtitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsDarkMode;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get settingsTools;

  /// No description provided for @settingsLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get settingsLegal;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacy;

  /// No description provided for @settingsPrivacySection.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacySection;

  /// No description provided for @settingsShowPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Show phone on my profile'**
  String get settingsShowPhoneLabel;

  /// No description provided for @settingsShowPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your phone number appears on your public profile'**
  String get settingsShowPhoneSubtitle;

  /// No description provided for @postContactSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get postContactSectionTitle;

  /// No description provided for @postContactSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile is always public. Showing your phone number is optional.'**
  String get postContactSectionSubtitle;

  /// No description provided for @postContactPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get postContactPhoneLabel;

  /// No description provided for @postContactPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+998 90 123 45 67'**
  String get postContactPhoneHint;

  /// No description provided for @postContactPhoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get postContactPhoneOptional;

  /// No description provided for @postShowPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Show phone number'**
  String get postShowPhoneLabel;

  /// No description provided for @postShowPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your phone appears on this listing'**
  String get postShowPhoneSubtitle;

  /// No description provided for @postShowProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'Show profile'**
  String get postShowProfileLabel;

  /// No description provided for @postShowProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Users can view your profile from this listing'**
  String get postShowProfileSubtitle;

  /// No description provided for @postAuthorHidden.
  ///
  /// In en, this message translates to:
  /// **'Author hidden'**
  String get postAuthorHidden;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get settingsTerms;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountHint.
  ///
  /// In en, this message translates to:
  /// **'All deals will be cancelled'**
  String get settingsDeleteAccountHint;

  /// No description provided for @settingsDeleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'All your data, services, and active deals will be deleted. This cannot be undone.'**
  String get settingsDeleteAccountConfirm;

  /// No description provided for @settingsDeleteAccountAction.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get settingsDeleteAccountAction;

  /// No description provided for @settingsDeleteAccountDone.
  ///
  /// In en, this message translates to:
  /// **'Account deleted'**
  String get settingsDeleteAccountDone;

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// No description provided for @remindersAdd.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get remindersAdd;

  /// No description provided for @remindersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reminders'**
  String get remindersEmptyTitle;

  /// No description provided for @remindersEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Synced with client book calendar. Also created when deals go in progress'**
  String get remindersEmptySubtitle;

  /// No description provided for @remindersFieldClientName.
  ///
  /// In en, this message translates to:
  /// **'Client name'**
  String get remindersFieldClientName;

  /// No description provided for @remindersUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get remindersUpcoming;

  /// No description provided for @remindersPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get remindersPast;

  /// No description provided for @remindersFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get remindersFieldTitle;

  /// No description provided for @remindersFieldBody.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get remindersFieldBody;

  /// No description provided for @remindersSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get remindersSave;

  /// No description provided for @remindersSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deal and appointment reminders'**
  String get remindersSettingsSubtitle;

  /// No description provided for @legalPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get legalPrivacyTitle;

  /// No description provided for @legalTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get legalTermsTitle;

  /// No description provided for @legalPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'YordamBor uses your data only to provide services, deals, and security.\n\n1. What we collect\n\nName, email, phone, service portfolio images, deal messages, and notifications.\n\n2. Where it is stored\n\nData is stored encrypted on Supabase servers.\n\n3. Third parties\n\nWe do not sell your data. We only share with technical partners required to run the app (hosting, email).\n\n4. Your rights\n\nYou may view, update, or delete your account and data.\n\n5. Contact\n\nQuestions: use the Settings section in the app.'**
  String get legalPrivacyBody;

  /// No description provided for @legalTermsBody.
  ///
  /// In en, this message translates to:
  /// **'YordamBor is a mobile platform connecting service providers and clients across categories. Using the app means you accept these terms.\n\n1. General\n\nYordamBor does not perform services itself — it connects parties. The platform is not a payment intermediary.\n\n2. Account and registration\n\nYou must provide accurate, up-to-date information and verify your email.\n\n3. Services and portfolio\n\nEvery service listing must include at least one real portfolio photo. False, misleading, or illegal listings may be removed.\n\n4. Deals (Yordam Bor / Yordam Kerak)\n\nPrice, timing, and scope are agreed between parties. YordamBor stores the deal process but does not collect payments.\n\n5. Prohibited conduct\n\nFraud, abuse, spam, illegal services, or deliberate rule violations are not allowed.\n\n6. Account suspension\n\nYordamBor may suspend or delete accounts that violate these terms.\n\n7. Changes\n\nTerms may be updated. Continued use means acceptance of the updated terms.\n\n8. Contact\n\nQuestions: use the Settings section in the app.'**
  String get legalTermsBody;

  /// No description provided for @shareXizmat.
  ///
  /// In en, this message translates to:
  /// **'Share service'**
  String get shareXizmat;

  /// No description provided for @shareXizmatMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out {name} on YordamBor'**
  String shareXizmatMessage(String name);

  /// No description provided for @shareYordamKerak.
  ///
  /// In en, this message translates to:
  /// **'Share request'**
  String get shareYordamKerak;

  /// No description provided for @shareYordamKerakMessage.
  ///
  /// In en, this message translates to:
  /// **'Help needed: {title} on YordamBor'**
  String shareYordamKerakMessage(String title);

  /// No description provided for @postNotFound.
  ///
  /// In en, this message translates to:
  /// **'Request not found'**
  String get postNotFound;

  /// No description provided for @shareCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get shareCopied;

  /// No description provided for @languageUz.
  ///
  /// In en, this message translates to:
  /// **'O\'zbek'**
  String get languageUz;

  /// No description provided for @languageRu.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRu;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageZh.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageZh;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get actionView;

  /// No description provided for @actionUnblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get actionUnblock;

  /// No description provided for @actionSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get actionSubmit;

  /// No description provided for @kelishuvTitle.
  ///
  /// In en, this message translates to:
  /// **'Deal'**
  String get kelishuvTitle;

  /// No description provided for @kelishuvNotFound.
  ///
  /// In en, this message translates to:
  /// **'Deal not found'**
  String get kelishuvNotFound;

  /// No description provided for @kelishuvMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get kelishuvMessages;

  /// No description provided for @kelishuvNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get kelishuvNoMessages;

  /// No description provided for @kelishuvOpeningOffer.
  ///
  /// In en, this message translates to:
  /// **'Initial offer'**
  String get kelishuvOpeningOffer;

  /// No description provided for @kelishuvReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get kelishuvReject;

  /// No description provided for @kelishuvCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get kelishuvCancel;

  /// No description provided for @kelishuvAccept.
  ///
  /// In en, this message translates to:
  /// **'I accept'**
  String get kelishuvAccept;

  /// No description provided for @kelishuvComplete.
  ///
  /// In en, this message translates to:
  /// **'Work completed'**
  String get kelishuvComplete;

  /// No description provided for @kelishuvEditTerms.
  ///
  /// In en, this message translates to:
  /// **'Edit terms'**
  String get kelishuvEditTerms;

  /// No description provided for @kelishuvTermsChanged.
  ///
  /// In en, this message translates to:
  /// **'Terms changed — both parties must confirm again'**
  String get kelishuvTermsChanged;

  /// No description provided for @kelishuvAwaitingComplete.
  ///
  /// In en, this message translates to:
  /// **'The other party confirmed completion — please confirm too'**
  String get kelishuvAwaitingComplete;

  /// No description provided for @kelishuvPartyA.
  ///
  /// In en, this message translates to:
  /// **'Party A'**
  String get kelishuvPartyA;

  /// No description provided for @kelishuvPartyB.
  ///
  /// In en, this message translates to:
  /// **'Party B'**
  String get kelishuvPartyB;

  /// No description provided for @kelishuvCompleteA.
  ///
  /// In en, this message translates to:
  /// **'A completed'**
  String get kelishuvCompleteA;

  /// No description provided for @kelishuvCompleteB.
  ///
  /// In en, this message translates to:
  /// **'B completed'**
  String get kelishuvCompleteB;

  /// No description provided for @kelishuvDualAccepted.
  ///
  /// In en, this message translates to:
  /// **'Both parties accepted'**
  String get kelishuvDualAccepted;

  /// No description provided for @kelishuvCompleteTooEarly.
  ///
  /// In en, this message translates to:
  /// **'Completion can be marked 3 days after work starts'**
  String get kelishuvCompleteTooEarly;

  /// No description provided for @kelishuvCompleteDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} day(s) until completion can be marked'**
  String kelishuvCompleteDaysLeft(int days);

  /// No description provided for @kelishuvMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Write a message...'**
  String get kelishuvMessageHint;

  /// No description provided for @kelishuvIncoming.
  ///
  /// In en, this message translates to:
  /// **'Incoming'**
  String get kelishuvIncoming;

  /// No description provided for @kelishuvIncomingSub.
  ///
  /// In en, this message translates to:
  /// **'Requests to your services'**
  String get kelishuvIncomingSub;

  /// No description provided for @kelishuvRequests.
  ///
  /// In en, this message translates to:
  /// **'My requests'**
  String get kelishuvRequests;

  /// No description provided for @kelishuvRequestsSub.
  ///
  /// In en, this message translates to:
  /// **'Deals you started'**
  String get kelishuvRequestsSub;

  /// No description provided for @kelishuvArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get kelishuvArchive;

  /// No description provided for @kelishuvArchiveSub.
  ///
  /// In en, this message translates to:
  /// **'Closed deals'**
  String get kelishuvArchiveSub;

  /// No description provided for @kelishuvNeedsResponse.
  ///
  /// In en, this message translates to:
  /// **'Response needed'**
  String get kelishuvNeedsResponse;

  /// No description provided for @kelishuvNeedsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get kelishuvNeedsConfirm;

  /// No description provided for @profileBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked users'**
  String get profileBlocked;

  /// No description provided for @profileClientBook.
  ///
  /// In en, this message translates to:
  /// **'Client book'**
  String get profileClientBook;

  /// No description provided for @profileClientBookSub.
  ///
  /// In en, this message translates to:
  /// **'Local client list'**
  String get profileClientBookSub;

  /// No description provided for @profileEarnings.
  ///
  /// In en, this message translates to:
  /// **'My earnings'**
  String get profileEarnings;

  /// No description provided for @profileEarningsSub.
  ///
  /// In en, this message translates to:
  /// **'Self-declared income'**
  String get profileEarningsSub;

  /// No description provided for @profileMyXizmatlar.
  ///
  /// In en, this message translates to:
  /// **'My services'**
  String get profileMyXizmatlar;

  /// No description provided for @profileSetAvailability.
  ///
  /// In en, this message translates to:
  /// **'Set availability'**
  String get profileSetAvailability;

  /// No description provided for @profileSectionLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load. Check your internet connection.'**
  String get profileSectionLoadFailed;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @clientBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Client book'**
  String get clientBookTitle;

  /// No description provided for @clientBookList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get clientBookList;

  /// No description provided for @clientBookCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get clientBookCalendar;

  /// No description provided for @clientBookOpenDeal.
  ///
  /// In en, this message translates to:
  /// **'Open deal'**
  String get clientBookOpenDeal;

  /// No description provided for @clientBookEditClient.
  ///
  /// In en, this message translates to:
  /// **'Edit client'**
  String get clientBookEditClient;

  /// No description provided for @clientBookAdd.
  ///
  /// In en, this message translates to:
  /// **'Add client'**
  String get clientBookAdd;

  /// No description provided for @clientBookBookClient.
  ///
  /// In en, this message translates to:
  /// **'Book client'**
  String get clientBookBookClient;

  /// No description provided for @clientBookEditBooking.
  ///
  /// In en, this message translates to:
  /// **'Edit booking'**
  String get clientBookEditBooking;

  /// No description provided for @clientBookNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter client name'**
  String get clientBookNameRequired;

  /// No description provided for @clientBookDateRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick an appointment date'**
  String get clientBookDateRequired;

  /// No description provided for @clientBookNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get clientBookNoteLabel;

  /// No description provided for @clientBookEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Client book is empty'**
  String get clientBookEmptyTitle;

  /// No description provided for @clientBookEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Book clients on the calendar or they are added when deals go in progress'**
  String get clientBookEmptySub;

  /// No description provided for @clientBookDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Appointment date'**
  String get clientBookDateLabel;

  /// No description provided for @clientBookBookDay.
  ///
  /// In en, this message translates to:
  /// **'Book this day'**
  String get clientBookBookDay;

  /// No description provided for @clientBookCalendarHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a day to book a client'**
  String get clientBookCalendarHint;

  /// No description provided for @clientBookMarkComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark service delivered'**
  String get clientBookMarkComplete;

  /// No description provided for @clientBookMarkCancelled.
  ///
  /// In en, this message translates to:
  /// **'Mark cancelled'**
  String get clientBookMarkCancelled;

  /// No description provided for @clientBookMarkPending.
  ///
  /// In en, this message translates to:
  /// **'Mark pending'**
  String get clientBookMarkPending;

  /// No description provided for @clientBookCompleteAmount.
  ///
  /// In en, this message translates to:
  /// **'Income from this client (UZS)'**
  String get clientBookCompleteAmount;

  /// No description provided for @clientBookDeliveryCompleted.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get clientBookDeliveryCompleted;

  /// No description provided for @clientBookDeliveryPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get clientBookDeliveryPending;

  /// No description provided for @clientBookDeliveryCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get clientBookDeliveryCancelled;

  /// No description provided for @clientBookNewClientOption.
  ///
  /// In en, this message translates to:
  /// **'New client'**
  String get clientBookNewClientOption;

  /// No description provided for @clientBookSelectClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get clientBookSelectClient;

  /// No description provided for @clientBookServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Service (optional)'**
  String get clientBookServiceLabel;

  /// No description provided for @clientBookBookingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} appointments'**
  String clientBookBookingCount(int count);

  /// No description provided for @appointmentStatusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get appointmentStatusUpcoming;

  /// No description provided for @appointmentStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get appointmentStatusCancelled;

  /// No description provided for @appointmentStatusPostponed.
  ///
  /// In en, this message translates to:
  /// **'Postponed'**
  String get appointmentStatusPostponed;

  /// No description provided for @appointmentStatusIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get appointmentStatusIncomplete;

  /// No description provided for @appointmentStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get appointmentStatusCompleted;

  /// No description provided for @kelishuvAppointmentRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Set appointment date'**
  String get kelishuvAppointmentRequiredTitle;

  /// No description provided for @kelishuvAppointmentRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'Both sides approved the deal. Pick when the service will happen.'**
  String get kelishuvAppointmentRequiredBody;

  /// No description provided for @remindersSettingsFollowUpLabel.
  ///
  /// In en, this message translates to:
  /// **'Follow-up checks (hours after appointment)'**
  String get remindersSettingsFollowUpLabel;

  /// No description provided for @remindersFollowUpPrompt.
  ///
  /// In en, this message translates to:
  /// **'Was this appointment successful?'**
  String get remindersFollowUpPrompt;

  /// No description provided for @clientBookAppointmentHistory.
  ///
  /// In en, this message translates to:
  /// **'Appointment history'**
  String get clientBookAppointmentHistory;

  /// No description provided for @clientBookAppointmentNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Appointment notes'**
  String get clientBookAppointmentNotesLabel;

  /// No description provided for @clientBookPhotosLabel.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get clientBookPhotosLabel;

  /// No description provided for @clientBookPhotosEmpty.
  ///
  /// In en, this message translates to:
  /// **'No photos yet'**
  String get clientBookPhotosEmpty;

  /// No description provided for @clientBookAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get clientBookAddPhoto;

  /// No description provided for @clientBookClientStats.
  ///
  /// In en, this message translates to:
  /// **'{completed} completed · {cancelled} cancelled · {upcoming} upcoming'**
  String clientBookClientStats(int completed, int cancelled, int upcoming);

  /// No description provided for @remindersUpdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Update status'**
  String get remindersUpdateStatus;

  /// No description provided for @remindersSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder settings'**
  String get remindersSettingsTitle;

  /// No description provided for @remindersSettingsAlertsLabel.
  ///
  /// In en, this message translates to:
  /// **'Alert times (minutes before)'**
  String get remindersSettingsAlertsLabel;

  /// No description provided for @remindersSettingsAtTime.
  ///
  /// In en, this message translates to:
  /// **'At time'**
  String get remindersSettingsAtTime;

  /// No description provided for @earningsTitle.
  ///
  /// In en, this message translates to:
  /// **'My earnings'**
  String get earningsTitle;

  /// No description provided for @earningsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total (self-declared)'**
  String get earningsTotal;

  /// No description provided for @earningsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit earnings'**
  String get earningsEdit;

  /// No description provided for @earningsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add earnings'**
  String get earningsAdd;

  /// No description provided for @earningsAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount (UZS)'**
  String get earningsAmountLabel;

  /// No description provided for @earningsNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get earningsNoteLabel;

  /// No description provided for @earningsAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get earningsAmountRequired;

  /// No description provided for @earningsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No earnings records'**
  String get earningsEmptyTitle;

  /// No description provided for @earningsEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Added automatically for priced deals in progress'**
  String get earningsEmptySub;

  /// No description provided for @earningsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is for your personal records only. Not tax or official reporting.'**
  String get earningsDisclaimer;

  /// No description provided for @notificationsEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Deal updates will appear here'**
  String get notificationsEmptySub;

  /// No description provided for @notificationKelishuvAccept.
  ///
  /// In en, this message translates to:
  /// **'Deal accepted'**
  String get notificationKelishuvAccept;

  /// No description provided for @notificationKelishuvMessage.
  ///
  /// In en, this message translates to:
  /// **'New message'**
  String get notificationKelishuvMessage;

  /// No description provided for @notificationKelishuvComplete.
  ///
  /// In en, this message translates to:
  /// **'Job completed'**
  String get notificationKelishuvComplete;

  /// No description provided for @notificationGeneric.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationGeneric;

  /// No description provided for @notificationTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String notificationTimeMinutes(int count);

  /// No description provided for @notificationTimeHours.
  ///
  /// In en, this message translates to:
  /// **'{count} h'**
  String notificationTimeHours(int count);

  /// No description provided for @notificationTimeDate.
  ///
  /// In en, this message translates to:
  /// **'{day}.{month}'**
  String notificationTimeDate(int day, int month);

  /// No description provided for @reviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsTitle;

  /// No description provided for @reviewProviderReplyLabel.
  ///
  /// In en, this message translates to:
  /// **'Provider reply'**
  String get reviewProviderReplyLabel;

  /// No description provided for @reviewsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get reviewsEmpty;

  /// No description provided for @reviewsRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get reviewsRate;

  /// No description provided for @xizmatCompletedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} completed'**
  String xizmatCompletedCount(int count);

  /// No description provided for @demoKelishuvBlocked.
  ///
  /// In en, this message translates to:
  /// **'Cannot create deals in demo mode'**
  String get demoKelishuvBlocked;

  /// No description provided for @genericUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get genericUser;

  /// No description provided for @actionPick.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get actionPick;

  /// No description provided for @xizmatStepIdentity.
  ///
  /// In en, this message translates to:
  /// **'1/3 — Who are you?'**
  String get xizmatStepIdentity;

  /// No description provided for @xizmatStepPortfolio.
  ///
  /// In en, this message translates to:
  /// **'2/3 — Portfolio'**
  String get xizmatStepPortfolio;

  /// No description provided for @xizmatProviderIndividual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get xizmatProviderIndividual;

  /// No description provided for @xizmatProviderInstitution.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get xizmatProviderInstitution;

  /// No description provided for @xizmatNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Service name'**
  String get xizmatNameLabel;

  /// No description provided for @xizmatDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Short description'**
  String get xizmatDescriptionLabel;

  /// No description provided for @xizmatDescriptionFull.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get xizmatDescriptionFull;

  /// No description provided for @xizmatServiceCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City you serve'**
  String get xizmatServiceCityLabel;

  /// No description provided for @xizmatServiceCityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Tashkent (optional)'**
  String get xizmatServiceCityHint;

  /// No description provided for @xizmatContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get xizmatContinue;

  /// No description provided for @xizmatPortfolioHint.
  ///
  /// In en, this message translates to:
  /// **'At least 1 image required. First image is the cover.'**
  String get xizmatPortfolioHint;

  /// No description provided for @xizmatHeroLabel.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get xizmatHeroLabel;

  /// No description provided for @xizmatUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get xizmatUploading;

  /// No description provided for @xizmatReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get xizmatReady;

  /// No description provided for @xizmatBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get xizmatBack;

  /// No description provided for @xizmatSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Your service is ready!'**
  String get xizmatSuccessTitle;

  /// No description provided for @xizmatSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Portfolio uploaded. Clients can now find you in Discover.'**
  String get xizmatSuccessBody;

  /// No description provided for @xizmatEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit service'**
  String get xizmatEditTitle;

  /// No description provided for @cannotRequestOwnXizmat.
  ///
  /// In en, this message translates to:
  /// **'You can\'t send a request to your own service'**
  String get cannotRequestOwnXizmat;

  /// No description provided for @xizmatNotFound.
  ///
  /// In en, this message translates to:
  /// **'Service not found'**
  String get xizmatNotFound;

  /// No description provided for @xizmatNoPermission.
  ///
  /// In en, this message translates to:
  /// **'No permission'**
  String get xizmatNoPermission;

  /// No description provided for @xizmatBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic info'**
  String get xizmatBasicInfo;

  /// No description provided for @xizmatPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get xizmatPortfolio;

  /// No description provided for @xizmatPortfolioEmpty.
  ///
  /// In en, this message translates to:
  /// **'Portfolio is empty. At least one image required.'**
  String get xizmatPortfolioEmpty;

  /// No description provided for @xizmatAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get xizmatAddPhoto;

  /// No description provided for @xizmatSetHero.
  ///
  /// In en, this message translates to:
  /// **'Set as cover'**
  String get xizmatSetHero;

  /// No description provided for @xizmatAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get xizmatAnalytics;

  /// No description provided for @xizmatReviewReplies.
  ///
  /// In en, this message translates to:
  /// **'Review replies'**
  String get xizmatReviewReplies;

  /// No description provided for @xizmatSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get xizmatSaved;

  /// No description provided for @xizmatReplySaved.
  ///
  /// In en, this message translates to:
  /// **'Reply saved'**
  String get xizmatReplySaved;

  /// No description provided for @xizmatPickCategoryError.
  ///
  /// In en, this message translates to:
  /// **'Select category and subcategory'**
  String get xizmatPickCategoryError;

  /// No description provided for @yordamKerakPostTitle.
  ///
  /// In en, this message translates to:
  /// **'Help needed post'**
  String get yordamKerakPostTitle;

  /// No description provided for @yordamKerakTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get yordamKerakTitleLabel;

  /// No description provided for @yordamKerakTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Plumber needed'**
  String get yordamKerakTitleHint;

  /// No description provided for @yordamKerakMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Project description'**
  String get yordamKerakMessageLabel;

  /// No description provided for @yordamKerakMessageHint.
  ///
  /// In en, this message translates to:
  /// **'What needs to be done, where, and when?'**
  String get yordamKerakMessageHint;

  /// No description provided for @yordamKerakBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget (optional, UZS)'**
  String get yordamKerakBudgetLabel;

  /// No description provided for @yordamKerakDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferred date (optional)'**
  String get yordamKerakDateLabel;

  /// No description provided for @yordamKerakDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes, optional)'**
  String get yordamKerakDurationLabel;

  /// No description provided for @yordamKerakPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get yordamKerakPublish;

  /// No description provided for @yordamKerakTitleTooShort.
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 3 characters'**
  String get yordamKerakTitleTooShort;

  /// No description provided for @yordamKerakMessageTooShort.
  ///
  /// In en, this message translates to:
  /// **'Description must be at least 10 characters'**
  String get yordamKerakMessageTooShort;

  /// No description provided for @yordamKerakCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get yordamKerakCategoryRequired;

  /// No description provided for @yordamKerakSubcategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a subcategory'**
  String get yordamKerakSubcategoryRequired;

  /// No description provided for @userProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get userProfileTitle;

  /// No description provided for @userProfileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get userProfileNotFound;

  /// No description provided for @userProfileServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get userProfileServices;

  /// No description provided for @userProfileServicesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No services yet'**
  String get userProfileServicesEmpty;

  /// No description provided for @userProfileRequests.
  ///
  /// In en, this message translates to:
  /// **'Help needed posts'**
  String get userProfileRequests;

  /// No description provided for @userProfileRequestsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No open posts'**
  String get userProfileRequestsEmpty;

  /// No description provided for @userProfileAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get userProfileAvailable;

  /// No description provided for @userProfileBusy.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get userProfileBusy;

  /// No description provided for @userProfilePartiallyBusy.
  ///
  /// In en, this message translates to:
  /// **'Partially unavailable'**
  String get userProfilePartiallyBusy;

  /// No description provided for @userProfileCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get userProfileCall;

  /// No description provided for @userProfilePhoneHidden.
  ///
  /// In en, this message translates to:
  /// **'Phone number is hidden'**
  String get userProfilePhoneHidden;

  /// No description provided for @userProfileViewProfile.
  ///
  /// In en, this message translates to:
  /// **'View profile'**
  String get userProfileViewProfile;

  /// No description provided for @xizmatProviderSection.
  ///
  /// In en, this message translates to:
  /// **'Service provider'**
  String get xizmatProviderSection;

  /// No description provided for @profileViewPublic.
  ///
  /// In en, this message translates to:
  /// **'My public profile'**
  String get profileViewPublic;

  /// No description provided for @profileCertificatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Certificates & credentials'**
  String get profileCertificatesTitle;

  /// No description provided for @profileCertificatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload credentials so clients can review them'**
  String get profileCertificatesSubtitle;

  /// No description provided for @profileCertificatesDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'YordamBor does not verify uploaded documents. Clients should confirm credentials themselves.'**
  String get profileCertificatesDisclaimer;

  /// No description provided for @profileCertificatesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add certificate'**
  String get profileCertificatesAdd;

  /// No description provided for @profileCertificatesTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get profileCertificatesTitleLabel;

  /// No description provided for @profileCertificatesTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Plumbing course certificate'**
  String get profileCertificatesTitleHint;

  /// No description provided for @profileCertificatesIssuerLabel.
  ///
  /// In en, this message translates to:
  /// **'Issuer (optional)'**
  String get profileCertificatesIssuerLabel;

  /// No description provided for @profileCertificatesIssuerHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Training center name'**
  String get profileCertificatesIssuerHint;

  /// No description provided for @profileCertificatesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No certificates uploaded yet'**
  String get profileCertificatesEmpty;

  /// No description provided for @profileCertificatesMaxReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum 8 certificates'**
  String get profileCertificatesMaxReached;

  /// No description provided for @profileCertificatesAdded.
  ///
  /// In en, this message translates to:
  /// **'Certificate added'**
  String get profileCertificatesAdded;

  /// No description provided for @profileCertificatesRemoved.
  ///
  /// In en, this message translates to:
  /// **'Certificate removed'**
  String get profileCertificatesRemoved;

  /// No description provided for @profileCertificatesRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove certificate?'**
  String get profileCertificatesRemoveTitle;

  /// No description provided for @xizmatOtherServices.
  ///
  /// In en, this message translates to:
  /// **'Other services'**
  String get xizmatOtherServices;

  /// No description provided for @xizmatViewAllServices.
  ///
  /// In en, this message translates to:
  /// **'View all services'**
  String get xizmatViewAllServices;

  /// No description provided for @xizmatStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get xizmatStatusAvailable;

  /// No description provided for @xizmatStatusBusy.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get xizmatStatusBusy;

  /// No description provided for @safetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get safetyTitle;

  /// No description provided for @safetyBlock.
  ///
  /// In en, this message translates to:
  /// **'Block'**
  String get safetyBlock;

  /// No description provided for @safetyBlockConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Block {name}? Their content will be hidden.'**
  String safetyBlockConfirmMessage(String name);

  /// No description provided for @safetyBlockDone.
  ///
  /// In en, this message translates to:
  /// **'User blocked'**
  String get safetyBlockDone;

  /// No description provided for @safetyHideUser.
  ///
  /// In en, this message translates to:
  /// **'Hide user'**
  String get safetyHideUser;

  /// No description provided for @safetyReportReason.
  ///
  /// In en, this message translates to:
  /// **'Report reason (optional)'**
  String get safetyReportReason;

  /// No description provided for @safetyReportHint.
  ///
  /// In en, this message translates to:
  /// **'What happened?'**
  String get safetyReportHint;

  /// No description provided for @safetyReportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit report'**
  String get safetyReportSubmit;

  /// No description provided for @safetyReportDone.
  ///
  /// In en, this message translates to:
  /// **'Report submitted. Thank you.'**
  String get safetyReportDone;

  /// No description provided for @reviewLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get reviewLater;

  /// No description provided for @blockedUnblocked.
  ///
  /// In en, this message translates to:
  /// **'Unblocked'**
  String get blockedUnblocked;

  /// No description provided for @kelishuvMoreCount.
  ///
  /// In en, this message translates to:
  /// **'{count} more'**
  String kelishuvMoreCount(int count);

  /// No description provided for @demoPostPickReal.
  ///
  /// In en, this message translates to:
  /// **'Demo post — pick a real one'**
  String get demoPostPickReal;

  /// No description provided for @createXizmatFirst.
  ///
  /// In en, this message translates to:
  /// **'Create your service profile first'**
  String get createXizmatFirst;

  /// No description provided for @pickXizmat.
  ///
  /// In en, this message translates to:
  /// **'Pick a service'**
  String get pickXizmat;

  /// No description provided for @categoryPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick category'**
  String get categoryPickTitle;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get categoryAll;

  /// No description provided for @subcategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All subcategories'**
  String get subcategoryAll;

  /// No description provided for @analyticsViews.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get analyticsViews;

  /// No description provided for @analyticsFavorites.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get analyticsFavorites;

  /// No description provided for @analyticsActiveDeals.
  ///
  /// In en, this message translates to:
  /// **'Active deals'**
  String get analyticsActiveDeals;

  /// No description provided for @analyticsCompletedDeals.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get analyticsCompletedDeals;

  /// No description provided for @analyticsConversion.
  ///
  /// In en, this message translates to:
  /// **'Conversion: {rate}%'**
  String analyticsConversion(String rate);

  /// No description provided for @kelishuvArchiveEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive is empty'**
  String get kelishuvArchiveEmptyTitle;

  /// No description provided for @kelishuvArchiveEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Completed or cancelled deals appear here'**
  String get kelishuvArchiveEmptySub;

  /// No description provided for @kelishuvStatusNegotiating.
  ///
  /// In en, this message translates to:
  /// **'Negotiating'**
  String get kelishuvStatusNegotiating;

  /// No description provided for @kelishuvStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get kelishuvStatusInProgress;

  /// No description provided for @kelishuvStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get kelishuvStatusCompleted;

  /// No description provided for @kelishuvStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get kelishuvStatusCancelled;

  /// No description provided for @kelishuvStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get kelishuvStatusRejected;

  /// No description provided for @kelishuvStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get kelishuvStatusArchived;

  /// No description provided for @busySlotTitle.
  ///
  /// In en, this message translates to:
  /// **'Busy time'**
  String get busySlotTitle;

  /// No description provided for @busySlotMessage.
  ///
  /// In en, this message translates to:
  /// **'You have an appointment on this date: {names}. Continue anyway?'**
  String busySlotMessage(String names);

  /// No description provided for @taklifFlowTitleYordamBor.
  ///
  /// In en, this message translates to:
  /// **'Help here — {name}'**
  String taklifFlowTitleYordamBor(String name);

  /// No description provided for @taklifFlowTitleYordamKerak.
  ///
  /// In en, this message translates to:
  /// **'Help needed — {name}'**
  String taklifFlowTitleYordamKerak(String name);

  /// No description provided for @taklifTitle.
  ///
  /// In en, this message translates to:
  /// **'Send offer'**
  String get taklifTitle;

  /// No description provided for @repeatBook.
  ///
  /// In en, this message translates to:
  /// **'Book again'**
  String get repeatBook;

  /// No description provided for @repeatBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Book again'**
  String get repeatBookTitle;

  /// No description provided for @taklifSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send your message and price at the start. Work begins after both parties accept.'**
  String get taklifSubtitle;

  /// No description provided for @taklifMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get taklifMessageLabel;

  /// No description provided for @taklifMessageHint.
  ///
  /// In en, this message translates to:
  /// **'How can you help?'**
  String get taklifMessageHint;

  /// No description provided for @taklifPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (optional, UZS)'**
  String get taklifPriceLabel;

  /// No description provided for @taklifDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Pick date (optional)'**
  String get taklifDateLabel;

  /// No description provided for @taklifDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes, optional)'**
  String get taklifDurationLabel;

  /// No description provided for @taklifSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send offer'**
  String get taklifSubmit;

  /// No description provided for @reviewCommentLabel.
  ///
  /// In en, this message translates to:
  /// **'Comment (optional)'**
  String get reviewCommentLabel;

  /// No description provided for @reviewCommentHint.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get reviewCommentHint;

  /// No description provided for @xizmatReplyLabel.
  ///
  /// In en, this message translates to:
  /// **'Your reply'**
  String get xizmatReplyLabel;

  /// No description provided for @xizmatReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Reply to the client'**
  String get xizmatReplyHint;

  /// No description provided for @xizmatClientLabel.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get xizmatClientLabel;

  /// No description provided for @kelishuvTermsDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Pick date'**
  String get kelishuvTermsDateLabel;

  /// No description provided for @kelishuvTermsMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get kelishuvTermsMessageLabel;

  /// No description provided for @kelishuvTermsPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (UZS)'**
  String get kelishuvTermsPriceLabel;

  /// No description provided for @kelishuvDetailPost.
  ///
  /// In en, this message translates to:
  /// **'Post: {title}'**
  String kelishuvDetailPost(String title);

  /// No description provided for @kelishuvDetailPrice.
  ///
  /// In en, this message translates to:
  /// **'Price: {amount} {currency}'**
  String kelishuvDetailPrice(String amount, String currency);

  /// No description provided for @kelishuvDetailTime.
  ///
  /// In en, this message translates to:
  /// **'Time: {slot}'**
  String kelishuvDetailTime(String slot);

  /// No description provided for @kelishuvSlotDateDuration.
  ///
  /// In en, this message translates to:
  /// **'{date} · {minutes} min'**
  String kelishuvSlotDateDuration(String date, int minutes);

  /// No description provided for @xizmatPricingSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get xizmatPricingSectionTitle;

  /// No description provided for @xizmatPricingSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose negotiable, fixed, or hourly — it\'s up to you.'**
  String get xizmatPricingSectionSubtitle;

  /// No description provided for @xizmatPricingNegotiable.
  ///
  /// In en, this message translates to:
  /// **'Negotiable'**
  String get xizmatPricingNegotiable;

  /// No description provided for @xizmatPricingFixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get xizmatPricingFixed;

  /// No description provided for @xizmatPricingHourly.
  ///
  /// In en, this message translates to:
  /// **'Hourly'**
  String get xizmatPricingHourly;

  /// No description provided for @xizmatPricingFixedRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (UZS)'**
  String get xizmatPricingFixedRateLabel;

  /// No description provided for @xizmatPricingHourlyRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Hourly rate (UZS)'**
  String get xizmatPricingHourlyRateLabel;

  /// No description provided for @xizmatPricingRateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 150000'**
  String get xizmatPricingRateHint;

  /// No description provided for @xizmatPricingMinDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Minimum duration (minutes, optional)'**
  String get xizmatPricingMinDurationLabel;

  /// No description provided for @xizmatPricingMinDurationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 120'**
  String get xizmatPricingMinDurationHint;

  /// No description provided for @xizmatPricingRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Enter a price for fixed or hourly pricing'**
  String get xizmatPricingRequiredError;

  /// No description provided for @xizmatPriceNegotiable.
  ///
  /// In en, this message translates to:
  /// **'Price negotiable'**
  String get xizmatPriceNegotiable;

  /// No description provided for @xizmatPricePerHour.
  ///
  /// In en, this message translates to:
  /// **'{amount}/hr'**
  String xizmatPricePerHour(String amount);

  /// No description provided for @xizmatAvailabilitySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get xizmatAvailabilitySectionTitle;

  /// No description provided for @xizmatAvailabilitySectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional — let clients know if you\'re free. Client Book does not change this.'**
  String get xizmatAvailabilitySectionSubtitle;

  /// No description provided for @xizmatAvailabilityShowLabel.
  ///
  /// In en, this message translates to:
  /// **'Show availability'**
  String get xizmatAvailabilityShowLabel;

  /// No description provided for @xizmatAvailabilityShowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When off, no status badge is shown'**
  String get xizmatAvailabilityShowSubtitle;

  /// No description provided for @xizmatAvailabilityAvailableNow.
  ///
  /// In en, this message translates to:
  /// **'Available now'**
  String get xizmatAvailabilityAvailableNow;

  /// No description provided for @xizmatAvailabilityBusy.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get xizmatAvailabilityBusy;

  /// No description provided for @xizmatAvailabilityCallMe.
  ///
  /// In en, this message translates to:
  /// **'Call to book'**
  String get xizmatAvailabilityCallMe;

  /// No description provided for @xizmatAvailabilityFromLabel.
  ///
  /// In en, this message translates to:
  /// **'From (optional)'**
  String get xizmatAvailabilityFromLabel;

  /// No description provided for @xizmatAvailabilityUntilLabel.
  ///
  /// In en, this message translates to:
  /// **'Until (optional)'**
  String get xizmatAvailabilityUntilLabel;

  /// No description provided for @xizmatAvailabilityUntilSuffix.
  ///
  /// In en, this message translates to:
  /// **' · until {time}'**
  String xizmatAvailabilityUntilSuffix(String time);

  /// No description provided for @xizmatAvailabilityFromSuffix.
  ///
  /// In en, this message translates to:
  /// **' · from {time}'**
  String xizmatAvailabilityFromSuffix(String time);

  /// No description provided for @xizmatAvailabilityRangeSuffix.
  ///
  /// In en, this message translates to:
  /// **' · {from}–{until}'**
  String xizmatAvailabilityRangeSuffix(String from, String until);

  /// No description provided for @xizmatAvailabilityModeRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Pick an availability mode'**
  String get xizmatAvailabilityModeRequiredError;

  /// No description provided for @xizmatAvailabilityWindowInvalidError.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get xizmatAvailabilityWindowInvalidError;

  /// No description provided for @xizmatPromiseSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your promise'**
  String get xizmatPromiseSectionTitle;

  /// No description provided for @xizmatPromiseSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell clients what you stand for. This is your motto — not a YordamBor warranty.'**
  String get xizmatPromiseSectionSubtitle;

  /// No description provided for @xizmatPromiseShowLabel.
  ///
  /// In en, this message translates to:
  /// **'Show my promise'**
  String get xizmatPromiseShowLabel;

  /// No description provided for @xizmatPromiseShowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Displayed on your listing for clients to read'**
  String get xizmatPromiseShowSubtitle;

  /// No description provided for @xizmatPromisePresetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Quick presets (editable)'**
  String get xizmatPromisePresetsLabel;

  /// No description provided for @xizmatPromiseFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Your promise'**
  String get xizmatPromiseFieldLabel;

  /// No description provided for @xizmatPromiseFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Write your own or edit a preset'**
  String get xizmatPromiseFieldHint;

  /// No description provided for @xizmatPromisePreset1.
  ///
  /// In en, this message translates to:
  /// **'If you\'re not satisfied, I\'ll redo the work'**
  String get xizmatPromisePreset1;

  /// No description provided for @xizmatPromisePreset2.
  ///
  /// In en, this message translates to:
  /// **'Quality guaranteed — if there\'s a problem, I\'ll refund you'**
  String get xizmatPromisePreset2;

  /// No description provided for @xizmatPromisePreset3.
  ///
  /// In en, this message translates to:
  /// **'On time and at the agreed price'**
  String get xizmatPromisePreset3;

  /// No description provided for @xizmatPromiseDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'YordamBor does not provide warranties. This is the provider\'s own statement.'**
  String get xizmatPromiseDisclaimer;

  /// No description provided for @xizmatPromiseRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Enter your promise or turn this off'**
  String get xizmatPromiseRequiredError;

  /// No description provided for @xizmatPromiseTooLongError.
  ///
  /// In en, this message translates to:
  /// **'Promise is too long'**
  String get xizmatPromiseTooLongError;

  /// No description provided for @settingsHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get settingsHelp;

  /// No description provided for @supportReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report a problem'**
  String get supportReportTitle;

  /// No description provided for @supportReportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bug, account, or payment concern'**
  String get supportReportSubtitle;

  /// No description provided for @supportCategoryLabelField.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get supportCategoryLabelField;

  /// No description provided for @supportCategoryBug.
  ///
  /// In en, this message translates to:
  /// **'Bug'**
  String get supportCategoryBug;

  /// No description provided for @supportCategoryAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get supportCategoryAccount;

  /// No description provided for @supportCategoryPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment concern'**
  String get supportCategoryPayment;

  /// No description provided for @supportCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get supportCategoryOther;

  /// No description provided for @supportDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get supportDescriptionLabel;

  /// No description provided for @supportDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe what happened…'**
  String get supportDescriptionHint;

  /// No description provided for @supportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get supportSubmit;

  /// No description provided for @supportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Thank you — we received your report'**
  String get supportSubmitted;

  /// No description provided for @supportLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in to report a problem'**
  String get supportLoginRequired;

  /// No description provided for @supportContactHint.
  ///
  /// In en, this message translates to:
  /// **'Support email: eeshbaev@outlook.com'**
  String get supportContactHint;

  /// No description provided for @supportMailtoFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open email app'**
  String get supportMailtoFailed;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us improve YordamBor'**
  String get feedbackSubtitle;

  /// No description provided for @feedbackMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Your feedback'**
  String get feedbackMessageLabel;

  /// No description provided for @feedbackMessageHint.
  ///
  /// In en, this message translates to:
  /// **'What could be better?'**
  String get feedbackMessageHint;

  /// No description provided for @feedbackSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get feedbackSubmit;

  /// No description provided for @feedbackThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback'**
  String get feedbackThanks;

  /// No description provided for @feedbackOpenFromSheet.
  ///
  /// In en, this message translates to:
  /// **'Use Help & support to send feedback.'**
  String get feedbackOpenFromSheet;

  /// No description provided for @appReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoying YordamBor?'**
  String get appReviewTitle;

  /// No description provided for @appReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your rating helps other users find trusted providers.'**
  String get appReviewSubtitle;

  /// No description provided for @appReviewYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, love it'**
  String get appReviewYes;

  /// No description provided for @appReviewNo.
  ///
  /// In en, this message translates to:
  /// **'Not really'**
  String get appReviewNo;

  /// No description provided for @appReviewLater.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get appReviewLater;

  /// No description provided for @providerProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get providerProgressTitle;

  /// No description provided for @providerProgressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build your reputation step by step'**
  String get providerProgressSubtitle;

  /// No description provided for @providerTierNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get providerTierNew;

  /// No description provided for @providerTierActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get providerTierActive;

  /// No description provided for @providerTierTrusted.
  ///
  /// In en, this message translates to:
  /// **'Trusted'**
  String get providerTierTrusted;

  /// No description provided for @providerTierTop.
  ///
  /// In en, this message translates to:
  /// **'Top provider'**
  String get providerTierTop;

  /// No description provided for @providerJobsRating.
  ///
  /// In en, this message translates to:
  /// **'{jobs} jobs · {rating}★'**
  String providerJobsRating(int jobs, String rating);

  /// No description provided for @providerNextMilestone.
  ///
  /// In en, this message translates to:
  /// **'{count} more jobs → {tier}'**
  String providerNextMilestone(int count, String tier);

  /// No description provided for @providerTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Next steps'**
  String get providerTipsTitle;

  /// No description provided for @progressTipAddCertificate.
  ///
  /// In en, this message translates to:
  /// **'Add a certificate to build trust'**
  String get progressTipAddCertificate;

  /// No description provided for @progressTipSetAvailability.
  ///
  /// In en, this message translates to:
  /// **'Set availability on your listing'**
  String get progressTipSetAvailability;

  /// No description provided for @progressTipReplyReviews.
  ///
  /// In en, this message translates to:
  /// **'Reply to client reviews'**
  String get progressTipReplyReviews;

  /// No description provided for @progressTipAddPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Add more portfolio photos'**
  String get progressTipAddPortfolio;

  /// No description provided for @progressTipSetPricing.
  ///
  /// In en, this message translates to:
  /// **'Set fixed or hourly pricing'**
  String get progressTipSetPricing;

  /// No description provided for @progressTipRepeatClients.
  ///
  /// In en, this message translates to:
  /// **'Ask happy clients to book again'**
  String get progressTipRepeatClients;

  /// No description provided for @achievementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @achievementsEmptySub.
  ///
  /// In en, this message translates to:
  /// **'No achievements yet. Complete jobs and grow your profile to earn badges.'**
  String get achievementsEmptySub;

  /// No description provided for @achievementFirstXizmat.
  ///
  /// In en, this message translates to:
  /// **'First service listed'**
  String get achievementFirstXizmat;

  /// No description provided for @achievementFirstDeal.
  ///
  /// In en, this message translates to:
  /// **'First completed job'**
  String get achievementFirstDeal;

  /// No description provided for @achievementJobs5.
  ///
  /// In en, this message translates to:
  /// **'5 jobs completed'**
  String get achievementJobs5;

  /// No description provided for @achievementJobs10.
  ///
  /// In en, this message translates to:
  /// **'10 jobs completed'**
  String get achievementJobs10;

  /// No description provided for @achievementJobs25.
  ///
  /// In en, this message translates to:
  /// **'25 jobs completed'**
  String get achievementJobs25;

  /// No description provided for @achievementFirstFiveStar.
  ///
  /// In en, this message translates to:
  /// **'First 5★ review'**
  String get achievementFirstFiveStar;

  /// No description provided for @achievementCertificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate uploaded'**
  String get achievementCertificate;

  /// No description provided for @achievementRepeatClient.
  ///
  /// In en, this message translates to:
  /// **'Loyal client (3+ jobs)'**
  String get achievementRepeatClient;

  /// No description provided for @achievementBodyFirstXizmat.
  ///
  /// In en, this message translates to:
  /// **'You listed your first service on YordamBor.'**
  String get achievementBodyFirstXizmat;

  /// No description provided for @achievementBodyFirstDeal.
  ///
  /// In en, this message translates to:
  /// **'You completed your first deal. Keep going!'**
  String get achievementBodyFirstDeal;

  /// No description provided for @achievementBodyJobs5.
  ///
  /// In en, this message translates to:
  /// **'Five jobs done — clients are noticing.'**
  String get achievementBodyJobs5;

  /// No description provided for @achievementBodyJobs10.
  ///
  /// In en, this message translates to:
  /// **'Ten completed jobs. You\'re building a real reputation.'**
  String get achievementBodyJobs10;

  /// No description provided for @achievementBodyJobs25.
  ///
  /// In en, this message translates to:
  /// **'Twenty-five jobs. Top-tier providers start here.'**
  String get achievementBodyJobs25;

  /// No description provided for @achievementBodyFirstFiveStar.
  ///
  /// In en, this message translates to:
  /// **'A client gave you 5 stars. Well deserved!'**
  String get achievementBodyFirstFiveStar;

  /// No description provided for @achievementBodyCertificate.
  ///
  /// In en, this message translates to:
  /// **'Your credentials are visible on your profile.'**
  String get achievementBodyCertificate;

  /// No description provided for @achievementBodyRepeatClient.
  ///
  /// In en, this message translates to:
  /// **'A client booked you three times or more.'**
  String get achievementBodyRepeatClient;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @guidesTitle.
  ///
  /// In en, this message translates to:
  /// **'Business tips'**
  String get guidesTitle;

  /// No description provided for @guidesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Grow your service step by step'**
  String get guidesSubtitle;

  /// No description provided for @guideXizmatConvertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a listing that converts'**
  String get guideXizmatConvertsTitle;

  /// No description provided for @guidePricingTitle.
  ///
  /// In en, this message translates to:
  /// **'Pricing: fixed vs hourly'**
  String get guidePricingTitle;

  /// No description provided for @guideRepeatClientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Get repeat bookings'**
  String get guideRepeatClientsTitle;

  /// No description provided for @guideCertificatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Certificates & trust'**
  String get guideCertificatesTitle;

  /// No description provided for @guideReviewRepliesTitle.
  ///
  /// In en, this message translates to:
  /// **'Reply to reviews professionally'**
  String get guideReviewRepliesTitle;

  /// No description provided for @guideXizmatConvertsBody.
  ///
  /// In en, this message translates to:
  /// **'Use a clear title, real portfolio photos, and your subcategory. Show pricing or say negotiable. Add availability so clients know when you can work.'**
  String get guideXizmatConvertsBody;

  /// No description provided for @guidePricingBody.
  ///
  /// In en, this message translates to:
  /// **'Fixed price works for predictable jobs. Hourly fits cleaning, tutoring, and care. Negotiable is fine — but a starting price gets more messages.'**
  String get guidePricingBody;

  /// No description provided for @guideRepeatClientsBody.
  ///
  /// In en, this message translates to:
  /// **'Do great work, reply quickly, and ask happy clients to use Book again after a completed deal. Repeat clients trust you already.'**
  String get guideRepeatClientsBody;

  /// No description provided for @guideCertificatesBody.
  ///
  /// In en, this message translates to:
  /// **'Upload credentials clients can review. YordamBor does not verify documents — they help clients decide, not guarantee quality.'**
  String get guideCertificatesBody;

  /// No description provided for @guideReviewRepliesBody.
  ///
  /// In en, this message translates to:
  /// **'Reply politely to every review. Thank clients for 5★ feedback. For criticism, stay professional — future clients read your replies.'**
  String get guideReviewRepliesBody;

  /// No description provided for @safetyPaymentsBanner.
  ///
  /// In en, this message translates to:
  /// **'Pay only as agreed with the provider. YordamBor does not handle money and is not responsible for off-platform payments.'**
  String get safetyPaymentsBanner;

  /// No description provided for @settingsSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety & payments'**
  String get settingsSafety;

  /// No description provided for @legalSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety & payments'**
  String get legalSafetyTitle;

  /// No description provided for @legalSafetyBody.
  ///
  /// In en, this message translates to:
  /// **'YordamBor connects clients and providers. It does not perform services, hold money, or guarantee outcomes.\n\nPayments\n\nAll payments are agreed directly between you and the other party. Never send full payment upfront to someone you do not trust. Meet in person when possible. YordamBor is not responsible for fraud, poor service, or disputes about money paid outside the app.\n\nYour responsibility\n\nVerify credentials, reviews, and certificates yourself. Use completed deals and reviews to judge providers.\n\nReporting\n\nReport abuse in the app. For product issues, use Help & support.'**
  String get legalSafetyBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
