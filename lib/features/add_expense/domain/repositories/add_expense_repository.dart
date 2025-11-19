import '../../../dashboard/domain/entities/expense.dart' as dashboard;
import '../entities/expense.dart';

abstract class AddExpenseRepository {
  Future<dashboard.ExpenseItem> add(Expense expense);
}
