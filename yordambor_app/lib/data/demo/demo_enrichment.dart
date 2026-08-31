import 'package:yordambor/data/demo/demo_user_profiles.dart';
import 'package:yordambor/domain/entities/xizmat_availability_mode.dart';
import 'package:yordambor/domain/entities/xizmat_feed_item.dart';
import 'package:yordambor/domain/entities/xizmat_pricing_model.dart';
import 'package:yordambor/domain/entities/yordam_kerak_post.dart';

/// Realistic pricing, availability, contact, and portfolio metadata for demo listings.
abstract final class DemoEnrichment {
  static XizmatFeedItem enrichXizmat(
    XizmatFeedItem item, {
    String? ownerId,
  }) {
    final meta = _xizmatMeta[item.id];
    final profile = ownerId != null ? DemoUserProfiles.byId(ownerId) : null;
    final showPhone = profile?.hasVisiblePhone ?? false;

    return XizmatFeedItem(
      id: item.id,
      name: item.name,
      categoryLabel: item.categoryLabel,
      subcategoryLabel: item.subcategoryLabel,
      categoryId: item.categoryId,
      subcategoryId: item.subcategoryId,
      heroImageUrl: item.heroImageUrl,
      portfolioImageUrls:
          meta?.portfolioImageUrls ?? item.portfolioImageUrls,
      rating: item.rating,
      completedCount: item.completedCount,
      isDemo: item.isDemo,
      description: item.description,
      providerType: item.providerType,
      ownerId: item.ownerId,
      ownerName: item.ownerName,
      ownerAvatarUrl: profile?.avatarUrl ?? item.ownerAvatarUrl,
      contactPhone: showPhone ? profile!.phone : item.contactPhone,
      showContactPhone: showPhone || item.showContactPhone,
      showProfile: item.showProfile,
      pricingModel: meta?.pricingModel ?? item.pricingModel,
      basePrice: meta?.basePrice ?? item.basePrice,
      currency: item.currency,
      minDurationMinutes: meta?.minDurationMinutes ?? item.minDurationMinutes,
      availabilityVisible:
          meta?.availabilityVisible ?? item.availabilityVisible,
      availabilityMode: meta?.availabilityMode ?? item.availabilityMode,
      availabilityFrom: item.availabilityFrom,
      availabilityUntil: item.availabilityUntil,
      showServicePromise:
          meta?.showServicePromise ?? item.showServicePromise,
      servicePromise: meta?.servicePromise ?? item.servicePromise,
      serviceCity: item.serviceCity,
    );
  }

  static YordamKerakFeedItem enrichYordamKerakPost(
    YordamKerakFeedItem item, {
    required String authorId,
  }) {
    final profile = DemoUserProfiles.byId(authorId);
    final showPhone = profile?.hasVisiblePhone ?? false;

    return YordamKerakFeedItem(
      id: item.id,
      title: item.title,
      categoryLabel: item.categoryLabel,
      subcategoryLabel: item.subcategoryLabel,
      categoryId: item.categoryId,
      subcategoryId: item.subcategoryId,
      authorName: item.authorName,
      message: item.message,
      price: item.price,
      currency: item.currency,
      startDate: item.startDate,
      durationMinutes: item.durationMinutes,
      seekingProviderType: item.seekingProviderType,
      isDemo: item.isDemo,
      authorId: authorId,
      contactPhone: showPhone ? profile!.phone : item.contactPhone,
      showContactPhone: showPhone || item.showContactPhone,
      showProfile: item.showProfile,
    );
  }
}

final class _XizmatMeta {
  const _XizmatMeta({
    this.pricingModel,
    this.basePrice,
    this.minDurationMinutes,
    this.availabilityVisible = false,
    this.availabilityMode,
    this.showServicePromise = false,
    this.servicePromise,
    this.portfolioImageUrls,
  });

  final XizmatPricingModel? pricingModel;
  final double? basePrice;
  final int? minDurationMinutes;
  final bool availabilityVisible;
  final XizmatAvailabilityMode? availabilityMode;
  final bool showServicePromise;
  final String? servicePromise;
  final List<String>? portfolioImageUrls;
}

