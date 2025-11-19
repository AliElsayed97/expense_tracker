import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_lite/core/services/currency_service.dart';

void main() {
  test('USD-based conversion divides by rate', () {
    final svc = CurrencyService();
    final rates = {'EUR': 0.5, 'USD': 1.0};
    final usd = svc.toUsd(amount: 100, currency: 'EUR', usdBaseRates: rates);
    expect(usd, 200);
  });
}
