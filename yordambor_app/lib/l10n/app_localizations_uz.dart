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
  String get splashTagline => 'YordamBor’da yordam bor!';

  @override
  String get tabHome => 'Asosiy';

  @override
  String get tabCalendar => 'Kalendar';

  @override
  String get calendarGuestSubtitle =>
      'Jadvalingiz va bandlikni belgilash uchun kiring.';

  @override
  String get calendarProviderHint =>
      'Kalendar kuniga bosing, keyin boʻsh yoki band deb belgilang.';

  @override
  String get calendarClientHint =>
      'Uchrashuvlar va eslatmalar kalendarda koʻrinadi. Batafsil uchun kunni bosing.';

  @override
  String get calendarLegendAvailable => 'Boʻsh';

  @override
  String get calendarLegendBusy => 'Band';

  @override
  String get calendarLegendAppointment => 'Uchrashuv';

  @override
  String get calendarMarkAvailable =>
      'Belgi: boʻsh — oʻzgartirish uchun bosing';

  @override
  String get calendarMarkBusy => 'Belgi: band — oʻzgartirish uchun bosing';

  @override
  String get calendarMarkUnset => 'Kunni belgilang: boʻsh / band';

  @override
  String get calendarNoEventsDay => 'Bu kunda uchrashuv yoʻq.';

  @override
  String get calendarWeekdayMon => 'Du';

  @override
  String get calendarWeekdayTue => 'Se';

  @override
  String get calendarWeekdayWed => 'Ch';

  @override
  String get calendarWeekdayThu => 'Pa';

  @override
  String get calendarWeekdayFri => 'Ju';

  @override
  String get calendarWeekdaySat => 'Sh';

  @override
  String get calendarWeekdaySun => 'Ya';

  @override
  String get tabFavorites => 'Saqlangan';

  @override
  String get tabBusiness => 'Biznes';

  @override
  String get businessTabServices => 'Xizmatlar';

  @override
  String get businessTabTools => 'Instrumentlar';

  @override
  String get businessToolsSubtitle =>
      'Mijoz kitobi, kvitansiya, daromad va boshqa provayder asboblari.';

  @override
  String get myXizmatlarGuestSubtitle =>
      'Xizmatlar va provayder asboblarini boshqarish uchun kiring.';

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
  String get filterProviderTypeHint => 'Xizmat koʻrsatuvchi turini tanlang';

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
  String get filterCategoryHint => 'Qaysi soha boʻyicha qidiryapsiz?';

  @override
  String get filterAllCategoriesHint => 'Barcha sohalardagi xizmatlar';

  @override
  String get filterAllSubcategoriesHint =>
      'Tanlangan sohadagi barcha yoʻnalishlar';

  @override
  String get filterCity => 'Shahar';

  @override
  String get filterAllCities => 'Barcha shaharlar';

  @override
  String get filterCityHint => 'Qaysi shaharda xizmat kerak?';

  @override
  String get filterAllCitiesHint => 'Barcha shaharlardagi eʼlonlar';

  @override
  String get xizmatServiceCityRequired =>
      'Xizmat koʻrsatadigan shaharni tanlang';

  @override
  String get serviceCityToshkent => 'Toshkent';

  @override
  String get serviceCityToshkentViloyati => 'Toshkent viloyati';

  @override
  String get serviceCitySamarqand => 'Samarqand';

  @override
  String get serviceCityBuxoro => 'Buxoro';

  @override
  String get serviceCityNukus => 'Nukus';

  @override
  String get serviceCityNamangan => 'Namangan';

  @override
  String get serviceCityAndijon => 'Andijon';

  @override
  String get serviceCityFargona => 'Fargʻona';

  @override
  String get serviceCityQarshi => 'Qarshi';

  @override
  String get serviceCityUrganch => 'Urganch';

  @override
  String get serviceCityTermiz => 'Termiz';

  @override
  String get serviceCityJizzax => 'Jizzax';

  @override
  String get serviceCityNavoiy => 'Navoiy';

  @override
  String get serviceCityQoqon => 'Qoʻqon';

  @override
  String get serviceCityGuliston => 'Guliston';

  @override
  String get serviceCityBoshqa => 'Boshqa';

  @override
  String homeFeedShowing(String summary) {
    return 'Koʻrsatilmoqda: $summary';
  }

  @override
  String get filterPickProviderTypeFirst =>
      'Avval jismoniy shaxs yoki tashkilotni tanlang';

  @override
  String get homeEmptyTitle => 'Tez orada xizmatlar paydo boʻladi';

  @override
  String get homeEmptySubtitle =>
      'Turli sohalardagi xizmatlar portfolio bilan qoʻshiladi';

  @override
  String get homeDemoXizmat => 'Demo xizmatlar namuna sifatida koʻrsatilmoqda';

  @override
  String get homeDemoPosts => 'Demo eʼlonlar namuna sifatida koʻrsatilmoqda';

  @override
  String get homeJobsEmptyTitle => 'Yordam Kerak eʼlonlari';

  @override
  String get homeJobsEmptySubtitle =>
      'Birinchi eʼlonni yuboring yoki filtrlarni oʻzgartiring';

  @override
  String get favoritesEmptyTitle => 'Yoqtirgan xizmatlaringizni saqlang';

  @override
  String get favoritesEmptySubtitle => 'Kartadagi ♥ tugmasini bosing';

  @override
  String get profileGuestTitle => 'YordamBor’ga xush kelibsiz';

  @override
  String get profileGuestSubtitle =>
      'Kelishuvlar va eʼlonlar uchun roʻyxatdan oʻting. Sevimlilar hisobsiz saqlanadi.';

  @override
  String get profilePhone => 'Telefon';

  @override
  String get profileChangePhoto => 'Rasmni oʻzgartirish';

  @override
  String get profilePhotoUpdated => 'Profil rasmi yangilandi';

  @override
  String get profilePhotoFailed => 'Rasmni yuklab boʻlmadi';

  @override
  String get login => 'Kirish';

  @override
  String get register => 'Roʻyxatdan oʻtish';

  @override
  String get notificationsTitle => 'Bildirishnomalar';

  @override
  String get notificationsEmpty => 'Hali bildirishnomalar yoʻq';

  @override
  String get fabPostYordamKerak => 'Eʼlon qoldirish';

  @override
  String get welcomeTitle => 'YordamBor’da Yordam bor!';

  @override
  String get welcomeBrand => 'YordamBor.';

  @override
  String get welcomeBody =>
      'Turli xizmatlarni toping. Yordam bering yoki yordam soʻrang.';

  @override
  String get startBrowsing => 'Boshlash';

  @override
  String get createAccount => 'Roʻyxatdan oʻtish';

  @override
  String get alreadyHaveAccount => 'Allaqachon hisobingiz bormi?';

  @override
  String get authContinueTitle => 'Davom etish uchun kiring';

  @override
  String get authContextGeneric => 'Davom etish uchun kiring';

  @override
  String get authContextFavorite => 'Sevimlilarga saqlash uchun kiring';

  @override
  String get authContextYordamKerak => 'Ustaga soʻrov yuborish uchun kiring';

  @override
  String get authContextYordamBor => 'Taklif yuborish uchun kiring';

  @override
  String get authContextPostJob => 'Eʼlon qoldirish uchun kiring';

  @override
  String get authContextDeal => 'Kelishuv boshlash uchun kiring';

  @override
  String get later => 'Keyinroq';

  @override
  String get fullName => 'Toʻliq ism';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Telefon';

  @override
  String get password => 'Parol';

  @override
  String get confirmPassword => 'Parol takror';

  @override
  String get fieldRequired => 'Bu maydon toʻldirilishi shart';

  @override
  String get invalidEmail => 'Email manzilini toʻgʻri kiriting';

  @override
  String get invalidPhone => 'Telefon raqamini toʻgʻri kiriting (+998…)';

  @override
  String get invalidNumber => 'Raqamni toʻgʻri kiriting';

  @override
  String get invalidMinutes => 'Daqiqalarni toʻgʻri kiriting';

  @override
  String get passwordTooShort =>
      'Parol kamida 8 belgidan iborat boʻlishi kerak';

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
      'Havolani telefoningizda oching. Ilova ochilgach yangi parol oʻrnatishingiz mumkin.';

  @override
  String get resetPasswordExpiredTitle => 'Havola muddati tugagan';

  @override
  String get resetPasswordExpiredBody =>
      'Parolni tiklash havolasini qayta soʻrang.';

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
      'Emailingizga tasdiqlash havolasi yubordik. Havolani ochgandan keyin “Tasdiqladim” tugmasini bosing.';

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
  String get continueBrowsing => 'Koʻrib chiqishni davom eting';

  @override
  String welcomeBack(String name) {
    return 'Xush kelibsiz, $name!';
  }

  @override
  String get welcomeGuestName => 'doʻstim';

  @override
  String welcomeNewTitle(String name) {
    return 'Xush kelibsiz, $name!';
  }

  @override
  String get welcomeNewBody =>
      'YordamBor oilasiga qoʻshilganingiz bilan tabriklaymiz! Xizmat toping, yordam bering yoki eʼlon qoldiring — biz har qadamda siz bilan birgamiz.';

  @override
  String welcomeLoginTitle(String name) {
    return 'Yana xush kelibsiz, $name!';
  }

  @override
  String get welcomeLoginBody =>
      'Sizni yana koʻrganimizdan xursandmiz. Bugun qanday yordam kerak?';

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
  String get providerPromptTitle => 'Xizmat koʻrsatasizmi?';

  @override
  String get providerPromptBody =>
      'Portfolio qoʻshing — mijozlar xizmatingizni topa oladi.';

  @override
  String get createXizmat => 'Xizmat yaratish';

  @override
  String get signOut => 'Chiqish';

  @override
  String get settings => 'Sozlamalar';

  @override
  String get settingsSubtitle => 'Til, maxfiylik, hisob';

  @override
  String get settingsAppearance => 'Koʻrinish';

  @override
  String get settingsDarkMode => 'Mavzu';

  @override
  String get settingsThemeSystem => 'Tizim';

  @override
  String get settingsThemeLight => 'Yorugʻ';

  @override
  String get settingsThemeDark => 'Qorongʻu';

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
  String get settingsShowPhoneLabel => 'Profilimda telefon koʻrsatilsin';

  @override
  String get settingsShowPhoneSubtitle =>
      'Ochiq profilingizda telefon raqamingiz koʻrinadi';

  @override
  String get postContactSectionTitle => 'Aloqa';

  @override
  String get postContactSectionSubtitle =>
      'Profil har doim ochiq. Telefon raqamini koʻrsatish ixtiyoriy.';

  @override
  String get postContactPhoneLabel => 'Telefon raqami';

  @override
  String get postContactPhoneHint => '+998 90 123 45 67';

  @override
  String get postContactPhoneOptional => 'Ixtiyoriy';

  @override
  String get postShowPhoneLabel => 'Telefon raqamini koʻrsatish';

  @override
  String get postShowPhoneSubtitle => 'Bu eʼlonda telefon raqamingiz koʻrinadi';

  @override
  String get postShowProfileLabel => 'Profilni koʻrsatish';

  @override
  String get postShowProfileSubtitle =>
      'Foydalanuvchilar profilingizni koʻra oladi';

  @override
  String get postAuthorHidden => 'Muallif yashirin';

  @override
  String get settingsTerms => 'Foydalanish shartlari';

  @override
  String get settingsDeleteAccount => 'Hisobni oʻchirish';

  @override
  String get settingsDeleteAccountHint => 'Barcha kelishuvlar bekor qilinadi';

  @override
  String get settingsDeleteAccountConfirm =>
      'Barcha maʼlumotlaringiz, xizmatlar va faol kelishuvlar oʻchiriladi. Bu amalni qaytarib boʻlmaydi.';

  @override
  String get settingsDeleteAccountAction => 'Hisobni oʻchirish';

  @override
  String get settingsDeleteAccountDone => 'Hisobingiz oʻchirildi';

  @override
  String get remindersTitle => 'Eslatmalar';

  @override
  String get remindersAdd => 'Eslatma qoʻshish';

  @override
  String get remindersEmptyTitle => 'Eslatmalar yoʻq';

  @override
  String get remindersEmptySubtitle =>
      'Mijoz kitobi kalendari bilan sinxron. Kelishuv boshlanganda ham yaratiladi';

  @override
  String get remindersFieldClientName => 'Mijoz ismi';

  @override
  String get remindersUpcoming => 'Kelgusi';

  @override
  String get remindersPast => 'Oʻtgan';

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
      'YordamBor shaxsiy maʼlumotlaringizni faqat xizmat koʻrsatish, kelishuvlar va xavfsizlik uchun ishlatadi.\n\n1. Qanday maʼlumotlar toʻplanadi\n\nIsm, email, telefon, xizmat portfolio rasmlari, kelishuv xabarlari va bildirishnomalar.\n\n2. Qayerda saqlanadi\n\nMaʼlumotlar Supabase serverlarida shifrlangan holda saqlanadi.\n\n3. Uchinchi tomonlar\n\nMaʼlumotlaringiz sotilmaydi. Faqat xizmat koʻrsatish uchun zarur boʻlgan texnik hamkorlar (hosting, email) bilan cheklangan.\n\n4. Sizning huquqlaringiz\n\nMaʼlumotlaringizni koʻrish, yangilash yoki hisobni oʻchirish huquqiga egasiz.\n\n5. Aloqa\n\nSavollar boʻyicha ilova ichidagi Sozlamalar boʻlimidan murojaat qiling.';

  @override
  String get legalTermsBody =>
      'YordamBor — turli sohalardagi xizmat koʻrsatuvchilar va mijozlarni bogʻlovchi mobil platforma. Platformadan foydalanish ushbu shartlarga rozilik bildirish hisoblanadi.\n\n1. Umumiy qoidalar\n\nYordamBor xizmatlarni taqdim etmaydi; u faqat tomonlarni bogʻlaydi. Platforma toʻlov vositachisi emas.\n\n2. Hisob va roʻyxatdan oʻtish\n\nToʻgʻri va yangilangan maʼlumotlarni taqdim etishingiz kerak. Email manzilingizni tasdiqlashingiz lozim.\n\n3. Xizmatlar va portfolio\n\nXizmat eʼlonida kamida bitta haqiqiy portfolio rasmi boʻlishi shart. Yolgʻon, chalgʻituvchi yoki noqonuniy eʼlonlar oʻchirilishi mumkin.\n\n4. Kelishuvlar (Yordam Bor / Yordam Kerak)\n\nNarx, muddat va ish tavsifi tomonlar oʻrtasida kelishiladi. YordamBor kelishuv jarayonini saqlaydi, lekin toʻlovni qabul qilmaydi.\n\n5. Taqiqlangan harakatlar\n\nFiribgarlik, haqorat, spam, noqonuniy xizmatlar yoki platforma qoidalarini ataylab buzish taqiqlanadi.\n\n6. Hisobni bloklash\n\nQoidalar buzilganda YordamBor hisobni vaqtincha yoki doimiy toʻxtatish huquqiga ega.\n\n7. Oʻzgarishlar\n\nShartlar yangilanishi mumkin. Davom etish yangilangan shartlarga rozilik hisoblanadi.\n\n8. Aloqa\n\nSavollar boʻyicha ilova ichidagi Sozlamalar boʻlimidan murojaat qiling.';

  @override
  String get shareXizmat => 'Ulashish';

  @override
  String shareXizmatMessage(String name) {
    return 'YordamBor’da $name xizmatini koʻring';
  }

  @override
  String get shareYordamKerak => 'Eʼlonni ulashish';

  @override
  String shareYordamKerakMessage(String title) {
    return 'Yordam kerak: $title — YordamBor';
  }

  @override
  String get postNotFound => 'Eʼlon topilmadi';

  @override
  String get shareCopied => 'Havola nusxalandi';

  @override
  String get actionSave => 'Saqlash';

  @override
  String get actionCancel => 'Bekor';

  @override
  String get actionEdit => 'Tahrirlash';

  @override
  String get actionDelete => 'Oʻchirish';

  @override
  String get actionView => 'Koʻrish';

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
  String get kelishuvNoMessages => 'Hali xabar yoʻq';

  @override
  String get kelishuvOpeningOffer => 'Boshlangʻich taklif';

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
      'Shartlar oʻzgardi — ikkala tomon ham qayta tasdiqlashi kerak';

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
      'Ishni tugatish jarayon boshlanganidan 3 kun oʻtgach mumkin';

  @override
  String kelishuvCompleteDaysLeft(int days) {
    return 'Tugatishni belgilash uchun $days kun qoldi';
  }

  @override
  String get kelishuvMessageHint => 'Xabar yozing…';

  @override
  String get kelishuvIncoming => 'Menga kelgan';

  @override
  String get kelishuvIncomingSub => 'Xizmatlaringizga kelgan soʻrovlar';

  @override
  String get kelishuvRequests => 'Mening soʻrovlarim';

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
  String get profileClientBookSub => 'Mahalliy mijozlar roʻyxati';

  @override
  String get profileEarnings => 'Mening daromadim';

  @override
  String get profileEarningsSub => 'Eʼlon qilingan daromad';

  @override
  String get profileMargin => 'Foyda';

  @override
  String get profileMarginSub => 'Asl narx va foyda';

  @override
  String get profilePaymentReceipt => 'Toʻlov kvitansiyasi';

  @override
  String get profilePaymentReceiptSub => 'Xizmatlar uchun PDF kvitansiya';

  @override
  String get receiptTitle => 'Toʻlov kvitansiyalari';

  @override
  String get receiptNew => 'Yangi kvitansiya';

  @override
  String get receiptEmptyTitle => 'Kvitansiyalar yoʻq';

  @override
  String get receiptEmptySubtitle =>
      'Mijoz uchun toʻlov kvitansiyasi yarating va PDF sifatida ulashing.';

  @override
  String get receiptDocumentTitle => 'TOʻLOV KVITANSIYASI';

  @override
  String get receiptNumber => 'Raqam';

  @override
  String get receiptDate => 'Sana';

  @override
  String get receiptSeller => 'Kimdan';

  @override
  String get receiptBuyer => 'Kimga';

  @override
  String get receiptBuyerName => 'Mijoz ismi';

  @override
  String get receiptBuyerPhone => 'Mijoz telefoni';

  @override
  String get receiptPickClient => 'Mijoz kitobidan tanlash';

  @override
  String get receiptXizmat => 'Xizmat';

  @override
  String get receiptLines => 'Pozitsiyalar';

  @override
  String get receiptLineTitle => 'Tavsif';

  @override
  String get receiptQuantity => 'Miqdor';

  @override
  String get receiptUnitPrice => 'Narx';

  @override
  String get receiptLineTotal => 'Summa';

  @override
  String get receiptAddLine => 'Qoʻshish';

  @override
  String get receiptDiscount => 'Chegirma';

  @override
  String get receiptTaxEnable => 'Soliq qoʻshish';

  @override
  String get receiptTaxRate => 'Soliq stavkasi (%)';

  @override
  String get receiptTaxLabel => 'Soliq nomi';

  @override
  String get receiptTaxDisclaimer =>
      'Soliq stavkasini oʻzingiz tanlaysiz. YordamBor soliq maslahati bermaydi.';

  @override
  String get receiptSubtotal => 'Oraliq summa';

  @override
  String get receiptTotal => 'Jami';

  @override
  String get receiptNote => 'Izoh';

  @override
  String get receiptDueDate => 'Toʻlov muddati';

  @override
  String get receiptCurrency => 'Valyuta';

  @override
  String get receiptCurrencyUzs => 'UZS';

  @override
  String get receiptCurrencyUsd => 'USD';

  @override
  String get receiptSharePdf => 'PDF ulashish';

  @override
  String get receiptPreview => 'PDF koʻrish';

  @override
  String get receiptSaved => 'Kvitansiya saqlandi';

  @override
  String get receiptValidationBuyer => 'Mijoz ismini kiriting';

  @override
  String get receiptValidationXizmat => 'Xizmatni tanlang';

  @override
  String get receiptValidationLines =>
      'Kamida bitta pozitsiya va narx kiriting';

  @override
  String get receiptFooterBranding => 'YordamBor orqali yaratildi';

  @override
  String get receiptDeleteConfirm => 'Ushbu kvitansiya oʻchirilsinmi?';

  @override
  String get receiptTaxPresetCustom => 'Boshqa';

  @override
  String get marginTitle => 'Foyda';

  @override
  String get marginUnitsTitle => 'Birliklar kitobxonasi';

  @override
  String get marginUnitsSubtitle =>
      'Tez hisob uchun narx bilan qayta ishlatiladigan birliklar';

  @override
  String get marginOpenUnits => 'Birliklar';

  @override
  String get marginAddUnit => 'Birlik qoʻshish';

  @override
  String get marginEditUnit => 'Birlikni tahrirlash';

  @override
  String get marginUnitName => 'Birlik nomi';

  @override
  String get marginUnitCost => 'Birlik narxi (UZS)';

  @override
  String get marginUnitBasis => 'Narx asosi (ixtiyoriy)';

  @override
  String get marginUnitBasisHint => 'masalan: soat, kg, dona';

  @override
  String get marginUnitsEmptyTitle => 'Hali birlik yoʻq';

  @override
  String get marginUnitsEmptySub =>
      'Tez-tez ishlatadigan birliklaringizni saqlang — mehnat, material, qadoq.';

  @override
  String get marginAddProduct => 'Mahsulot qoʻshish';

  @override
  String get marginEditProduct => 'Mahsulotni tahrirlash';

  @override
  String get marginProductName => 'Mahsulot nomi';

  @override
  String get marginSalePrice => 'Sotuv narxi (UZS)';

  @override
  String get marginCostTotal => 'Umumiy xarajat';

  @override
  String get marginProfit => 'Foyda';

  @override
  String get marginMarginPercent => 'Marja';

  @override
  String get marginCostBreakdown => 'Xarajat tarkibi';

  @override
  String get marginAddLine => 'Birlik qatorini qoʻshish';

  @override
  String get marginEditLine => 'Qatorni tahrirlash';

  @override
  String get marginLineName => 'Birlik / element nomi';

  @override
  String get marginLineQuantity => 'Miqdor';

  @override
  String get marginLineUnitCost => 'Birlik narxi (UZS)';

  @override
  String get marginLineQuantityLabel => 'Miqdor belgisi (ixtiyoriy)';

  @override
  String get marginLineQuantityLabelHint => 'masalan: soat, kg, dona';

  @override
  String get marginSelectUnit => 'Kitobxonadan tanlash';

  @override
  String get marginCustomLine => 'Qoʻlda qator';

  @override
  String get marginProductsEmptyTitle => 'Hali mahsulot yoʻq';

  @override
  String get marginProductsEmptySub =>
      'Xarajat, foyda va marjani koʻrish uchun mahsulot yoki xizmat qoʻshing.';

  @override
  String get marginNameRequired => 'Nom kiriting';

  @override
  String get marginPriceRequired => 'Sotuv narxini kiriting';

  @override
  String get marginCostRequired => 'Narx kiriting';

  @override
  String get marginQuantityRequired => 'Miqdor kiriting';

  @override
  String get marginAvgMargin => 'Oʻrtacha marja';

  @override
  String get marginPerProduct => 'mahsulot uchun';

  @override
  String get marginDeleteProduct => 'Mahsulotni oʻchirish';

  @override
  String get marginDeleteUnit => 'Birlikni oʻchirish';

  @override
  String get profileMyXizmatlar => 'Mening xizmatlarim';

  @override
  String get profileSetAvailability => 'Mavjudlikni belgilash';

  @override
  String get profileSectionLoadFailed =>
      'Yuklab boʻlmadi. Internet aloqasini tekshiring.';

  @override
  String get actionRetry => 'Qayta urinish';

  @override
  String get clientBookTitle => 'Mijoz kitobi';

  @override
  String get clientBookList => 'Roʻyxat';

  @override
  String get clientBookCalendar => 'Kalendar';

  @override
  String get clientBookOpenDeal => 'Kelishuvni ochish';

  @override
  String get clientBookEditClient => 'Mijozni tahrirlash';

  @override
  String get clientBookAdd => 'Mijoz qoʻshish';

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
  String get clientBookEmptyTitle => 'Mijozlar kitobi boʻsh';

  @override
  String get clientBookEmptySub =>
      'Kalendarda mijoz yozing yoki kelishuv boshlanganda qoʻshiladi';

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
  String get appointmentStatusPostponed => 'Koʻchirildi';

  @override
  String get appointmentStatusIncomplete => 'Boʻlmadi';

  @override
  String get appointmentStatusCompleted => 'Yakunlandi';

  @override
  String get kelishuvAppointmentRequiredTitle => 'Uchrashuv sanasini belgilang';

  @override
  String get kelishuvAppointmentRequiredBody =>
      'Ikkala tom kelishuvni qabul qildi. Xizmat qachon boʻlishini tanlang.';

  @override
  String get remindersSettingsFollowUpLabel => 'Uchrashuvdan keyin tekshirish';

  @override
  String get remindersFollowUpPrompt => 'Uchrashuv muvaffaqiyatli boʻldimi?';

  @override
  String get clientBookAppointmentHistory => 'Uchrashuv tarixi';

  @override
  String get clientBookAppointmentNotesLabel => 'Uchrashuv eslatmalari';

  @override
  String get clientBookPhotosLabel => 'Rasmlar';

  @override
  String get clientBookPhotosEmpty => 'Hali rasm yoʻq';

  @override
  String get clientBookAddPhoto => 'Rasm qoʻshish';

  @override
  String clientBookClientStats(int completed, int cancelled, int upcoming) {
    return '$completed yakunlandi · $cancelled bekor · $upcoming kelgusi';
  }

  @override
  String get remindersUpdateStatus => 'Holatni yangilash';

  @override
  String get remindersSettingsTitle => 'Eslatma sozlamalari';

  @override
  String get remindersSettingsAlertsLabel => 'Eslatish';

  @override
  String get remindersSettingsAtTime => 'Uchrashuv vaqtida';

  @override
  String get earningsTitle => 'Mening daromadim';

  @override
  String get earningsTotal => 'Jami (eʼlon qilingan)';

  @override
  String get earningsEdit => 'Daromadni tahrirlash';

  @override
  String get earningsAdd => 'Daromad qoʻshish';

  @override
  String get earningsAmountLabel => 'Summa (UZS)';

  @override
  String get earningsNoteLabel => 'Izoh';

  @override
  String get earningsAmountRequired => 'Summani kiriting';

  @override
  String get earningsEmptyTitle => 'Daromad yozuvlari yoʻq';

  @override
  String get earningsEmptySub =>
      'Narxli kelishuvlar jarayonga oʻtganda avtomatik qoʻshiladi';

  @override
  String get earningsDisclaimer =>
      'Bu maʼlumot faqat sizning shaxsiy hisobingiz. Soliq yoki rasmiy hisobot emas.';

  @override
  String get notificationsEmptySub =>
      'Kelishuv yangiliklari shu yerda paydo boʻladi';

  @override
  String get notificationKelishuvAccept => 'Kelishuv qabul qilindi';

  @override
  String get notificationKelishuvMessage => 'Yangi xabar';

  @override
  String get notificationKelishuvComplete => 'Ish yakunlandi';

  @override
  String get notificationSubsectorNewService => 'Subsohada yangi xizmat';

  @override
  String get notificationSubsectorDiscount => 'Subsohada narx pasaydi';

  @override
  String get notificationSubsectorHelpPost => 'Subsohada yordam kerak';

  @override
  String get notificationAlertsTitle => 'Subsoha bildirishnomalari';

  @override
  String get notificationAlertsSubtitle =>
      'Xizmat paydo boʻlganda, narx tushganda yoki yordam soʻralganda xabar oling.';

  @override
  String get notificationAlertsAdd => 'Bildirishnoma qoʻshish';

  @override
  String get notificationAlertsEmpty => 'Hali subsoha bildirishnomalari yoʻq';

  @override
  String get notificationAlertNewService => 'Yangi xizmatlar';

  @override
  String get notificationAlertDiscount => 'Narx pasayishi';

  @override
  String get notificationAlertHelpPost => 'Yordam kerak postlari';

  @override
  String get notificationAlertSeekerHint => 'Xizmat qidiryotgan boʻlsangiz';

  @override
  String get notificationAlertProviderHint =>
      'Provayder sifatida yordam bera olsangiz';

  @override
  String get notificationAlertsSaved => 'Sozlama saqlandi';

  @override
  String get notificationAlertsRemoved => 'Sozlama oʻchirildi';

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
  String get reviewProviderReplyLabel => 'Xizmat koʻrsatuvchi javobi';

  @override
  String get reviewsEmpty => 'Hali sharh yoʻq';

  @override
  String get reviewsRate => 'Baholash';

  @override
  String xizmatCompletedCount(int count) {
    return '$count bajarilgan';
  }

  @override
  String get demoKelishuvBlocked => 'Demo rejimida kelishuv yaratib boʻlmaydi';

  @override
  String get demoKelishuvSimulatedNote =>
      'Demo kelishuv — serverga saqlanmaydi. Demo provayder taklifni olgan deb koʻrsatiladi.';

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
  String get xizmatServiceCityLabel => 'Xizmat koʻrsatiladigan shahar';

  @override
  String get xizmatServiceCityHint => 'Xizmat koʻrsatadigan shaharni tanlang';

  @override
  String get xizmatContinue => 'Davom etish';

  @override
  String get xizmatPortfolioHint =>
      'Kamida 1 ta rasm majburiy. Birinchi rasm asosiy koʻrinish boʻladi.';

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
      'Oʻz xizmatingizga soʻrov yuborib boʻlmaydi';

  @override
  String get xizmatNotFound => 'Xizmat topilmadi';

  @override
  String get xizmatNoPermission => 'Ruxsat yoʻq';

  @override
  String get xizmatBasicInfo => 'Asosiy maʼlumot';

  @override
  String get xizmatPortfolio => 'Portfolio';

  @override
  String get xizmatPortfolioEmpty =>
      'Portfolio boʻsh. Kamida bitta rasm kerak.';

  @override
  String get xizmatAddPhoto => 'Rasm qoʻshish';

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
  String get yordamKerakPostTitle => 'Yordam Kerak eʼlon';

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
  String get yordamKerakPublish => 'Eʼlon qilish';

  @override
  String get yordamKerakTitleTooShort =>
      'Sarlavha kamida 3 ta belgidan iborat boʻlsin';

  @override
  String get yordamKerakMessageTooShort =>
      'Loyiha tavsifi kamida 10 ta belgidan iborat boʻlsin';

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
  String get userProfileServicesEmpty => 'Hali xizmat yoʻq';

  @override
  String get userProfileRequests => 'Yordam Kerak eʼlonlari';

  @override
  String get userProfileRequestsEmpty => 'Ochiq eʼlon yoʻq';

  @override
  String get userProfileAvailable => 'Mavjud';

  @override
  String get userProfileBusy => 'Band';

  @override
  String get userProfilePartiallyBusy => 'Qisman band';

  @override
  String get userProfileCall => 'Qoʻngʻiroq qilish';

  @override
  String get userProfilePhoneHidden => 'Telefon raqam yashirilgan';

  @override
  String get userProfileViewProfile => 'Profilni koʻrish';

  @override
  String get xizmatProviderSection => 'Xizmat koʻrsatuvchi';

  @override
  String get profileViewPublic => 'Ochiq profilim';

  @override
  String get profileCertificatesTitle => 'Sertifikatlar va malakalar';

  @override
  String get profileCertificatesSubtitle =>
      'Malaka hujjatlaringizni yuklang — mijozlar koʻrib chiqadi';

  @override
  String get profileCertificatesDisclaimer =>
      'YordamBor yuklangan hujjatlarni tasdiqlamaydi. Mijozlar hujjatlarni oʻzlari tekshirishi kerak.';

  @override
  String get profileCertificatesAdd => 'Sertifikat qoʻshish';

  @override
  String get profileCertificatesTitleLabel => 'Sarlavha';

  @override
  String get profileCertificatesTitleHint =>
      'Masalan: Santexnika kursi sertifikati';

  @override
  String get profileCertificatesIssuerLabel => 'Kim bergan (ixtiyoriy)';

  @override
  String get profileCertificatesIssuerHint => 'Masalan: Oʻquv markazi nomi';

  @override
  String get profileCertificatesEmpty => 'Hali sertifikat yuklanmagan';

  @override
  String get profileCertificatesMaxReached => 'Maksimal 8 ta sertifikat';

  @override
  String get profileCertificatesAdded => 'Sertifikat qoʻshildi';

  @override
  String get profileCertificatesRemoved => 'Sertifikat oʻchirildi';

  @override
  String get profileCertificatesRemoveTitle => 'Sertifikatni oʻchirasizmi?';

  @override
  String get xizmatOtherServices => 'Boshqa xizmatlar';

  @override
  String get xizmatViewAllServices => 'Barcha xizmatlarni koʻrish';

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
    return '$name bloklaysizmi? Uning kontenti koʻrinmaydi.';
  }

  @override
  String get safetyBlockDone => 'Foydalanuvchi bloklandi';

  @override
  String get safetyHideUser => 'Foydalanuvchini yashirish';

  @override
  String get safetyReportReason => 'Shikoyat sababi (ixtiyoriy)';

  @override
  String get safetyReportHint => 'Nima boʻldi?';

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
  String get demoPostPickReal => 'Demo eʼlon — haqiqiy eʼlon tanlang';

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
  String get analyticsViews => 'Koʻrishlar';

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
  String get kelishuvArchiveEmptyTitle => 'Arxiv boʻsh';

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
  String get reviewCommentHint => 'Tajribangiz qanday boʻldi?';

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
    return 'Eʼlon: $title';
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
      'Narx koʻrinib tursa, mijozlar tezroq yozadi.';

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
  String get xizmatPricingRequiredError => 'Summani kiriting';

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
      'Ixtiyoriy — mijozlar band/emassizligingizni koʻradi. Mijozlar kitobi buni oʻzgartirmaydi.';

  @override
  String get xizmatAvailabilityShowLabel => 'Mavjudlikni koʻrsatish';

  @override
  String get xizmatAvailabilityShowSubtitle =>
      'Oʻchirilgan boʻlsa, hech qanday belgi koʻrinmaydi';

  @override
  String get xizmatAvailabilityAvailableNow => 'Hozir mavjud';

  @override
  String get xizmatAvailabilityBusy => 'Band';

  @override
  String get xizmatAvailabilityCallMe => 'Oldindan yozilish';

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
      'Tugash vaqti boshlanishdan keyin boʻlishi kerak';

  @override
  String get xizmatPromiseSectionTitle => 'Vaʼdam';

  @override
  String get xizmatPromiseSectionSubtitle =>
      'Mijozlarga nima vaʼda qilishingizni yozing. Bu sizning shioringiz — YordamBor kafolati emas.';

  @override
  String get xizmatPromiseShowLabel => 'Vaʼdamni koʻrsatish';

  @override
  String get xizmatPromiseShowSubtitle => 'Eʼlonda mijozlar koʻradi';

  @override
  String get xizmatPromisePresetsLabel =>
      'Tezkor shablonlar (tahrirlash mumkin)';

  @override
  String get xizmatPromiseFieldLabel => 'Vaʼdangiz';

  @override
  String get xizmatPromiseFieldHint =>
      'Oʻzingiz yozing yoki shablonni tahrirlang';

  @override
  String get xizmatPromisePreset1 => 'Mamnun qolmasangiz, qayta bajaraman';

  @override
  String get xizmatPromisePreset2 =>
      'Sifatga kafolat — muammo boʻlsa, pulingizni qaytaraman';

  @override
  String get xizmatPromisePreset3 => 'Vaqtida va kelishilgan narxda';

  @override
  String get xizmatPromiseDisclaimer =>
      'YordamBor kafolat bermaydi. Bu xizmat koʻrsatuvchining oʻz soʻzi.';

  @override
  String get xizmatPromiseRequiredError => 'Vaʼdangizni yozing yoki oʻchiring';

  @override
  String get xizmatPromiseTooLongError => 'Vaʼda juda uzun';

  @override
  String get settingsHelp => 'Yordam va qoʻllab-quvvatlash';

  @override
  String get supportReportTitle => 'Muammo haqida xabar';

  @override
  String get supportReportSubtitle => 'Xato, hisob yoki toʻlov muammosi';

  @override
  String get supportCategoryLabelField => 'Kategoriya';

  @override
  String get supportCategoryBug => 'Xato';

  @override
  String get supportCategoryAccount => 'Hisob';

  @override
  String get supportCategoryPayment => 'Toʻlov muammosi';

  @override
  String get supportCategoryOther => 'Boshqa';

  @override
  String get supportDescriptionLabel => 'Tavsif';

  @override
  String get supportDescriptionHint => 'Nima boʻlganini yozing…';

  @override
  String get supportSubmit => 'Yuborish';

  @override
  String get supportSubmitted => 'Rahmat — xabaringiz qabul qilindi';

  @override
  String get supportLoginRequired => 'Xabar yuborish uchun kiring';

  @override
  String get supportContactHint => 'Qoʻllab-quvvatlash: eeshbaev@outlook.com';

  @override
  String get supportMailtoFailed => 'Email ilovasini ochib boʻlmadi';

  @override
  String get feedbackTitle => 'Fikr-mulohaza';

  @override
  String get feedbackSubtitle => 'YordamBor’ni yaxshilashga yordam bering';

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
      'Fikr yuborish uchun Yordam boʻlimidan foydalaning.';

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
      'Obroʻingizni bosqichma-bosqich quring';

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
  String get progressTipAddCertificate => 'Ishonch uchun sertifikat qoʻshing';

  @override
  String get progressTipSetAvailability => 'Eʼlonda mavjudlikni koʻrsating';

  @override
  String get progressTipReplyReviews => 'Sharhlarga javob bering';

  @override
  String get progressTipAddPortfolio => 'Portfolio rasmlarini koʻpaytiring';

  @override
  String get progressTipSetPricing => 'Qatʼiy yoki soatbay narx belgilang';

  @override
  String get progressTipRepeatClients =>
      'Mamnun mijozlardan qayta buyurtma soʻrang';

  @override
  String get achievementsTitle => 'Yutuqlar';

  @override
  String get achievementsEmptySub =>
      'Hali yutuq yoʻq. Ishlarni bajaring va profilni rivojlantiring.';

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
      'YordamBor’da birinchi xizmatingizni yaratdingiz.';

  @override
  String get achievementBodyFirstDeal =>
      'Birinchi kelishuvingiz yakunlandi. Davom eting!';

  @override
  String get achievementBodyJobs5 => 'Beshta ish — mijozlar sizni payqayapti.';

  @override
  String get achievementBodyJobs10 =>
      'Oʻn bajarilgan ish. Haqiqiy obroʻ quryapsiz.';

  @override
  String get achievementBodyJobs25 =>
      'Yigirma besh ish. Eng yaxshi ustalar qatoridasiz.';

  @override
  String get achievementBodyFirstFiveStar =>
      'Mijoz 5 yulduz berdi. Tabriklaymiz!';

  @override
  String get achievementBodyCertificate =>
      'Guvohnomalaringiz profilda koʻrinadi.';

  @override
  String get achievementBodyRepeatClient =>
      'Bir mijoz sizni uch marta yoki undan koʻp chaqirdi.';

  @override
  String get actionContinue => 'Davom etish';

  @override
  String get guidesTitle => 'Biznes maslahatlari';

  @override
  String get guidesSubtitle => 'Xizmatingizni bosqichma-bosqich oʻstiring';

  @override
  String get guideXizmatConvertsTitle => 'Sotadigan eʼlon yarating';

  @override
  String get guidePricingTitle => 'Narx: qatʼiy yoki soatbay';

  @override
  String get guideRepeatClientsTitle => 'Qayta buyurtma oling';

  @override
  String get guideCertificatesTitle => 'Sertifikatlar va ishonch';

  @override
  String get guideReviewRepliesTitle => 'Sharhlarga professional javob';

  @override
  String get guideXizmatConvertsBody =>
      'Aniq sarlavha, haqiqiy portfolio va subsoha tanlang. Narx yoki kelishuvchan deb yozing. Mavjudlikni koʻrsating.';

  @override
  String get guidePricingBody =>
      'Qatʼiy narx aniq ishlar uchun. Soatbay tozalash, repetitorlik uchun mos. Kelishuvchan ham boʻladi — boshlangʻich narx koʻproq murojaat oladi.';

  @override
  String get guideRepeatClientsBody =>
      'Sifatli ish qiling, tez javob bering. Mamnun mijozlardan kelishuvdan keyin Qayta buyurtma tugmasini ishlating.';

  @override
  String get guideCertificatesBody =>
      'Mijozlar koʻradigan malaka hujjatlarini yuklang. YordamBor hujjatlarni tasdiqlamaydi — ular ishonch uchun yordam beradi.';

  @override
  String get guideReviewRepliesBody =>
      'Har bir sharhga muloyim javob bering. 5★ uchun rahmat ayting. Tanqidga professional javob bering — kelajakdagi mijozlar oʻqiydi.';

  @override
  String get safetyPaymentsBanner =>
      'Faqat kelishilgan tartibda toʻlang. YordamBor pul oʻtkazmaydi va platformadan tashqari toʻlovlar uchun javobgar emas.';

  @override
  String get settingsSafety => 'Xavfsizlik va toʻlovlar';

  @override
  String get legalSafetyTitle => 'Xavfsizlik va toʻlovlar';

  @override
  String get legalSafetyBody =>
      'YordamBor mijoz va ustani bogʻlaydi. Xizmat koʻrsatmaydi, pul saqlamaydi va natijaga kafolat bermaydi.\n\nToʻlovlar\n\nToʻlovlar toʻgʻridan-toʻgʻri siz va boshqa tomon oʻrtasida kelishiladi. Ishonchsiz odamga oldindan toʻliq pul yubormang. YordamBor firibgarlik yoki nizo uchun javobgar emas.\n\nSizning masʼuliyatingiz\n\nGuvohnoma, sharh va sertifikatlarni oʻzingiz tekshiring.\n\nXabar berish\n\nHaqorat uchun ilovadan shikoyat qiling. Texnik muammo uchun Yordam boʻlimidan foydalaning.';

  @override
  String get greetingMorning => 'Xayrli tong';

  @override
  String get greetingAfternoon => 'Xayrli kun';

  @override
  String get greetingEvening => 'Xayrli kech';

  @override
  String get greetingNight => 'Salom';

  @override
  String get greetingWelcomeBack => 'Qaytganingiz bilan';

  @override
  String get greetingWelcomeNew => 'Xush kelibsiz';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String homeFactAwaitingReply(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta kelishuv javobingizni kutmoqda',
    );
    return '$_temp0';
  }

  @override
  String homeFactInProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta kelishuv jarayonda',
    );
    return '$_temp0';
  }

  @override
  String get homeFactNewMember =>
      'Boshlash uchun yordam soʻrang yoki xizmat qoʻshing';

  @override
  String get continueYourTurn => 'Sizning navbatingiz';

  @override
  String get continueReplyToDeal => 'Shartlarni koʻrib, javob bering';

  @override
  String get continueInProgress => 'Jarayonda';

  @override
  String get continueMarkDone => 'Ish bitgach, tasdiqlang';

  @override
  String get continueDraftTitle => 'Tugallanmagan soʻrov';

  @override
  String get continueDraftUntitled => 'Sarlavhasiz soʻrov';

  @override
  String get continueDraftHint => 'Toʻxtagan joyingizdan davom eting';

  @override
  String get draftDelete => 'Qoralamani oʻchirish';

  @override
  String get draftDeleted => 'Qoralama oʻchirildi';

  @override
  String get draftRestored => 'Qoralama tiklandi';

  @override
  String get draftStartOver => 'Boshidan boshlash';

  @override
  String get actionUndo => 'Qaytarish';

  @override
  String get quickAskHelp => 'Yordam soʻrash';

  @override
  String get quickOfferService => 'Xizmat qoʻshish';

  @override
  String get feedEndTitle => 'Hammasi koʻrildi';

  @override
  String get feedEndAskPrompt => 'Kerakli usta topilmadimi?';

  @override
  String get feedEndJobsHint => 'Yangi soʻrovlar shu yerda birinchi chiqadi';

  @override
  String get whatsNewTitle => 'Yangiliklar';

  @override
  String get whatsNewLookTitle => 'Yangi, toza koʻrinish';

  @override
  String get whatsNewLookBody =>
      'Oʻqishga qulay yangi shrift, ranglar va belgilar.';

  @override
  String get whatsNewNextStepTitle => 'Keyingi qadamingiz bosh sahifada';

  @override
  String get whatsNewNextStepBody =>
      'Sizni kutayotgan kelishuvlar va tugallanmagan soʻrovlar endi birinchi chiqadi.';

  @override
  String get whatsNewDraftsTitle => 'Qoralamalar oʻz-oʻzidan saqlanadi';

  @override
  String get whatsNewDraftsBody =>
      'Soʻrovni yarim yoʻlda yopsangiz ham, keyinroq davom ettirasiz.';

  @override
  String get whatsNewDone => 'Tushunarli';

  @override
  String get xizmatCardNew => 'Yangi';

  @override
  String get favoriteAdd => 'Saqlash';

  @override
  String get favoriteRemove => 'Saqlanganlardan olib tashlash';

  @override
  String statJobsDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'bajarilgan ish',
    );
    return '$_temp0';
  }

  @override
  String get statRating => 'reyting';

  @override
  String get dealBondYou => 'Siz';

  @override
  String get dealBondYourTurn =>
      'Sizning navbatingiz: shartlarni koʻrib, qabul qiling';

  @override
  String dealBondWaiting(String name) {
    return '$name javobini kutyapmiz';
  }

  @override
  String get dealBondAgreed => 'Kelishildi · ish jarayonda';

  @override
  String get dealBondDone => 'Ish bajarildi · rahmat';

  @override
  String get dealBondClosed => 'Bu kelishuv yopilgan';

  @override
  String get undoDeleted => 'Oʻchirildi';

  @override
  String get savedRemoved => 'Saqlanganlardan olib tashlandi';

  @override
  String get yordamKerakTitleRequired => 'Qisqa sarlavha yozing';

  @override
  String get yordamKerakMessageRequired => 'Nima kerakligini yozing';

  @override
  String get stateErrorTitle => 'Yuklab boʻlmadi';

  @override
  String get stateErrorBody => 'Internetni tekshirib, qayta urinib koʻring.';

  @override
  String get stateOfflineBanner =>
      'Internet yoʻq. Saqlangan maʼlumot koʻrsatilmoqda';

  @override
  String get disabledHintServiceName => 'Kamida 2 harfdan iborat nom yozing';

  @override
  String get disabledHintServiceCity => 'Ishlaydigan shahringizni tanlang';

  @override
  String get disabledHintServicePhoto =>
      'Eʼlon qilish uchun kamida bitta rasm qoʻshing';

  @override
  String get disabledHintPickSubcategory => 'Avval subsohani tanlang';

  @override
  String get disabledHintOneAlert => 'Kamida bitta bildirishnomani yoqing';

  @override
  String get milestoneOverline => 'Yangi yutuq';

  @override
  String get milestoneDismiss => 'Yopish';

  @override
  String get notificationsTooltip => 'Bildirishnomalar';

  @override
  String a11yRating(String rating) {
    return 'reyting $rating';
  }

  @override
  String get a11yNewProvider => 'YordamBor’da yangi';

  @override
  String get filtersClear => 'Filtrlarni tozalash';

  @override
  String get actionClose => 'Yopish';

  @override
  String get actionMore => 'Boshqa amallar';

  @override
  String get actionSend => 'Yuborish';

  @override
  String get actionPreviousMonth => 'Oldingi oy';

  @override
  String get actionNextMonth => 'Keyingi oy';

  @override
  String get a11yShowPassword => 'Parolni koʻrsatish';

  @override
  String get a11yHidePassword => 'Parolni yashirish';

  @override
  String a11yStarRating(int count) {
    return '$count yulduz';
  }

  @override
  String get detailPaneEmptyTitle => 'Kartani tanlang';

  @override
  String get detailPaneEmptyBody => 'U shu yerda, roʻyxat yonida ochiladi.';

  @override
  String get taklifAskHint => 'Sizga qanday yordam kerak?';

  @override
  String get taklifAskSubtitle =>
      'Ishni tasvirlab bering, xohlasangiz byudjetni ham yozing. Ikkalangiz kelishgach, ish boshlanadi.';

  @override
  String get taklifAskSubmit => 'Soʻrov yuborish';

  @override
  String dealOfferAutoCancel(int days) {
    return 'Javob boʻlmasa, $days kundan keyin avtomatik bekor qilinadi';
  }

  @override
  String dealOfferReplyWithin(int days) {
    return '$days kun ichida javob bering, aks holda taklif bekor qilinadi';
  }

  @override
  String get dealAcceptedRow => 'Shartlarni qabul qildi';

  @override
  String get dealCompletedRow => 'Ish bajarilganini tasdiqladi';

  @override
  String get dealWithdrawOffer => 'Taklifni qaytarib olish';

  @override
  String get dealWithdrawTitle => 'Taklifni qaytarib olasizmi?';

  @override
  String get dealWithdrawBody =>
      'Kelishuv bekor qilinadi. Keyin yangi taklif yuborishingiz mumkin.';

  @override
  String get dealChatOpensOnReply => 'Javob kelgach, suhbat ochiladi.';

  @override
  String get dealRejectTitle => 'Taklifni rad etasizmi?';

  @override
  String get dealRejectBody =>
      'Xohlasangiz, sababini yozing — u kelishuvda koʻrinib turadi.';

  @override
  String get dealRejectCommentLabel => 'Izoh (ixtiyoriy)';

  @override
  String get dealSendNewOffer => 'Yangi taklif yuborish';

  @override
  String get dealClosedNewOfferHint =>
      'Xizmat hali ham kerakmi? Yangi taklif yuboring — suhbat yangidan boshlanadi.';

  @override
  String get archiveTabNeeded => 'Yordam kerak edi';

  @override
  String get archiveTabProvided => 'Yordam koʻrsatildi';

  @override
  String get archiveNeededEmpty =>
      'Yordam soʻragan kelishuvlaringiz shu yerda chiqadi.';

  @override
  String get archiveProvidedEmpty =>
      'Yordam bergan kelishuvlaringiz shu yerda chiqadi.';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$total tadan $unlocked tasi ochildi';
  }

  @override
  String get achievementsShow => 'Hammasini koʻrish';

  @override
  String get achievementsHide => 'Yashirish';

  @override
  String get yordamKerakCityRequired => 'Shaharni tanlang';

  @override
  String get taklifContactTitle => 'Kontaktlaringiz';

  @override
  String get taklifContactNote =>
      'Ikkinchi tomon ularni kelishuvda koʻradi va siz bilan bogʻlanadi.';

  @override
  String get taklifFirstNameLabel => 'Ism';

  @override
  String get taklifLastNameLabel => 'Familiya';

  @override
  String get taklifFirstNameRequired => 'Ismingizni kiriting';

  @override
  String get taklifPhoneRequired => 'Telefon raqamingizni kiriting';

  @override
  String get taklifMessageOptionalLabel => 'Xabar (ixtiyoriy)';

  @override
  String get dealContactTitle => 'Bogʻlanish uchun';

  @override
  String get dealContactSent => 'Kontaktlaringizni yubordingiz';

  @override
  String get dealsSectionTitle => 'Kelishuvlaringiz';

  @override
  String get dealStateYourTurn => 'Muhokamada · navbat sizda';

  @override
  String get dealStateSent => 'Yuborildi · javob kutilmoqda';

  @override
  String get dealStateInProgress => 'Qabul qilindi · ish jarayonida';

  @override
  String get dealStateAwaitingConfirm =>
      'Siz tasdiqladingiz · ikkinchi tomon kutilmoqda';

  @override
  String get actionAdd => 'Qoʻshish';

  @override
  String get businessEarningsTitle => 'Shu oydagi daromad';

  @override
  String get businessEarningsSee => 'Daromadni koʻrish';

  @override
  String get businessStatWaitingLabel => 'javobingizni kutmoqda';

  @override
  String get businessNextStepsTitle => 'Koʻproq mijoz uchun';

  @override
  String businessNextStepsProgress(int done, int total) {
    return '$total tadan $done';
  }

  @override
  String get businessStepPhotos => '3 yoki undan koʻp rasm qoʻshing';

  @override
  String get businessStepPhotosWhy => 'Rasmli xizmatlar koʻproq tanlanadi';

  @override
  String get businessStepPrice => 'Narxni koʻrsating';

  @override
  String get businessStepPriceWhy => 'Aniq narx — kelishuvgacha kamroq savol';

  @override
  String get businessStepAvailability => 'Qachon boʻsh ekaningizni koʻrsating';

  @override
  String get businessStepAvailabilityWhy =>
      'Mijozlar tez kela oladiganlarga yozadi';

  @override
  String get businessStepShare => 'Xizmat havolasini ulashing';

  @override
  String get businessStepShareWhy =>
      'Telegramda yuboring — doʻstlaringiz sizni tavsiya qiladi';

  @override
  String businessServicesCount(int count, int max) {
    return 'Xizmatlarim · $max tadan $count';
  }

  @override
  String xizmatLimitReached(int max) {
    return '$max tagacha xizmat joylash mumkin. Yangisini qoʻshish uchun birini oʻzgartiring yoki oʻchiring.';
  }

  @override
  String get calendarStatusCaption => 'Holatingiz · mijozlar koʻradi';

  @override
  String get calendarLegendNeedHelp => 'Menga yordam';

  @override
  String get calendarLegendGiveHelp => 'Men yordam beraman';

  @override
  String get calendarLegendPersonal => 'Shaxsiy';

  @override
  String get calendarHintMark =>
      'Kunni bosing va boʻsh yoki band deb belgilang. Kunning bir qismi boʻlsa, soatlarni koʻrsating; aks holda butun ish kuni.';

  @override
  String get calendarHintClient =>
      'Kelishuvlaringiz eslatmalari: sizga yordam va siz beradigan yordam. Batafsil uchun kunni bosing.';

  @override
  String get calendarDayNotMarked => 'Belgilanmagan';

  @override
  String get calendarWholeWorkingDay => 'Butun ish kuni';

  @override
  String get calendarAddHours => 'Vaqt qoʻshish';

  @override
  String get calendarRemoveHours => 'Bu vaqtni olib tashlash';

  @override
  String get calendarHoursFrom => 'Boshlanishi';

  @override
  String get calendarHoursTo => 'Tugashi';

  @override
  String get calendarDayEvents => 'Shu kungi eslatmalar';

  @override
  String get workingHoursTitle => 'Ish vaqti';

  @override
  String get workingHoursHint => 'Mijozlar ularni xizmatlaringizda koʻradi';

  @override
  String get workingHoursSheetHint =>
      'Odatiy ish kuningiz. Standart: 9:00–13:00 va 14:00–18:00.';

  @override
  String get workingHoursReset => '9–13 va 14–18 ga qaytarish';

  @override
  String get workingHoursInvalid =>
      'Vaqtni tekshiring: har biri tugashidan oldin boshlansin va ustma-ust tushmasin.';

  @override
  String get workingHoursSaved => 'Ish vaqti saqlandi';

  @override
  String get xizmatOwnHoursTitle => 'Bu xizmat uchun alohida vaqt';

  @override
  String xizmatOwnHoursOff(String hours) {
    return 'Profildagidek: $hours';
  }

  @override
  String get xizmatHoursInCalendar => 'Ish vaqtini kalendarda oʻzgartirasiz.';

  @override
  String get xizmatHoursOpenCalendar => 'Kalendarni ochish';

  @override
  String get xizmatScheduleTitle => 'Ish vaqti va bandlik';

  @override
  String get xizmatScheduleNextDays => 'Keyingi 2 hafta';

  @override
  String get xizmatTodayFree => 'Bugun boʻsh';

  @override
  String get xizmatTodayBusy => 'Bugun band';

  @override
  String xizmatTodayBusyAt(String hours) {
    return 'Bugun band: $hours';
  }

  @override
  String xizmatTodayFreeAt(String hours) {
    return 'Bugun boʻsh: $hours';
  }

  @override
  String get calendarNoRemindersDay => 'Bu kunga eslatmalar yoʻq.';

  @override
  String get sampleTag => 'Namuna';

  @override
  String get demoDealNote => 'Bu namuna: kelishuv haqiqiy odamga yuborilmaydi.';

  @override
  String get feedInviteProvidersTitle => 'Birinchi ijrochilardan biri boʻling';

  @override
  String get feedInviteProvidersBody =>
      'Xizmatingizni qoʻshing — mijozlar uni birinchi koʻradi.';

  @override
  String get feedInviteAskTitle => 'Birinchi boʻlib yordam soʻrang';

  @override
  String get feedInviteAskBody =>
      'Nima kerakligini yozing — ijrochilar soʻrovingizni koʻradi.';

  @override
  String get feedInviteProvidersAction => 'Oʻz xizmatingizni qoʻshing';

  @override
  String get feedInviteAskAction => 'Nima kerakligini yozing';

  @override
  String get sampleFindProvider => 'Ijrochi topish';

  @override
  String get sampleFindProviderHint =>
      'Bu namuna. Vazifani yozing — uni haqiqiy ijrochilar koʻradi.';

  @override
  String get sampleAlertNewServices =>
      'Bu sohada ijrochi paydo boʻlsa, xabar bering';

  @override
  String get sampleRequestPosted =>
      'Soʻrov eʼlon qilindi — uni ijrochilar koʻradi.';

  @override
  String get sampleRequestTitle => 'Bu namuna soʻrov';

  @override
  String get sampleRequestBody =>
      'Haqiqiy soʻrovlar shu yerda paydo boʻladi. Bildirishnomalarni yoqing — kimdir bu sohada yordam soʻrasa, xabar beramiz.';

  @override
  String get sampleAlertHelpPosts => 'Yangi soʻrovlar haqida xabar berish';

  @override
  String get sampleAlertOn =>
      'Tayyor — bu sohadagi yangi soʻrovlar haqida xabar beramiz.';

  @override
  String get foundingBadge => 'YordamBor’da birinchi';

  @override
  String get foundingBadgeNote =>
      'Birinchi ijrochilar «YordamBor’da birinchi» belgisini oladi.';

  @override
  String get inviteTitle => 'Ijrochilarni taklif qiling';

  @override
  String get inviteBody =>
      'Yaxshi elektrik, repetitor yoki salonni bilasizmi? Taklif qiling: haqiqiy ijrochilar qancha koʻp boʻlsa, mijozlar shuncha koʻp keladi.';

  @override
  String get inviteShare => 'Taklifnoma yuborish';

  @override
  String get invitePrepare => 'Tanishingiz uchun xizmat tayyorlash';

  @override
  String get inviteMessage =>
      'YordamBor’ga qoʻshiling: u yerda mijozlar butun Oʻzbekiston boʻylab ijrochi topadi. Xizmat qoʻshish bepul, birinchi ijrochilar «YordamBor’da birinchi» belgisini oladi.';

  @override
  String invitePersonalMessage(String name, String trade, String city) {
    return '$name, salom! Men YordamBor’daman — u yerda mijozlar ijrochi topadi. «$trade» xizmatingizni ($city) qoʻshing: bepul, birinchi ijrochilar «YordamBor’da birinchi» belgisini oladi.';
  }

  @override
  String inviteOpenLink(String link) {
    return 'Boshlash uchun oching: $link';
  }

  @override
  String inviteAppLink(String link) {
    return 'Ilova: $link';
  }

  @override
  String get invitePrepareTitle => 'Tanishingiz uchun xizmat';

  @override
  String get invitePrepareBody =>
      'Kasbi va shahrini tanlang. U ushbular toʻldirilgan «Yangi xizmat»ni ochadigan havola oladi va xizmatni oʻzi eʼlon qiladi.';

  @override
  String get invitePersonName => 'Ismi (ixtiyoriy)';

  @override
  String get invitePersonPhone => 'Telefoni (ixtiyoriy)';

  @override
  String get invitePickTrade => 'Soha';

  @override
  String get inviteSendWhatsApp => 'WhatsApp orqali yuborish';

  @override
  String get inviteSendSms => 'SMS orqali yuborish';

  @override
  String get inviteSendOther => 'Boshqa ilova';

  @override
  String get inviteNeedTradeCity => 'Soha va shaharni tanlang';

  @override
  String get onbGoalTitle => 'YordamBor’ga nima uchun keldingiz?';

  @override
  String get onbGoalNeedHelp => 'Menga yordam kerak';

  @override
  String get onbGoalNeedHelpSub => 'Ijrochi topish yoki vazifani yozish';

  @override
  String get onbGoalOffer => 'Men xizmat koʻrsataman';

  @override
  String get onbGoalOfferSub => 'Mijoz topish va daromad qilish';

  @override
  String get onbGoalBoth => 'Ikkalasi ham';

  @override
  String get onbGoalBothSub =>
      'Yordam beraman, baʼzan oʻzim ham yordam soʻrayman';

  @override
  String get onbCityTitle => 'Shahringiz';

  @override
  String get onbCitySub => 'Yaqiningizdagilarni koʻrsatamiz.';

  @override
  String get onbNext => 'Keyingisi';

  @override
  String get onbDone => 'Tayyor';

  @override
  String get onbSkip => 'Oʻtkazib yuborish';

  @override
  String onbStep(int current, int total) {
    return '$total qadamdan $current';
  }

  @override
  String get onbIntro1Title => 'Xizmatlar yoningizda';

  @override
  String get onbIntro1Body =>
      'Butun Oʻzbekiston boʻylab mutaxassislar va tashkilotlar.';

  @override
  String get onbIntro2Title => 'Yordam kerakmi? Soʻrang';

  @override
  String get onbIntro2Body =>
      'Vazifani yozing — ijrochilar oʻzlari javob beradi.';

  @override
  String get onbIntro3Title => 'Xizmatingizni taklif qiling';

  @override
  String get onbIntro3Body => 'Jismoniy shaxs yoki tashkilot sifatida. Bepul.';

  @override
  String get onbIntro4Title => 'Halol va xotirjam';

  @override
  String get onbIntro4Body =>
      'Kelishuv ikki tomon rozi boʻlganda boshlanadi. Sharhlar faqat bajarilgan ishdan keyin. Toʻlov — kelishuvga koʻra.';

  @override
  String get onbTypeTitle => 'Qanday ishlaysiz?';

  @override
  String get onbTypeSub =>
      'Mijozlar buni xizmatlaringizda koʻradi. Keyin oʻzgartirish mumkin.';

  @override
  String get onbTypeIndividualSub => 'Usta, repetitor yoki frilanser';

  @override
  String get onbTypeInstitutionSub =>
      'Kompaniya, salon, klinika yoki oʻquv markazi';

  @override
  String onbReadyToOffer(String action) {
    return 'Tayyor boʻlganingizda «$action»ni bosing.';
  }

  @override
  String get inviteAction => 'Tanish ijrochini taklif qilish';

  @override
  String invitePersonalMessageNoName(String trade, String city) {
    return 'Salom! Men YordamBor’daman — u yerda mijozlar ijrochi topadi. «$trade» xizmatingizni ($city) qoʻshing: bepul, birinchi ijrochilar «YordamBor’da birinchi» belgisini oladi.';
  }

  @override
  String get joinTitle => 'Sizni YordamBor’ga taklif qilishdi';

  @override
  String get joinBody =>
      'Xizmatingizni qoʻshing — bu bepul. Mijozlar bu yerda ijrochini soha va shahar boʻyicha topadi.';

  @override
  String get joinLookAround => 'Avval ilovani koʻrib chiqish';

  @override
  String get onbStart => 'Boshlash';

  @override
  String get welcomeFindHelp => 'Yordam toping';

  @override
  String get welcomeGiveHelp => 'Yordam bering';

  @override
  String get onbTileLawyer => 'Advokat';

  @override
  String get onbTileBeauty => 'Goʻzallik';

  @override
  String get onbTileCatering => 'Keytering';

  @override
  String get onbTileVet => 'Veterinar';

  @override
  String get onbTileCleaning => 'Tozalash';

  @override
  String get onbTileElectrician => 'Elektrik';

  @override
  String get onbTilePlumber => 'Santexnik';

  @override
  String get onbTileDental => 'Stomatologiya';

  @override
  String onbMoreServices(int count) {
    return 'va yana $count dan ortiq xizmat turi';
  }

  @override
  String get onbIllRequestTitle => 'Oshxonadagi kran oqyapti';

  @override
  String get onbIllToday => 'Bugun';

  @override
  String get onbIllNewOffers => '2 ta yangi taklif';

  @override
  String get onbIllName1 => 'Aziz';

  @override
  String get onbIllName2 => 'Dilnoza';

  @override
  String get onbIllOffer1 => 'Bugun 18:00 da kela olaman';

  @override
  String get onbIllOffer2 => 'Ertaga ertalab boʻshman';

  @override
  String get onbIllNewRequest => 'Yangi soʻrov';

  @override
  String get onbIllSocket => 'Rozetka almashtirish';

  @override
  String get onbTileTutor => 'Repetitor';

  @override
  String get onbTileAuto => 'Avto servis';

  @override
  String get searchTooltip => 'Qidirish';

  @override
  String get searchHint => 'Ism, tashkilot yoki xizmat';

  @override
  String get searchPrompt =>
      'Ijrochi ismi, tashkilot nomi yoki xizmatni yozing, masalan, «santexnik».';

  @override
  String get searchNoResults => 'Hech narsa topilmadi';

  @override
  String get searchNoResultsHint =>
      'Soʻrov joylang — ijrochilar oʻzlari javob beradi.';

  @override
  String get searchOffline =>
      'Internet yoʻq: faqat telefondagilar koʻrsatilmoqda.';

  @override
  String get onbTileRenovation => 'Taʼmirlash';

  @override
  String get onbTileFitness => 'Fitnes';

  @override
  String get onbTileTranslator => 'Tarjimon';

  @override
  String get onbTileBarber => 'Sartarosh';

  @override
  String get onbTileMusic => 'Musiqa darslari';

  @override
  String get onbTileStylist => 'Stilist';

  @override
  String get onbTileKindergarten => 'Bogʻcha';

  @override
  String get onbIllTutorTitle => 'Ingliz tili va IELTS';

  @override
  String get onbIllStylistRequest => 'Toʻy uchun obraz';

  @override
  String onbKindsChip(int count) {
    return '+$count xizmat turi';
  }

  @override
  String get onbIllDentalRequestTitle => 'Tishim ogʻriyapti';

  @override
  String get onbTileDentist => 'Stomatolog';

  @override
  String get onbIllDentalOffer1 => 'Bugun 16:00 da qabul qilamiz';

  @override
  String get onbIllDentalOffer2 => 'Ertaga ertalab qabul qilaman';

  @override
  String get xizmatStatNoReviews => 'Sharh yoʻq';

  @override
  String get xizmatStatPrice => 'narx';

  @override
  String get xizmatStatPerHour => 'soatiga';

  @override
  String get xizmatStatNegotiable => 'Kelishiladi';

  @override
  String get xizmatPromiseOwnWords => 'Ijrochining oʻz soʻzi';

  @override
  String get xizmatAboutTitle => 'Xizmat haqida';

  @override
  String get actionReadMore => 'Batafsil';

  @override
  String get actionReadLess => 'Yigʻish';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta sharh',
    );
    return '$_temp0';
  }

  @override
  String reviewsSeeAll(int count) {
    return 'Barcha sharhlar ($count)';
  }

  @override
  String get reviewsFilterAll => 'Hammasi';

  @override
  String get reviewsFilterEmpty => 'Bunday baholi sharh hali yoʻq';

  @override
  String reviewsBarA11y(int stars, int count) {
    return '$stars baho: $count ta';
  }

  @override
  String get xizmatHowTitle => 'Qanday ishlaydi';

  @override
  String get xizmatHowAsk => 'Soʻrov yuboring';

  @override
  String get xizmatHowChat => 'Ilovada yozishing';

  @override
  String get xizmatHowAgree => 'Kelishib oling';

  @override
  String providerMemberSince(String year) {
    return '$year-yildan aʼzo';
  }

  @override
  String providerServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ta xizmat',
    );
    return '$_temp0';
  }

  @override
  String get xizmatAboutHint =>
      'Nima qilasiz, qanday ishlaysiz, mijozga nimani vaʼda qilasiz';

  @override
  String xizmatPricePerDay(String amount) {
    return '$amount/kun';
  }

  @override
  String xizmatPricePerMonth(String amount) {
    return '$amount/oy';
  }

  @override
  String xizmatPricePerUnit(String amount) {
    return '$amount/dona';
  }

  @override
  String get xizmatStatPerDay => 'kuniga';

  @override
  String get xizmatStatPerMonth => 'oyiga';

  @override
  String get xizmatStatPerUnit => 'donasiga';

  @override
  String get priceChoiceTitle => 'Narx';

  @override
  String get priceChoiceServiceHint =>
      'Narx koʻrinib tursa, mijozlar tezroq yozadi.';

  @override
  String get priceChoiceRequestHint => 'Qancha toʻlashga tayyorsiz?';

  @override
  String get priceChoiceNegotiable => 'Kelishiladi';

  @override
  String get priceChoiceNegotiableHint => 'Suhbatda kelishasiz';

  @override
  String get priceChoiceAmount => 'Aniq narx';

  @override
  String get priceChoiceAmountHint => 'Summa va birlik';

  @override
  String get priceAmountLabel => 'Summa (soʻm)';

  @override
  String get priceAmountHint => 'Masalan: 150000';

  @override
  String get priceUnitFixed => 'Ish uchun';

  @override
  String get priceUnitHour => 'Soatiga';

  @override
  String get priceUnitDay => 'Kuniga';

  @override
  String get priceUnitMonth => 'Oyiga';

  @override
  String get priceUnitUnit => 'Donasiga';

  @override
  String get priceChoiceRequired =>
      'Narxni tanlang: kelishiladi yoki aniq summa';

  @override
  String get growthI00Title => 'Xizmatingiz YordamBorʼda!';

  @override
  String get growthI00Body =>
      'Tabriklaymiz! 30 kun davomida koʻproq mijoz topishga yordam beradigan qisqa maslahatlar yuboramiz.';

  @override
  String get growthI01Title => 'Rasmlar ishonch uygʻotadi';

  @override
  String get growthI01Body =>
      'Ishingizdan kamida 3 ta rasm qoʻshing — «oldin va keyin» suratlari ayniqsa yaxshi ishlaydi.';

  @override
  String get growthI02Title => 'Narxni koʻrsating';

  @override
  String get growthI02Body =>
      'Aniq narx — kamroq savol va tezroq kelishuv. Soat, kun yoki ish uchun narx qoʻying.';

  @override
  String get growthI03Title => 'Qachon boʻshsiz?';

  @override
  String get growthI03Body =>
      'Holatingizni «Hozir mavjud» qiling: mijozlar tez kela oladigan ustaga birinchi yozadi.';

  @override
  String get growthI04Title => 'Mijozlaringizni YordamBorʼga taklif qiling';

  @override
  String get growthI04Body =>
      'Doimiy mijozlaringizga xizmatingiz havolasini yuboring: keyingi safar sizni bir bosishda topishadi.';

  @override
  String get growthI05Title => 'Tez javob — koʻproq ish';

  @override
  String get growthI05Body =>
      'Soʻrovlarga bir soat ichida javob bering: mijozlar odatda birinchi javob berganni tanlaydi.';

  @override
  String get growthI06Title => 'Oʻzingiz haqingizda yozing';

  @override
  String get growthI06Body =>
      'Tajribangiz va ish uslubingizni 3–4 gapda yozing: mijoz kim bilan ishlashini bilishni xohlaydi.';

  @override
  String get growthI07Title => 'Sharh — eng yaxshi reklama';

  @override
  String get growthI07Body =>
      'Ish tugagach, mijozdan YordamBorʼda sharh qoldirishni soʻrang: har bir baho yangi mijoz olib keladi.';

  @override
  String get growthI08Title => 'YordamBor doʻstlaringizga ham kerak';

  @override
  String get growthI08Body =>
      'Doʻst va qoʻshnilaringizga YordamBor haqida aytib bering: mijozlar koʻpaysa, buyurtmalar ham koʻpayadi.';

  @override
  String get growthI09Title => 'Kalendaringizni yangilang';

  @override
  String get growthI09Body =>
      'Band kunlaringizni belgilang: mijozlar boʻsh vaqtingizni koʻrib, aniq kunga yozilishadi.';

  @override
  String get growthI10Title => 'Daromadingizni kuzating';

  @override
  String get growthI10Body =>
      '«Instrumentlar»da daromad, mijozlar daftari va chek bor: hammasi bir joyda.';

  @override
  String get growthI11Title => '30 kun — zoʻr boshlanish!';

  @override
  String get growthI11Body =>
      'Xizmatingiz havolasini ijtimoiy tarmoqlarda ulashing va YordamBorʼda oʻsishda davom eting.';

  @override
  String get growthO00Title => 'Tashkilotingiz YordamBorʼda!';

  @override
  String get growthO00Body =>
      'Tabriklaymiz! 30 kun davomida mijozlar oqimini oshirish uchun qisqa maslahatlar yuboramiz.';

  @override
  String get growthO01Title => 'Joyingizni koʻrsating';

  @override
  String get growthO01Body =>
      'Bino, jamoa va ishlaringizdan kamida 3 ta rasm qoʻshing: mijoz qayerga kelishini oldindan koʻradi.';

  @override
  String get growthO02Title => 'Narxlarni oching';

  @override
  String get growthO02Body =>
      'Asosiy xizmat narxini koʻrsating: mijozlar narxi aniq tashkilotlarga koʻproq yozadi.';

  @override
  String get growthO03Title => 'Ish vaqtini belgilang';

  @override
  String get growthO03Body =>
      'Ish kunlari va soatlaringizni kiriting: mijozlar qachon kelish mumkinligini darhol koʻradi.';

  @override
  String get growthO04Title => 'Mijozlaringizni YordamBorʼga taklif qiling';

  @override
  String get growthO04Body =>
      'Havolani Telegram kanalingizda, kassada yoki SMSʼda ulashing: mijozlar sizni bir bosishda topadi.';

  @override
  String get growthO05Title => 'Litsenziya va sertifikatlar';

  @override
  String get growthO05Body =>
      'Hujjatlaringizni profilga qoʻshing: rasmiy tasdiq tashkilotga ishonchni oshiradi.';

  @override
  String get growthO06Title => 'Har bir yoʻnalish — alohida xizmat';

  @override
  String get growthO06Body =>
      'Xizmatlaringizni alohida qoʻshing (5 tagacha): mijoz aynan keraklisini tezroq topadi.';

  @override
  String get growthO07Title => 'Soʻrovlarga tez javob bering';

  @override
  String get growthO07Body =>
      'Javob berish uchun masʼul xodimni belgilang: tez javob — koʻproq kelishuv.';

  @override
  String get growthO08Title => 'Har bir mijozdan sharh soʻrang';

  @override
  String get growthO08Body =>
      'Mamnun mijozlar sharhi reytingingizni oshiradi va yangi mijozlarni olib keladi.';

  @override
  String get growthO09Title => 'Havolani vizitkaga joylang';

  @override
  String get growthO09Body =>
      'YordamBor havolangizni vizitka, menyu yoki vitrinaga qoʻying: yozilish bir bosishda.';

  @override
  String get growthO10Title => 'Hisob-kitob bir joyda';

  @override
  String get growthO10Body =>
      'Chek, daromad va mijozlar daftari «Instrumentlar»da: tashkilotingizni tartibli boshqaring.';

  @override
  String get growthO11Title => 'Birinchi oy yakunlandi!';

  @override
  String get growthO11Body =>
      'Natijalarni xizmat kartangizda koʻring va YordamBorʼda mijozlaringizni koʻpaytirishda davom eting.';

  @override
  String get growthProgramTitle => 'Biznesingizni oʻstiring';

  @override
  String growthProgramDay(int day) {
    return '$day-kun · 30 kunlik dastur';
  }

  @override
  String get growthTipDone => 'Bajarildi';

  @override
  String get growthEarlierTips => 'Oldingi maslahatlar';

  @override
  String get growthTipsOff => 'Maslahatlarni oʻchirish';

  @override
  String get growthTipsOffDone =>
      'Maslahatlar oʻchirildi. Eslatma sozlamalarida qayta yoqasiz.';

  @override
  String get growthTipsSetting => 'Biznes maslahatlari';

  @override
  String get growthTipsSettingSub =>
      'Xizmat qoʻshganingizdan keyin 30 kun davomida';

  @override
  String growthInviteShareText(String link) {
    return 'YordamBor — ishonchli ustalar va xizmatlar bir joyda. Yuklab oling: $link';
  }

  @override
  String get growthActionPhotos => 'Rasm qoʻshish';

  @override
  String get growthActionPrice => 'Narxni qoʻyish';

  @override
  String get growthActionAvailability => 'Holatni belgilash';

  @override
  String get growthActionHours => 'Ish vaqtini kiritish';

  @override
  String get growthActionShare => 'Havolani ulashish';

  @override
  String get growthActionInvite => 'Taklif qilish';

  @override
  String get growthActionReply => 'Soʻrovlarni ochish';

  @override
  String get growthActionDescription => 'Tavsifni yozish';

  @override
  String get growthActionReviews => 'Kelishuvlarni ochish';

  @override
  String get growthActionCalendar => 'Kalendarni ochish';

  @override
  String get growthActionTools => 'Instrumentlarni ochish';

  @override
  String get growthActionCertificates => 'Hujjat qoʻshish';

  @override
  String get growthActionMoreServices => 'Xizmat qoʻshish';

  @override
  String get growthActionMyServices => 'Xizmatlarimni koʻrish';

  @override
  String get appointmentPhaseNow => 'Hozir';

  @override
  String get appointmentPhaseToday => 'Bugun';

  @override
  String get appointmentPhasePlanned => 'Rejada';

  @override
  String get appointmentPhasePast => 'Yakunlash kutilmoqda';

  @override
  String get appointmentPhaseDone => 'Bajarildi';

  @override
  String get appointmentPhaseCancelled => 'Bekor qilingan';

  @override
  String get appointmentRoleProvider => 'Men xizmat beraman';

  @override
  String get appointmentRoleClient => 'Men olaman';

  @override
  String get appointmentPartyClient => 'Mijoz';

  @override
  String get appointmentPartyProvider => 'Xizmat beruvchi';

  @override
  String get appointmentCall => 'Qoʻngʻiroq';

  @override
  String get actionChat => 'Yozish';

  @override
  String get actionKeep => 'Qoldirish';

  @override
  String get appointmentCancel => 'Bekor qilish';

  @override
  String get appointmentCancelTitle => 'Uchrashuvni bekor qilasizmi?';

  @override
  String get appointmentCancelBody =>
      'Bu amalni qaytarib boʻlmaydi. Ikkinchi tomon xabardor qilinadi.';

  @override
  String get appointmentCancelConfirm => 'Ha, bekor qilish';

  @override
  String get appointmentSaveClient => 'Mijozlar roʻyxatiga saqlash';

  @override
  String get appointmentFactPrice => 'NARX';

  @override
  String get appointmentFactDuration => 'DAVOMIYLIGI';

  @override
  String appointmentDuration(int minutes) {
    return '$minutes min';
  }

  @override
  String get availabilitySheetCaption => 'Mijozlar hozir nima koʻradi?';

  @override
  String get availabilityTileNowHint => 'Hozir buyurtma qabul qilyapman';

  @override
  String get availabilityTileBusyHint => 'Band, tez qaytaman';

  @override
  String get availabilityTileBookingHint => 'Oldindan band qiling';

  @override
  String get availabilityTileHidden => 'Yashirilgan';

  @override
  String get availabilityTileHiddenHint => 'Xizmat koʻrinmaydi';

  @override
  String get availabilityUntilTitle => 'Qachongacha?';

  @override
  String get availabilityUntilHour => '1 soat';

  @override
  String get availabilityUntilToday => 'Bugun';

  @override
  String get availabilityUntilForever => 'Muddatsiz';

  @override
  String get availabilityHoursTitle => 'Ish vaqti';

  @override
  String get availabilityHoursOwn => 'Mening jadvalim';

  @override
  String get availabilityHoursShared => 'Umumiy vaqt';

  @override
  String get availabilityBusyToggle => 'Mijozlarga band vaqtni koʻrsat';

  @override
  String get availabilityBusyToggleHint =>
      'Mijozlar ikki haftalik jadvalda boʻsh va band vaqtingizni koʻradi';

  @override
  String get availabilityPreview => 'Koʻrinish';

  @override
  String get availabilityHiddenPreview => 'Qidirishda yashirilgan';

  @override
  String get availabilitySaved => 'Status saqlandi';

  @override
  String get businessEmptyTitle => 'YordamBorda pul ishlashni boshlang';

  @override
  String get businessEmptyBody =>
      'Yaqin atrofda minglab odamlar hozir yordam qidirmoqda. Birinchi xizmatingizni qoʻshing — bu atigi 2 daqiqa oladi.';

  @override
  String get calendarTabTitle => 'Jadval';

  @override
  String get calendarNoAppointments => 'Hali uchrashuvlar yoʻq';

  @override
  String get calendarNoAppointmentsHint =>
      'Kelishilgan bitimlar uchrashuvlar sifatida bu yerda koʻrinadi';

  @override
  String get calendarSectionToday => 'Bugun';

  @override
  String get calendarSectionUpcoming => 'Rejalashtirilgan';

  @override
  String get calendarSectionPast => 'Oʻtgan';

  @override
  String get calendarBusyTitle => 'Mening bandligim';

  @override
  String get calendarBusyAllDay => 'Butun kun band';

  @override
  String get calendarBusyHours => 'Band vaqt';

  @override
  String get calendarServicesStrip => 'Xizmatlarim';

  @override
  String get calendarReminders => 'Eslatmalar';

  @override
  String get reminderLeadDay => '1 kun oldin';

  @override
  String get reminderLead3Hours => '3 soat oldin';

  @override
  String get reminderLeadHour => '1 soat oldin';

  @override
  String get reminderLead15Min => '15 daqiqa oldin';

  @override
  String get saveClientPromptTitle => 'Mijozni saqlaysizmi?';

  @override
  String saveClientPromptBody(String name) {
    return '${name}ni mijozlar roʻyxatiga qoʻshmoqchimisiz?';
  }

  @override
  String get saveClientConfirm => 'Saqlash';

  @override
  String get saveClientSkip => 'Keyinroq';

  @override
  String get saveClientDone => 'Mijoz saqlandi';

  @override
  String get notifSectionSoon => 'Yaqin uchrashuvlar';

  @override
  String get notifAppointmentCancelledTitle => 'Uchrashuv bekor qilindi';

  @override
  String get notifSubsectorHelpTitle => 'Sizning sochangizda yordam kerak';

  @override
  String reminderLeadMinutes(int count) {
    return '$count daqiqa oldin';
  }

  @override
  String reminderLeadHours(int count) {
    return '$count soat oldin';
  }

  @override
  String reminderLeadDays(int count) {
    return '$count kun oldin';
  }

  @override
  String reminderFollowUpAfterHours(int count) {
    return '$count soatdan keyin';
  }

  @override
  String get reminderFollowUpServiceDone => 'Xizmat bajarildimi?';

  @override
  String reminderDefaultBody(String name) {
    return '$name bilan uchrashuv';
  }

  @override
  String get remindersSettingsPickOne => 'Kamida bitta vaqtni tanlang';

  @override
  String get remindersSettingsFollowUpHint =>
      'Qanday oʻtganini soʻraymiz — kelishuv va daromadingiz yangilanib turadi.';

  @override
  String get alertFromServiceTag => 'Xizmatingiz uchun';

  @override
  String get alertFromServiceHint =>
      'Ushbu xizmatni qoʻshganingizda yaratildi. Keraksizini oʻchirib qoʻying.';

  @override
  String get alertAnyCity => 'Istalgan shahar';

  @override
  String get errSignInRequired => 'Kirish talab qilinadi';

  @override
  String get errServerNotSetUp => 'Supabase sozlanmagan';

  @override
  String get errGoogleSignInFailed =>
      'Google orqali kirib bo\'lmadi. Qaytadan urinib ko\'ring.';

  @override
  String get errTelegramOpenFailed =>
      'Telegram sahifasini ochib bo\'lmadi. Qaytadan urinib ko\'ring.';

  @override
  String get errNoPermission => 'Ruxsat yoʻq';

  @override
  String get errDealNotFound => 'Kelishuv topilmadi';

  @override
  String get errServiceNotFound => 'Xizmat topilmadi';

  @override
  String get errOwnService => 'Oʻz xizmatingizga soʻrov yuborib boʻlmaydi';

  @override
  String get errOwnRequest => 'Oʻz eʼloningizga taklif yuborib boʻlmaydi';

  @override
  String get errDealNotCreated => 'Kelishuv yaratilmadi';

  @override
  String get errPhotoRequired => 'Kamida bitta portfolio rasmi kerak';

  @override
  String get errOfferViaOwnService =>
      'Faqat oʻz xizmatingiz orqali taklif yuboring';

  @override
  String get errRequestNotFound => 'Eʼlon topilmadi';

  @override
  String get errServiceNotUploaded => 'Xizmat yaratildi, lekin yuklanmadi';

  @override
  String get errMessageTooShort => 'Xabar juda qisqa';

  @override
  String get errMessageEmpty => 'Xabar boʻsh boʻlmasin';

  @override
  String get errWrongPhoneOrPassword => 'Telefon raqami yoki parol notoʻgʻri';

  @override
  String get errDescriptionTooShort =>
      'Tavsif kamida 10 ta belgidan iborat boʻlsin';

  @override
  String get errPickSubcategory => 'Subsohani tanlang';

  @override
  String get errPickCategory => 'Sohani tanlang';

  @override
  String get errTermsOnlyOpenDeal =>
      'Shartlarni faqat faol kelishuvda oʻzgartirish mumkin';

  @override
  String get errPickCity => 'Shaharni tanlang';

  @override
  String get errTitleMin3 => 'Sarlavha kamida 3 ta belgidan iborat boʻlsin';

  @override
  String get errTitleMin2 => 'Sarlavha kamida 2 ta belgidan iborat boʻlsin';

  @override
  String get errSignUpFailed => 'Roʻyxatdan oʻtish amalga oshmadi';

  @override
  String get errResetLinkExpired =>
      'Parolni tiklash havolasi muddati tugagan. Qayta soʻrang.';

  @override
  String get errCannotBlockSelf => 'Oʻzingizni bloklab boʻlmaydi';

  @override
  String errMaxAlerts(int count) {
    return 'Koʻpi bilan $count ta sozlama';
  }

  @override
  String errMaxCertificates(int count) {
    return 'Koʻpi bilan $count ta sertifikat';
  }

  @override
  String get errDealNotUpdated => 'Kelishuv yangilanmadi';

  @override
  String get errKeepOnePhoto => 'Kamida bitta portfolio rasmi qolishi kerak';

  @override
  String get errPickAlertType => 'Kamida bitta bildirishnoma turini tanlang';

  @override
  String get errOwnProfileOnly =>
      'Faqat oʻz profilingizga qoʻshishingiz mumkin';

  @override
  String get errOnlyAgreedDone =>
      'Faqat jarayondagi kelishuvni yakunlash mumkin';

  @override
  String get errEmailNotFound => 'Email topilmadi';

  @override
  String get errDealAlreadyOpen =>
      'Bu xizmat uchun faol kelishuv allaqachon mavjud';

  @override
  String get errAccountNotFound =>
      'Bu telefon yoki email bilan hisob topilmadi';

  @override
  String get errAlreadyReviewed =>
      'Bu kelishuv uchun baho allaqachon qoldirilgan';

  @override
  String get errUserBlocked => 'Bu foydalanuvchi bilan aloqa bloklangan';

  @override
  String get errNotNow => 'Bu amal hozirgi holatda mumkin emas';

  @override
  String get errRatingRange => 'Baho 1 dan 5 gacha boʻlishi kerak';

  @override
  String get errTermsLocked =>
      '3 kundan keyin shartlarni oʻzgartirib boʻlmaydi';

  @override
  String get errSlowNetwork =>
      'Internet aloqasi sekin yoki server javob bermayapti. Keyinroq qayta urinib koʻring.';

  @override
  String get errTooManyAttempts =>
      'Juda koʻp urinish. 15 daqiqadan keyin qayta urinib koʻring yoki email bilan kiring.';

  @override
  String get errProjectDescriptionTooShort =>
      'Loyiha tavsifi kamida 10 ta belgidan iborat boʻlsin';

  @override
  String errMaxServices(int count) {
    return 'Koʻpi bilan $count ta xizmat yaratish mumkin';
  }

  @override
  String get errDoneAfter3Days =>
      'Ishni tugatish jarayon boshlanganidan 3 kun oʻtgach mumkin';

  @override
  String get errOffline =>
      'Internet aloqasi yoʻq yoki serverga ulanib boʻlmadi. Keyinroq qayta urinib koʻring.';

  @override
  String get dealAcceptTitle => 'Qabul qilasizmi?';

  @override
  String get dealAcceptBody =>
      'Kelishuv shartlarini qabul qilganingizdan keyin ikkinchi tomon ham tasdiqlashi kerak.';

  @override
  String get dealDoneTitle => 'Ish bajarildimi?';

  @override
  String get dealDoneBodyLast => 'Siz tasdiqlasangiz, kelishuv yakunlanadi.';

  @override
  String get dealDoneBodyFirst =>
      'Ish toʻliq bajarilganini tasdiqlaysizmi? Ikkinchi tomon ham tasdiqlashi kerak.';

  @override
  String get dealDoneConfirm => 'Bajarildi';

  @override
  String get dealCancelTitle => 'Bekor qilasizmi?';

  @override
  String get dealCancelBody =>
      'Kelishuv bekor qilinadi. Bu amalni qaytarib boʻlmaydi.';

  @override
  String get dealEditTitle => 'Shartlarni oʻzgartirasizmi?';

  @override
  String get dealEditBody =>
      'Oʻzgarishdan keyin ikkala tomon ham qayta tasdiqlashi kerak boʻladi.';

  @override
  String get actionYes => 'Ha';

  @override
  String get actionNo => 'Yoʻq';

  @override
  String get fallbackUserName => 'Foydalanuvchi';

  @override
  String get fallbackServiceName => 'Xizmat';

  @override
  String get fallbackYou => 'Siz';

  @override
  String get channelAlerts => 'Bildirishnomalar';

  @override
  String get channelAlertsSub => 'Kelishuv va subsoha bildirishnomalari';

  @override
  String get channelReminders => 'Eslatmalar';

  @override
  String get channelRemindersSub => 'Kelishuv va mijoz eslatmalari';

  @override
  String get channelTips => 'Maslahatlar';

  @override
  String get channelTipsSub => 'Biznesingizni oʻstirish boʻyicha maslahatlar';

  @override
  String get errBadApiKey =>
      'Supabase API kaliti notoʻgʻri. .env.json faylida anon key ni tekshiring va ilovani qayta ishga tushiring.';

  @override
  String get errWrongEmailOrPassword => 'Email yoki parol notoʻgʻri';

  @override
  String get errEmailNotConfirmed =>
      'Email tasdiqlanmagan. Pochtangizdagi havolani bosing yoki qayta yuboring.';

  @override
  String get errEmailTaken =>
      'Bu email bilan hisob mavjud. Kirishni sinab koʻring.';

  @override
  String get errPhoneTaken => 'Bu telefon raqami allaqachon roʻyxatdan oʻtgan';

  @override
  String get socialOrEmail => 'yoki email bilan';

  @override
  String get socialContinueGoogle => 'Google bilan davom etish';

  @override
  String get socialContinueTelegram => 'Telegram bilan davom etish';

  @override
  String get profileSetupTitle => 'Profilingizni to\'ldiring';

  @override
  String get profileSetupNameHint => 'Ismingiz va familiyangiz';

  @override
  String get profileSetupNameRequired => 'Ism kiritish shart';

  @override
  String get profileSetupNameFull => 'Ism va familiyani kiriting';

  @override
  String get profileSetupPhoneRequired => 'Telefon raqami kiritish shart';

  @override
  String get profileSetupPhoneIncomplete => 'Raqam to\'liq emas';

  @override
  String get profileSetupPhoneOnce =>
      'Bir telefon raqami faqat bitta hisob uchun ishlatilishi mumkin.';

  @override
  String profileSetupSignedInWith(String provider) {
    return '$provider orqali kirdiniz';
  }
}
