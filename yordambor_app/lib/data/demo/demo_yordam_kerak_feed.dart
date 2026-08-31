import 'package:yordambor/data/demo/demo_enrichment.dart';
import 'package:yordambor/domain/entities/yordam_kerak_post.dart';

/// Demo e'lonlar — haqiqiy O'zbekiston hayotidan olingan vaziyatlar.
abstract final class DemoYordamKerakFeed {
  static final _baseItems = [
    YordamKerakFeedItem(
      id: 'demo-job-elderly-care',
      title: '82 yoshli onamni qarab turish uchun ayol kerak',
      categoryLabel: 'Sog\'liq',
      subcategoryLabel: 'Uy hamshirasi',
      categoryId: 'health',
      subcategoryId: 'home_nurse',
      authorName: 'Sarvar',
      message:
          'Onamni yoshi 82, qarab otirishga ayol kere hamshiralik bilimlari bo\'lishi shart. '
          'Ovqat qilish, yuvintirish va boshqa.',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-female-driving-instructor',
      title: 'Ayolimga ayol haydovchi o\'qituvchi kerak',
      categoryLabel: 'Ta\'lim',
      subcategoryLabel: 'Haydovchilik o\'qituvchisi',
      categoryId: 'education',
      subcategoryId: 'other',
      authorName: 'Bobur',
      message:
          'Ayolimga ayol moshina orgatadigan kere, erkaklar bezovti qilmanglar.',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-web-designer',
      title: 'Komandaga web dizayner kerak',
      categoryLabel: 'Masofaviy ish va frilanser',
      subcategoryLabel: 'Frilanser dizayner',
      categoryId: 'remote_freelance',
      subcategoryId: 'freelance_designer',
      authorName: 'CodeLine Veb Studiya',
      message:
          'Komandaga web dizayner kere, yoshro, bilimi yaxshi va ish organaman dganidan.',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-laminat-yunusobod',
      title: 'Yunusobod yangi uylar — laminat yotqizish',
      categoryLabel: 'Uy ta\'miri',
      subcategoryLabel: 'Pol yopish (laminat, parket)',
      categoryId: 'home_repair',
      subcategoryId: 'flooring',
      authorName: 'Jamshid',
      message:
          '3 xonali kvartira, 68 m². Laminat o\'zimda bor, faqat usta va kesish kerak. '
          'Ertaga ertalab boshlash mumkin.',
      price: 2800000,
      currency: 'UZS',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-washing-machine',
      title: 'Samsung kir yuvish mashinasi ishlamayapti',
      categoryLabel: 'Uy ta\'miri',
      subcategoryLabel: 'Maishiy texnika ta\'miri',
      categoryId: 'home_repair',
      subcategoryId: 'appliance_repair',
      authorName: 'Nodira',
      message:
          'Mirzo Ulug\'bek, quyish vaqtida to\'xtab qoladi. Model WF8590. '
          'Uyga keladigan usta kerak, zavod kafolati tugagan.',
      price: 250000,
      currency: 'UZS',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-math-dtm',
      title: '9-sinf o\'g\'lim uchun matematika repetitori',
      categoryLabel: 'Ta\'lim',
      subcategoryLabel: 'Matematika repetitori',
      categoryId: 'education',
      subcategoryId: 'math_tutor',
      authorName: 'Bekzod',
      message:
          'DTM va maktab imtihoniga tayyorlov. Haftada 3 kun, kechki vaqt. '
          'Yashnobod yoki onlayn Zoom ham bo\'ladi.',
      price: 80000,
      currency: 'UZS',
      durationMinutes: 90,
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-move-sergeli',
      title: 'Chilonzordan Sergeliga ko\'chish yordami',
      categoryLabel: 'Transport',
      subcategoryLabel: 'Ko\'chishga yordam',
      categoryId: 'transport',
      subcategoryId: 'moving_help',
      authorName: 'Alisher',
      message:
          '2 xonali kvartira: divan, krovat, stol, kir yuvish mashinasi. '
          'Yuk mashinasi va 2 yukchi kerak, yakshanba kuni.',
      price: 900000,
      currency: 'UZS',
      startDate: DateTime(2026, 8, 24),
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-gate-welder',
      title: 'Hovli darvozasini payvand qilish kerak',
      categoryLabel: 'Uy ta\'miri',
      subcategoryLabel: 'Payvandchi',
      categoryId: 'home_repair',
      subcategoryId: 'welder',
      authorName: 'Sherzod',
      message:
          'Temir darvoza singan, qulflanmayapti. Olmaliq tomonda, material bor. '
          'Bir kun ichida bitirish mumkin bo\'lsa yaxshi.',
      price: 350000,
      currency: 'UZS',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-toy-osh',
      title: 'Farg\'onada to\'y oshxonasi — 200 kishi',
      categoryLabel: 'Ovqat va oshxona',
      subcategoryLabel: 'Tadbir uchun ovqat tayyorlash',
      categoryId: 'food_culinary',
      subcategoryId: 'event_cooking',
      authorName: 'Dilshod',
      message:
          'Osh, somsa va salat. 15-aprel, to\'y marosimi. Oshpazlar va idish-tovoq '
          'bilan keladigan jamoa kerak.',
      price: 18000000,
      currency: 'UZS',
      startDate: DateTime(2026, 4, 15),
      seekingProviderType: 'institution',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-russian-prep',
      title: '1-sinfga boradigan qizim uchun rus tili',
      categoryLabel: 'Ta\'lim',
      subcategoryLabel: 'Rus tili repetitori',
      categoryId: 'education',
      subcategoryId: 'russian_tutor',
      authorName: 'Ziyoda',
      message:
          'Maktabgacha rus tilida o\'qitadigan repetitor kerak. '
          'Dushanba–juma, 16:00 dan keyin, Sergeli tumani.',
      price: 70000,
      currency: 'UZS',
      durationMinutes: 60,
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-1c-accountant',
      title: 'YATT uchun 1C va soliq hisoboti',
      categoryLabel: 'Masofaviy va frilans',
      subcategoryLabel: 'Frilanser buxgalter',
      categoryId: 'remote_freelance',
      subcategoryId: 'freelance_accountant',
      authorName: 'Rustam',
      message:
          'Onlayn do\'kon ochdim, oylik hisobot va soliq deklaratsiyasi kerak. '
          '1C Bukhgalteriya tajribasi bo\'lishi shart.',
      price: 500000,
      currency: 'UZS',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-bathroom-tile',
      title: 'Hammom plitkasini almashtirish',
      categoryLabel: 'Uy ta\'miri',
      subcategoryLabel: 'Plitka yotqizuvchi',
      categoryId: 'home_repair',
      subcategoryId: 'tile_installer',
      authorName: 'Kamola',
      message:
          'Eski plitka yirtilgan, 6 m² hammom. Yangi plitka sotib olaman, '
          'eskiini olib tashlash va yotqizish kerak. Uchtepa tumani.',
      price: 3200000,
      currency: 'UZS',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-wedding-damas',
      title: 'To\'y uchun 3 ta Damas mikroavtobus',
      categoryLabel: 'Transport',
      subcategoryLabel: 'To\'y uchun transport',
      categoryId: 'transport',
      subcategoryId: 'wedding_transport',
      authorName: 'Aziz',
      message:
          'Nikoh 28-mart, Toshkent — Qibray yo\'nalishi. Kelin uyidan to\'y zaligacha '
          'mehmonlarni olib borish kerak. Bezak bilan.',
      price: 2400000,
      currency: 'UZS',
      startDate: DateTime(2026, 3, 28),
      seekingProviderType: 'institution',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-wedding-planner',
      title: 'Nikoh to\'yini tashkil qilish yordami',
      categoryLabel: 'Shaxsiy xizmatlar',
      subcategoryLabel: 'Tadbir tashkilotchisi',
      categoryId: 'personal_services',
      subcategoryId: 'event_planner',
      authorName: 'Nilufar',
      message:
          '150 kishi, aprel oyida. Zal, dekor, tamada va dasturxonga maslahat kerak. '
          'Budjetni muhokama qilamiz, tajribali bo\'lsin.',
      price: 5000000,
      currency: 'UZS',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-furniture-assembly',
      title: 'Bolalar xonasi mebelini yig\'ish',
      categoryLabel: 'Uy ta\'miri',
      subcategoryLabel: 'Usta',
      categoryId: 'home_repair',
      subcategoryId: 'handyman',
      authorName: 'Otabek',
      message:
          'Shkaf, stol va karavot qutisi kelgan. Qog\'oz yo\'riqnomasi bor, '
          'lekin o\'zim ulgurmayapman. Bugun yoki ertaga kechqurun.',
      price: 200000,
      currency: 'UZS',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-wedding-beauty-home',
      title: 'To\'y oldidan uyda soch va grimm — allergiya bor',
      categoryLabel: 'Go\'zallik',
      subcategoryLabel: 'Uyga keladigan go\'zallik ustasi',
      categoryId: 'beauty',
      subcategoryId: 'home_beauty',
      authorName: 'Madina',
      message:
          'Sentabrda to\'y. Terim juda sezgir, ba\'zi kosmetikadan qizaradi. '
          'Uyga keladigan kosmetolog kerak — soch turmagi + yengil grimm. '
          'Maxsus talab: allergolog kosmetolog, uyga kelish.',
      price: 650000,
      currency: 'UZS',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-kamaz-mechanic',
      title: 'Kamaz Toshkent viloyatidan Farg\'onaga ketadi — ishga tushmayapti',
      categoryLabel: 'Avto xizmatlar',
      subcategoryLabel: 'Mexanik',
      categoryId: 'auto',
      subcategoryId: 'mechanic',
      authorName: 'Jasur',
      message:
          'Katta yuk tashuvchi ishga tushmayapti, akkumulyator yangi. '
          'Uyga yoki garajga keladigan mexanik kerak, kechqurun bo\'lsa ham. '
          'Maxsus talab: katta yuk mashina tuzatuvchi, shoshilinch.',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-cafe-smm',
      title:
          'Новая кофейня, нужна SMM-специалист или лицо компании для продвижения бизнеса',
      categoryLabel: 'Marketing va o\'sish',
      subcategoryLabel: 'SMM mutaxassis',
      categoryId: 'marketing_growth',
      subcategoryId: 'smm_specialist',
      authorName: 'Sevinch',
      message:
          'Открылись 2 недели назад, Instagramа нет, нужен человек с опытом '
          'по контент-менеджменту и продвижению компании в социальных сетях '
          'в кругу молодёжи. Бюджет: договоримся в рамках средней стоимости в '
          'Ташкенте. Особые требования: молодая, дружелюбная и активная в '
          'соцсетях с минимум 9 000 активных молодых подписчиков в Instagram.',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-birthday-dj',
      title: '50 kishilik tug\'ilgan kunimga yosh DJ',
      categoryLabel: 'San\'at va ijrochilar',
      subcategoryLabel: 'DJ',
      categoryId: 'arts_performers',
      subcategoryId: 'dj',
      authorName: 'Sardor',
      message:
          '30 ga to\'ldim — tug\'ilgan kunim uy hovlimizda. Ovoz uskunasi va '
          'boshqa apparatlari bilan keladigan DJ kerak, 3–4 soatga. '
          'Maxsus talab: o\'zbek, qozoq va boshqa xalqaro repertuar, hovlida, '
          'ovoz uskunasi bilan.',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-rent-with-dog',
      title: '2 xonali kvartira — it bilan, metro yaqinida',
      categoryLabel: 'Ko\'chmas mulk',
      subcategoryLabel: 'Ijara agenti',
      categoryId: 'real_estate',
      subcategoryId: 'rental_agent',
      authorName: 'Dilnoza',
      message:
          'Men va 4 yoshli itim (tinch) uchun ijara qidiryapman. Narxiga qarab '
          'Chilonzor yoki Yunusobod tumani, metro 10 daqiqa yaqinligida. '
          'Ko\'p uy egalari itga ruxsat bermayapti — shunga mos variantlar kerak. '
          'Maxsus talab: hayvon bilan yashash, metro yaqin, ayol mijoz.',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-postpartum-yoga',
      title: 'Tug\'ruqdan keyin yoga mashqlari — uyda',
      categoryLabel: 'Sport va fitnes',
      subcategoryLabel: 'Shaxsiy murabbiy',
      categoryId: 'sports_fitness',
      subcategoryId: 'personal_trainer',
      authorName: 'Nigora',
      message:
          '32 yosh, tug\'ruqdan 3 oy o\'tdi. Sport zaliga borish qiyin, emizikli '
          'bolam bor. Uyga keladigan murabbiy ayol kerak — yoga va yengil kuch '
          'mashqlar. Haftada 2 marta. Maxsus talab: postpartum, uyga kelish, '
          'yengil dastur.',
      price: 220000,
      currency: 'UZS',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-labrador-sitting',
      title: 'Опека двух дружелюбных лабрадоров',
      categoryLabel: 'Veterinariya',
      subcategoryLabel: 'Hayvon parvarishi',
      categoryId: 'veterinary',
      subcategoryId: 'pet_sitter',
      authorName: 'Anvar',
      message:
          'Помогите, пожалуйста: едем в путешествие на две недели, два лабрадора '
          'остаются без присмотра. Нужны добрые люди, чтобы присмотрели, пока '
          'нас нет в городе. Заплатим хорошо, не обидим, обещаю!',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
    YordamKerakFeedItem(
      id: 'demo-job-exam-psychologist',
      title: 'Imtihon va uydagi sharoit stressi — qizim 11-sinf, psixolog kerak',
      categoryLabel: 'Sog\'liq',
      subcategoryLabel: 'Psixolog',
      categoryId: 'health',
      subcategoryId: 'psychologist',
      authorName: 'Kamola',
      message:
          'Qizim DTM oldida juda qattiq asabiylashyapti, uxlamayapti. Uydagi ba\'zi '
          'sharoitlar ham ta\'sir qilyapti va ko\'p tortishyapmiz — shunga balki '
          'psixolog yordam berar degan umiddaman. Maxsus talab: o\'smirlar stressi '
          'bilan ishlay oladigan psixolog.',
      price: 200000,
      currency: 'UZS',
      seekingProviderType: 'individual',
      isDemo: true,
    ),
  ];

  static const _authorIds = {
    'demo-job-elderly-care': 'demo-user-sarvar',
    'demo-job-female-driving-instructor': 'demo-user-bobur',
    'demo-job-web-designer': 'demo-user-codeline',
    'demo-job-laminat-yunusobod': 'demo-user-jamshid',
    'demo-job-washing-machine': 'demo-user-nodira',
    'demo-job-math-dtm': 'demo-user-bekzod',
    'demo-job-move-sergeli': 'demo-user-alisher',
    'demo-job-gate-welder': 'demo-user-sherzod',
    'demo-job-toy-osh': 'demo-user-dilshod',
    'demo-job-russian-prep': 'demo-user-ziyoda',
    'demo-job-1c-accountant': 'demo-user-rustam',
    'demo-job-bathroom-tile': 'demo-user-kamola-k',
    'demo-job-wedding-damas': 'demo-user-aziz-k',
    'demo-job-wedding-planner': 'demo-user-nilufar-k',
    'demo-job-furniture-assembly': 'demo-user-otabek',
    'demo-job-wedding-beauty-home': 'demo-user-madina',
    'demo-job-kamaz-mechanic': 'demo-user-jasur',
    'demo-job-cafe-smm': 'demo-user-sevinch',
    'demo-job-birthday-dj': 'demo-user-sardor',
    'demo-job-rent-with-dog': 'demo-user-dilnoza',
    'demo-job-postpartum-yoga': 'demo-user-nigora',
    'demo-job-labrador-sitting': 'demo-user-anvar',
    'demo-job-exam-psychologist': 'demo-user-kamola-h',
  };

  static List<YordamKerakFeedItem> get items =>
      _baseItems.map(_withAuthorId).toList(growable: false);

  static YordamKerakFeedItem? findById(String id) {
    for (final item in items) {
      if (item.id == id) return item;
    }
    return null;
  }

  static YordamKerakFeedItem _withAuthorId(YordamKerakFeedItem item) {
    final authorId = _authorIds[item.id];
    if (authorId == null) return item;

    return DemoEnrichment.enrichYordamKerakPost(
      YordamKerakFeedItem(
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
        contactPhone: item.contactPhone,
        showContactPhone: item.showContactPhone,
        showProfile: item.showProfile,
      ),
      authorId: authorId,
    );
  }
}
