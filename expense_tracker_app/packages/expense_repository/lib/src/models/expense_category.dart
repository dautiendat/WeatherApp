import '../entities/entities.dart';
//use for app
class ExpenseCategory{
  String categoryId;
  String name;
  String icon;
  int color;

  ExpenseCategory({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.color,
  });

  static final empty = ExpenseCategory(
    categoryId: '',
    name: '',
    icon: '',
    color: 0xFFFFFFFF,
  );
  //transform Category into CategoryEntity to send to Firebase
  ExpenseCategoryEntity toEntity(){
    return ExpenseCategoryEntity(
      categoryId: categoryId,
      name: name,
      icon: icon,
      color: color,
    );
  }
  //transform CategoryEntity that takes from Firebase into Category
  static ExpenseCategory fromEntity (ExpenseCategoryEntity entity){
    return ExpenseCategory(
      categoryId: entity.categoryId,
      name: entity.name,
      icon: entity.icon,
      color: entity.color,
    );
  }
}