import 'package:equatable/equatable.dart';
import '../../../../core/utils/date_filters.dart';
import '../entities/expense.dart';

class PagedExpenses extends Equatable {
  final List<ExpenseItem> items;
  final bool hasMore;
  const PagedExpenses(this.items, this.hasMore);

  @override
  List<Object?> get props => [items, hasMore];
}

abstract class DashboardExpenseRepository {
  Future<PagedExpenses> getExpenses({
    required ExpenseFilter filter,
    required int page,
    required int pageSize,
  });

  Future<double> getTotalUsd({required ExpenseFilter filter});
}
