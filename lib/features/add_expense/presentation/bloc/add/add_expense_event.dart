part of 'add_expense_bloc.dart';

abstract class AddExpenseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddExpenseFieldChanged extends AddExpenseEvent {
  final String? category;
  final String? iconKey;
  final double? amount;
  final String? currency;
  final DateTime? date;
  final String? receiptPath;
  AddExpenseFieldChanged({
    this.category,
    this.iconKey,
    this.amount,
    this.currency,
    this.date,
    this.receiptPath,
  });
  @override
  List<Object?> get props =>
      [category, iconKey, amount, currency, date, receiptPath];
}

class AddExpenseSubmitted extends AddExpenseEvent {
  final Expense expense;
  AddExpenseSubmitted(this.expense);
  @override
  List<Object?> get props => [expense];
}
