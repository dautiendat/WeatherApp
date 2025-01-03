import 'package:expense_repository/expense_repository.dart';

class Expense{
  String expenseId;
  ExpenseCategory category;
  int totalAmount;
  DateTime dateTime;

  Expense({
    required this.expenseId,
    required this.category,
    required this.totalAmount,
    required this.dateTime
  });

  static final empty = Expense(
    expenseId: '', 
    category: ExpenseCategory.empty, 
    totalAmount: 0,
    dateTime: DateTime.now()
  );

  ExpenseEntity toEntity (){
    return ExpenseEntity(
      expenseId: expenseId,
      category: category,
      totalAmount: totalAmount,
      dateTime:dateTime,
    );
  }
  static Expense fromEntity(ExpenseEntity entity){
    return Expense(
      expenseId: entity.expenseId, 
      category: entity.category, 
      totalAmount: entity.totalAmount,
      dateTime:entity.dateTime,
    );
  }
}