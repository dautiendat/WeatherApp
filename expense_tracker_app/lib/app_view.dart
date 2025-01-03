import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker_app/mycolors.dart';
import 'package:expense_tracker_app/screens/add_expenses/blocs/bloc/get_expense_bloc.dart';
import 'package:expense_tracker_app/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              primary: Color(MY_BLUE),
              secondary: Color(MY_PURPLE),
              tertiary: Color(MY_ORANGE),
              outline: Colors.grey,
              secondaryContainer: Colors.black),
          useMaterial3: true),
      home: BlocProvider(
        create: (context) => 
        GetExpenseBloc(FirebaseExpenseRepo())..add(GetExpense()),
        child: HomeScreen(),
      )
    );
  }
}
