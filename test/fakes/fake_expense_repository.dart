import 'dart:math';
import 'package:expense_tracker_lite/core/utils/date_filters.dart';
import 'package:expense_tracker_lite/features/dashboard/domain/entities/expense.dart';
import 'package:expense_tracker_lite/features/dashboard/domain/repositories/dashboard_expense_repository.dart';

class FakeExpenseRepository implements DashboardExpenseRepository {
  final List<ExpenseItem> _items = [];

  FakeExpenseRepository({int seedItems = 35}) {
    final rnd = Random(1);
    for (var i = 0; i < seedItems; i++) {
      final dayOffset = rnd.nextInt(20);
      _items.add(ExpenseItem(
        id: 'id_$i',
        category: i % 2 == 0 ? 'Groceries' : 'Entertainment',
        iconKey: i % 2 == 0 ? 'food' : 'entertainment',
        amountOriginal: 10 + i.toDouble(),
        currency: 'USD',
        amountUsd: 10 + i.toDouble(),
        date: DateTime.now().subtract(Duration(days: dayOffset)),
        receiptPath: null,
      ));
    }
    _items.sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<PagedExpenses> getExpenses({required ExpenseFilter filter, required int page, required int pageSize}) async {
    final filtered = _items.where((e) => filter.includeDate(e.date)).toList();
    final start = page * pageSize;
    final end = (start + pageSize).clamp(0, filtered.length).toInt();
    final slice = start >= filtered.length ? <ExpenseItem>[] : filtered.sublist(start, end);
    final hasMore = (page + 1) * pageSize < filtered.length;
    return PagedExpenses(slice, hasMore);
  }

  @override
  Future<double> getTotalUsd({required ExpenseFilter filter}) async {
    return _items.where((e) => filter.includeDate(e.date)).fold<double>(0.0, (p, e) => p + e.amountUsd);
  }
}
