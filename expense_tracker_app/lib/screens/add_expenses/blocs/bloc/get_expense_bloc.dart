import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'get_expense_event.dart';
part 'get_expense_state.dart';

class GetExpenseBloc extends Bloc<GetExpense, GetExpenseState> {
  ExpenseRepository repository;
  GetExpenseBloc(this.repository) : super(GetExpenseInitial()) {
    on<GetExpense>((event, emit) async{
      await _getExpense(emit);
    });
  }
  _getExpense(Emitter emit) async{
    emit(GetExpenseLoading());
    try {
      List<Expense> expenses = await repository.getListExpense();
      emit(GetExpenseSuccess(expenses));
    } catch (e) {
      emit(GetExpenseFailure());
    }
  }
}
