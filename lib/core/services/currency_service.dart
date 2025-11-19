import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../persistence/hive_boxes.dart';

class CurrencyService {
  final Uri _endpoint = Uri.parse('https://open.er-api.com/v6/latest/USD');

  static const String _kRatesKey = 'latest_usd';
  static const String _kTsKey = 'ts';

  Future<Map<String, double>> getUsdRates() async {
    final box = await Hive.openBox(HiveBoxes.rates);

    try {
      final res = await http.get(_endpoint).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final jsonBody = json.decode(res.body) as Map<String, dynamic>;
        final ratesRaw = jsonBody['rates'];
        if (ratesRaw is Map<String, dynamic>) {
          final rates = ratesRaw.map(
            (k, v) =>
                MapEntry(k.toString().toUpperCase(), (v as num).toDouble()),
          );
          await box.put(_kRatesKey, rates);
          await box.put(_kTsKey, DateTime.now().millisecondsSinceEpoch);
          return rates;
        }
        throw const FormatException(
            'Malformed rates payload'); // Why: bad API shape → fallback to cache
      } else {
        final cached = _loadCachedRates(box);
        if (cached != null) return cached;
        throw RatesUnavailableException();
      }
    } on RatesUnavailableException {
      rethrow;
    } on SocketException catch (_) {
      final cached = _loadCachedRates(box);
      if (cached != null) return cached;
      throw RatesUnavailableException();
    } on HttpException catch (_) {
      final cached = _loadCachedRates(box);
      if (cached != null) return cached;
      throw RatesUnavailableException();
    } on FormatException catch (_) {
      final cached = _loadCachedRates(box);
      if (cached != null) return cached;
      throw RatesUnavailableException();
    } on Exception catch (_) {
      final cached = _loadCachedRates(box);
      if (cached != null) return cached;
      throw RatesUnavailableException();
    }
  }

  Map<String, double>? _loadCachedRates(Box box) {
    final cached = box.get(_kRatesKey);
    if (cached is Map) {
      final map = cached
          .cast<String, dynamic>()
          .map((k, v) => MapEntry(k.toUpperCase(), (v as num).toDouble()));
      if (map.isNotEmpty) return map;
    }
    return null;
  }

  double toUsd({
    required double amount,
    required String currency,
    required Map<String, double> usdBaseRates,
  }) {
    final code = currency.toUpperCase();
    if (code == 'USD') return amount;
    final rate = usdBaseRates[code];
    if (rate == null || rate == 0) {
      throw ArgumentError('Unknown or zero rate for $code');
    }
    return amount / rate;
  }
}

class RatesUnavailableException implements Exception {
  final String message;
  RatesUnavailableException(
      [this.message =
          'Exchange rates unavailable. Connect to the internet once to initialize.']);
  @override
  String toString() => message;
}
