import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map<String, dynamic>> myTransactionsData = [
  {
    'icon': FaIcon(
      FontAwesomeIcons.burger,
      color: Colors.white,
    ),
    'name': 'Food',
    'totalAmount': '-\$20.00',
    'color': Colors.yellow,
    'date': 'Today'
  },
  {
    'icon': FaIcon(FontAwesomeIcons.bagShopping, color: Colors.white),
    'name': 'Shopping',
    'totalAmount': '-\$150.00',
    'color': Colors.purpleAccent,
    'date': 'Today'
  },
  {
    'icon': FaIcon(FontAwesomeIcons.gamepad, color: Colors.white),
    'name': 'Entertainment',
    'totalAmount': '-\$60.00',
    'color': Colors.red,
    'date': 'Yesterday'
  },
  {
    'icon': FaIcon(FontAwesomeIcons.plane, color: Colors.white),
    'name': 'Travel',
    'totalAmount': '-\$250.00',
    'color': Colors.green,
    'date': 'Yesteday'
  },
  {
    'icon': FaIcon(FontAwesomeIcons.bagShopping, color: Colors.white),
    'name': 'Shopping',
    'totalAmount': '-\$300.00',
    'color': Colors.purpleAccent,
    'date': '02/20/2024'
  }
];
