import 'package:expense_tracker/data/hive_database.dart';
import 'package:expense_tracker/datetime/date_time_helper.dart';
import 'package:expense_tracker/models/expense.item.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  // list of all expenses
  List<ExpenseItem> overallExpenseList = [];

  //get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

  //prepre data to display
  //first get database object
  final db = HiveDatabase();
  //then load data
  void prepareData() {
   //if there is data , load it
   if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData();
     
   }
  }

  //add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);

    notifyListeners();
    //save to database
    db.saveData(overallExpenseList);
  }

  //delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);

    notifyListeners();
    //save to database
    db.saveData(overallExpenseList);
  }

  //get weekday from dateTime object
  String getWeekDay(DateTime day) {
    switch (day.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // get date for statrt of week (sunday)

  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    //get todays date
    DateTime today = DateTime.now();

    //go back to the start of the week (sunday)
    for (int i = 0; i < 7; i++) {
      if (getWeekDay(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  /*

  convert overall list of expense into a daily expense summary

  e.g.

  overallExpenseList =

  [
   [food, 2025/01/01,R20],
    [transport, 2025/01/01,R30],
    [clothes, 2025/01/02,R50],
    [entertainment, 2025/01/03,R100],
    [food, 2025/01/03,R20],
  ]



  converted to dailyExpenseSummary =

  [
    [2025/01/01, R50],
    [2025/01/02, R50],
    [2025/01/03, R120],
    [2025/01/04, R0],
    [2025/01/05, R0],
    [2025/01/06, R0],
    [2025/01/07, R0],
  ]

  */

  Map<String, double> calculateExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      //date (yyyymmdd) : total amount for that day
    };

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.date);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        //if date already exists, add amount to existing amount
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      }else{
        //if date does not exist, add new date and amount
        dailyExpenseSummary.addAll({date: amount});
      }
    }

    return dailyExpenseSummary;
  }
}
