import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'create_expense_event.dart';
part 'create_expense_state.dart';

class CreateExpenseBloc extends Bloc<CreateExpense, CreateExpenseState> {
  ExpenseRepository repository;
  CreateExpenseBloc(this.repository) : super(CreateExpenseInitial()) {
    on<CreateExpense>((event, emit) async{
      await _createExpense(event.expense, emit);
    });
  }
  _createExpense(Expense expense,Emitter emit) async{
    emit(CreateExpenseLoading());
    try {
      await repository.createExpense(expense);
      emit(CreateExpenseSuccess());
    } catch (e) {
      emit(CreateExpenseFailure());
    }
  }
}
