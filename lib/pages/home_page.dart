import 'dart:ffi';

import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/components/expents_tile.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/models/expense.item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //text field controllers
  final expenseNameController = TextEditingController();
  final expenseAmountController = TextEditingController();

  //prepare data for display on app start
  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  //add new expense
  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //expense name
            TextField(
              controller: expenseNameController,
              decoration: const InputDecoration(hintText: 'Expense name'),
            ),

            //expense amount
            TextField(
              controller: expenseAmountController,
              decoration: const InputDecoration(hintText: 'Expense amount'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          //save button
          MaterialButton(onPressed: save, child: const Text('Save')),

          //cancel button
          MaterialButton(onPressed: cancel, child: const Text('Cancel')),
        ],
      ),
    );
  }

  //delete expense
  void  deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  //save new expense
  void save() {
    // only save if text fields are not empty
    if (expenseNameController.text.isNotEmpty && expenseAmountController.text.isNotEmpty) {
      //create expense item
    ExpenseItem newExpense = ExpenseItem(
      name: expenseNameController.text,
      amount: expenseAmountController.text,
      date: DateTime.now(),
    );
    //add expense to list of expenses
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    }
    //close dialog after saving
    Navigator.pop(context);

    //clear text fields
    clear();
  }

  //cancel

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  //clear controller
  void clear() {
    expenseNameController.clear();
    expenseAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          backgroundColor: Colors.black,
          child: Icon(Icons.add, color: Colors.grey[300]),
        ),

        body: ListView(
          children: [
            //weekly summary chart 
            ExpenseSummary(
              startOfweek: value.startOfWeekDate(),
            ),

            const SizedBox(height: 20),

            //list of expenses
            ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: value.getAllExpenseList().length,
          itemBuilder: (context, index) => ExpenseTile(
            name: value.getAllExpenseList()[index].name,
            amount: value.getAllExpenseList()[index].amount,
            date: value.getAllExpenseList()[index].date,
            deleteTapped: (p0) => deleteExpense(value.getAllExpenseList()[index]),
          ),
        ),
          ],
        )
      ),
    );
  }
}
