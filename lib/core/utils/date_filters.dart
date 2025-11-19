enum ExpenseFilter { all, thisMonth, last7Days }

extension ExpenseFilterX on ExpenseFilter {
  String get label {
    switch (this) {
      case ExpenseFilter.all:
        return 'All';
      case ExpenseFilter.thisMonth:
        return 'This month';
      case ExpenseFilter.last7Days:
        return 'Last 7 days';
    }
  }

  bool includeDate(DateTime d) {
    final now = DateTime.now();
    switch (this) {
      case ExpenseFilter.all:
        return true;
      case ExpenseFilter.thisMonth:
        return d.year == now.year && d.month == now.month;
      case ExpenseFilter.last7Days:
        return d.isAfter(now.subtract(const Duration(days: 7)));
    }
  }
}
