import 'dart:developer';
import 'package:expense_repository/expense_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FirebaseExpenseRepo implements ExpenseRepository {
  final categoryCollection = FirebaseFirestore.instance.collection('categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');

  @override
  Future<void> createCategory(ExpenseCategory category) async {
    try {
      await categoryCollection
          .doc(category.categoryId)
          .set(category.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ExpenseCategory>> getListCategory() async {
    try {
      return await categoryCollection
        .get()
        .then((value) => value.docs.map((data) => 
        ExpenseCategory.fromEntity(
          ExpenseCategoryEntity.fromDocument(data.data())))
          .toList());
        
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  
  @override
  Future<void> createExpense(Expense expense) async{
    try {
      await expenseCollection
        .doc(expense.expenseId)
        .set(expense.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  
  @override
  Future<List<Expense>> getListExpense() async{
    try {
      return await expenseCollection
        .get()
        .then((value) => value.docs.map((data) => 
          Expense.fromEntity(
            ExpenseEntity.fromDocument(data.data()))).toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
