import '../../../../core/utils/date_filters.dart';
import '../repositories/dashboard_expense_repository.dart';

class GetSummary {
  final DashboardExpenseRepository repo;
  GetSummary(this.repo);

  Future<double> call(ExpenseFilter filter) => repo.getTotalUsd(filter: filter);
}
