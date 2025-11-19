part of 'add_expense_bloc.dart';

enum AddExpenseStatus { idle, submitting, success, error }

class AddExpenseState extends Equatable {
  final String category;
  final String iconKey;
  final double amount;
  final String currency;
  final DateTime date;
  final String? receiptPath;
  final AddExpenseStatus status;
  final String? error;

  AddExpenseState({
    this.category = 'Entertainment',
    this.iconKey = 'entertainment',
    this.amount = 0,
    this.currency = 'USD',
    DateTime? date,
    this.receiptPath,
    this.status = AddExpenseStatus.idle,
    this.error,
  }) : date = date ?? DateTime.now();

  AddExpenseState copyWith({
    String? category,
    String? iconKey,
    double? amount,
    String? currency,
    DateTime? date,
    String? receiptPath,
    AddExpenseStatus? status,
    String? error,
  }) =>
      AddExpenseState(
        category: category ?? this.category,
        iconKey: iconKey ?? this.iconKey,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        date: date ?? this.date,
        receiptPath: receiptPath ?? this.receiptPath,
        status: status ?? this.status,
        error: error,
      );

  @override
  List<Object?> get props =>
      [category, iconKey, amount, currency, date, receiptPath, status, error];
}
