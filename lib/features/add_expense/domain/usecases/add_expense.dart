import '../../../dashboard/domain/entities/expense.dart' as dashboard;
import '../entities/expense.dart';
import '../repositories/add_expense_repository.dart';

class AddExpense {
  final AddExpenseRepository repo;
  AddExpense(this.repo);

  Future<dashboard.ExpenseItem> call(Expense expense) => repo.add(expense);
}
