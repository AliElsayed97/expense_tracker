import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String category;
  final String iconKey;
  final double amount;
  final String currency;
  final DateTime date;
  final String? receiptPath;

  const Expense({
    required this.category,
    required this.iconKey,
    required this.amount,
    required this.currency,
    required this.date,
    this.receiptPath,
  });

  @override
  List<Object?> get props =>
      [category, iconKey, amount, currency, date, receiptPath];
}
