import '../../../../core/utils/date_filters.dart';
import '../../../../core/persistence/models/expense_hive_model.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/dashboard_expense_repository.dart';
import '../datasources/dashboard_local_datasource.dart';

class DashboardExpenseRepositoryImpl implements DashboardExpenseRepository {
  final DashboardLocalDataSource local;
  DashboardExpenseRepositoryImpl({required this.local});

  ExpenseItem _map(ExpenseHiveModel m) => ExpenseItem(
        id: m.id,
        category: m.category,
        iconKey: m.iconKey,
        amountOriginal: m.amountOriginal,
        currency: m.currency,
        amountUsd: m.amountUsd,
        date: m.date,
        receiptPath: m.receiptPath,
      );

  @override
  Future<PagedExpenses> getExpenses({
    required ExpenseFilter filter,
    required int page,
    required int pageSize,
  }) async {
    final rows = await local.query(filter, page: page, pageSize: pageSize);
    final totalCount = await local.countFiltered(filter);
    final hasMore = (page + 1) * pageSize < totalCount;
    return PagedExpenses(rows.map(_map).toList(), hasMore);
  }

  @override
  Future<double> getTotalUsd({required ExpenseFilter filter}) => local.sumUsd(filter);
}
