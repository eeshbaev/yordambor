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

  /// No description provided for @tabCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get tabCalendar;

  /// No description provided for @calendarGuestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to see your schedule and mark availability.'**
  String get calendarGuestSubtitle;

  /// No description provided for @calendarProviderHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a day on the calendar, then use the button below to mark available or busy.'**
  String get calendarProviderHint;

  /// No description provided for @calendarClientHint.
  ///
  /// In en, this message translates to:
  /// **'Your appointments and reminders appear on the calendar. Tap a day for details.'**
  String get calendarClientHint;

  /// No description provided for @calendarLegendAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get calendarLegendAvailable;

  /// No description provided for @calendarLegendBusy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get calendarLegendBusy;

  /// No description provided for @calendarLegendAppointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get calendarLegendAppointment;

  /// No description provided for @calendarMarkAvailable.
  ///
  /// In en, this message translates to:
  /// **'Marked: available — tap to change'**
  String get calendarMarkAvailable;

  /// No description provided for @calendarMarkBusy.
  ///
  /// In en, this message translates to:
  /// **'Marked: busy — tap to change'**
  String get calendarMarkBusy;

  /// No description provided for @calendarMarkUnset.
  ///
  /// In en, this message translates to:
  /// **'Mark day: available / busy'**
  String get calendarMarkUnset;

  /// No description provided for @calendarNoEventsDay.
  ///
  /// In en, this message translates to:
  /// **'No appointments on this day.'**
  String get calendarNoEventsDay;

  /// No description provided for @calendarWeekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get calendarWeekdayMon;

  /// No description provided for @calendarWeekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get calendarWeekdayTue;

  /// No description provided for @calendarWeekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get calendarWeekdayWed;

  /// No description provided for @calendarWeekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get calendarWeekdayThu;

  /// No description provided for @calendarWeekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get calendarWeekdayFri;

  /// No description provided for @calendarWeekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get calendarWeekdaySat;

  /// No description provided for @calendarWeekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get calendarWeekdaySun;

  /// No description provided for @tabFavorites.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get tabFavorites;

  /// No description provided for @tabBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get tabBusiness;

  /// No description provided for @businessTabServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get businessTabServices;

  /// No description provided for @businessTabTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get businessTabTools;

  /// No description provided for @businessToolsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Client book, receipts, earnings, and other provider tools.'**
  String get businessToolsSubtitle;

  /// No description provided for @myXizmatlarGuestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your services and provider tools.'**
  String get myXizmatlarGuestSubtitle;

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

  /// No description provided for @filterCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get filterCity;

  /// No description provided for @filterAllCities.
  ///
  /// In en, this message translates to:
  /// **'All cities'**
  String get filterAllCities;

  /// No description provided for @filterCityHint.
  ///
  /// In en, this message translates to:
  /// **'Where do you need the service?'**
  String get filterCityHint;

  /// No description provided for @filterAllCitiesHint.
  ///
  /// In en, this message translates to:
  /// **'Listings in every city'**
  String get filterAllCitiesHint;

  /// No description provided for @xizmatServiceCityRequired.
  ///
  /// In en, this message translates to:
  /// **'Select the city where you provide this service'**
  String get xizmatServiceCityRequired;

  /// No description provided for @serviceCityToshkent.
  ///
  /// In en, this message translates to:
  /// **'Tashkent'**
  String get serviceCityToshkent;

  /// No description provided for @serviceCityToshkentViloyati.
  ///
  /// In en, this message translates to:
  /// **'Tashkent region'**
  String get serviceCityToshkentViloyati;

  /// No description provided for @serviceCitySamarqand.
  ///
  /// In en, this message translates to:
  /// **'Samarkand'**
  String get serviceCitySamarqand;

  /// No description provided for @serviceCityBuxoro.
  ///
  /// In en, this message translates to:
  /// **'Bukhara'**
  String get serviceCityBuxoro;

  /// No description provided for @serviceCityNukus.
  ///
  /// In en, this message translates to:
  /// **'Nukus'**
  String get serviceCityNukus;

  /// No description provided for @serviceCityNamangan.
  ///
  /// In en, this message translates to:
  /// **'Namangan'**
  String get serviceCityNamangan;

  /// No description provided for @serviceCityAndijon.
  ///
  /// In en, this message translates to:
  /// **'Andijan'**
  String get serviceCityAndijon;

  /// No description provided for @serviceCityFargona.
  ///
  /// In en, this message translates to:
  /// **'Fergana'**
  String get serviceCityFargona;

  /// No description provided for @serviceCityQarshi.
  ///
  /// In en, this message translates to:
  /// **'Qarshi'**
  String get serviceCityQarshi;

  /// No description provided for @serviceCityUrganch.
  ///
  /// In en, this message translates to:
  /// **'Urgench'**
  String get serviceCityUrganch;

  /// No description provided for @serviceCityTermiz.
  ///
  /// In en, this message translates to:
  /// **'Termiz'**
  String get serviceCityTermiz;

  /// No description provided for @serviceCityJizzax.
  ///
  /// In en, this message translates to:
  /// **'Jizzakh'**
  String get serviceCityJizzax;

  /// No description provided for @serviceCityNavoiy.
  ///
  /// In en, this message translates to:
  /// **'Navoi'**
  String get serviceCityNavoiy;

  /// No description provided for @serviceCityQoqon.
  ///
  /// In en, this message translates to:
  /// **'Kokand'**
  String get serviceCityQoqon;

  /// No description provided for @serviceCityGuliston.
  ///
  /// In en, this message translates to:
  /// **'Gulistan'**
  String get serviceCityGuliston;

  /// No description provided for @serviceCityBoshqa.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get serviceCityBoshqa;

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
  /// **'Enter a valid phone number (+998…)'**
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
  /// **'We sent a confirmation link to your email. After opening it, tap “I confirmed”.'**
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
  /// **'We’re so glad you joined YordamBor. Find services, offer help, or post a job — we’re here for you every step of the way.'**
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
  /// **'Oʻzbek'**
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
  /// **'Write a message…'**
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

  /// No description provided for @profileMargin.
  ///
  /// In en, this message translates to:
  /// **'Margin'**
  String get profileMargin;

  /// No description provided for @profileMarginSub.
  ///
  /// In en, this message translates to:
  /// **'Cost & profit'**
  String get profileMarginSub;

  /// No description provided for @profilePaymentReceipt.
  ///
  /// In en, this message translates to:
  /// **'Payment receipt'**
  String get profilePaymentReceipt;

  /// No description provided for @profilePaymentReceiptSub.
  ///
  /// In en, this message translates to:
  /// **'PDF receipts for your services'**
  String get profilePaymentReceiptSub;

  /// No description provided for @receiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment receipts'**
  String get receiptTitle;

  /// No description provided for @receiptNew.
  ///
  /// In en, this message translates to:
  /// **'New receipt'**
  String get receiptNew;

  /// No description provided for @receiptEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No receipts yet'**
  String get receiptEmptyTitle;

  /// No description provided for @receiptEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a payment receipt for a client and share it as PDF.'**
  String get receiptEmptySubtitle;

  /// No description provided for @receiptDocumentTitle.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT RECEIPT'**
  String get receiptDocumentTitle;

  /// No description provided for @receiptNumber.
  ///
  /// In en, this message translates to:
  /// **'No.'**
  String get receiptNumber;

  /// No description provided for @receiptDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get receiptDate;

  /// No description provided for @receiptSeller.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get receiptSeller;

  /// No description provided for @receiptBuyer.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get receiptBuyer;

  /// No description provided for @receiptBuyerName.
  ///
  /// In en, this message translates to:
  /// **'Client name'**
  String get receiptBuyerName;

  /// No description provided for @receiptBuyerPhone.
  ///
  /// In en, this message translates to:
  /// **'Client phone'**
  String get receiptBuyerPhone;

  /// No description provided for @receiptPickClient.
  ///
  /// In en, this message translates to:
  /// **'Pick from client book'**
  String get receiptPickClient;

  /// No description provided for @receiptXizmat.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get receiptXizmat;

  /// No description provided for @receiptLines.
  ///
  /// In en, this message translates to:
  /// **'Line items'**
  String get receiptLines;

  /// No description provided for @receiptLineTitle.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get receiptLineTitle;

  /// No description provided for @receiptQuantity.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get receiptQuantity;

  /// No description provided for @receiptUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get receiptUnitPrice;

  /// No description provided for @receiptLineTotal.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get receiptLineTotal;

  /// No description provided for @receiptAddLine.
  ///
  /// In en, this message translates to:
  /// **'Add line'**
  String get receiptAddLine;

  /// No description provided for @receiptDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get receiptDiscount;

  /// No description provided for @receiptTaxEnable.
  ///
  /// In en, this message translates to:
  /// **'Add tax'**
  String get receiptTaxEnable;

  /// No description provided for @receiptTaxRate.
  ///
  /// In en, this message translates to:
  /// **'Tax rate (%)'**
  String get receiptTaxRate;

  /// No description provided for @receiptTaxLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax label'**
  String get receiptTaxLabel;

  /// No description provided for @receiptTaxDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'You choose the tax rate. YordamBor does not provide tax advice.'**
  String get receiptTaxDisclaimer;

  /// No description provided for @receiptSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get receiptSubtotal;

  /// No description provided for @receiptTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get receiptTotal;

  /// No description provided for @receiptNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get receiptNote;

  /// No description provided for @receiptDueDate.
  ///
  /// In en, this message translates to:
  /// **'Payment due'**
  String get receiptDueDate;

  /// No description provided for @receiptCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get receiptCurrency;

  /// No description provided for @receiptCurrencyUzs.
  ///
  /// In en, this message translates to:
  /// **'UZS'**
  String get receiptCurrencyUzs;

  /// No description provided for @receiptCurrencyUsd.
  ///
  /// In en, this message translates to:
  /// **'USD'**
  String get receiptCurrencyUsd;

  /// No description provided for @receiptSharePdf.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get receiptSharePdf;

  /// No description provided for @receiptPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview PDF'**
  String get receiptPreview;

  /// No description provided for @receiptSaved.
  ///
  /// In en, this message translates to:
  /// **'Receipt saved'**
  String get receiptSaved;

  /// No description provided for @receiptValidationBuyer.
  ///
  /// In en, this message translates to:
  /// **'Enter client name'**
  String get receiptValidationBuyer;

  /// No description provided for @receiptValidationXizmat.
  ///
  /// In en, this message translates to:
  /// **'Select a service'**
  String get receiptValidationXizmat;

  /// No description provided for @receiptValidationLines.
  ///
  /// In en, this message translates to:
  /// **'Add at least one line item with a price'**
  String get receiptValidationLines;

  /// No description provided for @receiptFooterBranding.
  ///
  /// In en, this message translates to:
  /// **'Created with YordamBor'**
  String get receiptFooterBranding;

  /// No description provided for @receiptDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this receipt?'**
  String get receiptDeleteConfirm;

  /// No description provided for @receiptTaxPresetCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get receiptTaxPresetCustom;

  /// No description provided for @marginTitle.
  ///
  /// In en, this message translates to:
  /// **'Margin'**
  String get marginTitle;

  /// No description provided for @marginUnitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Unit library'**
  String get marginUnitsTitle;

  /// No description provided for @marginUnitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reusable units with a cost for quick product math'**
  String get marginUnitsSubtitle;

  /// No description provided for @marginOpenUnits.
  ///
  /// In en, this message translates to:
  /// **'Unit library'**
  String get marginOpenUnits;

  /// No description provided for @marginAddUnit.
  ///
  /// In en, this message translates to:
  /// **'Add unit'**
  String get marginAddUnit;

  /// No description provided for @marginEditUnit.
  ///
  /// In en, this message translates to:
  /// **'Edit unit'**
  String get marginEditUnit;

  /// No description provided for @marginUnitName.
  ///
  /// In en, this message translates to:
  /// **'Unit name'**
  String get marginUnitName;

  /// No description provided for @marginUnitCost.
  ///
  /// In en, this message translates to:
  /// **'Cost per unit (UZS)'**
  String get marginUnitCost;

  /// No description provided for @marginUnitBasis.
  ///
  /// In en, this message translates to:
  /// **'Cost basis (optional)'**
  String get marginUnitBasis;

  /// No description provided for @marginUnitBasisHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. per hour, per kg, per item'**
  String get marginUnitBasisHint;

  /// No description provided for @marginUnitsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No units yet'**
  String get marginUnitsEmptyTitle;

  /// No description provided for @marginUnitsEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Save units you use often — labor, materials, packaging — with a cost.'**
  String get marginUnitsEmptySub;

  /// No description provided for @marginAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get marginAddProduct;

  /// No description provided for @marginEditProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get marginEditProduct;

  /// No description provided for @marginProductName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get marginProductName;

  /// No description provided for @marginSalePrice.
  ///
  /// In en, this message translates to:
  /// **'Sale price (UZS)'**
  String get marginSalePrice;

  /// No description provided for @marginCostTotal.
  ///
  /// In en, this message translates to:
  /// **'Total cost'**
  String get marginCostTotal;

  /// No description provided for @marginProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get marginProfit;

  /// No description provided for @marginMarginPercent.
  ///
  /// In en, this message translates to:
  /// **'Margin'**
  String get marginMarginPercent;

  /// No description provided for @marginCostBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Cost breakdown'**
  String get marginCostBreakdown;

  /// No description provided for @marginAddLine.
  ///
  /// In en, this message translates to:
  /// **'Add unit line'**
  String get marginAddLine;

  /// No description provided for @marginEditLine.
  ///
  /// In en, this message translates to:
  /// **'Edit unit line'**
  String get marginEditLine;

  /// No description provided for @marginLineName.
  ///
  /// In en, this message translates to:
  /// **'Unit / item name'**
  String get marginLineName;

  /// No description provided for @marginLineQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get marginLineQuantity;

  /// No description provided for @marginLineUnitCost.
  ///
  /// In en, this message translates to:
  /// **'Cost per unit (UZS)'**
  String get marginLineUnitCost;

  /// No description provided for @marginLineQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity label (optional)'**
  String get marginLineQuantityLabel;

  /// No description provided for @marginLineQuantityLabelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. hr, kg, pc'**
  String get marginLineQuantityLabelHint;

  /// No description provided for @marginSelectUnit.
  ///
  /// In en, this message translates to:
  /// **'Pick from library'**
  String get marginSelectUnit;

  /// No description provided for @marginCustomLine.
  ///
  /// In en, this message translates to:
  /// **'Custom line'**
  String get marginCustomLine;

  /// No description provided for @marginProductsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get marginProductsEmptyTitle;

  /// No description provided for @marginProductsEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Add a product or service to see cost, profit, and margin.'**
  String get marginProductsEmptySub;

  /// No description provided for @marginNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get marginNameRequired;

  /// No description provided for @marginPriceRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a sale price'**
  String get marginPriceRequired;

  /// No description provided for @marginCostRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a cost'**
  String get marginCostRequired;

  /// No description provided for @marginQuantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a quantity'**
  String get marginQuantityRequired;

  /// No description provided for @marginAvgMargin.
  ///
  /// In en, this message translates to:
  /// **'Average margin'**
  String get marginAvgMargin;

  /// No description provided for @marginPerProduct.
  ///
  /// In en, this message translates to:
  /// **'per product'**
  String get marginPerProduct;

  /// No description provided for @marginDeleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete product'**
  String get marginDeleteProduct;

  /// No description provided for @marginDeleteUnit.
  ///
  /// In en, this message translates to:
  /// **'Delete unit'**
  String get marginDeleteUnit;

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
  /// **'Check after the appointment'**
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
  /// **'Remind me'**
  String get remindersSettingsAlertsLabel;

  /// No description provided for @remindersSettingsAtTime.
  ///
  /// In en, this message translates to:
  /// **'At the time'**
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

  /// No description provided for @notificationSubsectorNewService.
  ///
  /// In en, this message translates to:
  /// **'New service in your sub-sector'**
  String get notificationSubsectorNewService;

  /// No description provided for @notificationSubsectorDiscount.
  ///
  /// In en, this message translates to:
  /// **'Price drop in your sub-sector'**
  String get notificationSubsectorDiscount;

  /// No description provided for @notificationSubsectorHelpPost.
  ///
  /// In en, this message translates to:
  /// **'Help needed in your sub-sector'**
  String get notificationSubsectorHelpPost;

  /// No description provided for @notificationAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sub-sector alerts'**
  String get notificationAlertsTitle;

  /// No description provided for @notificationAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get notified when services appear, prices drop, or someone needs help.'**
  String get notificationAlertsSubtitle;

  /// No description provided for @notificationAlertsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add alert'**
  String get notificationAlertsAdd;

  /// No description provided for @notificationAlertsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sub-sector alerts yet'**
  String get notificationAlertsEmpty;

  /// No description provided for @notificationAlertNewService.
  ///
  /// In en, this message translates to:
  /// **'New services'**
  String get notificationAlertNewService;

  /// No description provided for @notificationAlertDiscount.
  ///
  /// In en, this message translates to:
  /// **'Price drops'**
  String get notificationAlertDiscount;

  /// No description provided for @notificationAlertHelpPost.
  ///
  /// In en, this message translates to:
  /// **'Help requests (Yordam kerak)'**
  String get notificationAlertHelpPost;

  /// No description provided for @notificationAlertSeekerHint.
  ///
  /// In en, this message translates to:
  /// **'When you are looking for a service'**
  String get notificationAlertSeekerHint;

  /// No description provided for @notificationAlertProviderHint.
  ///
  /// In en, this message translates to:
  /// **'When you can offer help as a provider'**
  String get notificationAlertProviderHint;

  /// No description provided for @notificationAlertsSaved.
  ///
  /// In en, this message translates to:
  /// **'Alert saved'**
  String get notificationAlertsSaved;

  /// No description provided for @notificationAlertsRemoved.
  ///
  /// In en, this message translates to:
  /// **'Alert removed'**
  String get notificationAlertsRemoved;

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

  /// No description provided for @demoKelishuvSimulatedNote.
  ///
  /// In en, this message translates to:
  /// **'Demo deal — not saved on the server. The demo provider is shown as having received your offer.'**
  String get demoKelishuvSimulatedNote;

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
  /// **'Choose where you provide this service'**
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
  /// **'You can’t send a request to your own service'**
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
  /// **'Clients write sooner when they can see the price.'**
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
  /// **'Enter the amount'**
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
  /// **'Optional — let clients know if you’re free. Client Book does not change this.'**
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
  /// **'By appointment'**
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
  /// **'If you’re not satisfied, I’ll redo the work'**
  String get xizmatPromisePreset1;

  /// No description provided for @xizmatPromisePreset2.
  ///
  /// In en, this message translates to:
  /// **'Quality guaranteed — if there’s a problem, I’ll refund you'**
  String get xizmatPromisePreset2;

  /// No description provided for @xizmatPromisePreset3.
  ///
  /// In en, this message translates to:
  /// **'On time and at the agreed price'**
  String get xizmatPromisePreset3;

  /// No description provided for @xizmatPromiseDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'YordamBor does not provide warranties. This is the provider’s own statement.'**
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
  /// **'Ten completed jobs. You’re building a real reputation.'**
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

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @greetingNight.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get greetingNight;

  /// No description provided for @greetingWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get greetingWelcomeBack;

  /// No description provided for @greetingWelcomeNew.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get greetingWelcomeNew;

  /// No description provided for @greetingWithName.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}'**
  String greetingWithName(String greeting, String name);

  /// No description provided for @homeFactAwaitingReply.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} deal is waiting for your reply} other{{count} deals are waiting for your reply}}'**
  String homeFactAwaitingReply(int count);

  /// No description provided for @homeFactInProgress.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} deal in progress} other{{count} deals in progress}}'**
  String homeFactInProgress(int count);

  /// No description provided for @homeFactNewMember.
  ///
  /// In en, this message translates to:
  /// **'Ask for help or offer a service to begin'**
  String get homeFactNewMember;

  /// No description provided for @continueYourTurn.
  ///
  /// In en, this message translates to:
  /// **'Your turn'**
  String get continueYourTurn;

  /// No description provided for @continueReplyToDeal.
  ///
  /// In en, this message translates to:
  /// **'Review the terms and reply'**
  String get continueReplyToDeal;

  /// No description provided for @continueInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get continueInProgress;

  /// No description provided for @continueMarkDone.
  ///
  /// In en, this message translates to:
  /// **'Confirm when the job is done'**
  String get continueMarkDone;

  /// No description provided for @continueDraftTitle.
  ///
  /// In en, this message translates to:
  /// **'Unfinished request'**
  String get continueDraftTitle;

  /// No description provided for @continueDraftUntitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled request'**
  String get continueDraftUntitled;

  /// No description provided for @continueDraftHint.
  ///
  /// In en, this message translates to:
  /// **'Pick up where you left off'**
  String get continueDraftHint;

  /// No description provided for @draftDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete draft'**
  String get draftDelete;

  /// No description provided for @draftDeleted.
  ///
  /// In en, this message translates to:
  /// **'Draft deleted'**
  String get draftDeleted;

  /// No description provided for @draftRestored.
  ///
  /// In en, this message translates to:
  /// **'Draft restored'**
  String get draftRestored;

  /// No description provided for @draftStartOver.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get draftStartOver;

  /// No description provided for @actionUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// No description provided for @quickAskHelp.
  ///
  /// In en, this message translates to:
  /// **'Ask for help'**
  String get quickAskHelp;

  /// No description provided for @quickOfferService.
  ///
  /// In en, this message translates to:
  /// **'Offer a service'**
  String get quickOfferService;

  /// No description provided for @feedEndTitle.
  ///
  /// In en, this message translates to:
  /// **'You’re all caught up'**
  String get feedEndTitle;

  /// No description provided for @feedEndAskPrompt.
  ///
  /// In en, this message translates to:
  /// **'Didn’t find the right person?'**
  String get feedEndAskPrompt;

  /// No description provided for @feedEndJobsHint.
  ///
  /// In en, this message translates to:
  /// **'New requests appear here first'**
  String get feedEndJobsHint;

  /// No description provided for @whatsNewTitle.
  ///
  /// In en, this message translates to:
  /// **'What’s new'**
  String get whatsNewTitle;

  /// No description provided for @whatsNewLookTitle.
  ///
  /// In en, this message translates to:
  /// **'A cleaner, calmer look'**
  String get whatsNewLookTitle;

  /// No description provided for @whatsNewLookBody.
  ///
  /// In en, this message translates to:
  /// **'New type, colors and icons that are easier to read.'**
  String get whatsNewLookBody;

  /// No description provided for @whatsNewNextStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Your next step, on Home'**
  String get whatsNewNextStepTitle;

  /// No description provided for @whatsNewNextStepBody.
  ///
  /// In en, this message translates to:
  /// **'Deals waiting for you and unfinished requests now come first.'**
  String get whatsNewNextStepBody;

  /// No description provided for @whatsNewDraftsTitle.
  ///
  /// In en, this message translates to:
  /// **'Drafts save themselves'**
  String get whatsNewDraftsTitle;

  /// No description provided for @whatsNewDraftsBody.
  ///
  /// In en, this message translates to:
  /// **'Close a request halfway and finish it later.'**
  String get whatsNewDraftsBody;

  /// No description provided for @whatsNewDone.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get whatsNewDone;

  /// No description provided for @xizmatCardNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get xizmatCardNew;

  /// No description provided for @favoriteAdd.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get favoriteAdd;

  /// No description provided for @favoriteRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get favoriteRemove;

  /// No description provided for @statJobsDone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{job done} other{jobs done}}'**
  String statJobsDone(int count);

  /// No description provided for @statRating.
  ///
  /// In en, this message translates to:
  /// **'rating'**
  String get statRating;

  /// No description provided for @dealBondYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get dealBondYou;

  /// No description provided for @dealBondYourTurn.
  ///
  /// In en, this message translates to:
  /// **'Your turn: review the terms and accept'**
  String get dealBondYourTurn;

  /// No description provided for @dealBondWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {name} to reply'**
  String dealBondWaiting(String name);

  /// No description provided for @dealBondAgreed.
  ///
  /// In en, this message translates to:
  /// **'Agreed · the work is under way'**
  String get dealBondAgreed;

  /// No description provided for @dealBondDone.
  ///
  /// In en, this message translates to:
  /// **'Done · thank you both'**
  String get dealBondDone;

  /// No description provided for @dealBondClosed.
  ///
  /// In en, this message translates to:
  /// **'This deal is closed'**
  String get dealBondClosed;

  /// No description provided for @undoDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get undoDeleted;

  /// No description provided for @savedRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from saved'**
  String get savedRemoved;

  /// No description provided for @yordamKerakTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Write a short title'**
  String get yordamKerakTitleRequired;

  /// No description provided for @yordamKerakMessageRequired.
  ///
  /// In en, this message translates to:
  /// **'Describe what you need'**
  String get yordamKerakMessageRequired;

  /// No description provided for @stateErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load this'**
  String get stateErrorTitle;

  /// No description provided for @stateErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get stateErrorBody;

  /// No description provided for @stateOfflineBanner.
  ///
  /// In en, this message translates to:
  /// **'No internet. Showing saved results.'**
  String get stateOfflineBanner;

  /// No description provided for @disabledHintServiceName.
  ///
  /// In en, this message translates to:
  /// **'Add a name of at least 2 letters'**
  String get disabledHintServiceName;

  /// No description provided for @disabledHintServiceCity.
  ///
  /// In en, this message translates to:
  /// **'Choose the city you work in'**
  String get disabledHintServiceCity;

  /// No description provided for @disabledHintServicePhoto.
  ///
  /// In en, this message translates to:
  /// **'Add at least one photo to publish'**
  String get disabledHintServicePhoto;

  /// No description provided for @disabledHintPickSubcategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a speciality first'**
  String get disabledHintPickSubcategory;

  /// No description provided for @disabledHintOneAlert.
  ///
  /// In en, this message translates to:
  /// **'Turn on at least one alert'**
  String get disabledHintOneAlert;

  /// No description provided for @milestoneOverline.
  ///
  /// In en, this message translates to:
  /// **'New milestone'**
  String get milestoneOverline;

  /// No description provided for @milestoneDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get milestoneDismiss;

  /// No description provided for @notificationsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTooltip;

  /// No description provided for @a11yRating.
  ///
  /// In en, this message translates to:
  /// **'rated {rating}'**
  String a11yRating(String rating);

  /// No description provided for @a11yNewProvider.
  ///
  /// In en, this message translates to:
  /// **'new on YordamBor'**
  String get a11yNewProvider;

  /// No description provided for @filtersClear.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get filtersClear;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionMore.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get actionMore;

  /// No description provided for @actionSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get actionSend;

  /// No description provided for @actionPreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get actionPreviousMonth;

  /// No description provided for @actionNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get actionNextMonth;

  /// No description provided for @a11yShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get a11yShowPassword;

  /// No description provided for @a11yHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get a11yHidePassword;

  /// No description provided for @a11yStarRating.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 star} other{{count} stars}}'**
  String a11yStarRating(int count);

  /// No description provided for @detailPaneEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a card'**
  String get detailPaneEmptyTitle;

  /// No description provided for @detailPaneEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'It opens here, beside the list.'**
  String get detailPaneEmptyBody;

  /// No description provided for @taklifAskHint.
  ///
  /// In en, this message translates to:
  /// **'What help do you need?'**
  String get taklifAskHint;

  /// No description provided for @taklifAskSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Describe the job and, if you like, your budget. Work starts once you both agree.'**
  String get taklifAskSubtitle;

  /// No description provided for @taklifAskSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get taklifAskSubmit;

  /// No description provided for @dealOfferAutoCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancelled automatically if there’s no reply in {days, plural, =1{1 day} other{{days} days}}'**
  String dealOfferAutoCancel(int days);

  /// No description provided for @dealOfferReplyWithin.
  ///
  /// In en, this message translates to:
  /// **'Reply within {days, plural, =1{1 day} other{{days} days}}, or the offer is cancelled'**
  String dealOfferReplyWithin(int days);

  /// No description provided for @dealAcceptedRow.
  ///
  /// In en, this message translates to:
  /// **'Accepted the terms'**
  String get dealAcceptedRow;

  /// No description provided for @dealCompletedRow.
  ///
  /// In en, this message translates to:
  /// **'Confirmed the work is done'**
  String get dealCompletedRow;

  /// No description provided for @dealWithdrawOffer.
  ///
  /// In en, this message translates to:
  /// **'Withdraw offer'**
  String get dealWithdrawOffer;

  /// No description provided for @dealWithdrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Withdraw your offer?'**
  String get dealWithdrawTitle;

  /// No description provided for @dealWithdrawBody.
  ///
  /// In en, this message translates to:
  /// **'The deal is cancelled. You can send a new offer later.'**
  String get dealWithdrawBody;

  /// No description provided for @dealChatOpensOnReply.
  ///
  /// In en, this message translates to:
  /// **'The chat opens once they reply.'**
  String get dealChatOpensOnReply;

  /// No description provided for @dealRejectTitle.
  ///
  /// In en, this message translates to:
  /// **'Decline this offer?'**
  String get dealRejectTitle;

  /// No description provided for @dealRejectBody.
  ///
  /// In en, this message translates to:
  /// **'Add a reason if you like — it stays visible in the deal.'**
  String get dealRejectBody;

  /// No description provided for @dealRejectCommentLabel.
  ///
  /// In en, this message translates to:
  /// **'Comment (optional)'**
  String get dealRejectCommentLabel;

  /// No description provided for @dealSendNewOffer.
  ///
  /// In en, this message translates to:
  /// **'Send a new offer'**
  String get dealSendNewOffer;

  /// No description provided for @dealClosedNewOfferHint.
  ///
  /// In en, this message translates to:
  /// **'Still need this service? Send a new offer and the discussion starts afresh.'**
  String get dealClosedNewOfferHint;

  /// No description provided for @archiveTabNeeded.
  ///
  /// In en, this message translates to:
  /// **'Needed help'**
  String get archiveTabNeeded;

  /// No description provided for @archiveTabProvided.
  ///
  /// In en, this message translates to:
  /// **'Provided help'**
  String get archiveTabProvided;

  /// No description provided for @archiveNeededEmpty.
  ///
  /// In en, this message translates to:
  /// **'Deals where you asked for help will appear here.'**
  String get archiveNeededEmpty;

  /// No description provided for @archiveProvidedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Deals where you helped someone will appear here.'**
  String get archiveProvidedEmpty;

  /// No description provided for @achievementsProgress.
  ///
  /// In en, this message translates to:
  /// **'{unlocked} of {total} unlocked'**
  String achievementsProgress(int unlocked, int total);

  /// No description provided for @achievementsShow.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get achievementsShow;

  /// No description provided for @achievementsHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get achievementsHide;

  /// No description provided for @yordamKerakCityRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a city'**
  String get yordamKerakCityRequired;

  /// No description provided for @taklifContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Your contact details'**
  String get taklifContactTitle;

  /// No description provided for @taklifContactNote.
  ///
  /// In en, this message translates to:
  /// **'The other side sees these in the deal, to reach you.'**
  String get taklifContactNote;

  /// No description provided for @taklifFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get taklifFirstNameLabel;

  /// No description provided for @taklifLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Family name'**
  String get taklifLastNameLabel;

  /// No description provided for @taklifFirstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get taklifFirstNameRequired;

  /// No description provided for @taklifPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get taklifPhoneRequired;

  /// No description provided for @taklifMessageOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Message (optional)'**
  String get taklifMessageOptionalLabel;

  /// No description provided for @dealContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact details'**
  String get dealContactTitle;

  /// No description provided for @dealContactSent.
  ///
  /// In en, this message translates to:
  /// **'You shared your contact details'**
  String get dealContactSent;

  /// No description provided for @dealsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your deals'**
  String get dealsSectionTitle;

  /// No description provided for @dealStateYourTurn.
  ///
  /// In en, this message translates to:
  /// **'In discussion · your turn'**
  String get dealStateYourTurn;

  /// No description provided for @dealStateSent.
  ///
  /// In en, this message translates to:
  /// **'Sent · waiting for a reply'**
  String get dealStateSent;

  /// No description provided for @dealStateInProgress.
  ///
  /// In en, this message translates to:
  /// **'Accepted · under way'**
  String get dealStateInProgress;

  /// No description provided for @dealStateAwaitingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Done on your side · waiting for confirmation'**
  String get dealStateAwaitingConfirm;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @businessEarningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Earned this month'**
  String get businessEarningsTitle;

  /// No description provided for @businessEarningsSee.
  ///
  /// In en, this message translates to:
  /// **'See earnings'**
  String get businessEarningsSee;

  /// No description provided for @businessStatWaitingLabel.
  ///
  /// In en, this message translates to:
  /// **'waiting for you'**
  String get businessStatWaitingLabel;

  /// No description provided for @businessNextStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Get more clients'**
  String get businessNextStepsTitle;

  /// No description provided for @businessNextStepsProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total}'**
  String businessNextStepsProgress(int done, int total);

  /// No description provided for @businessStepPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add 3 or more photos'**
  String get businessStepPhotos;

  /// No description provided for @businessStepPhotosWhy.
  ///
  /// In en, this message translates to:
  /// **'Services with photos get chosen more often'**
  String get businessStepPhotosWhy;

  /// No description provided for @businessStepPrice.
  ///
  /// In en, this message translates to:
  /// **'Set a price'**
  String get businessStepPrice;

  /// No description provided for @businessStepPriceWhy.
  ///
  /// In en, this message translates to:
  /// **'A clear price means fewer questions before the deal'**
  String get businessStepPriceWhy;

  /// No description provided for @businessStepAvailability.
  ///
  /// In en, this message translates to:
  /// **'Show when you’re free'**
  String get businessStepAvailability;

  /// No description provided for @businessStepAvailabilityWhy.
  ///
  /// In en, this message translates to:
  /// **'Clients write to people who can come soon'**
  String get businessStepAvailabilityWhy;

  /// No description provided for @businessStepShare.
  ///
  /// In en, this message translates to:
  /// **'Share your service link'**
  String get businessStepShare;

  /// No description provided for @businessStepShareWhy.
  ///
  /// In en, this message translates to:
  /// **'Send it on Telegram so friends can recommend you'**
  String get businessStepShareWhy;

  /// No description provided for @businessServicesCount.
  ///
  /// In en, this message translates to:
  /// **'My services · {count} of {max}'**
  String businessServicesCount(int count, int max);

  /// No description provided for @xizmatLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You can have up to {max} services. Edit or remove one to add another.'**
  String xizmatLimitReached(int max);

  /// No description provided for @calendarStatusCaption.
  ///
  /// In en, this message translates to:
  /// **'Your status · clients see it'**
  String get calendarStatusCaption;

  /// No description provided for @calendarLegendNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Help I get'**
  String get calendarLegendNeedHelp;

  /// No description provided for @calendarLegendGiveHelp.
  ///
  /// In en, this message translates to:
  /// **'Help I give'**
  String get calendarLegendGiveHelp;

  /// No description provided for @calendarLegendPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get calendarLegendPersonal;

  /// No description provided for @calendarHintMark.
  ///
  /// In en, this message translates to:
  /// **'Tap a day and mark it free or busy. Add hours if it’s only part of the day; otherwise it’s the whole working day.'**
  String get calendarHintMark;

  /// No description provided for @calendarHintClient.
  ///
  /// In en, this message translates to:
  /// **'Reminders of your deals: help you get and help you give. Tap a day for details.'**
  String get calendarHintClient;

  /// No description provided for @calendarDayNotMarked.
  ///
  /// In en, this message translates to:
  /// **'Not marked'**
  String get calendarDayNotMarked;

  /// No description provided for @calendarWholeWorkingDay.
  ///
  /// In en, this message translates to:
  /// **'Whole working day'**
  String get calendarWholeWorkingDay;

  /// No description provided for @calendarAddHours.
  ///
  /// In en, this message translates to:
  /// **'Add hours'**
  String get calendarAddHours;

  /// No description provided for @calendarRemoveHours.
  ///
  /// In en, this message translates to:
  /// **'Remove these hours'**
  String get calendarRemoveHours;

  /// No description provided for @calendarHoursFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get calendarHoursFrom;

  /// No description provided for @calendarHoursTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get calendarHoursTo;

  /// No description provided for @calendarDayEvents.
  ///
  /// In en, this message translates to:
  /// **'Reminders this day'**
  String get calendarDayEvents;

  /// No description provided for @workingHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get workingHoursTitle;

  /// No description provided for @workingHoursHint.
  ///
  /// In en, this message translates to:
  /// **'Clients see them on your services'**
  String get workingHoursHint;

  /// No description provided for @workingHoursSheetHint.
  ///
  /// In en, this message translates to:
  /// **'Your usual working day. By default 9:00–13:00 and 14:00–18:00.'**
  String get workingHoursSheetHint;

  /// No description provided for @workingHoursReset.
  ///
  /// In en, this message translates to:
  /// **'Back to 9–13 and 14–18'**
  String get workingHoursReset;

  /// No description provided for @workingHoursInvalid.
  ///
  /// In en, this message translates to:
  /// **'Check the hours: each one starts before it ends, and they don’t overlap.'**
  String get workingHoursInvalid;

  /// No description provided for @workingHoursSaved.
  ///
  /// In en, this message translates to:
  /// **'Working hours saved'**
  String get workingHoursSaved;

  /// No description provided for @xizmatOwnHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Own hours for this service'**
  String get xizmatOwnHoursTitle;

  /// No description provided for @xizmatOwnHoursOff.
  ///
  /// In en, this message translates to:
  /// **'Same as your profile: {hours}'**
  String xizmatOwnHoursOff(String hours);

  /// No description provided for @xizmatHoursInCalendar.
  ///
  /// In en, this message translates to:
  /// **'You change working hours in the calendar.'**
  String get xizmatHoursInCalendar;

  /// No description provided for @xizmatHoursOpenCalendar.
  ///
  /// In en, this message translates to:
  /// **'Open calendar'**
  String get xizmatHoursOpenCalendar;

  /// No description provided for @xizmatScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Hours and availability'**
  String get xizmatScheduleTitle;

  /// No description provided for @xizmatScheduleNextDays.
  ///
  /// In en, this message translates to:
  /// **'Next two weeks'**
  String get xizmatScheduleNextDays;

  /// No description provided for @xizmatTodayFree.
  ///
  /// In en, this message translates to:
  /// **'Free today'**
  String get xizmatTodayFree;

  /// No description provided for @xizmatTodayBusy.
  ///
  /// In en, this message translates to:
  /// **'Busy today'**
  String get xizmatTodayBusy;

  /// No description provided for @xizmatTodayBusyAt.
  ///
  /// In en, this message translates to:
  /// **'Busy today: {hours}'**
  String xizmatTodayBusyAt(String hours);

  /// No description provided for @xizmatTodayFreeAt.
  ///
  /// In en, this message translates to:
  /// **'Free today: {hours}'**
  String xizmatTodayFreeAt(String hours);

  /// No description provided for @calendarNoRemindersDay.
  ///
  /// In en, this message translates to:
  /// **'No reminders on this day.'**
  String get calendarNoRemindersDay;

  /// No description provided for @sampleTag.
  ///
  /// In en, this message translates to:
  /// **'Sample'**
  String get sampleTag;

  /// No description provided for @demoDealNote.
  ///
  /// In en, this message translates to:
  /// **'This is a sample: the deal doesn’t go to a real person.'**
  String get demoDealNote;

  /// No description provided for @feedInviteProvidersTitle.
  ///
  /// In en, this message translates to:
  /// **'Be one of the first providers'**
  String get feedInviteProvidersTitle;

  /// No description provided for @feedInviteProvidersBody.
  ///
  /// In en, this message translates to:
  /// **'Add your service, and clients will see it first.'**
  String get feedInviteProvidersBody;

  /// No description provided for @feedInviteAskTitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first to ask'**
  String get feedInviteAskTitle;

  /// No description provided for @feedInviteAskBody.
  ///
  /// In en, this message translates to:
  /// **'Say what you need, and providers will see your request.'**
  String get feedInviteAskBody;

  /// No description provided for @feedInviteProvidersAction.
  ///
  /// In en, this message translates to:
  /// **'Add your service'**
  String get feedInviteProvidersAction;

  /// No description provided for @feedInviteAskAction.
  ///
  /// In en, this message translates to:
  /// **'Describe what you need'**
  String get feedInviteAskAction;

  /// No description provided for @sampleFindProvider.
  ///
  /// In en, this message translates to:
  /// **'Find a provider'**
  String get sampleFindProvider;

  /// No description provided for @sampleFindProviderHint.
  ///
  /// In en, this message translates to:
  /// **'This is a sample. Describe the job, and real providers will see it.'**
  String get sampleFindProviderHint;

  /// No description provided for @sampleAlertNewServices.
  ///
  /// In en, this message translates to:
  /// **'Tell me when a provider joins in this field'**
  String get sampleAlertNewServices;

  /// No description provided for @sampleRequestPosted.
  ///
  /// In en, this message translates to:
  /// **'Request posted — providers will see it.'**
  String get sampleRequestPosted;

  /// No description provided for @sampleRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'This is a sample request'**
  String get sampleRequestTitle;

  /// No description provided for @sampleRequestBody.
  ///
  /// In en, this message translates to:
  /// **'Real requests will show up here. Turn on alerts and we’ll tell you when someone asks for help in this field.'**
  String get sampleRequestBody;

  /// No description provided for @sampleAlertHelpPosts.
  ///
  /// In en, this message translates to:
  /// **'Alert me to new requests'**
  String get sampleAlertHelpPosts;

  /// No description provided for @sampleAlertOn.
  ///
  /// In en, this message translates to:
  /// **'Done — we’ll tell you about new requests in this field.'**
  String get sampleAlertOn;

  /// No description provided for @foundingBadge.
  ///
  /// In en, this message translates to:
  /// **'First on YordamBor'**
  String get foundingBadge;

  /// No description provided for @foundingBadgeNote.
  ///
  /// In en, this message translates to:
  /// **'The first providers get the “First on YordamBor” badge.'**
  String get foundingBadgeNote;

  /// No description provided for @inviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite providers'**
  String get inviteTitle;

  /// No description provided for @inviteBody.
  ///
  /// In en, this message translates to:
  /// **'Know a good electrician, tutor or salon? Invite them: the more real providers, the more clients come.'**
  String get inviteBody;

  /// No description provided for @inviteShare.
  ///
  /// In en, this message translates to:
  /// **'Share an invite'**
  String get inviteShare;

  /// No description provided for @invitePrepare.
  ///
  /// In en, this message translates to:
  /// **'Prepare a service for someone'**
  String get invitePrepare;

  /// No description provided for @inviteMessage.
  ///
  /// In en, this message translates to:
  /// **'Join me on YordamBor: clients there find providers across Uzbekistan. Adding your service is free, and the first providers get the “First on YordamBor” badge.'**
  String get inviteMessage;

  /// No description provided for @invitePersonalMessage.
  ///
  /// In en, this message translates to:
  /// **'{name}, hello! I’m on YordamBor, where clients find providers. Add your service “{trade}” in {city}: it’s free, and the first providers get the “First on YordamBor” badge.'**
  String invitePersonalMessage(String name, String trade, String city);

  /// No description provided for @inviteOpenLink.
  ///
  /// In en, this message translates to:
  /// **'Open to start: {link}'**
  String inviteOpenLink(String link);

  /// No description provided for @inviteAppLink.
  ///
  /// In en, this message translates to:
  /// **'The app: {link}'**
  String inviteAppLink(String link);

  /// No description provided for @invitePrepareTitle.
  ///
  /// In en, this message translates to:
  /// **'A service for someone you know'**
  String get invitePrepareTitle;

  /// No description provided for @invitePrepareBody.
  ///
  /// In en, this message translates to:
  /// **'Pick their trade and city. They get a link that opens “New service” with these filled in; they publish it themselves.'**
  String get invitePrepareBody;

  /// No description provided for @invitePersonName.
  ///
  /// In en, this message translates to:
  /// **'Their name (optional)'**
  String get invitePersonName;

  /// No description provided for @invitePersonPhone.
  ///
  /// In en, this message translates to:
  /// **'Their phone (optional)'**
  String get invitePersonPhone;

  /// No description provided for @invitePickTrade.
  ///
  /// In en, this message translates to:
  /// **'Trade'**
  String get invitePickTrade;

  /// No description provided for @inviteSendWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Send on WhatsApp'**
  String get inviteSendWhatsApp;

  /// No description provided for @inviteSendSms.
  ///
  /// In en, this message translates to:
  /// **'Send by SMS'**
  String get inviteSendSms;

  /// No description provided for @inviteSendOther.
  ///
  /// In en, this message translates to:
  /// **'Another app'**
  String get inviteSendOther;

  /// No description provided for @inviteNeedTradeCity.
  ///
  /// In en, this message translates to:
  /// **'Choose the trade and the city'**
  String get inviteNeedTradeCity;

  /// No description provided for @onbGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What brings you to YordamBor?'**
  String get onbGoalTitle;

  /// No description provided for @onbGoalNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'I need help'**
  String get onbGoalNeedHelp;

  /// No description provided for @onbGoalNeedHelpSub.
  ///
  /// In en, this message translates to:
  /// **'Find a provider or describe a job'**
  String get onbGoalNeedHelpSub;

  /// No description provided for @onbGoalOffer.
  ///
  /// In en, this message translates to:
  /// **'I offer services'**
  String get onbGoalOffer;

  /// No description provided for @onbGoalOfferSub.
  ///
  /// In en, this message translates to:
  /// **'Get clients and earn'**
  String get onbGoalOfferSub;

  /// No description provided for @onbGoalBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get onbGoalBoth;

  /// No description provided for @onbGoalBothSub.
  ///
  /// In en, this message translates to:
  /// **'I help, and sometimes I need help'**
  String get onbGoalBothSub;

  /// No description provided for @onbCityTitle.
  ///
  /// In en, this message translates to:
  /// **'Your city'**
  String get onbCityTitle;

  /// No description provided for @onbCitySub.
  ///
  /// In en, this message translates to:
  /// **'We’ll show what’s near you.'**
  String get onbCitySub;

  /// No description provided for @onbNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onbNext;

  /// No description provided for @onbDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get onbDone;

  /// No description provided for @onbSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onbSkip;

  /// No description provided for @onbStep.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onbStep(int current, int total);

  /// No description provided for @onbIntro1Title.
  ///
  /// In en, this message translates to:
  /// **'Services near you'**
  String get onbIntro1Title;

  /// No description provided for @onbIntro1Body.
  ///
  /// In en, this message translates to:
  /// **'Specialists and organizations across Uzbekistan.'**
  String get onbIntro1Body;

  /// No description provided for @onbIntro2Title.
  ///
  /// In en, this message translates to:
  /// **'Need help? Just ask'**
  String get onbIntro2Title;

  /// No description provided for @onbIntro2Body.
  ///
  /// In en, this message translates to:
  /// **'Describe the task, and providers will reach out.'**
  String get onbIntro2Body;

  /// No description provided for @onbIntro3Title.
  ///
  /// In en, this message translates to:
  /// **'Offer your services'**
  String get onbIntro3Title;

  /// No description provided for @onbIntro3Body.
  ///
  /// In en, this message translates to:
  /// **'As an individual or an organization. Free.'**
  String get onbIntro3Body;

  /// No description provided for @onbIntro4Title.
  ///
  /// In en, this message translates to:
  /// **'Fair and calm'**
  String get onbIntro4Title;

  /// No description provided for @onbIntro4Body.
  ///
  /// In en, this message translates to:
  /// **'A deal starts when both sides agree. Reviews come only after finished work. You pay as agreed.'**
  String get onbIntro4Body;

  /// No description provided for @onbTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you work?'**
  String get onbTypeTitle;

  /// No description provided for @onbTypeSub.
  ///
  /// In en, this message translates to:
  /// **'Clients see this on your services. You can change it later.'**
  String get onbTypeSub;

  /// No description provided for @onbTypeIndividualSub.
  ///
  /// In en, this message translates to:
  /// **'A tradesperson, tutor or freelancer'**
  String get onbTypeIndividualSub;

  /// No description provided for @onbTypeInstitutionSub.
  ///
  /// In en, this message translates to:
  /// **'A company, salon, clinic or training centre'**
  String get onbTypeInstitutionSub;

  /// No description provided for @onbReadyToOffer.
  ///
  /// In en, this message translates to:
  /// **'Whenever you’re ready, tap “{action}”.'**
  String onbReadyToOffer(String action);

  /// No description provided for @inviteAction.
  ///
  /// In en, this message translates to:
  /// **'Invite a provider you know'**
  String get inviteAction;

  /// No description provided for @invitePersonalMessageNoName.
  ///
  /// In en, this message translates to:
  /// **'Hello! I’m on YordamBor, where clients find providers. Add your service “{trade}” in {city}: it’s free, and the first providers get the “First on YordamBor” badge.'**
  String invitePersonalMessageNoName(String trade, String city);

  /// No description provided for @joinTitle.
  ///
  /// In en, this message translates to:
  /// **'You’re invited to YordamBor'**
  String get joinTitle;

  /// No description provided for @joinBody.
  ///
  /// In en, this message translates to:
  /// **'Add your service — it’s free. Clients find providers here by trade and city.'**
  String get joinBody;

  /// No description provided for @joinLookAround.
  ///
  /// In en, this message translates to:
  /// **'Look around first'**
  String get joinLookAround;

  /// No description provided for @onbStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onbStart;

  /// No description provided for @welcomeFindHelp.
  ///
  /// In en, this message translates to:
  /// **'Find help'**
  String get welcomeFindHelp;

  /// No description provided for @welcomeGiveHelp.
  ///
  /// In en, this message translates to:
  /// **'Offer help'**
  String get welcomeGiveHelp;

  /// No description provided for @onbTileLawyer.
  ///
  /// In en, this message translates to:
  /// **'Lawyer'**
  String get onbTileLawyer;

  /// No description provided for @onbTileBeauty.
  ///
  /// In en, this message translates to:
  /// **'Beauty'**
  String get onbTileBeauty;

  /// No description provided for @onbTileCatering.
  ///
  /// In en, this message translates to:
  /// **'Catering'**
  String get onbTileCatering;

  /// No description provided for @onbTileVet.
  ///
  /// In en, this message translates to:
  /// **'Vet'**
  String get onbTileVet;

  /// No description provided for @onbTileCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cleaning'**
  String get onbTileCleaning;

  /// No description provided for @onbTileElectrician.
  ///
  /// In en, this message translates to:
  /// **'Electrician'**
  String get onbTileElectrician;

  /// No description provided for @onbTilePlumber.
  ///
  /// In en, this message translates to:
  /// **'Plumber'**
  String get onbTilePlumber;

  /// No description provided for @onbTileDental.
  ///
  /// In en, this message translates to:
  /// **'Dental clinic'**
  String get onbTileDental;

  /// No description provided for @onbMoreServices.
  ///
  /// In en, this message translates to:
  /// **'and {count}+ more kinds of service'**
  String onbMoreServices(int count);

  /// No description provided for @onbIllRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'The kitchen tap is leaking'**
  String get onbIllRequestTitle;

  /// No description provided for @onbIllToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get onbIllToday;

  /// No description provided for @onbIllNewOffers.
  ///
  /// In en, this message translates to:
  /// **'2 new offers'**
  String get onbIllNewOffers;

  /// No description provided for @onbIllName1.
  ///
  /// In en, this message translates to:
  /// **'Aziz'**
  String get onbIllName1;

  /// No description provided for @onbIllName2.
  ///
  /// In en, this message translates to:
  /// **'Dilnoza'**
  String get onbIllName2;

  /// No description provided for @onbIllOffer1.
  ///
  /// In en, this message translates to:
  /// **'I can come today at 6 pm'**
  String get onbIllOffer1;

  /// No description provided for @onbIllOffer2.
  ///
  /// In en, this message translates to:
  /// **'Free tomorrow morning'**
  String get onbIllOffer2;

  /// No description provided for @onbIllNewRequest.
  ///
  /// In en, this message translates to:
  /// **'New request'**
  String get onbIllNewRequest;

  /// No description provided for @onbIllSocket.
  ///
  /// In en, this message translates to:
  /// **'Replace a socket'**
  String get onbIllSocket;

  /// No description provided for @onbTileTutor.
  ///
  /// In en, this message translates to:
  /// **'Tutor'**
  String get onbTileTutor;

  /// No description provided for @onbTileAuto.
  ///
  /// In en, this message translates to:
  /// **'Car repair'**
  String get onbTileAuto;

  /// No description provided for @searchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTooltip;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Name, organization or service'**
  String get searchHint;

  /// No description provided for @searchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Type a provider’s name, an organization or a service, such as “plumber”.'**
  String get searchPrompt;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get searchNoResults;

  /// No description provided for @searchNoResultsHint.
  ///
  /// In en, this message translates to:
  /// **'Post a request, and providers will reach out.'**
  String get searchNoResultsHint;

  /// No description provided for @searchOffline.
  ///
  /// In en, this message translates to:
  /// **'No connection: showing only what’s on your phone.'**
  String get searchOffline;

  /// No description provided for @onbTileRenovation.
  ///
  /// In en, this message translates to:
  /// **'Renovation'**
  String get onbTileRenovation;

  /// No description provided for @onbTileFitness.
  ///
  /// In en, this message translates to:
  /// **'Fitness'**
  String get onbTileFitness;

  /// No description provided for @onbTileTranslator.
  ///
  /// In en, this message translates to:
  /// **'Translator'**
  String get onbTileTranslator;

  /// No description provided for @onbTileBarber.
  ///
  /// In en, this message translates to:
  /// **'Barber'**
  String get onbTileBarber;

  /// No description provided for @onbTileMusic.
  ///
  /// In en, this message translates to:
  /// **'Music lessons'**
  String get onbTileMusic;

  /// No description provided for @onbTileStylist.
  ///
  /// In en, this message translates to:
  /// **'Stylist'**
  String get onbTileStylist;

  /// No description provided for @onbTileKindergarten.
  ///
  /// In en, this message translates to:
  /// **'Kindergarten'**
  String get onbTileKindergarten;

  /// No description provided for @onbIllTutorTitle.
  ///
  /// In en, this message translates to:
  /// **'English and IELTS'**
  String get onbIllTutorTitle;

  /// No description provided for @onbIllStylistRequest.
  ///
  /// In en, this message translates to:
  /// **'A look for a wedding'**
  String get onbIllStylistRequest;

  /// No description provided for @onbKindsChip.
  ///
  /// In en, this message translates to:
  /// **'+{count} kinds of service'**
  String onbKindsChip(int count);

  /// No description provided for @onbIllDentalRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'I have a toothache'**
  String get onbIllDentalRequestTitle;

  /// No description provided for @onbTileDentist.
  ///
  /// In en, this message translates to:
  /// **'Dentist'**
  String get onbTileDentist;

  /// No description provided for @onbIllDentalOffer1.
  ///
  /// In en, this message translates to:
  /// **'We can see you today at 4 pm'**
  String get onbIllDentalOffer1;

  /// No description provided for @onbIllDentalOffer2.
  ///
  /// In en, this message translates to:
  /// **'I can see you tomorrow morning'**
  String get onbIllDentalOffer2;

  /// No description provided for @xizmatStatNoReviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews'**
  String get xizmatStatNoReviews;

  /// No description provided for @xizmatStatPrice.
  ///
  /// In en, this message translates to:
  /// **'price'**
  String get xizmatStatPrice;

  /// No description provided for @xizmatStatPerHour.
  ///
  /// In en, this message translates to:
  /// **'per hour'**
  String get xizmatStatPerHour;

  /// No description provided for @xizmatStatNegotiable.
  ///
  /// In en, this message translates to:
  /// **'Negotiable'**
  String get xizmatStatNegotiable;

  /// No description provided for @xizmatPromiseOwnWords.
  ///
  /// In en, this message translates to:
  /// **'In the provider’s own words'**
  String get xizmatPromiseOwnWords;

  /// No description provided for @xizmatAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About this service'**
  String get xizmatAboutTitle;

  /// No description provided for @actionReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get actionReadMore;

  /// No description provided for @actionReadLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get actionReadLess;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} review} other{{count} reviews}}'**
  String reviewsCount(int count);

  /// No description provided for @reviewsSeeAll.
  ///
  /// In en, this message translates to:
  /// **'All reviews ({count})'**
  String reviewsSeeAll(int count);

  /// No description provided for @reviewsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get reviewsFilterAll;

  /// No description provided for @reviewsFilterEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reviews with this rating yet'**
  String get reviewsFilterEmpty;

  /// No description provided for @reviewsBarA11y.
  ///
  /// In en, this message translates to:
  /// **'Rating {stars}: {count}'**
  String reviewsBarA11y(int stars, int count);

  /// No description provided for @xizmatHowTitle.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get xizmatHowTitle;

  /// No description provided for @xizmatHowAsk.
  ///
  /// In en, this message translates to:
  /// **'Send a request'**
  String get xizmatHowAsk;

  /// No description provided for @xizmatHowChat.
  ///
  /// In en, this message translates to:
  /// **'Chat in the app'**
  String get xizmatHowChat;

  /// No description provided for @xizmatHowAgree.
  ///
  /// In en, this message translates to:
  /// **'Agree on the job'**
  String get xizmatHowAgree;

  /// No description provided for @providerMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {year}'**
  String providerMemberSince(String year);

  /// No description provided for @providerServicesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} service} other{{count} services}}'**
  String providerServicesCount(int count);

  /// No description provided for @xizmatAboutHint.
  ///
  /// In en, this message translates to:
  /// **'What you do, how you work, what you promise clients'**
  String get xizmatAboutHint;

  /// No description provided for @xizmatPricePerDay.
  ///
  /// In en, this message translates to:
  /// **'{amount}/day'**
  String xizmatPricePerDay(String amount);

  /// No description provided for @xizmatPricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'{amount}/month'**
  String xizmatPricePerMonth(String amount);

  /// No description provided for @xizmatPricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'{amount}/unit'**
  String xizmatPricePerUnit(String amount);

  /// No description provided for @xizmatStatPerDay.
  ///
  /// In en, this message translates to:
  /// **'per day'**
  String get xizmatStatPerDay;

  /// No description provided for @xizmatStatPerMonth.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get xizmatStatPerMonth;

  /// No description provided for @xizmatStatPerUnit.
  ///
  /// In en, this message translates to:
  /// **'per unit'**
  String get xizmatStatPerUnit;

  /// No description provided for @priceChoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceChoiceTitle;

  /// No description provided for @priceChoiceServiceHint.
  ///
  /// In en, this message translates to:
  /// **'Clients write sooner when they can see the price.'**
  String get priceChoiceServiceHint;

  /// No description provided for @priceChoiceRequestHint.
  ///
  /// In en, this message translates to:
  /// **'How much are you ready to pay?'**
  String get priceChoiceRequestHint;

  /// No description provided for @priceChoiceNegotiable.
  ///
  /// In en, this message translates to:
  /// **'Negotiable'**
  String get priceChoiceNegotiable;

  /// No description provided for @priceChoiceNegotiableHint.
  ///
  /// In en, this message translates to:
  /// **'Agree on it in the chat'**
  String get priceChoiceNegotiableHint;

  /// No description provided for @priceChoiceAmount.
  ///
  /// In en, this message translates to:
  /// **'Set price'**
  String get priceChoiceAmount;

  /// No description provided for @priceChoiceAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Amount and unit'**
  String get priceChoiceAmountHint;

  /// No description provided for @priceAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount (UZS)'**
  String get priceAmountLabel;

  /// No description provided for @priceAmountHint.
  ///
  /// In en, this message translates to:
  /// **'For example: 150000'**
  String get priceAmountHint;

  /// No description provided for @priceUnitFixed.
  ///
  /// In en, this message translates to:
  /// **'Per job'**
  String get priceUnitFixed;

  /// No description provided for @priceUnitHour.
  ///
  /// In en, this message translates to:
  /// **'Per hour'**
  String get priceUnitHour;

  /// No description provided for @priceUnitDay.
  ///
  /// In en, this message translates to:
  /// **'Per day'**
  String get priceUnitDay;

  /// No description provided for @priceUnitMonth.
  ///
  /// In en, this message translates to:
  /// **'Per month'**
  String get priceUnitMonth;

  /// No description provided for @priceUnitUnit.
  ///
  /// In en, this message translates to:
  /// **'Per unit'**
  String get priceUnitUnit;

  /// No description provided for @priceChoiceRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose the price: negotiable or an amount'**
  String get priceChoiceRequired;

  /// No description provided for @growthI00Title.
  ///
  /// In en, this message translates to:
  /// **'Your service is live on YordamBor!'**
  String get growthI00Title;

  /// No description provided for @growthI00Body.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! For the next 30 days we\'ll send short tips to help you find more clients.'**
  String get growthI00Body;

  /// No description provided for @growthI01Title.
  ///
  /// In en, this message translates to:
  /// **'Photos build trust'**
  String get growthI01Title;

  /// No description provided for @growthI01Body.
  ///
  /// In en, this message translates to:
  /// **'Add at least 3 photos of your work — before-and-after shots work especially well.'**
  String get growthI01Body;

  /// No description provided for @growthI02Title.
  ///
  /// In en, this message translates to:
  /// **'Show your price'**
  String get growthI02Title;

  /// No description provided for @growthI02Body.
  ///
  /// In en, this message translates to:
  /// **'A clear price means fewer questions and faster deals. Set a price per hour, day or job.'**
  String get growthI02Body;

  /// No description provided for @growthI03Title.
  ///
  /// In en, this message translates to:
  /// **'When are you free?'**
  String get growthI03Title;

  /// No description provided for @growthI03Body.
  ///
  /// In en, this message translates to:
  /// **'Set your status to “Available now”: clients write first to those who can come soon.'**
  String get growthI03Body;

  /// No description provided for @growthI04Title.
  ///
  /// In en, this message translates to:
  /// **'Invite your clients to YordamBor'**
  String get growthI04Title;

  /// No description provided for @growthI04Body.
  ///
  /// In en, this message translates to:
  /// **'Send your regular clients a link to your service: next time they\'ll find you in one tap.'**
  String get growthI04Body;

  /// No description provided for @growthI05Title.
  ///
  /// In en, this message translates to:
  /// **'Fast replies win work'**
  String get growthI05Title;

  /// No description provided for @growthI05Body.
  ///
  /// In en, this message translates to:
  /// **'Reply to requests within an hour: clients usually pick whoever answers first.'**
  String get growthI05Body;

  /// No description provided for @growthI06Title.
  ///
  /// In en, this message translates to:
  /// **'Tell clients about yourself'**
  String get growthI06Title;

  /// No description provided for @growthI06Body.
  ///
  /// In en, this message translates to:
  /// **'Describe your experience and the way you work in 3–4 sentences: clients want to know who they\'ll work with.'**
  String get growthI06Body;

  /// No description provided for @growthI07Title.
  ///
  /// In en, this message translates to:
  /// **'Reviews are the best ad'**
  String get growthI07Title;

  /// No description provided for @growthI07Body.
  ///
  /// In en, this message translates to:
  /// **'When a job is done, ask the client for a review on YordamBor: every rating brings new clients.'**
  String get growthI07Body;

  /// No description provided for @growthI08Title.
  ///
  /// In en, this message translates to:
  /// **'Your friends need YordamBor too'**
  String get growthI08Title;

  /// No description provided for @growthI08Body.
  ///
  /// In en, this message translates to:
  /// **'Tell friends and neighbours about YordamBor: more clients here means more orders for you.'**
  String get growthI08Body;

  /// No description provided for @growthI09Title.
  ///
  /// In en, this message translates to:
  /// **'Keep your calendar current'**
  String get growthI09Title;

  /// No description provided for @growthI09Body.
  ///
  /// In en, this message translates to:
  /// **'Mark your busy days: clients see when you\'re free and book a specific day.'**
  String get growthI09Body;

  /// No description provided for @growthI10Title.
  ///
  /// In en, this message translates to:
  /// **'Track your income'**
  String get growthI10Title;

  /// No description provided for @growthI10Body.
  ///
  /// In en, this message translates to:
  /// **'Tools has your income, client book and receipts — all in one place.'**
  String get growthI10Body;

  /// No description provided for @growthI11Title.
  ///
  /// In en, this message translates to:
  /// **'30 days — a great start!'**
  String get growthI11Title;

  /// No description provided for @growthI11Body.
  ///
  /// In en, this message translates to:
  /// **'Share your service link on social media and keep growing on YordamBor.'**
  String get growthI11Body;

  /// No description provided for @growthO00Title.
  ///
  /// In en, this message translates to:
  /// **'Your organisation is live on YordamBor!'**
  String get growthO00Title;

  /// No description provided for @growthO00Body.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! For the next 30 days we\'ll send short tips to grow your flow of clients.'**
  String get growthO00Body;

  /// No description provided for @growthO01Title.
  ///
  /// In en, this message translates to:
  /// **'Show your place'**
  String get growthO01Title;

  /// No description provided for @growthO01Body.
  ///
  /// In en, this message translates to:
  /// **'Add at least 3 photos of your premises, team and work: clients see in advance where they\'re going.'**
  String get growthO01Body;

  /// No description provided for @growthO02Title.
  ///
  /// In en, this message translates to:
  /// **'Make your prices clear'**
  String get growthO02Title;

  /// No description provided for @growthO02Body.
  ///
  /// In en, this message translates to:
  /// **'Show the price of your main service: clients write more to organisations with clear prices.'**
  String get growthO02Body;

  /// No description provided for @growthO03Title.
  ///
  /// In en, this message translates to:
  /// **'Set your opening hours'**
  String get growthO03Title;

  /// No description provided for @growthO03Body.
  ///
  /// In en, this message translates to:
  /// **'Add your working days and hours: clients see right away when they can come.'**
  String get growthO03Body;

  /// No description provided for @growthO04Title.
  ///
  /// In en, this message translates to:
  /// **'Invite your clients to YordamBor'**
  String get growthO04Title;

  /// No description provided for @growthO04Body.
  ///
  /// In en, this message translates to:
  /// **'Share your link in your Telegram channel, at the till or by SMS: clients find you in one tap.'**
  String get growthO04Body;

  /// No description provided for @growthO05Title.
  ///
  /// In en, this message translates to:
  /// **'Licences and certificates'**
  String get growthO05Title;

  /// No description provided for @growthO05Body.
  ///
  /// In en, this message translates to:
  /// **'Add your documents to your profile: official proof makes clients trust you more.'**
  String get growthO05Body;

  /// No description provided for @growthO06Title.
  ///
  /// In en, this message translates to:
  /// **'One service per line of work'**
  String get growthO06Title;

  /// No description provided for @growthO06Body.
  ///
  /// In en, this message translates to:
  /// **'Add your services one by one (up to 5): clients find exactly what they need faster.'**
  String get growthO06Body;

  /// No description provided for @growthO07Title.
  ///
  /// In en, this message translates to:
  /// **'Answer requests quickly'**
  String get growthO07Title;

  /// No description provided for @growthO07Body.
  ///
  /// In en, this message translates to:
  /// **'Put someone in charge of replies: fast answers mean more deals.'**
  String get growthO07Body;

  /// No description provided for @growthO08Title.
  ///
  /// In en, this message translates to:
  /// **'Ask every client for a review'**
  String get growthO08Title;

  /// No description provided for @growthO08Body.
  ///
  /// In en, this message translates to:
  /// **'Reviews from happy clients raise your rating and bring in new clients.'**
  String get growthO08Body;

  /// No description provided for @growthO09Title.
  ///
  /// In en, this message translates to:
  /// **'Put your link on your business card'**
  String get growthO09Title;

  /// No description provided for @growthO09Body.
  ///
  /// In en, this message translates to:
  /// **'Put your YordamBor link on your card, menu or shop window: booking takes one tap.'**
  String get growthO09Body;

  /// No description provided for @growthO10Title.
  ///
  /// In en, this message translates to:
  /// **'Your books in one place'**
  String get growthO10Title;

  /// No description provided for @growthO10Body.
  ///
  /// In en, this message translates to:
  /// **'Receipts, income and the client book are in Tools: keep your organisation in order.'**
  String get growthO10Body;

  /// No description provided for @growthO11Title.
  ///
  /// In en, this message translates to:
  /// **'Your first month is done!'**
  String get growthO11Title;

  /// No description provided for @growthO11Body.
  ///
  /// In en, this message translates to:
  /// **'See your results on your service card and keep growing your clients on YordamBor.'**
  String get growthO11Body;

  /// No description provided for @growthProgramTitle.
  ///
  /// In en, this message translates to:
  /// **'Grow your business'**
  String get growthProgramTitle;

  /// No description provided for @growthProgramDay.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of 30'**
  String growthProgramDay(int day);

  /// No description provided for @growthTipDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get growthTipDone;

  /// No description provided for @growthEarlierTips.
  ///
  /// In en, this message translates to:
  /// **'Earlier tips'**
  String get growthEarlierTips;

  /// No description provided for @growthTipsOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off tips'**
  String get growthTipsOff;

  /// No description provided for @growthTipsOffDone.
  ///
  /// In en, this message translates to:
  /// **'Tips are off. You can turn them back on in reminder settings.'**
  String get growthTipsOffDone;

  /// No description provided for @growthTipsSetting.
  ///
  /// In en, this message translates to:
  /// **'Business tips'**
  String get growthTipsSetting;

  /// No description provided for @growthTipsSettingSub.
  ///
  /// In en, this message translates to:
  /// **'For 30 days after you add a service'**
  String get growthTipsSettingSub;

  /// No description provided for @growthInviteShareText.
  ///
  /// In en, this message translates to:
  /// **'YordamBor — trusted pros and services in one place. Get the app: {link}'**
  String growthInviteShareText(String link);

  /// No description provided for @growthActionPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get growthActionPhotos;

  /// No description provided for @growthActionPrice.
  ///
  /// In en, this message translates to:
  /// **'Set the price'**
  String get growthActionPrice;

  /// No description provided for @growthActionAvailability.
  ///
  /// In en, this message translates to:
  /// **'Set your status'**
  String get growthActionAvailability;

  /// No description provided for @growthActionHours.
  ///
  /// In en, this message translates to:
  /// **'Set your hours'**
  String get growthActionHours;

  /// No description provided for @growthActionShare.
  ///
  /// In en, this message translates to:
  /// **'Share the link'**
  String get growthActionShare;

  /// No description provided for @growthActionInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get growthActionInvite;

  /// No description provided for @growthActionReply.
  ///
  /// In en, this message translates to:
  /// **'Open requests'**
  String get growthActionReply;

  /// No description provided for @growthActionDescription.
  ///
  /// In en, this message translates to:
  /// **'Write the description'**
  String get growthActionDescription;

  /// No description provided for @growthActionReviews.
  ///
  /// In en, this message translates to:
  /// **'Open deals'**
  String get growthActionReviews;

  /// No description provided for @growthActionCalendar.
  ///
  /// In en, this message translates to:
  /// **'Open the calendar'**
  String get growthActionCalendar;

  /// No description provided for @growthActionTools.
  ///
  /// In en, this message translates to:
  /// **'Open tools'**
  String get growthActionTools;

  /// No description provided for @growthActionCertificates.
  ///
  /// In en, this message translates to:
  /// **'Add a document'**
  String get growthActionCertificates;

  /// No description provided for @growthActionMoreServices.
  ///
  /// In en, this message translates to:
  /// **'Add a service'**
  String get growthActionMoreServices;

  /// No description provided for @growthActionMyServices.
  ///
  /// In en, this message translates to:
  /// **'See my services'**
  String get growthActionMyServices;

  /// No description provided for @appointmentPhaseNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get appointmentPhaseNow;

  /// No description provided for @appointmentPhaseToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get appointmentPhaseToday;

  /// No description provided for @appointmentPhasePlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get appointmentPhasePlanned;

  /// No description provided for @appointmentPhasePast.
  ///
  /// In en, this message translates to:
  /// **'Awaiting completion'**
  String get appointmentPhasePast;

  /// No description provided for @appointmentPhaseDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get appointmentPhaseDone;

  /// No description provided for @appointmentPhaseCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get appointmentPhaseCancelled;

  /// No description provided for @appointmentRoleProvider.
  ///
  /// In en, this message translates to:
  /// **'I provide'**
  String get appointmentRoleProvider;

  /// No description provided for @appointmentRoleClient.
  ///
  /// In en, this message translates to:
  /// **'I receive'**
  String get appointmentRoleClient;

  /// No description provided for @appointmentPartyClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get appointmentPartyClient;

  /// No description provided for @appointmentPartyProvider.
  ///
  /// In en, this message translates to:
  /// **'Service provider'**
  String get appointmentPartyProvider;

  /// No description provided for @appointmentCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get appointmentCall;

  /// No description provided for @actionChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get actionChat;

  /// No description provided for @actionKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get actionKeep;

  /// No description provided for @appointmentCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get appointmentCancel;

  /// No description provided for @appointmentCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel appointment?'**
  String get appointmentCancelTitle;

  /// No description provided for @appointmentCancelBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. The other party will be notified.'**
  String get appointmentCancelBody;

  /// No description provided for @appointmentCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, cancel'**
  String get appointmentCancelConfirm;

  /// No description provided for @appointmentSaveClient.
  ///
  /// In en, this message translates to:
  /// **'Save to client list'**
  String get appointmentSaveClient;

  /// No description provided for @appointmentFactPrice.
  ///
  /// In en, this message translates to:
  /// **'PRICE'**
  String get appointmentFactPrice;

  /// No description provided for @appointmentFactDuration.
  ///
  /// In en, this message translates to:
  /// **'DURATION'**
  String get appointmentFactDuration;

  /// No description provided for @appointmentDuration.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String appointmentDuration(int minutes);

  /// No description provided for @availabilitySheetCaption.
  ///
  /// In en, this message translates to:
  /// **'What will clients see right now?'**
  String get availabilitySheetCaption;

  /// No description provided for @availabilityTileNowHint.
  ///
  /// In en, this message translates to:
  /// **'Taking orders now'**
  String get availabilityTileNowHint;

  /// No description provided for @availabilityTileBusyHint.
  ///
  /// In en, this message translates to:
  /// **'Busy, back soon'**
  String get availabilityTileBusyHint;

  /// No description provided for @availabilityTileBookingHint.
  ///
  /// In en, this message translates to:
  /// **'Book in advance'**
  String get availabilityTileBookingHint;

  /// No description provided for @availabilityTileHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get availabilityTileHidden;

  /// No description provided for @availabilityTileHiddenHint.
  ///
  /// In en, this message translates to:
  /// **'Service not visible'**
  String get availabilityTileHiddenHint;

  /// No description provided for @availabilityUntilTitle.
  ///
  /// In en, this message translates to:
  /// **'Until when?'**
  String get availabilityUntilTitle;

  /// No description provided for @availabilityUntilHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get availabilityUntilHour;

  /// No description provided for @availabilityUntilToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get availabilityUntilToday;

  /// No description provided for @availabilityUntilForever.
  ///
  /// In en, this message translates to:
  /// **'Open-ended'**
  String get availabilityUntilForever;

  /// No description provided for @availabilityHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Working hours'**
  String get availabilityHoursTitle;

  /// No description provided for @availabilityHoursOwn.
  ///
  /// In en, this message translates to:
  /// **'My schedule'**
  String get availabilityHoursOwn;

  /// No description provided for @availabilityHoursShared.
  ///
  /// In en, this message translates to:
  /// **'Shared hours'**
  String get availabilityHoursShared;

  /// No description provided for @availabilityBusyToggle.
  ///
  /// In en, this message translates to:
  /// **'Show busy hours to clients'**
  String get availabilityBusyToggle;

  /// No description provided for @availabilityBusyToggleHint.
  ///
  /// In en, this message translates to:
  /// **'Clients see a two-week strip with your free and busy slots'**
  String get availabilityBusyToggleHint;

  /// No description provided for @availabilityPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get availabilityPreview;

  /// No description provided for @availabilityHiddenPreview.
  ///
  /// In en, this message translates to:
  /// **'Hidden from search'**
  String get availabilityHiddenPreview;

  /// No description provided for @availabilitySaved.
  ///
  /// In en, this message translates to:
  /// **'Status saved'**
  String get availabilitySaved;

  /// No description provided for @businessEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Start earning on YordamBor'**
  String get businessEmptyTitle;

  /// No description provided for @businessEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Thousands of people nearby are looking for help right now. Add your first service — it takes just 2 minutes.'**
  String get businessEmptyBody;

  /// No description provided for @calendarTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get calendarTabTitle;

  /// No description provided for @calendarNoAppointments.
  ///
  /// In en, this message translates to:
  /// **'No appointments yet'**
  String get calendarNoAppointments;

  /// No description provided for @calendarNoAppointmentsHint.
  ///
  /// In en, this message translates to:
  /// **'Agreed deals appear here as appointments'**
  String get calendarNoAppointmentsHint;

  /// No description provided for @calendarSectionToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get calendarSectionToday;

  /// No description provided for @calendarSectionUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get calendarSectionUpcoming;

  /// No description provided for @calendarSectionPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get calendarSectionPast;

  /// No description provided for @calendarBusyTitle.
  ///
  /// In en, this message translates to:
  /// **'My availability'**
  String get calendarBusyTitle;

  /// No description provided for @calendarBusyAllDay.
  ///
  /// In en, this message translates to:
  /// **'Busy all day'**
  String get calendarBusyAllDay;

  /// No description provided for @calendarBusyHours.
  ///
  /// In en, this message translates to:
  /// **'Busy hours'**
  String get calendarBusyHours;

  /// No description provided for @calendarServicesStrip.
  ///
  /// In en, this message translates to:
  /// **'My services'**
  String get calendarServicesStrip;

  /// No description provided for @calendarReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get calendarReminders;

  /// No description provided for @reminderLeadDay.
  ///
  /// In en, this message translates to:
  /// **'1 day before'**
  String get reminderLeadDay;

  /// No description provided for @reminderLead3Hours.
  ///
  /// In en, this message translates to:
  /// **'3 hours before'**
  String get reminderLead3Hours;

  /// No description provided for @reminderLeadHour.
  ///
  /// In en, this message translates to:
  /// **'1 hour before'**
  String get reminderLeadHour;

  /// No description provided for @reminderLead15Min.
  ///
  /// In en, this message translates to:
  /// **'15 minutes before'**
  String get reminderLead15Min;

  /// No description provided for @saveClientPromptTitle.
  ///
  /// In en, this message translates to:
  /// **'Save client?'**
  String get saveClientPromptTitle;

  /// No description provided for @saveClientPromptBody.
  ///
  /// In en, this message translates to:
  /// **'Would you like to add {name} to your client list?'**
  String saveClientPromptBody(String name);

  /// No description provided for @saveClientConfirm.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveClientConfirm;

  /// No description provided for @saveClientSkip.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get saveClientSkip;

  /// No description provided for @saveClientDone.
  ///
  /// In en, this message translates to:
  /// **'Client saved'**
  String get saveClientDone;

  /// No description provided for @notifSectionSoon.
  ///
  /// In en, this message translates to:
  /// **'Upcoming appointments'**
  String get notifSectionSoon;

  /// No description provided for @notifAppointmentCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment cancelled'**
  String get notifAppointmentCancelledTitle;

  /// No description provided for @notifSubsectorHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help needed in your area'**
  String get notifSubsectorHelpTitle;

  /// No description provided for @reminderLeadMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute before} other{{count} minutes before}}'**
  String reminderLeadMinutes(int count);

  /// No description provided for @reminderLeadHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour before} other{{count} hours before}}'**
  String reminderLeadHours(int count);

  /// No description provided for @reminderLeadDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day before} other{{count} days before}}'**
  String reminderLeadDays(int count);

  /// No description provided for @reminderFollowUpAfterHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour after} other{{count} hours after}}'**
  String reminderFollowUpAfterHours(int count);

  /// No description provided for @reminderFollowUpServiceDone.
  ///
  /// In en, this message translates to:
  /// **'Was the service done?'**
  String get reminderFollowUpServiceDone;

  /// No description provided for @reminderDefaultBody.
  ///
  /// In en, this message translates to:
  /// **'Appointment with {name}'**
  String reminderDefaultBody(String name);

  /// No description provided for @remindersSettingsPickOne.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one time'**
  String get remindersSettingsPickOne;

  /// No description provided for @remindersSettingsFollowUpHint.
  ///
  /// In en, this message translates to:
  /// **'We ask how it went, so the deal and your earnings stay up to date.'**
  String get remindersSettingsFollowUpHint;

  /// No description provided for @alertFromServiceTag.
  ///
  /// In en, this message translates to:
  /// **'For your service'**
  String get alertFromServiceTag;

  /// No description provided for @alertFromServiceHint.
  ///
  /// In en, this message translates to:
  /// **'Made when you added this service. Switch off what you don\'t need.'**
  String get alertFromServiceHint;

  /// No description provided for @alertAnyCity.
  ///
  /// In en, this message translates to:
  /// **'Any city'**
  String get alertAnyCity;

  /// No description provided for @errSignInRequired.
  ///
  /// In en, this message translates to:
  /// **'Please sign in first'**
  String get errSignInRequired;

  /// No description provided for @errServerNotSetUp.
  ///
  /// In en, this message translates to:
  /// **'The server is not set up'**
  String get errServerNotSetUp;

  /// No description provided for @errNoPermission.
  ///
  /// In en, this message translates to:
  /// **'You can\'t do that'**
  String get errNoPermission;

  /// No description provided for @errDealNotFound.
  ///
  /// In en, this message translates to:
  /// **'Deal not found'**
  String get errDealNotFound;

  /// No description provided for @errServiceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Service not found'**
  String get errServiceNotFound;

  /// No description provided for @errOwnService.
  ///
  /// In en, this message translates to:
  /// **'You can\'t send a request to your own service'**
  String get errOwnService;

  /// No description provided for @errOwnRequest.
  ///
  /// In en, this message translates to:
  /// **'You can\'t make an offer on your own request'**
  String get errOwnRequest;

  /// No description provided for @errDealNotCreated.
  ///
  /// In en, this message translates to:
  /// **'The deal was not created'**
  String get errDealNotCreated;

  /// No description provided for @errPhotoRequired.
  ///
  /// In en, this message translates to:
  /// **'Add at least one portfolio photo'**
  String get errPhotoRequired;

  /// No description provided for @errOfferViaOwnService.
  ///
  /// In en, this message translates to:
  /// **'Offer through one of your own services'**
  String get errOfferViaOwnService;

  /// No description provided for @errRequestNotFound.
  ///
  /// In en, this message translates to:
  /// **'Request not found'**
  String get errRequestNotFound;

  /// No description provided for @errServiceNotUploaded.
  ///
  /// In en, this message translates to:
  /// **'The service was created but could not be loaded'**
  String get errServiceNotUploaded;

  /// No description provided for @errMessageTooShort.
  ///
  /// In en, this message translates to:
  /// **'The message is too short'**
  String get errMessageTooShort;

  /// No description provided for @errMessageEmpty.
  ///
  /// In en, this message translates to:
  /// **'Write a message first'**
  String get errMessageEmpty;

  /// No description provided for @errWrongPhoneOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong phone number or password'**
  String get errWrongPhoneOrPassword;

  /// No description provided for @errDescriptionTooShort.
  ///
  /// In en, this message translates to:
  /// **'The description needs at least 10 characters'**
  String get errDescriptionTooShort;

  /// No description provided for @errPickSubcategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a sub-sector'**
  String get errPickSubcategory;

  /// No description provided for @errPickCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a sector'**
  String get errPickCategory;

  /// No description provided for @errTermsOnlyOpenDeal.
  ///
  /// In en, this message translates to:
  /// **'Terms can only change while the deal is open'**
  String get errTermsOnlyOpenDeal;

  /// No description provided for @errPickCity.
  ///
  /// In en, this message translates to:
  /// **'Choose a city'**
  String get errPickCity;

  /// No description provided for @errTitleMin3.
  ///
  /// In en, this message translates to:
  /// **'The title needs at least 3 characters'**
  String get errTitleMin3;

  /// No description provided for @errTitleMin2.
  ///
  /// In en, this message translates to:
  /// **'The title needs at least 2 characters'**
  String get errTitleMin2;

  /// No description provided for @errSignUpFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign-up did not go through'**
  String get errSignUpFailed;

  /// No description provided for @errResetLinkExpired.
  ///
  /// In en, this message translates to:
  /// **'This password reset link has expired. Ask for a new one.'**
  String get errResetLinkExpired;

  /// No description provided for @errCannotBlockSelf.
  ///
  /// In en, this message translates to:
  /// **'You can\'t block yourself'**
  String get errCannotBlockSelf;

  /// No description provided for @errMaxAlerts.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} alerts'**
  String errMaxAlerts(int count);

  /// No description provided for @errMaxCertificates.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} certificates'**
  String errMaxCertificates(int count);

  /// No description provided for @errDealNotUpdated.
  ///
  /// In en, this message translates to:
  /// **'The deal was not updated'**
  String get errDealNotUpdated;

  /// No description provided for @errKeepOnePhoto.
  ///
  /// In en, this message translates to:
  /// **'Keep at least one portfolio photo'**
  String get errKeepOnePhoto;

  /// No description provided for @errPickAlertType.
  ///
  /// In en, this message translates to:
  /// **'Choose at least one kind of alert'**
  String get errPickAlertType;

  /// No description provided for @errOwnProfileOnly.
  ///
  /// In en, this message translates to:
  /// **'You can only add to your own profile'**
  String get errOwnProfileOnly;

  /// No description provided for @errOnlyAgreedDone.
  ///
  /// In en, this message translates to:
  /// **'Only an agreed deal can be marked done'**
  String get errOnlyAgreedDone;

  /// No description provided for @errEmailNotFound.
  ///
  /// In en, this message translates to:
  /// **'Email not found'**
  String get errEmailNotFound;

  /// No description provided for @errDealAlreadyOpen.
  ///
  /// In en, this message translates to:
  /// **'You already have an open deal for this service'**
  String get errDealAlreadyOpen;

  /// No description provided for @errAccountNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account with this phone or email'**
  String get errAccountNotFound;

  /// No description provided for @errAlreadyReviewed.
  ///
  /// In en, this message translates to:
  /// **'This deal has already been reviewed'**
  String get errAlreadyReviewed;

  /// No description provided for @errUserBlocked.
  ///
  /// In en, this message translates to:
  /// **'Contact with this person is blocked'**
  String get errUserBlocked;

  /// No description provided for @errNotNow.
  ///
  /// In en, this message translates to:
  /// **'That can\'t be done right now'**
  String get errNotNow;

  /// No description provided for @errRatingRange.
  ///
  /// In en, this message translates to:
  /// **'The rating must be from 1 to 5'**
  String get errRatingRange;

  /// No description provided for @errTermsLocked.
  ///
  /// In en, this message translates to:
  /// **'Terms can\'t change three days after agreeing'**
  String get errTermsLocked;

  /// No description provided for @errSlowNetwork.
  ///
  /// In en, this message translates to:
  /// **'The connection is slow or the server is not answering. Try again later.'**
  String get errSlowNetwork;

  /// No description provided for @errTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in 15 minutes, or sign in with your email.'**
  String get errTooManyAttempts;

  /// No description provided for @errProjectDescriptionTooShort.
  ///
  /// In en, this message translates to:
  /// **'The description needs at least 10 characters'**
  String get errProjectDescriptionTooShort;

  /// No description provided for @errMaxServices.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} services'**
  String errMaxServices(int count);

  /// No description provided for @errDoneAfter3Days.
  ///
  /// In en, this message translates to:
  /// **'Done can be confirmed three days after agreeing'**
  String get errDoneAfter3Days;

  /// No description provided for @errOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection, or the server can\'t be reached. Try again later.'**
  String get errOffline;

  /// No description provided for @dealAcceptTitle.
  ///
  /// In en, this message translates to:
  /// **'Accept?'**
  String get dealAcceptTitle;

  /// No description provided for @dealAcceptBody.
  ///
  /// In en, this message translates to:
  /// **'Once you accept the terms, the other side confirms them too.'**
  String get dealAcceptBody;

  /// No description provided for @dealDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Is the work done?'**
  String get dealDoneTitle;

  /// No description provided for @dealDoneBodyLast.
  ///
  /// In en, this message translates to:
  /// **'Once you confirm, the deal is complete.'**
  String get dealDoneBodyLast;

  /// No description provided for @dealDoneBodyFirst.
  ///
  /// In en, this message translates to:
  /// **'Confirm the work is fully done? The other side confirms too.'**
  String get dealDoneBodyFirst;

  /// No description provided for @dealDoneConfirm.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get dealDoneConfirm;

  /// No description provided for @dealCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel the deal?'**
  String get dealCancelTitle;

  /// No description provided for @dealCancelBody.
  ///
  /// In en, this message translates to:
  /// **'The deal will be cancelled. This can\'t be undone.'**
  String get dealCancelBody;

  /// No description provided for @dealEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Change the terms?'**
  String get dealEditTitle;

  /// No description provided for @dealEditBody.
  ///
  /// In en, this message translates to:
  /// **'After the change, both sides confirm again.'**
  String get dealEditBody;

  /// No description provided for @actionYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get actionYes;

  /// No description provided for @actionNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get actionNo;

  /// No description provided for @fallbackUserName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get fallbackUserName;

  /// No description provided for @fallbackServiceName.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get fallbackServiceName;

  /// No description provided for @fallbackYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get fallbackYou;

  /// No description provided for @channelAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get channelAlerts;

  /// No description provided for @channelAlertsSub.
  ///
  /// In en, this message translates to:
  /// **'Deals and sub-sector alerts'**
  String get channelAlertsSub;

  /// No description provided for @channelReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get channelReminders;

  /// No description provided for @channelRemindersSub.
  ///
  /// In en, this message translates to:
  /// **'Deal and client reminders'**
  String get channelRemindersSub;

  /// No description provided for @channelTips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get channelTips;

  /// No description provided for @channelTipsSub.
  ///
  /// In en, this message translates to:
  /// **'Tips to grow your business'**
  String get channelTipsSub;

  /// No description provided for @errBadApiKey.
  ///
  /// In en, this message translates to:
  /// **'The app\'s server key is wrong. Check the anon key in .env.json and restart the app.'**
  String get errBadApiKey;

  /// No description provided for @errWrongEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password'**
  String get errWrongEmailOrPassword;

  /// No description provided for @errEmailNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your email isn\'t confirmed yet. Open the link we sent, or send it again.'**
  String get errEmailNotConfirmed;

  /// No description provided for @errEmailTaken.
  ///
  /// In en, this message translates to:
  /// **'An account with this email exists. Try signing in.'**
  String get errEmailTaken;

  /// No description provided for @errPhoneTaken.
  ///
  /// In en, this message translates to:
  /// **'This phone number is already registered'**
  String get errPhoneTaken;
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
