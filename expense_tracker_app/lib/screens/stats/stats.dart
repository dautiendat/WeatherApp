import 'dart:math';

import 'package:expense_tracker_app/data/data.dart';
import 'package:expense_tracker_app/screens/home/views/home_screen.dart';
import 'package:expense_tracker_app/screens/stats/chart.dart';
import 'package:flutter/material.dart';

class StatScreen extends StatelessWidget {
  const StatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const HomeScreen(),
              )
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
              ),
              Icon(
                Icons.arrow_circle_left,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
      title: Text(
        'Transactions',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          _incomeAndExpensesWidged(context),
          SizedBox(
            height: 12,
          ),
          //biểu đồ
          _statsScreenExpenses(context),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sat, 20 March 2021',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.outline,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '-\$500.00',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: myTransactionsData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
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
                                        color: myTransactionsData[index]
                                            ['color'],
                                        shape: BoxShape.circle)),
                                myTransactionsData[index]['icon'],
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              myTransactionsData[index]['name'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          myTransactionsData[index]['totalAmount'],
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ))
        ],
      ),
    ),
        );
  }

  Container _statsScreenExpenses(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            Text(
              '01 Jan 2024 - 01 April 2024',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            Text(
              '\$3500.00',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 12,
            ),
            Expanded(child: MyChart()),
          ],
        ),
      ),
    );
  }

  Container _incomeAndExpensesWidged(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            //income
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.tertiary,
                ], transform: GradientRotation(pi / 4)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  'Income',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ),
            ),
            //expenses
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.tertiary,
                ], transform: GradientRotation(pi / 4)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  'Expenses',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
