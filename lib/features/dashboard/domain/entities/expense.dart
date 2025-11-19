import 'package:equatable/equatable.dart';

class ExpenseItem extends Equatable {
  final String id;
  final String category;
  final String iconKey;
  final double amountOriginal;
  final String currency;
  final double amountUsd;
  final DateTime date;
  final String? receiptPath;

  const ExpenseItem({
    required this.id,
    required this.category,
    required this.iconKey,
    required this.amountOriginal,
    required this.currency,
    required this.amountUsd,
    required this.date,
    this.receiptPath,
  });

  @override
  List<Object?> get props => [id, category, iconKey, amountOriginal, currency, amountUsd, date, receiptPath];
}
