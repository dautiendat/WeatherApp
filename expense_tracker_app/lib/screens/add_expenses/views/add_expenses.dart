import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_app/mycolors.dart';
import 'package:expense_tracker_app/screens/add_expenses/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:expense_tracker_app/screens/add_expenses/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:expense_tracker_app/screens/add_expenses/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddExpenses extends StatefulWidget {
  const AddExpenses({super.key});

  @override
  State<AddExpenses> createState() => _AddExpensesState();
}

class _AddExpensesState extends State<AddExpenses> {
  //bắt sự kiện cho các textformfield
  final TextEditingController _expenseController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  //định dạng ngày => Sat, 23 March 2024
  String formatted = 'EEE, dd MMMM yyyy';

  //list name icon
  List<String> icons = ['burger', 'plane', 'shopping', 'dog'];

  //tạo mới 1 expense
  late Expense expense;

  //tạo biến loading cho toàn bộ màn hình add expense
  bool isLoading = false;

  @override
  void initState() {
    expense = Expense.empty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseSuccess) {
          Navigator.pop(context);
        } else if (state is CreateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Add Expense',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 16,
              ),
              _inputMoney(context),
              SizedBox(
                height: 32,
              ),
              _inputCategory(),
              SizedBox(
                height: 16,
              ),
              _inputDate(context),
              SizedBox(
                height: 20,
              ),
              _saveButton(context)
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _inputMoney(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: TextFormField(
        controller: _expenseController,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
            focusColor: Color(MY_BLUE),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(
              FontAwesomeIcons.dollarSign,
              size: 16,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none)),
      ),
    );
  }

  TextFormField _inputDate(BuildContext context) {
    return TextFormField(
      onTap: () async {
        //lấy ngày cuối cùng của năm tiếp theo
        final DateTime lastDateOfNextYear =
            DateTime(expense.dateTime.year + 1, 12, 31);
        DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: expense.dateTime,
            firstDate: DateTime.now(),
            lastDate: lastDateOfNextYear);
        if (selectedDate != null) {
          setState(() {
            _dateController.text = DateFormat(formatted).format(selectedDate);
            expense.dateTime = selectedDate;
          });
        }
      },
      controller: _dateController,
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          focusColor: Color(MY_BLUE),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(
            FontAwesomeIcons.calendarDay,
            size: 16,
            color: Colors.grey,
          ),
          hintText: DateFormat(formatted).format(expense.dateTime),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none)),
    );
  }

  Widget _inputCategory() {
    return BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
        builder: (context, state) {
      if (state is GetCategoriesSuccess) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              readOnly: true,
              onTap: () async {
                //newCategory để lấy category được tạo mới ở dialog _showMyDialog()
                var newCategory = await showDialog(
                  context: context,
                  builder: (context) {
                    return _showMyDialog();
                  },
                );
                setState(() {
                  //thêm catrgory mới vào đầu danh sách
                  state.categories.insert(0, newCategory);
                  expense.category = newCategory;
                });
              },
              decoration: InputDecoration(
                  filled: true,
                  fillColor: expense.category.color == MY_WHITE
                      ? Colors.white
                      : Color(expense.category.color),
                  prefixIcon: expense.category.icon == ''
                      ? Icon(
                          FontAwesomeIcons.list,
                          size: 16,
                          color: Colors.grey,
                        )
                      : Image.asset(
                          'assets/images/${expense.category.icon}.png',
                          scale: 1.5,
                          color: Colors.white,
                        ),
                  suffixIcon: Icon(
                    FontAwesomeIcons.plus,
                    size: 16,
                  ),
                  hintText: expense.category.name != ''
                      ? expense.category.name
                      : 'Category',
                  hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      borderSide: BorderSide.none)),
            ),
            Container(
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                expense.category = state.categories[index];
                              });
                            },
                            leading: Image.asset(
                              'assets/images/${state.categories[index].icon}.png',
                              scale: 1.5,
                              color: Colors.white,
                            ),
                            title: Text(
                              state.categories[index].name,
                              style: TextStyle(
                                color: state.categories[index].color == MY_WHITE
                                    ? Colors.black
                                    : Color(MY_WHITE),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            tileColor: Color(state.categories[index].color),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      );
                    },
                  ),
                ))
          ],
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }

  Widget _saveButton(BuildContext context) {
    return isLoading
    ? Center(child: CircularProgressIndicator(),)
    :Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.tertiary,
          ], transform: GradientRotation(pi / 4)),
          borderRadius: BorderRadius.circular(12)),
      child: BlocBuilder<CreateCategoryBloc, CreateCategoryState>(
        builder: (context, state) {
          return isLoading
              ? Center(child: CircularProgressIndicator())
              : TextButton(
                  onPressed: () {
                    setState(() {
                      expense.totalAmount =
                          int.parse(_expenseController.text);
                    });
                    // tạo expense mới
                    expense.expenseId = Uuid().v4();
                    context
                        .read<CreateExpenseBloc>()
                        .add(CreateExpense(expense));
                    Navigator.pop(context,expense);
                  },
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
                  child: Text(
                    'SAVE',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
        },
      ),
    );
  }

  //==================================================================
  //==================================================================
  //==================================================================
  //==================================================================
  //==================================================================
  //create category
  Widget _showMyDialog() {
    TextEditingController nameController = TextEditingController();
    bool isExpanded = false;
    int colorSelected = MY_WHITE;
    String iconSelected = '';
    bool isLoading = false;
    ExpenseCategory category = ExpenseCategory.empty;
    //context khác
    return StatefulBuilder(
      builder: (contxt, setState) {
        return AlertDialog(
          title: Text('Create a new Category'),
          content: BlocProvider.value(
            value: context.read<CreateCategoryBloc>(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  controller: nameController,
                  decoration: InputDecoration(
                      focusColor: Color(MY_BLUE),
                      filled: true,
                      isDense: true,
                      hintText: 'Name',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none)),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  readOnly: true,
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  decoration: InputDecoration(
                      focusColor: Color(MY_BLUE),
                      filled: true,
                      isDense: true,
                      hintText: 'Icon',
                      suffixIcon: isExpanded
                          ? Icon(FontAwesomeIcons.chevronUp)
                          : Icon(FontAwesomeIcons.chevronDown),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: isExpanded
                              ? BorderRadius.vertical(top: Radius.circular(12))
                              : BorderRadius.circular(12),
                          borderSide: BorderSide.none)),
                ),
                isExpanded
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(12))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
                            itemCount: icons.length,
                            itemBuilder: (context, index) {
                              //click icon
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    iconSelected = icons[index];
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          width: 2,
                                          color: iconSelected == icons[index]
                                              ? Color(MY_BLUE)
                                              : Colors.grey),
                                      image: DecorationImage(
                                          image: AssetImage(
                                        'assets/images/${icons[index]}.png',
                                      ))),
                                ),
                              );
                            },
                          ),
                        ))
                    : Container(),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  readOnly: true,
                  onTap: () {
                    //show color picker
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        //cấp lại context
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ColorPicker(
                                pickerColor: Color(colorSelected),
                                onColorChanged: (value) {
                                  setState(() {
                                    // cast string to int
                                    colorSelected =
                                        ((value.a * 255).toInt() << 24) |
                                            ((value.r * 255).toInt() << 16) |
                                            ((value.g * 255).toInt() << 8) |
                                            (value.b * 255).toInt();
                                  });
                                },
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                      Theme.of(context).colorScheme.tertiary,
                                    ], transform: GradientRotation(pi / 4)),
                                    borderRadius: BorderRadius.circular(12)),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                                  child: Text(
                                    'SAVE COLOR',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  decoration: InputDecoration(
                      focusColor: Color(MY_BLUE),
                      filled: true,
                      hintText: 'Color',
                      hintStyle: TextStyle(
                          color: colorSelected == MY_WHITE
                              ? Colors.black
                              : Colors.white),
                      isDense: true,
                      fillColor: Color(colorSelected),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none)),
                ),
                SizedBox(
                  height: 12,
                ),
                //lắng nghe nếu create category thành công
                //==> pop category sang cho màn hình cũ (màn hình add expense)
                BlocListener<CreateCategoryBloc, CreateCategoryState>(
                  listener: (context, state) {
                    if (state is CreateCategorySuccess) {
                      Navigator.pop(context, category);
                    } else if (state is CreateCategoryLoading) {
                      setState(() => isLoading = true);
                    }
                  },
                  child: isLoading == false
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.tertiary,
                              ], transform: GradientRotation(pi / 4)),
                              borderRadius: BorderRadius.circular(12)),
                          child: TextButton(
                            onPressed: () {
                              category.categoryId = Uuid().v1();
                              category.name = nameController.text;
                              category.icon = iconSelected;
                              category.color = colorSelected;
                              context
                                  .read<CreateCategoryBloc>()
                                  .add(CreateCategory(category));
                            },
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                            child: Text(
                              'SAVE',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //==================================================================
  //==================================================================
  //==================================================================
  //==================================================================
  //==================================================================
}
