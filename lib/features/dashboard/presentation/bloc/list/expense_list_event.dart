part of 'expense_list_bloc.dart';

abstract class ExpenseListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExpenseListLoaded extends ExpenseListEvent {}
class ExpenseListLoadMore extends ExpenseListEvent {}
class ExpenseListFilterChanged extends ExpenseListEvent {
  final ExpenseFilter filter;
  ExpenseListFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}
class ExpenseListExpenseAdded extends ExpenseListEvent {}
