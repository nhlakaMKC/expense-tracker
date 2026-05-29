import 'package:expense_tracker/models/expense.item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  //reference the hive box

  final _myBox = Hive.box('expense_database2');

  //write data
  void saveData(List<ExpenseItem> allExpense) {
    /*
    Hive can only store basic data types, Strins,int,double, dateTime etc
    we cannot store custom objects directly like the expenseItem object
    so lets  convert the ExpenseItem object in to a basic data type first

    allExpense is a list of expenseItem objects

    allExpense =
    [
    ExpenseItem (name / amount / dateTime),
    ...
    ]

    -> we will convert it to a list of maps

    [
    [name, amount, dateTime],
    ...]
     */

    List<List<dynamic>> allExpensesFormated = [];

    for (var expense in allExpense) {
      //convert each expense item object to a list of storable data types (string, double, dateTime)
      List<dynamic> expenseFormated = [
        expense.name,
        expense.amount,
        expense.date,
      ];
      //add the formatted expense item to the list of all expenses
      allExpensesFormated.add(expenseFormated);
    }
    //save the list of formatted expenses to hive
    _myBox.put('ALL_EXPENSE', allExpensesFormated);
  }

  //read data
  List<ExpenseItem> readData() {
    /*
    Data is stored in hive as a list of strings + dateTime
    we need to convert it back to a list of expenseItem objects

    savedData =
    [
    [name, amount, dateTime],
    ...
    ]
    -> we will convert it to a list of expenseItem objects

    [
    ExpenseItem (name / amount / dateTime),
    ... 
    ]
     */

    List savedExpenses = _myBox.get('ALL_EXPENSE') ?? [];
    List<ExpenseItem> allExpenses = [];

    for (int i = 0; i < savedExpenses.length; i++) {
      //collect each saved expense
      String name = savedExpenses[i][0];
      String amount = savedExpenses[i][1];
      DateTime dateTime = savedExpenses[i][2];

      //create expenseItem object
      ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        date: dateTime,
      );

      //add expense to ovarall expense list 
      allExpenses.add(expense);
    }
    return allExpenses;
  }
}
