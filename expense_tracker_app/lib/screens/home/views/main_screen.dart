import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatelessWidget {
  final List<Expense> expenses;
  const MainScreen(this.expenses,{super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _userWidget(context),
                //icon setting
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.settings,
                          color: Colors.grey,
                        )),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            //widget total balance
            _creditCardWidget(context),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'View all',
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _listViewTransactions()
          ],
        ),
      ),
    ));
  }

  Widget _listViewTransactions() {
    //định dạng ngày => Sat, 23 March 2024
    String formatted = 'EEE, dd MMMM yyyy';
        return Expanded(
            child: ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Color(expenses[index].category.color),
                                    shape: BoxShape.circle),
                              ),
                              Image.asset(
                                'assets/images/${expenses[index].category.icon}.png',
                                scale: 2,
                                color: Colors.white,
                              )
                            ],
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            expenses[index].category.name,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${expenses[index].totalAmount}.00',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            DateFormat(formatted).format(expenses[index].dateTime),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.outline,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      );
    }
  }

  Container _creditCardWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
                blurRadius: 4,
                color: Colors.grey.shade300,
                offset: Offset(5, 5))
          ],
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
            transform: GradientRotation(pi / 4),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            '\$ 4800.00',
            style: TextStyle(
                fontSize: 40, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _inCome(),
                _expense(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Row _userWidget(BuildContext context) {
    return Row(
      children: [
        //avatar
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow[700],
              ),
            ),
            Icon(
              Icons.person,
              color: Colors.yellow[800],
            )
          ],
        ),
        SizedBox(
          width: 8,
        ),
        //chào user
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              'Username, ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }

  Row _expense() {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration:
              BoxDecoration(color: Colors.white30, shape: BoxShape.circle),
          child: Icon(
            Icons.arrow_upward_rounded,
            color: Colors.red,
            size: 18,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expenses',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            Text(
              '\$ 800.00',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Row _inCome() {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration:
              BoxDecoration(color: Colors.white30, shape: BoxShape.circle),
          child: Icon(
            Icons.arrow_downward_rounded,
            color: Colors.greenAccent,
            size: 18,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Income',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
            Text(
              '\$ 4800.00',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