const _illustrator = 'assets/demo/illustrator.jpg';
const _production = 'assets/demo/production.jpg';
const _blogger = 'assets/demo/blogger.jpg';
const _barbershop = 'assets/demo/barbershop.jpg';
const _vet = 'assets/demo/vet_clinic.jpg';
const _carpet = 'assets/demo/carpet_cleaning.jpg';
const _interiorRenovation = 'assets/demo/interior_renovation.jpg';
const _wasteRemoval = 'assets/demo/waste_removal.jpg';
const _asalTovuq = 'assets/demo/asal_tovuq.jpg';
const _asalBaliq = 'assets/demo/asal_baliq.jpg';
const _ochiqSahna = 'assets/demo/ochiq_sahna_dining.jpg';
const _ochiqSahnaStage = 'assets/demo/ochiq_sahna_stage.jpg';
const _kinopark = 'assets/demo/kinopark.jpg';
const _kinoparkNight = 'assets/demo/kinopark_night.jpg';
const _musicSchool = 'assets/demo/music_school.jpg';
const _guitarLesson = 'assets/demo/guitar_lesson.jpg';
const _bellaPasta = 'assets/demo/bella_pasta.jpg';
const _bellaPizza = 'assets/demo/bella_pizza.jpg';

const _xizmatMeta = <String, _XizmatMeta>{
  'demo-sanjar-plumber': _XizmatMeta(
    pricingModel: XizmatPricingModel.hourly,
    basePrice: 120000,
    minDurationMinutes: 60,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    showServicePromise: true,
    servicePromise:
        'Chiqishdan oldin narxni aytaman — yashirin to\'lov yo\'q.',
  ),
  'demo-malika-cleaning': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 180000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    showServicePromise: true,
    servicePromise: 'O\'z vositalarim bilan kelaman, kimyoviy hid qoldirmayman.',
  ),
  'demo-aziz-electric': _XizmatMeta(
    pricingModel: XizmatPricingModel.hourly,
    basePrice: 100000,
    minDurationMinutes: 60,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.busy,
    showServicePromise: true,
    servicePromise: 'Xavfsizlik qoidalariga qat\'iy rioya qilaman.',
  ),
  'demo-english-tutor': _XizmatMeta(
    pricingModel: XizmatPricingModel.hourly,
    basePrice: 90000,
    minDurationMinutes: 60,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
  ),
  'demo-web-studio': _XizmatMeta(
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.callMe,
    showServicePromise: true,
    servicePromise: 'Texnik vazifa va muddatni shartnomada aniq yozamiz.',
  ),
  'demo-nail-specialist': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 130000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
  ),
  'demo-dental-clinic': _XizmatMeta(
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.callMe,
    showServicePromise: true,
    servicePromise: 'Birinchi konsultatsiya bepul.',
  ),
  'demo-eye-clinic': _XizmatMeta(
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.callMe,
  ),
  'demo-business-consultant': _XizmatMeta(
    pricingModel: XizmatPricingModel.hourly,
    basePrice: 250000,
    minDurationMinutes: 60,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
  ),
  'demo-financial-advisor': _XizmatMeta(
    pricingModel: XizmatPricingModel.hourly,
    basePrice: 200000,
    minDurationMinutes: 60,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
  ),
  'demo-elderly-care': _XizmatMeta(
    pricingModel: XizmatPricingModel.hourly,
    basePrice: 45000,
    minDurationMinutes: 60,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    showServicePromise: true,
    servicePromise: 'Tajriba va sabr bilan ishlayman.',
  ),
  'demo-kindergarten': _XizmatMeta(
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.callMe,
  ),
  'demo-blogger': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 600000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
  ),
  'demo-ad-agency': _XizmatMeta(
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.callMe,
    showServicePromise: true,
    servicePromise: 'Hisobot va natijalarni haftalik taqdim etamiz.',
  ),
  'demo-production-studio': _XizmatMeta(
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.busy,
  ),
  'demo-translator': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 90000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
  ),
  'demo-visa-help': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 550000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.callMe,
  ),
  'demo-fitness-club': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 350000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
  ),
  'demo-swimming-pool': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 280000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
  ),
  'demo-transport-repair': _XizmatMeta(
    pricingModel: XizmatPricingModel.hourly,
    basePrice: 85000,
    minDurationMinutes: 60,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    showServicePromise: true,
    servicePromise:
        'Diagnostika bepul — ta\'mir kerak bo\'lmasa, to\'lov talab qilinmaydi.',
  ),
  'demo-saloma-massage': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 280000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.callMe,
    showServicePromise: true,
    servicePromise: 'Сертификат и стаж каждого мастера — на стойке.',
  ),
  'demo-inkor-law': _XizmatMeta(
    pricingModel: XizmatPricingModel.hourly,
    basePrice: 500000,
    minDurationMinutes: 60,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.callMe,
    showServicePromise: true,
    servicePromise: 'Birinchi 30 daqiqa maslahat bepul.',
  ),
  'demo-yondashuv-law': _XizmatMeta(
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.callMe,
    showServicePromise: true,
    servicePromise: 'Maxfiylik kafolati — oilaviy masalalar yopiq yuritiladi.',
  ),
  'demo-kontrakto-translation': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 75000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    showServicePromise: true,
    servicePromise: 'Notarial tasdiqlash 1–2 ish kuni ichida.',
  ),
  'demo-import-export': _XizmatMeta(
    pricingModel: XizmatPricingModel.hourly,
    basePrice: 300000,
    minDurationMinutes: 60,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
  ),
  'demo-tax-consultant': _XizmatMeta(
    pricingModel: XizmatPricingModel.hourly,
    basePrice: 180000,
    minDurationMinutes: 60,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    showServicePromise: true,
    servicePromise: 'Deklaratsiya topshirishdan oldin tekshiruv o\'tkazaman.',
  ),
  'demo-stylist-sabina': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 350000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
  ),
  'demo-brobarber': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 80000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    portfolioImageUrls: [_barbershop],
    showServicePromise: true,
    servicePromise: 'Navbatni Telegram-bot orqali olish mumkin.',
  ),
  'demo-vetcare': _XizmatMeta(
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.callMe,
    portfolioImageUrls: [_vet],
    showServicePromise: true,
    servicePromise: 'Favqulodda chaqiruv — kechayu kunduz javob beramiz.',
  ),
  'demo-gilamchi': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 150000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    portfolioImageUrls: [_carpet],
    showServicePromise: true,
    servicePromise:
        'Natijadan qoniqmasangiz, qayta tozalash bepul.',
  ),
  'demo-fitness-timur': _XizmatMeta(
    pricingModel: XizmatPricingModel.hourly,
    basePrice: 220000,
    minDurationMinutes: 60,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    showServicePromise: true,
    servicePromise:
        'План питания обновляю каждую неделю по вашему прогрессу.',
  ),
  'demo-illustrator-aziza': _XizmatMeta(
    pricingModel: XizmatPricingModel.negotiable,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    portfolioImageUrls: [_illustrator, _production, _blogger],
    showServicePromise: true,
    servicePromise:
        'Eskizni tasdiqlagandan keyin yakuniy ishni topshiraman.',
  ),
  'demo-archstroy-design': _XizmatMeta(
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.callMe,
    portfolioImageUrls: [_interiorRenovation, _production],
    showServicePromise: true,
    servicePromise:
        'Смету и сроки фиксируем в договоре — без скрытых доплат.',
  ),
  'demo-chiqindi-out': _XizmatMeta(
    pricingModel: XizmatPricingModel.negotiable,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    portfolioImageUrls: [_wasteRemoval],
    showServicePromise: true,
    servicePromise:
        'Погрузка включена. Выезд в день обращения — если машина свободна.',
  ),
  'demo-asal-tovuqchalar': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 38000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    portfolioImageUrls: [_asalTovuq, _asalBaliq],
    showServicePromise: true,
    servicePromise:
        'Asal sous — bizning maxsus retsept. Buyurtmalar 24/7 qabul qilinamiz.',
  ),
  'demo-ochiq-sahna': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 80000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    portfolioImageUrls: [_ochiqSahna],
    showServicePromise: true,
    servicePromise: 'Taom va spektakl bir joyda — stol band qiling',
  ),
  'demo-kinopark': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 45000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    portfolioImageUrls: [_kinopark],
    showServicePromise: true,
    servicePromise: 'Кино под звёздами — сеансы каждый вечер',
  ),
  'demo-musiqachi-maktabi': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 350000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.callMe,
    portfolioImageUrls: [_musicSchool],
    showServicePromise: true,
    servicePromise: 'Первый пробный урок бесплатно — запишитесь',
  ),
  'demo-bella-pasta': _XizmatMeta(
    pricingModel: XizmatPricingModel.fixed,
    basePrice: 155000,
    availabilityVisible: true,
    availabilityMode: XizmatAvailabilityMode.availableNow,
    portfolioImageUrls: [_bellaPasta],
    showServicePromise: true,
    servicePromise: 'Пицца и паста от итальянского шефа — недавно открылись',
  ),
};
