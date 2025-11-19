part of 'expense_list_bloc.dart';

enum ExpenseListStatus { initial, loading, ready, loadingMore, error }

class ExpenseListState extends Equatable {
  final ExpenseListStatus status;
  final List<ExpenseItem> items;
  final bool hasMore;
  final int page;
  final ExpenseFilter filter;
  final double totalUsd;

  const ExpenseListState({
    required this.status,
    required this.items,
    required this.hasMore,
    required this.page,
    required this.filter,
    required this.totalUsd,
  });

  const ExpenseListState.initial()
      : status = ExpenseListStatus.initial,
        items = const [],
        hasMore = true,
        page = 0,
        filter = ExpenseFilter.all,
        totalUsd = 0.0;

  ExpenseListState copyWith({
    ExpenseListStatus? status,
    List<ExpenseItem>? items,
    bool? hasMore,
    int? page,
    ExpenseFilter? filter,
    double? totalUsd,
  }) {
    return ExpenseListState(
      status: status ?? this.status,
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      filter: filter ?? this.filter,
      totalUsd: totalUsd ?? this.totalUsd,
    );
  }

  @override
  List<Object?> get props => [status, items, hasMore, page, filter, totalUsd];
}
