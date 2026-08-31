// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appName => 'YordamBor';

  @override
  String get splashTagline => 'YordamBor\'da yordam bor!';

  @override
  String get tabHome => 'Asosiy';

  @override
  String get tabFavorites => 'Saqlangan';

  @override
  String get tabProfile => 'Profil';

  @override
  String get filterYordamBor => 'Yordam Bor';

  @override
  String get filterYordamKerak => 'Yordam Kerak';

  @override
  String get filterCategory => 'Soha';

  @override
  String get filterSubcategory => 'Subsoha';

  @override
  String get filterPickCategoryFirst => 'Avval soha tanlang';

  @override
  String get filterProviderType => 'Tur';

  @override
  String get filterProviderAll => 'Barchasi';

  @override
  String get filterProviderTypeHint => 'Xizmat ko\'rsatuvchi turini tanlang';

  @override
  String get filterProviderAllHint => 'Jismoniy shaxs va tashkilotlar';

  @override
  String get filterProviderIndividualHint =>
      'Shaxsiy usta, repetitor, maslahatchi';

  @override
  String get filterProviderInstitutionHint => 'Klinika, studiya, kompaniya';

  @override
  String get filterAllCategories => 'Barcha sohalar';

  @override
  String get filterAllSubcategories => 'Barcha subsohalar';

  @override
  String get filterCategoryHint => 'Qaysi soha bo\'yicha qidiryapsiz?';

  @override
  String get filterAllCategoriesHint => 'Barcha sohalardagi xizmatlar';

  @override
  String get filterAllSubcategoriesHint =>
      'Tanlangan sohadagi barcha yo\'nalishlar';

  @override
  String homeFeedShowing(String summary) {
    return 'Ko\'rsatilmoqda: $summary';
  }

  @override
  String get filterPickProviderTypeFirst =>
      'Avval jismoniy shaxs yoki tashkilotni tanlang';

  @override
  String get homeEmptyTitle => 'Tez orada xizmatlar paydo bo\'ladi';

  @override
  String get homeEmptySubtitle =>
      'Turli sohalardagi xizmatlar portfolio bilan qo\'shiladi';

  @override
  String get homeDemoXizmat => 'Demo xizmatlar namuna sifatida ko\'rsatilmoqda';

  @override
  String get homeDemoPosts => 'Demo e\'lonlar namuna sifatida ko\'rsatilmoqda';

  @override
  String get homeJobsEmptyTitle => 'Yordam Kerak e\'lonlari';

  @override
  String get homeJobsEmptySubtitle =>
      'Birinchi e\'lonni yuboring yoki filtrlarni o\'zgartiring';

  @override
  String get favoritesEmptyTitle => 'Yoqtirgan xizmatlaringizni saqlang';

  @override
  String get favoritesEmptySubtitle => 'Kartadagi ♥ tugmasini bosing';

  @override
  String get profileGuestTitle => 'YordamBor\'ga xush kelibsiz';

  @override
  String get profileGuestSubtitle =>
      'Kelishuvlar va e\'lonlar uchun ro\'yxatdan o\'ting. Sevimlilar hisobsiz saqlanadi.';

  @override
  String get profilePhone => 'Telefon';

  @override
  String get profileChangePhoto => 'Rasmni o\'zgartirish';

  @override
  String get profilePhotoUpdated => 'Profil rasmi yangilandi';

  @override
  String get profilePhotoFailed => 'Rasmni yuklab bo\'lmadi';

  @override
  String get login => 'Kirish';

  @override
  String get register => 'Ro\'yxatdan o\'tish';

  @override
  String get notificationsTitle => 'Bildirishnomalar';

  @override
  String get notificationsEmpty => 'Hali bildirishnomalar yo\'q';

  @override
  String get fabPostYordamKerak => 'E\'lon qoldirish';

  @override
  String get welcomeTitle => 'YordamBor\'da Yordam bor!';

  @override
  String get welcomeBrand => 'YordamBor.';

  @override
  String get welcomeBody =>
      'Turli xizmatlarni toping. Yordam bering yoki yordam so\'rang.';

  @override
  String get startBrowsing => 'Boshlash';

  @override
  String get createAccount => 'Ro\'yxatdan o\'tish';

  @override
  String get alreadyHaveAccount => 'Allaqachon hisobingiz bormi?';

  @override
  String get authContinueTitle => 'Davom etish uchun kiring';

  @override
  String get authContextGeneric => 'Davom etish uchun kiring';

  @override
  String get authContextFavorite => 'Sevimlilarga saqlash uchun kiring';

  @override
  String get authContextYordamKerak => 'Ustaga so\'rov yuborish uchun kiring';

  @override
  String get authContextYordamBor => 'Taklif yuborish uchun kiring';

  @override
  String get authContextPostJob => 'E\'lon qoldirish uchun kiring';

  @override
  String get authContextDeal => 'Kelishuv boshlash uchun kiring';

  @override
  String get later => 'Keyinroq';

  @override
  String get fullName => 'To\'liq ism';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Telefon';

  @override
  String get password => 'Parol';

  @override
  String get confirmPassword => 'Parol takror';

  @override
  String get fieldRequired => 'Bu maydon to\'ldirilishi shart';

  @override
  String get invalidEmail => 'Email manzilini to\'g\'ri kiriting';

  @override
  String get invalidPhone => 'Telefon raqamini to\'g\'ri kiriting (+998...)';

  @override
  String get invalidNumber => 'Raqamni to\'g\'ri kiriting';

  @override
  String get invalidMinutes => 'Daqiqalarni to\'g\'ri kiriting';

  @override
  String get passwordTooShort =>
      'Parol kamida 8 belgidan iborat bo\'lishi kerak';

  @override
  String get passwordsDoNotMatch => 'Parollar mos kelmadi';

  @override
  String get acceptTermsRequired => 'Foydalanish shartlariga rozilik bildiring';

  @override
  String get acceptTerms => 'Foydalanish shartlariga roziman';

  @override
  String get acceptTermsLead => '';

  @override
  String get acceptTermsLink => 'Foydalanish shartlari';

  @override
  String get acceptTermsTrail => 'ga roziman';

  @override
  String get forgotPassword => 'Parolni unutdingizmi?';

  @override
  String get resetPasswordTitle => 'Yangi parol';

  @override
  String get resetPasswordBody => 'Yangi parol kiriting va saqlang.';

  @override
  String get resetPasswordSubmit => 'Parolni saqlash';

  @override
  String get resetPasswordSuccess => 'Parol yangilandi';

  @override
  String get resetPasswordSendLink => 'Havola yuborish';

  @override
  String resetPasswordEmailSent(String emailAddress) {
    return '$emailAddress manziliga parolni tiklash havolasi yubordik.';
  }

  @override
  String get resetPasswordEmailHint =>
      'Havolani telefoningizda oching. Ilova ochilgach yangi parol o\'rnatishingiz mumkin.';

  @override
  String get resetPasswordExpiredTitle => 'Havola muddati tugagan';

  @override
  String get resetPasswordExpiredBody =>
      'Parolni tiklash havolasini qayta so\'rang.';

  @override
  String get continueAction => 'Davom etish';

  @override
  String get verifyEmailTitle => 'Emailni tasdiqlang';

  @override
  String verifyEmailBody(String emailAddress) {
    return '$emailAddress manziliga tasdiqlash havolasi yubordik.';
  }

  @override
  String get verifyEmailBodyMissing =>
      'Emailingizga tasdiqlash havolasi yubordik. Havolani ochgandan keyin \"Tasdiqladim\" tugmasini bosing.';

  @override
  String get verifyEmailCheck => 'Tasdiqladim';

  @override
  String get verifyEmailPending =>
      'Email hali tasdiqlanmagan. Pochtangizni tekshiring.';

  @override
  String get openMail => 'Pochtani ochish';

  @override
  String get resendEmail => 'Qayta yuborish';

  @override
  String get continueBrowsing => 'Ko\'rib chiqishni davom eting';

  @override
  String welcomeBack(String name) {
    return 'Xush kelibsiz, $name!';
  }

  @override
  String get welcomeGuestName => 'do\'stim';

  @override
  String welcomeNewTitle(String name) {
    return 'Xush kelibsiz, $name!';
  }

  @override
  String get welcomeNewBody =>
      'YordamBor oilasiga qo\'shilganingiz bilan tabriklaymiz! Xizmat toping, yordam bering yoki e\'lon qoldiring — biz har qadamda siz bilan birgamiz.';

  @override
  String welcomeLoginTitle(String name) {
    return 'Yana xush kelibsiz, $name!';
  }

  @override
  String get welcomeLoginBody =>
      'Sizni yana ko\'rganimizdan xursandmiz. Bugun qanday yordam kerak?';

  @override
  String welcomeReturnTitle(String name) {
    return 'Salom, $name!';
  }

  @override
  String get welcomeReturnBody => 'Kerakli xizmatlar sizni kutmoqda.';

  @override
  String get welcomeReturnBodyYordamKerak =>
      'Xizmatlaringiz mijoz ehtiyojiga mos keladimi?';

  @override
  String homeGreetingShort(String name) {
    return 'Salom, $name!';
  }

  @override
  String get homeGreetingYordamBor => 'Bugun qanday yordam kerak?';

  @override
  String get homeGreetingYordamKerak => 'Bugun yordam bera olasizmi?';

  @override
  String get providerPromptTitle => 'Xizmat ko\'rsatasizmi?';

  @override
  String get providerPromptBody =>
      'Portfolio qo\'shing — mijozlar xizmatingizni topa oladi.';

  @override
  String get createXizmat => 'Xizmat yaratish';

  @override
  String get signOut => 'Chiqish';

  @override
  String get settings => 'Sozlamalar';

  @override
  String get settingsSubtitle => 'Til, maxfiylik, hisob';

  @override
  String get settingsAppearance => 'Ko\'rinish';

  @override
  String get settingsDarkMode => 'Mavzu';

  @override
  String get settingsThemeSystem => 'Tizim';

  @override
  String get settingsThemeLight => 'Yorug\'';

  @override
  String get settingsThemeDark => 'Qorong\'u';

  @override
  String get settingsLanguage => 'Til';

  @override
  String get settingsTools => 'Asboblar';

  @override
  String get settingsLegal => 'Huquqiy';

  @override
  String get settingsPrivacy => 'Maxfiylik siyosati';

  @override
  String get settingsPrivacySection => 'Maxfiylik';

  @override
  String get settingsShowPhoneLabel => 'Profilimda telefon ko\'rsatilsin';

  @override
  String get settingsShowPhoneSubtitle =>
      'Ochiq profilingizda telefon raqamingiz ko\'rinadi';

  @override
  String get postContactSectionTitle => 'Aloqa';

  @override
  String get postContactSectionSubtitle =>
      'Profil har doim ochiq. Telefon raqamini ko\'rsatish ixtiyoriy.';

  @override
  String get postContactPhoneLabel => 'Telefon raqami';

  @override
  String get postContactPhoneHint => '+998 90 123 45 67';

  @override
  String get postContactPhoneOptional => 'Ixtiyoriy';

  @override
  String get postShowPhoneLabel => 'Telefon raqamini ko\'rsatish';

  @override
  String get postShowPhoneSubtitle =>
      'Bu e\'londa telefon raqamingiz ko\'rinadi';

  @override
  String get postShowProfileLabel => 'Profilni ko\'rsatish';

  @override
  String get postShowProfileSubtitle =>
      'Foydalanuvchilar profilingizni ko\'ra oladi';

  @override
  String get postAuthorHidden => 'Muallif yashirin';

  @override
  String get settingsTerms => 'Foydalanish shartlari';

  @override
  String get settingsDeleteAccount => 'Hisobni o\'chirish';

  @override
  String get settingsDeleteAccountHint => 'Barcha kelishuvlar bekor qilinadi';

  @override
  String get settingsDeleteAccountConfirm =>
      'Barcha ma\'lumotlaringiz, xizmatlar va faol kelishuvlar o\'chiriladi. Bu amalni qaytarib bo\'lmaydi.';

  @override
  String get settingsDeleteAccountAction => 'Hisobni o\'chirish';

  @override
  String get settingsDeleteAccountDone => 'Hisobingiz o\'chirildi';

  @override
  String get remindersTitle => 'Eslatmalar';

  @override
  String get remindersAdd => 'Eslatma qo\'shish';

  @override
  String get remindersEmptyTitle => 'Eslatmalar yo\'q';

  @override
  String get remindersEmptySubtitle =>
      'Mijoz kitobi kalendari bilan sinxron. Kelishuv boshlanganda ham yaratiladi';

  @override
  String get remindersFieldClientName => 'Mijoz ismi';

  @override
  String get remindersUpcoming => 'Kelgusi';

  @override
  String get remindersPast => 'O\'tgan';

  @override
  String get remindersFieldTitle => 'Sarlavha';

  @override
  String get remindersFieldBody => 'Izoh (ixtiyoriy)';

  @override
  String get remindersSave => 'Saqlash';

  @override
  String get remindersSettingsSubtitle => 'Kelishuv va uchrashuv eslatmalari';

  @override
  String get legalPrivacyTitle => 'Maxfiylik siyosati';

  @override
  String get legalTermsTitle => 'Foydalanish shartlari';

  @override
  String get legalPrivacyBody =>
      'YordamBor shaxsiy ma\'lumotlaringizni faqat xizmat ko\'rsatish, kelishuvlar va xavfsizlik uchun ishlatadi.\n\n1. Qanday ma\'lumotlar to\'planadi\n\nIsm, email, telefon, xizmat portfolio rasmlari, kelishuv xabarlari va bildirishnomalar.\n\n2. Qayerda saqlanadi\n\nMa\'lumotlar Supabase serverlarida shifrlangan holda saqlanadi.\n\n3. Uchinchi tomonlar\n\nMa\'lumotlaringiz sotilmaydi. Faqat xizmat ko\'rsatish uchun zarur bo\'lgan texnik hamkorlar (hosting, email) bilan cheklangan.\n\n4. Sizning huquqlaringiz\n\nMa\'lumotlaringizni ko\'rish, yangilash yoki hisobni o\'chirish huquqiga egasiz.\n\n5. Aloqa\n\nSavollar bo\'yicha ilova ichidagi Sozlamalar bo\'limidan murojaat qiling.';

  @override
  String get legalTermsBody =>
      'YordamBor — turli sohalardagi xizmat ko\'rsatuvchilar va mijozlarni bog\'lovchi mobil platforma. Platformadan foydalanish ushbu shartlarga rozilik bildirish hisoblanadi.\n\n1. Umumiy qoidalar\n\nYordamBor xizmatlarni taqdim etmaydi; u faqat tomonlarni bog\'laydi. Platforma to\'lov vositachisi emas.\n\n2. Hisob va ro\'yxatdan o\'tish\n\nTo\'g\'ri va yangilangan ma\'lumotlarni taqdim etishingiz kerak. Email manzilingizni tasdiqlashingiz lozim.\n\n3. Xizmatlar va portfolio\n\nXizmat e\'lonida kamida bitta haqiqiy portfolio rasmi bo\'lishi shart. Yolg\'on, chalg\'ituvchi yoki noqonuniy e\'lonlar o\'chirilishi mumkin.\n\n4. Kelishuvlar (Yordam Bor / Yordam Kerak)\n\nNarx, muddat va ish tavsifi tomonlar o\'rtasida kelishiladi. YordamBor kelishuv jarayonini saqlaydi, lekin to\'lovni qabul qilmaydi.\n\n5. Taqiqlangan harakatlar\n\nFiribgarlik, haqorat, spam, noqonuniy xizmatlar yoki platforma qoidalarini ataylab buzish taqiqlanadi.\n\n6. Hisobni bloklash\n\nQoidalar buzilganda YordamBor hisobni vaqtincha yoki doimiy to\'xtatish huquqiga ega.\n\n7. O\'zgarishlar\n\nShartlar yangilanishi mumkin. Davom etish yangilangan shartlarga rozilik hisoblanadi.\n\n8. Aloqa\n\nSavollar bo\'yicha ilova ichidagi Sozlamalar bo\'limidan murojaat qiling.';

  @override
  String get shareXizmat => 'Ulashish';

  @override
  String shareXizmatMessage(String name) {
    return 'YordamBor\'da $name xizmatini ko\'ring';
  }

  @override
  String get shareYordamKerak => 'E\'lonni ulashish';

  @override
  String shareYordamKerakMessage(String title) {
    return 'Yordam kerak: $title — YordamBor';
  }

  @override
  String get postNotFound => 'E\'lon topilmadi';

  @override
  String get shareCopied => 'Havola nusxalandi';

  @override
  String get languageUz => 'O\'zbek';

  @override
  String get languageRu => 'Русский';

  @override
  String get languageEn => 'English';

  @override
  String get languageZh => '中文';

  @override
  String get actionSave => 'Saqlash';

  @override
  String get actionCancel => 'Bekor';

  @override
  String get actionEdit => 'Tahrirlash';

  @override
  String get actionDelete => 'O\'chirish';

  @override
  String get actionView => 'Ko\'rish';

  @override
  String get actionUnblock => 'Blokdan chiqarish';

  @override
  String get actionSubmit => 'Yuborish';

  @override
  String get kelishuvTitle => 'Kelishuv';

  @override
  String get kelishuvNotFound => 'Kelishuv topilmadi';

  @override
  String get kelishuvMessages => 'Xabarlar';

  @override
  String get kelishuvNoMessages => 'Hali xabar yo\'q';

  @override
  String get kelishuvOpeningOffer => 'Boshlang\'ich taklif';

  @override
  String get kelishuvReject => 'Rad etish';

  @override
  String get kelishuvCancel => 'Bekor qilish';

  @override
  String get kelishuvAccept => 'Qabul qilaman';

  @override
  String get kelishuvComplete => 'Ish bajarildi';

  @override
  String get kelishuvEditTerms => 'Shartlarni tahrirlash';

  @override
  String get kelishuvTermsChanged =>
      'Shartlar o\'zgardi — ikkala tomon ham qayta tasdiqlashi kerak';

  @override
  String get kelishuvAwaitingComplete =>
      'Boshqa tomon ish bajarilganini tasdiqladi — siz ham tasdiqlang';

  @override
  String get kelishuvPartyA => 'Tomon A';

  @override
  String get kelishuvPartyB => 'Tomon B';

  @override
  String get kelishuvCompleteA => 'A bajarildi';

  @override
  String get kelishuvCompleteB => 'B bajarildi';

  @override
  String get kelishuvDualAccepted => 'Ikki tomon ham qabul qildi';

  @override
  String get kelishuvCompleteTooEarly =>
      'Ishni tugatish jarayon boshlanganidan 3 kun o\'tgach mumkin';

  @override
  String kelishuvCompleteDaysLeft(int days) {
    return 'Tugatishni belgilash uchun $days kun qoldi';
  }

  @override
  String get kelishuvMessageHint => 'Xabar yozing...';

  @override
  String get kelishuvIncoming => 'Menga kelgan';

  @override
  String get kelishuvIncomingSub => 'Xizmatlaringizga kelgan so\'rovlar';

  @override
  String get kelishuvRequests => 'Mening so\'rovlarim';

  @override
  String get kelishuvRequestsSub => 'Yuborgan kelishuvlaringiz';

  @override
  String get kelishuvArchive => 'Arxiv';

  @override
  String get kelishuvArchiveSub => 'Yakunlangan kelishuvlar';

  @override
  String get kelishuvNeedsResponse => 'Javob kerak';

  @override
  String get kelishuvNeedsConfirm => 'Tasdiqlash';

  @override
  String get profileBlocked => 'Bloklanganlar';

  @override
  String get profileClientBook => 'Mijoz kitobi';

  @override
  String get profileClientBookSub => 'Mahalliy mijozlar ro\'yxati';

  @override
  String get profileEarnings => 'Mening daromadim';

  @override
  String get profileEarningsSub => 'E\'lon qilingan daromad';

  @override
  String get profileMyXizmatlar => 'Mening xizmatlarim';

  @override
  String get profileSetAvailability => 'Mavjudlikni belgilash';

  @override
  String get profileSectionLoadFailed =>
      'Yuklab bo\'lmadi. Internet aloqasini tekshiring.';

  @override
  String get actionRetry => 'Qayta urinish';

  @override
  String get clientBookTitle => 'Mijoz kitobi';

  @override
  String get clientBookList => 'Ro\'yxat';

  @override
  String get clientBookCalendar => 'Kalendar';

  @override
  String get clientBookOpenDeal => 'Kelishuvni ochish';

  @override
  String get clientBookEditClient => 'Mijozni tahrirlash';

  @override
  String get clientBookAdd => 'Mijoz qo\'shish';

  @override
  String get clientBookBookClient => 'Mijozni yozish';

  @override
  String get clientBookEditBooking => 'Yozuvni tahrirlash';

  @override
  String get clientBookNameRequired => 'Mijoz ismini kiriting';

  @override
  String get clientBookDateRequired => 'Uchrashuv sanasini tanlang';

  @override
  String get clientBookNoteLabel => 'Eslatma';

  @override
  String get clientBookEmptyTitle => 'Mijozlar kitobi bo\'sh';

  @override
  String get clientBookEmptySub =>
      'Kalendarda mijoz yozing yoki kelishuv boshlanganda qo\'shiladi';

  @override
  String get clientBookDateLabel => 'Uchrashuv sanasi';

  @override
  String get clientBookBookDay => 'Shu kunga yozish';

  @override
  String get clientBookCalendarHint => 'Mijozni yozish uchun kunni bosing';

  @override
  String get clientBookMarkComplete => 'Xizmat bajarildi';

  @override
  String get clientBookMarkCancelled => 'Bekor qilish';

  @override
  String get clientBookMarkPending => 'Kutilmoqda deb belgilash';

  @override
  String get clientBookCompleteAmount => 'Mijozdan daromad (UZS)';

  @override
  String get clientBookDeliveryCompleted => 'Bajarildi';

  @override
  String get clientBookDeliveryPending => 'Kutilmoqda';

  @override
  String get clientBookDeliveryCancelled => 'Bekor qilindi';

  @override
  String get clientBookNewClientOption => 'Yangi mijoz';

  @override
  String get clientBookSelectClient => 'Mijoz';

  @override
  String get clientBookServiceLabel => 'Xizmat (ixtiyoriy)';

  @override
  String clientBookBookingCount(int count) {
    return '$count uchrashuv';
  }

  @override
  String get appointmentStatusUpcoming => 'Kelgusi';

  @override
  String get appointmentStatusCancelled => 'Bekor qilindi';

  @override
  String get appointmentStatusPostponed => 'Ko\'chirildi';

  @override
  String get appointmentStatusIncomplete => 'Bo\'lmadi';

  @override
  String get appointmentStatusCompleted => 'Yakunlandi';

  @override
  String get kelishuvAppointmentRequiredTitle => 'Uchrashuv sanasini belgilang';

  @override
  String get kelishuvAppointmentRequiredBody =>
      'Ikkala tom kelishuvni qabul qildi. Xizmat qachon bo\'lishini tanlang.';

  @override
  String get remindersSettingsFollowUpLabel =>
      'Uchrashuvdan keyin tekshirish (soat)';

  @override
  String get remindersFollowUpPrompt => 'Uchrashuv muvaffaqiyatli bo\'ldimi?';

  @override
  String get clientBookAppointmentHistory => 'Uchrashuv tarixi';

  @override
  String get clientBookAppointmentNotesLabel => 'Uchrashuv eslatmalari';

  @override
  String get clientBookPhotosLabel => 'Rasmlar';

  @override
  String get clientBookPhotosEmpty => 'Hali rasm yo\'q';

  @override
  String get clientBookAddPhoto => 'Rasm qo\'shish';

  @override
  String clientBookClientStats(int completed, int cancelled, int upcoming) {
    return '$completed yakunlandi · $cancelled bekor · $upcoming kelgusi';
  }

  @override
  String get remindersUpdateStatus => 'Holatni yangilash';

  @override
  String get remindersSettingsTitle => 'Eslatma sozlamalari';

  @override
  String get remindersSettingsAlertsLabel =>
      'Ogohlantirish vaqti (daqiqa oldin)';

  @override
  String get remindersSettingsAtTime => 'Vaqtida';

  @override
  String get earningsTitle => 'Mening daromadim';

  @override
  String get earningsTotal => 'Jami (e\'lon qilingan)';

  @override
  String get earningsEdit => 'Daromadni tahrirlash';

  @override
  String get earningsAdd => 'Daromad qo\'shish';

  @override
  String get earningsAmountLabel => 'Summa (UZS)';

  @override
  String get earningsNoteLabel => 'Izoh';

  @override
  String get earningsAmountRequired => 'Summani kiriting';

  @override
  String get earningsEmptyTitle => 'Daromad yozuvlari yo\'q';

  @override
  String get earningsEmptySub =>
      'Narxli kelishuvlar jarayonga o\'tganda avtomatik qo\'shiladi';

  @override
  String get earningsDisclaimer =>
      'Bu ma\'lumot faqat sizning shaxsiy hisobingiz. Soliq yoki rasmiy hisobot emas.';

  @override
  String get notificationsEmptySub =>
      'Kelishuv yangiliklari shu yerda paydo bo\'ladi';

  @override
  String get notificationKelishuvAccept => 'Kelishuv qabul qilindi';

  @override
  String get notificationKelishuvMessage => 'Yangi xabar';

  @override
  String get notificationKelishuvComplete => 'Ish yakunlandi';

  @override
  String get notificationGeneric => 'Bildirishnoma';

  @override
  String notificationTimeMinutes(int count) {
    return '$count daq';
  }

  @override
  String notificationTimeHours(int count) {
    return '$count soat';
  }

  @override
  String notificationTimeDate(int day, int month) {
    return '$day.$month';
  }

  @override
  String get reviewsTitle => 'Sharhlar';

  @override
  String get reviewProviderReplyLabel => 'Xizmat ko\'rsatuvchi javobi';

  @override
  String get reviewsEmpty => 'Hali sharh yo\'q';

  @override
  String get reviewsRate => 'Baholash';

  @override
  String xizmatCompletedCount(int count) {
    return '$count bajarilgan';
  }

  @override
  String get demoKelishuvBlocked => 'Demo rejimida kelishuv yaratib bo\'lmaydi';

  @override
  String get genericUser => 'Foydalanuvchi';

  @override
  String get actionPick => 'Tanlang';

  @override
  String get xizmatStepIdentity => '1/3 — Kim siz?';

  @override
  String get xizmatStepPortfolio => '2/3 — Portfolio';

  @override
  String get xizmatProviderIndividual => 'Jismoniy shaxs';

  @override
  String get xizmatProviderInstitution => 'Tashkilot';

  @override
  String get xizmatNameLabel => 'Xizmat nomi';

  @override
  String get xizmatDescriptionLabel => 'Qisqa tavsif';

  @override
  String get xizmatDescriptionFull => 'Tavsif';

  @override
  String get xizmatServiceCityLabel => 'Xizmat ko\'rsatiladigan shahar';

  @override
  String get xizmatServiceCityHint => 'Masalan: Toshkent (ixtiyoriy)';

  @override
  String get xizmatContinue => 'Davom etish';

  @override
  String get xizmatPortfolioHint =>
      'Kamida 1 ta rasm majburiy. Birinchi rasm asosiy ko\'rinish bo\'ladi.';

  @override
  String get xizmatHeroLabel => 'Asosiy';

  @override
  String get xizmatUploading => 'Yuklanmoqda…';

  @override
  String get xizmatReady => 'Tayyor';

  @override
  String get xizmatBack => 'Orqaga';

  @override
  String get xizmatSuccessTitle => 'Xizmatingiz tayyor!';

  @override
  String get xizmatSuccessBody =>
      'Portfolio yuklandi. Endi mijozlar xizmatingizni topa oladi.';

  @override
  String get xizmatEditTitle => 'Xizmatni tahrirlash';

  @override
  String get cannotRequestOwnXizmat =>
      'O\'z xizmatingizga so\'rov yuborib bo\'lmaydi';

  @override
  String get xizmatNotFound => 'Xizmat topilmadi';

  @override
  String get xizmatNoPermission => 'Ruxsat yo\'q';

  @override
  String get xizmatBasicInfo => 'Asosiy ma\'lumot';

  @override
  String get xizmatPortfolio => 'Portfolio';

  @override
  String get xizmatPortfolioEmpty =>
      'Portfolio bo\'sh. Kamida bitta rasm kerak.';

  @override
  String get xizmatAddPhoto => 'Rasm qo\'shish';

  @override
  String get xizmatSetHero => 'Asosiy qilish';

  @override
  String get xizmatAnalytics => 'Analitika';

  @override
  String get xizmatReviewReplies => 'Sharhlarga javob';

  @override
  String get xizmatSaved => 'Saqlanildi';

  @override
  String get xizmatReplySaved => 'Javob saqlandi';

  @override
  String get xizmatPickCategoryError => 'Soha va subsohani tanlang';

  @override
  String get yordamKerakPostTitle => 'Yordam Kerak e\'lon';

  @override
  String get yordamKerakTitleLabel => 'Sarlavha';

  @override
  String get yordamKerakTitleHint => 'Masalan: Santexnik kerak';

  @override
  String get yordamKerakMessageLabel => 'Loyiha tavsifi';

  @override
  String get yordamKerakMessageHint => 'Nima qilish kerak, qayerda va qachon?';

  @override
  String get yordamKerakBudgetLabel => 'Byudjet (ixtiyoriy, UZS)';

  @override
  String get yordamKerakDateLabel => 'Kerakli sana (ixtiyoriy)';

  @override
  String get yordamKerakDurationLabel => 'Davomiylik (daqiqa, ixtiyoriy)';

  @override
  String get yordamKerakPublish => 'E\'lon qilish';

  @override
  String get yordamKerakTitleTooShort =>
      'Sarlavha kamida 3 ta belgidan iborat bo\'lsin';

  @override
  String get yordamKerakMessageTooShort =>
      'Loyiha tavsifi kamida 10 ta belgidan iborat bo\'lsin';

  @override
  String get yordamKerakCategoryRequired => 'Sohani tanlang';

  @override
  String get yordamKerakSubcategoryRequired => 'Subsohani tanlang';

  @override
  String get userProfileTitle => 'Profil';

  @override
  String get userProfileNotFound => 'Profil topilmadi';

  @override
  String get userProfileServices => 'Xizmatlar';

  @override
  String get userProfileServicesEmpty => 'Hali xizmat yo\'q';

  @override
  String get userProfileRequests => 'Yordam Kerak e\'lonlari';

  @override
  String get userProfileRequestsEmpty => 'Ochiq e\'lon yo\'q';

  @override
  String get userProfileAvailable => 'Mavjud';

  @override
  String get userProfileBusy => 'Band';

  @override
  String get userProfilePartiallyBusy => 'Qisman band';

  @override
  String get userProfileCall => 'Qo\'ng\'iroq qilish';

  @override
  String get userProfilePhoneHidden => 'Telefon raqam yashirilgan';

  @override
  String get userProfileViewProfile => 'Profilni ko\'rish';

  @override
  String get xizmatProviderSection => 'Xizmat ko\'rsatuvchi';

  @override
  String get profileViewPublic => 'Ochiq profilim';

  @override
  String get profileCertificatesTitle => 'Sertifikatlar va malakalar';

  @override
  String get profileCertificatesSubtitle =>
      'Malaka hujjatlaringizni yuklang — mijozlar ko\'rib chiqadi';

  @override
  String get profileCertificatesDisclaimer =>
      'YordamBor yuklangan hujjatlarni tasdiqlamaydi. Mijozlar hujjatlarni o\'zlari tekshirishi kerak.';

  @override
  String get profileCertificatesAdd => 'Sertifikat qo\'shish';

  @override
  String get profileCertificatesTitleLabel => 'Sarlavha';

  @override
  String get profileCertificatesTitleHint =>
      'Masalan: Santexnika kursi sertifikati';

  @override
  String get profileCertificatesIssuerLabel => 'Kim bergan (ixtiyoriy)';

  @override
  String get profileCertificatesIssuerHint => 'Masalan: O\'quv markazi nomi';

  @override
  String get profileCertificatesEmpty => 'Hali sertifikat yuklanmagan';

  @override
  String get profileCertificatesMaxReached => 'Maksimal 8 ta sertifikat';

  @override
  String get profileCertificatesAdded => 'Sertifikat qo\'shildi';

  @override
  String get profileCertificatesRemoved => 'Sertifikat o\'chirildi';

  @override
  String get profileCertificatesRemoveTitle => 'Sertifikatni o\'chirasizmi?';

  @override
  String get xizmatOtherServices => 'Boshqa xizmatlar';

  @override
  String get xizmatViewAllServices => 'Barcha xizmatlarni ko\'rish';

  @override
  String get xizmatStatusAvailable => 'Mavjud';

  @override
  String get xizmatStatusBusy => 'Band';

  @override
  String get safetyTitle => 'Xavfsizlik';

  @override
  String get safetyBlock => 'Bloklash';

  @override
  String safetyBlockConfirmMessage(String name) {
    return '$name bloklaysizmi? Uning kontenti ko\'rinmaydi.';
  }

  @override
  String get safetyBlockDone => 'Foydalanuvchi bloklandi';

  @override
  String get safetyHideUser => 'Foydalanuvchini yashirish';

  @override
  String get safetyReportReason => 'Shikoyat sababi (ixtiyoriy)';

  @override
  String get safetyReportHint => 'Nima bo\'ldi?';

  @override
  String get safetyReportSubmit => 'Shikoyat yuborish';

  @override
  String get safetyReportDone => 'Shikoyat yuborildi. Rahmat.';

  @override
  String get reviewLater => 'Keyinroq';

  @override
  String get blockedUnblocked => 'Blokdan chiqarildi';

  @override
  String kelishuvMoreCount(int count) {
    return 'Yana $count ta';
  }

  @override
  String get demoPostPickReal => 'Demo e\'lon — haqiqiy e\'lon tanlang';

  @override
  String get createXizmatFirst => 'Avval xizmat profilingizni yarating';

  @override
  String get pickXizmat => 'Xizmat tanlang';

  @override
  String get categoryPickTitle => 'Soha tanlang';

  @override
  String get categoryAll => 'Barcha sohalar';

  @override
  String get subcategoryAll => 'Barcha subsohalar';

  @override
  String get analyticsViews => 'Ko\'rishlar';

  @override
  String get analyticsFavorites => 'Saqlangan';

  @override
  String get analyticsActiveDeals => 'Faol kelishuv';

  @override
  String get analyticsCompletedDeals => 'Bajarilgan';

  @override
  String analyticsConversion(String rate) {
    return 'Konversiya: $rate%';
  }

  @override
  String get kelishuvArchiveEmptyTitle => 'Arxiv bo\'sh';

  @override
  String get kelishuvArchiveEmptySub =>
      'Yakunlangan yoki bekor qilingan kelishuvlar shu yerda';

  @override
  String get kelishuvStatusNegotiating => 'Muzokarada';

  @override
  String get kelishuvStatusInProgress => 'Jarayonda';

  @override
  String get kelishuvStatusCompleted => 'Bajarildi';

  @override
  String get kelishuvStatusCancelled => 'Bekor qilindi';

  @override
  String get kelishuvStatusRejected => 'Rad etildi';

  @override
  String get kelishuvStatusArchived => 'Arxiv';

  @override
  String get busySlotTitle => 'Band vaqt';

  @override
  String busySlotMessage(String names) {
    return 'Bu sanada mijoz kitobingizda uchrashuv bor: $names. Baribir davom etasizmi?';
  }

  @override
  String taklifFlowTitleYordamBor(String name) {
    return 'Yordam Bor — $name';
  }

  @override
  String taklifFlowTitleYordamKerak(String name) {
    return 'Yordam Kerak — $name';
  }

  @override
  String get taklifTitle => 'Taklif yuborish';

  @override
  String get repeatBook => 'Qayta buyurtma';

  @override
  String get repeatBookTitle => 'Qayta buyurtma';

  @override
  String get taklifSubtitle =>
      'Xabar va narxni kelishuv boshida yuboring. Ikki tomon ham qabul qilgandan keyin ish jarayoni boshlanadi.';

  @override
  String get taklifMessageLabel => 'Xabar';

  @override
  String get taklifMessageHint => 'Qanday yordam bera olasiz?';

  @override
  String get taklifPriceLabel => 'Narx (ixtiyoriy, UZS)';

  @override
  String get taklifDateLabel => 'Sanani tanlang (ixtiyoriy)';

  @override
  String get taklifDurationLabel => 'Davomiylik (daqiqa, ixtiyoriy)';

  @override
  String get taklifSubmit => 'Taklif yuborish';

  @override
  String get reviewCommentLabel => 'Izoh (ixtiyoriy)';

  @override
  String get reviewCommentHint => 'Tajribangiz qanday bo\'ldi?';

  @override
  String get xizmatReplyLabel => 'Javobingiz';

  @override
  String get xizmatReplyHint => 'Mijozga javob yozing';

  @override
  String get xizmatClientLabel => 'Mijoz';

  @override
  String get kelishuvTermsDateLabel => 'Sanani tanlang';

  @override
  String get kelishuvTermsMessageLabel => 'Xabar';

  @override
  String get kelishuvTermsPriceLabel => 'Narx (UZS)';

  @override
  String kelishuvDetailPost(String title) {
    return 'E\'lon: $title';
  }

  @override
  String kelishuvDetailPrice(String amount, String currency) {
    return 'Narx: $amount $currency';
  }

  @override
  String kelishuvDetailTime(String slot) {
    return 'Vaqt: $slot';
  }

  @override
  String kelishuvSlotDateDuration(String date, int minutes) {
    return '$date · $minutes daqiqa';
  }

  @override
  String get xizmatPricingSectionTitle => 'Narx';

  @override
  String get xizmatPricingSectionSubtitle =>
      'Kelishiladi, belgilangan yoki soatlik — o\'zingiz tanlang.';

  @override
  String get xizmatPricingNegotiable => 'Kelishiladi';

  @override
  String get xizmatPricingFixed => 'Belgilangan';

  @override
  String get xizmatPricingHourly => 'Soatlik';

  @override
  String get xizmatPricingFixedRateLabel => 'Narxi (UZS)';

  @override
  String get xizmatPricingHourlyRateLabel => 'Soatlik stavka (UZS)';

  @override
  String get xizmatPricingRateHint => 'Masalan: 150000';

  @override
  String get xizmatPricingMinDurationLabel =>
      'Minimal davomiylik (daqiqa, ixtiyoriy)';

  @override
  String get xizmatPricingMinDurationHint => 'Masalan: 120';

  @override
  String get xizmatPricingRequiredError =>
      'Belgilangan yoki soatlik uchun narx kiriting';

  @override
  String get xizmatPriceNegotiable => 'Narx kelishiladi';

  @override
  String xizmatPricePerHour(String amount) {
    return '$amount/soat';
  }

  @override
  String get xizmatAvailabilitySectionTitle => 'Mavjudlik';

  @override
  String get xizmatAvailabilitySectionSubtitle =>
      'Ixtiyoriy — mijozlar band/emassizligingizni ko\'radi. Mijozlar kitobi buni o\'zgartirmaydi.';

  @override
  String get xizmatAvailabilityShowLabel => 'Mavjudlikni ko\'rsatish';

  @override
  String get xizmatAvailabilityShowSubtitle =>
      'O\'chirilgan bo\'lsa, hech qanday belgi ko\'rinmaydi';

  @override
  String get xizmatAvailabilityAvailableNow => 'Hozir mavjud';

  @override
  String get xizmatAvailabilityBusy => 'Band';

  @override
  String get xizmatAvailabilityCallMe => 'Qo\'ng\'iroq qiling';

  @override
  String get xizmatAvailabilityFromLabel => 'Dan (ixtiyoriy)';

  @override
  String get xizmatAvailabilityUntilLabel => 'Gacha (ixtiyoriy)';

  @override
  String xizmatAvailabilityUntilSuffix(String time) {
    return ' · $time gacha';
  }

  @override
  String xizmatAvailabilityFromSuffix(String time) {
    return ' · $time dan';
  }

  @override
  String xizmatAvailabilityRangeSuffix(String from, String until) {
    return ' · $from–$until';
  }

  @override
  String get xizmatAvailabilityModeRequiredError => 'Mavjudlik turini tanlang';

  @override
  String get xizmatAvailabilityWindowInvalidError =>
      'Tugash vaqti boshlanishdan keyin bo\'lishi kerak';

  @override
  String get xizmatPromiseSectionTitle => 'Va\'dam';

  @override
  String get xizmatPromiseSectionSubtitle =>
      'Mijozlarga nima va\'da qilishingizni yozing. Bu sizning shioringiz — YordamBor kafolati emas.';

  @override
  String get xizmatPromiseShowLabel => 'Va\'damni ko\'rsatish';

  @override
  String get xizmatPromiseShowSubtitle => 'E\'londa mijozlar ko\'radi';

  @override
  String get xizmatPromisePresetsLabel =>
      'Tezkor shablonlar (tahrirlash mumkin)';

  @override
  String get xizmatPromiseFieldLabel => 'Va\'dangiz';

  @override
  String get xizmatPromiseFieldHint =>
      'O\'zingiz yozing yoki shablonni tahrirlang';

  @override
  String get xizmatPromisePreset1 => 'Mamnun qolmasangiz, qayta bajaraman';

  @override
  String get xizmatPromisePreset2 =>
      'Sifatga kafolat — muammo bo\'lsa, pulingizni qaytaraman';

  @override
  String get xizmatPromisePreset3 => 'Vaqtida va kelishilgan narxda';

  @override
  String get xizmatPromiseDisclaimer =>
      'YordamBor kafolat bermaydi. Bu xizmat ko\'rsatuvchining o\'z so\'zi.';

  @override
  String get xizmatPromiseRequiredError =>
      'Va\'dangizni yozing yoki o\'chiring';

  @override
  String get xizmatPromiseTooLongError => 'Va\'da juda uzun';

  @override
  String get settingsHelp => 'Yordam va qo\'llab-quvvatlash';

  @override
  String get supportReportTitle => 'Muammo haqida xabar';

  @override
  String get supportReportSubtitle => 'Xato, hisob yoki to\'lov muammosi';

  @override
  String get supportCategoryLabelField => 'Kategoriya';

  @override
  String get supportCategoryBug => 'Xato';

  @override
  String get supportCategoryAccount => 'Hisob';

  @override
  String get supportCategoryPayment => 'To\'lov muammosi';

  @override
  String get supportCategoryOther => 'Boshqa';

  @override
  String get supportDescriptionLabel => 'Tavsif';

  @override
  String get supportDescriptionHint => 'Nima bo\'lganini yozing…';

  @override
  String get supportSubmit => 'Yuborish';

  @override
  String get supportSubmitted => 'Rahmat — xabaringiz qabul qilindi';

  @override
  String get supportLoginRequired => 'Xabar yuborish uchun kiring';

  @override
  String get supportContactHint => 'Qo\'llab-quvvatlash: eeshbaev@outlook.com';

  @override
  String get supportMailtoFailed => 'Email ilovasini ochib bo\'lmadi';

  @override
  String get feedbackTitle => 'Fikr-mulohaza';

  @override
  String get feedbackSubtitle => 'YordamBor\'ni yaxshilashga yordam bering';

  @override
  String get feedbackMessageLabel => 'Fikringiz';

  @override
  String get feedbackMessageHint => 'Nima yaxshilanishi mumkin?';

  @override
  String get feedbackSubmit => 'Yuborish';

  @override
  String get feedbackThanks => 'Fikringiz uchun rahmat';

  @override
  String get feedbackOpenFromSheet =>
      'Fikr yuborish uchun Yordam bo\'limidan foydalaning.';

  @override
  String get appReviewTitle => 'YordamBor yoqayaptimi?';

  @override
  String get appReviewSubtitle =>
      'Bahongiz boshqalarga ishonchli ustalar topishga yordam beradi.';

  @override
  String get appReviewYes => 'Ha, juda yoqadi';

  @override
  String get appReviewNo => 'Unchalik emas';

  @override
  String get appReviewLater => 'Keyinroq';

  @override
  String get providerProgressTitle => 'Sizning rivojingiz';

  @override
  String get providerProgressSubtitle =>
      'Obro\'ingizni bosqichma-bosqich quring';

  @override
  String get providerTierNew => 'Yangi';

  @override
  String get providerTierActive => 'Faol';

  @override
  String get providerTierTrusted => 'Ishonchli';

  @override
  String get providerTierTop => 'Top usta';

  @override
  String providerJobsRating(int jobs, String rating) {
    return '$jobs ish · $rating★';
  }

  @override
  String providerNextMilestone(int count, String tier) {
    return 'Yana $count ta ish → $tier';
  }

  @override
  String get providerTipsTitle => 'Keyingi qadamlar';

  @override
  String get progressTipAddCertificate => 'Ishonch uchun sertifikat qo\'shing';

  @override
  String get progressTipSetAvailability => 'E\'londa mavjudlikni ko\'rsating';

  @override
  String get progressTipReplyReviews => 'Sharhlarga javob bering';

  @override
  String get progressTipAddPortfolio => 'Portfolio rasmlarini ko\'paytiring';

  @override
  String get progressTipSetPricing => 'Qat\'iy yoki soatbay narx belgilang';

  @override
  String get progressTipRepeatClients =>
      'Mamnun mijozlardan qayta buyurtma so\'rang';

  @override
  String get achievementsTitle => 'Yutuqlar';

  @override
  String get achievementsEmptySub =>
      'Hali yutuq yo\'q. Ishlarni bajaring va profilni rivojlantiring.';

  @override
  String get achievementFirstXizmat => 'Birinchi xizmat';

  @override
  String get achievementFirstDeal => 'Birinchi bajarilgan ish';

  @override
  String get achievementJobs5 => '5 ta ish';

  @override
  String get achievementJobs10 => '10 ta ish';

  @override
  String get achievementJobs25 => '25 ta ish';

  @override
  String get achievementFirstFiveStar => 'Birinchi 5★';

  @override
  String get achievementCertificate => 'Sertifikat yuklandi';

  @override
  String get achievementRepeatClient => 'Doimiy mijoz (3+ ish)';

  @override
  String get achievementBodyFirstXizmat =>
      'YordamBor\'da birinchi xizmatingizni yaratdingiz.';

  @override
  String get achievementBodyFirstDeal =>
      'Birinchi kelishuvingiz yakunlandi. Davom eting!';

  @override
  String get achievementBodyJobs5 => 'Beshta ish — mijozlar sizni payqayapti.';

  @override
  String get achievementBodyJobs10 =>
      'O\'n bajarilgan ish. Haqiqiy obro\' quryapsiz.';

  @override
  String get achievementBodyJobs25 =>
      'Yigirma besh ish. Eng yaxshi ustalar qatoridasiz.';

  @override
  String get achievementBodyFirstFiveStar =>
      'Mijoz 5 yulduz berdi. Tabriklaymiz!';

  @override
  String get achievementBodyCertificate =>
      'Guvohnomalaringiz profilda ko\'rinadi.';

  @override
  String get achievementBodyRepeatClient =>
      'Bir mijoz sizni uch marta yoki undan ko\'p chaqirdi.';

  @override
  String get actionContinue => 'Davom etish';

  @override
  String get guidesTitle => 'Biznes maslahatlari';

  @override
  String get guidesSubtitle => 'Xizmatingizni bosqichma-bosqich o\'stiring';

  @override
  String get guideXizmatConvertsTitle => 'Sotadigan e\'lon yarating';

  @override
  String get guidePricingTitle => 'Narx: qat\'iy yoki soatbay';

  @override
  String get guideRepeatClientsTitle => 'Qayta buyurtma oling';

  @override
  String get guideCertificatesTitle => 'Sertifikatlar va ishonch';

  @override
  String get guideReviewRepliesTitle => 'Sharhlarga professional javob';

  @override
  String get guideXizmatConvertsBody =>
      'Aniq sarlavha, haqiqiy portfolio va subsoha tanlang. Narx yoki kelishuvchan deb yozing. Mavjudlikni ko\'rsating.';

  @override
  String get guidePricingBody =>
      'Qat\'iy narx aniq ishlar uchun. Soatbay tozalash, repetitorlik uchun mos. Kelishuvchan ham bo\'ladi — boshlang\'ich narx ko\'proq murojaat oladi.';

  @override
  String get guideRepeatClientsBody =>
      'Sifatli ish qiling, tez javob bering. Mamnun mijozlardan kelishuvdan keyin Qayta buyurtma tugmasini ishlating.';

  @override
  String get guideCertificatesBody =>
      'Mijozlar ko\'radigan malaka hujjatlarini yuklang. YordamBor hujjatlarni tasdiqlamaydi — ular ishonch uchun yordam beradi.';

  @override
  String get guideReviewRepliesBody =>
      'Har bir sharhga muloyim javob bering. 5★ uchun rahmat ayting. Tanqidga professional javob bering — kelajakdagi mijozlar o\'qiydi.';

  @override
  String get safetyPaymentsBanner =>
      'Faqat kelishilgan tartibda to\'lang. YordamBor pul o\'tkazmaydi va platformadan tashqari to\'lovlar uchun javobgar emas.';

  @override
  String get settingsSafety => 'Xavfsizlik va to\'lovlar';

  @override
  String get legalSafetyTitle => 'Xavfsizlik va to\'lovlar';

  @override
  String get legalSafetyBody =>
      'YordamBor mijoz va ustani bog\'laydi. Xizmat ko\'rsatmaydi, pul saqlamaydi va natijaga kafolat bermaydi.\n\nTo\'lovlar\n\nTo\'lovlar to\'g\'ridan-to\'g\'ri siz va boshqa tomom o\'rtasida kelishiladi. Ishonchsiz odamga oldindan to\'liq pul yubormang. YordamBor firibgarlik yoki nizo uchun javobgar emas.\n\nSizning mas\'uliyatingiz\n\nGuvohnoma, sharh va sertifikatlarni o\'zingiz tekshiring.\n\nXabar berish\n\nHaqorat uchun ilovadan shikoyat qiling. Texnik muammo uchun Yordam bo\'limidan foydalaning.';
}
