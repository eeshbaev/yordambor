export type Language = 'UZ' | 'RU' | 'EN';

export const categories = [
  {
    id: 'home_repair',
    icon: '🔧',
    names: { uz: 'Uy ta\'miri', ru: 'Ремонт дома', en: 'Home Repair' },
    individual_subcategories: [
      { id: 'plumber', names: { uz: 'Santexnik', ru: 'Сантехник', en: 'Plumber' } },
      { id: 'electrician', names: { uz: 'Elektrik', ru: 'Электрик', en: 'Electrician' } },
      { id: 'carpenter', names: { uz: 'Duradgor', ru: 'Плотник', en: 'Carpenter' } },
      { id: 'locksmith', names: { uz: 'Chilangar', ru: 'Слесарь', en: 'Locksmith' } },
      { id: 'painter', names: { uz: 'Bo\'yoqchi', ru: 'Маляр', en: 'Painter' } },
      { id: 'welder', names: { uz: 'Payvandchi', ru: 'Сварщик', en: 'Welder' } },
      { id: 'handyman', names: { uz: 'Usta', ru: 'Мастер на все руки', en: 'Handyman' } },
      { id: 'tile_installer', names: { uz: 'Plitka yotqizuvchi', ru: 'Плиточник', en: 'Tile installer' } },
      { id: 'ac_repair', names: { uz: 'Konditsioner ta\'miri', ru: 'Ремонт кондиционеров', en: 'AC repair' } },
      { id: 'appliance_repair', names: { uz: 'Maishiy texnika ta\'miri', ru: 'Ремонт бытовой техники', en: 'Appliance repair' } },
      { id: 'roofer', names: { uz: 'Tom yopuvchi', ru: 'Кровельщик', en: 'Roofer' } },
      { id: 'drywall', names: { uz: 'Gipsokarton montaj', ru: 'Монтаж гипсокартона', en: 'Drywall installer' } },
      { id: 'flooring', names: { uz: 'Pol yopish (laminat, parket)', ru: 'Укладка полов', en: 'Flooring installer' } },
      { id: 'water_heater', names: { uz: 'Qozon va suv isitgich', ru: 'Котёл и водонагреватель', en: 'Boiler & water heater' } },
      { id: 'gas_stove', names: { uz: 'Gaz plita o\'rnatish', ru: 'Установка газовой плиты', en: 'Gas stove installation' } },
      { id: 'curtain_blinds', names: { uz: 'Parda va jaluzi', ru: 'Шторы и жалюзи', en: 'Curtains & blinds' } },
      { id: 'mosquito_screens', names: { uz: 'Komiljon to\'ri', ru: 'Москитные сетки', en: 'Mosquito screens' } },
      { id: 'furniture_assembly', names: { uz: 'Mebel yig\'ish', ru: 'Сборка мебели', en: 'Furniture assembly' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'renovation_company', names: { uz: 'Ta\'mirlash kompaniyasi', ru: 'Ремонтная компания', en: 'Renovation company' } },
      { id: 'property_maintenance', names: { uz: 'Mulk xizmat ko\'rsatish', ru: 'Обслуживание недвижимости', en: 'Property maintenance' } },
      { id: 'facility_management', names: { uz: 'Obektlarni boshqarish', ru: 'Управление объектами', en: 'Facility management' } },
      { id: 'construction_firm', names: { uz: 'Qurilish firması', ru: 'Строительная фирма', en: 'Construction firm' } },
      { id: 'interior_design_studio', names: { uz: 'Interer dizayn studiyasi', ru: 'Студия интерьерного дизайна', en: 'Interior design studio' } },
      { id: 'electrical_company', names: { uz: 'Elektr montaj kompaniyasi', ru: 'Электромонтажная компания', en: 'Electrical company' } },
      { id: 'plumbing_company', names: { uz: 'Santexnika kompaniyasi', ru: 'Сантехническая компания', en: 'Plumbing company' } },
      { id: 'hvac_company', names: { uz: 'Isitish-sovutish kompaniyasi', ru: 'Компания ОВК', en: 'HVAC company' } },
      { id: 'landscaping_company', names: { uz: 'Landshaft dizayn kompaniyasi', ru: 'Ландшафтная компания', en: 'Landscaping company' } },
      { id: 'security_systems', names: { uz: 'Xavfsizlik tizimlari', ru: 'Системы безопасности', en: 'Security systems company' } },
      { id: 'elevator_service', names: { uz: 'Lift xizmati', ru: 'Лифтовое обслуживание', en: 'Elevator service' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'cleaning',
    icon: '🧹',
    names: { uz: 'Tozalash', ru: 'Уборка', en: 'Cleaning' },
    individual_subcategories: [
      { id: 'house_cleaning', names: { uz: 'Uy tozalash', ru: 'Уборка дома', en: 'House cleaning' } },
      { id: 'carpet_cleaning', names: { uz: 'Gilam tozalash', ru: 'Чистка ковров', en: 'Carpet cleaning' } },
      { id: 'window_cleaning', names: { uz: 'Oyna tozalash', ru: 'Мытьё окон', en: 'Window cleaning' } },
      { id: 'after_repair_cleaning', names: { uz: 'Ta\'mirdan keyin tozalash', ru: 'Уборка после ремонта', en: 'Post-renovation cleaning' } },
      { id: 'deep_cleaning', names: { uz: 'Chuqur tozalash', ru: 'Глубокая уборка', en: 'Deep cleaning' } },
      { id: 'move_out_cleaning', names: { uz: 'Ko\'chishdan keyin tozalash', ru: 'Уборка при переезде', en: 'Move-out cleaning' } },
      { id: 'sofa_cleaning', names: { uz: 'Divan va mebel tozalash', ru: 'Чистка мебели', en: 'Upholstery cleaning' } },
      { id: 'kitchen_cleaning', names: { uz: 'Oshxona chuqur tozalash', ru: 'Глубокая уборка кухни', en: 'Kitchen deep clean' } },
      { id: 'ironing_laundry', names: { uz: 'Kiyim yuvish va dazmol', ru: 'Стирка и глажка', en: 'Laundry & ironing' } },
      { id: 'disinfection', names: { uz: 'Dezinfeksiya', ru: 'Дезинфекция', en: 'Disinfection' } },
      { id: 'pool_cleaning', names: { uz: 'Hovuz tozalash', ru: 'Чистка бассейна', en: 'Pool cleaning' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'office_cleaning', names: { uz: 'Ofis tozalash', ru: 'Уборка офиса', en: 'Office cleaning' } },
      { id: 'hotel_cleaning', names: { uz: 'Mehmonxona tozalash', ru: 'Уборка в отелях', en: 'Hotel cleaning' } },
      { id: 'hospital_cleaning', names: { uz: 'Kasalxona tozalash', ru: 'Уборка в больницах', en: 'Hospital cleaning' } },
      { id: 'commercial_cleaning', names: { uz: 'Tijorat binolarini tozalash', ru: 'Уборка коммерческих помещений', en: 'Commercial cleaning' } },
      { id: 'industrial_cleaning', names: { uz: 'Sanoat tozalash', ru: 'Промышленная уборка', en: 'Industrial cleaning' } },
      { id: 'cleaning_company', names: { uz: 'Tozalash kompaniyasi', ru: 'Клининговая компания', en: 'Cleaning company' } },
      { id: 'restaurant_cleaning', names: { uz: 'Restoran tozalash', ru: 'Уборка ресторанов', en: 'Restaurant cleaning' } },
      { id: 'school_cleaning', names: { uz: 'Maktab tozalash', ru: 'Уборка школ', en: 'School cleaning' } },
      { id: 'mall_cleaning', names: { uz: 'Savdo markazi tozalash', ru: 'Уборка ТЦ', en: 'Mall cleaning' } },
      { id: 'warehouse_cleaning', names: { uz: 'Ombor tozalash', ru: 'Уборка складов', en: 'Warehouse cleaning' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'education',
    icon: '📚',
    names: { uz: 'Ta\'lim', ru: 'Образование', en: 'Education' },
    individual_subcategories: [
      { id: 'english_tutor', names: { uz: 'Ingliz tili repetitori', ru: 'Репетитор английского', en: 'English tutor' } },
      { id: 'math_tutor', names: { uz: 'Matematika repetitori', ru: 'Репетитор математики', en: 'Math tutor' } },
      { id: 'russian_tutor', names: { uz: 'Rus tili repetitori', ru: 'Репетитор русского', en: 'Russian tutor' } },
      { id: 'physics_tutor', names: { uz: 'Fizika repetitori', ru: 'Репетитор физики', en: 'Physics tutor' } },
      { id: 'chemistry_tutor', names: { uz: 'Kimyo repetitori', ru: 'Репетитор химии', en: 'Chemistry tutor' } },
      { id: 'ielts_prep', names: { uz: 'IELTS tayyorlovi', ru: 'Подготовка к IELTS', en: 'IELTS prep' } },
      { id: 'music_lessons', names: { uz: 'Musiqa darslari', ru: 'Уроки музыки', en: 'Music lessons' } },
      { id: 'programming_tutor', names: { uz: 'Dasturlash o\'qituvchisi', ru: 'Репетитор по программированию', en: 'Programming tutor' } },
      { id: 'chess_lessons', names: { uz: 'Shaxmat darslari', ru: 'Уроки шахмат', en: 'Chess lessons' } },
      { id: 'home_tutor', names: { uz: 'Uyga keladigan repetitor', ru: 'Репетитор на дому', en: 'Home tutor' } },
      { id: 'uzbek_tutor', names: { uz: 'O\'zbek tili repetitori', ru: 'Репетитор узбекского', en: 'Uzbek language tutor' } },
      { id: 'korean_tutor', names: { uz: 'Koreys tili repetitori', ru: 'Репетитор корейского', en: 'Korean tutor' } },
      { id: 'german_tutor', names: { uz: 'Nemis tili repetitori', ru: 'Репетитор немецкого', en: 'German tutor' } },
      { id: 'biology_tutor', names: { uz: 'Biologiya repetitori', ru: 'Репетитор биологии', en: 'Biology tutor' } },
      { id: 'history_tutor', names: { uz: 'Tarix repetitori', ru: 'Репетитор истории', en: 'History tutor' } },
      { id: 'university_prep', names: { uz: 'OTMga tayyorlov', ru: 'Подготовка в вуз', en: 'University entrance prep' } },
      { id: 'sat_gmat_prep', names: { uz: 'SAT/GMAT tayyorlovi', ru: 'Подготовка SAT/GMAT', en: 'SAT/GMAT prep' } },
      { id: 'coding_for_kids', names: { uz: 'Bolalar uchun dasturlash', ru: 'Программирование для детей', en: 'Coding for kids' } },
      { id: 'art_lessons', names: { uz: 'Rassomlik darslari', ru: 'Уроки рисования', en: 'Art lessons' } },
      { id: 'dance_lessons_private', names: { uz: 'Raqs darslari (shaxsiy)', ru: 'Частные уроки танцев', en: 'Private dance lessons' } },
      { id: 'quran_lessons', names: { uz: 'Qur\'on o\'qitish', ru: 'Обучение Корану', en: 'Quran lessons' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'language_center', names: { uz: 'Til o\'rganish markazi', ru: 'Языковой центр', en: 'Language center' } },
      { id: 'tutoring_center', names: { uz: 'Repetitorlik markazi', ru: 'Репетиторский центр', en: 'Tutoring center' } },
      { id: 'it_school', names: { uz: 'IT maktab', ru: 'IT школа', en: 'IT school' } },
      { id: 'preschool', names: { uz: 'Maktabgacha ta\'lim', ru: 'Дошкольное образование', en: 'Preschool' } },
      { id: 'driving_school', names: { uz: 'Avtoyo\'l maktabi', ru: 'Автошкола', en: 'Driving school' } },
      { id: 'vocational_training', names: { uz: 'Kasbiy o\'quv markazi', ru: 'Учебный центр профподготовки', en: 'Vocational training center' } },
      { id: 'online_school', names: { uz: 'Online maktab', ru: 'Онлайн школа', en: 'Online school' } },
      { id: 'exam_prep_center', names: { uz: 'Imtihon tayyorlov markazi', ru: 'Центр подготовки к экзаменам', en: 'Exam prep center' } },
      { id: 'art_school', names: { uz: 'San\'at maktabi', ru: 'Художественная школа', en: 'Art school' } },
      { id: 'stem_academy', names: { uz: 'STEM akademiya', ru: 'STEM академия', en: 'STEM academy' } },
      { id: 'corporate_training', names: { uz: 'Korporativ trening markazi', ru: 'Корпоративное обучение', en: 'Corporate training center' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'tech',
    icon: '💻',
    names: { uz: 'Texnologiya', ru: 'Технологии', en: 'Tech' },
    individual_subcategories: [
      { id: 'computer_repair', names: { uz: 'Kompyuter ta\'miri', ru: 'Ремонт компьютера', en: 'Computer repair' } },
      { id: 'phone_repair', names: { uz: 'Telefon ta\'miri', ru: 'Ремонт телефона', en: 'Phone repair' } },
      { id: 'software_setup', names: { uz: 'Dastur o\'rnatish', ru: 'Установка программ', en: 'Software setup' } },
      { id: 'web_developer', names: { uz: 'Veb dasturchi', ru: 'Веб-разработчик', en: 'Web developer' } },
      { id: 'app_developer', names: { uz: 'Mobil ilova dasturchi', ru: 'Разработчик мобильных приложений', en: 'App developer' } },
      { id: 'network_setup', names: { uz: 'Tarmoq sozlash', ru: 'Настройка сети', en: 'Network setup' } },
      { id: 'laptop_repair', names: { uz: 'Noutbuk ta\'miri', ru: 'Ремонт ноутбуков', en: 'Laptop repair' } },
      { id: 'printer_setup', names: { uz: 'Printer sozlash', ru: 'Настройка принтеров', en: 'Printer setup' } },
      { id: 'cctv_install', names: { uz: 'Video kuzatuv o\'rnatish', ru: 'Установка видеонаблюдения', en: 'CCTV installation' } },
      { id: 'smart_home', names: { uz: 'Aqlli uy sozlash', ru: 'Умный дом', en: 'Smart home setup' } },
      { id: 'data_recovery', names: { uz: 'Ma\'lumot tiklash', ru: 'Восстановление данных', en: 'Data recovery' } },
      { id: 'it_consultant', names: { uz: 'IT maslahatchi', ru: 'IT консультант', en: 'IT consultant' } },
      { id: 'qa_tester', names: { uz: 'QA / test mutaxassisi', ru: 'QA / тестировщик', en: 'QA tester' } },
      { id: 'devops', names: { uz: 'DevOps mutaxassisi', ru: 'DevOps специалист', en: 'DevOps engineer' } },
      { id: 'ui_designer', names: { uz: 'Interfeys dizayneri', ru: 'UI дизайнер', en: 'UI designer' } },
      { id: 'telegram_bot', names: { uz: 'Telegram bot yaratish', ru: 'Разработка Telegram-ботов', en: 'Telegram bot developer' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'it_company', names: { uz: 'IT kompaniya', ru: 'IT компания', en: 'IT company' } },
      { id: 'software_agency', names: { uz: 'Dasturiy ta\'minot agentligi', ru: 'Агентство по разработке ПО', en: 'Software agency' } },
      { id: 'tech_support_company', names: { uz: 'Texnik yordam kompaniyasi', ru: 'Компания техподдержки', en: 'Tech support company' } },
      { id: 'cybersecurity_firm', names: { uz: 'Kiberxavfsizlik firması', ru: 'Фирма по кибербезопасности', en: 'Cybersecurity firm' } },
      { id: 'cloud_services', names: { uz: 'Bulut xizmatlari', ru: 'Облачные услуги', en: 'Cloud services' } },
      { id: 'web_studio', names: { uz: 'Veb studiya', ru: 'Веб-студия', en: 'Web studio' } },
      { id: 'hosting_provider', names: { uz: 'Hosting provayder', ru: 'Хостинг-провайдер', en: 'Hosting provider' } },
      { id: 'erp_implementation', names: { uz: 'ERP joriy etish', ru: 'Внедрение ERP', en: 'ERP implementation' } },
      { id: 'digital_transformation', names: { uz: 'Raqamli transformatsiya', ru: 'Цифровая трансформация', en: 'Digital transformation' } },
      { id: 'call_center_it', names: { uz: 'IT call-markaz', ru: 'IT колл-центр', en: 'IT call center' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'transport',
    icon: '🚗',
    names: { uz: 'Transport', ru: 'Транспорт', en: 'Transport' },
    individual_subcategories: [
      { id: 'driver', names: { uz: 'Haydovchi', ru: 'Водитель', en: 'Driver' } },
      { id: 'delivery', names: { uz: 'Yetkazib berish', ru: 'Доставка', en: 'Delivery' } },
      { id: 'moving_help', names: { uz: 'Ko\'chishga yordam', ru: 'Помощь с переездом', en: 'Moving help' } },
      { id: 'courier', names: { uz: 'Kuryer', ru: 'Курьер', en: 'Courier' } },
      { id: 'personal_driver', names: { uz: 'Shaxsiy haydovchi', ru: 'Личный водитель', en: 'Personal driver' } },
      { id: 'airport_transfer', names: { uz: 'Aeroport transfer', ru: 'Трансфер в аэропорт', en: 'Airport transfer' } },
      { id: 'wedding_transport', names: { uz: 'To\'y uchun transport', ru: 'Транспорт на свадьбу', en: 'Wedding transport' } },
      { id: 'freight_helper', names: { uz: 'Yuk ortish yordamchisi', ru: 'Помощь с погрузкой', en: 'Loading/unloading help' } },
      { id: 'motorcycle_courier', names: { uz: 'Motokuryer', ru: 'Мотокурьер', en: 'Motorcycle courier' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'transport_company', names: { uz: 'Transport kompaniyasi', ru: 'Транспортная компания', en: 'Transport company' } },
      { id: 'logistics', names: { uz: 'Logistika', ru: 'Логистика', en: 'Logistics' } },
      { id: 'taxi_service', names: { uz: 'Taksi xizmati', ru: 'Служба такси', en: 'Taxi service' } },
      { id: 'cargo_delivery', names: { uz: 'Yuk tashish', ru: 'Грузоперевозки', en: 'Cargo delivery' } },
      { id: 'bus_rental', names: { uz: 'Avtobus ijarasi', ru: 'Аренда автобусов', en: 'Bus rental' } },
      { id: 'moving_company', names: { uz: 'Ko\'chish kompaniyasi', ru: 'Компания переездов', en: 'Moving company' } },
      { id: 'international_logistics', names: { uz: 'Xalqaro logistika', ru: 'Международная логистика', en: 'International logistics' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'beauty',
    icon: '💄',
    names: { uz: 'Go\'zallik', ru: 'Красота', en: 'Beauty' },
    individual_subcategories: [
      { id: 'hairstylist', names: { uz: 'Soch ustasi', ru: 'Парикмахер', en: 'Hairstylist' } },
      { id: 'makeup_artist', names: { uz: 'Grim ustasi', ru: 'Визажист', en: 'Makeup artist' } },
      { id: 'nail_specialist', names: { uz: 'Tirnoq ustasi', ru: 'Мастер маникюра', en: 'Nail specialist' } },
      { id: 'barber', names: { uz: 'Sartarosh', ru: 'Барбер', en: 'Barber' } },
      { id: 'home_beauty', names: { uz: 'Uyga keladigan go\'zallik ustasi', ru: 'Мастер красоты на выезде', en: 'Mobile beauty specialist' } },
      { id: 'lash_brow', names: { uz: 'Kiprik va qosh', ru: 'Ресницы и брови', en: 'Lash & brow specialist' } },
      { id: 'wedding_makeup', names: { uz: 'To\'y grimi', ru: 'Свадебный макияж', en: 'Wedding makeup' } },
      { id: 'henna_artist', names: { uz: 'Xenna ustasi', ru: 'Мастер хны', en: 'Henna artist' } },
      { id: 'skincare', names: { uz: 'Teri parvarishi', ru: 'Уход за кожей', en: 'Skincare specialist' } },
      { id: 'permanent_makeup', names: { uz: 'Doimiy grimir', ru: 'Перманентный макияж', en: 'Permanent makeup' } },
      { id: 'hair_colorist', names: { uz: 'Soch bo\'yash ustasi', ru: 'Колорист', en: 'Hair colorist' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'beauty_salon', names: { uz: 'Go\'zallik saloni', ru: 'Салон красоты', en: 'Beauty salon' } },
      { id: 'barbershop', names: { uz: 'Sartaroshxona', ru: 'Барбершоп', en: 'Barbershop' } },
      { id: 'spa', names: { uz: 'SPA markazi', ru: 'СПА центр', en: 'SPA center' } },
      { id: 'nail_studio', names: { uz: 'Tirnoq studiyasi', ru: 'Ногтевая студия', en: 'Nail studio' } },
      { id: 'cosmetics_store', names: { uz: 'Kosmetika do\'koni', ru: 'Магазин косметики', en: 'Cosmetics store' } },
      { id: 'beauty_academy', names: { uz: 'Go\'zallik akademiyasi', ru: 'Академия красоты', en: 'Beauty academy' } },
      { id: 'wedding_salon', names: { uz: 'To\'y saloni', ru: 'Свадебный салон', en: 'Bridal salon' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'health',
    icon: '🏥',
    names: { uz: 'Sog\'liq', ru: 'Здоровье', en: 'Health & Wellness' },
    individual_subcategories: [
      { id: 'psychologist', names: { uz: 'Psixolog', ru: 'Психолог', en: 'Psychologist' } },
      { id: 'nutritionist', names: { uz: 'Dietolog', ru: 'Диетолог', en: 'Nutritionist' } },
      { id: 'massage_therapist', names: { uz: 'Massaj ustasi', ru: 'Массажист', en: 'Massage therapist' } },
      { id: 'nurse', names: { uz: 'Hamshira', ru: 'Медсестра', en: 'Nurse' } },
      { id: 'caregiver', names: { uz: 'Parvarishchi', ru: 'Сиделка', en: 'Caregiver' } },
      { id: 'physiotherapist', names: { uz: 'Fizioterapevt', ru: 'Физиотерапевт', en: 'Physiotherapist' } },
      { id: 'speech_therapist', names: { uz: 'Logoped', ru: 'Логопед', en: 'Speech therapist' } },
      { id: 'home_nurse', names: { uz: 'Uy hamshirasi', ru: 'Медсестра на дому', en: 'Home nurse' } },
      { id: 'acupuncture', names: { uz: 'Igna terapiya', ru: 'Иглоукалывание', en: 'Acupuncture' } },
      { id: 'fitness_nutrition', names: { uz: 'Sog\'lom ovqatlanish maslahati', ru: 'Консультация по питанию', en: 'Nutrition coaching' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'clinic', names: { uz: 'Klinika', ru: 'Клиника', en: 'Clinic' } },
      { id: 'dental_clinic', names: { uz: 'Stomatologiya klinikasi', ru: 'Стоматологическая клиника', en: 'Dental clinic' } },
      { id: 'medical_center', names: { uz: 'Tibbiy markaz', ru: 'Медицинский центр', en: 'Medical center' } },
      { id: 'pharmacy', names: { uz: 'Dorixona', ru: 'Аптека', en: 'Pharmacy' } },
      { id: 'rehabilitation_center', names: { uz: 'Reabilitatsiya markazi', ru: 'Реабилитационный центр', en: 'Rehabilitation center' } },
      { id: 'diagnostic_center', names: { uz: 'Diagnostika markazi', ru: 'Диагностический центр', en: 'Diagnostic center' } },
      { id: 'laboratory', names: { uz: 'Laboratoriya', ru: 'Лаборатория', en: 'Medical laboratory' } },
      { id: 'optics_clinic', names: { uz: 'Ko\'z klinikasi', ru: 'Глазная клиника', en: 'Eye clinic' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'auto',
    icon: '🔩',
    names: { uz: 'Avto xizmatlar', ru: 'Авто услуги', en: 'Auto Services' },
    individual_subcategories: [
      { id: 'mechanic', names: { uz: 'Mexanik', ru: 'Механик', en: 'Mechanic' } },
      { id: 'car_electrician', names: { uz: 'Avto elektrik', ru: 'Автоэлектрик', en: 'Car electrician' } },
      { id: 'tire_service', names: { uz: 'Shinomontaj', ru: 'Шиномонтаж', en: 'Tire service' } },
      { id: 'car_detailing', names: { uz: 'Avtomobil tozalash', ru: 'Детейлинг', en: 'Car detailing' } },
      { id: 'oil_change', names: { uz: 'Moy almashtirish', ru: 'Замена масла', en: 'Oil change' } },
      { id: 'body_repair', names: { uz: 'Kuzov ta\'miri', ru: 'Кузовной ремонт', en: 'Body repair' } },
      { id: 'auto_glass', names: { uz: 'Avto oyna', ru: 'Автостёкла', en: 'Auto glass' } },
      { id: 'car_alarm', names: { uz: 'Signalizatsiya o\'rnatish', ru: 'Установка сигнализации', en: 'Car alarm install' } },
      { id: 'lpg_install', names: { uz: 'Gaz ballon o\'rnatish', ru: 'Установка ГБО', en: 'LPG/CNG install' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'car_service', names: { uz: 'Avto servis', ru: 'Автосервис', en: 'Car service center' } },
      { id: 'car_wash', names: { uz: 'Avtomobil yuvish', ru: 'Автомойка', en: 'Car wash' } },
      { id: 'auto_parts', names: { uz: 'Ehtiyot qismlar do\'koni', ru: 'Магазин автозапчастей', en: 'Auto parts store' } },
      { id: 'driving_school', names: { uz: 'Haydovchilik maktabi', ru: 'Автошкола', en: 'Driving school' } },
      { id: 'car_dealership', names: { uz: 'Avtosalon', ru: 'Автосалон', en: 'Car dealership' } },
      { id: 'towing_service', names: { uz: 'Evakuator xizmati', ru: 'Эвакуатор', en: 'Towing service' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'family',
    icon: '👨‍👩‍👧',
    names: { uz: 'Oila va bolalar', ru: 'Семья и дети', en: 'Family & Kids' },
    individual_subcategories: [
      { id: 'babysitter', names: { uz: 'Bolalar parvarishi', ru: 'Няня', en: 'Babysitter' } },
      { id: 'elderly_care', names: { uz: 'Keksalar parvarishi', ru: 'Уход за пожилыми', en: 'Elderly care' } },
      { id: 'pet_care', names: { uz: 'Uy hayvonlari parvarishi', ru: 'Уход за животными', en: 'Pet care' } },
      { id: 'nanny', names: { uz: 'Enaga', ru: 'Гувернантка', en: 'Nanny' } },
      { id: 'homework_help', names: { uz: 'Uy vazifasiga yordam', ru: 'Помощь с домашним заданием', en: 'Homework help' } },
      { id: 'special_needs_care', names: { uz: 'Maxsus ehtiyojli bolalar parvarishi', ru: 'Уход за детьми с особыми потребностями', en: 'Special needs care' } },
      { id: 'dog_walker', names: { uz: 'It sayr qildirish', ru: 'Выгул собак', en: 'Dog walker' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'kindergarten', names: { uz: 'Bog\'cha', ru: 'Детский сад', en: 'Kindergarten' } },
      { id: 'daycare_center', names: { uz: 'Kunduzi bolalar markazi', ru: 'Центр дневного ухода', en: 'Daycare center' } },
      { id: 'family_center', names: { uz: 'Oila markazi', ru: 'Семейный центр', en: 'Family center' } },
      { id: 'pet_hotel', names: { uz: 'Hayvonlar mehmonxonasi', ru: 'Гостиница для животных', en: 'Pet hotel' } },
      { id: 'development_center', names: { uz: 'Rivojlanish markazi', ru: 'Центр развития', en: 'Child development center' } },
      { id: 'summer_camp', names: { uz: 'Yozgi lager', ru: 'Летний лагерь', en: 'Summer camp' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'food_culinary',
    icon: '🍽️',
    names: { uz: 'Ovqat va oshxona', ru: 'Еда и кулинария', en: 'Food & Culinary' },
    individual_subcategories: [
      { id: 'home_chef', names: { uz: 'Uyga keladigan oshpaz', ru: 'Домашний повар', en: 'Home chef' } },
      { id: 'cake_baker', names: { uz: 'Tort va desert ustasi', ru: 'Мастер тортов и десертов', en: 'Cake & dessert maker' } },
      { id: 'meal_prep', names: { uz: 'Ovqat tayyorlab berish', ru: 'Приготовление еды на неделю', en: 'Meal prep service' } },
      { id: 'uzbek_cuisine', names: { uz: 'O\'zbek milliy taomlari', ru: 'Узбекская национальная кухня', en: 'Uzbek national cuisine' } },
      { id: 'event_cooking', names: { uz: 'Tadbirlar uchun pishirish', ru: 'Приготовление на мероприятиях', en: 'Event cooking' } },
      { id: 'barista', names: { uz: 'Barista', ru: 'Бариста', en: 'Barista' } },
      { id: 'food_photographer', names: { uz: 'Ovqat fotografi', ru: 'Фуд-фотограф', en: 'Food photographer' } },
      { id: 'diet_chef', names: { uz: 'Dietali ovqat', ru: 'Диетический повар', en: 'Diet chef' } },
      { id: 'grill_bbq', names: { uz: 'Gril va BBQ', ru: 'Гриль и BBQ', en: 'Grill & BBQ chef' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'restaurant', names: { uz: 'Restoran', ru: 'Ресторан', en: 'Restaurant' } },
      { id: 'cafe', names: { uz: 'Kafe', ru: 'Кафе', en: 'Cafe' } },
      { id: 'bar', names: { uz: 'Bar', ru: 'Бар', en: 'Bar' } },
      { id: 'catering_company', names: { uz: 'Keytering kompaniyasi', ru: 'Кейтеринговая компания', en: 'Catering company' } },
      { id: 'bakery', names: { uz: 'Non-pishiriq do\'koni', ru: 'Пекарня', en: 'Bakery' } },
      { id: 'food_delivery', names: { uz: 'Ovqat yetkazib berish', ru: 'Доставка еды', en: 'Food delivery service' } },
      { id: 'cloud_kitchen', names: { uz: 'Cloud kitchen', ru: 'Облачная кухня', en: 'Cloud kitchen' } },
      { id: 'food_truck', names: { uz: 'Food truck', ru: 'Фуд-трак', en: 'Food truck' } },
      { id: 'halal_catering', names: { uz: 'Halol keytering', ru: 'Халяль кейтеринг', en: 'Halal catering' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'marketing_growth',
    icon: '📈',
    names: { uz: 'Marketing va o\'sish', ru: 'Маркетинг и рост', en: 'Marketing & Growth' },
    individual_subcategories: [
      { id: 'blogger', names: { uz: 'Blogger', ru: 'Блогер', en: 'Blogger' } },
      { id: 'smm_specialist', names: { uz: 'SMM mutaxassis', ru: 'SMM специалист', en: 'SMM specialist' } },
      { id: 'seo_specialist', names: { uz: 'SEO mutaxassis', ru: 'SEO специалист', en: 'SEO specialist' } },
      { id: 'content_creator', names: { uz: 'Kontent yaratuvchi', ru: 'Контент-мейкер', en: 'Content creator' } },
      { id: 'influencer', names: { uz: 'Influencer', ru: 'Инфлюенсер', en: 'Influencer' } },
      { id: 'copywriter', names: { uz: 'Kopirayter', ru: 'Копирайтер', en: 'Copywriter' } },
      { id: 'targetologist', names: { uz: 'Targetolog', ru: 'Таргетолог', en: 'Paid ads specialist' } },
      { id: 'email_marketer', names: { uz: 'Email marketing', ru: 'Email-маркетинг', en: 'Email marketer' } },
      { id: 'marketplace_seller', names: { uz: 'Marketpleys sotuvchi', ru: 'Продавец на маркетплейсах', en: 'Marketplace seller' } },
      { id: 'brand_strategist', names: { uz: 'Brend strategi', ru: 'Бренд-стратег', en: 'Brand strategist' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'advertising_agency', names: { uz: 'Reklama agentligi', ru: 'Рекламное агентство', en: 'Advertising agency' } },
      { id: 'pr_agency', names: { uz: 'PR agentligi', ru: 'PR агентство', en: 'PR agency' } },
      { id: 'digital_marketing_agency', names: { uz: 'Digital marketing agentligi', ru: 'Агентство диджитал-маркетинга', en: 'Digital marketing agency' } },
      { id: 'branding_studio', names: { uz: 'Brending studiyasi', ru: 'Брендинговая студия', en: 'Branding studio' } },
      { id: 'media_company', names: { uz: 'Media kompaniya', ru: 'Медиакомпания', en: 'Media company' } },
      { id: 'influencer_agency', names: { uz: 'Influencer agentligi', ru: 'Инфлюенсер-агентство', en: 'Influencer agency' } },
      { id: 'production_house', names: { uz: 'Prodyuserlik studiyasi', ru: 'Продакшн', en: 'Production house' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'creative_digital',
    icon: '🎨',
    names: { uz: 'Ijodiy va raqamli xizmatlar', ru: 'Творческие и цифровые услуги', en: 'Creative & Digital' },
    individual_subcategories: [
      { id: 'graphic_designer', names: { uz: 'Grafik dizayner', ru: 'Графический дизайнер', en: 'Graphic designer' } },
      { id: 'ui_ux_designer', names: { uz: 'UI/UX dizayner', ru: 'UI/UX дизайнер', en: 'UI/UX designer' } },
      { id: 'logo_designer', names: { uz: 'Logo dizayner', ru: 'Дизайнер логотипов', en: 'Logo designer' } },
      { id: 'video_editor', names: { uz: 'Video montajchi', ru: 'Видеомонтажёр', en: 'Video editor' } },
      { id: 'photographer', names: { uz: 'Fotograf', ru: 'Фотограф', en: 'Photographer' } },
      { id: 'motion_designer', names: { uz: 'Motion dizayner', ru: 'Моушн-дизайнер', en: 'Motion designer' } },
      { id: 'illustrator', names: { uz: 'Illyustrator', ru: 'Иллюстратор', en: 'Illustrator' } },
      { id: '3d_artist', names: { uz: '3D rassom', ru: '3D-художник', en: '3D artist' } },
      { id: 'voice_over', names: { uz: 'Dublyaj ovozi', ru: 'Озвучка', en: 'Voice-over artist' } },
      { id: 'drone_pilot', names: { uz: 'Drone operator', ru: 'Оператор дрона', en: 'Drone pilot' } },
      { id: 'social_media_design', names: { uz: 'Ijtimoiy tarmoq dizayni', ru: 'Дизайн для соцсетей', en: 'Social media design' } },
      { id: 'animator', names: { uz: 'Animator', ru: 'Аниматор', en: 'Animator' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'design_studio', names: { uz: 'Dizayn studiyasi', ru: 'Дизайн-студия', en: 'Design studio' } },
      { id: 'photo_studio', names: { uz: 'Foto studiya', ru: 'Фотостудия', en: 'Photo studio' } },
      { id: 'video_production', names: { uz: 'Video ishlab chiqarish', ru: 'Видеопроизводство', en: 'Video production company' } },
      { id: 'creative_agency', names: { uz: 'Kreativ agentlik', ru: 'Креативное агентство', en: 'Creative agency' } },
      { id: 'printing_house', names: { uz: 'Poligrafiya', ru: 'Полиграфия', en: 'Printing house' } },
      { id: 'signage_company', names: { uz: 'Reklama yorliqlari', ru: 'Вывески и наружка', en: 'Signage company' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'fashion_tailoring',
    icon: '🧵',
    names: { uz: 'Moda va tikuvchilik', ru: 'Мода и пошив', en: 'Fashion & Tailoring' },
    individual_subcategories: [
      { id: 'tailor', names: { uz: 'Tikuvchi', ru: 'Портной', en: 'Tailor' } },
      { id: 'traditional_clothing', names: { uz: 'Milliy kiyimlar ustasi', ru: 'Мастер национальной одежды', en: 'Traditional clothing maker' } },
      { id: 'embroidery', names: { uz: 'Kashtachilik', ru: 'Вышивка', en: 'Embroidery' } },
      { id: 'alterations', names: { uz: 'Kiyim ta\'mirlash', ru: 'Ремонт одежды', en: 'Clothing alterations' } },
      { id: 'wedding_dress', names: { uz: 'To\'y libosi tikish', ru: 'Пошив свадебного платья', en: 'Wedding dress tailor' } },
      { id: 'leather_craft', names: { uz: 'Charm tikuv', ru: 'Работа с кожей', en: 'Leather craft' } },
      { id: 'shoe_repair', names: { uz: 'Poyabzal ta\'miri', ru: 'Ремонт обуви', en: 'Shoe repair' } },
      { id: 'fashion_stylist', names: { uz: 'Stilist', ru: 'Стилист', en: 'Fashion stylist' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'fashion_atelier', names: { uz: 'Moda atelier', ru: 'Модное ателье', en: 'Fashion atelier' } },
      { id: 'clothing_factory', names: { uz: 'Kiyim fabrikasi', ru: 'Швейная фабрика', en: 'Clothing factory' } },
      { id: 'uniform_maker', names: { uz: 'Forma kiyimlar', ru: 'Пошив форменной одежды', en: 'Uniform manufacturer' } },
      { id: 'textile_wholesale', names: { uz: 'To\'qimachilik ulgurji', ru: 'Текстильный опт', en: 'Textile wholesale' } },
      { id: 'fashion_brand', names: { uz: 'Moda brendi', ru: 'Модный бренд', en: 'Fashion brand' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'consultancy',
    icon: '🏛️',
    names: { uz: 'Konsalting', ru: 'Консалтинг', en: 'Consultancy' },
    individual_subcategories: [
      { id: 'business_consultant', names: { uz: 'Biznes maslahatchi', ru: 'Бизнес-консультант', en: 'Business consultant' } },
      { id: 'financial_advisor', names: { uz: 'Moliyaviy maslahatchi', ru: 'Финансовый советник', en: 'Financial advisor' } },
      { id: 'hr_consultant', names: { uz: 'HR maslahatchi', ru: 'HR консультант', en: 'HR consultant' } },
      { id: 'startup_mentor', names: { uz: 'Startap mentori', ru: 'Ментор для стартапов', en: 'Startup mentor' } },
      { id: 'career_coach', names: { uz: 'Karyera kouchi', ru: 'Карьерный коуч', en: 'Career coach' } },
      { id: 'tax_consultant', names: { uz: 'Soliq maslahatchisi', ru: 'Налоговый консультант', en: 'Tax consultant' } },
      { id: 'import_export', names: { uz: 'Import-eksport maslahati', ru: 'Консультация по импорту/экспорту', en: 'Import/export consultant' } },
      { id: 'marketing_consultant', names: { uz: 'Marketing maslahatchi', ru: 'Маркетинговый консультант', en: 'Marketing consultant' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'consulting_firm', names: { uz: 'Konsalting firması', ru: 'Консалтинговая фирма', en: 'Consulting firm' } },
      { id: 'accounting_firm', names: { uz: 'Buxgalteriya firması', ru: 'Бухгалтерская фирма', en: 'Accounting firm' } },
      { id: 'audit_company', names: { uz: 'Audit kompaniyasi', ru: 'Аудиторская компания', en: 'Audit company' } },
      { id: 'investment_firm', names: { uz: 'Investitsiya firması', ru: 'Инвестиционная фирма', en: 'Investment firm' } },
      { id: 'law_tax_firm', names: { uz: 'Yuridik-soliq firmasi', ru: 'Юридико-налоговая фирма', en: 'Legal & tax firm' } },
      { id: 'management_consulting', names: { uz: 'Menejment konsalting', ru: 'Управленческий консалтинг', en: 'Management consulting' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'personal_services',
    icon: '🧳',
    names: { uz: 'Shaxsiy xizmatlar', ru: 'Личные услуги', en: 'Personal Services' },
    individual_subcategories: [
      { id: 'personal_assistant', names: { uz: 'Shaxsiy yordamchi', ru: 'Личный помощник', en: 'Personal assistant' } },
      { id: 'translator', names: { uz: 'Tarjimon', ru: 'Переводчик', en: 'Translator' } },
      { id: 'event_planner', names: { uz: 'Tadbir tashkilotchisi', ru: 'Организатор мероприятий', en: 'Event planner' } },
      { id: 'errand_runner', names: { uz: 'Topshiriqlarni bajaruvchi', ru: 'Выполнение поручений', en: 'Errand runner' } },
      { id: 'travel_planner', names: { uz: 'Sayohat rejalashtiruvchi', ru: 'Планировщик путешествий', en: 'Travel planner' } },
      { id: 'wedding_planner', names: { uz: 'To\'y tashkilotchisi', ru: 'Свадебный организатор', en: 'Wedding planner' } },
      { id: 'visa_assistance', names: { uz: 'Viza yordami', ru: 'Помощь с визой', en: 'Visa assistance' } },
      { id: 'personal_shopper', names: { uz: 'Shaxsiy xaridor', ru: 'Персональный шоппер', en: 'Personal shopper' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'event_agency', names: { uz: 'Tadbir agentligi', ru: 'Ивент агентство', en: 'Event agency' } },
      { id: 'travel_agency', names: { uz: 'Sayohat agentligi', ru: 'Туристическое агентство', en: 'Travel agency' } },
      { id: 'translation_bureau', names: { uz: 'Tarjima byurosi', ru: 'Бюро переводов', en: 'Translation bureau' } },
      { id: 'concierge_service', names: { uz: 'Konsyerj xizmati', ru: 'Консьерж-сервис', en: 'Concierge service' } },
      { id: 'wedding_agency', names: { uz: 'To\'y agentligi', ru: 'Свадебное агентство', en: 'Wedding agency' } },
      { id: 'relocation_service', names: { uz: 'Ko\'chish xizmati', ru: 'Релокация', en: 'Relocation service' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  // ─── NEW CATEGORIES ───────────────────────────────────────────────

  {
    id: 'arts_performers',
    icon: '🎭',
    names: { uz: 'San\'at va ijrochilar', ru: 'Искусство и артисты', en: 'Arts & Performers' },
    individual_subcategories: [
      { id: 'musician', names: { uz: 'Musiqachi', ru: 'Музыкант', en: 'Musician' } },
      { id: 'singer', names: { uz: 'Qo\'shiqchi', ru: 'Певец/Певица', en: 'Singer' } },
      { id: 'dancer', names: { uz: 'Raqqos/Raqqosa', ru: 'Танцор/Танцовщица', en: 'Dancer' } },
      { id: 'comedian', names: { uz: 'Komediyachi', ru: 'Комик', en: 'Comedian' } },
      { id: 'mc_host', names: { uz: 'Toʻylar boshlovchisi', ru: 'Ведущий мероприятий', en: 'MC / Event host' } },
      { id: 'actor', names: { uz: 'Artist', ru: 'Актёр/Актриса', en: 'Actor' } },
      { id: 'magician', names: { uz: 'Fokuschi', ru: 'Фокусник', en: 'Magician' } },
      { id: 'dj', names: { uz: 'DJ', ru: 'DJ', en: 'DJ' } },
      { id: 'poet_writer', names: { uz: 'Shoir / yozuvchi', ru: 'Поэт / писатель', en: 'Poet / writer' } },
      { id: 'calligrapher', names: { uz: 'Xattot', ru: 'Каллиграф', en: 'Calligrapher' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'music_band', names: { uz: 'Musiqa guruhi', ru: 'Музыкальная группа', en: 'Music band' } },
      { id: 'theater', names: { uz: 'Teatr', ru: 'Театр', en: 'Theater' } },
      { id: 'entertainment_agency', names: { uz: 'Ko\'ngil ochar agentlik', ru: 'Агентство развлечений', en: 'Entertainment agency' } },
      { id: 'dance_studio', names: { uz: 'Raqs studiyasi', ru: 'Танцевальная студия', en: 'Dance studio' } },
      { id: 'music_school', names: { uz: 'Musiqa maktabi', ru: 'Музыкальная школа', en: 'Music school' } },
      { id: 'event_production', names: { uz: 'Tadbir prodyuserligi', ru: 'Продакшн мероприятий', en: 'Event production' } },
      { id: 'recording_studio', names: { uz: 'Yozuv studiyasi', ru: 'Студия звукозаписи', en: 'Recording studio' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'legal',
    icon: '⚖️',
    names: { uz: 'Huquqiy xizmatlar', ru: 'Юридические услуги', en: 'Legal Services' },
    individual_subcategories: [
      { id: 'lawyer', names: { uz: 'Advokat', ru: 'Адвокат', en: 'Lawyer' } },
      { id: 'notary', names: { uz: 'Notarius', ru: 'Нотариус', en: 'Notary' } },
      { id: 'legal_consultant', names: { uz: 'Huquqiy maslahatchi', ru: 'Юридический консультант', en: 'Legal consultant' } },
      { id: 'contract_specialist', names: { uz: 'Shartnoma mutaxassisi', ru: 'Специалист по договорам', en: 'Contract specialist' } },
      { id: 'family_lawyer', names: { uz: 'Oila huquqi advokati', ru: 'Семейный адвокат', en: 'Family lawyer' } },
      { id: 'labor_lawyer', names: { uz: 'Mehnat huquqi', ru: 'Трудовое право', en: 'Labor law specialist' } },
      { id: 'immigration_lawyer', names: { uz: 'Migratsiya huquqi', ru: 'Миграционное право', en: 'Immigration lawyer' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'law_firm', names: { uz: 'Advokatlik firması', ru: 'Юридическая фирма', en: 'Law firm' } },
      { id: 'notary_office', names: { uz: 'Notarial idora', ru: 'Нотариальная контора', en: 'Notary office' } },
      { id: 'legal_support_company', names: { uz: 'Huquqiy yordam kompaniyasi', ru: 'Компания юридической поддержки', en: 'Legal support company' } },
      { id: 'arbitration_center', names: { uz: 'Arbitraj markazi', ru: 'Арбитражный центр', en: 'Arbitration center' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'real_estate',
    icon: '🏠',
    names: { uz: 'Ko\'chmas mulk', ru: 'Недвижимость', en: 'Real Estate' },
    individual_subcategories: [
      { id: 'realtor', names: { uz: 'Rieltor', ru: 'Риелтор', en: 'Realtor' } },
      { id: 'property_valuator', names: { uz: 'Mulk baholovchi', ru: 'Оценщик недвижимости', en: 'Property valuator' } },
      { id: 'property_manager', names: { uz: 'Mulk boshqaruvchi', ru: 'Управляющий недвижимостью', en: 'Property manager' } },
      { id: 'rental_agent', names: { uz: 'Ijara agenti', ru: 'Агент по аренде', en: 'Rental agent' } },
      { id: 'commercial_realtor', names: { uz: 'Tijorat ko\'chmas mulk', ru: 'Коммерческая недвижимость', en: 'Commercial realtor' } },
      { id: 'home_stager', names: { uz: 'Uy bezatish (staging)', ru: 'Хоумстейджинг', en: 'Home stager' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'real_estate_agency', names: { uz: 'Ko\'chmas mulk agentligi', ru: 'Агентство недвижимости', en: 'Real estate agency' } },
      { id: 'developer', names: { uz: 'Qurilish muassasasi', ru: 'Застройщик', en: 'Property developer' } },
      { id: 'property_management_company', names: { uz: 'Mulk boshqaruv kompaniyasi', ru: 'Управляющая компания', en: 'Property management company' } },
      { id: 'coworking_space', names: { uz: 'Coworking maydoni', ru: 'Коворкинг', en: 'Coworking space' } },
      { id: 'warehouse_rental', names: { uz: 'Ombor ijarasi', ru: 'Аренда складов', en: 'Warehouse rental' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'veterinary',
    icon: '🐾',
    names: { uz: 'Veterinariya', ru: 'Ветеринария', en: 'Veterinary' },
    individual_subcategories: [
      { id: 'vet_doctor', names: { uz: 'Veterinar shifokor', ru: 'Ветеринарный врач', en: 'Veterinarian' } },
      { id: 'pet_groomer', names: { uz: 'Hayvonlarni tayyorlash ustasi', ru: 'Грумер', en: 'Pet groomer' } },
      { id: 'pet_trainer', names: { uz: 'Hayvonlarni o\'rgatuvchi', ru: 'Кинолог/дрессировщик', en: 'Pet trainer' } },
      { id: 'pet_sitter', names: { uz: 'Hayvon parvarishi', ru: 'Передержка животных', en: 'Pet sitter' } },
      { id: 'aquarium_specialist', names: { uz: 'Akvarium mutaxassisi', ru: 'Специалист по аквариумам', en: 'Aquarium specialist' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'vet_clinic', names: { uz: 'Veterinar klinika', ru: 'Ветеринарная клиника', en: 'Veterinary clinic' } },
      { id: 'pet_shop', names: { uz: 'Hayvonlar do\'koni', ru: 'Зоомагазин', en: 'Pet shop' } },
      { id: 'pet_hotel', names: { uz: 'Hayvonlar mehmonxonasi', ru: 'Зоогостиница', en: 'Pet hotel' } },
      { id: 'pet_pharmacy', names: { uz: 'Veterinar dorixona', ru: 'Ветаптека', en: 'Pet pharmacy' } },
      { id: 'animal_shelter', names: { uz: 'Hayvonlar boshpanasi', ru: 'Приют для животных', en: 'Animal shelter' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'sports_fitness',
    icon: '💪',
    names: { uz: 'Sport va fitnes', ru: 'Спорт и фитнес', en: 'Sports & Fitness' },
    individual_subcategories: [
      { id: 'personal_trainer', names: { uz: 'Shaxsiy murabbiy', ru: 'Персональный тренер', en: 'Personal trainer' } },
      { id: 'yoga_instructor', names: { uz: 'Yoga murabbiyi', ru: 'Инструктор по йоге', en: 'Yoga instructor' } },
      { id: 'football_coach', names: { uz: 'Futbol murabbiyi', ru: 'Тренер по футболу', en: 'Football coach' } },
      { id: 'swimming_coach', names: { uz: 'Suzish murabbiyi', ru: 'Тренер по плаванию', en: 'Swimming coach' } },
      { id: 'martial_arts', names: { uz: 'Jang san\'atlari murabbiyi', ru: 'Тренер по единоборствам', en: 'Martial arts coach' } },
      { id: 'nutritionist_sports', names: { uz: 'Sport dietologi', ru: 'Спортивный диетолог', en: 'Sports nutritionist' } },
      { id: 'tennis_coach', names: { uz: 'Tennis murabbiyi', ru: 'Тренер по теннису', en: 'Tennis coach' } },
      { id: 'boxing_coach', names: { uz: 'Boks murabbiyi', ru: 'Тренер по боксу', en: 'Boxing coach' } },
      { id: 'pilates_instructor', names: { uz: 'Pilates instruktori', ru: 'Инструктор пилатеса', en: 'Pilates instructor' } },
      { id: 'running_coach', names: { uz: 'Yugurish murabbiyi', ru: 'Тренер по бегу', en: 'Running coach' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'gym', names: { uz: 'Sport zali', ru: 'Спортзал', en: 'Gym' } },
      { id: 'fitness_club', names: { uz: 'Fitnes klub', ru: 'Фитнес-клуб', en: 'Fitness club' } },
      { id: 'sports_school', names: { uz: 'Sport maktabi', ru: 'Спортивная школа', en: 'Sports school' } },
      { id: 'swimming_pool', names: { uz: 'Suzish havzasi', ru: 'Бассейн', en: 'Swimming pool' } },
      { id: 'sports_club', names: { uz: 'Sport klub', ru: 'Спортивный клуб', en: 'Sports club' } },
      { id: 'martial_arts_school', names: { uz: 'Jang san\'ati maktabi', ru: 'Школа единоборств', en: 'Martial arts school' } },
      { id: 'sports_medicine', names: { uz: 'Sport tibbiyoti', ru: 'Спортивная медицина', en: 'Sports medicine clinic' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },

  {
    id: 'remote_freelance',
    icon: '💼',
    names: { uz: 'Masofaviy ish va frilanser', ru: 'Удалённая работа и фриланс', en: 'Remote Work & Freelance' },
    individual_subcategories: [
      { id: 'freelance_developer', names: { uz: 'Frilanser dasturchi', ru: 'Фриланс-разработчик', en: 'Freelance developer' } },
      { id: 'freelance_designer', names: { uz: 'Frilanser dizayner', ru: 'Фриланс-дизайнер', en: 'Freelance designer' } },
      { id: 'freelance_writer', names: { uz: 'Frilanser yozuvchi', ru: 'Фриланс-автор', en: 'Freelance writer' } },
      { id: 'virtual_assistant', names: { uz: 'Virtual yordamchi', ru: 'Виртуальный ассистент', en: 'Virtual assistant' } },
      { id: 'data_analyst', names: { uz: 'Ma\'lumotlar tahlilchisi', ru: 'Аналитик данных', en: 'Data analyst' } },
      { id: 'freelance_accountant', names: { uz: 'Frilanser buxgalter', ru: 'Фриланс-бухгалтер', en: 'Freelance accountant' } },
      { id: 'project_manager', names: { uz: 'Loyiha menejeri', ru: 'Менеджер проектов', en: 'Project manager' } },
      { id: 'customer_support', names: { uz: 'Mijozlarga yordam', ru: 'Поддержка клиентов', en: 'Customer support' } },
      { id: 'bookkeeper', names: { uz: 'Buxgalter (masofadan)', ru: 'Бухгалтер (удалённо)', en: 'Remote bookkeeper' } },
      { id: 'social_media_manager', names: { uz: 'Ijtimoiy tarmoq menejeri', ru: 'SMM-менеджер', en: 'Social media manager' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
    institution_subcategories: [
      { id: 'outsourcing_company', names: { uz: 'Autsorsing kompaniyasi', ru: 'Аутсорсинговая компания', en: 'Outsourcing company' } },
      { id: 'remote_team', names: { uz: 'Masofaviy jamoa', ru: 'Удалённая команда', en: 'Remote team' } },
      { id: 'staffing_agency', names: { uz: 'Xodimlar agentligi', ru: 'Кадровое агентство', en: 'Staffing agency' } },
      { id: 'bpo_company', names: { uz: 'BPO kompaniya', ru: 'BPO компания', en: 'BPO company' } },
      { id: 'freelance_platform', names: { uz: 'Frilans platforma', ru: 'Фриланс-платформа', en: 'Freelance platform' } },
      { id: 'other', names: { uz: 'Boshqa (yozing)', ru: 'Другое (напишите)', en: 'Other (describe)' }, is_open: true },
    ],
  },
];

export const cities = [
  'Tashkent',
  'Samarkand',
];

export type Category = typeof categories[0];
export type Subcategory = Category['individual_subcategories'][0];
/** Specialist / poster type for category trees */
export type ProviderType = 'individual' | 'institution';
/** API / profile may use "organization" — same as institution */
export type ProviderTypeInput = ProviderType | 'organization';

export function normalizeProviderType(type: ProviderTypeInput): ProviderType {
  return type === 'organization' ? 'institution' : type;
}

export function getCategoryById(id: string): Category | undefined {
  return categories.find(c => c.id === id);
}

export function getSubcategories(categoryId: string, providerType: ProviderTypeInput): Subcategory[] {
  const category = getCategoryById(categoryId);
  if (!category) return [];
  return normalizeProviderType(providerType) === 'individual'
    ? category.individual_subcategories
    : category.institution_subcategories;
}

export function findSubcategory(
  categoryId: string,
  subcategoryId: string,
  providerType?: ProviderTypeInput
): Subcategory | undefined {
  if (providerType) {
    return getSubcategories(categoryId, providerType).find(s => s.id === subcategoryId);
  }
  const category = getCategoryById(categoryId);
  if (!category) return undefined;
  return [...category.individual_subcategories, ...category.institution_subcategories].find(
    s => s.id === subcategoryId
  );
}

export function getSubcategoryName(
  categoryId: string,
  subcategoryId: string,
  lang: 'uz' | 'ru' | 'en',
  providerType?: ProviderTypeInput
): string {
  const sub = findSubcategory(categoryId, subcategoryId, providerType);
  return sub?.names[lang] ?? subcategoryId;
}

export function getProviderTypeLabel(providerType: ProviderType, lang: 'uz' | 'ru' | 'en'): string {
  if (providerType === 'individual') {
    return lang === 'uz' ? 'Jismoniy shaxs' : lang === 'ru' ? 'Физическое лицо' : 'Individual';
  }
  return lang === 'uz' ? 'Tashkilot' : lang === 'ru' ? 'Организация' : 'Organization';
}

/** Whether a stored profile user_type matches the browse/filter provider type */
export function profileMatchesProviderType(
  profileUserType: 'individual' | 'organization' | 'institution',
  filter: ProviderType
): boolean {
  if (filter === 'individual') return profileUserType === 'individual';
  return profileUserType === 'organization' || profileUserType === 'institution';
}