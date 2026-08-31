// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'YordamBor';

  @override
  String get splashTagline => '在 YordamBor，帮助就在这里！';

  @override
  String get tabHome => '首页';

  @override
  String get tabFavorites => '收藏';

  @override
  String get tabProfile => '个人资料';

  @override
  String get filterYordamBor => '提供帮助';

  @override
  String get filterYordamKerak => '需要帮助';

  @override
  String get filterCategory => '类别';

  @override
  String get filterSubcategory => '子类别';

  @override
  String get filterPickCategoryFirst => '请先选择类别';

  @override
  String get filterProviderType => '类型';

  @override
  String get filterProviderAll => '全部类型';

  @override
  String get filterProviderTypeHint => '选择服务提供者类型';

  @override
  String get filterProviderAllHint => '个人与机构';

  @override
  String get filterProviderIndividualHint => '自由职业者、导师、专家';

  @override
  String get filterProviderInstitutionHint => '诊所、工作室、公司';

  @override
  String get filterAllCategories => '全部领域';

  @override
  String get filterAllSubcategories => '全部子领域';

  @override
  String get filterCategoryHint => '您想浏览哪个领域？';

  @override
  String get filterAllCategoriesHint => '所有领域的服务';

  @override
  String get filterAllSubcategoriesHint => '所选领域的全部方向';

  @override
  String homeFeedShowing(String summary) {
    return '当前显示：$summary';
  }

  @override
  String get filterPickProviderTypeFirst => '请先选择个人或机构';

  @override
  String get homeEmptyTitle => '各类服务即将上线';

  @override
  String get homeEmptySubtitle => '请等待各行业的服务提供者上传作品集';

  @override
  String get homeDemoXizmat => '演示服务作为示例展示';

  @override
  String get homeDemoPosts => '演示帖子作为示例展示';

  @override
  String get homeJobsEmptyTitle => '需要帮助';

  @override
  String get homeJobsEmptySubtitle => '发布第一个需求或更改筛选条件';

  @override
  String get favoritesEmptyTitle => '收藏您喜欢的服务';

  @override
  String get favoritesEmptySubtitle => '点击卡片上的 ♥';

  @override
  String get profileGuestTitle => '欢迎使用 YordamBor';

  @override
  String get profileGuestSubtitle => '注册后可发起交易和发布。收藏无需登录。';

  @override
  String get profilePhone => '电话';

  @override
  String get profileChangePhoto => '更换照片';

  @override
  String get profilePhotoUpdated => '头像已更新';

  @override
  String get profilePhotoFailed => '无法上传照片';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get notificationsTitle => '通知';

  @override
  String get notificationsEmpty => '暂无通知';

  @override
  String get fabPostYordamKerak => '发布需求';

  @override
  String get welcomeTitle => '在 YordamBor，帮助就在这里！';

  @override
  String get welcomeBrand => 'YordamBor.';

  @override
  String get welcomeBody => '发现各类服务。提供帮助或寻求帮助。';

  @override
  String get startBrowsing => '开始';

  @override
  String get createAccount => '创建账户';

  @override
  String get alreadyHaveAccount => '已有账户？';

  @override
  String get authContinueTitle => '登录以继续';

  @override
  String get authContextGeneric => '登录以继续';

  @override
  String get authContextFavorite => '登录以收藏';

  @override
  String get authContextYordamKerak => '登录以发送请求';

  @override
  String get authContextYordamBor => '登录以发送报价';

  @override
  String get authContextPostJob => '登录以发布';

  @override
  String get authContextDeal => '登录以开始交易';

  @override
  String get later => '稍后';

  @override
  String get fullName => '全名';

  @override
  String get email => '邮箱';

  @override
  String get phone => '电话';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get fieldRequired => '此字段为必填项';

  @override
  String get invalidEmail => '请输入有效的邮箱地址';

  @override
  String get invalidPhone => '请输入有效的电话号码（+998...）';

  @override
  String get invalidNumber => '请输入有效数字';

  @override
  String get invalidMinutes => '请输入有效的分钟数';

  @override
  String get passwordTooShort => '密码至少需要 8 个字符';

  @override
  String get passwordsDoNotMatch => '两次输入的密码不一致';

  @override
  String get acceptTermsRequired => '必须同意使用条款';

  @override
  String get acceptTerms => '我同意使用条款';

  @override
  String get acceptTermsLead => '我同意';

  @override
  String get acceptTermsLink => '使用条款';

  @override
  String get acceptTermsTrail => '';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get resetPasswordTitle => '新密码';

  @override
  String get resetPasswordBody => '请输入并保存新密码。';

  @override
  String get resetPasswordSubmit => '保存密码';

  @override
  String get resetPasswordSuccess => '密码已更新';

  @override
  String get resetPasswordSendLink => '发送重置链接';

  @override
  String resetPasswordEmailSent(String emailAddress) {
    return '我们已向 $emailAddress 发送密码重置链接。';
  }

  @override
  String get resetPasswordEmailHint => '请在手机上打开链接。应用会打开以便您设置新密码。';

  @override
  String get resetPasswordExpiredTitle => '链接已过期';

  @override
  String get resetPasswordExpiredBody => '请重新请求密码重置链接。';

  @override
  String get continueAction => '继续';

  @override
  String get verifyEmailTitle => '验证邮箱';

  @override
  String verifyEmailBody(String emailAddress) {
    return '我们已向 $emailAddress 发送确认链接。';
  }

  @override
  String get verifyEmailBodyMissing => '我们已向您的邮箱发送确认链接。打开链接后请点击“我已确认”。';

  @override
  String get verifyEmailCheck => '我已确认';

  @override
  String get verifyEmailPending => '邮箱尚未验证，请检查收件箱。';

  @override
  String get openMail => '打开邮件';

  @override
  String get resendEmail => '重新发送';

  @override
  String get continueBrowsing => '继续浏览';

  @override
  String welcomeBack(String name) {
    return '欢迎，$name！';
  }

  @override
  String get welcomeGuestName => '朋友';

  @override
  String welcomeNewTitle(String name) {
    return '欢迎，$name！';
  }

  @override
  String get welcomeNewBody => '很高兴您加入 YordamBor。找服务、提供帮助或发布需求——我们一路陪伴您。';

  @override
  String welcomeLoginTitle(String name) {
    return '欢迎回来，$name！';
  }

  @override
  String get welcomeLoginBody => '很高兴再次见到您。今天需要什么帮助？';

  @override
  String welcomeReturnTitle(String name) {
    return '你好，$name！';
  }

  @override
  String get welcomeReturnBody => '您需要的服务正在等您。';

  @override
  String get welcomeReturnBodyYordamKerak => '您的服务符合客户需求吗？';

  @override
  String homeGreetingShort(String name) {
    return '你好，$name！';
  }

  @override
  String get homeGreetingYordamBor => '今天需要什么帮助？';

  @override
  String get homeGreetingYordamKerak => '今天能帮忙吗？';

  @override
  String get providerPromptTitle => '您提供服务吗？';

  @override
  String get providerPromptBody => '添加作品集 — 客户将找到您。';

  @override
  String get createXizmat => '创建服务';

  @override
  String get signOut => '退出';

  @override
  String get settings => '设置';

  @override
  String get settingsSubtitle => '语言、隐私、账户';

  @override
  String get settingsAppearance => '外观';

  @override
  String get settingsDarkMode => '主题';

  @override
  String get settingsThemeSystem => '系统';

  @override
  String get settingsThemeLight => '浅色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsTools => '工具';

  @override
  String get settingsLegal => '法律';

  @override
  String get settingsPrivacy => '隐私政策';

  @override
  String get settingsPrivacySection => '隐私';

  @override
  String get settingsShowPhoneLabel => '在资料中显示电话';

  @override
  String get settingsShowPhoneSubtitle => '公开资料页会显示您的电话号码';

  @override
  String get postContactSectionTitle => '联系方式';

  @override
  String get postContactSectionSubtitle => '资料始终公开。是否显示电话号码由您决定。';

  @override
  String get postContactPhoneLabel => '电话号码';

  @override
  String get postContactPhoneHint => '+998 90 123 45 67';

  @override
  String get postContactPhoneOptional => '可选';

  @override
  String get postShowPhoneLabel => '显示电话号码';

  @override
  String get postShowPhoneSubtitle => '此帖子会显示您的电话';

  @override
  String get postShowProfileLabel => '显示资料';

  @override
  String get postShowProfileSubtitle => '用户可从此帖查看您的资料';

  @override
  String get postAuthorHidden => '作者已隐藏';

  @override
  String get settingsTerms => '使用条款';

  @override
  String get settingsDeleteAccount => '删除账户';

  @override
  String get settingsDeleteAccountHint => '所有交易将被取消';

  @override
  String get settingsDeleteAccountConfirm => '您的所有数据、服务和进行中的交易将被删除。此操作无法撤销。';

  @override
  String get settingsDeleteAccountAction => '删除账户';

  @override
  String get settingsDeleteAccountDone => '账户已删除';

  @override
  String get remindersTitle => '提醒';

  @override
  String get remindersAdd => '添加提醒';

  @override
  String get remindersEmptyTitle => '暂无提醒';

  @override
  String get remindersEmptySubtitle => '与客户簿日历同步。交易开始时也会创建';

  @override
  String get remindersFieldClientName => '客户姓名';

  @override
  String get remindersUpcoming => '即将到来';

  @override
  String get remindersPast => '已过期';

  @override
  String get remindersFieldTitle => '标题';

  @override
  String get remindersFieldBody => '备注（可选）';

  @override
  String get remindersSave => '保存';

  @override
  String get remindersSettingsSubtitle => '交易和预约提醒';

  @override
  String get legalPrivacyTitle => '隐私政策';

  @override
  String get legalTermsTitle => '使用条款';

  @override
  String get legalPrivacyBody =>
      'YordamBor 仅将您的数据用于服务、交易和安全。\n\n1. 收集的数据\n\n姓名、邮箱、电话、服务作品集图片、交易消息和通知。\n\n2. 存储位置\n\n数据加密存储在 Supabase 服务器上。\n\n3. 第三方\n\n我们不出售您的数据。仅与运行应用所需的技术合作伙伴共享。\n\n4. 您的权利\n\n您可以查看、更新或删除账户和数据。\n\n5. 联系\n\n如有问题，请通过应用内的设置部分联系我们。';

  @override
  String get legalTermsBody =>
      'YordamBor 是连接各行业服务提供者与客户的移动平台。使用应用即表示您接受这些条款。\n\n1. 总则\n\nYordamBor 不直接提供服务，仅连接双方。平台不是支付中介。\n\n2. 账户与注册\n\n您须提供准确、最新的信息并验证邮箱。\n\n3. 服务与作品集\n\n每条服务信息须至少包含一张真实作品集照片。虚假或违法信息可能被删除。\n\n4. 交易（Yordam Bor / Yordam Kerak）\n\n价格、时间和工作范围由双方协商。YordamBor 保存交易过程，但不代收付款。\n\n5. 禁止行为\n\n禁止欺诈、辱骂、垃圾信息、非法服务或故意违反规则。\n\n6. 账户暂停\n\n违反条款时，YordamBor 可暂停或删除账户。\n\n7. 变更\n\n条款可能更新。继续使用即表示接受更新后的条款。\n\n8. 联系\n\n如有问题，请通过应用内的设置部分联系我们。';

  @override
  String get shareXizmat => '分享';

  @override
  String shareXizmatMessage(String name) {
    return '在 YordamBor 查看 $name';
  }

  @override
  String get shareYordamKerak => '分享需求';

  @override
  String shareYordamKerakMessage(String title) {
    return '需要帮助：$title — YordamBor';
  }

  @override
  String get postNotFound => '未找到需求';

  @override
  String get shareCopied => '链接已复制';

  @override
  String get languageUz => 'O\'zbek';

  @override
  String get languageRu => 'Русский';

  @override
  String get languageEn => 'English';

  @override
  String get languageZh => '中文';

  @override
  String get actionSave => '保存';

  @override
  String get actionCancel => '取消';

  @override
  String get actionEdit => '编辑';

  @override
  String get actionDelete => '删除';

  @override
  String get actionView => '查看';

  @override
  String get actionUnblock => '取消屏蔽';

  @override
  String get actionSubmit => '提交';

  @override
  String get kelishuvTitle => '交易';

  @override
  String get kelishuvNotFound => '未找到交易';

  @override
  String get kelishuvMessages => '消息';

  @override
  String get kelishuvNoMessages => '暂无消息';

  @override
  String get kelishuvOpeningOffer => '初始报价';

  @override
  String get kelishuvReject => '拒绝';

  @override
  String get kelishuvCancel => '取消';

  @override
  String get kelishuvAccept => '我接受';

  @override
  String get kelishuvComplete => '工作已完成';

  @override
  String get kelishuvEditTerms => '编辑条款';

  @override
  String get kelishuvTermsChanged => '条款已更改 — 双方需重新确认';

  @override
  String get kelishuvAwaitingComplete => '对方已确认完成 — 请你也确认';

  @override
  String get kelishuvPartyA => '甲方';

  @override
  String get kelishuvPartyB => '乙方';

  @override
  String get kelishuvCompleteA => 'A 已完成';

  @override
  String get kelishuvCompleteB => 'B 已完成';

  @override
  String get kelishuvDualAccepted => '双方已接受';

  @override
  String get kelishuvCompleteTooEarly => '工作开始 3 天后才能标记完成';

  @override
  String kelishuvCompleteDaysLeft(int days) {
    return '还需 $days 天才能标记完成';
  }

  @override
  String get kelishuvMessageHint => '写消息...';

  @override
  String get kelishuvIncoming => '收到的';

  @override
  String get kelishuvIncomingSub => '对您服务的请求';

  @override
  String get kelishuvRequests => '我的请求';

  @override
  String get kelishuvRequestsSub => '您发起的交易';

  @override
  String get kelishuvArchive => '归档';

  @override
  String get kelishuvArchiveSub => '已关闭的交易';

  @override
  String get kelishuvNeedsResponse => '需要回复';

  @override
  String get kelishuvNeedsConfirm => '确认';

  @override
  String get profileBlocked => '已屏蔽用户';

  @override
  String get profileClientBook => '客户簿';

  @override
  String get profileClientBookSub => '本地客户列表';

  @override
  String get profileEarnings => '我的收入';

  @override
  String get profileEarningsSub => '自行申报的收入';

  @override
  String get profileMyXizmatlar => '我的服务';

  @override
  String get profileSetAvailability => '设置可用状态';

  @override
  String get profileSectionLoadFailed => '无法加载，请检查网络连接。';

  @override
  String get actionRetry => '重试';

  @override
  String get clientBookTitle => '客户簿';

  @override
  String get clientBookList => '列表';

  @override
  String get clientBookCalendar => '日历';

  @override
  String get clientBookOpenDeal => '打开交易';

  @override
  String get clientBookEditClient => '编辑客户';

  @override
  String get clientBookAdd => '添加客户';

  @override
  String get clientBookBookClient => '预约客户';

  @override
  String get clientBookEditBooking => '编辑预约';

  @override
  String get clientBookNameRequired => '请输入客户姓名';

  @override
  String get clientBookDateRequired => '请选择预约日期';

  @override
  String get clientBookNoteLabel => '备注';

  @override
  String get clientBookEmptyTitle => '客户簿为空';

  @override
  String get clientBookEmptySub => '在日历中预约客户，或在交易开始时自动添加';

  @override
  String get clientBookDateLabel => '预约日期';

  @override
  String get clientBookBookDay => '预约此日';

  @override
  String get clientBookCalendarHint => '点击日期为客户预约';

  @override
  String get clientBookMarkComplete => '标记服务已完成';

  @override
  String get clientBookMarkCancelled => '标记取消';

  @override
  String get clientBookMarkPending => '标记待处理';

  @override
  String get clientBookCompleteAmount => '客户收入 (UZS)';

  @override
  String get clientBookDeliveryCompleted => '已完成';

  @override
  String get clientBookDeliveryPending => '待处理';

  @override
  String get clientBookDeliveryCancelled => '已取消';

  @override
  String get clientBookNewClientOption => '新客户';

  @override
  String get clientBookSelectClient => '客户';

  @override
  String get clientBookServiceLabel => '服务（可选）';

  @override
  String clientBookBookingCount(int count) {
    return '$count 次预约';
  }

  @override
  String get appointmentStatusUpcoming => '即将到来';

  @override
  String get appointmentStatusCancelled => '已取消';

  @override
  String get appointmentStatusPostponed => '已改期';

  @override
  String get appointmentStatusIncomplete => '未完成';

  @override
  String get appointmentStatusCompleted => '已完成';

  @override
  String get kelishuvAppointmentRequiredTitle => '设置预约日期';

  @override
  String get kelishuvAppointmentRequiredBody => '双方已同意交易。请选择服务时间。';

  @override
  String get remindersSettingsFollowUpLabel => '预约后跟进（小时）';

  @override
  String get remindersFollowUpPrompt => '这次预约成功了吗？';

  @override
  String get clientBookAppointmentHistory => '预约历史';

  @override
  String get clientBookAppointmentNotesLabel => '预约备注';

  @override
  String get clientBookPhotosLabel => '照片';

  @override
  String get clientBookPhotosEmpty => '暂无照片';

  @override
  String get clientBookAddPhoto => '添加照片';

  @override
  String clientBookClientStats(int completed, int cancelled, int upcoming) {
    return '$completed 已完成 · $cancelled 已取消 · $upcoming 即将到来';
  }

  @override
  String get remindersUpdateStatus => '更新状态';

  @override
  String get remindersSettingsTitle => '提醒设置';

  @override
  String get remindersSettingsAlertsLabel => '提醒时间（分钟前）';

  @override
  String get remindersSettingsAtTime => '准时';

  @override
  String get earningsTitle => '我的收入';

  @override
  String get earningsTotal => '总计（自行申报）';

  @override
  String get earningsEdit => '编辑收入';

  @override
  String get earningsAdd => '添加收入';

  @override
  String get earningsAmountLabel => '金额 (UZS)';

  @override
  String get earningsNoteLabel => '备注';

  @override
  String get earningsAmountRequired => '请输入金额';

  @override
  String get earningsEmptyTitle => '暂无收入记录';

  @override
  String get earningsEmptySub => '有定价的交易进行中时自动添加';

  @override
  String get earningsDisclaimer => '仅供个人记录，非税务或官方报告。';

  @override
  String get notificationsEmptySub => '交易更新将显示在这里';

  @override
  String get notificationKelishuvAccept => '交易已接受';

  @override
  String get notificationKelishuvMessage => '新消息';

  @override
  String get notificationKelishuvComplete => '工作已完成';

  @override
  String get notificationGeneric => '通知';

  @override
  String notificationTimeMinutes(int count) {
    return '$count 分钟';
  }

  @override
  String notificationTimeHours(int count) {
    return '$count 小时';
  }

  @override
  String notificationTimeDate(int day, int month) {
    return '$day.$month';
  }

  @override
  String get reviewsTitle => '评价';

  @override
  String get reviewProviderReplyLabel => '服务提供者回复';

  @override
  String get reviewsEmpty => '暂无评价';

  @override
  String get reviewsRate => '评分';

  @override
  String xizmatCompletedCount(int count) {
    return '已完成 $count 个';
  }

  @override
  String get demoKelishuvBlocked => '演示模式下无法创建交易';

  @override
  String get genericUser => '用户';

  @override
  String get actionPick => '选择';

  @override
  String get xizmatStepIdentity => '1/3 — 您是谁？';

  @override
  String get xizmatStepPortfolio => '2/3 — 作品集';

  @override
  String get xizmatProviderIndividual => '个人';

  @override
  String get xizmatProviderInstitution => '机构';

  @override
  String get xizmatNameLabel => '服务名称';

  @override
  String get xizmatDescriptionLabel => '简短描述';

  @override
  String get xizmatDescriptionFull => '描述';

  @override
  String get xizmatServiceCityLabel => '服务城市';

  @override
  String get xizmatServiceCityHint => '例如：塔什干（可选）';

  @override
  String get xizmatContinue => '继续';

  @override
  String get xizmatPortfolioHint => '至少需要 1 张图片。第一张为封面。';

  @override
  String get xizmatHeroLabel => '封面';

  @override
  String get xizmatUploading => '上传中…';

  @override
  String get xizmatReady => '完成';

  @override
  String get xizmatBack => '返回';

  @override
  String get xizmatSuccessTitle => '您的服务已就绪！';

  @override
  String get xizmatSuccessBody => '作品集已上传。客户现在可以在 Discover 中找到您。';

  @override
  String get xizmatEditTitle => '编辑服务';

  @override
  String get cannotRequestOwnXizmat => '不能向自己的服务发送请求';

  @override
  String get xizmatNotFound => '未找到服务';

  @override
  String get xizmatNoPermission => '无权限';

  @override
  String get xizmatBasicInfo => '基本信息';

  @override
  String get xizmatPortfolio => '作品集';

  @override
  String get xizmatPortfolioEmpty => '作品集为空。至少需要一张图片。';

  @override
  String get xizmatAddPhoto => '添加图片';

  @override
  String get xizmatSetHero => '设为封面';

  @override
  String get xizmatAnalytics => '分析';

  @override
  String get xizmatReviewReplies => '评价回复';

  @override
  String get xizmatSaved => '已保存';

  @override
  String get xizmatReplySaved => '回复已保存';

  @override
  String get xizmatPickCategoryError => '请选择类别和子类别';

  @override
  String get yordamKerakPostTitle => '需要帮助';

  @override
  String get yordamKerakTitleLabel => '标题';

  @override
  String get yordamKerakTitleHint => '例如：需要水管工';

  @override
  String get yordamKerakMessageLabel => '项目描述';

  @override
  String get yordamKerakMessageHint => '需要做什么、在哪里、什么时候？';

  @override
  String get yordamKerakBudgetLabel => '预算（可选，UZS）';

  @override
  String get yordamKerakDateLabel => '期望日期（可选）';

  @override
  String get yordamKerakDurationLabel => '时长（分钟，可选）';

  @override
  String get yordamKerakPublish => '发布';

  @override
  String get yordamKerakTitleTooShort => '标题至少 3 个字符';

  @override
  String get yordamKerakMessageTooShort => '描述至少 10 个字符';

  @override
  String get yordamKerakCategoryRequired => '请选择领域';

  @override
  String get yordamKerakSubcategoryRequired => '请选择子领域';

  @override
  String get userProfileTitle => '个人资料';

  @override
  String get userProfileNotFound => '未找到资料';

  @override
  String get userProfileServices => '服务';

  @override
  String get userProfileServicesEmpty => '暂无服务';

  @override
  String get userProfileRequests => '需要帮助';

  @override
  String get userProfileRequestsEmpty => '暂无帖子';

  @override
  String get userProfileAvailable => '可预约';

  @override
  String get userProfileBusy => '暂不可约';

  @override
  String get userProfilePartiallyBusy => '部分不可约';

  @override
  String get userProfileCall => '拨打';

  @override
  String get userProfilePhoneHidden => '电话号码已隐藏';

  @override
  String get userProfileViewProfile => '查看资料';

  @override
  String get xizmatProviderSection => '服务提供者';

  @override
  String get profileViewPublic => '我的公开资料';

  @override
  String get profileCertificatesTitle => '证书与资质';

  @override
  String get profileCertificatesSubtitle => '上传资质文件供客户查看';

  @override
  String get profileCertificatesDisclaimer => 'YordamBor 不验证上传的文件。客户需自行核实。';

  @override
  String get profileCertificatesAdd => '添加证书';

  @override
  String get profileCertificatesTitleLabel => '标题';

  @override
  String get profileCertificatesTitleHint => '例如：管道工课程证书';

  @override
  String get profileCertificatesIssuerLabel => '颁发机构（可选）';

  @override
  String get profileCertificatesIssuerHint => '例如：培训机构名称';

  @override
  String get profileCertificatesEmpty => '尚未上传证书';

  @override
  String get profileCertificatesMaxReached => '最多 8 个证书';

  @override
  String get profileCertificatesAdded => '证书已添加';

  @override
  String get profileCertificatesRemoved => '证书已删除';

  @override
  String get profileCertificatesRemoveTitle => '删除证书？';

  @override
  String get xizmatOtherServices => '其他服务';

  @override
  String get xizmatViewAllServices => '查看所有服务';

  @override
  String get xizmatStatusAvailable => '可预约';

  @override
  String get xizmatStatusBusy => '暂不可约';

  @override
  String get safetyTitle => '安全';

  @override
  String get safetyBlock => '屏蔽';

  @override
  String safetyBlockConfirmMessage(String name) {
    return '屏蔽 $name？其内容将被隐藏。';
  }

  @override
  String get safetyBlockDone => '用户已屏蔽';

  @override
  String get safetyHideUser => '隐藏用户';

  @override
  String get safetyReportReason => '举报原因（可选）';

  @override
  String get safetyReportHint => '发生了什么？';

  @override
  String get safetyReportSubmit => '提交举报';

  @override
  String get safetyReportDone => '举报已提交。谢谢。';

  @override
  String get reviewLater => '稍后';

  @override
  String get blockedUnblocked => '已取消屏蔽';

  @override
  String kelishuvMoreCount(int count) {
    return '还有 $count 个';
  }

  @override
  String get demoPostPickReal => '演示帖子 — 请选择真实帖子';

  @override
  String get createXizmatFirst => '请先创建服务资料';

  @override
  String get pickXizmat => '选择服务';

  @override
  String get categoryPickTitle => '选择类别';

  @override
  String get categoryAll => '所有类别';

  @override
  String get subcategoryAll => '所有子类别';

  @override
  String get analyticsViews => '浏览';

  @override
  String get analyticsFavorites => '收藏';

  @override
  String get analyticsActiveDeals => '进行中的交易';

  @override
  String get analyticsCompletedDeals => '已完成';

  @override
  String analyticsConversion(String rate) {
    return '转化率：$rate%';
  }

  @override
  String get kelishuvArchiveEmptyTitle => '归档为空';

  @override
  String get kelishuvArchiveEmptySub => '已完成或取消的交易将显示在这里';

  @override
  String get kelishuvStatusNegotiating => '协商中';

  @override
  String get kelishuvStatusInProgress => '进行中';

  @override
  String get kelishuvStatusCompleted => '已完成';

  @override
  String get kelishuvStatusCancelled => '已取消';

  @override
  String get kelishuvStatusRejected => '已拒绝';

  @override
  String get kelishuvStatusArchived => '归档';

  @override
  String get busySlotTitle => '时间冲突';

  @override
  String busySlotMessage(String names) {
    return '此日期已有预约：$names。仍要继续吗？';
  }

  @override
  String taklifFlowTitleYordamBor(String name) {
    return '提供帮助 — $name';
  }

  @override
  String taklifFlowTitleYordamKerak(String name) {
    return '需要帮助 — $name';
  }

  @override
  String get taklifTitle => '发送报价';

  @override
  String get repeatBook => '再次预约';

  @override
  String get repeatBookTitle => '再次预约';

  @override
  String get taklifSubtitle => '在开始时发送消息和价格。双方都接受后开始工作。';

  @override
  String get taklifMessageLabel => '消息';

  @override
  String get taklifMessageHint => '您能提供什么帮助？';

  @override
  String get taklifPriceLabel => '价格（可选，UZS）';

  @override
  String get taklifDateLabel => '选择日期（可选）';

  @override
  String get taklifDurationLabel => '时长（分钟，可选）';

  @override
  String get taklifSubmit => '发送报价';

  @override
  String get reviewCommentLabel => '评论（可选）';

  @override
  String get reviewCommentHint => '体验如何？';

  @override
  String get xizmatReplyLabel => '您的回复';

  @override
  String get xizmatReplyHint => '回复客户';

  @override
  String get xizmatClientLabel => '客户';

  @override
  String get kelishuvTermsDateLabel => '选择日期';

  @override
  String get kelishuvTermsMessageLabel => '消息';

  @override
  String get kelishuvTermsPriceLabel => '价格（UZS）';

  @override
  String kelishuvDetailPost(String title) {
    return '帖子：$title';
  }

  @override
  String kelishuvDetailPrice(String amount, String currency) {
    return '价格：$amount $currency';
  }

  @override
  String kelishuvDetailTime(String slot) {
    return '时间：$slot';
  }

  @override
  String kelishuvSlotDateDuration(String date, int minutes) {
    return '$date · $minutes 分钟';
  }

  @override
  String get xizmatPricingSectionTitle => '定价';

  @override
  String get xizmatPricingSectionSubtitle => '可协商、固定或按小时——由您自行选择。';

  @override
  String get xizmatPricingNegotiable => '可协商';

  @override
  String get xizmatPricingFixed => '固定价';

  @override
  String get xizmatPricingHourly => '按小时';

  @override
  String get xizmatPricingFixedRateLabel => '价格（UZS）';

  @override
  String get xizmatPricingHourlyRateLabel => '时薪（UZS）';

  @override
  String get xizmatPricingRateHint => '例如：150000';

  @override
  String get xizmatPricingMinDurationLabel => '最小时长（分钟，可选）';

  @override
  String get xizmatPricingMinDurationHint => '例如：120';

  @override
  String get xizmatPricingRequiredError => '固定价或按小时定价需填写价格';

  @override
  String get xizmatPriceNegotiable => '价格可协商';

  @override
  String xizmatPricePerHour(String amount) {
    return '$amount/小时';
  }

  @override
  String get xizmatAvailabilitySectionTitle => '可用状态';

  @override
  String get xizmatAvailabilitySectionSubtitle =>
      '可选 — 让客户知道您是否空闲。客户簿不会自动更改此状态。';

  @override
  String get xizmatAvailabilityShowLabel => '显示可用状态';

  @override
  String get xizmatAvailabilityShowSubtitle => '关闭后不显示任何状态';

  @override
  String get xizmatAvailabilityAvailableNow => '现在可预约';

  @override
  String get xizmatAvailabilityBusy => '暂不可约';

  @override
  String get xizmatAvailabilityCallMe => '请致电预约';

  @override
  String get xizmatAvailabilityFromLabel => '从（可选）';

  @override
  String get xizmatAvailabilityUntilLabel => '至（可选）';

  @override
  String xizmatAvailabilityUntilSuffix(String time) {
    return ' · 至 $time';
  }

  @override
  String xizmatAvailabilityFromSuffix(String time) {
    return ' · 从 $time';
  }

  @override
  String xizmatAvailabilityRangeSuffix(String from, String until) {
    return ' · $from–$until';
  }

  @override
  String get xizmatAvailabilityModeRequiredError => '请选择可用状态类型';

  @override
  String get xizmatAvailabilityWindowInvalidError => '结束时间必须晚于开始时间';

  @override
  String get xizmatPromiseSectionTitle => '您的承诺';

  @override
  String get xizmatPromiseSectionSubtitle =>
      '告诉客户您的服务承诺。这是您的 motto — 不是 YordamBor 的担保。';

  @override
  String get xizmatPromiseShowLabel => '显示我的承诺';

  @override
  String get xizmatPromiseShowSubtitle => '在您的 listing 上向客户展示';

  @override
  String get xizmatPromisePresetsLabel => '快捷模板（可编辑）';

  @override
  String get xizmatPromiseFieldLabel => '您的承诺';

  @override
  String get xizmatPromiseFieldHint => '自行填写或编辑模板';

  @override
  String get xizmatPromisePreset1 => '不满意则重新完成';

  @override
  String get xizmatPromisePreset2 => '质量保证 — 有问题则退款';

  @override
  String get xizmatPromisePreset3 => '准时且按约定价格';

  @override
  String get xizmatPromiseDisclaimer => 'YordamBor 不提供担保。此为服务提供者自行声明。';

  @override
  String get xizmatPromiseRequiredError => '请填写承诺或关闭此选项';

  @override
  String get xizmatPromiseTooLongError => '承诺内容过长';

  @override
  String get settingsHelp => '帮助与支持';

  @override
  String get supportReportTitle => '报告问题';

  @override
  String get supportReportSubtitle => '错误、账户或付款问题';

  @override
  String get supportCategoryLabelField => '类别';

  @override
  String get supportCategoryBug => '错误';

  @override
  String get supportCategoryAccount => '账户';

  @override
  String get supportCategoryPayment => '付款问题';

  @override
  String get supportCategoryOther => '其他';

  @override
  String get supportDescriptionLabel => '描述';

  @override
  String get supportDescriptionHint => '请描述发生了什么…';

  @override
  String get supportSubmit => '提交';

  @override
  String get supportSubmitted => '谢谢 — 我们已收到';

  @override
  String get supportLoginRequired => '请登录后报告问题';

  @override
  String get supportContactHint => '支持邮箱：eeshbaev@outlook.com';

  @override
  String get supportMailtoFailed => '无法打开邮件应用';

  @override
  String get feedbackTitle => '发送反馈';

  @override
  String get feedbackSubtitle => '帮助我们改进 YordamBor';

  @override
  String get feedbackMessageLabel => '您的反馈';

  @override
  String get feedbackMessageHint => '有什么可以改进？';

  @override
  String get feedbackSubmit => '发送';

  @override
  String get feedbackThanks => '感谢您的反馈';

  @override
  String get feedbackOpenFromSheet => '请通过帮助与支持发送反馈。';

  @override
  String get appReviewTitle => '喜欢 YordamBor 吗？';

  @override
  String get appReviewSubtitle => '您的评分帮助其他人找到可信的服务者。';

  @override
  String get appReviewYes => '喜欢';

  @override
  String get appReviewNo => '不太喜欢';

  @override
  String get appReviewLater => '以后再说';

  @override
  String get providerProgressTitle => '您的进度';

  @override
  String get providerProgressSubtitle => '逐步建立声誉';

  @override
  String get providerTierNew => '新手';

  @override
  String get providerTierActive => '活跃';

  @override
  String get providerTierTrusted => '可信';

  @override
  String get providerTierTop => '顶级';

  @override
  String providerJobsRating(int jobs, String rating) {
    return '$jobs 单 · $rating★';
  }

  @override
  String providerNextMilestone(int count, String tier) {
    return '还需 $count 单 → $tier';
  }

  @override
  String get providerTipsTitle => '下一步';

  @override
  String get progressTipAddCertificate => '添加证书建立信任';

  @override
  String get progressTipSetAvailability => '设置可用时间';

  @override
  String get progressTipReplyReviews => '回复客户评价';

  @override
  String get progressTipAddPortfolio => '添加更多作品集照片';

  @override
  String get progressTipSetPricing => '设置固定或小时价格';

  @override
  String get progressTipRepeatClients => '请满意客户再次预约';

  @override
  String get achievementsTitle => '成就';

  @override
  String get achievementsEmptySub => '暂无成就。完成订单并完善资料即可获得徽章。';

  @override
  String get achievementFirstXizmat => '首个服务';

  @override
  String get achievementFirstDeal => '首单完成';

  @override
  String get achievementJobs5 => '5 单完成';

  @override
  String get achievementJobs10 => '10 单完成';

  @override
  String get achievementJobs25 => '25 单完成';

  @override
  String get achievementFirstFiveStar => '首个 5★';

  @override
  String get achievementCertificate => '已上传证书';

  @override
  String get achievementRepeatClient => '忠实客户';

  @override
  String get achievementBodyFirstXizmat => '您发布了第一个服务。';

  @override
  String get achievementBodyFirstDeal => '首单完成，继续加油！';

  @override
  String get achievementBodyJobs5 => '五单完成 — 客户开始注意到您。';

  @override
  String get achievementBodyJobs10 => '十单 — 声誉在建立。';

  @override
  String get achievementBodyJobs25 => '二十五单 — 顶级之路。';

  @override
  String get achievementBodyFirstFiveStar => '客户给了 5 星！';

  @override
  String get achievementBodyCertificate => '证书已在资料中显示。';

  @override
  String get achievementBodyRepeatClient => '同一客户预约 3 次以上。';

  @override
  String get actionContinue => '继续';

  @override
  String get guidesTitle => '经营建议';

  @override
  String get guidesSubtitle => '逐步发展您的服务';

  @override
  String get guideXizmatConvertsTitle => '高转化 listing';

  @override
  String get guidePricingTitle => '定价：固定或按小时';

  @override
  String get guideRepeatClientsTitle => '获得回头客';

  @override
  String get guideCertificatesTitle => '证书与信任';

  @override
  String get guideReviewRepliesTitle => '专业回复评价';

  @override
  String get guideXizmatConvertsBody => '清晰标题、真实照片、子类别、价格或面议、可用时间。';

  @override
  String get guidePricingBody => '固定价适合明确工作，按小时适合清洁和辅导。';

  @override
  String get guideRepeatClientsBody => '做好工作，完成后请客户使用再次预约。';

  @override
  String get guideCertificatesBody => '上传证书供客户查看。YordamBor 不验证文件。';

  @override
  String get guideReviewRepliesBody => '礼貌回复每条评价。';

  @override
  String get safetyPaymentsBanner => '请按约定付款。YordamBor 不处理资金，不对平台外付款负责。';

  @override
  String get settingsSafety => '安全与付款';

  @override
  String get legalSafetyTitle => '安全与付款';

  @override
  String get legalSafetyBody =>
      'YordamBor 连接客户与服务者，不提供服务、不保管资金。\n\n付款\n\n双方直接付款。勿向陌生人预付全款。YordamBor 不对欺诈负责。\n\n您的责任\n\n自行核实评价与证书。\n\n举报\n\n滥用请用应用内举报。技术问题请用帮助与支持。';
}
