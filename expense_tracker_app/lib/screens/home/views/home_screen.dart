import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_app/mycolors.dart';
import 'package:expense_tracker_app/screens/add_expenses/blocs/bloc/get_expense_bloc.dart';
import 'package:expense_tracker_app/screens/add_expenses/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:expense_tracker_app/screens/add_expenses/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:expense_tracker_app/screens/add_expenses/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:expense_tracker_app/screens/add_expenses/views/add_expenses.dart';
import 'package:expense_tracker_app/screens/home/views/main_screen.dart';
import 'package:expense_tracker_app/screens/stats/stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpenseBloc, GetExpenseState>(
      builder: (context, state) {
        if(state is GetExpenseSuccess){
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            child: BottomNavigationBar(
                onTap: (value) {
                  setState(() {
                    index = value;
                  });
                },
                backgroundColor: Colors.white,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 3,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        size: 30,
                        color:
                            index == 0 ? Color(MY_BLUE) : Colors.grey.shade500,
                      ),
                      label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart,
                          size: 30,
                          color: index == 1
                              ? Color(MY_BLUE)
                              : Colors.grey.shade500),
                      label: 'Stats')
                ]),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Expense? newExpense = await Navigator.push(
                  context,
                  MaterialPageRoute<Expense>(
                    builder: (BuildContext context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              CreateCategoryBloc(FirebaseExpenseRepo()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              GetCategoriesBloc(FirebaseExpenseRepo())
                                ..add(GetCategories()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              CreateExpenseBloc(FirebaseExpenseRepo()),
                        )
                      ],
                      child: AddExpenses(),
                    ),
                  )
                );
              if (newExpense != null) {
                setState(() {
                  state.expenses.add(newExpense);
                });
                
              }
            },
            shape: CircleBorder(),
            child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.tertiary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary,
                    ], transform: GradientRotation(pi / 4))),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          ),
          body: index == 0 ? MainScreen(state.expenses) : StatScreen(),
        );
      }else {
        return Scaffold(body: Center(child: CircularProgressIndicator(),));
      } 
      }
    );
  }
}
