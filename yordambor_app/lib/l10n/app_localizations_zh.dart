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
  String get tabCalendar => '日历';

  @override
  String get calendarGuestSubtitle => '登录后可查看日程并标记空闲/忙碌。';

  @override
  String get calendarProviderHint => '点击日历中的日期，然后在下方标记空闲或忙碌。';

  @override
  String get calendarClientHint => '预约和提醒会显示在日历上。点击日期查看详情。';

  @override
  String get calendarLegendAvailable => '空闲';

  @override
  String get calendarLegendBusy => '忙碌';

  @override
  String get calendarLegendAppointment => '预约';

  @override
  String get calendarMarkAvailable => '已标记：空闲 — 点击更改';

  @override
  String get calendarMarkBusy => '已标记：忙碌 — 点击更改';

  @override
  String get calendarMarkUnset => '标记日期：空闲 / 忙碌';

  @override
  String get calendarNoEventsDay => '当天没有预约。';

  @override
  String get calendarWeekdayMon => '一';

  @override
  String get calendarWeekdayTue => '二';

  @override
  String get calendarWeekdayWed => '三';

  @override
  String get calendarWeekdayThu => '四';

  @override
  String get calendarWeekdayFri => '五';

  @override
  String get calendarWeekdaySat => '六';

  @override
  String get calendarWeekdaySun => '日';

  @override
  String get tabFavorites => '收藏';

  @override
  String get tabBusiness => '商务';

  @override
  String get businessTabServices => '服务';

  @override
  String get businessTabTools => '工具';

  @override
  String get businessToolsSubtitle => '客户簿、收据、收入及其他服务商工具。';

  @override
  String get myXizmatlarGuestSubtitle => '登录后即可管理服务与工具。';

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
  String get filterCity => '城市';

  @override
  String get filterAllCities => '全部城市';

  @override
  String get filterCityHint => '您需要在哪个城市？';

  @override
  String get filterAllCitiesHint => '所有城市的服务';

  @override
  String get xizmatServiceCityRequired => '请选择服务城市';

  @override
  String get serviceCityToshkent => '塔什干';

  @override
  String get serviceCityToshkentViloyati => '塔什干州';

  @override
  String get serviceCitySamarqand => '撒马尔罕';

  @override
  String get serviceCityBuxoro => '布哈拉';

  @override
  String get serviceCityNukus => '努库斯';

  @override
  String get serviceCityNamangan => '纳曼干';

  @override
  String get serviceCityAndijon => '安集延';

  @override
  String get serviceCityFargona => '费尔干纳';

  @override
  String get serviceCityQarshi => '卡尔希';

  @override
  String get serviceCityUrganch => '乌尔根奇';

  @override
  String get serviceCityTermiz => '铁尔梅兹';

  @override
  String get serviceCityJizzax => '吉扎克';

  @override
  String get serviceCityNavoiy => '纳沃伊';

  @override
  String get serviceCityQoqon => '浩罕';

  @override
  String get serviceCityGuliston => '古利斯坦';

  @override
  String get serviceCityBoshqa => '其他';

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
  String get invalidPhone => '请输入有效的电话号码（+998…）';

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
  String get languageUz => 'Oʻzbek';

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
  String get kelishuvMessageHint => '写消息……';

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
  String get profileMargin => '利润';

  @override
  String get profileMarginSub => '成本与利润';

  @override
  String get profilePaymentReceipt => '付款收据';

  @override
  String get profilePaymentReceiptSub => '为您的服务生成 PDF 收据';

  @override
  String get receiptTitle => '付款收据';

  @override
  String get receiptNew => '新建收据';

  @override
  String get receiptEmptyTitle => '暂无收据';

  @override
  String get receiptEmptySubtitle => '为客户创建付款收据并以 PDF 分享。';

  @override
  String get receiptDocumentTitle => '付款收据';

  @override
  String get receiptNumber => '编号';

  @override
  String get receiptDate => '日期';

  @override
  String get receiptSeller => '出具方';

  @override
  String get receiptBuyer => '客户';

  @override
  String get receiptBuyerName => '客户姓名';

  @override
  String get receiptBuyerPhone => '客户电话';

  @override
  String get receiptPickClient => '从客户簿选择';

  @override
  String get receiptXizmat => '服务';

  @override
  String get receiptLines => '明细';

  @override
  String get receiptLineTitle => '说明';

  @override
  String get receiptQuantity => '数量';

  @override
  String get receiptUnitPrice => '单价';

  @override
  String get receiptLineTotal => '金额';

  @override
  String get receiptAddLine => '添加一行';

  @override
  String get receiptDiscount => '折扣';

  @override
  String get receiptTaxEnable => '添加税费';

  @override
  String get receiptTaxRate => '税率 (%)';

  @override
  String get receiptTaxLabel => '税费名称';

  @override
  String get receiptTaxDisclaimer => '税率由您自行选择。YordamBor 不提供税务建议。';

  @override
  String get receiptSubtotal => '小计';

  @override
  String get receiptTotal => '合计';

  @override
  String get receiptNote => '备注';

  @override
  String get receiptDueDate => '付款期限';

  @override
  String get receiptCurrency => '货币';

  @override
  String get receiptCurrencyUzs => 'UZS';

  @override
  String get receiptCurrencyUsd => 'USD';

  @override
  String get receiptSharePdf => '分享 PDF';

  @override
  String get receiptPreview => '预览 PDF';

  @override
  String get receiptSaved => '收据已保存';

  @override
  String get receiptValidationBuyer => '请输入客户姓名';

  @override
  String get receiptValidationXizmat => '请选择服务';

  @override
  String get receiptValidationLines => '请至少添加一行并填写价格';

  @override
  String get receiptFooterBranding => '由 YordamBor 创建';

  @override
  String get receiptDeleteConfirm => '删除此收据？';

  @override
  String get receiptTaxPresetCustom => '自定义';

  @override
  String get marginTitle => '利润';

  @override
  String get marginUnitsTitle => '单位库';

  @override
  String get marginUnitsSubtitle => '可复用的单位及成本，便于快速计算';

  @override
  String get marginOpenUnits => '单位库';

  @override
  String get marginAddUnit => '添加单位';

  @override
  String get marginEditUnit => '编辑单位';

  @override
  String get marginUnitName => '单位名称';

  @override
  String get marginUnitCost => '单位成本 (UZS)';

  @override
  String get marginUnitBasis => '成本基准（可选）';

  @override
  String get marginUnitBasisHint => '例如：每小时、每公斤、每件';

  @override
  String get marginUnitsEmptyTitle => '暂无单位';

  @override
  String get marginUnitsEmptySub => '保存常用单位——人工、材料、包装等及成本。';

  @override
  String get marginAddProduct => '添加产品';

  @override
  String get marginEditProduct => '编辑产品';

  @override
  String get marginProductName => '产品名称';

  @override
  String get marginSalePrice => '售价 (UZS)';

  @override
  String get marginCostTotal => '总成本';

  @override
  String get marginProfit => '利润';

  @override
  String get marginMarginPercent => '利润率';

  @override
  String get marginCostBreakdown => '成本明细';

  @override
  String get marginAddLine => '添加单位行';

  @override
  String get marginEditLine => '编辑单位行';

  @override
  String get marginLineName => '单位 / 项目名称';

  @override
  String get marginLineQuantity => '数量';

  @override
  String get marginLineUnitCost => '单位成本 (UZS)';

  @override
  String get marginLineQuantityLabel => '数量标签（可选）';

  @override
  String get marginLineQuantityLabelHint => '例如：小时、kg、件';

  @override
  String get marginSelectUnit => '从单位库选择';

  @override
  String get marginCustomLine => '自定义行';

  @override
  String get marginProductsEmptyTitle => '暂无产品';

  @override
  String get marginProductsEmptySub => '添加产品或服务以查看成本、利润和利润率。';

  @override
  String get marginNameRequired => '请输入名称';

  @override
  String get marginPriceRequired => '请输入售价';

  @override
  String get marginCostRequired => '请输入成本';

  @override
  String get marginQuantityRequired => '请输入数量';

  @override
  String get marginAvgMargin => '平均利润率';

  @override
  String get marginPerProduct => '每个产品';

  @override
  String get marginDeleteProduct => '删除产品';

  @override
  String get marginDeleteUnit => '删除单位';

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
  String get notificationSubsectorNewService => '您关注的子类有新服务';

  @override
  String get notificationSubsectorDiscount => '您关注的子类降价了';

  @override
  String get notificationSubsectorHelpPost => '您关注的子类有人需要帮助';

  @override
  String get notificationAlertsTitle => '子类提醒';

  @override
  String get notificationAlertsSubtitle => '有新服务、降价或求助帖子时立即通知您。';

  @override
  String get notificationAlertsAdd => '添加提醒';

  @override
  String get notificationAlertsEmpty => '暂无子类提醒';

  @override
  String get notificationAlertNewService => '新服务';

  @override
  String get notificationAlertDiscount => '降价';

  @override
  String get notificationAlertHelpPost => '求助帖（需要帮助）';

  @override
  String get notificationAlertSeekerHint => '当您正在找服务时';

  @override
  String get notificationAlertProviderHint => '当您可以作为服务商提供帮助时';

  @override
  String get notificationAlertsSaved => '提醒已保存';

  @override
  String get notificationAlertsRemoved => '提醒已删除';

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
  String get demoKelishuvSimulatedNote => '演示交易不会保存到服务器。演示服务方显示为已收到您的报价。';

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
  String get xizmatServiceCityHint => '请选择服务城市';

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
  String get xizmatAvailabilityCallMe => '需预约';

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

  @override
  String get greetingMorning => '早上好';

  @override
  String get greetingAfternoon => '下午好';

  @override
  String get greetingEvening => '晚上好';

  @override
  String get greetingNight => '你好';

  @override
  String get greetingWelcomeBack => '欢迎回来';

  @override
  String get greetingWelcomeNew => '欢迎';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting，$name';
  }

  @override
  String homeFactAwaitingReply(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 笔交易等待您的回复',
    );
    return '$_temp0';
  }

  @override
  String homeFactInProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 笔交易进行中',
    );
    return '$_temp0';
  }

  @override
  String get homeFactNewMember => '先寻求帮助或发布服务吧';

  @override
  String get continueYourTurn => '轮到您了';

  @override
  String get continueReplyToDeal => '查看条款并回复';

  @override
  String get continueInProgress => '进行中';

  @override
  String get continueMarkDone => '完成后请确认';

  @override
  String get continueDraftTitle => '未完成的需求';

  @override
  String get continueDraftUntitled => '未命名的需求';

  @override
  String get continueDraftHint => '从上次停下的地方继续';

  @override
  String get draftDelete => '删除草稿';

  @override
  String get draftDeleted => '草稿已删除';

  @override
  String get draftRestored => '已恢复草稿';

  @override
  String get draftStartOver => '重新开始';

  @override
  String get actionUndo => '撤销';

  @override
  String get quickAskHelp => '寻求帮助';

  @override
  String get quickOfferService => '提供服务';

  @override
  String get feedEndTitle => '已经到底了';

  @override
  String get feedEndAskPrompt => '没找到合适的人？';

  @override
  String get feedEndJobsHint => '新需求会最先出现在这里';

  @override
  String get whatsNewTitle => '新功能';

  @override
  String get whatsNewLookTitle => '更清爽的新外观';

  @override
  String get whatsNewLookBody => '新的字体、颜色和图标，更易阅读。';

  @override
  String get whatsNewNextStepTitle => '主页显示您的下一步';

  @override
  String get whatsNewNextStepBody => '等待您处理的交易和未完成的需求现在优先显示。';

  @override
  String get whatsNewDraftsTitle => '草稿自动保存';

  @override
  String get whatsNewDraftsBody => '需求写到一半，也能稍后继续。';

  @override
  String get whatsNewDone => '知道了';

  @override
  String get xizmatCardNew => '新入驻';

  @override
  String get favoriteAdd => '收藏';

  @override
  String get favoriteRemove => '取消收藏';

  @override
  String statJobsDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已完成的工作',
    );
    return '$_temp0';
  }

  @override
  String get statRating => '评分';

  @override
  String get dealBondYou => '您';

  @override
  String get dealBondYourTurn => '轮到您：查看条款并接受';

  @override
  String dealBondWaiting(String name) {
    return '等待 $name 回复';
  }

  @override
  String get dealBondAgreed => '已达成 · 工作进行中';

  @override
  String get dealBondDone => '已完成 · 感谢双方';

  @override
  String get dealBondClosed => '此交易已关闭';

  @override
  String get undoDeleted => '已删除';

  @override
  String get savedRemoved => '已取消收藏';

  @override
  String get yordamKerakTitleRequired => '请写一个简短的标题';

  @override
  String get yordamKerakMessageRequired => '请描述您的需求';

  @override
  String get stateErrorTitle => '加载失败';

  @override
  String get stateErrorBody => '请检查网络后重试。';

  @override
  String get stateOfflineBanner => '无网络连接，正在显示已保存的内容。';

  @override
  String get disabledHintServiceName => '请输入至少 2 个字的名称';

  @override
  String get disabledHintServiceCity => '请选择您服务的城市';

  @override
  String get disabledHintServicePhoto => '请至少添加一张照片';

  @override
  String get disabledHintPickSubcategory => '请先选择细分领域';

  @override
  String get disabledHintOneAlert => '请至少开启一项提醒';

  @override
  String get milestoneOverline => '新的里程碑';

  @override
  String get milestoneDismiss => '关闭';

  @override
  String get notificationsTooltip => '通知';

  @override
  String a11yRating(String rating) {
    return '评分 $rating';
  }

  @override
  String get a11yNewProvider => 'YordamBor 新入驻';

  @override
  String get filtersClear => '清除筛选';

  @override
  String get actionClose => '关闭';

  @override
  String get actionMore => '更多操作';

  @override
  String get actionSend => '发送';

  @override
  String get actionPreviousMonth => '上个月';

  @override
  String get actionNextMonth => '下个月';

  @override
  String get a11yShowPassword => '显示密码';

  @override
  String get a11yHidePassword => '隐藏密码';

  @override
  String a11yStarRating(int count) {
    return '$count 星';
  }

  @override
  String get detailPaneEmptyTitle => '选择一张卡片';

  @override
  String get detailPaneEmptyBody => '它会在列表旁边的这里打开。';

  @override
  String get taklifAskHint => '您需要什么帮助？';

  @override
  String get taklifAskSubtitle => '描述需要做的事，也可以写上预算。双方同意后即可开始。';

  @override
  String get taklifAskSubmit => '发送请求';

  @override
  String dealOfferAutoCancel(int days) {
    return '如果 $days 天内没有回复，将自动取消';
  }

  @override
  String dealOfferReplyWithin(int days) {
    return '请在 $days 天内回复，否则报价将自动取消';
  }

  @override
  String get dealAcceptedRow => '已接受条款';

  @override
  String get dealCompletedRow => '已确认完成';

  @override
  String get dealWithdrawOffer => '撤回报价';

  @override
  String get dealWithdrawTitle => '撤回您的报价？';

  @override
  String get dealWithdrawBody => '该交易将被取消。之后可以发送新的报价。';

  @override
  String get dealChatOpensOnReply => '对方回复后即可开始沟通。';

  @override
  String get dealRejectTitle => '拒绝此报价？';

  @override
  String get dealRejectBody => '如果愿意，可以写下原因——它会保留在交易中。';

  @override
  String get dealRejectCommentLabel => '备注（可选）';

  @override
  String get dealSendNewOffer => '发送新报价';

  @override
  String get dealClosedNewOfferHint => '仍然需要这项服务？发送新报价，重新开始沟通。';

  @override
  String get archiveTabNeeded => '需要过帮助';

  @override
  String get archiveTabProvided => '提供过帮助';

  @override
  String get archiveNeededEmpty => '您请求帮助的交易会显示在这里。';

  @override
  String get archiveProvidedEmpty => '您帮助他人的交易会显示在这里。';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '已解锁 $unlocked/$total';
  }

  @override
  String get achievementsShow => '查看全部';

  @override
  String get achievementsHide => '收起';

  @override
  String get yordamKerakCityRequired => '请选择城市';

  @override
  String get taklifContactTitle => '您的联系方式';

  @override
  String get taklifContactNote => '对方会在交易中看到这些信息，以便联系您。';

  @override
  String get taklifFirstNameLabel => '名字';

  @override
  String get taklifLastNameLabel => '姓氏';

  @override
  String get taklifFirstNameRequired => '请输入名字';

  @override
  String get taklifPhoneRequired => '请输入电话号码';

  @override
  String get taklifMessageOptionalLabel => '留言（可选）';

  @override
  String get dealContactTitle => '联系方式';

  @override
  String get dealContactSent => '您已分享联系方式';

  @override
  String get dealsSectionTitle => '您的交易';

  @override
  String get dealStateYourTurn => '协商中 · 轮到您';

  @override
  String get dealStateSent => '已发送 · 等待回复';

  @override
  String get dealStateInProgress => '已接受 · 进行中';

  @override
  String get dealStateAwaitingConfirm => '您已确认 · 等待对方确认';

  @override
  String get actionAdd => '添加';

  @override
  String get businessEarningsTitle => '本月收入';

  @override
  String get businessEarningsSee => '查看收入';

  @override
  String get businessStatWaitingLabel => '待您回复';

  @override
  String get businessNextStepsTitle => '获得更多客户';

  @override
  String businessNextStepsProgress(int done, int total) {
    return '$done/$total';
  }

  @override
  String get businessStepPhotos => '添加 3 张或更多照片';

  @override
  String get businessStepPhotosWhy => '有照片的服务更常被选择';

  @override
  String get businessStepPrice => '设置价格';

  @override
  String get businessStepPriceWhy => '价格清晰，成交前疑问更少';

  @override
  String get businessStepAvailability => '显示您的空闲时间';

  @override
  String get businessStepAvailabilityWhy => '客户更愿意联系能尽快上门的人';

  @override
  String get businessStepShare => '分享您的服务链接';

  @override
  String get businessStepShareWhy => '通过 Telegram 发送，让朋友推荐您';

  @override
  String get businessStartTitle => '把技能变成收入';

  @override
  String get businessStartStep1 => '描述服务和价格';

  @override
  String get businessStartStep2 => '添加照片和城市';

  @override
  String get businessStartStep3 => '接收请求并达成交易';

  @override
  String businessServicesCount(int count, int max) {
    return '我的服务 · $count/$max';
  }

  @override
  String xizmatLimitReached(int max) {
    return '最多可发布 $max 项服务。请编辑或删除一项后再添加。';
  }

  @override
  String get calendarStatusCaption => '您的状态 · 客户可见';

  @override
  String get calendarLegendNeedHelp => '我获得的帮助';

  @override
  String get calendarLegendGiveHelp => '我提供的帮助';

  @override
  String get calendarLegendPersonal => '个人';

  @override
  String get calendarHintMark => '点击日期，标记空闲或忙碌。如只占一天中的部分时间，请填写时段；否则视为整个工作日。';

  @override
  String get calendarHintClient => '这里是交易提醒：您获得的帮助和您提供的帮助。点击日期查看详情。';

  @override
  String get calendarDayNotMarked => '未标记';

  @override
  String get calendarWholeWorkingDay => '整个工作日';

  @override
  String get calendarAddHours => '添加时段';

  @override
  String get calendarRemoveHours => '删除此时段';

  @override
  String get calendarHoursFrom => '开始';

  @override
  String get calendarHoursTo => '结束';

  @override
  String get calendarDayEvents => '当天的提醒';

  @override
  String get workingHoursTitle => '工作时间';

  @override
  String get workingHoursHint => '客户会在您的服务中看到';

  @override
  String get workingHoursSheetHint => '您通常的工作日。默认 9:00–13:00 和 14:00–18:00。';

  @override
  String get workingHoursReset => '恢复为 9–13 和 14–18';

  @override
  String get workingHoursInvalid => '请检查时间：每段开始早于结束，且互不重叠。';

  @override
  String get workingHoursSaved => '工作时间已保存';

  @override
  String get xizmatOwnHoursTitle => '此服务单独的时间';

  @override
  String xizmatOwnHoursOff(String hours) {
    return '与个人资料相同：$hours';
  }

  @override
  String get xizmatHoursInCalendar => '工作时间在日历中修改。';

  @override
  String get xizmatHoursOpenCalendar => '打开日历';

  @override
  String get xizmatScheduleTitle => '工作时间与空闲情况';

  @override
  String get xizmatScheduleNextDays => '未来两周';

  @override
  String get xizmatTodayFree => '今天有空';

  @override
  String get xizmatTodayBusy => '今天忙碌';

  @override
  String xizmatTodayBusyAt(String hours) {
    return '今天忙碌：$hours';
  }

  @override
  String xizmatTodayFreeAt(String hours) {
    return '今天有空：$hours';
  }

  @override
  String get calendarNoRemindersDay => '当天没有提醒。';

  @override
  String get sampleTag => '示例';

  @override
  String get demoDealNote => '这是示例：交易不会发送给真实用户。';

  @override
  String get feedInviteProvidersTitle => '成为首批服务提供者';

  @override
  String get feedInviteProvidersBody => '添加您的服务，客户会最先看到它。';

  @override
  String get feedInviteAskTitle => '第一个发布求助';

  @override
  String get feedInviteAskBody => '写下您的需求，服务提供者会看到。';

  @override
  String get feedInviteProvidersAction => '添加您的服务';

  @override
  String get feedInviteAskAction => '描述您的需求';

  @override
  String get sampleFindProvider => '寻找服务提供者';

  @override
  String get sampleFindProviderHint => '这是示例。描述您的需求，真实的服务提供者会看到。';

  @override
  String get sampleAlertNewServices => '此领域有新的服务提供者时通知我';

  @override
  String get sampleRequestPosted => '求助已发布——服务提供者会看到。';

  @override
  String get sampleRequestTitle => '这是示例求助';

  @override
  String get sampleRequestBody => '真实的求助会出现在这里。开启通知，有人在此领域求助时我们会告诉您。';

  @override
  String get sampleAlertHelpPosts => '有新求助时通知我';

  @override
  String get sampleAlertOn => '已开启——此领域有新求助时会通知您。';

  @override
  String get foundingBadge => 'YordamBor 先行者';

  @override
  String get foundingBadgeNote => '首批服务提供者将获得“YordamBor 先行者”徽章。';

  @override
  String get inviteTitle => '邀请服务提供者';

  @override
  String get inviteBody => '认识好的电工、家教或沙龙吗？邀请他们：真实的服务提供者越多，客户就越多。';

  @override
  String get inviteShare => '分享邀请';

  @override
  String get invitePrepare => '为熟人准备服务';

  @override
  String get inviteMessage =>
      '加入 YordamBor：客户在这里找到乌兹别克斯坦各地的服务提供者。添加服务免费，首批服务提供者将获得“YordamBor 先行者”徽章。';

  @override
  String invitePersonalMessage(String name, String trade, String city) {
    return '$name，您好！我在使用 YordamBor，客户在这里找到服务提供者。添加您的服务“$trade”（$city）：免费，首批服务提供者将获得“YordamBor 先行者”徽章。';
  }

  @override
  String inviteOpenLink(String link) {
    return '打开开始：$link';
  }

  @override
  String inviteAppLink(String link) {
    return '应用：$link';
  }

  @override
  String get invitePrepareTitle => '为熟人准备的服务';

  @override
  String get invitePrepareBody =>
      '选择对方的领域和城市。对方会收到一个链接，打开已填好这些信息的“新服务”，并由本人发布。';

  @override
  String get invitePersonName => '对方姓名（可选）';

  @override
  String get invitePersonPhone => '对方电话（可选）';

  @override
  String get invitePickTrade => '领域';

  @override
  String get inviteSendWhatsApp => '通过 WhatsApp 发送';

  @override
  String get inviteSendSms => '通过短信发送';

  @override
  String get inviteSendOther => '其他应用';

  @override
  String get inviteNeedTradeCity => '请选择领域和城市';

  @override
  String get onbGoalTitle => '您来 YordamBor 是为了？';

  @override
  String get onbGoalNeedHelp => '我需要帮助';

  @override
  String get onbGoalNeedHelpSub => '寻找服务提供者或描述需求';

  @override
  String get onbGoalOffer => '我提供服务';

  @override
  String get onbGoalOfferSub => '获得客户并赚钱';

  @override
  String get onbGoalBoth => '两者都是';

  @override
  String get onbGoalBothSub => '我提供帮助，有时也需要帮助';

  @override
  String get onbCityTitle => '您所在的城市';

  @override
  String get onbCitySub => '为您显示附近的内容。';

  @override
  String get onbNext => '下一步';

  @override
  String get onbDone => '完成';

  @override
  String get onbSkip => '跳过';

  @override
  String onbStep(int current, int total) {
    return '第 $current 步，共 $total 步';
  }

  @override
  String get onbIntro1Title => '身边的服务';

  @override
  String get onbIntro1Body => '遍布乌兹别克斯坦的专业人士和机构。';

  @override
  String get onbIntro2Title => '需要帮助？发布需求';

  @override
  String get onbIntro2Body => '描述您的需求，服务提供者会主动联系您。';

  @override
  String get onbIntro3Title => '提供您的服务';

  @override
  String get onbIntro3Body => '以个人或机构身份发布，免费。';

  @override
  String get onbIntro4Title => '公平又安心';

  @override
  String get onbIntro4Body => '双方都同意后交易才开始。只有完成工作后才能评价。按约定付款。';

  @override
  String get onbTypeTitle => '您以什么身份工作？';

  @override
  String get onbTypeSub => '客户会在您的服务上看到这一点。之后可以更改。';

  @override
  String get onbTypeIndividualSub => '工匠、家教或自由职业者';

  @override
  String get onbTypeInstitutionSub => '公司、沙龙、诊所或培训中心';

  @override
  String onbReadyToOffer(String action) {
    return '准备好后，点击“$action”。';
  }

  @override
  String get inviteAction => '邀请您认识的服务提供者';

  @override
  String invitePersonalMessageNoName(String trade, String city) {
    return '您好！我在使用 YordamBor，客户在这里找到服务提供者。添加您的服务“$trade”（$city）：免费，首批服务提供者将获得“YordamBor 先行者”徽章。';
  }

  @override
  String get joinTitle => '您受邀加入 YordamBor';

  @override
  String get joinBody => '添加您的服务——完全免费。客户在这里按行业和城市寻找服务提供者。';

  @override
  String get joinLookAround => '先看看应用';

  @override
  String get onbStart => '开始使用';

  @override
  String get welcomeFindHelp => '寻找帮助';

  @override
  String get welcomeGiveHelp => '提供帮助';

  @override
  String get onbTileLawyer => '律师';

  @override
  String get onbTileBeauty => '美容';

  @override
  String get onbTileCatering => '餐饮服务';

  @override
  String get onbTileVet => '兽医';

  @override
  String get onbTileCleaning => '保洁';

  @override
  String get onbTileElectrician => '电工';

  @override
  String get onbTilePlumber => '水管工';

  @override
  String get onbTileDental => '牙科诊所';

  @override
  String onbMoreServices(int count) {
    return '以及 $count 多种其他服务';
  }

  @override
  String get onbIllRequestTitle => '厨房水龙头漏水';

  @override
  String get onbIllToday => '今天';

  @override
  String get onbIllNewOffers => '2 个新报价';

  @override
  String get onbIllName1 => 'Aziz';

  @override
  String get onbIllName2 => 'Dilnoza';

  @override
  String get onbIllOffer1 => '我今天18:00可以上门';

  @override
  String get onbIllOffer2 => '明天上午有空';

  @override
  String get onbIllNewRequest => '新需求';

  @override
  String get onbIllSocket => '更换插座';

  @override
  String get onbTileTutor => '家教';

  @override
  String get onbTileAuto => '汽车维修';

  @override
  String get searchTooltip => '搜索';

  @override
  String get searchHint => '姓名、机构或服务';

  @override
  String get searchPrompt => '输入服务者姓名、机构名称或服务，例如“水管工”。';

  @override
  String get searchNoResults => '未找到结果';

  @override
  String get searchNoResultsHint => '发布需求，服务提供者会主动联系您。';

  @override
  String get searchOffline => '无网络连接：仅显示手机上已有的内容。';

  @override
  String get onbTileRenovation => '装修';

  @override
  String get onbTileFitness => '健身';

  @override
  String get onbTileTranslator => '翻译';

  @override
  String get onbTileBarber => '理发师';

  @override
  String get onbTileMusic => '音乐课';

  @override
  String get onbTileStylist => '造型师';

  @override
  String get onbTileKindergarten => '幼儿园';

  @override
  String get onbIllTutorTitle => '英语与雅思';

  @override
  String get onbIllStylistRequest => '婚礼造型';

  @override
  String onbKindsChip(int count) {
    return '+$count 种服务';
  }

  @override
  String get onbIllDentalRequestTitle => '我牙疼';

  @override
  String get onbTileDentist => '牙医';

  @override
  String get onbIllDentalOffer1 => '今天16:00可以接诊';

  @override
  String get onbIllDentalOffer2 => '明天上午可以接诊';

  @override
  String get xizmatStatNoReviews => '暂无评价';

  @override
  String get xizmatStatPrice => '价格';

  @override
  String get xizmatStatPerHour => '每小时';

  @override
  String get xizmatStatNegotiable => '面议';

  @override
  String get xizmatPromiseOwnWords => '服务提供者自述';

  @override
  String get xizmatAboutTitle => '服务介绍';

  @override
  String get actionReadMore => '展开';

  @override
  String get actionReadLess => '收起';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条评价',
    );
    return '$_temp0';
  }

  @override
  String reviewsSeeAll(int count) {
    return '全部评价（$count）';
  }

  @override
  String get reviewsFilterAll => '全部';

  @override
  String get reviewsFilterEmpty => '暂无该评分的评价';

  @override
  String reviewsBarA11y(int stars, int count) {
    return '$stars 星：$count 条';
  }

  @override
  String get xizmatHowTitle => '如何进行';

  @override
  String get xizmatHowAsk => '发送请求';

  @override
  String get xizmatHowChat => '在应用内沟通';

  @override
  String get xizmatHowAgree => '达成约定';

  @override
  String providerMemberSince(String year) {
    return '$year 年加入';
  }

  @override
  String providerServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项服务',
    );
    return '$_temp0';
  }

  @override
  String get xizmatAboutHint => '您做什么、如何工作、向客户承诺什么';
}
