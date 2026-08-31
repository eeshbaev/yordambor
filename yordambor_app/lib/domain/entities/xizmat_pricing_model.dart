enum XizmatPricingModel {
  negotiable,
  fixed,
  hourly;

  static XizmatPricingModel fromDb(String? value) => switch (value) {
        'fixed' => XizmatPricingModel.fixed,
        'hourly' => XizmatPricingModel.hourly,
        _ => XizmatPricingModel.negotiable,
      };

  String toDb() => name;
}
