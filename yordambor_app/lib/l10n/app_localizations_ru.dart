// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'YordamBor';

  @override
  String get splashTagline => 'На YordamBor есть помощь!';

  @override
  String get tabHome => 'Главная';

  @override
  String get tabCalendar => 'Календарь';

  @override
  String get calendarGuestSubtitle =>
      'Войдите, чтобы видеть расписание и отмечать занятость.';

  @override
  String get calendarProviderHint =>
      'Нажмите на день, затем отметьте «свободен» или «занят».';

  @override
  String get calendarClientHint =>
      'Встречи и напоминания отображаются в календаре. Нажмите на день для деталей.';

  @override
  String get calendarLegendAvailable => 'Свободен';

  @override
  String get calendarLegendBusy => 'Занят';

  @override
  String get calendarLegendAppointment => 'Встреча';

  @override
  String get calendarMarkAvailable =>
      'Отмечено: свободен — нажмите, чтобы изменить';

  @override
  String get calendarMarkBusy => 'Отмечено: занят — нажмите, чтобы изменить';

  @override
  String get calendarMarkUnset => 'Отметить день: свободен / занят';

  @override
  String get calendarNoEventsDay => 'На этот день встреч нет.';

  @override
  String get calendarWeekdayMon => 'Пн';

  @override
  String get calendarWeekdayTue => 'Вт';

  @override
  String get calendarWeekdayWed => 'Ср';

  @override
  String get calendarWeekdayThu => 'Чт';

  @override
  String get calendarWeekdayFri => 'Пт';

  @override
  String get calendarWeekdaySat => 'Сб';

  @override
  String get calendarWeekdaySun => 'Вс';

  @override
  String get tabFavorites => 'Избранное';

  @override
  String get tabBusiness => 'Бизнес';

  @override
  String get businessTabServices => 'Услуги';

  @override
  String get businessTabTools => 'Инструменты';

  @override
  String get businessToolsSubtitle =>
      'Книга клиентов, квитанции, доход и другие инструменты.';

  @override
  String get myXizmatlarGuestSubtitle =>
      'Войдите, чтобы управлять услугами и инструментами.';

  @override
  String get tabProfile => 'Профиль';

  @override
  String get filterYordamBor => 'Есть помощь';

  @override
  String get filterYordamKerak => 'Нужна помощь';

  @override
  String get filterCategory => 'Сфера';

  @override
  String get filterSubcategory => 'Подсфера';

  @override
  String get filterPickCategoryFirst => 'Сначала выберите сферу';

  @override
  String get filterProviderType => 'Тип';

  @override
  String get filterProviderAll => 'Все типы';

  @override
  String get filterProviderTypeHint => 'Выберите тип исполнителя';

  @override
  String get filterProviderAllHint => 'Физлица и организации';

  @override
  String get filterProviderIndividualHint => 'Частные мастера, репетиторы';

  @override
  String get filterProviderInstitutionHint => 'Клиники, студии, компании';

  @override
  String get filterAllCategories => 'Все сферы';

  @override
  String get filterAllSubcategories => 'Все подсферы';

  @override
  String get filterCategoryHint => 'В какой сфере ищете?';

  @override
  String get filterAllCategoriesHint => 'Услуги во всех сферах';

  @override
  String get filterAllSubcategoriesHint => 'Все направления выбранной сферы';

  @override
  String get filterCity => 'Город';

  @override
  String get filterAllCities => 'Все города';

  @override
  String get filterCityHint => 'В каком городе нужна услуга?';

  @override
  String get filterAllCitiesHint => 'Объявления во всех городах';

  @override
  String get xizmatServiceCityRequired => 'Выберите город обслуживания';

  @override
  String get serviceCityToshkent => 'Ташкент';

  @override
  String get serviceCityToshkentViloyati => 'Ташкентская область';

  @override
  String get serviceCitySamarqand => 'Самарканд';

  @override
  String get serviceCityBuxoro => 'Бухара';

  @override
  String get serviceCityNukus => 'Нукус';

  @override
  String get serviceCityNamangan => 'Наманган';

  @override
  String get serviceCityAndijon => 'Андижан';

  @override
  String get serviceCityFargona => 'Фергана';

  @override
  String get serviceCityQarshi => 'Карши';

  @override
  String get serviceCityUrganch => 'Ургенч';

  @override
  String get serviceCityTermiz => 'Термез';

  @override
  String get serviceCityJizzax => 'Джизак';

  @override
  String get serviceCityNavoiy => 'Навои';

  @override
  String get serviceCityQoqon => 'Коканд';

  @override
  String get serviceCityGuliston => 'Гулистан';

  @override
  String get serviceCityBoshqa => 'Другое';

  @override
  String homeFeedShowing(String summary) {
    return 'Показано: $summary';
  }

  @override
  String get filterPickProviderTypeFirst =>
      'Сначала выберите частное лицо или организацию';

  @override
  String get homeEmptyTitle => 'Скоро здесь появятся услуги';

  @override
  String get homeEmptySubtitle =>
      'Подождите, пока исполнители из разных сфер добавят портфолио';

  @override
  String get homeDemoXizmat => 'Демо-услуги показаны как примеры';

  @override
  String get homeDemoPosts => 'Демо-объявления показаны как примеры';

  @override
  String get homeJobsEmptyTitle => 'Нужна помощь';

  @override
  String get homeJobsEmptySubtitle =>
      'Опубликуйте первое объявление или измените фильтры';

  @override
  String get favoritesEmptyTitle => 'Сохраняйте понравившиеся услуги';

  @override
  String get favoritesEmptySubtitle => 'Нажмите ♥ на карточке';

  @override
  String get profileGuestTitle => 'Добро пожаловать в YordamBor';

  @override
  String get profileGuestSubtitle =>
      'Регистрация для сделок и объявлений. Избранное работает без аккаунта.';

  @override
  String get profilePhone => 'Телефон';

  @override
  String get profileChangePhoto => 'Изменить фото';

  @override
  String get profilePhotoUpdated => 'Фото профиля обновлено';

  @override
  String get profilePhotoFailed => 'Не удалось загрузить фото';

  @override
  String get login => 'Войти';

  @override
  String get register => 'Регистрация';

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String get notificationsEmpty => 'Уведомлений пока нет';

  @override
  String get fabPostYordamKerak => 'Опубликовать';

  @override
  String get welcomeTitle => 'На YordamBor помощь есть!';

  @override
  String get welcomeBrand => 'YordamBor.';

  @override
  String get welcomeBody =>
      'Находите услуги в любой сфере. Помогайте или просите помощь.';

  @override
  String get startBrowsing => 'Начать';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get authContinueTitle => 'Войдите, чтобы продолжить';

  @override
  String get authContextGeneric => 'Войдите, чтобы продолжить';

  @override
  String get authContextFavorite => 'Войдите, чтобы сохранить в избранное';

  @override
  String get authContextYordamKerak => 'Войдите, чтобы отправить запрос';

  @override
  String get authContextYordamBor => 'Войдите, чтобы отправить предложение';

  @override
  String get authContextPostJob => 'Войдите, чтобы опубликовать';

  @override
  String get authContextDeal => 'Войдите, чтобы начать сделку';

  @override
  String get later => 'Позже';

  @override
  String get fullName => 'Полное имя';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Телефон';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Повтор пароля';

  @override
  String get fieldRequired => 'Это поле обязательно';

  @override
  String get invalidEmail => 'Введите корректный email';

  @override
  String get invalidPhone => 'Введите корректный номер телефона (+998…)';

  @override
  String get invalidNumber => 'Введите корректное число';

  @override
  String get invalidMinutes => 'Введите корректное количество минут';

  @override
  String get passwordTooShort => 'Пароль должен содержать минимум 8 символов';

  @override
  String get passwordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get acceptTermsRequired => 'Примите условия использования';

  @override
  String get acceptTerms => 'Принимаю условия использования';

  @override
  String get acceptTermsLead => 'Принимаю ';

  @override
  String get acceptTermsLink => 'условия использования';

  @override
  String get acceptTermsTrail => '';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get resetPasswordTitle => 'Новый пароль';

  @override
  String get resetPasswordBody => 'Введите и сохраните новый пароль.';

  @override
  String get resetPasswordSubmit => 'Сохранить пароль';

  @override
  String get resetPasswordSuccess => 'Пароль обновлён';

  @override
  String get resetPasswordSendLink => 'Отправить ссылку';

  @override
  String resetPasswordEmailSent(String emailAddress) {
    return 'Мы отправили ссылку для сброса пароля на $emailAddress.';
  }

  @override
  String get resetPasswordEmailHint =>
      'Откройте ссылку на телефоне. Приложение откроется для установки нового пароля.';

  @override
  String get resetPasswordExpiredTitle => 'Ссылка истекла';

  @override
  String get resetPasswordExpiredBody =>
      'Запросите новую ссылку для сброса пароля.';

  @override
  String get continueAction => 'Продолжить';

  @override
  String get verifyEmailTitle => 'Подтвердите email';

  @override
  String verifyEmailBody(String emailAddress) {
    return 'Мы отправили ссылку на $emailAddress.';
  }

  @override
  String get verifyEmailBodyMissing =>
      'Мы отправили ссылку на ваш email. После подтверждения нажмите «Я подтвердил».';

  @override
  String get verifyEmailCheck => 'Я подтвердил';

  @override
  String get verifyEmailPending => 'Email ещё не подтверждён. Проверьте почту.';

  @override
  String get openMail => 'Открыть почту';

  @override
  String get resendEmail => 'Отправить снова';

  @override
  String get continueBrowsing => 'Продолжить просмотр';

  @override
  String welcomeBack(String name) {
    return 'Добро пожаловать, $name!';
  }

  @override
  String get welcomeGuestName => 'друг';

  @override
  String welcomeNewTitle(String name) {
    return 'Добро пожаловать, $name!';
  }

  @override
  String get welcomeNewBody =>
      'Мы рады, что вы присоединились к YordamBor. Находите услуги, помогайте другим или публикуйте объявления — мы рядом на каждом шаге.';

  @override
  String welcomeLoginTitle(String name) {
    return 'С возвращением, $name!';
  }

  @override
  String get welcomeLoginBody =>
      'Рады снова вас видеть. Чем можем помочь сегодня?';

  @override
  String welcomeReturnTitle(String name) {
    return 'Здравствуйте, $name!';
  }

  @override
  String get welcomeReturnBody => 'Нужные услуги ждут Вас';

  @override
  String get welcomeReturnBodyYordamKerak =>
      'Ваши услуги подходят под запросы клиентов?';

  @override
  String homeGreetingShort(String name) {
    return 'Здравствуйте, $name!';
  }

  @override
  String get homeGreetingYordamBor => 'Какая помощь вам нужна сегодня?';

  @override
  String get homeGreetingYordamKerak => 'Можете помочь сегодня?';

  @override
  String get providerPromptTitle => 'Оказываете услуги?';

  @override
  String get providerPromptBody => 'Добавьте портфолио — клиенты найдут вас.';

  @override
  String get createXizmat => 'Создать услугу';

  @override
  String get signOut => 'Выйти';

  @override
  String get settings => 'Настройки';

  @override
  String get settingsSubtitle => 'Язык, конфиденциальность, аккаунт';

  @override
  String get settingsAppearance => 'Оформление';

  @override
  String get settingsDarkMode => 'Тема';

  @override
  String get settingsThemeSystem => 'Системная';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsTools => 'Инструменты';

  @override
  String get settingsLegal => 'Правовая информация';

  @override
  String get settingsPrivacy => 'Политика конфиденциальности';

  @override
  String get settingsPrivacySection => 'Конфиденциальность';

  @override
  String get settingsShowPhoneLabel => 'Показывать телефон в профиле';

  @override
  String get settingsShowPhoneSubtitle =>
      'Номер телефона виден в открытом профиле';

  @override
  String get postContactSectionTitle => 'Контакт';

  @override
  String get postContactSectionSubtitle =>
      'Профиль всегда открыт. Показ телефона — по вашему выбору.';

  @override
  String get postContactPhoneLabel => 'Номер телефона';

  @override
  String get postContactPhoneHint => '+998 90 123 45 67';

  @override
  String get postContactPhoneOptional => 'Необязательно';

  @override
  String get postShowPhoneLabel => 'Показывать телефон';

  @override
  String get postShowPhoneSubtitle => 'Телефон будет виден в этом объявлении';

  @override
  String get postShowProfileLabel => 'Показывать профиль';

  @override
  String get postShowProfileSubtitle =>
      'Пользователи смогут открыть ваш профиль';

  @override
  String get postAuthorHidden => 'Автор скрыт';

  @override
  String get settingsTerms => 'Условия использования';

  @override
  String get settingsDeleteAccount => 'Удалить аккаунт';

  @override
  String get settingsDeleteAccountHint => 'Все сделки будут отменены';

  @override
  String get settingsDeleteAccountConfirm =>
      'Все ваши данные, услуги и активные сделки будут удалены. Это необратимо.';

  @override
  String get settingsDeleteAccountAction => 'Удалить аккаунт';

  @override
  String get settingsDeleteAccountDone => 'Аккаунт удалён';

  @override
  String get remindersTitle => 'Напоминания';

  @override
  String get remindersAdd => 'Добавить напоминание';

  @override
  String get remindersEmptyTitle => 'Нет напоминаний';

  @override
  String get remindersEmptySubtitle =>
      'Синхронизировано с календарём клиентов. Также создаются при начале сделки';

  @override
  String get remindersFieldClientName => 'Имя клиента';

  @override
  String get remindersUpcoming => 'Предстоящие';

  @override
  String get remindersPast => 'Прошедшие';

  @override
  String get remindersFieldTitle => 'Заголовок';

  @override
  String get remindersFieldBody => 'Заметка (необязательно)';

  @override
  String get remindersSave => 'Сохранить';

  @override
  String get remindersSettingsSubtitle => 'Напоминания о сделках и встречах';

  @override
  String get legalPrivacyTitle => 'Политика конфиденциальности';

  @override
  String get legalTermsTitle => 'Условия использования';

  @override
  String get legalPrivacyBody =>
      'YordamBor использует ваши данные только для услуг, сделок и безопасности.\n\n1. Какие данные собираются\n\nИмя, email, телефон, фото портфолио, сообщения сделок и уведомления.\n\n2. Где хранятся\n\nДанные хранятся в зашифрованном виде на серверах Supabase.\n\n3. Третьи стороны\n\nМы не продаём ваши данные. Передаём только техническим партнёрам, необходимым для работы приложения.\n\n4. Ваши права\n\nВы можете просматривать, обновлять или удалить аккаунт и данные.\n\n5. Контакты\n\nВопросы — через раздел Настройки в приложении.';

  @override
  String get legalTermsBody =>
      'YordamBor — мобильная платформа, соединяющая исполнителей и клиентов из разных сфер. Использование приложения означает принятие этих условий.\n\n1. Общие положения\n\nYordamBor не оказывает услуги сам — он соединяет стороны. Платформа не является платёжным посредником.\n\n2. Аккаунт и регистрация\n\nВы обязаны предоставлять точные и актуальные данные и подтвердить email.\n\n3. Услуги и портфолио\n\nКаждое объявление должно содержать минимум одно реальное фото портфолио. Ложные или незаконные объявления могут быть удалены.\n\n4. Сделки (Yordam Bor / Yordam Kerak)\n\nЦена, сроки и объём работ согласуются сторонами. YordamBor хранит процесс сделки, но не принимает оплату.\n\n5. Запрещённые действия\n\nМошенничество, оскорбления, спам, незаконные услуги или нарушение правил запрещены.\n\n6. Блокировка аккаунта\n\nYordamBor может временно или навсегда заблокировать аккаунт при нарушении условий.\n\n7. Изменения\n\nУсловия могут обновляться. Продолжение использования означает согласие с новой версией.\n\n8. Контакты\n\nВопросы — через раздел Настройки в приложении.';

  @override
  String get shareXizmat => 'Поделиться';

  @override
  String shareXizmatMessage(String name) {
    return 'Посмотрите $name на YordamBor';
  }

  @override
  String get shareYordamKerak => 'Поделиться запросом';

  @override
  String shareYordamKerakMessage(String title) {
    return 'Нужна помощь: $title на YordamBor';
  }

  @override
  String get postNotFound => 'Запрос не найден';

  @override
  String get shareCopied => 'Ссылка скопирована';

  @override
  String get languageUz => 'Oʻzbek';

  @override
  String get languageRu => 'Русский';

  @override
  String get languageEn => 'English';

  @override
  String get languageZh => '中文';

  @override
  String get actionSave => 'Сохранить';

  @override
  String get actionCancel => 'Отмена';

  @override
  String get actionEdit => 'Изменить';

  @override
  String get actionDelete => 'Удалить';

  @override
  String get actionView => 'Просмотр';

  @override
  String get actionUnblock => 'Разблокировать';

  @override
  String get actionSubmit => 'Отправить';

  @override
  String get kelishuvTitle => 'Сделка';

  @override
  String get kelishuvNotFound => 'Сделка не найдена';

  @override
  String get kelishuvMessages => 'Сообщения';

  @override
  String get kelishuvNoMessages => 'Сообщений пока нет';

  @override
  String get kelishuvOpeningOffer => 'Начальное предложение';

  @override
  String get kelishuvReject => 'Отклонить';

  @override
  String get kelishuvCancel => 'Отменить';

  @override
  String get kelishuvAccept => 'Принимаю';

  @override
  String get kelishuvComplete => 'Работа выполнена';

  @override
  String get kelishuvEditTerms => 'Изменить условия';

  @override
  String get kelishuvTermsChanged =>
      'Условия изменены — обе стороны должны подтвердить снова';

  @override
  String get kelishuvAwaitingComplete =>
      'Другая сторона подтвердила выполнение — подтвердите и вы';

  @override
  String get kelishuvPartyA => 'Сторона A';

  @override
  String get kelishuvPartyB => 'Сторона B';

  @override
  String get kelishuvCompleteA => 'A выполнил';

  @override
  String get kelishuvCompleteB => 'B выполнил';

  @override
  String get kelishuvDualAccepted => 'Обе стороны приняли';

  @override
  String get kelishuvCompleteTooEarly =>
      'Завершение можно отметить через 3 дня после начала работы';

  @override
  String kelishuvCompleteDaysLeft(int days) {
    return 'До возможности завершения: $days дн.';
  }

  @override
  String get kelishuvMessageHint => 'Напишите сообщение…';

  @override
  String get kelishuvIncoming => 'Входящие';

  @override
  String get kelishuvIncomingSub => 'Запросы к вашим услугам';

  @override
  String get kelishuvRequests => 'Мои запросы';

  @override
  String get kelishuvRequestsSub => 'Сделки, которые вы начали';

  @override
  String get kelishuvArchive => 'Архив';

  @override
  String get kelishuvArchiveSub => 'Закрытые сделки';

  @override
  String get kelishuvNeedsResponse => 'Нужен ответ';

  @override
  String get kelishuvNeedsConfirm => 'Подтвердить';

  @override
  String get profileBlocked => 'Заблокированные';

  @override
  String get profileClientBook => 'Книга клиентов';

  @override
  String get profileClientBookSub => 'Локальный список клиентов';

  @override
  String get profileEarnings => 'Мой доход';

  @override
  String get profileEarningsSub => 'Заявленный доход';

  @override
  String get profileMargin => 'Маржа';

  @override
  String get profileMarginSub => 'Себестоимость и прибыль';

  @override
  String get profilePaymentReceipt => 'Квитанция об оплате';

  @override
  String get profilePaymentReceiptSub => 'PDF-квитанции для ваших услуг';

  @override
  String get receiptTitle => 'Квитанции';

  @override
  String get receiptNew => 'Новая квитанция';

  @override
  String get receiptEmptyTitle => 'Квитанций пока нет';

  @override
  String get receiptEmptySubtitle =>
      'Создайте квитанцию для клиента и отправьте PDF.';

  @override
  String get receiptDocumentTitle => 'КВИТАНЦИЯ ОБ ОПЛАТЕ';

  @override
  String get receiptNumber => '№';

  @override
  String get receiptDate => 'Дата';

  @override
  String get receiptSeller => 'От';

  @override
  String get receiptBuyer => 'Кому';

  @override
  String get receiptBuyerName => 'Имя клиента';

  @override
  String get receiptBuyerPhone => 'Телефон клиента';

  @override
  String get receiptPickClient => 'Выбрать из книги клиентов';

  @override
  String get receiptXizmat => 'Услуга';

  @override
  String get receiptLines => 'Позиции';

  @override
  String get receiptLineTitle => 'Описание';

  @override
  String get receiptQuantity => 'Кол-во';

  @override
  String get receiptUnitPrice => 'Цена';

  @override
  String get receiptLineTotal => 'Сумма';

  @override
  String get receiptAddLine => 'Добавить';

  @override
  String get receiptDiscount => 'Скидка';

  @override
  String get receiptTaxEnable => 'Добавить налог';

  @override
  String get receiptTaxRate => 'Ставка (%)';

  @override
  String get receiptTaxLabel => 'Название налога';

  @override
  String get receiptTaxDisclaimer =>
      'Ставку выбираете вы. YordamBor не даёт налоговых консультаций.';

  @override
  String get receiptSubtotal => 'Подытог';

  @override
  String get receiptTotal => 'Итого';

  @override
  String get receiptNote => 'Примечание';

  @override
  String get receiptDueDate => 'Срок оплаты';

  @override
  String get receiptCurrency => 'Валюта';

  @override
  String get receiptCurrencyUzs => 'UZS';

  @override
  String get receiptCurrencyUsd => 'USD';

  @override
  String get receiptSharePdf => 'Поделиться PDF';

  @override
  String get receiptPreview => 'Просмотр PDF';

  @override
  String get receiptSaved => 'Квитанция сохранена';

  @override
  String get receiptValidationBuyer => 'Введите имя клиента';

  @override
  String get receiptValidationXizmat => 'Выберите услугу';

  @override
  String get receiptValidationLines => 'Добавьте хотя бы одну позицию с ценой';

  @override
  String get receiptFooterBranding => 'Создано в YordamBor';

  @override
  String get receiptDeleteConfirm => 'Удалить эту квитанцию?';

  @override
  String get receiptTaxPresetCustom => 'Другая';

  @override
  String get marginTitle => 'Маржа';

  @override
  String get marginUnitsTitle => 'Справочник единиц';

  @override
  String get marginUnitsSubtitle =>
      'Повторяемые единицы с ценой для быстрого расчёта';

  @override
  String get marginOpenUnits => 'Справочник единиц';

  @override
  String get marginAddUnit => 'Добавить единицу';

  @override
  String get marginEditUnit => 'Изменить единицу';

  @override
  String get marginUnitName => 'Название единицы';

  @override
  String get marginUnitCost => 'Стоимость за единицу (UZS)';

  @override
  String get marginUnitBasis => 'База стоимости (необязательно)';

  @override
  String get marginUnitBasisHint => 'напр. за час, за кг, за шт';

  @override
  String get marginUnitsEmptyTitle => 'Единиц пока нет';

  @override
  String get marginUnitsEmptySub =>
      'Сохраните часто используемые единицы — труд, материалы, упаковку.';

  @override
  String get marginAddProduct => 'Добавить продукт';

  @override
  String get marginEditProduct => 'Изменить продукт';

  @override
  String get marginProductName => 'Название продукта';

  @override
  String get marginSalePrice => 'Цена продажи (UZS)';

  @override
  String get marginCostTotal => 'Общая себестоимость';

  @override
  String get marginProfit => 'Прибыль';

  @override
  String get marginMarginPercent => 'Маржа';

  @override
  String get marginCostBreakdown => 'Структура затрат';

  @override
  String get marginAddLine => 'Добавить строку';

  @override
  String get marginEditLine => 'Изменить строку';

  @override
  String get marginLineName => 'Единица / позиция';

  @override
  String get marginLineQuantity => 'Количество';

  @override
  String get marginLineUnitCost => 'Стоимость за единицу (UZS)';

  @override
  String get marginLineQuantityLabel => 'Подпись количества (необяз.)';

  @override
  String get marginLineQuantityLabelHint => 'напр. ч, кг, шт';

  @override
  String get marginSelectUnit => 'Из справочника';

  @override
  String get marginCustomLine => 'Своя строка';

  @override
  String get marginProductsEmptyTitle => 'Продуктов пока нет';

  @override
  String get marginProductsEmptySub =>
      'Добавьте продукт или услугу, чтобы видеть себестоимость и прибыль.';

  @override
  String get marginNameRequired => 'Введите название';

  @override
  String get marginPriceRequired => 'Введите цену продажи';

  @override
  String get marginCostRequired => 'Введите стоимость';

  @override
  String get marginQuantityRequired => 'Введите количество';

  @override
  String get marginAvgMargin => 'Средняя маржа';

  @override
  String get marginPerProduct => 'на продукт';

  @override
  String get marginDeleteProduct => 'Удалить продукт';

  @override
  String get marginDeleteUnit => 'Удалить единицу';

  @override
  String get profileMyXizmatlar => 'Мои услуги';

  @override
  String get profileSetAvailability => 'Указать доступность';

  @override
  String get profileSectionLoadFailed =>
      'Не удалось загрузить. Проверьте интернет.';

  @override
  String get actionRetry => 'Повторить';

  @override
  String get clientBookTitle => 'Книга клиентов';

  @override
  String get clientBookList => 'Список';

  @override
  String get clientBookCalendar => 'Календарь';

  @override
  String get clientBookOpenDeal => 'Открыть сделку';

  @override
  String get clientBookEditClient => 'Изменить клиента';

  @override
  String get clientBookAdd => 'Добавить клиента';

  @override
  String get clientBookBookClient => 'Записать клиента';

  @override
  String get clientBookEditBooking => 'Изменить запись';

  @override
  String get clientBookNameRequired => 'Введите имя клиента';

  @override
  String get clientBookDateRequired => 'Выберите дату записи';

  @override
  String get clientBookNoteLabel => 'Заметка';

  @override
  String get clientBookEmptyTitle => 'Книга клиентов пуста';

  @override
  String get clientBookEmptySub =>
      'Записывайте клиентов в календаре или они добавятся при начале сделки';

  @override
  String get clientBookDateLabel => 'Дата записи';

  @override
  String get clientBookBookDay => 'Записать на этот день';

  @override
  String get clientBookCalendarHint =>
      'Нажмите на день, чтобы записать клиента';

  @override
  String get clientBookMarkComplete => 'Услуга оказана';

  @override
  String get clientBookMarkCancelled => 'Отменить запись';

  @override
  String get clientBookMarkPending => 'Вернуть в ожидание';

  @override
  String get clientBookCompleteAmount => 'Доход от клиента (UZS)';

  @override
  String get clientBookDeliveryCompleted => 'Оказано';

  @override
  String get clientBookDeliveryPending => 'Ожидается';

  @override
  String get clientBookDeliveryCancelled => 'Отменено';

  @override
  String get clientBookNewClientOption => 'Новый клиент';

  @override
  String get clientBookSelectClient => 'Клиент';

  @override
  String get clientBookServiceLabel => 'Услуга (необязательно)';

  @override
  String clientBookBookingCount(int count) {
    return '$count записей';
  }

  @override
  String get appointmentStatusUpcoming => 'Предстоящая';

  @override
  String get appointmentStatusCancelled => 'Отменена';

  @override
  String get appointmentStatusPostponed => 'Перенесена';

  @override
  String get appointmentStatusIncomplete => 'Не состоялась';

  @override
  String get appointmentStatusCompleted => 'Завершена';

  @override
  String get kelishuvAppointmentRequiredTitle => 'Укажите дату записи';

  @override
  String get kelishuvAppointmentRequiredBody =>
      'Обе стороны одобрили сделку. Выберите дату и время услуги.';

  @override
  String get remindersSettingsFollowUpLabel =>
      'Проверка после записи (часы после)';

  @override
  String get remindersFollowUpPrompt => 'Услуга была оказана?';

  @override
  String get clientBookAppointmentHistory => 'История записей';

  @override
  String get clientBookAppointmentNotesLabel => 'Заметки о записи';

  @override
  String get clientBookPhotosLabel => 'Фото';

  @override
  String get clientBookPhotosEmpty => 'Фото пока нет';

  @override
  String get clientBookAddPhoto => 'Добавить фото';

  @override
  String clientBookClientStats(int completed, int cancelled, int upcoming) {
    return '$completed завершено · $cancelled отменено · $upcoming предстоящих';
  }

  @override
  String get remindersUpdateStatus => 'Изменить статус';

  @override
  String get remindersSettingsTitle => 'Настройки напоминаний';

  @override
  String get remindersSettingsAlertsLabel => 'Время оповещений (минут до)';

  @override
  String get remindersSettingsAtTime => 'Вовремя';

  @override
  String get earningsTitle => 'Мой доход';

  @override
  String get earningsTotal => 'Итого (заявлено)';

  @override
  String get earningsEdit => 'Изменить доход';

  @override
  String get earningsAdd => 'Добавить доход';

  @override
  String get earningsAmountLabel => 'Сумма (UZS)';

  @override
  String get earningsNoteLabel => 'Примечание';

  @override
  String get earningsAmountRequired => 'Введите сумму';

  @override
  String get earningsEmptyTitle => 'Нет записей о доходе';

  @override
  String get earningsEmptySub => 'Добавляется автоматически для сделок с ценой';

  @override
  String get earningsDisclaimer =>
      'Только для личного учёта. Не для налогов или официальной отчётности.';

  @override
  String get notificationsEmptySub => 'Обновления сделок появятся здесь';

  @override
  String get notificationKelishuvAccept => 'Сделка принята';

  @override
  String get notificationKelishuvMessage => 'Новое сообщение';

  @override
  String get notificationKelishuvComplete => 'Работа завершена';

  @override
  String get notificationSubsectorNewService =>
      'Новая услуга в вашей подкатегории';

  @override
  String get notificationSubsectorDiscount => 'Снижение цены в подкатегории';

  @override
  String get notificationSubsectorHelpPost => 'Нужна помощь в подкатегории';

  @override
  String get notificationAlertsTitle => 'Оповещения по подкатегориям';

  @override
  String get notificationAlertsSubtitle =>
      'Уведомления о новых услугах, скидках и запросах помощи.';

  @override
  String get notificationAlertsAdd => 'Добавить оповещение';

  @override
  String get notificationAlertsEmpty => 'Оповещений по подкатегориям пока нет';

  @override
  String get notificationAlertNewService => 'Новые услуги';

  @override
  String get notificationAlertDiscount => 'Снижение цен';

  @override
  String get notificationAlertHelpPost => 'Запросы «Нужна помощь»';

  @override
  String get notificationAlertSeekerHint => 'Если вы ищете услугу';

  @override
  String get notificationAlertProviderHint =>
      'Если вы можете помочь как исполнитель';

  @override
  String get notificationAlertsSaved => 'Оповещение сохранено';

  @override
  String get notificationAlertsRemoved => 'Оповещение удалено';

  @override
  String get notificationGeneric => 'Уведомление';

  @override
  String notificationTimeMinutes(int count) {
    return '$count мин';
  }

  @override
  String notificationTimeHours(int count) {
    return '$count ч';
  }

  @override
  String notificationTimeDate(int day, int month) {
    return '$day.$month';
  }

  @override
  String get reviewsTitle => 'Отзывы';

  @override
  String get reviewProviderReplyLabel => 'Ответ исполнителя';

  @override
  String get reviewsEmpty => 'Отзывов пока нет';

  @override
  String get reviewsRate => 'Оценить';

  @override
  String xizmatCompletedCount(int count) {
    return '$count выполнено';
  }

  @override
  String get demoKelishuvBlocked => 'Нельзя создать сделку в демо-режиме';

  @override
  String get demoKelishuvSimulatedNote =>
      'Демо-сделка не сохраняется на сервере. Демо-исполнитель отображается как получивший предложение.';

  @override
  String get genericUser => 'Пользователь';

  @override
  String get actionPick => 'Выбрать';

  @override
  String get xizmatStepIdentity => '1/3 — Кто вы?';

  @override
  String get xizmatStepPortfolio => '2/3 — Портфолио';

  @override
  String get xizmatProviderIndividual => 'Специалист';

  @override
  String get xizmatProviderInstitution => 'Организация';

  @override
  String get xizmatNameLabel => 'Название услуги';

  @override
  String get xizmatDescriptionLabel => 'Краткое описание';

  @override
  String get xizmatDescriptionFull => 'Описание';

  @override
  String get xizmatServiceCityLabel => 'Город обслуживания';

  @override
  String get xizmatServiceCityHint => 'Выберите город обслуживания';

  @override
  String get xizmatContinue => 'Продолжить';

  @override
  String get xizmatPortfolioHint => 'Минимум 1 фото. Первое фото — обложка.';

  @override
  String get xizmatHeroLabel => 'Обложка';

  @override
  String get xizmatUploading => 'Загрузка…';

  @override
  String get xizmatReady => 'Готово';

  @override
  String get xizmatBack => 'Назад';

  @override
  String get xizmatSuccessTitle => 'Ваша услуга готова!';

  @override
  String get xizmatSuccessBody =>
      'Портфолио загружено. Клиенты могут найти вас в Discover.';

  @override
  String get xizmatEditTitle => 'Редактировать услугу';

  @override
  String get cannotRequestOwnXizmat => 'Нельзя отправить запрос на свою услугу';

  @override
  String get xizmatNotFound => 'Услуга не найдена';

  @override
  String get xizmatNoPermission => 'Нет доступа';

  @override
  String get xizmatBasicInfo => 'Основная информация';

  @override
  String get xizmatPortfolio => 'Портфолио';

  @override
  String get xizmatPortfolioEmpty =>
      'Портфолио пусто. Нужно хотя бы одно фото.';

  @override
  String get xizmatAddPhoto => 'Добавить фото';

  @override
  String get xizmatSetHero => 'Сделать обложкой';

  @override
  String get xizmatAnalytics => 'Аналитика';

  @override
  String get xizmatReviewReplies => 'Ответы на отзывы';

  @override
  String get xizmatSaved => 'Сохранено';

  @override
  String get xizmatReplySaved => 'Ответ сохранён';

  @override
  String get xizmatPickCategoryError => 'Выберите сферу и подсферу';

  @override
  String get yordamKerakPostTitle => 'Нужна помощь';

  @override
  String get yordamKerakTitleLabel => 'Заголовок';

  @override
  String get yordamKerakTitleHint => 'Например: Нужен сантехник';

  @override
  String get yordamKerakMessageLabel => 'Описание проекта';

  @override
  String get yordamKerakMessageHint => 'Что нужно сделать, где и когда?';

  @override
  String get yordamKerakBudgetLabel => 'Бюджет (необязательно, UZS)';

  @override
  String get yordamKerakDateLabel => 'Желаемая дата (необязательно)';

  @override
  String get yordamKerakDurationLabel => 'Длительность (минуты, необязательно)';

  @override
  String get yordamKerakPublish => 'Опубликовать';

  @override
  String get yordamKerakTitleTooShort => 'Заголовок — минимум 3 символа';

  @override
  String get yordamKerakMessageTooShort => 'Описание — минимум 10 символов';

  @override
  String get yordamKerakCategoryRequired => 'Выберите сферу';

  @override
  String get yordamKerakSubcategoryRequired => 'Выберите подсферу';

  @override
  String get userProfileTitle => 'Профиль';

  @override
  String get userProfileNotFound => 'Профиль не найден';

  @override
  String get userProfileServices => 'Услуги';

  @override
  String get userProfileServicesEmpty => 'Услуг пока нет';

  @override
  String get userProfileRequests => 'Нужна помощь';

  @override
  String get userProfileRequestsEmpty => 'Нет открытых объявлений';

  @override
  String get userProfileAvailable => 'Доступно';

  @override
  String get userProfileBusy => 'Недоступно';

  @override
  String get userProfilePartiallyBusy => 'Частично недоступно';

  @override
  String get userProfileCall => 'Позвонить';

  @override
  String get userProfilePhoneHidden => 'Номер скрыт';

  @override
  String get userProfileViewProfile => 'Открыть профиль';

  @override
  String get xizmatProviderSection => 'Исполнитель';

  @override
  String get profileViewPublic => 'Мой публичный профиль';

  @override
  String get profileCertificatesTitle => 'Сертификаты и квалификации';

  @override
  String get profileCertificatesSubtitle =>
      'Загрузите документы о квалификации для клиентов';

  @override
  String get profileCertificatesDisclaimer =>
      'YordamBor не проверяет загруженные документы. Клиенты должны проверять их самостоятельно.';

  @override
  String get profileCertificatesAdd => 'Добавить сертификат';

  @override
  String get profileCertificatesTitleLabel => 'Название';

  @override
  String get profileCertificatesTitleHint =>
      'Например: Сертификат курса сантехника';

  @override
  String get profileCertificatesIssuerLabel => 'Кем выдан (необязательно)';

  @override
  String get profileCertificatesIssuerHint =>
      'Например: Название учебного центра';

  @override
  String get profileCertificatesEmpty => 'Сертификаты ещё не загружены';

  @override
  String get profileCertificatesMaxReached => 'Максимум 8 сертификатов';

  @override
  String get profileCertificatesAdded => 'Сертификат добавлен';

  @override
  String get profileCertificatesRemoved => 'Сертификат удалён';

  @override
  String get profileCertificatesRemoveTitle => 'Удалить сертификат?';

  @override
  String get xizmatOtherServices => 'Другие услуги';

  @override
  String get xizmatViewAllServices => 'Все услуги';

  @override
  String get xizmatStatusAvailable => 'Доступно';

  @override
  String get xizmatStatusBusy => 'Недоступно';

  @override
  String get safetyTitle => 'Безопасность';

  @override
  String get safetyBlock => 'Заблокировать';

  @override
  String safetyBlockConfirmMessage(String name) {
    return 'Заблокировать $name? Их контент будет скрыт.';
  }

  @override
  String get safetyBlockDone => 'Пользователь заблокирован';

  @override
  String get safetyHideUser => 'Скрыть пользователя';

  @override
  String get safetyReportReason => 'Причина жалобы (необязательно)';

  @override
  String get safetyReportHint => 'Что произошло?';

  @override
  String get safetyReportSubmit => 'Отправить жалобу';

  @override
  String get safetyReportDone => 'Жалоба отправлена. Спасибо.';

  @override
  String get reviewLater => 'Позже';

  @override
  String get blockedUnblocked => 'Разблокирован';

  @override
  String kelishuvMoreCount(int count) {
    return 'Ещё $count';
  }

  @override
  String get demoPostPickReal => 'Демо-объявление — выберите настоящее';

  @override
  String get createXizmatFirst => 'Сначала создайте профиль услуги';

  @override
  String get pickXizmat => 'Выберите услугу';

  @override
  String get categoryPickTitle => 'Выберите сферу';

  @override
  String get categoryAll => 'Все сферы';

  @override
  String get subcategoryAll => 'Все подсферы';

  @override
  String get analyticsViews => 'Просмотры';

  @override
  String get analyticsFavorites => 'В избранном';

  @override
  String get analyticsActiveDeals => 'Активные сделки';

  @override
  String get analyticsCompletedDeals => 'Выполнено';

  @override
  String analyticsConversion(String rate) {
    return 'Конверсия: $rate%';
  }

  @override
  String get kelishuvArchiveEmptyTitle => 'Архив пуст';

  @override
  String get kelishuvArchiveEmptySub =>
      'Завершённые или отменённые сделки появятся здесь';

  @override
  String get kelishuvStatusNegotiating => 'Переговоры';

  @override
  String get kelishuvStatusInProgress => 'В работе';

  @override
  String get kelishuvStatusCompleted => 'Выполнено';

  @override
  String get kelishuvStatusCancelled => 'Отменено';

  @override
  String get kelishuvStatusRejected => 'Отклонено';

  @override
  String get kelishuvStatusArchived => 'Архив';

  @override
  String get busySlotTitle => 'Занятое время';

  @override
  String busySlotMessage(String names) {
    return 'На эту дату уже есть встреча: $names. Продолжить?';
  }

  @override
  String taklifFlowTitleYordamBor(String name) {
    return 'Есть помощь — $name';
  }

  @override
  String taklifFlowTitleYordamKerak(String name) {
    return 'Нужна помощь — $name';
  }

  @override
  String get taklifTitle => 'Отправить предложение';

  @override
  String get repeatBook => 'Забронировать снова';

  @override
  String get repeatBookTitle => 'Забронировать снова';

  @override
  String get taklifSubtitle =>
      'Отправьте сообщение и цену в начале. Работа начнётся после принятия обеими сторонами.';

  @override
  String get taklifMessageLabel => 'Сообщение';

  @override
  String get taklifMessageHint => 'Чем можете помочь?';

  @override
  String get taklifPriceLabel => 'Цена (необязательно, UZS)';

  @override
  String get taklifDateLabel => 'Выберите дату (необязательно)';

  @override
  String get taklifDurationLabel => 'Длительность (минуты, необязательно)';

  @override
  String get taklifSubmit => 'Отправить предложение';

  @override
  String get reviewCommentLabel => 'Комментарий (необязательно)';

  @override
  String get reviewCommentHint => 'Как прошло?';

  @override
  String get xizmatReplyLabel => 'Ваш ответ';

  @override
  String get xizmatReplyHint => 'Ответ клиенту';

  @override
  String get xizmatClientLabel => 'Клиент';

  @override
  String get kelishuvTermsDateLabel => 'Выберите дату';

  @override
  String get kelishuvTermsMessageLabel => 'Сообщение';

  @override
  String get kelishuvTermsPriceLabel => 'Цена (UZS)';

  @override
  String kelishuvDetailPost(String title) {
    return 'Объявление: $title';
  }

  @override
  String kelishuvDetailPrice(String amount, String currency) {
    return 'Цена: $amount $currency';
  }

  @override
  String kelishuvDetailTime(String slot) {
    return 'Время: $slot';
  }

  @override
  String kelishuvSlotDateDuration(String date, int minutes) {
    return '$date · $minutes мин';
  }

  @override
  String get xizmatPricingSectionTitle => 'Цена';

  @override
  String get xizmatPricingSectionSubtitle =>
      'Когда цена видна, клиенты пишут быстрее.';

  @override
  String get xizmatPricingNegotiable => 'Договорная';

  @override
  String get xizmatPricingFixed => 'Фиксированная';

  @override
  String get xizmatPricingHourly => 'Почасовая';

  @override
  String get xizmatPricingFixedRateLabel => 'Цена (UZS)';

  @override
  String get xizmatPricingHourlyRateLabel => 'Ставка в час (UZS)';

  @override
  String get xizmatPricingRateHint => 'Например: 150000';

  @override
  String get xizmatPricingMinDurationLabel =>
      'Мин. длительность (минуты, необязательно)';

  @override
  String get xizmatPricingMinDurationHint => 'Например: 120';

  @override
  String get xizmatPricingRequiredError => 'Укажите сумму';

  @override
  String get xizmatPriceNegotiable => 'Цена по договорённости';

  @override
  String xizmatPricePerHour(String amount) {
    return '$amount/час';
  }

  @override
  String get xizmatAvailabilitySectionTitle => 'Доступность';

  @override
  String get xizmatAvailabilitySectionSubtitle =>
      'Необязательно — клиенты увидят, свободны ли вы. Книга клиентов это не меняет.';

  @override
  String get xizmatAvailabilityShowLabel => 'Показывать доступность';

  @override
  String get xizmatAvailabilityShowSubtitle =>
      'Если выключено, значок не отображается';

  @override
  String get xizmatAvailabilityAvailableNow => 'Сейчас доступно';

  @override
  String get xizmatAvailabilityBusy => 'Недоступно';

  @override
  String get xizmatAvailabilityCallMe => 'По записи';

  @override
  String get xizmatAvailabilityFromLabel => 'С (необязательно)';

  @override
  String get xizmatAvailabilityUntilLabel => 'До (необязательно)';

  @override
  String xizmatAvailabilityUntilSuffix(String time) {
    return ' · до $time';
  }

  @override
  String xizmatAvailabilityFromSuffix(String time) {
    return ' · с $time';
  }

  @override
  String xizmatAvailabilityRangeSuffix(String from, String until) {
    return ' · $from–$until';
  }

  @override
  String get xizmatAvailabilityModeRequiredError => 'Выберите тип доступности';

  @override
  String get xizmatAvailabilityWindowInvalidError =>
      'Время окончания должно быть позже начала';

  @override
  String get xizmatPromiseSectionTitle => 'Ваше обещание';

  @override
  String get xizmatPromiseSectionSubtitle =>
      'Расскажите клиентам, что вы гарантируете. Это ваш девиз — не гарантия YordamBor.';

  @override
  String get xizmatPromiseShowLabel => 'Показывать обещание';

  @override
  String get xizmatPromiseShowSubtitle => 'Отображается в объявлении';

  @override
  String get xizmatPromisePresetsLabel =>
      'Быстрые шаблоны (можно редактировать)';

  @override
  String get xizmatPromiseFieldLabel => 'Ваше обещание';

  @override
  String get xizmatPromiseFieldHint =>
      'Напишите своё или отредактируйте шаблон';

  @override
  String get xizmatPromisePreset1 => 'Если не довольны — переделаю работу';

  @override
  String get xizmatPromisePreset2 =>
      'Гарантия качества — при проблеме верну деньги';

  @override
  String get xizmatPromisePreset3 => 'Вовремя и по согласованной цене';

  @override
  String get xizmatPromiseDisclaimer =>
      'YordamBor не предоставляет гарантий. Это заявление исполнителя.';

  @override
  String get xizmatPromiseRequiredError => 'Введите обещание или отключите';

  @override
  String get xizmatPromiseTooLongError => 'Слишком длинное обещание';

  @override
  String get settingsHelp => 'Помощь и поддержка';

  @override
  String get supportReportTitle => 'Сообщить о проблеме';

  @override
  String get supportReportSubtitle => 'Ошибка, аккаунт или оплата';

  @override
  String get supportCategoryLabelField => 'Категория';

  @override
  String get supportCategoryBug => 'Ошибка';

  @override
  String get supportCategoryAccount => 'Аккаунт';

  @override
  String get supportCategoryPayment => 'Проблема с оплатой';

  @override
  String get supportCategoryOther => 'Другое';

  @override
  String get supportDescriptionLabel => 'Описание';

  @override
  String get supportDescriptionHint => 'Опишите проблему…';

  @override
  String get supportSubmit => 'Отправить';

  @override
  String get supportSubmitted => 'Спасибо — мы получили ваше сообщение';

  @override
  String get supportLoginRequired => 'Войдите, чтобы отправить сообщение';

  @override
  String get supportContactHint => 'Поддержка: eeshbaev@outlook.com';

  @override
  String get supportMailtoFailed => 'Не удалось открыть почту';

  @override
  String get feedbackTitle => 'Обратная связь';

  @override
  String get feedbackSubtitle => 'Помогите улучшить YordamBor';

  @override
  String get feedbackMessageLabel => 'Ваш отзыв';

  @override
  String get feedbackMessageHint => 'Что можно улучшить?';

  @override
  String get feedbackSubmit => 'Отправить';

  @override
  String get feedbackThanks => 'Спасибо за отзыв';

  @override
  String get feedbackOpenFromSheet =>
      'Используйте раздел Помощь для обратной связи.';

  @override
  String get appReviewTitle => 'Нравится YordamBor?';

  @override
  String get appReviewSubtitle =>
      'Ваша оценка помогает другим найти надёжных исполнителей.';

  @override
  String get appReviewYes => 'Да, нравится';

  @override
  String get appReviewNo => 'Не очень';

  @override
  String get appReviewLater => 'Не сейчас';

  @override
  String get providerProgressTitle => 'Ваш прогресс';

  @override
  String get providerProgressSubtitle => 'Стройте репутацию шаг за шагом';

  @override
  String get providerTierNew => 'Новый';

  @override
  String get providerTierActive => 'Активный';

  @override
  String get providerTierTrusted => 'Надёжный';

  @override
  String get providerTierTop => 'Топ исполнитель';

  @override
  String providerJobsRating(int jobs, String rating) {
    return '$jobs заказов · $rating★';
  }

  @override
  String providerNextMilestone(int count, String tier) {
    return 'Ещё $count → $tier';
  }

  @override
  String get providerTipsTitle => 'Следующие шаги';

  @override
  String get progressTipAddCertificate => 'Добавьте сертификат';

  @override
  String get progressTipSetAvailability => 'Укажите доступность';

  @override
  String get progressTipReplyReviews => 'Отвечайте на отзывы';

  @override
  String get progressTipAddPortfolio => 'Добавьте фото портфолио';

  @override
  String get progressTipSetPricing =>
      'Укажите фиксированную или почасовую цену';

  @override
  String get progressTipRepeatClients =>
      'Просите довольных клиентов заказать снова';

  @override
  String get achievementsTitle => 'Достижения';

  @override
  String get achievementsEmptySub =>
      'Пока нет достижений. Выполняйте заказы и развивайте профиль.';

  @override
  String get achievementFirstXizmat => 'Первый сервис';

  @override
  String get achievementFirstDeal => 'Первый заказ';

  @override
  String get achievementJobs5 => '5 заказов';

  @override
  String get achievementJobs10 => '10 заказов';

  @override
  String get achievementJobs25 => '25 заказов';

  @override
  String get achievementFirstFiveStar => 'Первые 5★';

  @override
  String get achievementCertificate => 'Сертификат загружен';

  @override
  String get achievementRepeatClient => 'Постоянный клиент';

  @override
  String get achievementBodyFirstXizmat =>
      'Вы создали первый сервис на YordamBor.';

  @override
  String get achievementBodyFirstDeal => 'Первый заказ выполнен!';

  @override
  String get achievementBodyJobs5 => 'Пять заказов — клиенты замечают вас.';

  @override
  String get achievementBodyJobs10 => 'Десять заказов — репутация растёт.';

  @override
  String get achievementBodyJobs25 => 'Двадцать пять заказов — уровень топ.';

  @override
  String get achievementBodyFirstFiveStar => 'Клиент поставил 5 звёзд!';

  @override
  String get achievementBodyCertificate => 'Документы видны в профиле.';

  @override
  String get achievementBodyRepeatClient => 'Клиент заказал у вас 3+ раз.';

  @override
  String get actionContinue => 'Продолжить';

  @override
  String get guidesTitle => 'Советы для бизнеса';

  @override
  String get guidesSubtitle => 'Развивайте сервис шаг за шагом';

  @override
  String get guideXizmatConvertsTitle => 'Объявление, которое продаёт';

  @override
  String get guidePricingTitle => 'Цены: фикс или почасовая';

  @override
  String get guideRepeatClientsTitle => 'Повторные заказы';

  @override
  String get guideCertificatesTitle => 'Сертификаты и доверие';

  @override
  String get guideReviewRepliesTitle => 'Ответы на отзывы';

  @override
  String get guideXizmatConvertsBody =>
      'Чёткий заголовок, реальные фото, подкатегория, цена или договорная, доступность.';

  @override
  String get guidePricingBody =>
      'Фикс для предсказуемых работ. Почасовая для уборки и репетиторства.';

  @override
  String get guideRepeatClientsBody =>
      'Качественная работа и кнопка «Забронировать снова» после сделки.';

  @override
  String get guideCertificatesBody =>
      'Загрузите документы. YordamBor их не проверяет.';

  @override
  String get guideReviewRepliesBody => 'Отвечайте вежливо на все отзывы.';

  @override
  String get safetyPaymentsBanner =>
      'Платите только по договорённости. YordamBor не принимает деньги и не отвечает за внешние платежи.';

  @override
  String get settingsSafety => 'Безопасность и оплата';

  @override
  String get legalSafetyTitle => 'Безопасность и оплата';

  @override
  String get legalSafetyBody =>
      'YordamBor соединяет клиентов и исполнителей. Не оказывает услуги и не хранит деньги.\n\nОплата\n\nОплата напрямую между сторонами. Не переводите полную сумму незнакомцам. YordamBor не отвечает за мошенничество.\n\nВаша ответственность\n\nПроверяйте отзывы и документы сами.\n\nЖалобы\n\nНа злоупотребления — через приложение. На ошибки — Помощь.';

  @override
  String get greetingMorning => 'Доброе утро';

  @override
  String get greetingAfternoon => 'Добрый день';

  @override
  String get greetingEvening => 'Добрый вечер';

  @override
  String get greetingNight => 'Доброй ночи';

  @override
  String get greetingWelcomeBack => 'С возвращением';

  @override
  String get greetingWelcomeNew => 'Добро пожаловать';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String homeFactAwaitingReply(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сделки ждут вашего ответа',
      many: '$count сделок ждут вашего ответа',
      few: '$count сделки ждут вашего ответа',
      one: '$count сделка ждёт вашего ответа',
    );
    return '$_temp0';
  }

  @override
  String homeFactInProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сделки в работе',
      many: '$count сделок в работе',
      few: '$count сделки в работе',
      one: '$count сделка в работе',
    );
    return '$_temp0';
  }

  @override
  String get homeFactNewMember =>
      'Для начала попросите помощи или предложите услугу';

  @override
  String get continueYourTurn => 'Ваша очередь';

  @override
  String get continueReplyToDeal => 'Проверьте условия и ответьте';

  @override
  String get continueInProgress => 'В работе';

  @override
  String get continueMarkDone => 'Подтвердите, когда работа выполнена';

  @override
  String get continueDraftTitle => 'Незавершённый запрос';

  @override
  String get continueDraftUntitled => 'Запрос без названия';

  @override
  String get continueDraftHint => 'Продолжите с того же места';

  @override
  String get draftDelete => 'Удалить черновик';

  @override
  String get draftDeleted => 'Черновик удалён';

  @override
  String get draftRestored => 'Черновик восстановлен';

  @override
  String get draftStartOver => 'Начать заново';

  @override
  String get actionUndo => 'Отменить';

  @override
  String get quickAskHelp => 'Попросить помощи';

  @override
  String get quickOfferService => 'Предложить услугу';

  @override
  String get feedEndTitle => 'Вы всё посмотрели';

  @override
  String get feedEndAskPrompt => 'Не нашли подходящего мастера?';

  @override
  String get feedEndJobsHint => 'Новые запросы появляются здесь первыми';

  @override
  String get whatsNewTitle => 'Что нового';

  @override
  String get whatsNewLookTitle => 'Обновлённый, чистый вид';

  @override
  String get whatsNewLookBody =>
      'Новые шрифты, цвета и значки — читать стало легче.';

  @override
  String get whatsNewNextStepTitle => 'Следующий шаг — на главной';

  @override
  String get whatsNewNextStepBody =>
      'Сделки, которые ждут вас, и незавершённые запросы теперь сверху.';

  @override
  String get whatsNewDraftsTitle => 'Черновики сохраняются сами';

  @override
  String get whatsNewDraftsBody =>
      'Закройте запрос на полпути — продолжите позже.';

  @override
  String get whatsNewDone => 'Понятно';

  @override
  String get xizmatCardNew => 'Новый';

  @override
  String get favoriteAdd => 'В избранное';

  @override
  String get favoriteRemove => 'Убрать из избранного';

  @override
  String statJobsDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'выполненной работы',
      many: 'выполненных работ',
      few: 'выполненные работы',
      one: 'выполненная работа',
    );
    return '$_temp0';
  }

  @override
  String get statRating => 'рейтинг';

  @override
  String get dealBondYou => 'Вы';

  @override
  String get dealBondYourTurn => 'Ваша очередь: проверьте условия и примите';

  @override
  String dealBondWaiting(String name) {
    return 'Ждём ответа: $name';
  }

  @override
  String get dealBondAgreed => 'Договорились · работа идёт';

  @override
  String get dealBondDone => 'Работа выполнена · спасибо';

  @override
  String get dealBondClosed => 'Эта сделка закрыта';

  @override
  String get undoDeleted => 'Удалено';

  @override
  String get savedRemoved => 'Убрано из избранного';

  @override
  String get yordamKerakTitleRequired => 'Напишите короткий заголовок';

  @override
  String get yordamKerakMessageRequired => 'Опишите, что нужно сделать';

  @override
  String get stateErrorTitle => 'Не удалось загрузить';

  @override
  String get stateErrorBody => 'Проверьте соединение и попробуйте снова.';

  @override
  String get stateOfflineBanner =>
      'Нет интернета. Показаны сохранённые данные.';

  @override
  String get disabledHintServiceName => 'Введите название — минимум 2 буквы';

  @override
  String get disabledHintServiceCity => 'Выберите город, где вы работаете';

  @override
  String get disabledHintServicePhoto => 'Добавьте хотя бы одно фото';

  @override
  String get disabledHintPickSubcategory => 'Сначала выберите специализацию';

  @override
  String get disabledHintOneAlert => 'Включите хотя бы одно уведомление';

  @override
  String get milestoneOverline => 'Новое достижение';

  @override
  String get milestoneDismiss => 'Скрыть';

  @override
  String get notificationsTooltip => 'Уведомления';

  @override
  String a11yRating(String rating) {
    return 'рейтинг $rating';
  }

  @override
  String get a11yNewProvider => 'новый на YordamBor';

  @override
  String get filtersClear => 'Сбросить фильтры';

  @override
  String get actionClose => 'Закрыть';

  @override
  String get actionMore => 'Другие действия';

  @override
  String get actionSend => 'Отправить';

  @override
  String get actionPreviousMonth => 'Предыдущий месяц';

  @override
  String get actionNextMonth => 'Следующий месяц';

  @override
  String get a11yShowPassword => 'Показать пароль';

  @override
  String get a11yHidePassword => 'Скрыть пароль';

  @override
  String a11yStarRating(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count звезды',
      many: '$count звёзд',
      few: '$count звезды',
      one: '$count звезда',
    );
    return '$_temp0';
  }

  @override
  String get detailPaneEmptyTitle => 'Выберите карточку';

  @override
  String get detailPaneEmptyBody => 'Она откроется здесь, рядом со списком.';

  @override
  String get taklifAskHint => 'Какая помощь вам нужна?';

  @override
  String get taklifAskSubtitle =>
      'Опишите задачу и, если хотите, бюджет. Работа начнётся, когда вы оба согласитесь.';

  @override
  String get taklifAskSubmit => 'Отправить запрос';

  @override
  String dealOfferAutoCancel(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return 'Если ответа не будет, предложение отменится через $_temp0';
  }

  @override
  String dealOfferReplyWithin(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дней',
      one: '$days дня',
    );
    return 'Ответьте в течение $_temp0, иначе предложение отменится';
  }

  @override
  String get dealAcceptedRow => 'Приняли условия';

  @override
  String get dealCompletedRow => 'Подтвердили выполнение';

  @override
  String get dealWithdrawOffer => 'Отозвать предложение';

  @override
  String get dealWithdrawTitle => 'Отозвать предложение?';

  @override
  String get dealWithdrawBody =>
      'Сделка будет отменена. Позже можно отправить новое предложение.';

  @override
  String get dealChatOpensOnReply => 'Переписка откроется после ответа.';

  @override
  String get dealRejectTitle => 'Отклонить предложение?';

  @override
  String get dealRejectBody =>
      'Если хотите, напишите причину — она будет видна в сделке.';

  @override
  String get dealRejectCommentLabel => 'Комментарий (необязательно)';

  @override
  String get dealSendNewOffer => 'Отправить новое предложение';

  @override
  String get dealClosedNewOfferHint =>
      'Услуга всё ещё нужна? Отправьте новое предложение — обсуждение начнётся заново.';

  @override
  String get archiveTabNeeded => 'Нужна была помощь';

  @override
  String get archiveTabProvided => 'Оказана помощь';

  @override
  String get archiveNeededEmpty =>
      'Здесь появятся сделки, где вы просили о помощи.';

  @override
  String get archiveProvidedEmpty => 'Здесь появятся сделки, где помогали вы.';

  @override
  String achievementsProgress(int unlocked, int total) {
    return 'Открыто $unlocked из $total';
  }

  @override
  String get achievementsShow => 'Показать все';

  @override
  String get achievementsHide => 'Скрыть';

  @override
  String get yordamKerakCityRequired => 'Выберите город';

  @override
  String get taklifContactTitle => 'Ваши контакты';

  @override
  String get taklifContactNote =>
      'Другая сторона увидит их в сделке, чтобы связаться с вами.';

  @override
  String get taklifFirstNameLabel => 'Имя';

  @override
  String get taklifLastNameLabel => 'Фамилия';

  @override
  String get taklifFirstNameRequired => 'Введите имя';

  @override
  String get taklifPhoneRequired => 'Введите номер телефона';

  @override
  String get taklifMessageOptionalLabel => 'Сообщение (необязательно)';

  @override
  String get dealContactTitle => 'Контакты для связи';

  @override
  String get dealContactSent => 'Вы отправили свои контакты';

  @override
  String get dealsSectionTitle => 'Ваши сделки';

  @override
  String get dealStateYourTurn => 'В обсуждении · ваш ход';

  @override
  String get dealStateSent => 'Отправлено · ждём ответа';

  @override
  String get dealStateInProgress => 'Принято · в работе';

  @override
  String get dealStateAwaitingConfirm => 'Вы подтвердили · ждём другую сторону';

  @override
  String get actionAdd => 'Добавить';

  @override
  String get businessEarningsTitle => 'Доход в этом месяце';

  @override
  String get businessEarningsSee => 'Смотреть доход';

  @override
  String get businessStatWaitingLabel => 'ждут ответа';

  @override
  String get businessNextStepsTitle => 'Как получить больше клиентов';

  @override
  String businessNextStepsProgress(int done, int total) {
    return '$done из $total';
  }

  @override
  String get businessStepPhotos => 'Добавьте 3 или больше фото';

  @override
  String get businessStepPhotosWhy => 'Услуги с фото выбирают чаще';

  @override
  String get businessStepPrice => 'Укажите цену';

  @override
  String get businessStepPriceWhy =>
      'Понятная цена — меньше вопросов до сделки';

  @override
  String get businessStepAvailability => 'Покажите, когда вы свободны';

  @override
  String get businessStepAvailabilityWhy =>
      'Клиенты пишут тем, кто может прийти скоро';

  @override
  String get businessStepShare => 'Поделитесь ссылкой на услугу';

  @override
  String get businessStepShareWhy =>
      'Отправьте в Telegram — друзья порекомендуют вас';

  @override
  String get businessStartTitle => 'Превратите навыки в доход';

  @override
  String get businessStartStep1 => 'Опишите услугу и цену';

  @override
  String get businessStartStep2 => 'Добавьте фото и город';

  @override
  String get businessStartStep3 => 'Получайте заявки и договаривайтесь';

  @override
  String businessServicesCount(int count, int max) {
    return 'Мои услуги · $count из $max';
  }

  @override
  String xizmatLimitReached(int max) {
    return 'Можно до $max услуг. Измените или удалите одну, чтобы добавить новую.';
  }

  @override
  String get calendarStatusCaption => 'Ваш статус · его видят клиенты';

  @override
  String get calendarLegendNeedHelp => 'Мне помогают';

  @override
  String get calendarLegendGiveHelp => 'Я помогаю';

  @override
  String get calendarLegendPersonal => 'Личное';

  @override
  String get calendarHintMark =>
      'Нажмите на день и отметьте: свободен или занят. Если только часть дня — укажите часы; иначе это весь рабочий день.';

  @override
  String get calendarHintClient =>
      'Здесь напоминания о сделках: где помогают вам и где помогаете вы. Нажмите на день, чтобы увидеть детали.';

  @override
  String get calendarDayNotMarked => 'Не отмечен';

  @override
  String get calendarWholeWorkingDay => 'Весь рабочий день';

  @override
  String get calendarAddHours => 'Добавить время';

  @override
  String get calendarRemoveHours => 'Убрать это время';

  @override
  String get calendarHoursFrom => 'С';

  @override
  String get calendarHoursTo => 'До';

  @override
  String get calendarDayEvents => 'Напоминания на этот день';

  @override
  String get workingHoursTitle => 'Рабочие часы';

  @override
  String get workingHoursHint => 'Клиенты видят их в ваших услугах';

  @override
  String get workingHoursSheetHint =>
      'Ваш обычный рабочий день. По умолчанию 9:00–13:00 и 14:00–18:00.';

  @override
  String get workingHoursReset => 'Вернуть 9–13 и 14–18';

  @override
  String get workingHoursInvalid =>
      'Проверьте время: начало раньше конца, промежутки не пересекаются.';

  @override
  String get workingHoursSaved => 'Рабочие часы сохранены';

  @override
  String get xizmatOwnHoursTitle => 'Свои часы для этой услуги';

  @override
  String xizmatOwnHoursOff(String hours) {
    return 'Как в профиле: $hours';
  }

  @override
  String get xizmatHoursInCalendar => 'Рабочие часы меняются в календаре.';

  @override
  String get xizmatHoursOpenCalendar => 'Открыть календарь';

  @override
  String get xizmatScheduleTitle => 'Часы работы и занятость';

  @override
  String get xizmatScheduleNextDays => 'Ближайшие 2 недели';

  @override
  String get xizmatTodayFree => 'Сегодня свободен';

  @override
  String get xizmatTodayBusy => 'Сегодня занят';

  @override
  String xizmatTodayBusyAt(String hours) {
    return 'Сегодня занят: $hours';
  }

  @override
  String xizmatTodayFreeAt(String hours) {
    return 'Сегодня свободен: $hours';
  }

  @override
  String get calendarNoRemindersDay => 'На этот день напоминаний нет.';

  @override
  String get sampleTag => 'Пример';

  @override
  String get demoDealNote =>
      'Это пример: сделка не уходит настоящему человеку.';

  @override
  String get feedInviteProvidersTitle => 'Станьте одним из первых исполнителей';

  @override
  String get feedInviteProvidersBody =>
      'Добавьте свою услугу — клиенты увидят её первой.';

  @override
  String get feedInviteAskTitle => 'Попросите помощи первым';

  @override
  String get feedInviteAskBody =>
      'Опишите, что нужно, — исполнители увидят ваш запрос.';

  @override
  String get feedInviteProvidersAction => 'Добавить свою услугу';

  @override
  String get feedInviteAskAction => 'Описать, что нужно';

  @override
  String get sampleFindProvider => 'Найти исполнителя';

  @override
  String get sampleFindProviderHint =>
      'Это пример. Опишите задачу — её увидят настоящие исполнители.';

  @override
  String get sampleAlertNewServices =>
      'Сообщить, когда в этой сфере появится исполнитель';

  @override
  String get sampleRequestPosted =>
      'Запрос опубликован — его увидят исполнители.';

  @override
  String get sampleRequestTitle => 'Это пример запроса';

  @override
  String get sampleRequestBody =>
      'Настоящие запросы появятся здесь. Включите уведомления — мы сообщим, когда кто-то попросит помощи в этой сфере.';

  @override
  String get sampleAlertHelpPosts => 'Сообщать о новых запросах';

  @override
  String get sampleAlertOn => 'Готово — сообщим о новых запросах в этой сфере.';

  @override
  String get foundingBadge => 'Первый на YordamBor';

  @override
  String get foundingBadgeNote =>
      'Первые исполнители получают значок «Первый на YordamBor».';

  @override
  String get inviteTitle => 'Пригласите исполнителей';

  @override
  String get inviteBody =>
      'Знаете хорошего электрика, репетитора или салон? Пригласите их: чем больше настоящих исполнителей, тем больше клиентов.';

  @override
  String get inviteShare => 'Отправить приглашение';

  @override
  String get invitePrepare => 'Подготовить услугу для знакомого';

  @override
  String get inviteMessage =>
      'Присоединяйтесь к YordamBor: здесь клиенты по всему Узбекистану находят исполнителей. Добавить услугу — бесплатно, а первые исполнители получают значок «Первый на YordamBor».';

  @override
  String invitePersonalMessage(String name, String trade, String city) {
    return '$name, здравствуйте! Я в YordamBor — здесь клиенты находят исполнителей. Добавьте свою услугу «$trade» ($city): это бесплатно, а первые исполнители получают значок «Первый на YordamBor».';
  }

  @override
  String inviteOpenLink(String link) {
    return 'Откройте, чтобы начать: $link';
  }

  @override
  String inviteAppLink(String link) {
    return 'Приложение: $link';
  }

  @override
  String get invitePrepareTitle => 'Услуга для знакомого';

  @override
  String get invitePrepareBody =>
      'Выберите сферу и город. Человек получит ссылку, которая откроет «Новую услугу» с этими данными, и опубликует её сам.';

  @override
  String get invitePersonName => 'Имя (необязательно)';

  @override
  String get invitePersonPhone => 'Телефон (необязательно)';

  @override
  String get invitePickTrade => 'Сфера';

  @override
  String get inviteSendWhatsApp => 'Отправить в WhatsApp';

  @override
  String get inviteSendSms => 'Отправить по SMS';

  @override
  String get inviteSendOther => 'Другое приложение';

  @override
  String get inviteNeedTradeCity => 'Выберите сферу и город';

  @override
  String get onbGoalTitle => 'Что привело вас в YordamBor?';

  @override
  String get onbGoalNeedHelp => 'Мне нужна помощь';

  @override
  String get onbGoalNeedHelpSub => 'Найти исполнителя или описать задачу';

  @override
  String get onbGoalOffer => 'Я предлагаю услуги';

  @override
  String get onbGoalOfferSub => 'Находить клиентов и зарабатывать';

  @override
  String get onbGoalBoth => 'И то, и другое';

  @override
  String get onbGoalBothSub => 'Помогаю сам и иногда прошу помощи';

  @override
  String get onbCityTitle => 'Ваш город';

  @override
  String get onbCitySub => 'Покажем, что есть рядом с вами.';

  @override
  String get onbNext => 'Далее';

  @override
  String get onbDone => 'Готово';

  @override
  String get onbSkip => 'Пропустить';

  @override
  String onbStep(int current, int total) {
    return 'Шаг $current из $total';
  }

  @override
  String get onbIntro1Title => 'Услуги рядом с вами';

  @override
  String get onbIntro1Body => 'Специалисты и организации по всему Узбекистану.';

  @override
  String get onbIntro2Title => 'Нужна помощь? Попросите';

  @override
  String get onbIntro2Body => 'Опишите задачу — исполнители откликнутся сами.';

  @override
  String get onbIntro3Title => 'Предлагайте свои услуги';

  @override
  String get onbIntro3Body => 'Как специалист или как организация. Бесплатно.';

  @override
  String get onbIntro4Title => 'Честно и спокойно';

  @override
  String get onbIntro4Body =>
      'Сделка начинается, когда согласны обе стороны. Отзывы — только после выполненной работы. Оплата — по договорённости.';

  @override
  String get onbTypeTitle => 'Как вы работаете?';

  @override
  String get onbTypeSub =>
      'Это увидят клиенты на ваших услугах. Можно изменить позже.';

  @override
  String get onbTypeIndividualSub => 'Мастер, репетитор, фрилансер';

  @override
  String get onbTypeInstitutionSub => 'Компания, салон, клиника, учебный центр';

  @override
  String onbReadyToOffer(String action) {
    return 'Когда будете готовы, нажмите «$action».';
  }

  @override
  String get inviteAction => 'Пригласить знакомого исполнителя';

  @override
  String invitePersonalMessageNoName(String trade, String city) {
    return 'Здравствуйте! Я в YordamBor — здесь клиенты находят исполнителей. Добавьте свою услугу «$trade» ($city): это бесплатно, а первые исполнители получают значок «Первый на YordamBor».';
  }

  @override
  String get joinTitle => 'Вас пригласили в YordamBor';

  @override
  String get joinBody =>
      'Добавьте свою услугу — это бесплатно. Клиенты находят здесь исполнителей по сфере и городу.';

  @override
  String get joinLookAround => 'Сначала посмотреть приложение';

  @override
  String get onbStart => 'Начать';

  @override
  String get welcomeFindHelp => 'Найти помощь';

  @override
  String get welcomeGiveHelp => 'Помочь другим';

  @override
  String get onbTileLawyer => 'Юрист';

  @override
  String get onbTileBeauty => 'Красота';

  @override
  String get onbTileCatering => 'Кейтеринг';

  @override
  String get onbTileVet => 'Ветеринар';

  @override
  String get onbTileCleaning => 'Уборка';

  @override
  String get onbTileElectrician => 'Электрик';

  @override
  String get onbTilePlumber => 'Сантехник';

  @override
  String get onbTileDental => 'Стоматология';

  @override
  String onbMoreServices(int count) {
    return 'и ещё более $count видов услуг';
  }

  @override
  String get onbIllRequestTitle => 'Течёт кран на кухне';

  @override
  String get onbIllToday => 'Сегодня';

  @override
  String get onbIllNewOffers => '2 новых предложения';

  @override
  String get onbIllName1 => 'Азиз';

  @override
  String get onbIllName2 => 'Дилноза';

  @override
  String get onbIllOffer1 => 'Могу прийти сегодня в 18:00';

  @override
  String get onbIllOffer2 => 'Свободна завтра утром';

  @override
  String get onbIllNewRequest => 'Новый запрос';

  @override
  String get onbIllSocket => 'Заменить розетку';

  @override
  String get onbTileTutor => 'Репетитор';

  @override
  String get onbTileAuto => 'Автосервис';

  @override
  String get searchTooltip => 'Поиск';

  @override
  String get searchHint => 'Имя, организация или услуга';

  @override
  String get searchPrompt =>
      'Введите имя исполнителя, название организации или услугу, например «сантехник».';

  @override
  String get searchNoResults => 'Ничего не найдено';

  @override
  String get searchNoResultsHint =>
      'Опубликуйте запрос — исполнители откликнутся сами.';

  @override
  String get searchOffline =>
      'Нет связи: показано только то, что есть на телефоне.';

  @override
  String get onbTileRenovation => 'Ремонт квартир';

  @override
  String get onbTileFitness => 'Фитнес';

  @override
  String get onbTileTranslator => 'Переводчик';

  @override
  String get onbTileBarber => 'Барбер';

  @override
  String get onbTileMusic => 'Уроки музыки';

  @override
  String get onbTileStylist => 'Стилист';

  @override
  String get onbTileKindergarten => 'Детский сад';

  @override
  String get onbIllTutorTitle => 'Английский и IELTS';

  @override
  String get onbIllStylistRequest => 'Образ на свадьбу';

  @override
  String onbKindsChip(int count) {
    return '+$count видов услуг';
  }

  @override
  String get onbIllDentalRequestTitle => 'Болит зуб';

  @override
  String get onbTileDentist => 'Стоматолог';

  @override
  String get onbIllDentalOffer1 => 'Примем сегодня в 16:00';

  @override
  String get onbIllDentalOffer2 => 'Приму завтра утром';

  @override
  String get xizmatStatNoReviews => 'Нет отзывов';

  @override
  String get xizmatStatPrice => 'цена';

  @override
  String get xizmatStatPerHour => 'в час';

  @override
  String get xizmatStatNegotiable => 'Договорная';

  @override
  String get xizmatPromiseOwnWords => 'Слова исполнителя';

  @override
  String get xizmatAboutTitle => 'Об услуге';

  @override
  String get actionReadMore => 'Подробнее';

  @override
  String get actionReadLess => 'Свернуть';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count отзыва',
      many: '$count отзывов',
      few: '$count отзыва',
      one: '$count отзыв',
    );
    return '$_temp0';
  }

  @override
  String reviewsSeeAll(int count) {
    return 'Все отзывы ($count)';
  }

  @override
  String get reviewsFilterAll => 'Все';

  @override
  String get reviewsFilterEmpty => 'Отзывов с такой оценкой пока нет';

  @override
  String reviewsBarA11y(int stars, int count) {
    return 'Оценка $stars: $count';
  }

  @override
  String get xizmatHowTitle => 'Как это работает';

  @override
  String get xizmatHowAsk => 'Отправьте запрос';

  @override
  String get xizmatHowChat => 'Общайтесь в приложении';

  @override
  String get xizmatHowAgree => 'Договоритесь';

  @override
  String providerMemberSince(String year) {
    return 'Участник с $year г.';
  }

  @override
  String providerServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count услуги',
      many: '$count услуг',
      few: '$count услуги',
      one: '$count услуга',
    );
    return '$_temp0';
  }

  @override
  String get xizmatAboutHint =>
      'Что вы делаете, как работаете, что обещаете клиентам';

  @override
  String xizmatPricePerDay(String amount) {
    return '$amount/день';
  }

  @override
  String xizmatPricePerMonth(String amount) {
    return '$amount/мес.';
  }

  @override
  String xizmatPricePerUnit(String amount) {
    return '$amount/шт.';
  }

  @override
  String get xizmatStatPerDay => 'в день';

  @override
  String get xizmatStatPerMonth => 'в месяц';

  @override
  String get xizmatStatPerUnit => 'за штуку';

  @override
  String get priceChoiceTitle => 'Цена';

  @override
  String get priceChoiceServiceHint =>
      'Когда цена видна, клиенты пишут быстрее.';

  @override
  String get priceChoiceRequestHint => 'Сколько вы готовы заплатить?';

  @override
  String get priceChoiceNegotiable => 'Договорная';

  @override
  String get priceChoiceNegotiableHint => 'Обсудите в чате';

  @override
  String get priceChoiceAmount => 'Точная цена';

  @override
  String get priceChoiceAmountHint => 'Сумма и единица';

  @override
  String get priceAmountLabel => 'Сумма (сум)';

  @override
  String get priceAmountHint => 'Например: 150000';

  @override
  String get priceUnitFixed => 'За работу';

  @override
  String get priceUnitHour => 'В час';

  @override
  String get priceUnitDay => 'В день';

  @override
  String get priceUnitMonth => 'В месяц';

  @override
  String get priceUnitUnit => 'За штуку';

  @override
  String get priceChoiceRequired =>
      'Выберите цену: договорная или точная сумма';

  @override
  String get growthI00Title => 'Ваша услуга на YordamBor!';

  @override
  String get growthI00Body =>
      'Поздравляем! 30 дней мы будем присылать короткие советы, которые помогут найти больше клиентов.';

  @override
  String get growthI01Title => 'Фото вызывают доверие';

  @override
  String get growthI01Body =>
      'Добавьте хотя бы 3 фото своих работ — снимки «до и после» работают особенно хорошо.';

  @override
  String get growthI02Title => 'Покажите цену';

  @override
  String get growthI02Body =>
      'Точная цена — меньше вопросов и быстрее сделка. Укажите цену за час, день или работу.';

  @override
  String get growthI03Title => 'Когда вы свободны?';

  @override
  String get growthI03Body =>
      'Включите статус «Сейчас свободен»: клиенты первыми пишут тем, кто может прийти быстро.';

  @override
  String get growthI04Title => 'Пригласите своих клиентов в YordamBor';

  @override
  String get growthI04Body =>
      'Отправьте постоянным клиентам ссылку на услугу: в следующий раз они найдут вас в одно касание.';

  @override
  String get growthI05Title => 'Быстрый ответ — больше работы';

  @override
  String get growthI05Body =>
      'Отвечайте на запросы в течение часа: клиенты обычно выбирают того, кто ответил первым.';

  @override
  String get growthI06Title => 'Расскажите о себе';

  @override
  String get growthI06Body =>
      'Опишите опыт и манеру работы в 3–4 предложениях: клиенту важно знать, с кем он работает.';

  @override
  String get growthI07Title => 'Отзыв — лучшая реклама';

  @override
  String get growthI07Body =>
      'После работы попросите клиента оставить отзыв в YordamBor: каждая оценка приводит новых клиентов.';

  @override
  String get growthI08Title => 'YordamBor пригодится и вашим друзьям';

  @override
  String get growthI08Body =>
      'Расскажите друзьям и соседям о YordamBor: больше клиентов — больше заказов.';

  @override
  String get growthI09Title => 'Обновите календарь';

  @override
  String get growthI09Body =>
      'Отметьте занятые дни: клиенты увидят свободное время и запишутся на конкретный день.';

  @override
  String get growthI10Title => 'Следите за доходом';

  @override
  String get growthI10Body =>
      'В «Инструментах» есть доход, книга клиентов и чеки — всё в одном месте.';

  @override
  String get growthI11Title => '30 дней — отличный старт!';

  @override
  String get growthI11Body =>
      'Поделитесь ссылкой на услугу в соцсетях и продолжайте расти на YordamBor.';

  @override
  String get growthO00Title => 'Ваша организация на YordamBor!';

  @override
  String get growthO00Body =>
      'Поздравляем! 30 дней мы будем присылать короткие советы, как увеличить поток клиентов.';

  @override
  String get growthO01Title => 'Покажите своё место';

  @override
  String get growthO01Body =>
      'Добавьте хотя бы 3 фото здания, команды и работ: клиент заранее увидит, куда придёт.';

  @override
  String get growthO02Title => 'Откройте цены';

  @override
  String get growthO02Body =>
      'Укажите цену основной услуги: клиенты чаще пишут организациям с понятными ценами.';

  @override
  String get growthO03Title => 'Укажите часы работы';

  @override
  String get growthO03Body =>
      'Укажите рабочие дни и часы: клиенты сразу увидят, когда можно прийти.';

  @override
  String get growthO04Title => 'Пригласите своих клиентов в YordamBor';

  @override
  String get growthO04Body =>
      'Поделитесь ссылкой в своём Telegram-канале, на кассе или в SMS: клиенты найдут вас в одно касание.';

  @override
  String get growthO05Title => 'Лицензии и сертификаты';

  @override
  String get growthO05Body =>
      'Добавьте документы в профиль: официальное подтверждение повышает доверие к организации.';

  @override
  String get growthO06Title => 'Каждое направление — отдельная услуга';

  @override
  String get growthO06Body =>
      'Добавьте услуги по отдельности (до 5): клиент быстрее найдёт именно то, что нужно.';

  @override
  String get growthO07Title => 'Отвечайте на запросы быстро';

  @override
  String get growthO07Body =>
      'Назначьте сотрудника, отвечающего на запросы: быстрый ответ — больше сделок.';

  @override
  String get growthO08Title => 'Просите отзыв у каждого клиента';

  @override
  String get growthO08Body =>
      'Отзывы довольных клиентов поднимают рейтинг и приводят новых клиентов.';

  @override
  String get growthO09Title => 'Разместите ссылку на визитке';

  @override
  String get growthO09Body =>
      'Разместите ссылку YordamBor на визитке, в меню или на витрине: запись в одно касание.';

  @override
  String get growthO10Title => 'Учёт в одном месте';

  @override
  String get growthO10Body =>
      'Чеки, доход и книга клиентов — в «Инструментах»: управляйте организацией аккуратно.';

  @override
  String get growthO11Title => 'Первый месяц позади!';

  @override
  String get growthO11Body =>
      'Смотрите результаты в карточке услуги и продолжайте приумножать клиентов на YordamBor.';

  @override
  String get growthProgramTitle => 'Развивайте свой бизнес';

  @override
  String growthProgramDay(int day) {
    return 'День $day из 30';
  }

  @override
  String get growthTipDone => 'Готово';

  @override
  String get growthEarlierTips => 'Предыдущие советы';

  @override
  String get growthTipsOff => 'Отключить советы';

  @override
  String get growthTipsOffDone =>
      'Советы отключены. Включить их снова можно в настройках напоминаний.';

  @override
  String get growthTipsSetting => 'Советы для бизнеса';

  @override
  String get growthTipsSettingSub => '30 дней после добавления услуги';

  @override
  String growthInviteShareText(String link) {
    return 'YordamBor — надёжные мастера и услуги в одном месте. Скачайте: $link';
  }

  @override
  String get growthActionPhotos => 'Добавить фото';

  @override
  String get growthActionPrice => 'Указать цену';

  @override
  String get growthActionAvailability => 'Указать статус';

  @override
  String get growthActionHours => 'Указать часы';

  @override
  String get growthActionShare => 'Поделиться ссылкой';

  @override
  String get growthActionInvite => 'Пригласить';

  @override
  String get growthActionReply => 'Открыть запросы';

  @override
  String get growthActionDescription => 'Написать описание';

  @override
  String get growthActionReviews => 'Открыть сделки';

  @override
  String get growthActionCalendar => 'Открыть календарь';

  @override
  String get growthActionTools => 'Открыть инструменты';

  @override
  String get growthActionCertificates => 'Добавить документ';

  @override
  String get growthActionMoreServices => 'Добавить услугу';

  @override
  String get growthActionMyServices => 'Мои услуги';

  @override
  String get appointmentPhaseNow => 'Сейчас';

  @override
  String get appointmentPhaseToday => 'Сегодня';

  @override
  String get appointmentPhasePlanned => 'Запланировано';

  @override
  String get appointmentPhasePast => 'Ожидает завершения';

  @override
  String get appointmentPhaseDone => 'Выполнено';

  @override
  String get appointmentPhaseCancelled => 'Отменено';

  @override
  String get appointmentRoleProvider => 'Я оказываю';

  @override
  String get appointmentRoleClient => 'Я получаю';

  @override
  String get appointmentPartyClient => 'Клиент';

  @override
  String get appointmentPartyProvider => 'Исполнитель';

  @override
  String get appointmentCall => 'Позвонить';

  @override
  String get actionChat => 'Написать';

  @override
  String get actionKeep => 'Оставить';

  @override
  String get appointmentCancel => 'Отменить';

  @override
  String get appointmentCancelTitle => 'Отменить встречу?';

  @override
  String get appointmentCancelBody =>
      'Это действие нельзя отменить. Другая сторона будет уведомлена.';

  @override
  String get appointmentCancelConfirm => 'Да, отменить';

  @override
  String get appointmentSaveClient => 'Сохранить в список клиентов';

  @override
  String get appointmentFactPrice => 'ЦЕНА';

  @override
  String get appointmentFactDuration => 'ПРОДОЛЖИТ.';

  @override
  String appointmentDuration(int minutes) {
    return '$minutes мин';
  }

  @override
  String get availabilitySheetCaption => 'Что увидят клиенты прямо сейчас?';

  @override
  String get availabilityTileNowHint => 'Принимаю заказы сейчас';

  @override
  String get availabilityTileBusyHint => 'Занят, скоро вернусь';

  @override
  String get availabilityTileBookingHint => 'Бронируйте заранее';

  @override
  String get availabilityTileHidden => 'Скрыто';

  @override
  String get availabilityTileHiddenHint => 'Услуга не видна';

  @override
  String get availabilityUntilTitle => 'До когда?';

  @override
  String get availabilityUntilHour => '1 час';

  @override
  String get availabilityUntilToday => 'До конца дня';

  @override
  String get availabilityUntilForever => 'Бессрочно';

  @override
  String get availabilityHoursTitle => 'Рабочее время';

  @override
  String get availabilityHoursOwn => 'Мой график';

  @override
  String get availabilityHoursShared => 'Общее время';

  @override
  String get availabilityBusyToggle => 'Показывать занятые часы клиентам';

  @override
  String get availabilityBusyToggleHint =>
      'Клиенты видят двухнедельную сетку с вашими свободными и занятыми слотами';

  @override
  String get availabilityPreview => 'Как видят клиенты';

  @override
  String get availabilityHiddenPreview => 'Скрыто из поиска';

  @override
  String get availabilitySaved => 'Статус сохранён';

  @override
  String get businessEmptyTitle => 'Начните зарабатывать на YordamBor';

  @override
  String get businessEmptyBody =>
      'Тысячи людей рядом прямо сейчас ищут помощи. Добавьте первую услугу — это займёт всего 2 минуты.';

  @override
  String get calendarTabTitle => 'Расписание';

  @override
  String get calendarNoAppointments => 'Встреч пока нет';

  @override
  String get calendarNoAppointmentsHint =>
      'Согласованные сделки появятся здесь как встречи';

  @override
  String get calendarSectionToday => 'Сегодня';

  @override
  String get calendarSectionUpcoming => 'Предстоящие';

  @override
  String get calendarSectionPast => 'Прошедшие';

  @override
  String get calendarBusyTitle => 'Моя занятость';

  @override
  String get calendarBusyAllDay => 'Занят весь день';

  @override
  String get calendarBusyHours => 'Занятые часы';

  @override
  String get calendarServicesStrip => 'Мои услуги';

  @override
  String get calendarReminders => 'Напоминания';

  @override
  String get reminderLeadDay => 'За 1 день';

  @override
  String get reminderLead3Hours => 'За 3 часа';

  @override
  String get reminderLeadHour => 'За 1 час';

  @override
  String get reminderLead15Min => 'За 15 минут';

  @override
  String get saveClientPromptTitle => 'Сохранить клиента?';

  @override
  String saveClientPromptBody(String name) {
    return 'Хотите добавить $name в список клиентов?';
  }

  @override
  String get saveClientConfirm => 'Сохранить';

  @override
  String get saveClientSkip => 'Не сейчас';

  @override
  String get saveClientDone => 'Клиент сохранён';

  @override
  String get notifSectionSoon => 'Ближайшие встречи';

  @override
  String get notifAppointmentCancelledTitle => 'Встреча отменена';

  @override
  String get notifSubsectorHelpTitle => 'В вашей области нужна помощь';
}
