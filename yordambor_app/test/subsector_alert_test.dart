import 'package:flutter_test/flutter_test.dart';
import 'package:yordambor/domain/entities/subsector_alert_subscription.dart';

Map<String, dynamic> _row([Map<String, dynamic> extra = const {}]) => {
      'id': 'a1',
      'user_id': 'u1',
      'category_id': 'home_repair',
      'subcategory_id': 'cleaning',
      'provider_type': 'individual',
      'alert_new_service': false,
      'alert_discount': false,
      'alert_help_post': true,
      'created_at': '2030-01-01T10:00:00Z',
      'updated_at': '2030-01-02T10:00:00Z',
      ...extra,
    };

void main() {
  test('an alert made for a service, in its city', () {
    final alert = SubsectorAlertSubscription.fromRow(
      _row({'from_service': true, 'service_city': 'toshkent'}),
    );
    expect(alert.fromService, isTrue);
    expect(alert.serviceCity, 'toshkent');
    expect(alert.copyWith(alertHelpPost: false).fromService, isTrue);
    expect(alert.copyWith(alertHelpPost: false).serviceCity, 'toshkent');
  });

  test('a row from before migration 024: by hand, any city', () {
    final alert = SubsectorAlertSubscription.fromRow(_row());
    expect(alert.fromService, isFalse);
    expect(alert.serviceCity, isNull);
    expect(alert.hasAnyAlert, isTrue);
  });

  test('an unknown city or a missing update time does not break it', () {
    final alert = SubsectorAlertSubscription.fromRow(
      _row({'service_city': 'atlantis', 'updated_at': null}),
    );
    expect(alert.serviceCity, isNull);
    expect(alert.updatedAt, alert.createdAt);
  });
}
