// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'YordamBor';

  @override
  String get splashTagline => 'On YordamBor, help is here!';

  @override
  String get tabHome => 'Home';

  @override
  String get tabFavorites => 'Saved';

  @override
  String get tabProfile => 'Profile';

  @override
  String get filterYordamBor => 'Help here';

  @override
  String get filterYordamKerak => 'Help needed';

  @override
  String get filterCategory => 'Category';

  @override
  String get filterSubcategory => 'Subcategory';

  @override
  String get filterPickCategoryFirst => 'Select a category first';

  @override
  String get filterProviderType => 'Type';

  @override
  String get filterProviderAll => 'All types';

  @override
  String get filterProviderTypeHint => 'Choose a provider type';

  @override
  String get filterProviderAllHint => 'Individuals and organizations';

  @override
  String get filterProviderIndividualHint => 'Freelancers, tutors, specialists';

  @override
  String get filterProviderInstitutionHint => 'Clinics, studios, companies';

  @override
  String get filterAllCategories => 'All sectors';

  @override
  String get filterAllSubcategories => 'All subsectors';

  @override
  String get filterCategoryHint => 'Which field are you looking in?';

  @override
  String get filterAllCategoriesHint => 'Services across every field';

  @override
  String get filterAllSubcategoriesHint =>
      'All specialties in the selected field';

  @override
  String homeFeedShowing(String summary) {
    return 'Showing: $summary';
  }

  @override
  String get filterPickProviderTypeFirst =>
      'Select individual or organization first';

  @override
  String get homeEmptyTitle => 'Services will appear here soon';

  @override
  String get homeEmptySubtitle =>
      'Wait while service listings are added across categories';

  @override
  String get homeDemoXizmat => 'Demo services shown as examples';

  @override
  String get homeDemoPosts => 'Demo posts shown as examples';

  @override
  String get homeJobsEmptyTitle => 'Help needed posts';

  @override
  String get homeJobsEmptySubtitle =>
      'Post the first request or change filters';

  @override
  String get favoritesEmptyTitle => 'Save services you like';

  @override
  String get favoritesEmptySubtitle => 'Tap ♥ on a card';

  @override
  String get profileGuestTitle => 'Welcome to YordamBor';

  @override
  String get profileGuestSubtitle =>
      'Sign up for deals and posting. Favorites work without an account.';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profilePhotoUpdated => 'Profile photo updated';

  @override
  String get profilePhotoFailed => 'Could not upload photo';

  @override
  String get login => 'Log in';

  @override
  String get register => 'Sign up';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'No notifications yet';

  @override
  String get fabPostYordamKerak => 'Post request';

  @override
  String get welcomeTitle => 'On YordamBor, help is here!';

  @override
  String get welcomeBrand => 'YordamBor.';

  @override
  String get welcomeBody =>
      'Discover all kinds of services. Offer help or ask for help.';

  @override
  String get startBrowsing => 'Get started';

  @override
  String get createAccount => 'Create account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get authContinueTitle => 'Sign in to continue';

  @override
  String get authContextGeneric => 'Sign in to continue';

  @override
  String get authContextFavorite => 'Sign in to save favorites';

  @override
  String get authContextYordamKerak => 'Sign in to send a request';

  @override
  String get authContextYordamBor => 'Sign in to send an offer';

  @override
  String get authContextPostJob => 'Sign in to post';

  @override
  String get authContextDeal => 'Sign in to start a deal';

  @override
  String get later => 'Later';

  @override
  String get fullName => 'Full name';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidEmail => 'Enter a valid email address';

  @override
  String get invalidPhone => 'Enter a valid phone number (+998...)';

  @override
  String get invalidNumber => 'Enter a valid number';

  @override
  String get invalidMinutes => 'Enter valid minutes';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get acceptTermsRequired => 'You must accept the terms of use';

  @override
  String get acceptTerms => 'I accept the terms of use';

  @override
  String get acceptTermsLead => 'I accept the ';

  @override
  String get acceptTermsLink => 'terms of use';

  @override
  String get acceptTermsTrail => '';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetPasswordTitle => 'New password';

  @override
  String get resetPasswordBody => 'Enter and save your new password.';

  @override
  String get resetPasswordSubmit => 'Save password';

  @override
  String get resetPasswordSuccess => 'Password updated';

  @override
  String get resetPasswordSendLink => 'Send reset link';

  @override
  String resetPasswordEmailSent(String emailAddress) {
    return 'We sent a password reset link to $emailAddress.';
  }

  @override
  String get resetPasswordEmailHint =>
      'Open the link on your phone. The app will open so you can set a new password.';

  @override
  String get resetPasswordExpiredTitle => 'Link expired';

  @override
  String get resetPasswordExpiredBody => 'Request a new password reset link.';

  @override
  String get continueAction => 'Continue';

  @override
  String get verifyEmailTitle => 'Verify your email';

  @override
  String verifyEmailBody(String emailAddress) {
    return 'We sent a confirmation link to $emailAddress.';
  }

  @override
  String get verifyEmailBodyMissing =>
      'We sent a confirmation link to your email. After opening it, tap \"I confirmed\".';

  @override
  String get verifyEmailCheck => 'I confirmed';

  @override
  String get verifyEmailPending => 'Email not verified yet. Check your inbox.';

  @override
  String get openMail => 'Open mail app';

  @override
  String get resendEmail => 'Resend';

  @override
  String get continueBrowsing => 'Continue browsing';

  @override
  String welcomeBack(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get welcomeGuestName => 'friend';

  @override
  String welcomeNewTitle(String name) {
    return 'Welcome, $name!';
  }

  @override
  String get welcomeNewBody =>
      'We\'re so glad you joined YordamBor. Find services, offer help, or post a job — we\'re here for you every step of the way.';

  @override
  String welcomeLoginTitle(String name) {
    return 'Welcome back, $name!';
  }

  @override
  String get welcomeLoginBody =>
      'Great to see you again. What can we help you with today?';

  @override
  String welcomeReturnTitle(String name) {
    return 'Hello, $name!';
  }

  @override
  String get welcomeReturnBody => 'The services you need are waiting for you.';

  @override
  String get welcomeReturnBodyYordamKerak =>
      'Do your services match client needs?';

  @override
  String homeGreetingShort(String name) {
    return 'Hello, $name!';
  }

  @override
  String get homeGreetingYordamBor => 'What help do you need today?';

  @override
  String get homeGreetingYordamKerak => 'Can you help today?';

  @override
  String get providerPromptTitle => 'Do you offer services?';

  @override
  String get providerPromptBody => 'Add a portfolio — clients will find you.';

  @override
  String get createXizmat => 'Create service';

  @override
  String get signOut => 'Sign out';

  @override
  String get settings => 'Settings';

  @override
  String get settingsSubtitle => 'Language, privacy, account';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsDarkMode => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTools => 'Tools';

  @override
  String get settingsLegal => 'Legal';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get settingsPrivacySection => 'Privacy';

  @override
  String get settingsShowPhoneLabel => 'Show phone on my profile';

  @override
  String get settingsShowPhoneSubtitle =>
      'Your phone number appears on your public profile';

  @override
  String get postContactSectionTitle => 'Contact';

  @override
  String get postContactSectionSubtitle =>
      'Your profile is always public. Showing your phone number is optional.';

  @override
  String get postContactPhoneLabel => 'Phone number';

  @override
  String get postContactPhoneHint => '+998 90 123 45 67';

  @override
  String get postContactPhoneOptional => 'Optional';

  @override
  String get postShowPhoneLabel => 'Show phone number';

  @override
  String get postShowPhoneSubtitle => 'Your phone appears on this listing';

  @override
  String get postShowProfileLabel => 'Show profile';

  @override
  String get postShowProfileSubtitle =>
      'Users can view your profile from this listing';

  @override
  String get postAuthorHidden => 'Author hidden';

  @override
  String get settingsTerms => 'Terms of use';

  @override
  String get settingsDeleteAccount => 'Delete account';

  @override
  String get settingsDeleteAccountHint => 'All deals will be cancelled';

  @override
  String get settingsDeleteAccountConfirm =>
      'All your data, services, and active deals will be deleted. This cannot be undone.';

  @override
  String get settingsDeleteAccountAction => 'Delete account';

  @override
  String get settingsDeleteAccountDone => 'Account deleted';

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get remindersAdd => 'Add reminder';

  @override
  String get remindersEmptyTitle => 'No reminders';

  @override
  String get remindersEmptySubtitle =>
      'Synced with client book calendar. Also created when deals go in progress';

  @override
  String get remindersFieldClientName => 'Client name';

  @override
  String get remindersUpcoming => 'Upcoming';

  @override
  String get remindersPast => 'Past';

  @override
  String get remindersFieldTitle => 'Title';

  @override
  String get remindersFieldBody => 'Note (optional)';

  @override
  String get remindersSave => 'Save';

  @override
  String get remindersSettingsSubtitle => 'Deal and appointment reminders';

  @override
  String get legalPrivacyTitle => 'Privacy policy';

  @override
  String get legalTermsTitle => 'Terms of use';

  @override
  String get legalPrivacyBody =>
      'YordamBor uses your data only to provide services, deals, and security.\n\n1. What we collect\n\nName, email, phone, service portfolio images, deal messages, and notifications.\n\n2. Where it is stored\n\nData is stored encrypted on Supabase servers.\n\n3. Third parties\n\nWe do not sell your data. We only share with technical partners required to run the app (hosting, email).\n\n4. Your rights\n\nYou may view, update, or delete your account and data.\n\n5. Contact\n\nQuestions: use the Settings section in the app.';

  @override
  String get legalTermsBody =>
      'YordamBor is a mobile platform connecting service providers and clients across categories. Using the app means you accept these terms.\n\n1. General\n\nYordamBor does not perform services itself — it connects parties. The platform is not a payment intermediary.\n\n2. Account and registration\n\nYou must provide accurate, up-to-date information and verify your email.\n\n3. Services and portfolio\n\nEvery service listing must include at least one real portfolio photo. False, misleading, or illegal listings may be removed.\n\n4. Deals (Yordam Bor / Yordam Kerak)\n\nPrice, timing, and scope are agreed between parties. YordamBor stores the deal process but does not collect payments.\n\n5. Prohibited conduct\n\nFraud, abuse, spam, illegal services, or deliberate rule violations are not allowed.\n\n6. Account suspension\n\nYordamBor may suspend or delete accounts that violate these terms.\n\n7. Changes\n\nTerms may be updated. Continued use means acceptance of the updated terms.\n\n8. Contact\n\nQuestions: use the Settings section in the app.';

  @override
  String get shareXizmat => 'Share service';

  @override
  String shareXizmatMessage(String name) {
    return 'Check out $name on YordamBor';
  }

  @override
  String get shareYordamKerak => 'Share request';

  @override
  String shareYordamKerakMessage(String title) {
    return 'Help needed: $title on YordamBor';
  }

  @override
  String get postNotFound => 'Request not found';

  @override
  String get shareCopied => 'Link copied';

  @override
  String get languageUz => 'O\'zbek';

  @override
  String get languageRu => 'Русский';

  @override
  String get languageEn => 'English';

  @override
  String get languageZh => '中文';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionView => 'View';

  @override
  String get actionUnblock => 'Unblock';

  @override
  String get actionSubmit => 'Submit';

  @override
  String get kelishuvTitle => 'Deal';

  @override
  String get kelishuvNotFound => 'Deal not found';

  @override
  String get kelishuvMessages => 'Messages';

  @override
  String get kelishuvNoMessages => 'No messages yet';

  @override
  String get kelishuvOpeningOffer => 'Initial offer';

  @override
  String get kelishuvReject => 'Reject';

  @override
  String get kelishuvCancel => 'Cancel';

  @override
  String get kelishuvAccept => 'I accept';

  @override
  String get kelishuvComplete => 'Work completed';

  @override
  String get kelishuvEditTerms => 'Edit terms';

  @override
  String get kelishuvTermsChanged =>
      'Terms changed — both parties must confirm again';

  @override
  String get kelishuvAwaitingComplete =>
      'The other party confirmed completion — please confirm too';

  @override
  String get kelishuvPartyA => 'Party A';

  @override
  String get kelishuvPartyB => 'Party B';

  @override
  String get kelishuvCompleteA => 'A completed';

  @override
  String get kelishuvCompleteB => 'B completed';

  @override
  String get kelishuvDualAccepted => 'Both parties accepted';

  @override
  String get kelishuvCompleteTooEarly =>
      'Completion can be marked 3 days after work starts';

  @override
  String kelishuvCompleteDaysLeft(int days) {
    return '$days day(s) until completion can be marked';
  }

  @override
  String get kelishuvMessageHint => 'Write a message...';

  @override
  String get kelishuvIncoming => 'Incoming';

  @override
  String get kelishuvIncomingSub => 'Requests to your services';

  @override
  String get kelishuvRequests => 'My requests';

  @override
  String get kelishuvRequestsSub => 'Deals you started';

  @override
  String get kelishuvArchive => 'Archive';

  @override
  String get kelishuvArchiveSub => 'Closed deals';

  @override
  String get kelishuvNeedsResponse => 'Response needed';

  @override
  String get kelishuvNeedsConfirm => 'Confirm';

  @override
  String get profileBlocked => 'Blocked users';

  @override
  String get profileClientBook => 'Client book';

  @override
  String get profileClientBookSub => 'Local client list';

  @override
  String get profileEarnings => 'My earnings';

  @override
  String get profileEarningsSub => 'Self-declared income';

  @override
  String get profileMyXizmatlar => 'My services';

  @override
  String get profileSetAvailability => 'Set availability';

  @override
  String get profileSectionLoadFailed =>
      'Could not load. Check your internet connection.';

  @override
  String get actionRetry => 'Try again';

  @override
  String get clientBookTitle => 'Client book';

  @override
  String get clientBookList => 'List';

  @override
  String get clientBookCalendar => 'Calendar';

  @override
  String get clientBookOpenDeal => 'Open deal';

  @override
  String get clientBookEditClient => 'Edit client';

  @override
  String get clientBookAdd => 'Add client';

  @override
  String get clientBookBookClient => 'Book client';

  @override
  String get clientBookEditBooking => 'Edit booking';

  @override
  String get clientBookNameRequired => 'Enter client name';

  @override
  String get clientBookDateRequired => 'Pick an appointment date';

  @override
  String get clientBookNoteLabel => 'Note';

  @override
  String get clientBookEmptyTitle => 'Client book is empty';

  @override
  String get clientBookEmptySub =>
      'Book clients on the calendar or they are added when deals go in progress';

  @override
  String get clientBookDateLabel => 'Appointment date';

  @override
  String get clientBookBookDay => 'Book this day';

  @override
  String get clientBookCalendarHint => 'Tap a day to book a client';

  @override
  String get clientBookMarkComplete => 'Mark service delivered';

  @override
  String get clientBookMarkCancelled => 'Mark cancelled';

  @override
  String get clientBookMarkPending => 'Mark pending';

  @override
  String get clientBookCompleteAmount => 'Income from this client (UZS)';

  @override
  String get clientBookDeliveryCompleted => 'Delivered';

  @override
  String get clientBookDeliveryPending => 'Pending';

  @override
  String get clientBookDeliveryCancelled => 'Cancelled';

  @override
  String get clientBookNewClientOption => 'New client';

  @override
  String get clientBookSelectClient => 'Client';

  @override
  String get clientBookServiceLabel => 'Service (optional)';

  @override
  String clientBookBookingCount(int count) {
    return '$count appointments';
  }

  @override
  String get appointmentStatusUpcoming => 'Upcoming';

  @override
  String get appointmentStatusCancelled => 'Cancelled';

  @override
  String get appointmentStatusPostponed => 'Postponed';

  @override
  String get appointmentStatusIncomplete => 'Incomplete';

  @override
  String get appointmentStatusCompleted => 'Completed';

  @override
  String get kelishuvAppointmentRequiredTitle => 'Set appointment date';

  @override
  String get kelishuvAppointmentRequiredBody =>
      'Both sides approved the deal. Pick when the service will happen.';

  @override
  String get remindersSettingsFollowUpLabel =>
      'Follow-up checks (hours after appointment)';

  @override
  String get remindersFollowUpPrompt => 'Was this appointment successful?';

  @override
  String get clientBookAppointmentHistory => 'Appointment history';

  @override
  String get clientBookAppointmentNotesLabel => 'Appointment notes';

  @override
  String get clientBookPhotosLabel => 'Photos';

  @override
  String get clientBookPhotosEmpty => 'No photos yet';

  @override
  String get clientBookAddPhoto => 'Add photo';

  @override
  String clientBookClientStats(int completed, int cancelled, int upcoming) {
    return '$completed completed · $cancelled cancelled · $upcoming upcoming';
  }

  @override
  String get remindersUpdateStatus => 'Update status';

  @override
  String get remindersSettingsTitle => 'Reminder settings';

  @override
  String get remindersSettingsAlertsLabel => 'Alert times (minutes before)';

  @override
  String get remindersSettingsAtTime => 'At time';

  @override
  String get earningsTitle => 'My earnings';

  @override
  String get earningsTotal => 'Total (self-declared)';

  @override
  String get earningsEdit => 'Edit earnings';

  @override
  String get earningsAdd => 'Add earnings';

  @override
  String get earningsAmountLabel => 'Amount (UZS)';

  @override
  String get earningsNoteLabel => 'Note';

  @override
  String get earningsAmountRequired => 'Enter an amount';

  @override
  String get earningsEmptyTitle => 'No earnings records';

  @override
  String get earningsEmptySub =>
      'Added automatically for priced deals in progress';

  @override
  String get earningsDisclaimer =>
      'This is for your personal records only. Not tax or official reporting.';

  @override
  String get notificationsEmptySub => 'Deal updates will appear here';

  @override
  String get notificationKelishuvAccept => 'Deal accepted';

  @override
  String get notificationKelishuvMessage => 'New message';

  @override
  String get notificationKelishuvComplete => 'Job completed';

  @override
  String get notificationGeneric => 'Notification';

  @override
  String notificationTimeMinutes(int count) {
    return '$count min';
  }

  @override
  String notificationTimeHours(int count) {
    return '$count h';
  }

  @override
  String notificationTimeDate(int day, int month) {
    return '$day.$month';
  }

  @override
  String get reviewsTitle => 'Reviews';

  @override
  String get reviewProviderReplyLabel => 'Provider reply';

  @override
  String get reviewsEmpty => 'No reviews yet';

  @override
  String get reviewsRate => 'Rate';

  @override
  String xizmatCompletedCount(int count) {
    return '$count completed';
  }

  @override
  String get demoKelishuvBlocked => 'Cannot create deals in demo mode';

  @override
  String get genericUser => 'User';

  @override
  String get actionPick => 'Select';

  @override
  String get xizmatStepIdentity => '1/3 — Who are you?';

  @override
  String get xizmatStepPortfolio => '2/3 — Portfolio';

  @override
  String get xizmatProviderIndividual => 'Individual';

  @override
  String get xizmatProviderInstitution => 'Organization';

  @override
  String get xizmatNameLabel => 'Service name';

  @override
  String get xizmatDescriptionLabel => 'Short description';

  @override
  String get xizmatDescriptionFull => 'Description';

  @override
  String get xizmatServiceCityLabel => 'City you serve';

  @override
  String get xizmatServiceCityHint => 'e.g. Tashkent (optional)';

  @override
  String get xizmatContinue => 'Continue';

  @override
  String get xizmatPortfolioHint =>
      'At least 1 image required. First image is the cover.';

  @override
  String get xizmatHeroLabel => 'Cover';

  @override
  String get xizmatUploading => 'Uploading…';

  @override
  String get xizmatReady => 'Ready';

  @override
  String get xizmatBack => 'Back';

  @override
  String get xizmatSuccessTitle => 'Your service is ready!';

  @override
  String get xizmatSuccessBody =>
      'Portfolio uploaded. Clients can now find you in Discover.';

  @override
  String get xizmatEditTitle => 'Edit service';

  @override
  String get cannotRequestOwnXizmat =>
      'You can\'t send a request to your own service';

  @override
  String get xizmatNotFound => 'Service not found';

  @override
  String get xizmatNoPermission => 'No permission';

  @override
  String get xizmatBasicInfo => 'Basic info';

  @override
  String get xizmatPortfolio => 'Portfolio';

  @override
  String get xizmatPortfolioEmpty =>
      'Portfolio is empty. At least one image required.';

  @override
  String get xizmatAddPhoto => 'Add photo';

  @override
  String get xizmatSetHero => 'Set as cover';

  @override
  String get xizmatAnalytics => 'Analytics';

  @override
  String get xizmatReviewReplies => 'Review replies';

  @override
  String get xizmatSaved => 'Saved';

  @override
  String get xizmatReplySaved => 'Reply saved';

  @override
  String get xizmatPickCategoryError => 'Select category and subcategory';

  @override
  String get yordamKerakPostTitle => 'Help needed post';

  @override
  String get yordamKerakTitleLabel => 'Title';

  @override
  String get yordamKerakTitleHint => 'e.g. Plumber needed';

  @override
  String get yordamKerakMessageLabel => 'Project description';

  @override
  String get yordamKerakMessageHint =>
      'What needs to be done, where, and when?';

  @override
  String get yordamKerakBudgetLabel => 'Budget (optional, UZS)';

  @override
  String get yordamKerakDateLabel => 'Preferred date (optional)';

  @override
  String get yordamKerakDurationLabel => 'Duration (minutes, optional)';

  @override
  String get yordamKerakPublish => 'Publish';

  @override
  String get yordamKerakTitleTooShort => 'Title must be at least 3 characters';

  @override
  String get yordamKerakMessageTooShort =>
      'Description must be at least 10 characters';

  @override
  String get yordamKerakCategoryRequired => 'Select a category';

  @override
  String get yordamKerakSubcategoryRequired => 'Select a subcategory';

  @override
  String get userProfileTitle => 'Profile';

  @override
  String get userProfileNotFound => 'Profile not found';

  @override
  String get userProfileServices => 'Services';

  @override
  String get userProfileServicesEmpty => 'No services yet';

  @override
  String get userProfileRequests => 'Help needed posts';

  @override
  String get userProfileRequestsEmpty => 'No open posts';

  @override
  String get userProfileAvailable => 'Available';

  @override
  String get userProfileBusy => 'Unavailable';

  @override
  String get userProfilePartiallyBusy => 'Partially unavailable';

  @override
  String get userProfileCall => 'Call';

  @override
  String get userProfilePhoneHidden => 'Phone number is hidden';

  @override
  String get userProfileViewProfile => 'View profile';

  @override
  String get xizmatProviderSection => 'Service provider';

  @override
  String get profileViewPublic => 'My public profile';

  @override
  String get profileCertificatesTitle => 'Certificates & credentials';

  @override
  String get profileCertificatesSubtitle =>
      'Upload credentials so clients can review them';

  @override
  String get profileCertificatesDisclaimer =>
      'YordamBor does not verify uploaded documents. Clients should confirm credentials themselves.';

  @override
  String get profileCertificatesAdd => 'Add certificate';

  @override
  String get profileCertificatesTitleLabel => 'Title';

  @override
  String get profileCertificatesTitleHint => 'e.g. Plumbing course certificate';

  @override
  String get profileCertificatesIssuerLabel => 'Issuer (optional)';

  @override
  String get profileCertificatesIssuerHint => 'e.g. Training center name';

  @override
  String get profileCertificatesEmpty => 'No certificates uploaded yet';

  @override
  String get profileCertificatesMaxReached => 'Maximum 8 certificates';

  @override
  String get profileCertificatesAdded => 'Certificate added';

  @override
  String get profileCertificatesRemoved => 'Certificate removed';

  @override
  String get profileCertificatesRemoveTitle => 'Remove certificate?';

  @override
  String get xizmatOtherServices => 'Other services';

  @override
  String get xizmatViewAllServices => 'View all services';

  @override
  String get xizmatStatusAvailable => 'Available';

  @override
  String get xizmatStatusBusy => 'Unavailable';

  @override
  String get safetyTitle => 'Safety';

  @override
  String get safetyBlock => 'Block';

  @override
  String safetyBlockConfirmMessage(String name) {
    return 'Block $name? Their content will be hidden.';
  }

  @override
  String get safetyBlockDone => 'User blocked';

  @override
  String get safetyHideUser => 'Hide user';

  @override
  String get safetyReportReason => 'Report reason (optional)';

  @override
  String get safetyReportHint => 'What happened?';

  @override
  String get safetyReportSubmit => 'Submit report';

  @override
  String get safetyReportDone => 'Report submitted. Thank you.';

  @override
  String get reviewLater => 'Later';

  @override
  String get blockedUnblocked => 'Unblocked';

  @override
  String kelishuvMoreCount(int count) {
    return '$count more';
  }

  @override
  String get demoPostPickReal => 'Demo post — pick a real one';

  @override
  String get createXizmatFirst => 'Create your service profile first';

  @override
  String get pickXizmat => 'Pick a service';

  @override
  String get categoryPickTitle => 'Pick category';

  @override
  String get categoryAll => 'All categories';

  @override
  String get subcategoryAll => 'All subcategories';

  @override
  String get analyticsViews => 'Views';

  @override
  String get analyticsFavorites => 'Saved';

  @override
  String get analyticsActiveDeals => 'Active deals';

  @override
  String get analyticsCompletedDeals => 'Completed';

  @override
  String analyticsConversion(String rate) {
    return 'Conversion: $rate%';
  }

  @override
  String get kelishuvArchiveEmptyTitle => 'Archive is empty';

  @override
  String get kelishuvArchiveEmptySub =>
      'Completed or cancelled deals appear here';

  @override
  String get kelishuvStatusNegotiating => 'Negotiating';

  @override
  String get kelishuvStatusInProgress => 'In progress';

  @override
  String get kelishuvStatusCompleted => 'Completed';

  @override
  String get kelishuvStatusCancelled => 'Cancelled';

  @override
  String get kelishuvStatusRejected => 'Rejected';

  @override
  String get kelishuvStatusArchived => 'Archived';

  @override
  String get busySlotTitle => 'Busy time';

  @override
  String busySlotMessage(String names) {
    return 'You have an appointment on this date: $names. Continue anyway?';
  }

  @override
  String taklifFlowTitleYordamBor(String name) {
    return 'Help here — $name';
  }

  @override
  String taklifFlowTitleYordamKerak(String name) {
    return 'Help needed — $name';
  }

  @override
  String get taklifTitle => 'Send offer';

  @override
  String get repeatBook => 'Book again';

  @override
  String get repeatBookTitle => 'Book again';

  @override
  String get taklifSubtitle =>
      'Send your message and price at the start. Work begins after both parties accept.';

  @override
  String get taklifMessageLabel => 'Message';

  @override
  String get taklifMessageHint => 'How can you help?';

  @override
  String get taklifPriceLabel => 'Price (optional, UZS)';

  @override
  String get taklifDateLabel => 'Pick date (optional)';

  @override
  String get taklifDurationLabel => 'Duration (minutes, optional)';

  @override
  String get taklifSubmit => 'Send offer';

  @override
  String get reviewCommentLabel => 'Comment (optional)';

  @override
  String get reviewCommentHint => 'How was your experience?';

  @override
  String get xizmatReplyLabel => 'Your reply';

  @override
  String get xizmatReplyHint => 'Reply to the client';

  @override
  String get xizmatClientLabel => 'Client';

  @override
  String get kelishuvTermsDateLabel => 'Pick date';

  @override
  String get kelishuvTermsMessageLabel => 'Message';

  @override
  String get kelishuvTermsPriceLabel => 'Price (UZS)';

  @override
  String kelishuvDetailPost(String title) {
    return 'Post: $title';
  }

  @override
  String kelishuvDetailPrice(String amount, String currency) {
    return 'Price: $amount $currency';
  }

  @override
  String kelishuvDetailTime(String slot) {
    return 'Time: $slot';
  }

  @override
  String kelishuvSlotDateDuration(String date, int minutes) {
    return '$date · $minutes min';
  }

  @override
  String get xizmatPricingSectionTitle => 'Pricing';

  @override
  String get xizmatPricingSectionSubtitle =>
      'Choose negotiable, fixed, or hourly — it\'s up to you.';

  @override
  String get xizmatPricingNegotiable => 'Negotiable';

  @override
  String get xizmatPricingFixed => 'Fixed';

  @override
  String get xizmatPricingHourly => 'Hourly';

  @override
  String get xizmatPricingFixedRateLabel => 'Price (UZS)';

  @override
  String get xizmatPricingHourlyRateLabel => 'Hourly rate (UZS)';

  @override
  String get xizmatPricingRateHint => 'e.g. 150000';

  @override
  String get xizmatPricingMinDurationLabel =>
      'Minimum duration (minutes, optional)';

  @override
  String get xizmatPricingMinDurationHint => 'e.g. 120';

  @override
  String get xizmatPricingRequiredError =>
      'Enter a price for fixed or hourly pricing';

  @override
  String get xizmatPriceNegotiable => 'Price negotiable';

  @override
  String xizmatPricePerHour(String amount) {
    return '$amount/hr';
  }

  @override
  String get xizmatAvailabilitySectionTitle => 'Availability';

  @override
  String get xizmatAvailabilitySectionSubtitle =>
      'Optional — let clients know if you\'re free. Client Book does not change this.';

  @override
  String get xizmatAvailabilityShowLabel => 'Show availability';

  @override
  String get xizmatAvailabilityShowSubtitle =>
      'When off, no status badge is shown';

  @override
  String get xizmatAvailabilityAvailableNow => 'Available now';

  @override
  String get xizmatAvailabilityBusy => 'Unavailable';

  @override
  String get xizmatAvailabilityCallMe => 'Call to book';

  @override
  String get xizmatAvailabilityFromLabel => 'From (optional)';

  @override
  String get xizmatAvailabilityUntilLabel => 'Until (optional)';

  @override
  String xizmatAvailabilityUntilSuffix(String time) {
    return ' · until $time';
  }

  @override
  String xizmatAvailabilityFromSuffix(String time) {
    return ' · from $time';
  }

  @override
  String xizmatAvailabilityRangeSuffix(String from, String until) {
    return ' · $from–$until';
  }

  @override
  String get xizmatAvailabilityModeRequiredError => 'Pick an availability mode';

  @override
  String get xizmatAvailabilityWindowInvalidError =>
      'End time must be after start time';

  @override
  String get xizmatPromiseSectionTitle => 'Your promise';

  @override
  String get xizmatPromiseSectionSubtitle =>
      'Tell clients what you stand for. This is your motto — not a YordamBor warranty.';

  @override
  String get xizmatPromiseShowLabel => 'Show my promise';

  @override
  String get xizmatPromiseShowSubtitle =>
      'Displayed on your listing for clients to read';

  @override
  String get xizmatPromisePresetsLabel => 'Quick presets (editable)';

  @override
  String get xizmatPromiseFieldLabel => 'Your promise';

  @override
  String get xizmatPromiseFieldHint => 'Write your own or edit a preset';

  @override
  String get xizmatPromisePreset1 =>
      'If you\'re not satisfied, I\'ll redo the work';

  @override
  String get xizmatPromisePreset2 =>
      'Quality guaranteed — if there\'s a problem, I\'ll refund you';

  @override
  String get xizmatPromisePreset3 => 'On time and at the agreed price';

  @override
  String get xizmatPromiseDisclaimer =>
      'YordamBor does not provide warranties. This is the provider\'s own statement.';

  @override
  String get xizmatPromiseRequiredError =>
      'Enter your promise or turn this off';

  @override
  String get xizmatPromiseTooLongError => 'Promise is too long';

  @override
  String get settingsHelp => 'Help & support';

  @override
  String get supportReportTitle => 'Report a problem';

  @override
  String get supportReportSubtitle => 'Bug, account, or payment concern';

  @override
  String get supportCategoryLabelField => 'Category';

  @override
  String get supportCategoryBug => 'Bug';

  @override
  String get supportCategoryAccount => 'Account';

  @override
  String get supportCategoryPayment => 'Payment concern';

  @override
  String get supportCategoryOther => 'Other';

  @override
  String get supportDescriptionLabel => 'Description';

  @override
  String get supportDescriptionHint => 'Describe what happened…';

  @override
  String get supportSubmit => 'Submit';

  @override
  String get supportSubmitted => 'Thank you — we received your report';

  @override
  String get supportLoginRequired => 'Sign in to report a problem';

  @override
  String get supportContactHint => 'Support email: eeshbaev@outlook.com';

  @override
  String get supportMailtoFailed => 'Could not open email app';

  @override
  String get feedbackTitle => 'Send feedback';

  @override
  String get feedbackSubtitle => 'Help us improve YordamBor';

  @override
  String get feedbackMessageLabel => 'Your feedback';

  @override
  String get feedbackMessageHint => 'What could be better?';

  @override
  String get feedbackSubmit => 'Send feedback';

  @override
  String get feedbackThanks => 'Thank you for your feedback';

  @override
  String get feedbackOpenFromSheet => 'Use Help & support to send feedback.';

  @override
  String get appReviewTitle => 'Enjoying YordamBor?';

  @override
  String get appReviewSubtitle =>
      'Your rating helps other users find trusted providers.';

  @override
  String get appReviewYes => 'Yes, love it';

  @override
  String get appReviewNo => 'Not really';

  @override
  String get appReviewLater => 'Not now';

  @override
  String get providerProgressTitle => 'Your progress';

  @override
  String get providerProgressSubtitle => 'Build your reputation step by step';

  @override
  String get providerTierNew => 'New';

  @override
  String get providerTierActive => 'Active';

  @override
  String get providerTierTrusted => 'Trusted';

  @override
  String get providerTierTop => 'Top provider';

  @override
  String providerJobsRating(int jobs, String rating) {
    return '$jobs jobs · $rating★';
  }

  @override
  String providerNextMilestone(int count, String tier) {
    return '$count more jobs → $tier';
  }

  @override
  String get providerTipsTitle => 'Next steps';

  @override
  String get progressTipAddCertificate => 'Add a certificate to build trust';

  @override
  String get progressTipSetAvailability => 'Set availability on your listing';

  @override
  String get progressTipReplyReviews => 'Reply to client reviews';

  @override
  String get progressTipAddPortfolio => 'Add more portfolio photos';

  @override
  String get progressTipSetPricing => 'Set fixed or hourly pricing';

  @override
  String get progressTipRepeatClients => 'Ask happy clients to book again';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get achievementsEmptySub =>
      'No achievements yet. Complete jobs and grow your profile to earn badges.';

  @override
  String get achievementFirstXizmat => 'First service listed';

  @override
  String get achievementFirstDeal => 'First completed job';

  @override
  String get achievementJobs5 => '5 jobs completed';

  @override
  String get achievementJobs10 => '10 jobs completed';

  @override
  String get achievementJobs25 => '25 jobs completed';

  @override
  String get achievementFirstFiveStar => 'First 5★ review';

  @override
  String get achievementCertificate => 'Certificate uploaded';

  @override
  String get achievementRepeatClient => 'Loyal client (3+ jobs)';

  @override
  String get achievementBodyFirstXizmat =>
      'You listed your first service on YordamBor.';

  @override
  String get achievementBodyFirstDeal =>
      'You completed your first deal. Keep going!';

  @override
  String get achievementBodyJobs5 => 'Five jobs done — clients are noticing.';

  @override
  String get achievementBodyJobs10 =>
      'Ten completed jobs. You\'re building a real reputation.';

  @override
  String get achievementBodyJobs25 =>
      'Twenty-five jobs. Top-tier providers start here.';

  @override
  String get achievementBodyFirstFiveStar =>
      'A client gave you 5 stars. Well deserved!';

  @override
  String get achievementBodyCertificate =>
      'Your credentials are visible on your profile.';

  @override
  String get achievementBodyRepeatClient =>
      'A client booked you three times or more.';

  @override
  String get actionContinue => 'Continue';

  @override
  String get guidesTitle => 'Business tips';

  @override
  String get guidesSubtitle => 'Grow your service step by step';

  @override
  String get guideXizmatConvertsTitle => 'Create a listing that converts';

  @override
  String get guidePricingTitle => 'Pricing: fixed vs hourly';

  @override
  String get guideRepeatClientsTitle => 'Get repeat bookings';

  @override
  String get guideCertificatesTitle => 'Certificates & trust';

  @override
  String get guideReviewRepliesTitle => 'Reply to reviews professionally';

  @override
  String get guideXizmatConvertsBody =>
      'Use a clear title, real portfolio photos, and your subcategory. Show pricing or say negotiable. Add availability so clients know when you can work.';

  @override
  String get guidePricingBody =>
      'Fixed price works for predictable jobs. Hourly fits cleaning, tutoring, and care. Negotiable is fine — but a starting price gets more messages.';

  @override
  String get guideRepeatClientsBody =>
      'Do great work, reply quickly, and ask happy clients to use Book again after a completed deal. Repeat clients trust you already.';

  @override
  String get guideCertificatesBody =>
      'Upload credentials clients can review. YordamBor does not verify documents — they help clients decide, not guarantee quality.';

  @override
  String get guideReviewRepliesBody =>
      'Reply politely to every review. Thank clients for 5★ feedback. For criticism, stay professional — future clients read your replies.';

  @override
  String get safetyPaymentsBanner =>
      'Pay only as agreed with the provider. YordamBor does not handle money and is not responsible for off-platform payments.';

  @override
  String get settingsSafety => 'Safety & payments';

  @override
  String get legalSafetyTitle => 'Safety & payments';

  @override
  String get legalSafetyBody =>
      'YordamBor connects clients and providers. It does not perform services, hold money, or guarantee outcomes.\n\nPayments\n\nAll payments are agreed directly between you and the other party. Never send full payment upfront to someone you do not trust. Meet in person when possible. YordamBor is not responsible for fraud, poor service, or disputes about money paid outside the app.\n\nYour responsibility\n\nVerify credentials, reviews, and certificates yourself. Use completed deals and reviews to judge providers.\n\nReporting\n\nReport abuse in the app. For product issues, use Help & support.';
}
