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
  String get tabFavorites => 'Избранное';

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
  String get invalidPhone => 'Введите корректный номер телефона (+998...)';

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
  String get languageUz => 'O\'zbek';

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
  String get kelishuvMessageHint => 'Напишите сообщение...';

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
  String get xizmatServiceCityHint => 'Например: Ташкент (необязательно)';

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
      'Договорная, фиксированная или почасовая — вы сами выбираете.';

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
  String get xizmatPricingRequiredError =>
      'Укажите цену для фиксированной или почасовой оплаты';

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
  String get xizmatAvailabilityCallMe => 'Позвоните';

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
}
