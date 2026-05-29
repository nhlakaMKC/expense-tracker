import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main()async {
  //initialize hive
  await Hive.initFlutter();

  //open a box
  await Hive.openBox('expense_database2');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseData(),
      builder:(context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        home: const HomePage(),
      ),
    );
  }
}
