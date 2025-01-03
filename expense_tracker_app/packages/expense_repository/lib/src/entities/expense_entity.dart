import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';

class ExpenseEntity{
  String expenseId;
  ExpenseCategory category;
  int totalAmount;
  DateTime dateTime;

  ExpenseEntity({
    required this.expenseId,
    required this.category,
    required this.totalAmount,
    required this.dateTime,
  });

  Map<String,Object?> toDocument(){
    return {
      'expenseId': expenseId,
      //chuyển category thành map
      'category': category.toEntity().toDocument(),
      'totalAmount': totalAmount,
      'dateTime': dateTime,
    };
  }

  static ExpenseEntity fromDocument(Map<String,dynamic> doc){
    return ExpenseEntity(
      expenseId: doc['expenseId'], 
      category: ExpenseCategory.fromEntity(ExpenseCategoryEntity.fromDocument(doc['category'])), 
      totalAmount: doc['totalAmount'],
      //bỏ thời gian sau date
      dateTime: (doc['dateTime'] as Timestamp).toDate(),
    );
  }
}