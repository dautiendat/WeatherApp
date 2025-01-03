import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'create_category_event.dart';
part 'create_category_state.dart';

class CreateCategoryBloc extends Bloc<CreateCategory, CreateCategoryState> {
  //dùng để tham chiếu tới FirebaseExpenseRepo 
  final ExpenseRepository repository;
  CreateCategoryBloc(this.repository) : super(CreateCategoryInitial()) {
    on<CreateCategory>((event, emit) async{
      await _createCategory(event.category, emit);
    });
  }

  Future<void>_createCategory(ExpenseCategory category, Emitter emit) async{
    emit(CreateCategoryLoading());
    try {
      await repository.createCategory(category);
      emit(CreateCategorySuccess());
    } catch (e) {
      emit(CreateCategoryFailure());
    }
  }
}
