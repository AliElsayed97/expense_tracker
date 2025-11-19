import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/date_filters.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/usecases/get_expenses.dart';
import '../../../domain/usecases/get_summary.dart';

part 'expense_list_event.dart';
part 'expense_list_state.dart';

class ExpenseListBloc extends Bloc<ExpenseListEvent, ExpenseListState> {
  static const int _pageSize = 10;

  final GetExpenses getExpenses;
  final GetSummary getSummary;

  ExpenseListBloc({
    required this.getExpenses,
    required this.getSummary,
  }) : super(const ExpenseListState.initial()) {
    on<ExpenseListLoaded>(_onLoaded);
    on<ExpenseListLoadMore>(_onLoadMore);
    on<ExpenseListFilterChanged>(_onFilterChanged);
    on<ExpenseListExpenseAdded>(_onExpenseAdded);
  }

  Future<void> _onLoaded(
    ExpenseListLoaded event,
    Emitter<ExpenseListState> emit,
  ) async {
    emit(state.copyWith(status: ExpenseListStatus.loading, page: 0));
    try {
      final summaryUsd = await getSummary(state.filter);
      final page0 = await getExpenses(state.filter, 0, _pageSize);
      emit(
        state.copyWith(
          status: ExpenseListStatus.ready,
          items: page0.items,
          hasMore: page0.hasMore,
          page: 0,
          totalUsd: summaryUsd,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ExpenseListStatus.error));
    }
  }

  Future<void> _onLoadMore(
    ExpenseListLoadMore event,
    Emitter<ExpenseListState> emit,
  ) async {
    if (!state.hasMore || state.status == ExpenseListStatus.loadingMore) return;
    emit(state.copyWith(status: ExpenseListStatus.loadingMore));
    try {
      final next = state.page + 1;
      final res = await getExpenses(state.filter, next, _pageSize);
      emit(
        state.copyWith(
          status: ExpenseListStatus.ready,
          items: [...state.items, ...res.items],
          hasMore: res.hasMore,
          page: next,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ExpenseListStatus.ready));
    }
  }

  Future<void> _onFilterChanged(
    ExpenseListFilterChanged event,
    Emitter<ExpenseListState> emit,
  ) async {
    emit(state.copyWith(filter: event.filter));
    add(ExpenseListLoaded());
  }

  Future<void> _onExpenseAdded(
    ExpenseListExpenseAdded event,
    Emitter<ExpenseListState> emit,
  ) async {
    add(ExpenseListLoaded());
  }
}
