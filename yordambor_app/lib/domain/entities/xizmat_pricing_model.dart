/// How a price is meant, on a service or a help request (migration 024).
enum XizmatPricingModel {
  /// Agreed in the chat; no amount.
  negotiable,

  /// One amount for the whole job.
  fixed,
  hourly,
  daily,
  monthly,

  /// Per piece, item or unit of work.
  unit;

  /// The units an amount can be given in, in the order they are offered.
  static const amountUnits = [fixed, hourly, daily, monthly, unit];

  static XizmatPricingModel fromDb(String? value) => switch (value) {
        'fixed' => XizmatPricingModel.fixed,
        'hourly' => XizmatPricingModel.hourly,
        'daily' => XizmatPricingModel.daily,
        'monthly' => XizmatPricingModel.monthly,
        'unit' => XizmatPricingModel.unit,
        _ => XizmatPricingModel.negotiable,
      };

  String toDb() => name;

  /// Comes with an amount (everything but negotiable).
  bool get hasAmount => this != XizmatPricingModel.negotiable;
}
