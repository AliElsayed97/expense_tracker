import '../../../../core/utils/date_filters.dart';
import '../repositories/dashboard_expense_repository.dart';

class GetExpenses {
  final DashboardExpenseRepository repo;
  GetExpenses(this.repo);

  Future<PagedExpenses> call(ExpenseFilter filter, int page, int pageSize) {
    return repo.getExpenses(filter: filter, page: page, pageSize: pageSize);
  }
}
