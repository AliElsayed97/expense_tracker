import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/expense.dart';
import '../../../domain/usecases/add_expense.dart';

part 'add_expense_event.dart';
part 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final AddExpense addExpense;

  AddExpenseBloc({required this.addExpense}) : super(AddExpenseState()) {
    on<AddExpenseFieldChanged>((e, emit) => emit(state.copyWith(
          category: e.category ?? state.category,
          iconKey: e.iconKey ?? state.iconKey,
          amount: e.amount ?? state.amount,
          currency: e.currency ?? state.currency,
          date: e.date ?? state.date,
          receiptPath: e.receiptPath ?? state.receiptPath,
        )));

    on<AddExpenseSubmitted>(_onSubmit);
  }

  Future<void> _onSubmit(
      AddExpenseSubmitted e, Emitter<AddExpenseState> emit) async {
    emit(state.copyWith(status: AddExpenseStatus.submitting, error: null));
    try {
      await addExpense(e.expense);
      emit(state.copyWith(status: AddExpenseStatus.success));
    } catch (err) {
      emit(state.copyWith(
          status: AddExpenseStatus.error, error: err.toString()));
    }
  }
}
