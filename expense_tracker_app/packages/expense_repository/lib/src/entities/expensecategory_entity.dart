

class ExpenseCategoryEntity{
  String categoryId;
  String name;
  String icon;
  int color;

  ExpenseCategoryEntity({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.color,
  });
  //send data
  Map<String, Object?> toDocument(){
    return {
      'categoryId': categoryId,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }
  //get data
  static ExpenseCategoryEntity fromDocument(Map<String,dynamic> doc){
    return ExpenseCategoryEntity(
      categoryId: doc['categoryId'],
      name: doc['name'],
      icon: doc['icon'],
      color: doc['color'],
    );
  }
}