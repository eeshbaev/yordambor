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
  String get tabCalendar => 'Calendar';

  @override
  String get calendarGuestSubtitle =>
      'Sign in to see your schedule and mark availability.';

  @override
  String get calendarProviderHint =>
      'Tap a day on the calendar, then use the button below to mark available or busy.';

  @override
  String get calendarClientHint =>
      'Your appointments and reminders appear on the calendar. Tap a day for details.';

  @override
  String get calendarLegendAvailable => 'Available';

  @override
  String get calendarLegendBusy => 'Busy';

  @override
  String get calendarLegendAppointment => 'Appointment';

  @override
  String get calendarMarkAvailable => 'Marked: available — tap to change';

  @override
  String get calendarMarkBusy => 'Marked: busy — tap to change';

  @override
  String get calendarMarkUnset => 'Mark day: available / busy';

  @override
  String get calendarNoEventsDay => 'No appointments on this day.';

  @override
  String get calendarWeekdayMon => 'Mon';

  @override
  String get calendarWeekdayTue => 'Tue';

  @override
  String get calendarWeekdayWed => 'Wed';

  @override
  String get calendarWeekdayThu => 'Thu';

  @override
  String get calendarWeekdayFri => 'Fri';

  @override
  String get calendarWeekdaySat => 'Sat';

  @override
  String get calendarWeekdaySun => 'Sun';

  @override
  String get tabFavorites => 'Saved';

  @override
  String get tabBusiness => 'Business';

  @override
  String get businessTabServices => 'Services';

  @override
  String get businessTabTools => 'Tools';

  @override
  String get businessToolsSubtitle =>
      'Client book, receipts, earnings, and other provider tools.';

  @override
  String get myXizmatlarGuestSubtitle =>
      'Sign in to manage your services and provider tools.';

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
  String get filterCity => 'City';

  @override
  String get filterAllCities => 'All cities';

  @override
  String get filterCityHint => 'Where do you need the service?';

  @override
  String get filterAllCitiesHint => 'Listings in every city';

  @override
  String get xizmatServiceCityRequired =>
      'Select the city where you provide this service';

  @override
  String get serviceCityToshkent => 'Tashkent';

  @override
  String get serviceCityToshkentViloyati => 'Tashkent region';

  @override
  String get serviceCitySamarqand => 'Samarkand';

  @override
  String get serviceCityBuxoro => 'Bukhara';

  @override
  String get serviceCityNukus => 'Nukus';

  @override
  String get serviceCityNamangan => 'Namangan';

  @override
  String get serviceCityAndijon => 'Andijan';

  @override
  String get serviceCityFargona => 'Fergana';

  @override
  String get serviceCityQarshi => 'Qarshi';

  @override
  String get serviceCityUrganch => 'Urgench';

  @override
  String get serviceCityTermiz => 'Termiz';

  @override
  String get serviceCityJizzax => 'Jizzakh';

  @override
  String get serviceCityNavoiy => 'Navoi';

  @override
  String get serviceCityQoqon => 'Kokand';

  @override
  String get serviceCityGuliston => 'Gulistan';

  @override
  String get serviceCityBoshqa => 'Other';

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
  String get invalidPhone => 'Enter a valid phone number (+998…)';

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
      'We sent a confirmation link to your email. After opening it, tap “I confirmed”.';

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
      'We’re so glad you joined YordamBor. Find services, offer help, or post a job — we’re here for you every step of the way.';

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
  String get languageUz => 'Oʻzbek';

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
  String get kelishuvMessageHint => 'Write a message…';

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
  String get profileMargin => 'Margin';

  @override
  String get profileMarginSub => 'Cost & profit';

  @override
  String get profilePaymentReceipt => 'Payment receipt';

  @override
  String get profilePaymentReceiptSub => 'PDF receipts for your services';

  @override
  String get receiptTitle => 'Payment receipts';

  @override
  String get receiptNew => 'New receipt';

  @override
  String get receiptEmptyTitle => 'No receipts yet';

  @override
  String get receiptEmptySubtitle =>
      'Create a payment receipt for a client and share it as PDF.';

  @override
  String get receiptDocumentTitle => 'PAYMENT RECEIPT';

  @override
  String get receiptNumber => 'No.';

  @override
  String get receiptDate => 'Date';

  @override
  String get receiptSeller => 'From';

  @override
  String get receiptBuyer => 'To';

  @override
  String get receiptBuyerName => 'Client name';

  @override
  String get receiptBuyerPhone => 'Client phone';

  @override
  String get receiptPickClient => 'Pick from client book';

  @override
  String get receiptXizmat => 'Service';

  @override
  String get receiptLines => 'Line items';

  @override
  String get receiptLineTitle => 'Description';

  @override
  String get receiptQuantity => 'Qty';

  @override
  String get receiptUnitPrice => 'Price';

  @override
  String get receiptLineTotal => 'Amount';

  @override
  String get receiptAddLine => 'Add line';

  @override
  String get receiptDiscount => 'Discount';

  @override
  String get receiptTaxEnable => 'Add tax';

  @override
  String get receiptTaxRate => 'Tax rate (%)';

  @override
  String get receiptTaxLabel => 'Tax label';

  @override
  String get receiptTaxDisclaimer =>
      'You choose the tax rate. YordamBor does not provide tax advice.';

  @override
  String get receiptSubtotal => 'Subtotal';

  @override
  String get receiptTotal => 'Total';

  @override
  String get receiptNote => 'Note';

  @override
  String get receiptDueDate => 'Payment due';

  @override
  String get receiptCurrency => 'Currency';

  @override
  String get receiptCurrencyUzs => 'UZS';

  @override
  String get receiptCurrencyUsd => 'USD';

  @override
  String get receiptSharePdf => 'Share PDF';

  @override
  String get receiptPreview => 'Preview PDF';

  @override
  String get receiptSaved => 'Receipt saved';

  @override
  String get receiptValidationBuyer => 'Enter client name';

  @override
  String get receiptValidationXizmat => 'Select a service';

  @override
  String get receiptValidationLines =>
      'Add at least one line item with a price';

  @override
  String get receiptFooterBranding => 'Created with YordamBor';

  @override
  String get receiptDeleteConfirm => 'Delete this receipt?';

  @override
  String get receiptTaxPresetCustom => 'Custom';

  @override
  String get marginTitle => 'Margin';

  @override
  String get marginUnitsTitle => 'Unit library';

  @override
  String get marginUnitsSubtitle =>
      'Reusable units with a cost for quick product math';

  @override
  String get marginOpenUnits => 'Unit library';

  @override
  String get marginAddUnit => 'Add unit';

  @override
  String get marginEditUnit => 'Edit unit';

  @override
  String get marginUnitName => 'Unit name';

  @override
  String get marginUnitCost => 'Cost per unit (UZS)';

  @override
  String get marginUnitBasis => 'Cost basis (optional)';

  @override
  String get marginUnitBasisHint => 'e.g. per hour, per kg, per item';

  @override
  String get marginUnitsEmptyTitle => 'No units yet';

  @override
  String get marginUnitsEmptySub =>
      'Save units you use often — labor, materials, packaging — with a cost.';

  @override
  String get marginAddProduct => 'Add product';

  @override
  String get marginEditProduct => 'Edit product';

  @override
  String get marginProductName => 'Product name';

  @override
  String get marginSalePrice => 'Sale price (UZS)';

  @override
  String get marginCostTotal => 'Total cost';

  @override
  String get marginProfit => 'Profit';

  @override
  String get marginMarginPercent => 'Margin';

  @override
  String get marginCostBreakdown => 'Cost breakdown';

  @override
  String get marginAddLine => 'Add unit line';

  @override
  String get marginEditLine => 'Edit unit line';

  @override
  String get marginLineName => 'Unit / item name';

  @override
  String get marginLineQuantity => 'Quantity';

  @override
  String get marginLineUnitCost => 'Cost per unit (UZS)';

  @override
  String get marginLineQuantityLabel => 'Quantity label (optional)';

  @override
  String get marginLineQuantityLabelHint => 'e.g. hr, kg, pc';

  @override
  String get marginSelectUnit => 'Pick from library';

  @override
  String get marginCustomLine => 'Custom line';

  @override
  String get marginProductsEmptyTitle => 'No products yet';

  @override
  String get marginProductsEmptySub =>
      'Add a product or service to see cost, profit, and margin.';

  @override
  String get marginNameRequired => 'Enter a name';

  @override
  String get marginPriceRequired => 'Enter a sale price';

  @override
  String get marginCostRequired => 'Enter a cost';

  @override
  String get marginQuantityRequired => 'Enter a quantity';

  @override
  String get marginAvgMargin => 'Average margin';

  @override
  String get marginPerProduct => 'per product';

  @override
  String get marginDeleteProduct => 'Delete product';

  @override
  String get marginDeleteUnit => 'Delete unit';

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
  String get notificationSubsectorNewService =>
      'New service in your sub-sector';

  @override
  String get notificationSubsectorDiscount => 'Price drop in your sub-sector';

  @override
  String get notificationSubsectorHelpPost => 'Help needed in your sub-sector';

  @override
  String get notificationAlertsTitle => 'Sub-sector alerts';

  @override
  String get notificationAlertsSubtitle =>
      'Get notified when services appear, prices drop, or someone needs help.';

  @override
  String get notificationAlertsAdd => 'Add alert';

  @override
  String get notificationAlertsEmpty => 'No sub-sector alerts yet';

  @override
  String get notificationAlertNewService => 'New services';

  @override
  String get notificationAlertDiscount => 'Price drops';

  @override
  String get notificationAlertHelpPost => 'Help requests (Yordam kerak)';

  @override
  String get notificationAlertSeekerHint =>
      'When you are looking for a service';

  @override
  String get notificationAlertProviderHint =>
      'When you can offer help as a provider';

  @override
  String get notificationAlertsSaved => 'Alert saved';

  @override
  String get notificationAlertsRemoved => 'Alert removed';

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
  String get demoKelishuvSimulatedNote =>
      'Demo deal — not saved on the server. The demo provider is shown as having received your offer.';

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
  String get xizmatServiceCityHint => 'Choose where you provide this service';

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
      'You can’t send a request to your own service';

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
      'Clients write sooner when they can see the price.';

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
  String get xizmatPricingRequiredError => 'Enter the amount';

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
      'Optional — let clients know if you’re free. Client Book does not change this.';

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
  String get xizmatAvailabilityCallMe => 'By appointment';

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
      'If you’re not satisfied, I’ll redo the work';

  @override
  String get xizmatPromisePreset2 =>
      'Quality guaranteed — if there’s a problem, I’ll refund you';

  @override
  String get xizmatPromisePreset3 => 'On time and at the agreed price';

  @override
  String get xizmatPromiseDisclaimer =>
      'YordamBor does not provide warranties. This is the provider’s own statement.';

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
      'Ten completed jobs. You’re building a real reputation.';

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

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get greetingNight => 'Hello';

  @override
  String get greetingWelcomeBack => 'Welcome back';

  @override
  String get greetingWelcomeNew => 'Welcome';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String homeFactAwaitingReply(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deals are waiting for your reply',
      one: '$count deal is waiting for your reply',
    );
    return '$_temp0';
  }

  @override
  String homeFactInProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deals in progress',
      one: '$count deal in progress',
    );
    return '$_temp0';
  }

  @override
  String get homeFactNewMember => 'Ask for help or offer a service to begin';

  @override
  String get continueYourTurn => 'Your turn';

  @override
  String get continueReplyToDeal => 'Review the terms and reply';

  @override
  String get continueInProgress => 'In progress';

  @override
  String get continueMarkDone => 'Confirm when the job is done';

  @override
  String get continueDraftTitle => 'Unfinished request';

  @override
  String get continueDraftUntitled => 'Untitled request';

  @override
  String get continueDraftHint => 'Pick up where you left off';

  @override
  String get draftDelete => 'Delete draft';

  @override
  String get draftDeleted => 'Draft deleted';

  @override
  String get draftRestored => 'Draft restored';

  @override
  String get draftStartOver => 'Start over';

  @override
  String get actionUndo => 'Undo';

  @override
  String get quickAskHelp => 'Ask for help';

  @override
  String get quickOfferService => 'Offer a service';

  @override
  String get feedEndTitle => 'You’re all caught up';

  @override
  String get feedEndAskPrompt => 'Didn’t find the right person?';

  @override
  String get feedEndJobsHint => 'New requests appear here first';

  @override
  String get whatsNewTitle => 'What’s new';

  @override
  String get whatsNewLookTitle => 'A cleaner, calmer look';

  @override
  String get whatsNewLookBody =>
      'New type, colors and icons that are easier to read.';

  @override
  String get whatsNewNextStepTitle => 'Your next step, on Home';

  @override
  String get whatsNewNextStepBody =>
      'Deals waiting for you and unfinished requests now come first.';

  @override
  String get whatsNewDraftsTitle => 'Drafts save themselves';

  @override
  String get whatsNewDraftsBody =>
      'Close a request halfway and finish it later.';

  @override
  String get whatsNewDone => 'Got it';

  @override
  String get xizmatCardNew => 'New';

  @override
  String get favoriteAdd => 'Save';

  @override
  String get favoriteRemove => 'Remove from saved';

  @override
  String statJobsDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'jobs done',
      one: 'job done',
    );
    return '$_temp0';
  }

  @override
  String get statRating => 'rating';

  @override
  String get dealBondYou => 'You';

  @override
  String get dealBondYourTurn => 'Your turn: review the terms and accept';

  @override
  String dealBondWaiting(String name) {
    return 'Waiting for $name to reply';
  }

  @override
  String get dealBondAgreed => 'Agreed · the work is under way';

  @override
  String get dealBondDone => 'Done · thank you both';

  @override
  String get dealBondClosed => 'This deal is closed';

  @override
  String get undoDeleted => 'Deleted';

  @override
  String get savedRemoved => 'Removed from saved';

  @override
  String get yordamKerakTitleRequired => 'Write a short title';

  @override
  String get yordamKerakMessageRequired => 'Describe what you need';

  @override
  String get stateErrorTitle => 'Couldn’t load this';

  @override
  String get stateErrorBody => 'Check your connection and try again.';

  @override
  String get stateOfflineBanner => 'No internet. Showing saved results.';

  @override
  String get disabledHintServiceName => 'Add a name of at least 2 letters';

  @override
  String get disabledHintServiceCity => 'Choose the city you work in';

  @override
  String get disabledHintServicePhoto => 'Add at least one photo to publish';

  @override
  String get disabledHintPickSubcategory => 'Choose a speciality first';

  @override
  String get disabledHintOneAlert => 'Turn on at least one alert';

  @override
  String get milestoneOverline => 'New milestone';

  @override
  String get milestoneDismiss => 'Dismiss';

  @override
  String get notificationsTooltip => 'Notifications';

  @override
  String a11yRating(String rating) {
    return 'rated $rating';
  }

  @override
  String get a11yNewProvider => 'new on YordamBor';

  @override
  String get filtersClear => 'Clear filters';

  @override
  String get actionClose => 'Close';

  @override
  String get actionMore => 'More options';

  @override
  String get actionSend => 'Send';

  @override
  String get actionPreviousMonth => 'Previous month';

  @override
  String get actionNextMonth => 'Next month';

  @override
  String get a11yShowPassword => 'Show password';

  @override
  String get a11yHidePassword => 'Hide password';

  @override
  String a11yStarRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stars',
      one: '1 star',
    );
    return '$_temp0';
  }

  @override
  String get detailPaneEmptyTitle => 'Pick a card';

  @override
  String get detailPaneEmptyBody => 'It opens here, beside the list.';

  @override
  String get taklifAskHint => 'What help do you need?';

  @override
  String get taklifAskSubtitle =>
      'Describe the job and, if you like, your budget. Work starts once you both agree.';

  @override
  String get taklifAskSubmit => 'Send request';

  @override
  String dealOfferAutoCancel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'Cancelled automatically if there’s no reply in $_temp0';
  }

  @override
  String dealOfferReplyWithin(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'Reply within $_temp0, or the offer is cancelled';
  }

  @override
  String get dealAcceptedRow => 'Accepted the terms';

  @override
  String get dealCompletedRow => 'Confirmed the work is done';

  @override
  String get dealWithdrawOffer => 'Withdraw offer';

  @override
  String get dealWithdrawTitle => 'Withdraw your offer?';

  @override
  String get dealWithdrawBody =>
      'The deal is cancelled. You can send a new offer later.';

  @override
  String get dealChatOpensOnReply => 'The chat opens once they reply.';

  @override
  String get dealRejectTitle => 'Decline this offer?';

  @override
  String get dealRejectBody =>
      'Add a reason if you like — it stays visible in the deal.';

  @override
  String get dealRejectCommentLabel => 'Comment (optional)';

  @override
  String get dealSendNewOffer => 'Send a new offer';

  @override
  String get dealClosedNewOfferHint =>
      'Still need this service? Send a new offer and the discussion starts afresh.';

  @override
  String get archiveTabNeeded => 'Needed help';

  @override
  String get archiveTabProvided => 'Provided help';

  @override
  String get archiveNeededEmpty =>
      'Deals where you asked for help will appear here.';

  @override
  String get archiveProvidedEmpty =>
      'Deals where you helped someone will appear here.';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked of $total unlocked';
  }

  @override
  String get achievementsShow => 'Show all';

  @override
  String get achievementsHide => 'Hide';

  @override
  String get yordamKerakCityRequired => 'Select a city';

  @override
  String get taklifContactTitle => 'Your contact details';

  @override
  String get taklifContactNote =>
      'The other side sees these in the deal, to reach you.';

  @override
  String get taklifFirstNameLabel => 'First name';

  @override
  String get taklifLastNameLabel => 'Family name';

  @override
  String get taklifFirstNameRequired => 'Enter your first name';

  @override
  String get taklifPhoneRequired => 'Enter your phone number';

  @override
  String get taklifMessageOptionalLabel => 'Message (optional)';

  @override
  String get dealContactTitle => 'Contact details';

  @override
  String get dealContactSent => 'You shared your contact details';

  @override
  String get dealsSectionTitle => 'Your deals';

  @override
  String get dealStateYourTurn => 'In discussion · your turn';

  @override
  String get dealStateSent => 'Sent · waiting for a reply';

  @override
  String get dealStateInProgress => 'Accepted · under way';

  @override
  String get dealStateAwaitingConfirm =>
      'Done on your side · waiting for confirmation';

  @override
  String get actionAdd => 'Add';

  @override
  String get businessEarningsTitle => 'Earned this month';

  @override
  String get businessEarningsSee => 'See earnings';

  @override
  String get businessStatWaitingLabel => 'waiting for you';

  @override
  String get businessNextStepsTitle => 'Get more clients';

  @override
  String businessNextStepsProgress(int done, int total) {
    return '$done of $total';
  }

  @override
  String get businessStepPhotos => 'Add 3 or more photos';

  @override
  String get businessStepPhotosWhy =>
      'Services with photos get chosen more often';

  @override
  String get businessStepPrice => 'Set a price';

  @override
  String get businessStepPriceWhy =>
      'A clear price means fewer questions before the deal';

  @override
  String get businessStepAvailability => 'Show when you’re free';

  @override
  String get businessStepAvailabilityWhy =>
      'Clients write to people who can come soon';

  @override
  String get businessStepShare => 'Share your service link';

  @override
  String get businessStepShareWhy =>
      'Send it on Telegram so friends can recommend you';

  @override
  String businessServicesCount(int count, int max) {
    return 'My services · $count of $max';
  }

  @override
  String xizmatLimitReached(int max) {
    return 'You can have up to $max services. Edit or remove one to add another.';
  }

  @override
  String get calendarStatusCaption => 'Your status · clients see it';

  @override
  String get calendarLegendNeedHelp => 'Help I get';

  @override
  String get calendarLegendGiveHelp => 'Help I give';

  @override
  String get calendarLegendPersonal => 'Personal';

  @override
  String get calendarHintMark =>
      'Tap a day and mark it free or busy. Add hours if it’s only part of the day; otherwise it’s the whole working day.';

  @override
  String get calendarHintClient =>
      'Reminders of your deals: help you get and help you give. Tap a day for details.';

  @override
  String get calendarDayNotMarked => 'Not marked';

  @override
  String get calendarWholeWorkingDay => 'Whole working day';

  @override
  String get calendarAddHours => 'Add hours';

  @override
  String get calendarRemoveHours => 'Remove these hours';

  @override
  String get calendarHoursFrom => 'From';

  @override
  String get calendarHoursTo => 'To';

  @override
  String get calendarDayEvents => 'Reminders this day';

  @override
  String get workingHoursTitle => 'Working hours';

  @override
  String get workingHoursHint => 'Clients see them on your services';

  @override
  String get workingHoursSheetHint =>
      'Your usual working day. By default 9:00–13:00 and 14:00–18:00.';

  @override
  String get workingHoursReset => 'Back to 9–13 and 14–18';

  @override
  String get workingHoursInvalid =>
      'Check the hours: each one starts before it ends, and they don’t overlap.';

  @override
  String get workingHoursSaved => 'Working hours saved';

  @override
  String get xizmatOwnHoursTitle => 'Own hours for this service';

  @override
  String xizmatOwnHoursOff(String hours) {
    return 'Same as your profile: $hours';
  }

  @override
  String get xizmatHoursInCalendar =>
      'You change working hours in the calendar.';

  @override
  String get xizmatHoursOpenCalendar => 'Open calendar';

  @override
  String get xizmatScheduleTitle => 'Hours and availability';

  @override
  String get xizmatScheduleNextDays => 'Next two weeks';

  @override
  String get xizmatTodayFree => 'Free today';

  @override
  String get xizmatTodayBusy => 'Busy today';

  @override
  String xizmatTodayBusyAt(String hours) {
    return 'Busy today: $hours';
  }

  @override
  String xizmatTodayFreeAt(String hours) {
    return 'Free today: $hours';
  }

  @override
  String get calendarNoRemindersDay => 'No reminders on this day.';

  @override
  String get sampleTag => 'Sample';

  @override
  String get demoDealNote =>
      'This is a sample: the deal doesn’t go to a real person.';

  @override
  String get feedInviteProvidersTitle => 'Be one of the first providers';

  @override
  String get feedInviteProvidersBody =>
      'Add your service, and clients will see it first.';

  @override
  String get feedInviteAskTitle => 'Be the first to ask';

  @override
  String get feedInviteAskBody =>
      'Say what you need, and providers will see your request.';

  @override
  String get feedInviteProvidersAction => 'Add your service';

  @override
  String get feedInviteAskAction => 'Describe what you need';

  @override
  String get sampleFindProvider => 'Find a provider';

  @override
  String get sampleFindProviderHint =>
      'This is a sample. Describe the job, and real providers will see it.';

  @override
  String get sampleAlertNewServices =>
      'Tell me when a provider joins in this field';

  @override
  String get sampleRequestPosted => 'Request posted — providers will see it.';

  @override
  String get sampleRequestTitle => 'This is a sample request';

  @override
  String get sampleRequestBody =>
      'Real requests will show up here. Turn on alerts and we’ll tell you when someone asks for help in this field.';

  @override
  String get sampleAlertHelpPosts => 'Alert me to new requests';

  @override
  String get sampleAlertOn =>
      'Done — we’ll tell you about new requests in this field.';

  @override
  String get foundingBadge => 'First on YordamBor';

  @override
  String get foundingBadgeNote =>
      'The first providers get the “First on YordamBor” badge.';

  @override
  String get inviteTitle => 'Invite providers';

  @override
  String get inviteBody =>
      'Know a good electrician, tutor or salon? Invite them: the more real providers, the more clients come.';

  @override
  String get inviteShare => 'Share an invite';

  @override
  String get invitePrepare => 'Prepare a service for someone';

  @override
  String get inviteMessage =>
      'Join me on YordamBor: clients there find providers across Uzbekistan. Adding your service is free, and the first providers get the “First on YordamBor” badge.';

  @override
  String invitePersonalMessage(String name, String trade, String city) {
    return '$name, hello! I’m on YordamBor, where clients find providers. Add your service “$trade” in $city: it’s free, and the first providers get the “First on YordamBor” badge.';
  }

  @override
  String inviteOpenLink(String link) {
    return 'Open to start: $link';
  }

  @override
  String inviteAppLink(String link) {
    return 'The app: $link';
  }

  @override
  String get invitePrepareTitle => 'A service for someone you know';

  @override
  String get invitePrepareBody =>
      'Pick their trade and city. They get a link that opens “New service” with these filled in; they publish it themselves.';

  @override
  String get invitePersonName => 'Their name (optional)';

  @override
  String get invitePersonPhone => 'Their phone (optional)';

  @override
  String get invitePickTrade => 'Trade';

  @override
  String get inviteSendWhatsApp => 'Send on WhatsApp';

  @override
  String get inviteSendSms => 'Send by SMS';

  @override
  String get inviteSendOther => 'Another app';

  @override
  String get inviteNeedTradeCity => 'Choose the trade and the city';

  @override
  String get onbGoalTitle => 'What brings you to YordamBor?';

  @override
  String get onbGoalNeedHelp => 'I need help';

  @override
  String get onbGoalNeedHelpSub => 'Find a provider or describe a job';

  @override
  String get onbGoalOffer => 'I offer services';

  @override
  String get onbGoalOfferSub => 'Get clients and earn';

  @override
  String get onbGoalBoth => 'Both';

  @override
  String get onbGoalBothSub => 'I help, and sometimes I need help';

  @override
  String get onbCityTitle => 'Your city';

  @override
  String get onbCitySub => 'We’ll show what’s near you.';

  @override
  String get onbNext => 'Next';

  @override
  String get onbDone => 'Done';

  @override
  String get onbSkip => 'Skip';

  @override
  String onbStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get onbIntro1Title => 'Services near you';

  @override
  String get onbIntro1Body =>
      'Specialists and organizations across Uzbekistan.';

  @override
  String get onbIntro2Title => 'Need help? Just ask';

  @override
  String get onbIntro2Body =>
      'Describe the task, and providers will reach out.';

  @override
  String get onbIntro3Title => 'Offer your services';

  @override
  String get onbIntro3Body => 'As an individual or an organization. Free.';

  @override
  String get onbIntro4Title => 'Fair and calm';

  @override
  String get onbIntro4Body =>
      'A deal starts when both sides agree. Reviews come only after finished work. You pay as agreed.';

  @override
  String get onbTypeTitle => 'How do you work?';

  @override
  String get onbTypeSub =>
      'Clients see this on your services. You can change it later.';

  @override
  String get onbTypeIndividualSub => 'A tradesperson, tutor or freelancer';

  @override
  String get onbTypeInstitutionSub =>
      'A company, salon, clinic or training centre';

  @override
  String onbReadyToOffer(String action) {
    return 'Whenever you’re ready, tap “$action”.';
  }

  @override
  String get inviteAction => 'Invite a provider you know';

  @override
  String invitePersonalMessageNoName(String trade, String city) {
    return 'Hello! I’m on YordamBor, where clients find providers. Add your service “$trade” in $city: it’s free, and the first providers get the “First on YordamBor” badge.';
  }

  @override
  String get joinTitle => 'You’re invited to YordamBor';

  @override
  String get joinBody =>
      'Add your service — it’s free. Clients find providers here by trade and city.';

  @override
  String get joinLookAround => 'Look around first';

  @override
  String get onbStart => 'Get started';

  @override
  String get welcomeFindHelp => 'Find help';

  @override
  String get welcomeGiveHelp => 'Offer help';

  @override
  String get onbTileLawyer => 'Lawyer';

  @override
  String get onbTileBeauty => 'Beauty';

  @override
  String get onbTileCatering => 'Catering';

  @override
  String get onbTileVet => 'Vet';

  @override
  String get onbTileCleaning => 'Cleaning';

  @override
  String get onbTileElectrician => 'Electrician';

  @override
  String get onbTilePlumber => 'Plumber';

  @override
  String get onbTileDental => 'Dental clinic';

  @override
  String onbMoreServices(int count) {
    return 'and $count+ more kinds of service';
  }

  @override
  String get onbIllRequestTitle => 'The kitchen tap is leaking';

  @override
  String get onbIllToday => 'Today';

  @override
  String get onbIllNewOffers => '2 new offers';

  @override
  String get onbIllName1 => 'Aziz';

  @override
  String get onbIllName2 => 'Dilnoza';

  @override
  String get onbIllOffer1 => 'I can come today at 6 pm';

  @override
  String get onbIllOffer2 => 'Free tomorrow morning';

  @override
  String get onbIllNewRequest => 'New request';

  @override
  String get onbIllSocket => 'Replace a socket';

  @override
  String get onbTileTutor => 'Tutor';

  @override
  String get onbTileAuto => 'Car repair';

  @override
  String get searchTooltip => 'Search';

  @override
  String get searchHint => 'Name, organization or service';

  @override
  String get searchPrompt =>
      'Type a provider’s name, an organization or a service, such as “plumber”.';

  @override
  String get searchNoResults => 'Nothing found';

  @override
  String get searchNoResultsHint =>
      'Post a request, and providers will reach out.';

  @override
  String get searchOffline =>
      'No connection: showing only what’s on your phone.';

  @override
  String get onbTileRenovation => 'Renovation';

  @override
  String get onbTileFitness => 'Fitness';

  @override
  String get onbTileTranslator => 'Translator';

  @override
  String get onbTileBarber => 'Barber';

  @override
  String get onbTileMusic => 'Music lessons';

  @override
  String get onbTileStylist => 'Stylist';

  @override
  String get onbTileKindergarten => 'Kindergarten';

  @override
  String get onbIllTutorTitle => 'English and IELTS';

  @override
  String get onbIllStylistRequest => 'A look for a wedding';

  @override
  String onbKindsChip(int count) {
    return '+$count kinds of service';
  }

  @override
  String get onbIllDentalRequestTitle => 'I have a toothache';

  @override
  String get onbTileDentist => 'Dentist';

  @override
  String get onbIllDentalOffer1 => 'We can see you today at 4 pm';

  @override
  String get onbIllDentalOffer2 => 'I can see you tomorrow morning';

  @override
  String get xizmatStatNoReviews => 'No reviews';

  @override
  String get xizmatStatPrice => 'price';

  @override
  String get xizmatStatPerHour => 'per hour';

  @override
  String get xizmatStatNegotiable => 'Negotiable';

  @override
  String get xizmatPromiseOwnWords => 'In the provider’s own words';

  @override
  String get xizmatAboutTitle => 'About this service';

  @override
  String get actionReadMore => 'Read more';

  @override
  String get actionReadLess => 'Show less';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '$count review',
    );
    return '$_temp0';
  }

  @override
  String reviewsSeeAll(int count) {
    return 'All reviews ($count)';
  }

  @override
  String get reviewsFilterAll => 'All';

  @override
  String get reviewsFilterEmpty => 'No reviews with this rating yet';

  @override
  String reviewsBarA11y(int stars, int count) {
    return 'Rating $stars: $count';
  }

  @override
  String get xizmatHowTitle => 'How it works';

  @override
  String get xizmatHowAsk => 'Send a request';

  @override
  String get xizmatHowChat => 'Chat in the app';

  @override
  String get xizmatHowAgree => 'Agree on the job';

  @override
  String providerMemberSince(String year) {
    return 'Member since $year';
  }

  @override
  String providerServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count services',
      one: '$count service',
    );
    return '$_temp0';
  }

  @override
  String get xizmatAboutHint =>
      'What you do, how you work, what you promise clients';

  @override
  String xizmatPricePerDay(String amount) {
    return '$amount/day';
  }

  @override
  String xizmatPricePerMonth(String amount) {
    return '$amount/month';
  }

  @override
  String xizmatPricePerUnit(String amount) {
    return '$amount/unit';
  }

  @override
  String get xizmatStatPerDay => 'per day';

  @override
  String get xizmatStatPerMonth => 'per month';

  @override
  String get xizmatStatPerUnit => 'per unit';

  @override
  String get priceChoiceTitle => 'Price';

  @override
  String get priceChoiceServiceHint =>
      'Clients write sooner when they can see the price.';

  @override
  String get priceChoiceRequestHint => 'How much are you ready to pay?';

  @override
  String get priceChoiceNegotiable => 'Negotiable';

  @override
  String get priceChoiceNegotiableHint => 'Agree on it in the chat';

  @override
  String get priceChoiceAmount => 'Set price';

  @override
  String get priceChoiceAmountHint => 'Amount and unit';

  @override
  String get priceAmountLabel => 'Amount (UZS)';

  @override
  String get priceAmountHint => 'For example: 150000';

  @override
  String get priceUnitFixed => 'Per job';

  @override
  String get priceUnitHour => 'Per hour';

  @override
  String get priceUnitDay => 'Per day';

  @override
  String get priceUnitMonth => 'Per month';

  @override
  String get priceUnitUnit => 'Per unit';

  @override
  String get priceChoiceRequired => 'Choose the price: negotiable or an amount';

  @override
  String get growthI00Title => 'Your service is live on YordamBor!';

  @override
  String get growthI00Body =>
      'Congratulations! For the next 30 days we\'ll send short tips to help you find more clients.';

  @override
  String get growthI01Title => 'Photos build trust';

  @override
  String get growthI01Body =>
      'Add at least 3 photos of your work — before-and-after shots work especially well.';

  @override
  String get growthI02Title => 'Show your price';

  @override
  String get growthI02Body =>
      'A clear price means fewer questions and faster deals. Set a price per hour, day or job.';

  @override
  String get growthI03Title => 'When are you free?';

  @override
  String get growthI03Body =>
      'Set your status to “Available now”: clients write first to those who can come soon.';

  @override
  String get growthI04Title => 'Invite your clients to YordamBor';

  @override
  String get growthI04Body =>
      'Send your regular clients a link to your service: next time they\'ll find you in one tap.';

  @override
  String get growthI05Title => 'Fast replies win work';

  @override
  String get growthI05Body =>
      'Reply to requests within an hour: clients usually pick whoever answers first.';

  @override
  String get growthI06Title => 'Tell clients about yourself';

  @override
  String get growthI06Body =>
      'Describe your experience and the way you work in 3–4 sentences: clients want to know who they\'ll work with.';

  @override
  String get growthI07Title => 'Reviews are the best ad';

  @override
  String get growthI07Body =>
      'When a job is done, ask the client for a review on YordamBor: every rating brings new clients.';

  @override
  String get growthI08Title => 'Your friends need YordamBor too';

  @override
  String get growthI08Body =>
      'Tell friends and neighbours about YordamBor: more clients here means more orders for you.';

  @override
  String get growthI09Title => 'Keep your calendar current';

  @override
  String get growthI09Body =>
      'Mark your busy days: clients see when you\'re free and book a specific day.';

  @override
  String get growthI10Title => 'Track your income';

  @override
  String get growthI10Body =>
      'Tools has your income, client book and receipts — all in one place.';

  @override
  String get growthI11Title => '30 days — a great start!';

  @override
  String get growthI11Body =>
      'Share your service link on social media and keep growing on YordamBor.';

  @override
  String get growthO00Title => 'Your organisation is live on YordamBor!';

  @override
  String get growthO00Body =>
      'Congratulations! For the next 30 days we\'ll send short tips to grow your flow of clients.';

  @override
  String get growthO01Title => 'Show your place';

  @override
  String get growthO01Body =>
      'Add at least 3 photos of your premises, team and work: clients see in advance where they\'re going.';

  @override
  String get growthO02Title => 'Make your prices clear';

  @override
  String get growthO02Body =>
      'Show the price of your main service: clients write more to organisations with clear prices.';

  @override
  String get growthO03Title => 'Set your opening hours';

  @override
  String get growthO03Body =>
      'Add your working days and hours: clients see right away when they can come.';

  @override
  String get growthO04Title => 'Invite your clients to YordamBor';

  @override
  String get growthO04Body =>
      'Share your link in your Telegram channel, at the till or by SMS: clients find you in one tap.';

  @override
  String get growthO05Title => 'Licences and certificates';

  @override
  String get growthO05Body =>
      'Add your documents to your profile: official proof makes clients trust you more.';

  @override
  String get growthO06Title => 'One service per line of work';

  @override
  String get growthO06Body =>
      'Add your services one by one (up to 5): clients find exactly what they need faster.';

  @override
  String get growthO07Title => 'Answer requests quickly';

  @override
  String get growthO07Body =>
      'Put someone in charge of replies: fast answers mean more deals.';

  @override
  String get growthO08Title => 'Ask every client for a review';

  @override
  String get growthO08Body =>
      'Reviews from happy clients raise your rating and bring in new clients.';

  @override
  String get growthO09Title => 'Put your link on your business card';

  @override
  String get growthO09Body =>
      'Put your YordamBor link on your card, menu or shop window: booking takes one tap.';

  @override
  String get growthO10Title => 'Your books in one place';

  @override
  String get growthO10Body =>
      'Receipts, income and the client book are in Tools: keep your organisation in order.';

  @override
  String get growthO11Title => 'Your first month is done!';

  @override
  String get growthO11Body =>
      'See your results on your service card and keep growing your clients on YordamBor.';

  @override
  String get growthProgramTitle => 'Grow your business';

  @override
  String growthProgramDay(int day) {
    return 'Day $day of 30';
  }

  @override
  String get growthTipDone => 'Done';

  @override
  String get growthEarlierTips => 'Earlier tips';

  @override
  String get growthTipsOff => 'Turn off tips';

  @override
  String get growthTipsOffDone =>
      'Tips are off. You can turn them back on in reminder settings.';

  @override
  String get growthTipsSetting => 'Business tips';

  @override
  String get growthTipsSettingSub => 'For 30 days after you add a service';

  @override
  String growthInviteShareText(String link) {
    return 'YordamBor — trusted pros and services in one place. Get the app: $link';
  }

  @override
  String get growthActionPhotos => 'Add photos';

  @override
  String get growthActionPrice => 'Set the price';

  @override
  String get growthActionAvailability => 'Set your status';

  @override
  String get growthActionHours => 'Set your hours';

  @override
  String get growthActionShare => 'Share the link';

  @override
  String get growthActionInvite => 'Invite';

  @override
  String get growthActionReply => 'Open requests';

  @override
  String get growthActionDescription => 'Write the description';

  @override
  String get growthActionReviews => 'Open deals';

  @override
  String get growthActionCalendar => 'Open the calendar';

  @override
  String get growthActionTools => 'Open tools';

  @override
  String get growthActionCertificates => 'Add a document';

  @override
  String get growthActionMoreServices => 'Add a service';

  @override
  String get growthActionMyServices => 'See my services';

  @override
  String get appointmentPhaseNow => 'Now';

  @override
  String get appointmentPhaseToday => 'Today';

  @override
  String get appointmentPhasePlanned => 'Planned';

  @override
  String get appointmentPhasePast => 'Awaiting completion';

  @override
  String get appointmentPhaseDone => 'Done';

  @override
  String get appointmentPhaseCancelled => 'Cancelled';

  @override
  String get appointmentRoleProvider => 'I provide';

  @override
  String get appointmentRoleClient => 'I receive';

  @override
  String get appointmentPartyClient => 'Client';

  @override
  String get appointmentPartyProvider => 'Service provider';

  @override
  String get appointmentCall => 'Call';

  @override
  String get actionChat => 'Chat';

  @override
  String get actionKeep => 'Keep';

  @override
  String get appointmentCancel => 'Cancel';

  @override
  String get appointmentCancelTitle => 'Cancel appointment?';

  @override
  String get appointmentCancelBody =>
      'This action cannot be undone. The other party will be notified.';

  @override
  String get appointmentCancelConfirm => 'Yes, cancel';

  @override
  String get appointmentSaveClient => 'Save to client list';

  @override
  String get appointmentFactPrice => 'PRICE';

  @override
  String get appointmentFactDuration => 'DURATION';

  @override
  String appointmentDuration(int minutes) {
    return '$minutes min';
  }

  @override
  String get availabilitySheetCaption => 'What will clients see right now?';

  @override
  String get availabilityTileNowHint => 'Taking orders now';

  @override
  String get availabilityTileBusyHint => 'Busy, back soon';

  @override
  String get availabilityTileBookingHint => 'Book in advance';

  @override
  String get availabilityTileHidden => 'Hidden';

  @override
  String get availabilityTileHiddenHint => 'Service not visible';

  @override
  String get availabilityUntilTitle => 'Until when?';

  @override
  String get availabilityUntilHour => '1 hour';

  @override
  String get availabilityUntilToday => 'Today';

  @override
  String get availabilityUntilForever => 'Open-ended';

  @override
  String get availabilityHoursTitle => 'Working hours';

  @override
  String get availabilityHoursOwn => 'My schedule';

  @override
  String get availabilityHoursShared => 'Shared hours';

  @override
  String get availabilityBusyToggle => 'Show busy hours to clients';

  @override
  String get availabilityBusyToggleHint =>
      'Clients see a two-week strip with your free and busy slots';

  @override
  String get availabilityPreview => 'Preview';

  @override
  String get availabilityHiddenPreview => 'Hidden from search';

  @override
  String get availabilitySaved => 'Status saved';

  @override
  String get businessEmptyTitle => 'Start earning on YordamBor';

  @override
  String get businessEmptyBody =>
      'Thousands of people nearby are looking for help right now. Add your first service — it takes just 2 minutes.';

  @override
  String get calendarTabTitle => 'Schedule';

  @override
  String get calendarNoAppointments => 'No appointments yet';

  @override
  String get calendarNoAppointmentsHint =>
      'Agreed deals appear here as appointments';

  @override
  String get calendarSectionToday => 'Today';

  @override
  String get calendarSectionUpcoming => 'Upcoming';

  @override
  String get calendarSectionPast => 'Past';

  @override
  String get calendarBusyTitle => 'My availability';

  @override
  String get calendarBusyAllDay => 'Busy all day';

  @override
  String get calendarBusyHours => 'Busy hours';

  @override
  String get calendarServicesStrip => 'My services';

  @override
  String get calendarReminders => 'Reminders';

  @override
  String get reminderLeadDay => '1 day before';

  @override
  String get reminderLead3Hours => '3 hours before';

  @override
  String get reminderLeadHour => '1 hour before';

  @override
  String get reminderLead15Min => '15 minutes before';

  @override
  String get saveClientPromptTitle => 'Save client?';

  @override
  String saveClientPromptBody(String name) {
    return 'Would you like to add $name to your client list?';
  }

  @override
  String get saveClientConfirm => 'Save';

  @override
  String get saveClientSkip => 'Not now';

  @override
  String get saveClientDone => 'Client saved';

  @override
  String get notifSectionSoon => 'Upcoming appointments';

  @override
  String get notifAppointmentCancelledTitle => 'Appointment cancelled';

  @override
  String get notifSubsectorHelpTitle => 'Help needed in your area';
}
