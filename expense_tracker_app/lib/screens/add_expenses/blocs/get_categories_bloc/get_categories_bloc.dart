import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'get_categories_event.dart';
part 'get_categories_state.dart';

class GetCategoriesBloc extends Bloc<GetCategories, GetCategoriesState> {
  ExpenseRepository repository;
  GetCategoriesBloc(this.repository) : super(GetCategoriesInitial()) {
    on<GetCategories>((event, emit) async{
      await _getCategories(emit);
    });
  }
  _getCategories(Emitter emit)async{
    emit(GetCategoriesLoading());
    try {
      List<ExpenseCategory> categories = await repository.getListCategory();
      emit(GetCategoriesSuccess(categories));
    } catch (e) {
      emit(GetCategoriesFailure());
    }
  }
}
