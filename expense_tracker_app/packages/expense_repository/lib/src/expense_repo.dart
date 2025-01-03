
import '../expense_repository.dart';

abstract class ExpenseRepository {

  Future<void> createCategory(ExpenseCategory category);
  Future<void> createExpense(Expense expense);
  
  Future<List<ExpenseCategory>> getListCategory();
  Future<List<Expense>> getListExpense();
}